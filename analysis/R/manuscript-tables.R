manuscript_data <- function(name) readr::read_csv(paste0('output/tables/',name,'.csv'),show_col_types=FALSE)
COMPOSITE_NOTE <- paste('Composite reference: consensus preferred judgement on consensus cells,',
  'Published on other cells; 25 split cells excluded (485 cells per arm).',
  'Adjudicators could only choose among the three labels offered.',
  'Cells where both Sonnet arms matched Published were never adjudicated and are assumed correct.',
  'Both features inflate absolute composite values.')
TOPIC_ABBREVIATIONS <- paste('ACL, anterior cruciate ligament; CDK4/6, cyclin-dependent kinases 4 and 6;',
  'eGFR, estimated glomerular filtration rate; GLP-1, glucagon-like peptide-1; HER2, human epidermal growth factor receptor 2;',
  'HR, hormone receptor; IgA, immunoglobulin A; SGLT2, sodium-glucose cotransporter 2.')
CI_NOTE <- 'CI, confidence interval; 10,000 percentile bootstrap replicates, trials resampled within meta-analysis; seed 20261018.'
AGREEMENT_NOTE <- paste('Linearly weighted Cohen\u2019s \u03ba and Gwet\u2019s AC2.',
  'Exact agreement, sensitivity and specificity are n/N (%); their CI bounds are percentages.',
  'Not Low means Some concerns or High. All-Low rule has no variance; only accuracy and specificity are reported.',
  'Paired differences are on the coefficient scale or in percentage points; \u2014 indicates undefined or not applicable.')
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
    transmute(Specialty=specialty,Journal=dplyr::recode(journal,'Journal of the American College of Cardiology'='J Am Coll Cardiol','Clinical Journal of the American Society of Nephrology'='Clin J Am Soc Nephrol','The American Journal of Sports Medicine'='Am J Sports Med','British Journal of Anaesthesia'='Br J Anaesth','The Lancet Diabetes & Endocrinology'='Lancet Diabetes Endocrinol','The Lancet Respiratory Medicine'='Lancet Respir Med','The Lancet Rheumatology'='Lancet Rheumatol','The Lancet Neurology'='Lancet Neurol','The Lancet Oncology'='Lancet Oncol','The Lancet Psychiatry'='Lancet Psychiatry','Clinical Infectious Diseases'='Clin Infect Dis','Human Reproduction Update'='Hum Reprod Update','JAMA Pediatrics'='JAMA Pediatr','The Lancet'='Lancet'),Year=as.character(year),Topic=topic,
      Trials,`Published D1–D5 labels, Low / SC / High`=paste(Low,`Some concerns`,High,sep=' / '),`Overall given`)
  totals <- tibble(Specialty='Total',Journal='',Year='',Topic='',Trials=sum(out$Trials),
    `Published D1–D5 labels, Low / SC / High`=paste(sum(counts$Low),sum(counts$`Some concerns`),sum(counts$High),sep=' / '),
    `Overall given`=paste(sum(!is.na(filter(x,domain=='Overall')$meta)),'/ 102'))
  bind_rows(out,totals)
}
agreement_display <- function(x,ids=c('arm','domain'),difference=FALSE) {
  metrics <- intersect(c('kappa','AC2','accuracy','sensitivity','specificity'),unique(x$metric))
  x <- x |> filter(metric %in% metrics)
  x$value <- vapply(seq_len(nrow(x)),function(i) {
    r <- x[i,]; prop <- r$metric %in% c('accuracy','sensitivity','specificity')
    if(difference && prop) trimws(paste0(fmt_number(100*r$estimate,1),' ',fmt_ci(100*r$lower,100*r$upper,1,suppress_degenerate=TRUE)))
    else if(r$metric=='kappa' && is.finite(r$lower) && r$lower==r$upper) '\u2014'
    else fmt_estimate(r,prop)
  },character(1))
  x |> select(all_of(ids),metric,value) |> pivot_wider(names_from=metric,values_from=value) |>
    rename_with(~c(kappa='Weighted \u03ba',AC2='AC2',accuracy='Exact agreement',
      sensitivity='Sensitivity for Not Low',specificity='Specificity for Not Low')[.x],all_of(metrics))
}
main_table2 <- function() {
  pub <- manuscript_data('table2')
  comp <- manuscript_data('agreement-composite') |> filter(domain=='D1-D5',arm %in% c('ARBITER-Sonnet','Baseline-Sonnet'),metric %in% c('kappa','AC2','accuracy'))
  block <- function(x,label) {
    x <- agreement_display(x,'arm') |> mutate(arm=reader_label(arm)) |> rename(Source=arm)
    group_row(x,label)
  }
  dif <- bind_rows(manuscript_data('table2-differences'),manuscript_data('agreement-composite-differences') |>
      filter(domain=='D1-D5',metric %in% c('kappa','AC2','accuracy'))) |>
    filter(comparison=='ARBITER-Sonnet minus Baseline-Sonnet') |>
    mutate(Row=paste(if_else(reference=='Meta','Published','Composite'),reader_label(domain),sep=': ')) |>
    agreement_display('Row',TRUE) |> rename(Source=Row)
  bind_rows(block(filter(pub,domain=='D1-D5'),'Against Published labels — D1–D5 (510 cells)'),
    block(filter(pub,domain=='Overall'),'Against Published labels — Overall (81 trials)'),
    block(comp,'Against composite reference — D1–D5 (485 cells)'),
    group_row(dif,'Paired difference, ARBITER − Unassisted')) |> replace_na(as.list(setNames(rep('',6),names(dif))))
}
MEASURE_LABELS <- c('Consistent'='Consistent with RoB 2 algorithm',
  'Violation'='Contradicts own answers (violation)', 'Invalid answer path'='Required question skipped (invalid path)',
  'Departure'='Any departure','Proposed agreement'='Proposed judgement matches algorithm',
  'Recorded override'='Recorded override','Permitted escalation'='Permitted escalation',
  'Evidence coverage'='Signalling answers citing ≥1 evidence record',
  'Text-span evidence binding'='Text spans bound to captured source',
  'Visual evidence binding'='Visual regions bound to rendered page',
  'Structural evidence binding (overall)'='All evidence bound','Bundle verification'='Bundle passes independent verification')
main_table3 <- function() {
  x <- manuscript_data('table3')
  wanted <- tibble(domain=c(rep('D1-D5',6),rep('Overall',3),rep('Audit',5)),
    status=c('Consistent','Violation','Invalid answer path','Departure','Proposed agreement','Recorded override',
      'Consistent','Permitted escalation','Violation','Evidence coverage','Text-span evidence binding',
      'Visual evidence binding','Structural evidence binding (overall)','Bundle verification'))
  out <- wanted |> mutate(Measure=unname(MEASURE_LABELS[status]))
  for(a in c('ARBITER-Sonnet','Baseline-Sonnet')) {
    d <- x |> filter(arm==a) |> select(domain,status,estimate,lower,upper,n,count)
    d$value <- fmt_fraction(d$count,d$n)
    if(a=='Baseline-Sonnet') d$CI <- ifelse(d$status %in% c('Violation','Invalid answer path','Departure') & d$lower!=d$upper,
      fmt_ci(100*d$lower,100*d$upper,1),'')
    out <- left_join(out,d |> select(domain,status,value,any_of('CI')),by=c('domain','status'))
    names(out)[names(out)=='value'] <- reader_label(a)
  }
  out <- out |> mutate(Unassisted=if_else(domain=='Audit'|is.na(Unassisted),'Not available',Unassisted),CI=replace_na(CI,''))
  bind_rows(group_row(filter(out,domain=='D1-D5') |> select(Measure,ARBITER,Unassisted,CI),'Domain judgements (D1–D5)'),
    group_row(filter(out,domain=='Overall') |> select(Measure,ARBITER,Unassisted,CI),'Overall judgement'),
    group_row(filter(out,domain=='Audit') |> select(Measure,ARBITER,Unassisted,CI),'Evidence and audit')) |>
    rename(`Unassisted 95% CI (%)`=CI)
}
main_table4 <- function() {
  x <- manuscript_data('table4-reliability') |> agreement_display('comparison')
  between <- filter(x,startsWith(comparison,'A vs Z')) |>
    mutate(comparison=if_else(grepl('independent',comparison),'Independent judgements','Preferred judgements'))
  parts <- lapply(c('A','Z'),function(a) {
    d <- filter(x,startsWith(comparison,paste(a,'independent'))) |>
      mutate(comparison=reader_label(sub('.* vs ','',comparison)),comparison=if_else(comparison=='published label','Published',comparison))
    group_row(d,paste('Adjudicator',if(a=='A') 1 else 2,'independent vs …'))
  })
  bind_rows(group_row(between,'Between adjudicators'),parts[[1]],parts[[2]]) |>
    rename(Comparison=comparison,`Raw agreement`=`Exact agreement`)
}
main_table_notes <- function() list(
  paste('SC, Some concerns; RoB 2, risk of bias tool for randomised trials. Counts are published labels pooled across D1\u2013D5.',
    'Overall given indicates whether published Overall labels are available; total is labelled trials/all trials.',
    'The analysis excludes three unsupported-design trials from all arms. Metadata are curated from the source meta-analyses.',TOPIC_ABBREVIATIONS),
  paste(AGREEMENT_NOTE,COMPOSITE_NOTE,CI_NOTE),
  paste('Values are n/N (%). Separate 95% CI column gives Unassisted departure-type rates in %. Domain consistency for ARBITER refers to proposals;',
    'recorded overrides are separate. Departure = violation + invalid path.',
    'One Unassisted domain has no evaluable label/answer set and is excluded (509 evaluable).',
    'Overall consistency is exact worst-domain agreement; permitted escalations are separate.',
    'Evidence coverage uses active signalling answers as the denominator and answers citing at least one evidence record as the numerator.',
    'Evidence binding counts distinct identities cited by current active answers.',
    'Text spans are server-extracted; visual regions are server-rendered and hash-bound, but transcriptions are model-written and not checked against images.',
    'Bundle verification is structural, not evidence of clinical correctness or completion.',
    'Unassisted evidence traces, proposed judgements and recorded overrides are not available. RoB 2, risk of bias tool for randomised trials.',CI_NOTE),
  paste('All comparisons use the 154 disputed cells, selected because at least one Sonnet arm differed from Published.',
    'These comparisons cannot estimate agreement or published-label accuracy in the full benchmark.',
      'Independent judgements preceded blinded label presentation; preferred judgements selected among the three offered labels.',
      'Linearly weighted Cohen\u2019s \u03ba; Gwet\u2019s AC2; raw agreement as n/N (%) with CI bounds in %.',CI_NOTE))
build_main_tables <- function(inputs) {
  dir.create('output/manuscript',recursive=TRUE,showWarnings=FALSE)
  tables <- list(benchmark_table(inputs),main_table2(),main_table3(),main_table4())
  captions <- c('Table 1. Benchmark set','Table 2. Agreement (95% CI)',
    'Table 3. RoB 2 rule consistency and audit','Table 4. Reliability of the reference standard (95% CI)')
  notes <- main_table_notes()
  for(i in seq_along(tables)) {
    doc <- manuscript_doc() |> officer::body_add_par(captions[i],style='heading 1') |>
      flextable::body_add_flextable(main_table_flextable(tables[[i]],i,notes[[i]]))
    print(doc,target=paste0('output/manuscript/Table',i,'.docx'))
  }
  invisible(tables)
}
main_table_flextable <- function(x,i,note=main_table_notes()[[i]]) {
  widths <- list(c(1.14,1.18,.43,1.95,.46,1.02,.67),c(1.15,.8,.8,1.35,1.35,1.1),c(2.9,1.35,1.35,1.25),c(2.7,rep(1.3833,3)))
  ft <- house_table(x,note) |> flextable::width(j=seq_len(ncol(x)),width=widths[[i]])
  if(i>1) ft <- style_group_rows(ft,x)
  ft
}
