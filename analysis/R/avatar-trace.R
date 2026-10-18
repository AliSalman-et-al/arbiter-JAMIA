trace_quote_chunks <- function(text) {
  if(!nzchar(text)) return('')
  chunks <- character(); start <- 1L
  while(start<=nchar(text)) {
    end <- min(start+799L,nchar(text))
    breaks <- gregexpr('\n',substr(text,start,end),fixed=TRUE)[[1]]
    breaks <- breaks[breaks>0]
    if(length(breaks)>=18L) end <- start+breaks[18L]-1L
    chunks <- c(chunks,substr(text,start,end)); start <- end+1L
  }
  chunks
}
# Complete trace is sourced only from the committed bundle projection and rationale.
avatar_trace_blocks <- function(inputs) {
  d <- jsonlite::fromJSON('data-derived/avatar-trace.json',simplifyVector=FALSE)
  rationale <- jsonlite::fromJSON('data-derived/avatar-unassisted-rationale.json')
  mapping <- question_map()
  sources <- d$batch$trials[[1]]$sources
  source_labels <- setNames(vapply(sources,function(s) s$label,character(1)),vapply(sources,function(s) s$id,character(1)))
  judg <- function(x) c(low='Low',some_concerns='Some concerns',high='High')[[x]]
  requested <- '../no-kit-sonnet-5.5/results-102/model-signalling-answers.csv'
  versioned <- '../no-kit-sonnet-5.5/model-signalling-answers.csv'
  if(file.exists(requested)) stopifnot(identical(readBin(requested,'raw',file.info(requested)$size),readBin(versioned,'raw',file.info(versioned)$size)))
  unassisted <- read_input(if(file.exists(requested)) requested else versioned) |> mutate(question=question_id)
  blocks <- list()
  add <- function(title,x) blocks[[length(blocks)+1L]] <<- list(title=title,data=x)
  rows <- function(field,a='',u='') tibble(Field=field,`ARBITER (Sonnet 5.5)`=a,`Unassisted (Sonnet 5.5)`=u)
  for(domain in paste0('D',1:5)) {
    qs <- mapping$question[startsWith(mapping$question,substring(domain,2))]
    rec <- Filter(function(r) any(vapply(r$answers,function(a) a$question_id %in% mapping$question_id[mapping$question %in% qs],logical(1))),d$domain_records)[[1]]
    un <- unassisted |> filter(slug=='banovic26-avatar-2024',.data$domain==.env$domain)
    ul <- inputs$labels |> filter(slug=='banovic26-avatar-2024',arm=='Baseline-Sonnet',.data$domain==.env$domain)
    add(paste(domain,'judgements and rationale'),bind_rows(
      rows('Proposed / adopted',paste(judg(rec$decision$proposed),judg(rec$decision$adopted),sep=' / '),ul$label),
      rows('Domain rationale','Per-question justifications follow.',rationale[[domain]])))
    for(q in qs) {
      id <- mapping$question_id[mapping$question==q]
      a <- Filter(function(x) x$question_id==id,rec$answers)
      u <- un$answer[un$question==q]
      if(length(u)!=1L) stop('Missing Unassisted answer: ',q)
      if(!length(a)) {
        add(paste('Question',q),rows('Answer / activity','Not applicable; inactive (branching)',u)); next
      }
      a <- a[[1]]
      out <- bind_rows(rows('Answer / activity',paste(gsub('_',' ',a$answer,fixed=TRUE),if(id %in% unlist(rec$active_questions)) 'active' else 'inactive',sep='; '),gsub('_',' ',u,fixed=TRUE)),
        rows('Justification',a$justification),rows('Unknowns',if(length(a$unknowns)) paste(unlist(a$unknowns),collapse='; ') else 'None recorded'))
      for(i in seq_along(a$bases)) {
        basis <- a$bases[[i]]; e <- d$proposal$evidence[[basis$evidence]]
        stopifnot(!is.null(e))
        out <- bind_rows(out,rows(paste('Basis',i),gsub('_',' ',basis$kind,fixed=TRUE)),
          rows('Source',paste0(source_labels[[e$source_id]],'; page ',e$page,'; lines ',e$start_line,'–',e$end_line,
            '; source hash ',substr(sub('sha256:','',e$source_version,fixed=TRUE),1,12),'; evidence hash ',substr(sub('sha256:','',basis$evidence,fixed=TRUE),1,12))))
        quote <- e$quote
        if(is.null(quote)) quote <- e$transcription
        if(is.null(quote)) quote <- ''
        # Bound both characters and explicit lines: extracted tables may have many short lines.
        chunks <- trace_quote_chunks(quote)
        for(j in seq_along(chunks)) out <- bind_rows(out,rows(paste0('Full quote ',i,if(length(chunks)>1) paste0(' (',j,'/',length(chunks),')') else ''),chunks[j]))
      }
      if(length(a$counterevidence)) out <- bind_rows(out,rows('Counterevidence',paste(vapply(a$counterevidence,function(c) paste0('Basis ',c$basis_index,': ',c$implication),character(1)),collapse='; ')))
      add(paste('Question',q),out)
    }
  }
  overall <- d$snapshots[['banovic26-avatar-2024']]$aggregation
  unassisted_overall <- inputs$labels |> filter(slug=='banovic26-avatar-2024',arm=='Baseline-Sonnet',domain=='Overall') |> pull(label)
  stopifnot(length(unassisted_overall)==1L)
  add('Overall',rows('Proposed / adopted',paste(judg(overall$proposed),judg(overall$adopted),overall$rule,sep=' / '),unassisted_overall))
  blocks
}
