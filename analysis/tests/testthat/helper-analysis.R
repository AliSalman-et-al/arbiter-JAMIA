analysis_dir <- normalizePath(file.path('..','..'),winslash='/')
for(f in c('load.R','algorithms.R','bootstrap.R','agreement.R','win-share.R','grounding.R','secondary.R','process.R','extract-run-metrics.R','posthoc.R','expert-agreement.R','signalling.R','bundle-review.R','api-cost.R','publication-io.R')) source(file.path(analysis_dir,'R',f))
inputs <- load_inputs(file.path(analysis_dir,'..'))
