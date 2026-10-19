load_run_metrics <- function(directory='data-derived') {
  paths <- file.path(directory,paste0(tolower(names(ARMS)),'.csv'))
  if(!all(file.exists(paths))) stop('Derived run metrics absent. Run Rscript R/extract-run-metrics.R with raw logs available.')
  out <- bind_rows(lapply(paths,function(p) readr::read_csv(p,show_col_types=FALSE)))
  stopifnot(nrow(out)==204L,!anyDuplicated(paste(out$arm,out$slug)))
  out
}

process_summary <- function(metrics) {
  columns <- c('wall_seconds','input_tokens','cache_creation_tokens','cache_read_tokens',
    'output_tokens','thinking_tokens','cost_usd','turns','agent_steps','continues','approved')
  bind_rows(lapply(split(metrics,metrics$arm),function(x) bind_rows(lapply(columns,function(m) {
    v <- as.numeric(x[[m]]); ok <- !is.na(v)
    q <- if(any(ok)) quantile(v[ok],c(.25,.5,.75),names=FALSE,type=7) else rep(NA_real_,3)
    tibble(arm=x$arm[1],metric=m,n=sum(ok),missing=sum(!ok),median=q[2],q1=q[1],q3=q[3],
      total=if(all(ok)) sum(v) else NA_real_)
  }))))
}

paired_process_difference <- function(metrics,weights,model='Sonnet') {
  columns <- c('wall_seconds','input_tokens','cache_creation_tokens','cache_read_tokens',
    'output_tokens','thinking_tokens','cost_usd','turns','agent_steps','continues')
  a <- filter(metrics,arm==paste0('ARBITER-',.env$model))
  b <- filter(metrics,arm==paste0('Baseline-',.env$model)); b <- b[match(a$slug,b$slug),]
  bind_rows(lapply(columns,function(m) {
    delta <- a[[m]]-b[[m]]
    if(anyNA(delta)) return(tibble(metric=m,estimand='Mean paired trial difference',estimate=NA_real_,lower=NA_real_,upper=NA_real_,valid_replicates=0L))
    w <- bootstrap_rows(a,weights)
    values <- rbind(`Mean paired trial difference`=colSums(w*delta)/colSums(w),
      `Total paired difference`=colSums(w*delta))
    interval_table(values) |> rename(estimand=metric) |> mutate(metric=m)
  }))
}

process_display <- function(metrics,weights,model='Sonnet') {
  summaries <- process_summary(metrics)
  differences <- paired_process_difference(metrics,weights,model) |> filter(estimand=='Mean paired trial difference')
  columns <- c('wall_seconds','cost_usd','input_tokens','cache_creation_tokens','cache_read_tokens',
    'output_tokens','thinking_tokens','agent_steps','continues','turns')
  labels <- c('Time (minutes/trial)','Cost (USD/trial)','Input tokens (count/trial)',
    'Cache creation tokens (millions/trial)','Cache read tokens (millions/trial)',
    'Output tokens (thousands/trial)','Thinking tokens (thousands/trial)',
    'Agent steps/trial','Continue prompts/trial','Turns/trial')
  bind_rows(lapply(seq_along(columns),function(i) {
    m <- columns[i]
    cache <- m %in% c('cache_creation_tokens','cache_read_tokens')
    scale <- if(m=='wall_seconds') 60 else if(cache) 1e6 else
      if(m %in% c('output_tokens','thinking_tokens')) 1000 else 1
    digits <- if(m=='input_tokens') 0 else if(m=='cost_usd' || cache) 2 else 1
    fmt <- function(v) ifelse(is.na(v),'—',formatC(v/scale,format='f',digits=digits,
      big.mark=if(m=='input_tokens') ',' else ''))
    row <- tibble(Metric=labels[i])
    for(arm in paste0(c('ARBITER-','Baseline-'),model)) {
      s <- filter(summaries,.data$arm==.env$arm,metric==m)
      row[[arm]] <- paste0(fmt(s$median),' [',fmt(s$q1),' to ',fmt(s$q3),']')
    }
    d <- filter(differences,metric==m)
    row[['Paired mean difference (95% CI)']] <- paste0(fmt(d$estimate),' (',fmt(d$lower),' to ',fmt(d$upper),')')
    row
  }))
}

bundle_decision_cells <- function(metrics) {
  bind_rows(lapply(which(startsWith(metrics$arm,'ARBITER')),function(i) {
    records <- jsonlite::fromJSON(metrics$domain_decisions_json[i],simplifyVector=FALSE)
    bind_rows(lapply(records,function(d) tibble(arm=metrics$arm[i],slug=metrics$slug[i],
      domain=d$domain,proposed=d$proposed,adopted=d$adopted,algorithm=d$algorithm,
      override=d$override,recorded=d$recorded,rationale=d$rationale,
      evidence=paste(unlist(d$evidence),collapse='; '))))
  }))
}

validate_proposed_gate <- function(decisions,labels) {
  observed <- labels |> filter(startsWith(arm,'ARBITER'),domain!='Overall',!is.na(label)) |>
    left_join(decisions,by=c('arm','slug','domain'))
  if(anyNA(observed$proposed) || any(observed$proposed!=observed$algorithm) ||
    any(observed$adopted!=observed$label) || any(observed$override & !observed$recorded))
    stop('Proposed-judgement bundle validation gate failed')
  overrides <- filter(observed,override)
  if(nrow(overrides)) stop('Unexpected Sonnet override inventory')
  invisible(TRUE)
}

bundle_decision_rates <- function(decisions,labels,weights) {
  observed <- decisions |> inner_join(labels |> filter(startsWith(arm,'ARBITER'),domain!='Overall',!is.na(label)) |>
    select(arm,slug,domain),by=c('arm','slug','domain'))
  bind_rows(lapply(c('D1-D5',paste0('D',1:5)),function(g) {
    x <- if(g=='D1-D5') observed else filter(observed,domain==g)
    bind_rows(lapply(split(x,x$arm),function(a) bind_rows(lapply(
      c('Consistent','Proposed agreement','Recorded override','Violation','Invalid answer path','Departure'),function(s) {
        event <- switch(s,Consistent=a$proposed==a$algorithm,
          `Proposed agreement`=a$proposed==a$algorithm,
          `Recorded override`=a$override & a$recorded,
          `Invalid answer path`=rep(FALSE,nrow(a)),
          a$override & !a$recorded)
        interval_table(share_estimate(a,event,weights)) |> mutate(arm=a$arm[1],status=s,domain=g,
          n=nrow(a),count=sum(event),missing=102L*ifelse(g=='D1-D5',5L,1L)-nrow(a))
      }))))
  }))
}

binding_summary <- function(bindings,weights) {
  bind_rows(lapply(split(bindings,bindings$arm),function(x) {
    w <- bootstrap_rows(x,weights)
    labels <- c('Structural evidence binding (overall)','Text-span evidence binding',
      'Visual evidence binding','Other evidence records','Trials using visual evidence')
    numerators <- c('bound_records','text_bound','visual_bound','other_records','visual_trial')
    denominators <- c('cited_records','text_records','visual_records','cited_records',NA_character_)
    bind_rows(lapply(seq_along(labels),function(i) {
      numerator <- x[[numerators[i]]]
      denominator <- if(is.na(denominators[i])) rep(1,nrow(x)) else x[[denominators[i]]]
      interval_table(rbind(share=colSums(w*numerator)/colSums(w*denominator))) |>
        mutate(arm=x$arm[1],metric=labels[i],n=sum(denominator),count=sum(numerator),note='')
    }))
  }))
}

audit_summary <- function(metrics,weights,bindings=NULL) {
  bind_rows(lapply(split(metrics,metrics$arm),function(x) {
    if(!startsWith(x$arm[1],'ARBITER')) return(tibble(arm=x$arm[1],metric=c('Evidence coverage','Bundle verification'),
      estimate=NA_real_,lower=NA_real_,upper=NA_real_,valid_replicates=0L,n=NA_real_,count=NA_real_,note='Not available'))
    w <- bootstrap_rows(x,weights)
    evidence <- rbind(share=colSums(w*ifelse(is.na(x$evidenced_active_answers),0,x$evidenced_active_answers)) /
      colSums(w*ifelse(is.na(x$active_answers),0,x$active_answers)))
    valid <- !is.na(x$verification_passed)
    bind_rows(interval_table(evidence) |> mutate(metric='Evidence coverage',n=sum(x$active_answers,na.rm=TRUE),
      count=sum(x$evidenced_active_answers,na.rm=TRUE)),
      interval_table(share_estimate(x,!is.na(x$verification_passed)&x$verification_passed,weights,valid)) |>
        mutate(metric='Bundle verification',n=sum(valid),count=sum(x$verification_passed,na.rm=TRUE))) |>
      mutate(arm=x$arm[1],note='')
  })) |> bind_rows(if(!is.null(bindings)) binding_summary(bindings,weights))
}

evidence_distribution <- function(metrics) {
  x <- bind_rows(lapply(which(startsWith(metrics$arm,'ARBITER')),function(i) {
    d <- jsonlite::fromJSON(metrics$basis_distribution_json[i])
    if(!length(d)) return(NULL)
    as_tibble(d) |> mutate(arm=metrics$arm[i])
  })) |> group_by(arm,bases) |> summarise(answers=sum(answers),.groups='drop') |>
    group_by(arm) |> mutate(share=answers/sum(answers)) |> ungroup()
  x
}
