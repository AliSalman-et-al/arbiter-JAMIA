run_unchanged <- function(inputs,checks,weights,run_metrics) {
bundle_bindings <- readr::read_csv('data-derived/bundle-binding-counts.csv',show_col_types=FALSE) |> filter(arm %in% names(ARMS))
stopifnot(nrow(bundle_bindings)==102L,!anyDuplicated(paste(bundle_bindings$arm,bundle_bindings$slug)),
  setequal(bundle_bindings$slug,inputs$trials$slug))
api_trials <- readr::read_csv('data-derived/api-cost-trials.csv',show_col_types=FALSE) |> filter(arm %in% names(ARMS))
api_turns <- readr::read_csv('data-derived/api-cost-turns.csv',show_col_types=FALSE) |> filter(arm %in% names(ARMS))
run_metrics <- run_metrics |> rename(harness_cost_usd=cost_usd) |>
  left_join(api_trials |> select(arm,slug,cost_usd=point),by=c('arm','slug'))
stopifnot(nrow(run_metrics)==204L,!anyNA(run_metrics$cost_usd))
bundle_decisions <- bundle_decision_cells(run_metrics)
validate_proposed_gate(bundle_decisions,inputs$labels)
bundle_paths <- readr::read_csv('data-derived/bundle-path-checks.csv',show_col_types=FALSE) |> filter(arm %in% names(ARMS))
stopifnot(!any(bundle_paths$invalid_path),!any(bundle_paths$invalid_active_answer),
  all(bundle_paths$active_questions==bundle_paths$active_answered),
  sum(bundle_paths$final)==nrow(bundle_decisions))
dir.create('output/tables',recursive=TRUE,showWarnings=FALSE)
save_table <- function(x,name) {
  # Internal source-column names are translated before publication.
  names(x)[names(x)=='kit'] <- 'ARBITER_label'
  names(x)[names(x)=='nokit'] <- 'Baseline_label'
  if('arm' %in% names(x)) x <- x[order(match(x$arm,c('ARBITER-Sonnet','Baseline-Sonnet',
    'All-Low','Meta'))),,drop=FALSE]
  name <- publication_filename(name)
  x <- publication_labels(x)
  readr::write_csv(x,paste0('output/tables/',name,'.csv'),na='')
}
cost_summary <- api_trials |> group_by(arm) |> summarise(across(
  c(point,lower,upper,harness,side_5m_point,side_5m_lower,side_5m_upper),
  list(total=sum,median=median)),.groups='drop')
save_table(cost_summary,'api-cost-summary')
save_table(api_turns |> mutate(has_side=side_input+side_write1+side_write5+side_read+side_output>0,
  request_excess=gap_input<0|gap_write1<0|gap_write5<0|gap_read<0) |> group_by(arm) |> summarise(across(
  matches('^(request|result|side|gap)_(input|write1|write5|read|output)$'),sum),
  requests=sum(requests),high_requests=sum(high_requests),compaction_events=sum(compaction_events),
  turns_with_side_calls=sum(has_side),
  turns_with_request_excess=sum(request_excess),
  side_without_compaction=sum(side_without_compaction),.groups='drop'),'api-token-reconciliation')
save_table(process_summary(run_metrics),'process-summary')
save_table(process_display(run_metrics,weights),'table5')
save_table(paired_process_difference(run_metrics,weights),'process-differences')
save_table(audit_summary(run_metrics,weights,bundle_bindings),'audit-summary')
save_table(bundle_decisions,'bundle-domain-checks')
save_table(tibble(seed=SEED,replicates=B,coding_sample_seed=20261019L,
  rng_kind=RNGkind()[1],quantile_type=7),'reproducibility')
agreement_outputs <- function(labels,reference,exclude_missing=FALSE) {
  all_low <- labels |> filter(arm=='ARBITER-Sonnet') |> mutate(arm='All-Low',label='Low')
  labels <- bind_rows(labels,all_low)
  groups <- c('D1-D5',paste0('D',1:5))
  results <- differences <- list()
  for(g in groups) {
    x <- if(g=='D1-D5') filter(labels,domain!='Overall') else filter(labels,domain==g)
    if(!nrow(x)) next
    reps <- list()
    for(a in unique(x$arm)) {
      d <- x |> filter(arm==a,!is.na(meta))
      if(!nrow(d)) next
      reps[[a]] <- agreement_replicates(d,weights,exclude_missing)[c('accuracy','kappa'),,drop=FALSE]
      if(a=='All-Low') reps[[a]]['kappa',] <- NA_real_
      results[[paste(g,a)]] <- interval_table(reps[[a]]) |>
        mutate(arm=a,domain=g,reference=reference,n=sum(!exclude_missing|!is.na(d$label)),
          missing=sum(is.na(d$label)),count=NA_integer_)
      out <- results[[paste(g,a)]]
      kept <- if(exclude_missing) filter(d,!is.na(label)) else d
      for(m in 'accuracy') {
        eligible <- switch(m,accuracy=rep(TRUE,nrow(kept)),
          sensitivity=kept$meta!='Low',specificity=kept$meta=='Low')
        correct <- switch(m,accuracy=!is.na(kept$label)&kept$label==kept$meta,
          sensitivity=!is.na(kept$label)&kept$label!='Low',
          specificity=!is.na(kept$label)&kept$label=='Low')
        out$count[out$metric==m] <- sum(correct & eligible)
        out$n[out$metric==m] <- sum(eligible)
      }
      results[[paste(g,a)]] <- out
    }
    for(model in 'Sonnet') {
      aa <- paste0('ARBITER-',model); bb <- paste0('Baseline-',model)
      if(all(c(aa,bb) %in% names(reps))) differences[[paste(g,model)]] <-
        interval_table(reps[[aa]]-reps[[bb]]) |> mutate(comparison=paste(aa,'minus',bb),
          domain=g,reference=reference)
    }
  }
  list(estimates=bind_rows(results),differences=bind_rows(differences))
}
meta_agreement <- agreement_outputs(inputs$labels,'Meta')
save_table(meta_agreement$estimates,'agreement-meta')
save_table(meta_agreement$differences,'agreement-meta-differences')
save_table(checks,'domain-consistency-cells')
save_table(invalid_path_sensitivity(inputs,checks),'invalid-path-sensitivity')
save_table(checks |> filter(startsWith(arm,'ARBITER'),status=='Reported departure'),'algorithm-mismatches')
save_table(checks |> count(arm,status),'algorithm-validation-summary')
save_table(question_map(),'question-map')
overall <- overall_checks(inputs$labels)
save_table(overall,'overall-consistency-cells')
overall_rates <- consistency_rates(overall,weights) |> mutate(domain='Overall')
domain_rates <- bind_rows(lapply(c('D1-D5',paste0('D',1:5)),function(d) {
  x <- if(d=='D1-D5') checks else filter(checks,domain==d)
  x <- filter(x,!startsWith(arm,'ARBITER'))
  consistency_rates(x,weights) |> mutate(domain=d)
}))
consistency <- bind_rows(overall_rates,domain_rates,bundle_decision_rates(bundle_decisions,inputs$labels,weights),
  audit_summary(run_metrics,weights,bundle_bindings) |> rename(status=metric) |> mutate(domain='Audit',missing=NA_integer_))
save_table(consistency,'table3-supplement')
save_table(consistency |> filter(arm %in% c('Meta','ARBITER-Sonnet','Baseline-Sonnet')),'table3')

  source('R/materials.R',local=TRUE)
  build_materials(inputs,NULL)
  save_table(inputs$targets |> count(assess_vs_label,name='trials') |>
    mutate(analysis='Descriptive label-target audit'),'label-target-summary')
  x <- inputs$targets
  save_table(tibble(category=c('Trial-wide labels','Joint pain and disability labels','Unknown result binding',
    'Inferred binding (including unknown result binding)'),trials=c(
      sum(grepl('one rating per trial, not tied to an outcome',x$binding,fixed=TRUE)),
      sum(grepl('covering pain intensity and disability',x$binding,fixed=TRUE)),
      sum(x$assess_vs_label=='unknown'),sum(grepl('not stated by the meta',x$binding,fixed=TRUE)))) |>
    mutate(domain_labels=5L*trials),'label-target-binding-counts')
  invisible(TRUE)
}
