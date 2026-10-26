# Rebuild publication artifacts from finalized estimates, without resampling.
# Run run.R first when statistical inputs or estimands change.
source('R/load.R')
for(f in setdiff(list.files('R',pattern='[.]R$',full.names=TRUE),'R/load.R')) source(f)
inputs <- load_inputs()
build_displays(inputs,adjudication_cells(inputs),rebuild_figures=!'--tables-only' %in% commandArgs(TRUE))
# Refresh HTML from the finalized analysis and supplement materials.
python <- Sys.getenv('ARBITER_PYTHON', unset=Sys.which('python3'))
if(!nzchar(python)) python <- Sys.which('python')
stopifnot(system2(python,c('../scripts/report-refresh.py'))==0L)
