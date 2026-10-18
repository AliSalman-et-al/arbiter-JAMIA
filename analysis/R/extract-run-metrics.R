# Explicit extraction step, run with Rscript R/extract-run-metrics.R from analysis/.
# Reports never open raw logs or bundles. JSONL is streamed, one bounded chunk at a time.
json_object <- function(path) jsonlite::fromJSON(path,simplifyVector=FALSE)
parse_json_text <- function(text) {
  Encoding(text) <- 'UTF-8'
  jsonlite::fromJSON(text,simplifyVector=FALSE)
}
json_zip <- function(path,name) {
  con <- unz(path,name,open='r'); on.exit(close(con))
  parse_json_text(paste(readLines(con,warn=FALSE),collapse='\n'))
}
numeric_field <- function(x) if(is.null(x)) NA_real_ else as.numeric(x)
complete_sum <- function(x) if(anyNA(x)) NA_real_ else sum(x)

read_terminal_result <- function(path) {
  if(!file.exists(path)) stop('Missing turn log: ',path)
  con <- file(path,open='rb'); on.exit(close(con))
  result <- NULL
  repeat {
    lines <- readLines(con,n=100,warn=FALSE)
    if(!length(lines)) break
    selected <- lines[grepl('"total_cost_usd"\\s*:',lines,perl=TRUE)]
    for(line in selected) {
      if(!is.null(result)) stop('Multiple terminal results in ',path)
      result <- parse_json_text(line)
    }
  }
  result
}

bundle_metrics <- function(path,slug) {
  if(!file.exists(path)) return(list(bundle_present=FALSE,verification_passed=NA,
    active_answers=NA_integer_,evidenced_active_answers=NA_integer_,
    basis_distribution_json='[]',domain_decisions_json='[]',bundle_date=NA_character_))
  canonical <- json_zip(path,'canonical.json')
  verification <- json_zip(path,'verification.json')
  mapping <- c('domain:randomization'='D1','domain:deviations'='D2','domain:missing'='D3',
    'domain:measurement'='D4','domain:selection'='D5')
  labels <- c(low='Low',some_concerns='Some concerns',high='High')
  counts <- integer(); decisions <- list(); dates <- character()
  for(d in canonical$domain_records) {
    active <- unlist(d$active_questions,use.names=FALSE)
    answers <- d$answers
    a <- answers[vapply(answers,function(x) x$question_id %in% active,logical(1))]
    stopifnot(length(a)==length(active))
    counts <- c(counts,vapply(a,function(x) length(x$bases),integer(1)))
    answer_map <- setNames(vapply(a,function(x) x$answer,character(1)),
      question_map()$question[match(vapply(a,function(x) x$question_id,character(1)),question_map()$question_id)])
    domain <- unname(mapping[d$domain_id])
    override <- d$decision$proposed!=d$decision$adopted
    decisions[[domain]] <- list(domain=domain,proposed=unname(labels[d$decision$proposed]),
      adopted=unname(labels[d$decision$adopted]),algorithm=domain_algorithm(domain,answer_map),
      override=override,recorded=if(override) !is.null(d$decision$adjudication) else TRUE,
      rationale=if(override) d$decision$adjudication$rationale else '',
      evidence=if(override) unlist(d$decision$adjudication$evidence) else character())
    dates <- c(dates,d$observed_at)
  }
  distribution <- if(length(counts)) as.data.frame(table(counts),stringsAsFactors=FALSE) else
    data.frame(bases=integer(),answers=integer())
  names(distribution) <- c('bases','answers'); distribution$bases <- as.integer(distribution$bases)
  list(bundle_present=TRUE,verification_passed=identical(verification$result,'verified'),
    active_answers=length(counts),evidenced_active_answers=sum(counts>0),
    basis_distribution_json=jsonlite::toJSON(distribution,dataframe='rows',auto_unbox=TRUE),
    domain_decisions_json=jsonlite::toJSON(unname(decisions),auto_unbox=TRUE),
    bundle_date=if(length(dates)) substr(min(dates),1,10) else NA_character_)
}

extract_run_metrics <- function(root='..',output='data-derived') {
  # Validate the complete input inventory before writing anything.
  trials <- read_input(file.path(root,'rob2-meta-benchmark-set/TRIAL-SUMMARY.csv')) |>
    filter(!slug %in% EXCLUDED) |> select(slug,meta_id)
  for(folder in unname(ARMS)) {
    if(!dir.exists(file.path(root,folder,'logs'))) stop('Raw logs are absent: ',folder)
    for(slug in trials$slug) if(!file.exists(file.path(root,folder,'logs',slug,'meta.json')))
      stop('Missing run metadata: ',folder,'/',slug)
  }
  derived <- list()
  for(arm in names(ARMS)) {
    folder <- file.path(root,ARMS[[arm]])
    cp <- file.path(folder,'continues.csv')
    continues <- if(file.exists(cp)) read_input(cp) else tibble(slug=character())
    rows <- lapply(seq_len(nrow(trials)),function(i) {
      slug <- trials$slug[i]
      meta <- json_object(file.path(folder,'logs',slug,'meta.json'))
      turns <- meta$turns
      if(!length(turns)) stop('No turns in ',arm,'/',slug)
      terminal_count <- 0L
      for(t in turns) {
        result <- read_terminal_result(file.path(folder,'logs',slug,paste0('turn',t$n,'.jsonl')))
        if(is.null(result)) {
          if(!is.null(t$usage)) stop('Metadata usage without a terminal result: ',arm,'/',slug)
        } else {
          terminal_count <- terminal_count+1L
          for(k in c('input_tokens','cache_creation_input_tokens','cache_read_input_tokens','output_tokens')) {
            if(!isTRUE(all.equal(numeric_field(t$usage[[k]]),numeric_field(result$usage[[k]]))))
              stop('Turn usage mismatch: ',arm,'/',slug,' ',k)
          }
        }
      }
      sum_turn <- function(f) complete_sum(vapply(turns,f,numeric(1)))
      count_continue <- length(meta$continues)
      csv_count <- sum(continues$slug==slug)
      if(count_continue!=csv_count) stop('Continue count mismatch: ',arm,'/',slug)
      is_arbiter <- startsWith(arm,'ARBITER')
      b <- if(is_arbiter) bundle_metrics(file.path(folder,'bundles',paste0(slug,'.rob2.zip')),slug) else
        list(bundle_present=NA,verification_passed=NA,active_answers=NA_integer_,
          evidenced_active_answers=NA_integer_,basis_distribution_json='[]',domain_decisions_json='[]',bundle_date=NA_character_)
      tibble(arm=arm,slug=slug,meta_id=trials$meta_id[i],model=meta$model,effort=meta$effort,
        claude_version=meta$claude_version,wall_seconds=sum_turn(function(t) numeric_field(t$seconds)),
        input_tokens=sum_turn(function(t) numeric_field(t$usage$input_tokens)),
        cache_creation_tokens=sum_turn(function(t) numeric_field(t$usage$cache_creation_input_tokens)),
        cache_read_tokens=sum_turn(function(t) numeric_field(t$usage$cache_read_input_tokens)),
        output_tokens=sum_turn(function(t) numeric_field(t$usage$output_tokens)),
        thinking_tokens=sum_turn(function(t) numeric_field(t$usage$output_tokens_details$thinking_tokens)),
        cost_usd=sum_turn(function(t) numeric_field(t$cost_usd)),cost_basis='harness-reported; basis unknown',
        turns=length(turns),agent_steps=sum_turn(function(t) numeric_field(t$num_turns)),
        terminal_results=terminal_count,continues=count_continue,continues_csv=csv_count,
        approved=if(is_arbiter) identical(meta$review_exit,0L) else NA,
        bundle_present=b$bundle_present,verification_passed=b$verification_passed,
        active_answers=b$active_answers,evidenced_active_answers=b$evidenced_active_answers,
        basis_distribution_json=as.character(b$basis_distribution_json),
        domain_decisions_json=as.character(b$domain_decisions_json),bundle_date=b$bundle_date)
    })
    derived[[arm]] <- bind_rows(rows)
    message('Extracted ',arm,': ',nrow(derived[[arm]]),' analysis-set trials')
  }
  dir.create(output,recursive=TRUE,showWarnings=FALSE)
  for(arm in names(derived)) readr::write_csv(derived[[arm]],
    file.path(output,paste0(tolower(arm),'.csv')),na='')
  invisible(derived)
}

if(sys.nframe()==0L) {
  source('R/load.R'); source('R/algorithms.R')
  extract_run_metrics()
}
