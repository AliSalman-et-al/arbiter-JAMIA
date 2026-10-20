consistency_rates <- function(checks,weights) {
  bind_rows(lapply(split(checks,checks$arm),function(x) {
    evaluable <- x$status!='Not evaluable'
    statuses <- if('domain' %in% names(x)) c('Consistent','Violation','Invalid answer path','Departure') else
      c('Consistent','Permitted escalation','Violation')
    bind_rows(lapply(statuses,function(s) {
      event <- if(s=='Departure') x$status %in% c('Violation','Invalid answer path') else x$status==s
      interval_table(share_estimate(x,event,weights,evaluable)) |>
        mutate(arm=x$arm[1],status=s,n=sum(evaluable),count=sum(event),
          missing=sum(!evaluable))
    }))
  }))
}

overall_checks <- function(labels) {
  meta <- labels |> filter(arm=='ARBITER-Sonnet') |> mutate(label=meta,arm='Meta')
  bind_rows(labels,meta) |> select(arm,slug,domain,label) |>
    pivot_wider(names_from=domain,values_from=label) |> rowwise() |>
    mutate(status=overall_consistency(c_across(D1:D5),Overall)) |> ungroup() |>
    select(arm,slug,status)
}

consistency_rates <- function(checks,weights) {
  bind_rows(lapply(split(checks,checks$arm),function(x) {
    evaluable <- x$status!='Not evaluable'
    statuses <- if('domain' %in% names(x)) c('Consistent','Violation','Invalid answer path','Departure') else
      c('Consistent','Permitted escalation','Violation')
    bind_rows(lapply(statuses,function(s) {
      event <- if(s=='Departure') x$status %in% c('Violation','Invalid answer path') else x$status==s
      interval_table(share_estimate(x,event,weights,evaluable)) |>
        mutate(arm=x$arm[1],status=s,n=sum(evaluable),count=sum(event),
          missing=sum(!evaluable))
    }))
  }))
}

meta_leniency <- function(cells,weights) {
  x <- cells |> filter(consensus)
  delta <- match(x$meta,LABELS)-match(x$preferred,LABELS)
  bind_rows(lapply(c('Less severe','Equal','More severe'),function(s) {
    event <- switch(s,`Less severe`=delta<0,Equal=delta==0,`More severe`=delta>0)
    interval_table(share_estimate(x,event,weights)) |> mutate(direction=s,n=nrow(x),count=sum(event))
  }))
}

independent_signals <- function(adjud) {
  short <- c(Y='Y/PY',PY='Y/PY',N='N/PN',PN='N/PN',NI='NI/NA','NA'='NI/NA')
  bind_rows(lapply(seq_len(nrow(adjud)),function(i) {
    s <- adjud$signalling_answers_independent[i]
    if(is.na(s)) return(NULL)
    tokens <- regmatches(s,gregexpr('[1-5]\\.[1-7]\\s*=\\s*(PY|PN|NI|NA|Y|N)',s,perl=TRUE))[[1]]
    if(!length(tokens)) return(NULL)
    tibble(slug=adjud$slug[i],domain=adjud$domain[i],adjudicator=adjud$adjudicator[i],
      question=sub('\\s*=.*','',tokens),
      reference=unname(short[sub('.*=\\s*','',tokens)]))
  }))
}

