# Round-2 contract checks on the real exports, independently of display formatting.
source('R/load.R')
for(f in c('bootstrap','agreement','algorithms','win-share','posthoc','round11','round14-round2',
  'publication-io','presentation','manuscript-tables','avatar-trace','manuscript-supplement','checklist')) source(paste0('R/',f,'.R'))
x <- load_inputs(); cells <- adjudication_cells(x)
w <- stratified_cluster_weights(x$trials,10000,20261018)
stopifnot(isTRUE(all.equal(independent_paired_difference(cells,w),manuscript_data('independent-paired-difference'),check.attributes=FALSE)))
stopifnot(isTRUE(all.equal(composite_components(x,cells),manuscript_data('composite-components'),check.attributes=FALSE)))
stopifnot(isTRUE(all.equal(label_binding_counts(x),manuscript_data('label-target-binding-counts'),check.attributes=FALSE)))
# Recomputed labels in all three changed disagreements equal both ARBITER and preferred.
r <- rules_only_recomputation(x$labels,domain_checks(x),cells,w)$changed |> filter(consensus,discordant) |>
  left_join(cells |> select(slug,domain,kit),by=c('slug','domain'))
stopifnot(nrow(r)==3L,all(r$recomputed==r$kit),all(r$recomputed==r$preferred))
for(i in 1:4) {
  txt <- officer::docx_summary(officer::read_docx(paste0('output/manuscript/Table',i,'.docx')))$text
  stopifnot(!any(grepl('Sonnet|10[.]10[0-9]{2}/',txt)))
}
stopifnot(all(nzchar(reporting_checklist()$section)))
cat('Round-2 additions, three new ties, main-table terminology and complete reporting map verified.\n')
