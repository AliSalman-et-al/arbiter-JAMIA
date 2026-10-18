# Complete trace is sourced only from the committed bundle projection and rationale.
avatar_trace_blocks <- function(inputs) {
  d <- jsonlite::fromJSON('data-derived/avatar-trace.json',simplifyVector=FALSE)
  rationale <- jsonlite::fromJSON('data-derived/avatar-unassisted-rationale.json')
  mapping <- question_map(TRUE)
  sources <- d$batch$trials[[1]]$sources
  source_labels <- setNames(vapply(sources,function(s) s$label,character(1)),vapply(sources,function(s) s$id,character(1)))
  judg <- function(x) c(low='Low',some_concerns='Some concerns',high='High')[[x]]
  requested <- '../no-kit-sonnet-5.5/results-102/model-signalling-answers.csv'
  versioned <- '../no-kit-sonnet-5.5/model-signalling-answers.csv'
  if(file.exists(requested)) stopifnot(identical(readBin(requested,'raw',file.info(requested)$size),readBin(versioned,'raw',file.info(versioned)$size)))
  unassisted <- read_input(if(file.exists(requested)) requested else versioned) |> mutate(question=question_id)
  row <- function(q,a='',h='',j='',u='',c='',un='') tibble(
    Question=q,ARBITER=a,`Evidence handles (type)`=h,Justification=j,Unknowns=u,Counterevidence=c,Unassisted=un)
  answers <- list()
  for(domain in paste0('D',1:5)) {
    qs <- mapping$question[startsWith(mapping$question,substring(domain,2))]
    rec <- Filter(function(r) any(vapply(r$answers,function(a) a$question_id %in% mapping$question_id[mapping$question %in% qs],logical(1))),d$domain_records)[[1]]
    un <- unassisted |> filter(slug=='banovic26-avatar-2024',.data$domain==.env$domain)
    ul <- inputs$labels |> filter(slug=='banovic26-avatar-2024',arm=='Baseline-Sonnet',.data$domain==.env$domain)
    answers[[length(answers)+1L]] <- row(paste(domain,'judgement / rationale'),
      paste0('Proposed: ',judg(rec$decision$proposed),'; adopted: ',judg(rec$decision$adopted)),
      un=paste0(ul$label,'\n',rationale[[domain]]))
    for(q in qs) {
      id <- mapping$question_id[mapping$question==q]
      a <- Filter(function(x) x$question_id==id,rec$answers)
      u <- un$answer[un$question==q]
      if(length(u)!=1L) stop('Missing Unassisted answer: ',q)
      wording <- mapping$short_text[mapping$question==q]
      wording <- sub('Baseline imbalance','Preintervention imbalance',wording,fixed=TRUE)
      if(!length(a)) {
        answers[[length(answers)+1L]] <- row(paste(q,wording),'Not asked (inactive; branching)',un=u)
        next
      }
      a <- a[[1]]
      handles <- vapply(a$bases,function(b) {
        paste0(d$proposal$evidence[[b$evidence]]$handle,' (',gsub('_',' ',b$kind,fixed=TRUE),')')
      },character(1))
      counter <- if(length(a$counterevidence)) paste(vapply(a$counterevidence,function(c)
        paste0('Basis ',c$basis_index,': ',c$implication),character(1)),collapse='; ') else 'None recorded'
      answers[[length(answers)+1L]] <- row(paste(q,wording),
        if(id %in% unlist(rec$active_questions)) gsub('_',' ',a$answer,fixed=TRUE) else 'Not asked (inactive; branching)',
        paste(handles,collapse='; '),a$justification,
        if(length(a$unknowns)) paste(unlist(a$unknowns),collapse='; ') else 'None recorded',counter,u)
    }
  }
  overall <- d$snapshots[['banovic26-avatar-2024']]$aggregation
  uo <- inputs$labels |> filter(slug=='banovic26-avatar-2024',arm=='Baseline-Sonnet',domain=='Overall') |> pull(label)
  stopifnot(length(uo)==1L)
  answers[[length(answers)+1L]] <- row('Overall',paste0('Proposed: ',judg(overall$proposed),'; adopted: ',judg(overall$adopted)),j='Any domain Some concerns, with no High domain: Overall Some concerns.',un=uo)
  evidence <- bind_rows(lapply(names(d$proposal$evidence),function(key) {
    e <- d$proposal$evidence[[key]]
    quote <- if(!is.null(e$quote)) e$quote else e$transcription
    tibble(Handle=e$handle,Source=source_labels[[e$source_id]],Page=as.character(e$page),
      Lines=paste(e$start_line,e$end_line,sep='–'),`Source-version hash`=substr(sub('sha256:','',e$source_version,fixed=TRUE),1,12),
      `Full verbatim quote`=quote)
  }))
  stopifnot(nrow(evidence)==16L,!anyDuplicated(evidence$Handle))
  list(list(title='Part A. Answers and judgements',data=bind_rows(answers)),
    list(title='Part B. Evidence records',data=evidence))
}
