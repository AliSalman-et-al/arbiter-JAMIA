# Run after rendering: Rscript verify-round4.R <pre-round tables directory>
source('R/load.R')
source('R/process.R')
source('R/bootstrap.R')
source('R/agreement.R')
baseline <- commandArgs(trailingOnly=TRUE)[1]
stopifnot(!is.na(baseline),dir.exists(baseline))
files <- list.files('output/tables',pattern='[.]csv$')
stopifnot(setequal(files,list.files(baseline,pattern='[.]csv$')))
allowed <- c('figure1-draft-selection.csv','worked-trace-candidates.csv',
  'figure3-panelB.csv','table5.csv','table5-haiku.csv')
changed <- character()
for(f in files) {
  a <- readr::read_csv(file.path(baseline,f),show_col_types=FALSE)
  b <- readr::read_csv(file.path('output/tables',f),show_col_types=FALSE)
  # Compare column values, excluding readr's per-read problems external pointer.
  same <- function(a,b) identical(names(a),names(b)) &&
    identical(lapply(a,identity),lapply(b,identity))
  if(same(a,b)) next
  changed <- c(changed,f)
  stopifnot(f %in% allowed)
  if(f=='figure3-panelB.csv') {
    a$departure <- dplyr::recode(a$departure,'Baseline only'='Baseline only departed from meta',
      'Both, different labels'='Both departed, different labels','Both, same label'='Both departed, same label')
    stopifnot(same(a,b))
  }
}
# Reconstruct all displayed process statistics from the unchanged native-unit CSVs.
s <- readr::read_csv('output/tables/process-summary.csv',show_col_types=FALSE)
m <- load_run_metrics() |> rename(harness_cost_usd=cost_usd) |>
  left_join(readr::read_csv('data-derived/api-cost-trials.csv',show_col_types=FALSE) |>
    select(arm,slug,cost_usd=point),by=c('arm','slug'))
w <- stratified_cluster_weights(load_inputs()$trials,10000L,20261018L)
for(model in c('Sonnet','Haiku')) {
  f <- if(model=='Sonnet') 'table5.csv' else 'table5-haiku.csv'
  actual <- readr::read_csv(file.path('output/tables',f),show_col_types=FALSE)
  stopifnot(same(actual,process_display(m,w,model)))
}
# Every retained candidate value comes from the pre-existing evidence extraction.
e <- readr::read_csv('data-derived/bundle-trace-evidence.csv',show_col_types=FALSE)
for(f in c('worked-trace-candidates.csv','figure1-draft-selection.csv')) {
  x <- readr::read_csv(file.path('output/tables',f),show_col_types=FALSE)
  original <- e[match(paste(x$slug,x$domain,x$question,x$evidence_id),
    paste(e$slug,e$domain,e$question,e$evidence_id)),]
  for(n in setdiff(names(x),c('passage','passage_words'))) stopifnot(identical(x[[n]],original[[n]]))
  stopifnot(all(mapply(function(p,q) grepl(p,q,fixed=TRUE),x$passage,original$full_passage)))
}
cat(length(files),'CSVs compared;',length(files)-length(changed),'identical;',length(changed),'deliberate presentation changes:\n')
cat(paste(changed,collapse='\n'),'\nNumeric preservation checks passed.\n')
