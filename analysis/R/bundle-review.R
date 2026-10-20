# Explicit, reproducible bundle-only extraction; reports read the derived CSVs.
answer_abbreviation <- function(x) unname(c(yes='Y',probably_yes='PY',probably_no='PN',
  no='N',no_information='NI',not_applicable='NA')[x])

evidence_kind <- function(e) {
  if(!is.list(e)) return('other')
  # Visual takes precedence for hybrid records, so each citation counts once.
  if(identical(e$kind,'figure') || 'render' %in% names(e)) return('visual')
  if(identical(e$kind,'narrative') || any(c('quote','start','end') %in% names(e))) return('text')
  'other'
}

evidence_is_bound <- function(e,source_ids) {
  text_present <- function(x) is.character(x) && length(x)==1L && !is.na(x) && nzchar(trimws(x))
  number_present <- function(x) is.numeric(x) && length(x)==1L && is.finite(x)
  kind <- evidence_kind(e)
  if(kind=='other') return(FALSE)
  source_matches <- text_present(e$source_id) && e$source_id %in% source_ids
  if(kind=='visual') {
    r <- e$render
    if(!is.list(r)) return(FALSE)
    region <- e$region
    if(is.list(region) && length(region)==4L && all(vapply(region,number_present,logical(1))))
      region <- unlist(region,use.names=FALSE)
    return(source_matches && text_present(r$source_id) && r$source_id==e$source_id &&
      number_present(r$page) && r$page>0 && r$page==floor(r$page) && text_present(r$png_sha256) &&
      is.numeric(region) && length(region)==4L && all(is.finite(region)) &&
      all(region>=0 & region<=1) && region[1]<region[3] && region[2]<region[4] &&
      text_present(e$transcription))
  }
  text_present(e$quote) && source_matches && text_present(e$source_version) && number_present(e$page) &&
    number_present(e$start) && number_present(e$end) && e$start < e$end
}

bundle_binding_counts <- function(canonical,evidence) {
  # Current domain records only; historical answers are not analysis answers.
  cited <- unique(unlist(lapply(canonical$domain_records,function(d) {
    active <- Filter(function(a) a$question_id %in% unlist(d$active_questions),d$answers)
    unlist(lapply(active,function(a) vapply(c(a$bases,a$counterevidence),function(b)
      if(is.null(b$evidence)) NA_character_ else b$evidence,character(1))),use.names=FALSE)
  }),use.names=FALSE))
  cited <- cited[!is.na(cited)]
  sources <- unlist(lapply(canonical$batch$trials,function(t)
    vapply(t$sources,function(s) s$id,character(1))),use.names=FALSE)
  # Missing cited records remain unbound and are counted explicitly as other.
  kinds <- vapply(cited,function(id) evidence_kind(evidence[[id]]),character(1))
  bound <- vapply(cited,function(id) evidence_is_bound(evidence[[id]],sources),logical(1))
  c(cited_records=length(cited),bound_records=sum(bound),
    text_records=sum(kinds=='text'),text_bound=sum(bound & kinds=='text'),
    visual_records=sum(kinds=='visual'),visual_bound=sum(bound & kinds=='visual'),
    other_records=sum(kinds=='other'),visual_trial=as.integer(any(kinds=='visual')))
}

bundle_review_records <- function(canonical,arm,slug) {
  mapping <- c('domain:randomization'='D1','domain:deviations'='D2','domain:missing'='D3',
    'domain:measurement'='D4','domain:selection'='D5')
  bind_rows(lapply(canonical$domain_history_records,function(history) bind_rows(lapply(history,function(d) {
    active <- unlist(d$active_questions,use.names=FALSE)
    a <- d$answers[vapply(d$answers,function(a) a$question_id %in% active,logical(1))]
    ids <- vapply(a,function(a) a$question_id,character(1))
    answers <- setNames(vapply(a,function(a) a$answer,character(1)),
      question_map()$question[match(ids,question_map()$question_id)])
    domain <- unname(mapping[d$domain_id])
    final <- canonical$domain_records[[paste0(slug,':',d$domain_id)]]
    tibble(arm=arm,slug=slug,domain=domain,record=d$identity,
      final=identical(d$identity,final$identity),active_questions=length(active),
      active_answered=sum(active %in% ids),
      invalid_path=length(invalid_required_questions(domain,answers))>0L,
      invalid_active_answer=any(!answers %in% c('yes','probably_yes','no','probably_no','no_information')))
  }))))
}

extract_bundle_review <- function(inputs,root='..',output='data-derived') {
  paths <- bindings <- list()
  for(arm in names(ARMS)[startsWith(names(ARMS),'ARBITER')]) for(slug in inputs$trials$slug) {
    path <- file.path(root,ARMS[[arm]],'bundles',paste0(slug,'.rob2.zip'))
    if(!file.exists(path)) stop('Bundle absent: ',path)
    canonical <- json_zip(path,'canonical.json')
    entries <- unzip(path,list=TRUE)$Name
    evidence <- list()
    for(entry in entries[grepl('^evidence/.*[.]json$',entries)]) {
      e <- json_zip(path,entry)
      evidence[[e$identity]] <- e
    }
    counts <- bundle_binding_counts(canonical,evidence)
    bindings[[paste(arm,slug)]] <- tibble(arm=arm,slug=slug,
      !!!as.list(counts))
    paths[[paste(arm,slug)]] <- bundle_review_records(canonical,arm,slug)

  }
  checks <- bind_rows(paths)
  stopifnot(!any(checks$invalid_path),!any(checks$invalid_active_answer),
    all(checks$active_questions==checks$active_answered))
  readr::write_csv(checks,file.path(output,'bundle-path-checks.csv'))
  readr::write_csv(bind_rows(bindings),file.path(output,'bundle-binding-counts.csv'))
  invisible(checks)
}
