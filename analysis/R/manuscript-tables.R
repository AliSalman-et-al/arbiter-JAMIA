manuscript_data <- function(name) read_manuscript_data(name)
MEASURE_LABELS <- c('Violation'='Rating contradicts its own answers',
  'Invalid answer path'='Required question skipped','Departure'='Any rule break',
  'Evidence coverage'='Answers citing ≥1 passage or image',
  'Text-span evidence binding'='Quoted text linked to its source',
  'Visual evidence binding'='Image regions linked to their page',
  'Bundle verification'='Audit file passes the independent verifier')
main_table3 <- function() {
  x <- manuscript_data('table3')
  wanted <- tibble(domain=c(rep('D1-D5',3),rep('Audit',4)),
    status=c('Violation','Invalid answer path','Departure','Evidence coverage',
      'Text-span evidence binding','Visual evidence binding','Bundle verification')) |>
    mutate(Measure=unname(MEASURE_LABELS[status]))
  for(a in c('ARBITER-Sonnet','Baseline-Sonnet')) {
    d <- x |> filter(arm==a) |> select(domain,status,estimate,lower,upper,n,count)
    d$value <- fmt_fraction(d$count,d$n)
    if(a=='Baseline-Sonnet') d$value <- ifelse(d$status %in% c('Violation','Invalid answer path','Departure'),
      sub('[)]$','',d$value) |> paste0('; ',sub('^[(]','',fmt_ci(100*d$lower,100*d$upper,1,suppress_degenerate=TRUE))),d$value)
    if(a=='ARBITER-Sonnet') d$value <- ifelse(d$status %in% c('Violation','Invalid answer path','Departure'),'0 by design',d$value)
    wanted <- left_join(wanted,d |> select(domain,status,value),by=c('domain','status'))
    names(wanted)[names(wanted)=='value'] <- if(a=='ARBITER-Sonnet') 'ARBITER' else 'Unassisted'
  }
  wanted |> mutate(Unassisted=if_else(domain=='Audit'|is.na(Unassisted),'Not available',Unassisted)) |> select(Measure,ARBITER,Unassisted)
}

benchmark_table <- function(inputs,per_domain=FALSE) {
  meta <- readr::read_csv('data-curated/meta-analyses.csv',show_col_types=FALSE)
  x <- inputs$labels |> filter(arm=='ARBITER-Sonnet')
  counts <- x |> filter(domain!='Overall') |> count(meta_id,meta) |>
    complete(meta_id,meta=LABELS,fill=list(n=0)) |>
    pivot_wider(names_from=meta,values_from=n)
  trials <- inputs$trials |> count(meta_id,name='Trials')
  overall <- x |> filter(domain=='Overall') |> group_by(meta_id) |>
    summarise(`Overall given`=if(all(!is.na(meta))) 'Yes' else if(all(is.na(meta))) 'No' else 'Partly',.groups='drop')
  out <- meta |> left_join(trials,by='meta_id') |> left_join(counts,by='meta_id') |>
    left_join(overall,by='meta_id') |> arrange(specialty!='General medicine',specialty,journal) |>
    transmute(Specialty=specialty,Journal=dplyr::recode(journal,'Journal of the American College of Cardiology'='J Am Coll Cardiol','Clinical Journal of the American Society of Nephrology'='Clin J Am Soc Nephrol','The American Journal of Sports Medicine'='Am J Sports Med','British Journal of Anaesthesia'='Br J Anaesth','The Lancet Diabetes & Endocrinology'='Lancet Diabetes Endocrinol','The Lancet Respiratory Medicine'='Lancet Respir Med','The Lancet Rheumatology'='Lancet Rheumatol','The Lancet Neurology'='Lancet Neurol','The Lancet Oncology'='Lancet Oncol','The Lancet Psychiatry'='Lancet Psychiatry','Clinical Infectious Diseases'='Clin Infect Dis','Human Reproduction Update'='Hum Reprod Update','JAMA Pediatrics'='JAMA Pediatr','The Lancet'='Lancet'),Topic=topic,Year=as.character(year),
      DOI=doi,Trials,`Published D1–D5 labels (Low/SC/High)`=paste(Low,`Some concerns`,High,sep=' / '),`Overall given`)
  out$Journal <- paste(out$Journal,out$Year)
  out$Year <- NULL
  names(out)[names(out)=='Journal'] <- 'Journal and year'
  totals <- tibble(Specialty='Total',`Journal and year`='',Topic='',DOI='',Trials=sum(out$Trials),
    `Published D1–D5 labels (Low/SC/High)`=paste(sum(counts$Low),sum(counts$`Some concerns`),sum(counts$High),sep=' / '),
    `Overall given`=paste(sum(!is.na(filter(x,domain=='Overall')$meta)),'/ 102'))
  bind_rows(out,totals)
}
