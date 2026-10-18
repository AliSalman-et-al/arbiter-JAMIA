source('R/presentation.R')
baseline <- '44a29a82fcfb8319555594869e24c8dde90635be'
root <- normalizePath('..',winslash='/')
git <- function(args) {
  x <- system2('git',c('-C',shQuote(root),args),stdout=TRUE,stderr=FALSE)
  stopifnot(is.null(attr(x,'status'))); x
}
old <- strsplit(git(c('ls-tree','-r',baseline)),intToUtf8(9),fixed=TRUE)
old <- old[vapply(old,function(x) endsWith(x[2],'.csv'),logical(1))]
paths <- vapply(old,`[`,character(1),2)
hashes <- vapply(old,function(x) strsplit(x[1],' ',fixed=TRUE)[[1]][3],character(1))
current <- system2('git',c('-C',shQuote(root),'hash-object','--stdin-paths'),
  input=file.path(root,paths),stdout=TRUE,stderr=FALSE)
stopifnot(length(current)==length(hashes),identical(unname(current),unname(hashes)))
stopifnot(setequal(git(c('ls-files','--cached','--others','--exclude-standard','--','*.csv')),paths))
cat(sprintf('%d CSV files byte-identical (including Git newline normalisation) to %s\n',length(paths),baseline))
bad <- '(?i:(?<![A-Za-z0-9_])(rob2kit|rob2-kit|rob2-assess|no-kit|nokit|kit|meta label)(?![A-Za-z0-9_]))|\\bBaseline\\b|Adjudicator [AZ]\\b'
scan_text <- function(txt,path) {
  matches <- regmatches(txt,gregexpr(bad,txt,perl=TRUE))
  if(any(lengths(matches)>0)) { cat('Prohibited text in',path,'\n'); print(txt[lengths(matches)>0]) }
  stopifnot(!any(lengths(matches)>0))
  invisible(path)
}
for(p in list.files('output/manuscript',pattern='[.]docx$',full.names=TRUE)) {
  doc <- officer::read_docx(p)
  summary <- officer::docx_summary(doc)
  stopifnot(any(summary$content_type=='table cell'))
  scan_text(summary$text,p)
  writeLines(summary$text,paste0('output/manuscript/qa/',basename(p),'.txt'))
  # Tables retain Arial 9 pt as Word runs, not embedded images.
  tmp <- tempfile(); dir.create(tmp)
  unzip(p,files='word/document.xml',exdir=tmp)
  xml <- xml2::read_xml(file.path(tmp,'word/document.xml'))
  ns <- xml2::xml_ns(xml)
  tables <- xml2::xml_find_all(xml,'//w:tbl',ns)
  stopifnot(length(tables)>=1)
  for(tbl in tables) {
    sizes <- xml2::xml_attr(xml2::xml_find_all(tbl,'.//w:sz',ns),'val')
    fonts <- xml2::xml_attr(xml2::xml_find_all(tbl,'.//w:rFonts',ns),'ascii')
    stopifnot(all(sizes=='18'),all(fonts=='Arial'))
  }
  cat(basename(p),':',length(tables),'real Word table(s); text scan clean\n')
}
for(name in c(paste0('Figure',2:5),'eFigure1')) {
  path <- paste0('output/manuscript/',name,'.pdf')
  scan_text(pdftools::pdf_text(path),path)
  fonts <- pdftools::pdf_fonts(path)
  stopifnot(all(fonts$embedded),all(grepl('FiraSans',fonts$name)))
  dat <- pdftools::pdf_data(path,font_info=TRUE)[[1]]
  stopifnot(min(dat$font_size)>=7-0.01)
  size <- pdftools::pdf_pagesize(path)
  stopifnot(abs(size$width*25.4/72-174)<.1)
  tiff <- system2('magick',c('identify','-format',shQuote('%w %x %y %[units] %[compression]'),
    shQuote(paste0('output/manuscript/',name,'.tiff'))),stdout=TRUE)
  stopifnot(identical(tiff,'4110 600 600 PixelsPerInch LZW'))
  cat(name,': embedded Fira Sans; min text',min(dat$font_size),'pt; width 174 mm; 600-dpi LZW TIFF\n')
}
# Legacy Figure 1 report slot must stay byte-for-byte as assigned.
original <- system2('git',c('show',paste0(baseline,':analysis/results.qmd')),stdout=TRUE)
slot <- function(x) regmatches(x,regexpr('(?s)## Figure 1:.*?(?=## Figure 2)',x,perl=TRUE))
original_slot <- slot(paste(original,collapse='\n'))
new <- paste(readLines('results.qmd',encoding='UTF-8',warn=FALSE),collapse='\n')
stopifnot(identical(original_slot,slot(new)))
# Prohibited-name scan excludes that unchanged, separately-owned slot, including its figcaption.
html <- paste(readLines('results.html',encoding='UTF-8',warn=FALSE),collapse='\n')
html <- gsub('(?s)<section id="figure-1.*?(?=<section id="figure-2)', '',html,perl=TRUE)
html_text <- xml2::xml_text(xml2::read_html(html))
scan_text(html_text,'results.html (outside Figure 1 slot)')
scan_text(xml2::xml_text(xml2::read_html('supplement.html')),'supplement.html')
for(p in c('output/manuscript/figure-legends.md','output/figure-legends.md'))
  scan_text(readLines(p,warn=FALSE,encoding='UTF-8'),p)
cat('Reader-facing text scan clean; unchanged Figure 1 slot is explicitly excluded.\n')
