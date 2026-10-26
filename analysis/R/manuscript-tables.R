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
    names(wanted)[names(wanted)=='value'] <- reader_label(a)
  }
  wanted |> mutate(Unassisted=if_else(domain=='Audit'|is.na(Unassisted),'Not available',Unassisted)) |> select(Measure,ARBITER,Unassisted)
}
