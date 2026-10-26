expert_references <- function(inputs) {
  domains <- inputs$adjud |> transmute(slug,domain,adjudicator,reference=independent)
  overall <- domains |> group_by(slug,adjudicator) |>
    summarise(reference=derived_overall(reference),.groups='drop') |> mutate(domain='Overall')
  bind_rows(domains,overall)
}

reference_predictions <- function(inputs) {
  labels <- inputs$labels
  bind_rows(labels |> transmute(slug,domain,source=if_else(arm=='ARBITER-Sonnet','ARBITER','Unassisted'),label),
    labels |> filter(arm=='ARBITER-Sonnet',domain!='Overall') |> transmute(slug,domain,source='Published',label=meta))
}

expert_agreement <- function(inputs,weights) {
  refs <- expert_references(inputs)
  predictions <- reference_predictions(inputs)
  estimates <- differences <- confusion <- list()
  for(a in c('1','2')) for(g in c('D1-D5',paste0('D',1:5),'Overall')) {
    ref <- refs |> filter(adjudicator==a,if(g=='D1-D5') domain!='Overall' else domain==g)
    reps <- list()
    sources <- if(g=='Overall') c('ARBITER','Unassisted') else c('ARBITER','Unassisted','Published')
    population <- if(g=='Overall') 'All trials' else 'All domain cells'
    for(s in sources) {
      d <- ref |> inner_join(filter(predictions,source==s),by=c('slug','domain')) |> mutate(meta=reference)
      reps[[s]] <- agreement_replicates(d,weights)[c('accuracy','kappa'),,drop=FALSE]
      estimates[[length(estimates)+1L]] <- interval_table(reps[[s]]) |>
        mutate(adjudicator=a,source=s,domain=g,population=population,n=nrow(d),
          count=if_else(metric=='accuracy',sum(!is.na(d$label)&d$label==d$reference),NA_integer_))
      if(g %in% paste0('D',1:5)) confusion[[length(confusion)+1L]] <- d |>
        mutate(predicted=coalesce(label,'Missing')) |> count(domain,reference,predicted) |>
        mutate(adjudicator=a,source=s)
    }
    differences[[length(differences)+1L]] <- interval_table(reps$ARBITER-reps$Unassisted) |>
      mutate(adjudicator=a,comparison='ARBITER minus Unassisted',domain=g,
        population=population,n=nrow(ref))
  }
  list(estimates=bind_rows(estimates),differences=bind_rows(differences),confusion=bind_rows(confusion))
}

expert_reliability <- function(inputs,weights) {
  x <- expert_references(inputs) |> pivot_wider(names_from=adjudicator,values_from=reference)
  bind_rows(lapply(c('D1-D5',paste0('D',1:5),'Overall'),function(g) {
    d <- x |> filter(if(g=='D1-D5') domain!='Overall' else domain==g) |> transmute(slug,meta=`1`,label=`2`)
    interval_table(agreement_replicates(d,weights)[c('accuracy','kappa'),,drop=FALSE]) |>
      mutate(domain=g,n=nrow(d),count=if_else(metric=='accuracy',sum(d$meta==d$label),NA_integer_))
  }))
}

rules_only_diagnostic <- function(inputs,checks,cells,weights) {
  labels <- rules_only_labels(inputs$labels,checks)
  original <- inputs$labels |> filter(arm=='Baseline-Sonnet',domain!='Overall') |> select(slug,domain,original=label)
  replacements <- labels |> filter(arm=='Baseline-Sonnet',domain!='Overall') |> select(slug,domain,recomputed=label)
  changed <- left_join(original,replacements,by=c('slug','domain')) |>
    filter(!is.na(original),original!=recomputed) |>
    left_join(cells |> select(slug,domain,discordant,consensus),by=c('slug','domain'))
  agreement <- bind_rows(lapply(c('1','2'),function(a) {
    d <- inputs$adjud |> filter(adjudicator==a) |>
      transmute(slug,domain,reference=independent) |>
      inner_join(replacements |> rename(label=recomputed),by=c('slug','domain')) |> mutate(meta=reference)
    interval_table(agreement_replicates(d,weights)[c('accuracy','kappa'),,drop=FALSE]) |>
      mutate(adjudicator=a,source='Unassisted',domain='D1-D5',population='All domain cells',n=nrow(d),
        count=if_else(metric=='accuracy',sum(!is.na(d$label)&d$label==d$reference),NA_integer_))
  }))
  list(changed=changed,agreement=agreement)
}

conditional_choice_analyses <- function(cells,weights) {
  bind_rows(lapply(c('Consensus','Adjudicator 1','Adjudicator 2','Split sensitivity'),
    function(a) win_share(cells,weights,a)))
}
