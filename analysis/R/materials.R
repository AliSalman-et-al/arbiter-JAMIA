coding_kappa <- function(a,b) {
  levels <- sort(unique(c(a,b)))
  tab <- table(factor(a,levels),factor(b,levels))
  n <- sum(tab)
  observed <- sum(diag(tab))/n
  expected <- sum(rowSums(tab)*colSums(tab))/n^2
  if(!n || expected==1) NA_real_ else (observed-expected)/(1-expected)
}

coding_template <- function(inputs,cells) {
  explanations <- inputs$adjud |> select(slug,domain,adjudicator,
    independent_explanation,adjudication_explanation) |>
    pivot_wider(names_from=adjudicator,values_from=c(independent_explanation,adjudication_explanation))
  x <- cells |> filter(consensus) |> select(slug,meta_id,domain,preferred,kit,nokit,meta) |>
    pivot_longer(c(kit,nokit,meta),names_to='source',values_to='losing_label') |>
    filter(losing_label!=preferred) |> mutate(source=recode(source,kit='ARBITER',nokit='Baseline',meta='Meta')) |>
    arrange(slug,domain,source) |> left_join(explanations,by=c('slug','domain')) |>
    mutate(row_id=paste(slug,domain,source,sep=':'),second_author_sample=FALSE,
      code_author1='',code_author2='',final_code='',coding_notes='')
  sample <- withr::with_seed(20261019L,sample.int(nrow(x),ceiling(.2*nrow(x))))
  x$second_author_sample[sample] <- TRUE
  x
}

summarise_coding <- function(sheet,template,codebook) {
  stopifnot(!anyDuplicated(sheet$row_id),setequal(sheet$row_id,template$row_id))
  sheet <- sheet[match(template$row_id,sheet$row_id),]
  fixed <- setdiff(names(template),c('code_author1','code_author2','final_code','coding_notes'))
  for(n in fixed) stopifnot(identical(as.character(sheet[[n]]),as.character(template[[n]])))
  present <- function(x) !is.na(x)&nzchar(trimws(x))
  if(!all(present(sheet$code_author1)) ||
     !all(present(sheet$code_author2[sheet$second_author_sample]))) return(NULL)
  for(n in c('code_author1','code_author2','final_code')) {
    used <- which(present(sheet[[n]]))
    stopifnot(all(sheet[[n]][used] %in% codebook$code))
    for(i in used) stopifnot(any(codebook$code==sheet[[n]][i] &
      codebook$domain %in% c('All',sheet$domain[i])))
  }
  sample <- sheet[sheet$second_author_sample,]
  list(reliability=tibble(n=nrow(sample),kappa=coding_kappa(sample$code_author1,sample$code_author2)),
    counts=sheet |> mutate(code=if_else(present(final_code),final_code,code_author1)) |> count(source,code))
}

build_materials <- function(inputs,cells) {
  dir.create('output/coding',recursive=TRUE,showWarnings=FALSE)
  codebook <- tibble::tribble(
    ~domain,~code,~concept,~include,~exclude,
    'D1','D1_sequence','Sequence generation','Misread random sequence evidence','Concealment only',
    'D1','D1_concealment','Allocation concealment','Misjudged concealment before assignment','Post-allocation blinding',
    'D1','D1_imbalance','Baseline imbalance','Misjudged evidence of a randomization problem','Chance imbalance without concern',
    'D2','D2_awareness','Awareness of intervention','Misread participant or personnel awareness','Outcome-assessor awareness',
    'D2','D2_deviations','Deviations from intended intervention','Ignored or overcounted trial-context deviations, impact or balance','Routine adherence alone',
    'D2','D2_analysis','Effect-of-assignment analysis','Misjudged assignment analysis or substantial impact','Missing outcome data only',
    'D3','D3_missingness','Missing outcome data','Misjudged completeness, dependence or evidence against bias','Exclusions with complete outcomes',
    'D4','D4_measurement','Measurement method','Misread inappropriate or differential measurement','Assessor awareness alone',
    'D4','D4_awareness','Outcome-assessor awareness','Misjudged awareness and likely influence','Participant awareness without assessment role',
    'D5','D5_prespecification','Prespecified analysis','Missed or misread prospectively specified analysis','Multiplicity alone',
    'D5','D5_selection','Selection of reported result','Missed selective measurement or analysis reporting','Absent protocol alone',
    'All','X_target','Wrong result or outcome','Wrong outcome, time point or contrast assessed','Correct target with evidence error',
    'All','X_algorithm','Algorithm not followed','Own answers do not yield reported domain label','Disagreement about evidence feeding answers',
    'All','X_other','Other or insufficient explanation','Explain in coding_notes; no specific code supported','Specific supported category')
  readr::write_csv(codebook,'output/coding/codebook-draft.csv')
  writeLines(c('# Error-taxonomy codebook draft',
    'Humans only. No LLM assigns, proposes, or fills row-level codes.',
    'Concepts derive from RoB 2 full guidance (22 August 2019), domain tables 3–14.',
    'One row is one losing source on one consensus cell. Read both explanations and the trial evidence.',
    'Choose one primary code. Prefer the specific evidence error over X_algorithm when the error is upstream.',
    'Use X_algorithm only when the source own answers contradict its reported judgement.',
    'Author 1 codes every row in code_author1; author 2 independently codes only flagged rows in code_author2.',
    'The fixed random 20% sample is rounded upward; seed 20261019. Preserve all fixed columns.',
    'Record disagreements before reconciliation. Optionally fill final_code after discussion; raw author codes stay unchanged.',
    'The pipeline reports unweighted Cohen kappa on the sampled rows and counts by source.',
    'Blank or partial sheets retain the report placeholder. See codebook-draft.csv for inclusion/exclusion rules.'),
    'output/coding/README.md')
  template <- coding_template(inputs,cells)
  readr::write_csv(template,'output/coding/coding-sheet-empty.csv',na='')
  path <- 'output/coding/coding-sheet.csv'
  if(!file.exists(path)) readr::write_csv(template,path,na='')
  sheet <- readr::read_csv(path,show_col_types=FALSE,na=character(),
    col_types=readr::cols(.default=readr::col_character(),second_author_sample=readr::col_logical()))
  coding <- summarise_coding(sheet,template,codebook)
  # Remove obsolete summaries if a human sheet becomes incomplete again.
  for(p in c('coding-reliability','coding-counts')) {
    f <- paste0('output/tables/',p,'.csv')
    if(file.exists(f)) unlink(f)
  }
  if(!is.null(coding)) {
    save_table(coding$reliability,'coding-reliability')
    save_table(coding$counts,'coding-counts')
  }
  quoted_cells <- inputs$signals |> filter(arm=='ARBITER-Sonnet',active,has_quotation(justification)) |>
    distinct(slug,domain) |> mutate(has_qualifying_quotation=TRUE)
  candidates <- cells |> filter(consensus,kit==preferred,kit!=meta) |>
    left_join(quoted_cells,by=c('slug','domain')) |>
    mutate(has_qualifying_quotation=coalesce(has_qualifying_quotation,FALSE)) |>
    arrange(desc(has_qualifying_quotation),slug,domain) |>
    slice_head(n=5) |> select(slug,meta_id,domain,meta,kit,nokit,preferred,has_qualifying_quotation)
  text <- inputs$signals |> filter(arm=='ARBITER-Sonnet',active) |> arrange(slug,domain,question) |>
    group_by(slug,domain) |> summarise(signalling_answers=paste(paste0(question,'=',answer),collapse='; '),
      arbiter_justifications=paste(paste0(question,': ',justification),collapse='\n\n'),
      .groups='drop')
  save_table(left_join(candidates,text,by=c('slug','domain')),'worked-trace-candidates')
  stopifnot(nrow(candidates)>=3L,nrow(candidates)<=5L)

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
  save_table(tibble(type=c('Template','Example'),slug=c('',example$slug),prompt=c(template_text,filled)),
    'prompt-template-example')
}
