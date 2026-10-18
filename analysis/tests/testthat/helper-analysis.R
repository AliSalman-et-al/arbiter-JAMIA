analysis_dir <- normalizePath(file.path('..','..'),winslash='/')
source(file.path(analysis_dir,'R','load.R'))
source(file.path(analysis_dir,'R','algorithms.R'))
inputs <- load_inputs(file.path(analysis_dir,'..'))
