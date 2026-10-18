manuscript_data <- function(name) readr::read_csv(paste0('output/tables/',name,'.csv'),show_col_types=FALSE)
COMPOSITE_NOTE <- paste('Composite reference: consensus preferred judgement on consensus cells,',
  'Published on other cells; 25 split cells excluded (485 cells per arm).',
  'Adjudicators could only choose among the three labels offered.',
  'Cells where both Sonnet arms matched Published were never adjudicated and are assumed correct.',
  'Both features inflate absolute composite values; composite accuracy is not an abstract accuracy claim.')
CI_NOTE <- 'CI, confidence interval; 10,000 percentile bootstrap replicates, trials resampled within meta-analysis; seed 20261018.'
AGREEMENT_NOTE <- paste('Linearly weighted Cohen\u2019s \u03ba and Gwet\u2019s AC2.',
  'Exact agreement, sensitivity and specificity are n/N (%); their CI bounds are proportions.',
  'Not Low means Some concerns or High. All-Low rule has no variance; only accuracy and specificity are reported.',
  'Paired differences are on the original coefficient or proportion scale; \u2014 indicates undefined or not applicable.')
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
    left_join(overall,by='meta_id') |> arrange(specialty,journal) |>
    transmute(Specialty=specialty,`Journal; year`=paste0(journal,'; ',year),Topic=topic,
      Trials,`Low / Some concerns / High`=paste(Low,`Some concerns`,High,sep=' / '),`Overall given`)
  totals <- tibble(Specialty='Total',`Journal; year`='',Topic='',Trials=sum(out$Trials),
    `Low / Some concerns / High`=paste(sum(counts$Low),sum(counts$`Some concerns`),sum(counts$High),sep=' / '),
    `Overall given`=paste(sum(!is.na(filter(x,domain=='Overall')$meta)),'/ 102'))
  bind_rows(out,totals)
}
agreement_display <- function(x,ids=c('arm','domain'),difference=FALSE) {
  metrics <- intersect(c('kappa','AC2','accuracy','sensitivity','specificity'),unique(x$metric))
  x <- x |> filter(metric %in% metrics)
  x$value <- vapply(seq_len(nrow(x)),function(i)
    fmt_estimate(x[i,],!difference && x$metric[i] %in% c('accuracy','sensitivity','specificity')),character(1))
  x |> select(all_of(ids),metric,value) |> pivot_wider(names_from=metric,values_from=value) |>
    rename_with(~c(kappa='Weighted \u03ba',AC2='AC2',accuracy='Exact agreement',
      sensitivity='Sensitivity',specificity='Specificity')[.x],all_of(metrics))
}
main_table2 <- function() {
  pub <- manuscript_data('table2') |> mutate(Row=paste('Published',domain,reader_label(arm),sep='\n'))
  comp <- manuscript_data('agreement-composite') |> filter(domain=='D1-D5',arm %in% c('ARBITER-Sonnet','Baseline-Sonnet')) |>
    mutate(Row=paste('Composite',domain,reader_label(arm),sep='\n'))
  dif <- bind_rows(manuscript_data('table2-differences'),manuscript_data('agreement-composite-differences') |>
      filter(domain=='D1-D5')) |>
    filter(comparison=='ARBITER-Sonnet minus Baseline-Sonnet') |>
    mutate(Row=paste(if_else(reference=='Meta','Published','Composite'),domain,'ARBITER \u2212 Unassisted',sep='\n'))
  bind_rows(agreement_display(pub,'Row'),agreement_display(comp,'Row'),agreement_display(dif,'Row',TRUE)) |>
    rename(`Reference / population / source`=Row)
}
main_table3 <- function() {
  x <- manuscript_data('table3')
  wanted <- tibble(domain=c(rep('D1-D5',6),rep('Overall',3),rep('Audit',5)),
    status=c('Consistent','Violation','Invalid answer path','Departure','Proposed agreement','Recorded override',
      'Consistent','Permitted escalation','Violation','Evidence coverage','Text-span evidence binding',
      'Visual evidence binding','Structural evidence binding (overall)','Bundle verification'))
  out <- wanted |> mutate(Measure=paste(domain,status,sep=': '))
  for(a in c('ARBITER-Sonnet','Baseline-Sonnet')) {
    d <- x |> filter(arm==a) |> select(domain,status,estimate,lower,upper,n,count)
    d$value <- fmt_estimate(d,TRUE)
    out <- left_join(out,d |> select(domain,status,value),by=c('domain','status'))
    names(out)[names(out)=='value'] <- reader_label(a)
  }
  out <- out |> select(Measure,ARBITER,Unassisted)
  out$Unassisted[is.na(out$Unassisted)] <- 'Not available'
  out
}
main_table4 <- function() {
  manuscript_data('table4-reliability') |> agreement_display('comparison') |>
    mutate(comparison=reader_label(comparison)) |> rename(Comparison=comparison)
}
main_table_notes <- function() list(
  paste('RoB 2, risk of bias tool for randomised trials. Counts are published labels pooled across D1\u2013D5.',
    'Overall given indicates whether published Overall labels are available; total is labelled trials/all trials.',
    'The analysis excludes three unsupported-design trials from all arms. Metadata are curated from the source meta-analyses.'),
  paste(AGREEMENT_NOTE,COMPOSITE_NOTE,CI_NOTE),
  paste('Values are n/N (%) (95% CI, bounds as proportions). Domain consistency for ARBITER refers to proposals;',
    'recorded overrides are separate. Departure = violation + invalid path.',
    'One Unassisted domain has no evaluable label/answer set and is excluded (509 evaluable).',
    'Overall consistency is exact worst-domain agreement; permitted escalations are separate.',
    'Evidence binding counts distinct identities cited by current active answers.',
    'Text spans are server-extracted; visual regions are server-rendered and hash-bound, but transcriptions are model-written and not checked against images.',
    'Bundle verification is structural, not evidence of clinical correctness or completion.',
    'Unassisted evidence traces, proposed judgements and recorded overrides are not available. RoB 2, risk of bias tool for randomised trials.',CI_NOTE),
  paste('All comparisons use the 154 disputed cells, selected because at least one Sonnet arm differed from Published.',
    'These comparisons cannot estimate agreement or published-label accuracy in the full benchmark.',
    'Independent judgements preceded blinded label presentation; preferred judgements selected among the three offered labels.',AGREEMENT_NOTE,CI_NOTE))
build_main_tables <- function(inputs) {
  dir.create('output/manuscript',recursive=TRUE,showWarnings=FALSE)
  tables <- list(benchmark_table(inputs),main_table2(),main_table3(),main_table4())
  captions <- c('Table 1. Benchmark set','Table 2. Agreement (95% CI)',
    'Table 3. RoB 2 rule consistency and audit (95% CI)','Table 4. Reliability of the reference standard (95% CI)')
  notes <- main_table_notes()
  for(i in seq_along(tables)) write_word_table(tables[[i]],paste0('output/manuscript/Table',i,'.docx'),captions[i],notes[[i]])
  invisible(tables)
}
