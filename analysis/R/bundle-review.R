# Explicit, reproducible bundle-only extraction; reports read the derived CSVs.
answer_abbreviation <- function(x) unname(c(yes='Y',probably_yes='PY',probably_no='PN',
  no='N',no_information='NI',not_applicable='NA')[x])

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

bundle_trace_records <- function(canonical,slug,eligible) {
  labels <- c(low='Low',some_concerns='Some concerns',high='High')
  sources <- canonical$batch$trials[[1]]$sources
  bind_rows(lapply(seq_len(nrow(eligible)),function(i) {
    cell <- eligible[i,]
    d <- Filter(function(d) paste0('D',match(d$domain_id,c('domain:randomization','domain:deviations',
      'domain:missing','domain:measurement','domain:selection')))==cell$domain,canonical$domain_records)[[1]]
    a <- Filter(function(a) a$question_id %in% unlist(d$active_questions),d$answers)
    answer_set <- paste(vapply(a,function(a) paste0(question_map()$question[
      match(a$question_id,question_map()$question_id)],'=',answer_abbreviation(a$answer)),character(1)),collapse='; ')
    bind_rows(lapply(a,function(a) bind_rows(lapply(a$bases,function(b) {
      if(is.null(b$evidence)) return(NULL)
      e <- canonical$proposal$evidence[[b$evidence]]
      # Evidence files are also included in proposal evidence in these bundles.
      if(is.null(e)||is.null(e$page)||is.null(e$quote)) return(NULL)
      s <- Filter(function(s) s$id==e$source_id,sources)
      if(!length(s)) return(NULL)
      quote <- stringr::str_squish(e$quote)
      words <- strsplit(quote,'\\s+')[[1]]
      # Contiguous prefix only: never construct a quotation from justification.
      passage <- paste(head(words,30),collapse=' ')
      if(length(words)>30) passage <- paste0(passage,' …')
      tibble(slug=slug,domain=cell$domain,meta=cell$meta,ARBITER_label=cell$kit,
        Baseline_label=cell$nokit,preferred=cell$preferred,
        question=question_map()$question[match(a$question_id,question_map()$question_id)],
        answer=answer_abbreviation(a$answer),signalling_answers=answer_set,
        proposed=unname(labels[d$decision$proposed]),passage=passage,
        source=s[[1]]$label,page=e$page,evidence_id=e$identity,full_passage=quote,
        passage_words=min(length(words),30L))
    }))))
  }))
}

extract_bundle_review <- function(inputs,root='..',output='data-derived') {
  cells <- adjudication_cells(inputs) |> filter(consensus,kit==preferred,kit!=meta)
  paths <- traces <- list()
  for(arm in c('ARBITER-Sonnet','ARBITER-Haiku')) for(slug in inputs$trials$slug) {
    path <- file.path(root,ARMS[[arm]],'bundles',paste0(slug,'.rob2.zip'))
    if(!file.exists(path)) stop('Bundle absent: ',path)
    canonical <- json_zip(path,'canonical.json')
    paths[[paste(arm,slug)]] <- bundle_review_records(canonical,arm,slug)
    eligible <- filter(cells,.data$slug==.env$slug)
    if(arm=='ARBITER-Sonnet' && nrow(eligible)) {
      entries <- unzip(path,list=TRUE)$Name
      for(entry in entries[grepl('^evidence/',entries)]) {
        e <- json_zip(path,entry)
        canonical$proposal$evidence[[e$identity]] <- e
      }
      verification <- json_zip(path,'verification.json')
      traces[[slug]] <- bundle_trace_records(canonical,slug,eligible) |>
        mutate(verification_status=verification$result,
          verification_checks=paste(unlist(verification$checks),collapse='; '),
          verification_scope='Bundle-level; no passage-level match status recorded')
    }
  }
  checks <- bind_rows(paths)
  stopifnot(!any(checks$invalid_path),!any(checks$invalid_active_answer),
    all(checks$active_questions==checks$active_answered))
  readr::write_csv(checks,file.path(output,'bundle-path-checks.csv'))
  readr::write_csv(bind_rows(traces),file.path(output,'bundle-trace-evidence.csv'))
  invisible(checks)
}
