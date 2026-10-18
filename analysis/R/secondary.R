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
    bind_rows(lapply(c('Consistent','Permitted escalation','Violation'),function(s)
      interval_table(share_estimate(x,x$status==s,weights,evaluable)) |>
        mutate(arm=x$arm[1],status=s,n=sum(evaluable),count=sum(x$status==s),
          missing=sum(!evaluable))))
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

signalling_agreement <- function(inputs,weights) {
  reference <- independent_signals(inputs$adjud)
  collapse <- c(yes='Y/PY',probably_yes='Y/PY',no='N/PN',probably_no='N/PN',
    no_information='NI/NA',not_applicable='NI/NA')
  # The independent questions define eligibility, including an explicit NA answer.
  x <- reference |> inner_join(inputs$signals |> select(arm,slug,domain,question,answer),
    by=c('slug','domain','question'),relationship='many-to-many') |>
    mutate(prediction=unname(collapse[answer]),correct=!is.na(prediction)&prediction==reference)
  bind_rows(lapply(split(x,interaction(x$arm,x$adjudicator,x$question,drop=TRUE)),function(d)
    interval_table(share_estimate(d,d$correct,weights)) |> mutate(arm=d$arm[1],
      adjudicator=d$adjudicator[1],question=d$question[1],n=nrow(d),correct=sum(d$correct))))
}

