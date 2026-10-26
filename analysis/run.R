# One entry point. Run from analysis/; raw inputs are read-only.
source('R/load.R')
for(f in setdiff(list.files('R',pattern='[.]R$',full.names=TRUE),'R/load.R')) source(f)
SEED <- 20261018L
B <- 10000L
inputs <- load_inputs()
checks <- domain_checks(inputs)
validate_gate(checks)
weights <- stratified_cluster_weights(inputs$trials,B,SEED)
cells <- adjudication_cells(inputs)
dir.create('output/tables',recursive=TRUE,showWarnings=FALSE)
save_table <- function(x,name) {
  names(x)[names(x)=='kit'] <- 'ARBITER_label'
  names(x)[names(x)=='nokit'] <- 'Baseline_label'
  if('arm' %in% names(x)) x <- x[order(match(x$arm,c('ARBITER-Sonnet','Baseline-Sonnet','All-Low','Meta'))),,drop=FALSE]
  readr::write_csv(publication_labels(x),paste0('output/tables/',publication_filename(name),'.csv'),na='')
}
run_unchanged(inputs,checks,weights,load_run_metrics())
save_table(cells,'adjudication-analysis-cells')
# Retain the historical filename for source traces and publication readers.
save_table(conditional_choice_analyses(cells,weights),'primary-endpoint')
expert <- expert_agreement(inputs,weights)
for(n in names(expert)) save_table(expert[[n]],paste0('independent-',n))
save_table(expert_reliability(inputs,weights),'expert-reliability')
save_table(severity_distribution(inputs),'severity-distribution')
save_table(benchmark_documents(inputs),'benchmark-documents')
save_table(benchmark_characteristics(inputs),'benchmark-characteristics')
rules <- rules_only_diagnostic(inputs,checks,cells,weights)
for(n in names(rules)) save_table(rules[[n]],paste0('rules-only-',n))
parsed <- parse_signalling_evidence(inputs$evidence)
readr::write_csv(parsed,'data-derived/expert-signalling-components.csv',na='')
save_table(parsed |> filter(issue!=''),'signalling-parse-issues')
comparison <- match_signalling(parsed,inputs$signals)
readr::write_csv(comparison,'data-derived/expert-signalling-comparisons.csv',na='')
signals <- signalling_agreement(comparison,weights)
for(n in names(signals)) save_table(signals[[n]],paste0('signalling-',n))
save_table(reporting_checklist(),'reporting-checklist-skeleton')
build_displays(inputs,cells)
writeLines(trimws(capture.output(sessionInfo()),which='right'),'output/session-info.txt')
python <- Sys.getenv('ARBITER_PYTHON', unset=Sys.which('python3'))
if(!nzchar(python)) python <- Sys.which('python')
stopifnot(system2(python,c('../scripts/report-refresh.py'))==0L)
stopifnot(system2(python,c('../scripts/build-manuscript.py','--html-only'))==0L)
