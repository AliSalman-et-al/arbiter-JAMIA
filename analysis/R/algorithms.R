# Independent transcription of full guidance (22 August 2019), tables 4, 6,
# 10, 12 and 14. Cross-check: ARBITER 2f549ae, logic/evaluator.py.
domain_algorithm <- function(domain, answers) {
  a <- function(q) { x <- answers[q]; if(!length(x)||is.na(x)) NA_character_ else unname(x) }
  y <- function(q) a(q) %in% c('yes','probably_yes')
  n <- function(q) a(q) %in% c('no','probably_no')
  ni <- function(q) a(q) %in% 'no_information'
  yn <- function(q) y(q)||ni(q)
  nn <- function(q) n(q)||ni(q)
  # Return missing for absent required root questions; never infer an answer.
  roots <- switch(domain,D1=c('1.1','1.2','1.3'),D2=c('2.1','2.2','2.6'),
    D3='3.1',D4=c('4.1','4.2'),D5=c('5.1','5.2','5.3'))
  if(any(vapply(roots,function(q) is.na(a(q))||a(q)=='not_applicable',logical(1)))) return(NA_character_)
  if(domain=='D1') {
    if(n('1.2')||(ni('1.2')&&y('1.3'))) return('High')
    if(n('1.1')||ni('1.2')||y('1.3')) return('Some concerns')
    return('Low')
  }
  if(domain=='D2') {
    part1 <- 'Low'
    if(yn('2.1')||yn('2.2')) {
      if(ni('2.3')) part1 <- 'Some concerns'
      else if(y('2.3')) {
        if(n('2.4')||y('2.5')) part1 <- 'Some concerns'
        else if(yn('2.4')&&nn('2.5')) part1 <- 'High'
        else return(NA_character_)
      } else if(!n('2.3')) return(NA_character_)
    }
    part2 <- if(y('2.6')) 'Low' else if(n('2.7')) 'Some concerns' else if(yn('2.7')) 'High' else NA_character_
    if(is.na(part2)) return(NA_character_)
    return(LABELS[max(match(c(part1,part2),LABELS))])
  }
  if(domain=='D3') {
    if(y('3.1')) return('Low')
    if(y('3.2')||n('3.3')) return('Low')
    if(yn('3.4')) return('High')
    if(n('3.4')) return('Some concerns')
    return(NA_character_)
  }
  if(domain=='D4') {
    if(y('4.1')||y('4.2')) return('High')
    if(n('4.3')||n('4.4')) return(if(ni('4.2')) 'Some concerns' else 'Low')
    if(yn('4.5')) return('High')
    if(n('4.5')) return('Some concerns')
    return(NA_character_)
  }
  if(y('5.2')||y('5.3')) return('High')
  if(nn('5.1')||ni('5.2')||ni('5.3')) return('Some concerns')
  'Low'
}
overall_consistency <- function(domains, overall) {
  if(anyNA(c(domains,overall))) return('Not evaluable')
  worst <- LABELS[max(match(domains,LABELS))]
  if(overall==worst) 'Consistent' else if(overall=='High' && !'High' %in% domains &&
    sum(domains=='Some concerns')>=2) 'Permitted escalation' else 'Violation'
}
domain_checks <- function(inputs) {
  calculated <- inputs$signals |> group_by(arm,slug,domain) |>
    summarise(algorithm=domain_algorithm(first(domain),setNames(answer[active],question[active])),.groups='drop')
  inputs$labels |> filter(domain!='Overall') |>
    left_join(calculated,by=c('arm','slug','domain')) |>
    mutate(status=case_when(is.na(label)|is.na(algorithm)~'Not evaluable',
      label==algorithm~'Consistent',TRUE~'Violation'))
}
validate_gate <- function(checks) {
  sonnet <- checks |> filter(arm=='ARBITER-Sonnet',status!='Consistent')
  haiku <- checks |> filter(arm=='ARBITER-Haiku',status=='Violation')
  missing <- checks |> filter(arm=='ARBITER-Haiku',status=='Not evaluable')
  # The amended gate allows only the independently established exception.
  isolated <- nrow(haiku)==0L || (nrow(haiku)==1L && haiku$slug=='hill-2017' &&
    haiku$domain=='D1' && haiku$algorithm=='Low' && haiku$label=='Some concerns')
  unfinished <- all(missing$slug=='award-1-2014' & is.na(missing$label) & is.na(missing$algorithm))
  if(nrow(sonnet) || !isolated || !unfinished)
    stop('Section 5.4 validation gate failed: unexpected ARBITER inconsistency.',call.=FALSE)
  invisible(TRUE)
}
