source('R/load.R')
for(f in c('publication-io.R','presentation.R','manuscript-tables.R','manuscript-figures.R')) source(paste0('R/',f))
register_figure_fonts()
cells <- manuscript_data('adjudication-analysis-cells') |> rename(kit=ARBITER_label,nokit=Baseline_label)
plots <- list(Figure3=study_flow_plot,Figure4=published_reference_plot,Figure5=function() adjudication_plot(cells),Figure6=decisive_question_plot,eFigure1=forest_plot)
original <- JAMA_ROLES
for(mode in c('grayscale','deuteranopia')) {
 JAMA_ROLES <- if(mode=='grayscale') colorspace::desaturate(original) else colorspace::deutan(original)
 for(nm in names(plots)) ggplot2::ggsave(paste0('output/manuscript/qa/round14-',nm,'-',mode,'.png'),plots[[nm]](),width=174,height=if(nm=='Figure6') 210 else if(nm=='Figure4') 160 else 120,units='mm',dpi=120,device=ragg::agg_png,bg='white')
}
JAMA_ROLES <- original
