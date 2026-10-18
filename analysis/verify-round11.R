source('R/presentation.R')
bad <- '(?i:(?<![A-Za-z0-9_])(rob2kit|rob2-kit|rob2-assess|no-kit|nokit|kit|meta label)(?![A-Za-z0-9_]))|\\bBaseline\\b|Adjudicator [AZ]\\b|departed from Published'
scan_text <- function(txt,path) {
  hits <- grepl(bad,txt,perl=TRUE)
  if(any(hits)) stop('Prohibited text in ',path,': ',paste(txt[hits],collapse='\n'))
}
for(p in list.files('output/manuscript',pattern='[.]docx$',full.names=TRUE)) {
  doc <- officer::read_docx(p); summary <- officer::docx_summary(doc)
  scan_text(summary$text,p)
  writeLines(trimws(summary$text,which='right'),paste0('output/manuscript/qa/',basename(p),'.txt'))
  tmp <- tempfile(); dir.create(tmp); unzip(p,files='word/document.xml',exdir=tmp)
  xml <- xml2::read_xml(file.path(tmp,'word/document.xml')); ns <- xml2::xml_ns(xml)
  tables <- xml2::xml_find_all(xml,'//w:tbl',ns)
  stopifnot(length(tables)>=1)
  for(tbl in tables) {
    sizes <- xml2::xml_attr(xml2::xml_find_all(tbl,'.//w:sz',ns),'val')
    fonts <- xml2::xml_attr(xml2::xml_find_all(tbl,'.//w:rFonts',ns),'ascii')
    stopifnot(all(sizes=='18'),all(fonts=='Arial'))
  }
  cat(basename(p),length(tables),'editable tables, Arial 9 pt; text clean\n')
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
  html <- xml2::read_html(p)
  xml2::xml_remove(xml2::xml_find_all(html,'//script|//style'))
  scan_text(xml2::xml_text(xml2::xml_find_first(html,'//body')),p)
  cat(p,'reader text clean\n')
}
scan_text(readLines('output/manuscript/figure-legends.md',warn=FALSE,encoding='UTF-8'),'legends')
html <- xml2::read_html('results.html')
heads <- xml2::xml_text(xml2::xml_find_all(html,'//main//h2'))
stopifnot(all(mapply(function(p,x) grepl(p,x,fixed=TRUE),paste0('Figure ',1:6),heads[1:6])))
stopifnot(all(mapply(function(p,x) grepl(p,x,fixed=TRUE),paste0('Table ',1:4),heads[7:10])))
# All legacy statistics stay frozen; the mislabeled old matrix CSV is replaced.
changed <- system2('git',c('diff','--name-only','9792c55','--','output/tables'),stdout=TRUE)
allowed <- paste0('analysis/output/tables/',c('figure3-panelB.csv','efigure2-disagreement-patterns.csv','no-decisive-counts.csv','published-direction-domain.csv','severity-win-share.csv','vindicated-disagreements.csv'))
stopifnot(setequal(changed,allowed))
protected <- system2('git',c('diff','--name-only','9792c55','--','figure1','output/manuscript/Figure1.*','output/manuscript/Figure2.*','output/manuscript/legends-fig1-2.md'),stdout=TRUE)
stopifnot(length(protected)==0)
cat('Existing numerical results unchanged; legacy matrix relabelled; protected Figure 1/2 files unchanged\n')
source('R/load.R')
source('R/avatar-trace.R')
trace <- avatar_trace_blocks(load_inputs())
quotes <- unlist(lapply(trace,function(b) b$data[[2]][startsWith(b$data$Field,'Full quote')]))
normalise <- function(x) gsub('[[:space:]]','',x)
pdf <- normalise(paste(pdftools::pdf_text('output/manuscript/qa/Supplement-word.pdf'),collapse=''))
stopifnot(all(vapply(quotes,function(q) grepl(normalise(q),pdf,fixed=TRUE),logical(1))))
cat(length(quotes),'complete quote chunks verified in Word-rendered PDF\n')
