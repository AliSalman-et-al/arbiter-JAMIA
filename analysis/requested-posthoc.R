# Run from analysis/. Never calls a model or recomputes existing result exports.
source('R/load.R')
for(f in setdiff(list.files('R',pattern='[.]R$',full.names=TRUE),'R/load.R')) source(f)
inputs <- load_inputs()
weights <- stratified_cluster_weights(inputs$trials,10000L,20261018L)
run_requested_posthoc(inputs,weights)
