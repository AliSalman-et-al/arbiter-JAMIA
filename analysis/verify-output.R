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
stopifnot(!length(list.files('output/coding')))
for(name in c('cells','counts','frequency','issues','eligibility'))
  stopifnot(file.exists(paste0('output/tables/error-localisation-',name,'.csv')))
stopifnot(file.exists('output/tables/discussion-quote-candidates.csv'))
new_png <- file('output/figures/supplement-decisive-questions.png','rb')
seek(new_png,16)
stopifnot(all(readBin(new_png,'integer',2,size=4,endian='big')==c(6000,3300)))
close(new_png)
stopifnot(pdftools::pdf_info('output/figures/supplement-decisive-questions.pdf')$pages==1L)
cost <- readr::read_csv('data-derived/api-cost-trials.csv',show_col_types=FALSE)
stopifnot(nrow(cost)==408L,all(cost$lower<=cost$point),all(cost$point<=cost$upper),
  all(cost$point[grepl('Sonnet',cost$arm)]==cost$lower[grepl('Sonnet',cost$arm)]),
  all(cost$point[grepl('Sonnet',cost$arm)]==cost$upper[grepl('Sonnet',cost$arm)]))
turns <- readr::read_csv('data-derived/api-cost-turns.csv',show_col_types=FALSE)
reconciliation <- readr::read_csv('output/tables/api-token-reconciliation.csv',show_col_types=FALSE)
for(a in reconciliation$arm) {
  t <- turns[turns$arm==a,]
  stopifnot(reconciliation$turns_with_side_calls[reconciliation$arm==a]==
    sum(t$side_input+t$side_write1+t$side_write5+t$side_read+t$side_output>0))
  for(component in c('input','write1','write5','read')) stopifnot(all(
    t[[paste0('request_',component)]]+t[[paste0('gap_',component)]]==t[[paste0('result_',component)]]))
}
