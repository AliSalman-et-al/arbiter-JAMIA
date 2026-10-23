# Resume after already completed tables, figures, supplement and reporting map.
source('R/load.R')
for(f in setdiff(list.files('R',pattern='[.]R$',full.names=TRUE),'R/load.R')) source(f)
build_manuscript_document()
python <- Sys.getenv('ARBITER_PYTHON')
stopifnot(system2(python,c('../scripts/report-refresh.py'))==0L)
stopifnot(system2(python,c('../scripts/build-manuscript.py','--html-only'))==0L)
