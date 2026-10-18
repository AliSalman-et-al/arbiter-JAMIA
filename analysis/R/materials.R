trace_binding_text <- function(cell) {
  checks <- strsplit(cell$verification_checks,'; ',fixed=TRUE)[[1]]
  stopifnot(all(c('content_hashes','claims','domain_lineage') %in% checks),
    grepl('^sha256:[0-9a-f]{64}$',cell$source_version))
  paste0('Span bound to captured source: ',cell$source,', page ',cell$page,
    ', lines ',cell$start_line,'\u2013',cell$end_line,'; source hash ',
    substr(sub('^sha256:','',cell$source_version),1,8),'\u2026\n',
    'Independent bundle verifier: ',cell$verification_status,' (content hashes, claims, lineage)')
}

worked_trace_candidates <- function(evidence) {
  # Fixed evidence identities make the presentation choice reproducible.
  choices <- tibble(slug=c('award-10-2018','clyman-2019','boedt-2023','potsiurko-2022','levin-2016'),
    domain=c('D2','D4','D5','D4','D2'),question=c(2.6,4.5,5.3,4.3,2.6),
    evidence_id=paste0('sha256:',c(
      'a54e3f2ee2f7afad8cd0e7e6159050710c49eab7a98976db1bdc117b22730806',
      '49613565c8c053237e35bf26eec72d6006cf762b3b99907aab1ccf0be7727758',
      '6658214a31987859d8b8b89297e76176d5f60513de54d70a125422ac531a830b',
      'cf9b5373b697f1154a36fb193bdd766ba7781450d2a649035395b6cc4cb341d6',
      '7aa586b897bd8bbceac768c6d6080f1bda917f922bd77da08973578793031bb7')))
  x <- left_join(choices,evidence,by=c('slug','domain','question','evidence_id'))
  # Remove an unrelated trailing sentence fragment from the selected excerpt.
  x$passage[1] <- sub('^study[.] ','',x$passage[1])
  x$passage_words <- lengths(strsplit(x$passage,'\\s+'))
  stopifnot(nrow(x)==5L,!anyNA(x$passage),all(x$passage_words<=30),
    all(x$preferred==x$ARBITER_label),
    all(match(x$ARBITER_label[1:4],LABELS)>match(x$meta[1:4],LABELS)),
    all(x$Baseline_label[1:4]==x$meta[1:4]))
  x
}

build_materials <- function(inputs,cells) {
  evidence <- readr::read_csv('data-derived/bundle-trace-evidence.csv',show_col_types=FALSE)
  candidates <- worked_trace_candidates(evidence)
  save_table(candidates,'worked-trace-candidates')
  stopifnot(nrow(candidates)==5L)
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
  template_text <- '/arbiter-assess Assess risk of bias for {outcome} defined as {definition} in {trial}.'
  example <- inputs$targets |> arrange(slug) |> slice_head(n=1)
  filled <- paste0('/arbiter-assess Assess risk of bias for ',example$assess_outcome,
    ' defined as ',example$assess_values_as_printed,' in ',example$slug,'.')
  baseline_template <- 'Assess risk of bias for {outcome} defined as {definition} in {trial}.'
  format_instruction <- paste(readLines('../no-kit-sonnet-5.5/nokit-format.txt',warn=FALSE),collapse='\n')
  save_table(tibble(type=c('ARBITER template','ARBITER example','Baseline template','Baseline output-format instruction'),
    slug=c('',example$slug,'',''),prompt=c(template_text,filled,baseline_template,format_instruction)),
    'prompt-template-example')
}
