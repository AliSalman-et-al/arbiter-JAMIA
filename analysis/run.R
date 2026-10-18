# Rebuild all numerical outputs from read-only inputs. Run from analysis/.
source('R/load.R')
for(f in setdiff(list.files('R',full.names=TRUE),c('R/load.R','R/figures.R','R/materials.R'))) source(f)
SEED <- 20261018L
B <- 10000L
inputs <- load_inputs()
checks <- domain_checks(inputs)
validate_gate(checks)
weights <- stratified_cluster_weights(inputs$trials,B,SEED)
cells <- adjudication_cells(inputs)
run_metrics <- load_run_metrics()
bundle_bindings <- readr::read_csv('data-derived/bundle-binding-counts.csv',show_col_types=FALSE)
stopifnot(nrow(bundle_bindings)==204L,!anyDuplicated(paste(bundle_bindings$arm,bundle_bindings$slug)),
  setequal(bundle_bindings$slug,inputs$trials$slug))
api_trials <- readr::read_csv('data-derived/api-cost-trials.csv',show_col_types=FALSE)
api_turns <- readr::read_csv('data-derived/api-cost-turns.csv',show_col_types=FALSE)
run_metrics <- run_metrics |> rename(harness_cost_usd=cost_usd) |>
  left_join(api_trials |> select(arm,slug,cost_usd=point),by=c('arm','slug'))
stopifnot(nrow(run_metrics)==408L,!anyNA(run_metrics$cost_usd))
bundle_decisions <- bundle_decision_cells(run_metrics)
validate_proposed_gate(bundle_decisions,inputs$labels)
bundle_paths <- readr::read_csv('data-derived/bundle-path-checks.csv',show_col_types=FALSE)
stopifnot(!any(bundle_paths$invalid_path),!any(bundle_paths$invalid_active_answer),
  all(bundle_paths$active_questions==bundle_paths$active_answered),
  sum(bundle_paths$final)==nrow(bundle_decisions))
dir.create('output/tables',recursive=TRUE,showWarnings=FALSE)
save_table <- function(x,name) {
  # Internal source-column names are translated before publication.
  names(x)[names(x)=='kit'] <- 'ARBITER_label'
  names(x)[names(x)=='nokit'] <- 'Baseline_label'
  if('arm' %in% names(x)) x <- x[order(match(x$arm,c('ARBITER-Sonnet','Baseline-Sonnet',
    'All-Low','ARBITER-Haiku','Baseline-Haiku','Meta'))),,drop=FALSE]
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
save_table(process_display(run_metrics,weights,'Haiku'),'table5-haiku')
save_table(paired_process_difference(run_metrics,weights),'process-differences')
save_table(audit_summary(run_metrics,weights,bundle_bindings),'audit-summary')
save_table(evidence_distribution(run_metrics),'evidence-bases-distribution')
save_table(bundle_decisions,'bundle-domain-checks')
save_table(bundle_decisions |> filter(override),'recorded-overrides')
save_table(tibble(seed=SEED,replicates=B,coding_sample_seed=20261019L,
  rng_kind=RNGkind()[1],quantile_type=7),'reproducibility')
primary <- bind_rows(lapply(c('Consensus','A','Z','Split sensitivity'),function(s) win_share(cells,weights,s)))
save_table(primary,'primary-endpoint')

agreement_outputs <- function(labels,reference,exclude_missing=FALSE) {
  all_low <- labels |> filter(arm=='ARBITER-Sonnet') |> mutate(arm='All-Low',label='Low')
  labels <- bind_rows(labels,all_low)
  groups <- c('D1-D5',paste0('D',1:5),'Overall')
  results <- differences <- list()
  for(g in groups) {
    x <- if(g=='D1-D5') filter(labels,domain!='Overall') else filter(labels,domain==g)
    if(!nrow(x)) next
    reps <- list()
    for(a in unique(x$arm)) {
      d <- x |> filter(arm==a,!is.na(meta))
      if(!nrow(d)) next
      reps[[a]] <- agreement_replicates(d,weights,exclude_missing)
      if(a=='All-Low') reps[[a]][c('kappa','AC2','sensitivity'),] <- NA_real_
      results[[paste(g,a)]] <- interval_table(reps[[a]]) |>
        mutate(arm=a,domain=g,reference=reference,n=sum(!exclude_missing|!is.na(d$label)),
          missing=sum(is.na(d$label)),count=NA_integer_)
      out <- results[[paste(g,a)]]
      kept <- if(exclude_missing) filter(d,!is.na(label)) else d
      for(m in c('accuracy','sensitivity','specificity')) {
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
    for(model in c('Sonnet','Haiku')) {
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
composite <- agreement_outputs(composite_reference(inputs),'Composite')
save_table(composite$estimates,'agreement-composite')
save_table(composite$differences,'agreement-composite-differences')
for(a in c('A','Z')) {
  out <- agreement_outputs(composite_reference(inputs,a),paste('Adjudicator',a))
  save_table(out$estimates,paste0('composite-',a))
  save_table(out$differences,paste0('composite-',a,'-differences'))
}
# Pairwise deletion uses the same retained cells in both Haiku arms.
missing_keys <- inputs$labels |> filter(arm=='ARBITER-Haiku',is.na(label)) |> select(slug,domain)
observed <- inputs$labels |> filter(grepl('Haiku',arm)) |> anti_join(missing_keys,by=c('slug','domain'))
missing_sensitivity <- agreement_outputs(observed,'Meta; missing Haiku cells excluded',TRUE)
save_table(missing_sensitivity$estimates,'missing-sensitivity')
save_table(missing_sensitivity$differences,'missing-sensitivity-differences')

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

reliability_pair <- function(x,y,name) {
  d <- cells |> transmute(slug,meta=.data[[x]],label=.data[[y]])
  interval_table(agreement_replicates(d,weights)) |> filter(metric %in% c('kappa','AC2','accuracy')) |>
    mutate(comparison=name,n=nrow(d),count=if_else(metric=='accuracy',sum(d$meta==d$label),NA_integer_))
}
reliability <- bind_rows(reliability_pair('own_A','own_Z','A vs Z independent'),
  reliability_pair('chosen_label_A','chosen_label_Z','A vs Z preferred'),
  bind_rows(lapply(c('A','Z'),function(a) bind_rows(lapply(c('meta','kit','nokit'),function(s)
    reliability_pair(s,paste0('own_',a),paste(a,'independent vs',
      c(meta='meta label',kit='ARBITER-Sonnet',nokit='Baseline-Sonnet')[[s]])))))))
reliability <- reliability |> mutate(population=if_else(grepl('independent vs',comparison),
  'Disputed cells only (selected for disagreement with the meta label); not an estimate of overall meta-label accuracy',
  'Disputed cells only'))
save_table(reliability,'table4-reliability')
leniency <- meta_leniency(cells,weights)
save_table(leniency,'meta-leniency')
save_table(cells |> filter(consensus) |> count(meta,preferred) |>
  complete(meta=LABELS,preferred=LABELS,fill=list(n=0)),'meta-consensus-confusion')
grounding <- bind_rows(lapply(names(ARMS),function(a)
  grounding_share(filter(inputs$signals,arm==a),weights) |> mutate(arm=a)))
save_table(grounding,'grounding')
save_table(inputs$signals |> filter(startsWith(arm,'Baseline'),active) |>
  group_by(arm) |> summarise(n=n(),answer_code_only=sum(!is.na(justification) &
    trimws(justification) %in% c('Y','PY','PN','N','NI','NA')),.groups='drop'),
  'baseline-justification-content')
save_table(signalling_agreement(inputs,weights),'signalling-agreement')

confusion <- inputs$labels |> filter(!is.na(meta)) |>
  mutate(predicted=coalesce(label,'Missing')) |> count(arm,domain,meta,predicted) |>
  complete(arm,domain,meta=LABELS,predicted=c(LABELS,'Missing'),fill=list(n=0))
save_table(confusion,'confusion-matrices')
forest <- bind_rows(lapply(split(filter(inputs$labels,domain!='Overall'),
  interaction(filter(inputs$labels,domain!='Overall')$meta_id,
    filter(inputs$labels,domain!='Overall')$arm,drop=TRUE)),function(d) {
      interval_table(agreement_replicates(d,weights)) |> filter(metric=='kappa') |>
        mutate(meta_id=d$meta_id[1],arm=d$arm[1],n=nrow(d))
    }))
save_table(forest,'forest-meta')
save_table(cells,'adjudication-analysis-cells')
localisation <- localise_errors(inputs,cells)
for(name in c('cells','counts','frequency','issues','eligibility'))
  save_table(localisation[[name]],paste0('error-localisation-',name))
save_table(localisation$candidates,'discussion-quote-candidates')
if(file.exists('R/materials.R')) { source('R/materials.R'); build_materials(inputs,cells) }
# Figure 1 is maintained separately. Its code and outputs are not regenerated here.
build_main_tables(inputs)
build_manuscript_figures(cells)
build_supplement(inputs)
build_figure_legends()
