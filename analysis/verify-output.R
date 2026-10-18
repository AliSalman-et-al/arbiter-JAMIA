# Read-only checks of the artifacts produced by quarto render.
figures <- c('figure1','figure2','figure3','figure4','supplement-forest')
expected_width <- c(11,10,12,10,10)
expected_height <- c(9,8.5,9,5,10)
checks <- lapply(seq_along(figures),function(i) {
  path <- paste0('output/figures/',figures[i])
  png <- file(paste0(path,'.png'),'rb'); on.exit(close(png))
  stopifnot(identical(readBin(png,'raw',8),as.raw(c(137,80,78,71,13,10,26,10))))
  seek(png,16)
  size <- readBin(png,'integer',2,size=4,endian='big')
  stopifnot(all(size==600*c(expected_width[i],expected_height[i])))
  info <- pdftools::pdf_info(paste0(path,'.pdf'))
  stopifnot(info$pages==1L)
  data.frame(figure=figures[i],width_pixels=size[1],height_pixels=size[2],dpi=600,pdf_pages=info$pages)
})
for(f in c('table1','table2','table3','table4-reliability','primary-endpoint',
  'reporting-checklist-skeleton','algorithm-mismatches','process-summary','process-differences',
  'audit-summary','recorded-overrides','table5','table5-haiku','invalid-path-sensitivity',
  'worked-trace-candidates','baseline-justification-content')) stopifnot(file.exists(paste0('output/tables/',f,'.csv')))
stopifnot(file.exists('results.html'),file.exists('supplement.html'))
readr::write_csv(do.call(rbind,checks),'output/tables/artifact-verification.csv')
cat('Verified five one-page PDFs, five 600-dpi PNGs, both reports, and required tables.\n')
for(path in c('results.html','supplement.html')) {
  html <- paste(readLines(path,warn=FALSE,encoding='UTF-8'),collapse='\n')
  td <- regmatches(html,gregexpr('<td[^>]*>.*?</td>',html,perl=TRUE))[[1]]
  stopifnot(!any(grepl('[0-9][eE][+-][0-9]+',td)))
}
coding <- readr::read_csv('output/coding/coding-sheet.csv',show_col_types=FALSE)
stopifnot(all(is.na(coding$code_author1)),all(is.na(coding$code_author2)),all(is.na(coding$final_code)))
