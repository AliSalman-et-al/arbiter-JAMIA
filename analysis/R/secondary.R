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

