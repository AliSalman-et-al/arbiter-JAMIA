source('R/presentation.R')
bad <- '(?i:(?<![A-Za-z0-9_])(rob2kit|rob2-kit|rob2-assess|no-kit|nokit|kit|meta label)(?![A-Za-z0-9_]))|\\bBaseline\\b|Adjudicator [AZ]\\b|departed from Published|\\bNot Low\\b|\\bdiscordant\\b|consensus preferred|\\b[Vv]indicated\\b|\\b[Dd]ecisive question'
scan_text <- function(txt,path) {
  hits <- grepl(bad,txt,perl=TRUE)
  if(any(hits)) stop('Prohibited text in ',path,': ',paste(txt[hits],collapse='\n'))
  codes <- raw_reader_codes(txt)
  if(length(codes)) stop('Raw internal codes in ',path,': ',paste(codes,collapse=', '))
}
for(p in list.files('output/manuscript',pattern='[.]docx$',full.names=TRUE)) {
  doc <- officer::read_docx(p); summary <- officer::docx_summary(doc)
  scan_text(summary$text,p)
  writeLines(trimws(summary$text,which='right'),paste0('output/manuscript/qa/',basename(p),'.txt'))
  tmp <- tempfile(); dir.create(tmp); unzip(p,files='word/document.xml',exdir=tmp)
  xml <- xml2::read_xml(file.path(tmp,'word/document.xml')); ns <- xml2::xml_ns(xml)
  tables <- xml2::xml_find_all(xml,'//w:tbl',ns)
  stopifnot(length(tables)>=1)
  for(i in seq_along(tables)) {
    tbl <- tables[[i]]
    sizes <- xml2::xml_attr(xml2::xml_find_all(tbl,'.//w:sz',ns),'val')
    fonts <- xml2::xml_attr(xml2::xml_find_all(tbl,'.//w:rFonts',ns),'ascii')
    stopifnot(all(sizes %in% if(basename(p)=='Supplement.docx' && i<=2L) '16' else '18'),all(fonts=='Arial'))
  }
  cat(basename(p),length(tables),'editable tables, Arial 9 pt (trace 8 pt); text clean\n')
}
for(name in c(paste0('Figure',3:6),'eFigure1','eFigure2')) {
  path <- paste0('output/manuscript/',name,'.pdf')
  scan_text(pdftools::pdf_text(path),path)
  fonts <- pdftools::pdf_fonts(path)
  stopifnot(all(fonts$embedded),all(grepl('FiraSans',fonts$name)))
  dat <- pdftools::pdf_data(path,font_info=TRUE)[[1]]
  stopifnot(min(dat$font_size)>=7-.01)
  size <- pdftools::pdf_pagesize(path)
  stopifnot(abs(size$width*25.4/72-174)<.1)
  tiff <- system2('magick',c('identify','-format',shQuote('%w %x %y %[units] %[compression]'),shQuote(paste0('output/manuscript/',name,'.tiff'))),stdout=TRUE)
  stopifnot(identical(tiff,'4110 600 600 PixelsPerInch LZW'))
  cat(name,': min text',min(dat$font_size),'pt, 174 mm, 600-dpi LZW; text clean\n')
}
for(p in c('results.html','supplement.html')) {
  scan_text(reader_html_text(p),p)
  cat(p,'reader text clean\n')
}
scan_text(readLines('output/manuscript/figure-legends.md',warn=FALSE,encoding='UTF-8'),'legends')
source('R/load.R')
source('R/manuscript-tables.R')
tables <- list(benchmark_table(load_inputs()),main_table2(),main_table3(),main_table4())
for(i in 1:4) {
  x <- tables[[i]]
  pages <- pdftools::pdf_data(paste0('output/manuscript/qa/Table',i,'-word.pdf'))
  stopifnot(length(pages)==1L)
  dat <- pages[[1]]
  dat$text <- gsub('\u2060','',dat$text,fixed=TRUE)
  dat <- dat[nzchar(dat$text),]
  # Word emits separate PDF glyph runs around joiners. Rejoin only adjacent
  # runs without a space on the same baseline; wrapped lines cannot coalesce.
  for(k in rev(seq_len(nrow(dat)-1L))) {
    if(!dat$space[k] && abs(dat$y[k]-dat$y[k+1L])<1 &&
       abs(dat$x[k+1L]-dat$x[k]-dat$width[k])<2) {
      dat$text[k] <- paste0(dat$text[k],dat$text[k+1L])
      dat$width[k] <- dat$x[k+1L]+dat$width[k+1L]-dat$x[k]
      dat$space[k] <- dat$space[k+1L]
      dat <- dat[-(k+1L),]
    }
  }
  # Table 1 topics are long free text; all labels, merged labels and values must fit.
  for(j in setdiff(seq_len(ncol(x)),if(i==1) 4L else integer())) for(value in unique(x[[j]][nzchar(x[[j]])])) {
    words <- strsplit(as.character(value),' ',fixed=TRUE)[[1]]
    starts <- which(dat$text==words[1])
    found <- any(vapply(starts,function(k) {
      rows <- k+seq_along(words)-1L
      max(rows)<=nrow(dat) && identical(dat$text[rows],words) && diff(range(dat$y[rows]))<1
    },logical(1)))
    if(!found) stop('Missing or wrapped Table ',i,' value: ',value)
  }
  scan_text(pdftools::pdf_text(paste0('output/manuscript/qa/Table',i,'-word.pdf')),paste('Word Table',i))
  cat('Table',i,': every label and non-free-text value stays on one line in native Word PDF\n')
}
scan_text(pdftools::pdf_text('output/manuscript/qa/Supplement-word.pdf'),'Word supplement PDF')
html <- xml2::read_html('results.html')
images <- xml2::xml_find_all(html,'//main//img')
stopifnot(length(images)==6L,all(nchar(xml2::xml_attr(images,'alt'))>100L))
for(i in seq_along(images)) {
  src <- xml2::xml_attr(images[[i]],'src')
  path <- paste0('output/manuscript/Figure',i,'.png')
  stopifnot(startsWith(src,'data:image/png;base64,'),identical(
    jsonlite::base64_dec(sub('^[^,]*,','',src)),readBin(path,'raw',file.info(path)$size)))
}
cat('All six HTML figures embed the current PNG bytes and have full alt text\n')
heads <- xml2::xml_text(xml2::xml_find_all(html,'//main//h2'))
stopifnot(all(mapply(function(p,x) grepl(p,x,fixed=TRUE),paste0('Figure ',1:6),heads[1:6])))
stopifnot(all(mapply(function(p,x) grepl(p,x,fixed=TRUE),paste0('Table ',1:4),heads[7:10])))
# Round 12 is presentation-only: all CSVs and protected artwork remain exact.
changed <- system2('git',c('diff','--name-only','48c7116','--','output/tables'),stdout=TRUE)
stopifnot(length(changed)==0L)
protected <- system2('git',c('diff','--name-only','48c7116','--','figure1','output/manuscript/Figure1.*','output/manuscript/Figure2.*','output/manuscript/legends-fig1-2.md','output/manuscript/figure1-notes.md'),stdout=TRUE)
stopifnot(length(protected)==0L)
cat('Statistical CSVs and protected Figure 1/2 files unchanged\n')
source('R/load.R')
source('R/avatar-trace.R')
trace <- avatar_trace_blocks(load_inputs())
quotes <- trace[[2]]$data$`Full verbatim quote`
normalise <- function(x) gsub('[[:space:]]','',x)
# Raw reading order preserves cell text. Remove only the repeated Part B header
# so evidence records spanning pages reconstruct as one complete quote.
pdf <- normalise(paste(pdftools::pdf_text('output/manuscript/qa/Supplement-word.pdf',raw=TRUE),collapse=''))
pdf <- gsub('HandleSourcePageLinesSource-versionhashFullverbatimquote','',pdf,fixed=TRUE)
stopifnot(all(vapply(quotes,function(q) grepl(normalise(q),pdf,fixed=TRUE),logical(1))))
cat(length(quotes),'complete distinct evidence quotes verified in Word-rendered PDF\n')

pages <- pdftools::pdf_text('output/manuscript/qa/Supplement-word.pdf')
trace_start <- grep('Part A. Answers and judgements',pages,fixed=TRUE)
stopifnot(length(trace_start)==1L)
page_sizes <- pdftools::pdf_pagesize('output/manuscript/qa/Supplement-word.pdf')
trace_end <- min(which(seq_along(pages)>trace_start & page_sizes$width<page_sizes$height))-1L
page_sizes <- pdftools::pdf_pagesize('output/manuscript/qa/Supplement-word.pdf')
stopifnot(all(page_sizes$width[trace_start:trace_end]>page_sizes$height[trace_start:trace_end]),
  trace_end-trace_start+1L<=12L,all(nzchar(trimws(pages))))
cat('Supplement:',length(pages),'pages; AVATAR eTable:',trace_end-trace_start+1L,
    'pages (',trace_start,'–',trace_end,')\n')
jsonlite::write_json(list(supplement_pages=length(pages),avatar_pages=trace_end-trace_start+1L,
  avatar_first_page=trace_start,avatar_last_page=trace_end,distinct_quotes=length(quotes)),
  'output/manuscript/qa/round12-pagination.json',auto_unbox=TRUE,pretty=TRUE)
