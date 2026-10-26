# Question numbers are the official effect-of-assignment numbers in both workbooks.
ANSWER_CODES <- c(yes='Y',probably_yes='PY',no='N',probably_no='PN',no_information='NI',not_applicable='NA')
parse_answer_components <- function(text) {
  empty <- tibble(component='',answer=NA_character_,issue='Unresolved answer')
  if(is.na(text)||!nzchar(trimws(text))) return(empty)
  text <- trimws(gsub('\\*','',text))
  if(text %in% c('Y','PY','N','PN','NI','NA')) return(tibble(component='',answer=text,issue=''))
  # Each explicit component must have a name and one unambiguous answer code.
  text <- gsub('\\s*/\\s*(?=\\([a-z]\\))','; ',text,perl=TRUE)
  parts <- strsplit(text,';|(?<=[A-Z])\\.\\s+(?=[A-Z])',perl=TRUE)[[1]]
  out <- bind_rows(lapply(parts,function(p) {
    p <- trimws(sub('^Nested:\\s*','',p))
    m <- regexec('^(.+?)\\s*[:=]\\s*(PY|PN|NI|NA|Y|N)$',p,perl=TRUE); v <- regmatches(p,m)[[1]]
    if(!length(v)) {
      m <- regexec('^(.+?)\\s+(PY|PN|NI|NA|Y|N)$',p,perl=TRUE); v <- regmatches(p,m)[[1]]
    }
    if(!length(v)) {
      m <- regexec('^(PY|PN|NI|NA|Y|N):\\s*(.+)$',p,perl=TRUE); r <- regmatches(p,m)[[1]]
      if(length(r)) v <- c(r[1],r[3],r[2])
    }
    if(!length(v)) return(tibble(component=p,answer=NA_character_,issue='Unresolved component syntax'))
    tibble(component=tolower(trimws(v[2])),answer=v[3],issue='')
  }))
  if(anyDuplicated(out$component)) out$issue <- 'Duplicate component'
  out
}
parse_signalling_evidence <- function(evidence) {
  evidence <- evidence |> filter(phase=='Independent')
  bind_rows(lapply(seq_len(nrow(evidence)),function(i) {
    x <- evidence[i,]
    ans <- parse_answer_components(x$raw_answer)
    bind_cols(x[rep(1,nrow(ans)),],ans)
  }))
}
match_signalling <- function(parsed,signals) {
  ref <- parsed |> filter(phase=='Independent')
  # The exports have one answer per question. A scalar cannot stand for several outcomes.
  arms <- signals |> transmute(slug,domain,question,source=if_else(arm=='ARBITER-Sonnet','ARBITER','Unassisted'),
    arm_raw=if_else(answer %in% names(ANSWER_CODES),unname(ANSWER_CODES[answer]),answer),arm_active=active)
  stopifnot(!anyDuplicated(paste(arms$slug,arms$domain,arms$question,arms$source)))
  arm_parts <- bind_rows(lapply(seq_len(nrow(arms)),function(i) {
    a <- arms[i,]; p <- parse_answer_components(a$arm_raw)
    bind_cols(a[rep(1,nrow(p)),],p |> rename(arm_component=component,arm_answer=answer,arm_issue=issue))
  }))
  arm_parts$component_found <- TRUE
  x <- ref |> cross_join(tibble(source=unique(arm_parts$source))) |>
    left_join(arm_parts,by=c('slug','domain','question','source','component'='arm_component'))
  x |> mutate(component_match=!is.na(component_found),
    evaluable=component_match & issue=='' & arm_issue=='' & arm_active &
      !is.na(answer) & !is.na(arm_answer) & answer!='NA' & arm_answer!='NA',
    reason=case_when(!component_match~'Component not matched',issue!=''~issue,
      !arm_active~'Arm question inactive',answer=='NA'|arm_answer=='NA'~'Not applicable',
      is.na(arm_answer)~'Missing arm answer',TRUE~'Evaluable'),
    five_match=evaluable & answer==arm_answer,
    collapsed_match=evaluable & collapse_signal(answer)==collapse_signal(arm_answer))
}
collapse_signal <- function(x) unname(c(Y='Y/PY',PY='Y/PY',N='N/PN',PN='N/PN',NI='NI','NA'='NA')[x])
signalling_agreement <- function(comparisons,weights) {
  estimates <- differences <- list()
  summaries <- c('Overall',paste0('D',1:5))
  for(a in c('1','2')) for(g in c(summaries,question_map()$question)) {
    d <- comparisons |> filter(adjudicator==a,if(g=='Overall') TRUE else if(startsWith(g,'D')) domain==g else question==g)
    # Paired differences use exactly the same components in both arms.
    paired <- d |> select(slug,domain,question,component,source,evaluable,five_match,collapsed_match) |>
      pivot_wider(names_from=source,values_from=c(evaluable,five_match,collapsed_match)) |>
      filter(evaluable_ARBITER & evaluable_Unassisted)
    for(level in c('five','collapsed')) {
      if(g %in% summaries) for(s in c('ARBITER','Unassisted')) {
        x <- filter(d,source==s,evaluable); event <- x[[paste0(level,'_match')]]
        estimates[[length(estimates)+1L]] <- interval_table(share_estimate(x,event,weights)) |>
          mutate(adjudicator=a,source=s,group=g,level=level,n=nrow(x),count=sum(event))
      }
      delta <- as.integer(paired[[paste0(level,'_match_ARBITER')]])-as.integer(paired[[paste0(level,'_match_Unassisted')]])
      w <- bootstrap_rows(paired,weights)
      differences[[length(differences)+1L]] <- interval_table(rbind(difference=colSums(w*delta)/colSums(w))) |>
        mutate(adjudicator=a,group=g,level=level,n=nrow(paired))
    }
  }
  list(estimates=bind_rows(estimates),differences=bind_rows(differences),
    eligibility=comparisons |> count(adjudicator,source,domain,evaluable,reason,name='count'))
}
