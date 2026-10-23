build_materials <- function(inputs,cells) {
  journals <- c('ajsm-acl-leap'='American Journal of Sports Medicine','bja-prehab'='British Journal of Anaesthesia',
    'cid-rifampin'='Clinical Infectious Diseases','cjasn-iga'='Clinical Journal of the American Society of Nephrology',
    'gastro-glp1'='Gastroenterology','hru-preconception'='Human Reproduction Update',
    'jacc-avr'='Journal of the American College of Cardiology','jama-sglt2'='JAMA',
    'jamapeds-pda'='JAMA Pediatrics','lancet-clopidogrel'='The Lancet',
    'lde-glp1'='The Lancet Diabetes & Endocrinology','lneurol-neuropathic'='The Lancet Neurology',
    'loncol-cdk46'='The Lancet Oncology','lpsych-cannabinoids'='The Lancet Psychiatry',
    'lrheum-lbp'='The Lancet Rheumatology','lrm-preox'='The Lancet Respiratory Medicine')
  metadata <- inputs$trials |> count(meta_id,field,name='trials') |> mutate(journal=unname(journals[meta_id]))
  stopifnot(!anyNA(metadata$journal))
  distribution <- inputs$labels |> filter(arm=='ARBITER-Sonnet',domain!='Overall') |>
    count(meta_id,domain,meta) |> complete(meta_id,domain,meta=LABELS,fill=list(n=0)) |>
    mutate(meta=factor(meta,levels=LABELS)) |> arrange(meta_id,domain,meta) |>
    group_by(meta_id,domain) |> summarise(distribution=paste(n,collapse='/'),.groups='drop') |>
    pivot_wider(names_from=domain,values_from=distribution)
  save_table(left_join(metadata,distribution,by='meta_id'),'table1')
  save_table(meta_agreement$estimates |> filter(arm %in% c('ARBITER-Sonnet','Baseline-Sonnet','All-Low'),
    domain %in% c('D1-D5','Overall')),'table2')
  save_table(meta_agreement$differences |> filter(comparison=='ARBITER-Sonnet minus Baseline-Sonnet',
    domain %in% c('D1-D5','Overall')),'table2-differences')
  # Evaluated command: kit-sonnet-5.5/run_case.py and README.md.
  template_text <- '/rob2-assess Assess risk of bias for {outcome} defined as {definition} in {trial}.'
  example <- inputs$targets |> arrange(slug) |> slice_head(n=1)
  filled <- paste0('/rob2-assess Assess risk of bias for ',example$assess_outcome,
    ' defined as ',example$assess_values_as_printed,' in ',example$slug,'.')
  baseline_template <- 'Assess risk of bias for {outcome} defined as {definition} in {trial}.'
  format_instruction <- paste(readLines('../no-kit-sonnet-5.5/nokit-format.txt',warn=FALSE),collapse='\n')
  save_table(tibble(type=c('ARBITER template','ARBITER example','Baseline template','Baseline output-format instruction'),
    slug=c('',example$slug,'',''),prompt=c(template_text,filled,baseline_template,format_instruction)),
    'prompt-template-example')
}
