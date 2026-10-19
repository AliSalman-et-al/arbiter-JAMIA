# Author-requested round 2 additions; existing populations and bootstrap stay fixed.
independent_paired_difference <- function(cells,weights) {
  bind_rows(lapply(c('A','Z'),function(a) {
    own <- cells[[paste0('own_',a)]]
    delta <- as.integer(own==cells$kit)-as.integer(own==cells$nokit)
    w <- bootstrap_rows(cells,weights)
    interval_table(rbind(accuracy=colSums(w*delta)/colSums(w))) |>
      mutate(adjudicator=a,n=nrow(cells),ARBITER_count=sum(own==cells$kit),
        Unassisted_count=sum(own==cells$nokit),analysis='Post hoc paired difference')
  }))
}
composite_components <- function(inputs,cells) {
  inputs$labels |> filter(domain!='Overall') |>
    left_join(cells |> select(slug,domain,consensus,preferred),by=c('slug','domain')) |>
    filter(is.na(consensus)|consensus) |>
    mutate(component=if_else(is.na(consensus),'Kept meta label','Adjudicators’ agreed choice'),
      reference=coalesce(preferred,meta)) |>
    group_by(arm,component) |> summarise(n=n(),count=sum(label==reference),
      agreement=count/n,analysis='Post hoc descriptive split',.groups='drop')
}
question51_mechanism <- function(inputs,localisation) {
  selected <- localisation$cells |> filter(population=='Primary',source=='Baseline-Sonnet',
    grepl('(^|; )5[.]1($|;)',decisive_questions)) |> select(slug,domain)
  signals <- inputs$signals |> filter(question=='5.1') |>
    select(slug,arm,answer,justification) |>
    pivot_wider(names_from=arm,values_from=c(answer,justification))
  reference <- inputs$adjud |> filter(domain=='D5') |>
    transmute(slug,adjudicator,answer=vapply(signalling_answers_independent,function(t)
      parse_independent_answers(t,'D5')$answers[['5.1']],character(1))) |>
    pivot_wider(names_from=adjudicator,values_from=answer,names_prefix='reference_')
  sources <- readr::read_csv('output/tables/round2-bundle-inputs.csv',show_col_types=FALSE)
  selected |> left_join(signals,by='slug') |> left_join(reference,by='slug') |>
    left_join(sources,by='slug') |>
    mutate(mentions_document=grepl('registr|clinicaltrials|protocol|\\bSAP\\b|statistical analysis plan',
      coalesce(`justification_Baseline-Sonnet`,''),ignore.case=TRUE,perl=TRUE),
      answer=unname(c(yes='Y',probably_yes='PY',no='N',probably_no='PN',no_information='NI',not_applicable='NA')[`answer_Baseline-Sonnet`]),
      reference=reference_A,analysis='Post hoc descriptive analysis') |>
    select(slug,registry_or_protocol_or_sap,registry,source_inventory,
      mentions_document,answer,reference_A,reference_Z,
      unassisted_justification=`justification_Baseline-Sonnet`,
      ARBITER_justification=`justification_ARBITER-Sonnet`,analysis)
}
label_target_summary <- function(inputs) {
  inputs$targets |> count(assess_vs_label,name='trials') |>
    mutate(analysis='Descriptive label-target audit')
}
label_binding_counts <- function(inputs) {
  x <- inputs$targets
  tibble(category=c('Trial-wide labels','Joint pain and disability labels','Unknown result binding',
      'Inferred binding (including unknown result binding)'),
    trials=c(sum(grepl('one rating per trial, not tied to an outcome',x$binding,fixed=TRUE)),
      sum(grepl('covering pain intensity and disability',x$binding,fixed=TRUE)),
      sum(x$assess_vs_label=='unknown'),sum(grepl('not stated by the meta',x$binding,fixed=TRUE)))) |>
    mutate(domain_labels=5L*trials)
}
