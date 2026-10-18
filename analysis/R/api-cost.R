# Frozen rate card from binding plan section 5.8 (2026-10-18).
haiku_tier <- function(prompt_tokens) ifelse(prompt_tokens>100000,'high','low')
api_rates <- function(model,tier='low',side_5m=FALSE) {
  if(model=='Sonnet') return(c(input=2,write1=if(side_5m) 2.5 else 4,write5=2.5,read=.1,output=10))
  if(tier=='high') c(input=.5,write1=if(side_5m) .625 else 1,write5=.625,read=.05,output=2.5) else
    c(input=.1,write1=if(side_5m) .125 else .2,write5=.125,read=.01,output=.5)
}
api_cost_bounds <- function(requests,result,side,model,compactions,side_5m=FALSE) {
  # Input columns have final request counts; output comes only from result.usage.
  stopifnot(all(requests>=0),all(result>=0),all(side>=0))
  totals <- colSums(requests)
  gap <- result[c('input','write1','write5','read')]-totals
  tiers <- haiku_tier(rowSums(requests))
  high_share <- if(length(tiers)) mean(tiers=='high') else 0
  low <- api_rates(model,'low',side_5m); high <- api_rates(model,'high',side_5m)
  fixed <- sum(vapply(seq_len(nrow(requests)),function(i)
    sum(requests[i,]*api_rates(model,tiers[i])[colnames(requests)]),numeric(1)))
  cost <- function(bound) {
    share <- switch(bound,lower=0,point=high_share,upper=1)
    rate <- low*(1-share)+high*share
    side_rate <- if(compactions>0) high else rate
    (fixed+sum(gap*rate[names(gap)])+result['output']*rate['output']+
      sum(side*side_rate[names(side)]))/1000000
  }
  c(lower=unname(cost('lower')),point=unname(cost('point')),upper=unname(cost('upper')))
}
usage_vector <- function(u) {
  get <- function(x) if(is.null(x)) 0 else as.numeric(x)
  c(input=get(u$input_tokens),write1=get(u$cache_creation$ephemeral_1h_input_tokens),
    write5=get(u$cache_creation$ephemeral_5m_input_tokens),read=get(u$cache_read_input_tokens),
    output=get(u$output_tokens))
}
read_cost_turn <- function(path,model) {
  if(!file.exists(path)) stop('Missing turn log: ',path)
  con <- file(path,'rb'); on.exit(close(con))
  requests <- list(); result <- NULL; compactions <- 0L
  repeat {
    lines <- readLines(con,n=100,warn=FALSE)
    if(!length(lines)) break
    for(line in lines) {
      # Avoid parsing large tool payloads; no cost information is taken from them.
      if(!grepl('"type"\\s*:\\s*"(assistant|result)"|"compact_boundary"',line,perl=TRUE)) next
      x <- parse_json_text(line)
      if(identical(x$subtype,'compact_boundary')) compactions <- compactions+1L
      if(identical(x$type,'assistant') && is.null(x$parent_tool_use_id)) {
        id <- x$message$id
        if(is.null(requests[[id]])) {
          u <- x$message$usage
          if(sum(usage_vector(u))==0) next # synthetic error messages are not API requests
          if(!is.null(u$inference_geo) && !identical(u$inference_geo,'global')) stop('Non-global routing: ',path)
          if(is.null(u$inference_geo) && sum(usage_vector(u))>0) stop('Missing routing: ',path)
          v <- usage_vector(u)
          stopifnot(v['write1']+v['write5']==u$cache_creation_input_tokens)
          requests[[id]] <- v[c('input','write1','write5','read')]
        } else if(!identical(unname(usage_vector(x$message$usage)[c('input','write1','write5','read')]),
          unname(requests[[id]]))) stop('Input counters changed across snapshots: ',path)
      }
      if(identical(x$type,'result')) {
        if(!is.null(result)) stop('Multiple terminal results: ',path)
        result <- x
      }
    }
  }
  if(is.null(result)) stop('Missing terminal result: ',path)
  r <- usage_vector(result$usage)
  stopifnot(r['write1']+r['write5']==result$usage$cache_creation_input_tokens)
  mu <- result$modelUsage
  model_total <- colSums(do.call(rbind,lapply(mu,function(m) c(input=m$inputTokens,
    write1=m$cacheCreationInputTokens,write5=0,read=m$cacheReadInputTokens,output=m$outputTokens))))
  # modelUsage does not split cache writes; all observed main-thread writes are 1 hour.
  stopifnot(r['write5']==0)
  side <- model_total-r
  req <- if(length(requests)) do.call(rbind,requests) else matrix(0,0,4,
    dimnames=list(NULL,c('input','write1','write5','read')))
  bounds <- api_cost_bounds(req,r,side,model,compactions)
  sensitivity <- api_cost_bounds(req,r,side,model,compactions,TRUE)
  fields <- c(setNames(colSums(req),paste0('request_',colnames(req))),
    setNames(r,paste0('result_',names(r))),setNames(side,paste0('side_',names(side))),
    setNames(r[c('input','write1','write5','read')]-colSums(req),paste0('gap_',colnames(req))))
  tibble::as_tibble_row(c(as.list(fields),list(requests=nrow(req),high_requests=sum(haiku_tier(rowSums(req))=='high'),
    compaction_events=compactions,side_without_compaction=any(side>0)&&compactions==0,
    point=bounds['point'],lower=bounds['lower'],upper=bounds['upper'],
    side_5m_point=sensitivity['point'],side_5m_lower=sensitivity['lower'],side_5m_upper=sensitivity['upper'],
    harness=result$total_cost_usd)))
}
extract_api_costs <- function(root='..',output='data-derived') {
  inputs <- load_inputs(root)
  rows <- list()
  for(arm in names(ARMS)) {
    for(slug in inputs$trials$slug) {
      dir <- file.path(root,ARMS[[arm]],'logs',slug)
      if(!dir.exists(dir)) stop('Raw logs absent: ',dir)
      paths <- list.files(dir,pattern='^turn[0-9]+\\.jsonl$',full.names=TRUE)
      meta <- json_object(file.path(dir,'meta.json'))
      paths <- file.path(dir,paste0('turn',vapply(meta$turns,function(t) t$n,integer(1)),'.jsonl'))
      for(path in paths) rows[[paste(arm,slug,basename(path))]] <-
        read_cost_turn(path,if(grepl('Sonnet',arm)) 'Sonnet' else 'Haiku') |>
        mutate(arm=arm,slug=slug,turn=basename(path))
    }
    message('Reconstructed ',arm)
  }
  turns <- bind_rows(rows)
  stopifnot(all(turns$lower<=turns$point),all(turns$point<=turns$upper))
  numeric <- names(turns)[vapply(turns,is.numeric,logical(1))]
  trials <- turns |> group_by(arm,slug) |> summarise(across(all_of(numeric),sum),
    side_without_compaction=sum(side_without_compaction),.groups='drop')
  readr::write_csv(turns,file.path(output,'api-cost-turns.csv'))
  readr::write_csv(trials,file.path(output,'api-cost-trials.csv'))
  invisible(trials)
}
