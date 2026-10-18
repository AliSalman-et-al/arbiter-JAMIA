source('R/presentation.R')
baseline <- '912f641c1f91f2e3b064ccc0f7704ac74c71fbdc'
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
bad <- '(?i:(?<![A-Za-z0-9_])(rob2kit|rob2-kit|rob2|rob2-assess|no-kit|nokit|kit|meta label)(?![A-Za-z0-9_]))|\\bBaseline\\b|Adjudicator [AZ]\\b'
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
# Full reader-facing scans include the merged Figure 1 working view.
for(p in c('results.html','supplement.html')) scan_text(xml2::xml_text(xml2::read_html(p)),p)
scan_text(readLines('output/manuscript/figure-legends.md',warn=FALSE,encoding='UTF-8'),'canonical legends')
scan_text(pdftools::pdf_text('output/manuscript/Figure1.pdf'),'Figure1.pdf')
svg <- paste(readLines('output/manuscript/Figure1.svg',warn=FALSE,encoding='UTF-8'),collapse='\n')
scan_text(svg,'Figure1.svg (including accessible text)')
stopifnot(!file.exists('output/figure-legends.md'),!file.exists('output/manuscript/Figure1.tif'))
for(name in paste0('Figure',1:5)) stopifnot(all(file.exists(paste0('output/manuscript/',name,c('.pdf','.png','.tiff')))))
meta <- readr::read_csv('data-curated/meta-analyses.csv',show_col_types=FALSE)
for(p in list.files('output/manuscript',pattern='[.]docx$',full.names=TRUE)) {
  txt <- officer::docx_summary(officer::read_docx(p))$text
  stopifnot(!any(grepl('\\b[a-z]+-[12][0-9]{3}\\b',txt,perl=TRUE)))
  for(id in meta$meta_id) stopifnot(!any(grepl(id,txt,fixed=TRUE)))
  stopifnot(!any(grepl('[a-z]+_[a-z]+',txt,perl=TRUE)))
}
cat('Complete Word, publication PDF/SVG, HTML and canonical legend scans clean.\n')

# Figure 1 content remains byte-identical, including the renamed TIFF.
for(ext in c('pdf','png','svg')) {
  path <- paste0('analysis/output/manuscript/Figure1.',ext)
  stopifnot(identical(git(c('rev-parse',paste0(baseline,':',path))),git(c('hash-object',path))))
}
stopifnot(identical(git(c('rev-parse',paste0(baseline,':analysis/output/manuscript/Figure1.tif'))),
  git(c('hash-object','analysis/output/manuscript/Figure1.tiff'))))
cat('Figure 1 PDF/PNG/SVG and renamed TIFF bytes unchanged.\n')

for(name in c(paste0('Table',1:4),'Supplement','TRIPOD-LLM')) {
  path <- paste0('output/manuscript/qa/',name,'-word.pdf')
  expected <- if(name=='Supplement') 40L else if(name=='TRIPOD-LLM') 2L else 1L
  stopifnot(pdftools::pdf_info(path)$pages==expected)
  sizes <- pdftools::pdf_pagesize(path); pages <- pdftools::pdf_data(path)
  for(i in seq_along(pages)) {
    d <- pages[[i]]
    stopifnot(all(d$x>=0),all(d$y>=0),all(d$x+d$width<=sizes$width[i]+1),all(d$y+d$height<=sizes$height[i]+1))
  }
  cat(name,':',expected,'pages; rendered text within page bounds.\n')
}
