# Rebuild publication artifacts from finalized estimates, without resampling.
# Run run.R first when statistical inputs or estimands change.
source('R/load.R')
for(f in setdiff(list.files('R',pattern='[.]R$',full.names=TRUE),'R/load.R')) source(f)
inputs <- load_inputs()
build_displays(inputs,adjudication_cells(inputs),rebuild_figures=!'--tables-only' %in% commandArgs(TRUE))
for(page in c('results.qmd','supplement.qmd'))
  stopifnot(system2('quarto',c('render',page))==0L)
