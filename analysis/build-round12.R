# Rebuild presentation from the already-verified statistical CSVs.
source('R/load.R')
source('R/publication-io.R')
source('R/presentation.R')
for(f in c('algorithms.R','bootstrap.R','agreement.R','win-share.R','process.R','checklist.R',
  'avatar-trace.R','manuscript-tables.R','manuscript-supplement.R','manuscript-figures.R',
  'manuscript-legends.R','results-sentences.R')) source(paste0('R/',f))
inputs <- load_inputs()
build_main_tables(inputs)
build_manuscript_figures(adjudication_cells(inputs))
build_supplement(inputs)
build_figure_legends()
build_results_sentences()

finish_publication_outputs()
