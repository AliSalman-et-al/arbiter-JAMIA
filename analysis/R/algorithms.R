# Independent transcription of full guidance (22 August 2019), tables 4, 6,
# 10, 12 and 14. Cross-check: ARBITER 2f549ae, logic/evaluator.py.
domain_algorithm <- function(domain, answers) {
  if(length(invalid_required_questions(domain,answers))) return(NA_character_)
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
    summarise(algorithm=domain_algorithm(first(domain),setNames(answer[active],question[active])),
      answered=sum(active & !is.na(answer) & answer!=''),.groups='drop')
  inputs$labels |> filter(domain!='Overall') |>
    left_join(calculated,by=c('arm','slug','domain')) |>
    mutate(status=case_when(is.na(label)|is.na(answered)|answered==0~'Not evaluable',
      is.na(algorithm)~'Invalid answer path',
      label==algorithm~'Consistent',startsWith(arm,'ARBITER')~'Reported departure',TRUE~'Violation'))
}

# Follow the conditional path in question order. A later answer never repairs
# an absent or NA answer to an earlier required question.
invalid_required_questions <- function(domain,answers) {
  bad <- character()
  get <- function(q) {
    v <- unname(answers[q])
    if(!length(v)||is.na(v)||!v %in% c('yes','probably_yes','no','probably_no','no_information')) {
      bad <<- c(bad,q); return('invalid')
    }
    v
  }
  y <- function(v) v %in% c('yes','probably_yes')
  n <- function(v) v %in% c('no','probably_no')
  if(domain=='D1') for(q in c('1.1','1.2','1.3')) get(q)
  if(domain=='D2') {
    a <- get('2.1'); b <- get('2.2'); c <- get('2.6')
    if(y(a)||a=='no_information'||y(b)||b=='no_information') {
      d <- get('2.3')
      if(y(d)) {
        e <- get('2.4')
        if(!n(e) && e!='invalid') get('2.5')
      }
    }
    if(!y(c) && c!='invalid') get('2.7')
  }
  if(domain=='D3') {
    a <- get('3.1')
    if(!y(a) && a!='invalid') {
      b <- get('3.2')
      if(!y(b) && b!='invalid') {
        c <- get('3.3')
        if(!n(c) && c!='invalid') get('3.4')
      }
    }
  }
  if(domain=='D4') {
    a <- get('4.1'); b <- get('4.2')
    if(!y(a) && !y(b) && !'invalid' %in% c(a,b)) {
      c <- get('4.3')
      if(!n(c) && c!='invalid') {
        d <- get('4.4')
        if(!n(d) && d!='invalid') get('4.5')
      }
    }
  }
  if(domain=='D5') for(q in c('5.1','5.2','5.3')) get(q)
  unique(bad)
}

resolve_invalid_path <- function(domain,answers,replacement) {
  for(i in seq_len(7)) {
    bad <- invalid_required_questions(domain,answers)
    if(!length(bad)) return(domain_algorithm(domain,answers))
    answers[bad] <- replacement
  }
  stop('Answer path did not resolve')
}

invalid_path_sensitivity <- function(inputs,checks) {
  invalid <- checks |> filter(status=='Invalid answer path')
  bind_rows(lapply(c('no','no_information'),function(replacement) {
    resolved <- vapply(seq_len(nrow(invalid)),function(i) {
      x <- inputs$signals |> filter(arm==invalid$arm[i],slug==invalid$slug[i],domain==invalid$domain[i],active)
      resolve_invalid_path(invalid$domain[i],setNames(x$answer,x$question),replacement)
    },character(1))
    extra <- invalid |> mutate(resolved=resolved,violation=label!=resolved)
    bind_rows(lapply(c('D1-D5',paste0('D',1:5)),function(d) {
      x <- if(d=='D1-D5') checks else filter(checks,domain==d)
      e <- if(d=='D1-D5') extra else filter(extra,domain==d)
      x |> filter(startsWith(arm,'Baseline')) |> group_by(arm) |>
        summarise(n=sum(status!='Not evaluable'),original_violations=sum(status=='Violation'),
          invalid_paths=sum(status=='Invalid answer path'),.groups='drop') |>
        left_join(e |> group_by(arm) |> summarise(additional_violations=sum(violation),.groups='drop'),by='arm') |>
        mutate(domain=d,resolution=ifelse(replacement=='no','N/PN','NI'),
          additional_violations=coalesce(additional_violations,0L),
          violations=original_violations+additional_violations)
    }))
  }))
}
validate_gate <- function(checks) {
  sonnet <- checks |> filter(arm=='ARBITER-Sonnet',status!='Consistent')
  if(nrow(sonnet)) stop('Section 5.4 validation gate failed: unexpected ARBITER inconsistency.',call.=FALSE)
  invisible(TRUE)
}

# Canonical Overall is the worst domain; optional escalation is never imposed.
derived_overall <- function(domains) {
  if(length(domains)!=5L || anyNA(domains) || any(!domains %in% LABELS)) return(NA_character_)
  LABELS[max(match(domains,LABELS))]
}
