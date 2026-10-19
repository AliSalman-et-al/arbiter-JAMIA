LEGACY_TABLE_TITLES <- c(
  'Sixteen meta-analyses across 15 specialties supplied the benchmark',
  'ARBITER detected more of the risk flagged by published reviews, at lower specificity',
  'Without ARBITER, 1 in 8 domain ratings broke the RoB 2 rules',
  'Before seeing any label, both adjudicators’ own ratings agreed with ARBITER far more than with the unassisted model or the published review')
manuscript_data <- function(name) read_manuscript_data(name)
COMPOSITE_NOTE <- paste('Reference: the adjudicators’ agreed choice where both agreed; published labels elsewhere.',
  'Excludes 25 divided decisions (485 cells per arm). Only three labels were offered.',
  'Unreviewed cells where both arms matched published labels are assumed correct.',
  'Both features inflate absolute values.')
TOPIC_ABBREVIATIONS <- paste('ACL, anterior cruciate ligament; CDK4/6, cyclin-dependent kinases 4 and 6;',
  'eGFR, estimated glomerular filtration rate; GLP-1, glucagon-like peptide-1; HER2, human epidermal growth factor receptor 2;',
  'HR, hormone receptor; IgA, immunoglobulin A; SGLT2, sodium-glucose cotransporter 2.')
CI_NOTE <- 'CI, confidence interval; 10,000 percentile bootstrap replicates, trials resampled within meta-analysis; seed 20261018.'
AGREEMENT_NOTE <- paste('Linearly weighted Cohen\u2019s \u03ba and Gwet\u2019s AC2.',
  'Exact agreement, sensitivity and specificity are n/N (%); their CI bounds are percentages.',
  'Some concerns or High is the positive class. All-Low rule has no variance; only accuracy and specificity are reported.',
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
    transmute(Specialty=specialty,Journal=dplyr::recode(journal,'Journal of the American College of Cardiology'='J Am Coll Cardiol','Clinical Journal of the American Society of Nephrology'='Clin J Am Soc Nephrol','The American Journal of Sports Medicine'='Am J Sports Med','British Journal of Anaesthesia'='Br J Anaesth','The Lancet Diabetes & Endocrinology'='Lancet Diabetes Endocrinol','The Lancet Respiratory Medicine'='Lancet Respir Med','The Lancet Rheumatology'='Lancet Rheumatol','The Lancet Neurology'='Lancet Neurol','The Lancet Oncology'='Lancet Oncol','The Lancet Psychiatry'='Lancet Psychiatry','Clinical Infectious Diseases'='Clin Infect Dis','Human Reproduction Update'='Hum Reprod Update','JAMA Pediatrics'='JAMA Pediatr','The Lancet'='Lancet'),Topic=topic,Year=as.character(year),
      Trials,`Published D1–D5 labels (Low/SC/High)`=paste(Low,`Some concerns`,High,sep=' / '),`Overall given`)
  out$Journal <- paste(out$Journal,out$Year)
  out$Year <- NULL
  names(out)[names(out)=='Journal'] <- 'Journal and year'
  totals <- tibble(Specialty='Total',`Journal and year`='',Topic='',Trials=sum(out$Trials),
    `Published D1–D5 labels (Low/SC/High)`=paste(sum(counts$Low),sum(counts$`Some concerns`),sum(counts$High),sep=' / '),
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
      sensitivity='Sensitivity¹',specificity='Specificity')[.x],all_of(metrics))
}
main_table2 <- function() {
  pub <- manuscript_data('table2')
  block <- function(x,label) {
    if(any(x$metric=='sensitivity')) label <- paste0(label,'; Some concerns or High: N = ',unique(x$n[x$metric=='sensitivity'])[1],'; Low N = ',unique(x$n[x$metric=='specificity'])[1])
    x <- filter(x,metric!='AC2'); x$count <- NULL; x$n <- NULL
    x <- agreement_display(x,'arm') |> mutate(arm=reader_label(arm)) |> rename(Source=arm)
    group_row(x,label)
  }
  dif <- manuscript_data('table2-differences') |> filter(metric!='AC2') |>
    filter(comparison=='ARBITER-Sonnet minus Baseline-Sonnet') |>
    mutate(Row=paste(if_else(reference=='Meta','Published','Composite'),reader_label(domain),sep=': ')) |>
    agreement_display('Row',TRUE) |> rename(Source=Row)
  bind_rows(block(filter(pub,domain=='D1-D5'),'Against Published labels — D1–D5 (510 cells)'),
    block(filter(pub,domain=='Overall'),'Against Published labels — Overall (81 trials)'),
    group_row(dif,'Paired difference, ARBITER − Unassisted')) |> replace_na(as.list(setNames(rep('',5),names(dif))))
}
MEASURE_LABELS <- c('Consistent'='Consistent with RoB 2',
  'Violation'='Rating contradicts its own answers', 'Invalid answer path'='Required question skipped',
  'Departure'='Any rule break','Proposed agreement'='Proposed judgement matches algorithm',
  'Recorded override'='Recorded override','Permitted escalation'='Permitted escalation',
  'Evidence coverage'='Answers citing ≥1 supporting passage or image',
  'Text-span evidence binding'='Quoted text linked to its source',
  'Visual evidence binding'='Image regions linked to their page',
  'Structural evidence binding (overall)'='All evidence bound','Bundle verification'='Audit file passes the independent verifier')
main_table3 <- function() {
  x <- manuscript_data('table3')
  wanted <- tibble(domain=c(rep('D1-D5',3),paste0('D',1:5),'Overall',rep('Audit',4)),
    status=c('Violation','Invalid answer path','Departure',rep('Departure',5),'Consistent',
      'Evidence coverage','Text-span evidence binding','Visual evidence binding','Bundle verification'))
  x <- x |> filter(!(domain=='Overall' & status=='Consistent')) |> bind_rows(
    x |> filter(domain=='Overall',status %in% c('Consistent','Permitted escalation')) |>
      group_by(arm,domain) |> summarise(status='Consistent',count=sum(count),n=first(n),estimate=sum(estimate),lower=NA_real_,upper=NA_real_,.groups='drop'))
  out <- wanted |> mutate(Measure=if_else(domain %in% paste0('D',1:5),paste(domain,'rule breaks'),unname(MEASURE_LABELS[status])),
    Measure=if_else(domain=='Overall','Overall rating follows the RoB 2 rules (incl. permitted escalation)',Measure))
  for(a in c('ARBITER-Sonnet','Baseline-Sonnet')) {
    d <- x |> filter(arm==a) |> select(domain,status,estimate,lower,upper,n,count)
    d$value <- fmt_fraction(d$count,d$n)
    if(a=='Baseline-Sonnet') d$value <- ifelse(d$status %in% c('Violation','Invalid answer path','Departure'),
      sub('[)]$','',d$value) |> paste0('; ',sub('^[(]','',fmt_ci(100*d$lower,100*d$upper,1,suppress_degenerate=TRUE))),d$value)
    if(a=='ARBITER-Sonnet') d$value <- ifelse(d$status %in% c('Violation','Invalid answer path','Departure') & d$domain!='Overall','0 by design',d$value)
    out <- left_join(out,d |> select(domain,status,value),by=c('domain','status'))
    names(out)[names(out)=='value'] <- reader_label(a)
  }
  out <- out |> mutate(Unassisted=if_else(domain=='Audit'|is.na(Unassisted),'Not available',Unassisted))
  bind_rows(group_row(filter(out,domain %in% c('D1-D5',paste0('D',1:5))) |> select(Measure,Unassisted,ARBITER),'Domain ratings (D1–D5)'),
    group_row(filter(out,domain=='Overall') |> select(Measure,Unassisted,ARBITER),'Overall rating'),
    group_row(filter(out,domain=='Audit') |> select(Measure,Unassisted,ARBITER),'Evidence and audit'))
}

reliability_table <- function() {
  x <- manuscript_data('table4-reliability') |> filter(metric!='AC2') |> agreement_display('comparison')
  between <- filter(x,startsWith(comparison,'A vs Z')) |>
    mutate(comparison=if_else(grepl('independent',comparison),'Independent ratings','Ratings chosen after seeing labels'))
  parts <- lapply(c('A','Z'),function(a) {
    d <- filter(x,startsWith(comparison,paste(a,'independent'))) |>
      mutate(comparison=reader_label(sub('.* vs ','',comparison)),comparison=if_else(comparison=='published label','Published',comparison))
    group_row(d,paste('Adjudicator',if(a=='A') 1 else 2,'own rating compared with …'))
  })
  delta <- manuscript_data('independent-paired-difference') |>
    transmute(comparison=paste('Adjudicator',if_else(adjudicator=='A','1','2')),
      `Weighted κ`='—',`Exact agreement`=paste0(fmt_number(100*estimate,1),' ',fmt_ci(100*lower,100*upper,1)))
  bind_rows(group_row(between,'Between adjudicators'),parts[[1]],parts[[2]],
    group_row(delta,'Post hoc: paired agreement difference (percentage points)')) |>
    rename(Comparison=comparison,`Raw agreement`=`Exact agreement`)
}
legacy_table_notes <- function() {
  notes <- list(
  paste('SC, Some concerns; RoB 2, risk of bias tool for randomised trials. Counts are published labels pooled across D1\u2013D5.',
    paste0('Per-domain distributions: eTable ',supplement_number('Published label distributions by domain'),'.'),
    'Overall given indicates whether published Overall labels are available; total is labelled trials/all trials.',
    'The analysis excludes three unsupported-design trials from all arms. Metadata are curated from the source meta-analyses.',TOPIC_ABBREVIATIONS),
  paste('Published means published review label. Values are coefficients or percentages (95% CI); denominators are in block labels. ¹ Sensitivity for Some concerns or High; specificity is the share of published Low ratings also rated Low. All-Low rule has no variance; only accuracy and specificity are reported. Paired differences are coefficients or percentage points; — indicates undefined or not applicable.',paste0('AC2 and composite-reference results: eTables ',supplement_number('Agreement against Published, all sources and domains'),' and ',supplement_number('Agreement against the composite reference, Sonnet only'),'. Full paired differences: eTables ',supplement_number('Paired differences against Published'),' and ',supplement_number('Paired differences against the composite reference'),'.'),'Overall judgements were not adjudicated. Published labels were frequently less severe than the adjudicators’ agreed choice (Figure 4).',CI_NOTE),
  paste('Values are n/N (x.x%; 95% CI a–b) where an interval is shown. A rule break means a rating contradicts its own answers or a required question was skipped.',
    'ARBITER computes proposed ratings from the official rules and requires complete answers; recorded overrides: 0/510.',
    'One ARBITER Overall rating used the permitted escalation; both arms followed the Overall rules in every trial.',
    paste0('Full checks and skipped-question sensitivity: eTables ',supplement_number('RoB 2 consistency and structural audit, all sources and domains'),' and ',supplement_number('Invalid answer path sensitivity'),'.'),
    'One Unassisted domain lacks a rating and answers and is excluded (509 evaluable).',
    'Evidence coverage counts required answers citing a passage or image. Text and image checks count distinct cited records.',
    'ARBITER extracts quoted text and renders cited images. The model writes image descriptions; these are not checked against the images.',
    'The independent verifier checks the audit file structure, not clinical correctness or completion. Unassisted evidence records are unavailable.',CI_NOTE),
  paste('All comparisons use the 154 domain ratings reviewed because at least one arm differed from the published label.',
    'These comparisons cannot estimate agreement or published-label accuracy in the full benchmark.',
      'Adjudicators used no AI; each independent rating was made and frozen before the adjudicator saw any label. They then saw only three labels in an order randomised per cell, without rationales or quotations. ',
      'Linearly weighted Cohen\u2019s \u03ba; AC2 is in eTable PLACEHOLDER_RELIABILITY; raw agreement is n/N (x.x%; 95% CI a–b). Post hoc paired differences are ARBITER minus Unassisted agreement with the same independent rating, in percentage points.',CI_NOTE))
  lapply(notes,function(x) reader_label(gsub('PLACEHOLDER_RELIABILITY',supplement_number('Independent and selected ratings: full agreement including AC2'),x,fixed=TRUE)))
}
build_main_tables <- function(inputs) {
  dir.create('output/manuscript',recursive=TRUE,showWarnings=FALSE)
  tables <- list(main_table2(),reliability_table(),main_table3(),prior_work_table())
  captions <- paste0('Table ',1:4,'. ',MAIN_TABLE_TITLES)
  notes <- main_table_notes()
  for(i in seq_along(tables)) {
    doc <- manuscript_doc() |> officer::body_add_par(captions[i],style='heading 1') |>
      flextable::body_add_flextable(main_table_flextable(tables[[i]],i,notes[[i]]))
    print(doc,target=paste0('output/manuscript/Table',i,'.docx'))
  }
  invisible(tables)
}
main_table_widths <- function(i) {
  list(c(1.35,1.35,1.35,1.35,1.45),c(3.1,1.65,2.1),c(2.95,2.2,1.7),c(1.20,.55,.85,.70,.75,.48,.55,.98,.90))[[i]]
}
# Word joiners preserve the en dash while prohibiting a line break on either side.
main_table_no_break_ranges <- function(x) {
  x[] <- lapply(x,function(v) gsub('D1[\u2013-]D5','D1\u2060\u2013\u2060D5',v))
  x
}
main_table_padding <- function(i) if(i %in% 1:2) 1 else 3
main_table_flextable <- function(x,i,note=main_table_notes()[[i]]) {
  x <- main_table_no_break_ranges(x)
  ft <- house_table(x,note) |> flextable::width(j=seq_len(ncol(x)),width=main_table_widths(i))
  ft <- flextable::padding(ft,padding.left=main_table_padding(i),
    padding.right=main_table_padding(i),part='all')
  if(FALSE) {
    ft <- flextable::padding(ft,padding.top=2,padding.bottom=2,part='all') |>
      flextable::set_header_labels(values=setNames(
        'Published\u00a0D1\u2060–\u2060D5\u00a0labels\n(Low/SC/High)',names(x)[5])) |>
      flextable::hline(i=nrow(x)-1,border=officer::fp_border(width=.6),part='body') |>
      flextable::bold(i=nrow(x),j=1,part='body')
  }
  if(i<4) ft <- style_group_rows(ft,x)
  ft
}

MAIN_TABLE_TITLES <- c(LEGACY_TABLE_TITLES[c(2,4,3)],
  'ARBITER combines rule enforcement, quotation checks and blinded adjudication')
main_table_notes <- function() {
  old <- legacy_table_notes()
  list(old[[2]],old[[4]],old[[3]],prior_work_note())
}
prior_work_table <- function() {
  x <- readr::read_csv('data-curated/prior-work-comparison.csv',show_col_types=FALSE)
  stopifnot(all(c('registry_or_protocol_given','identical_inputs_across_compared_arms','reference_key') %in% names(x)),
    x$study_id[1]=='marshall_2016')
  x |> transmute(Study=paste0(if_else(reference_key=='This study','This study (ARBITER)',paste0('[ref: ',reference_key,']')),
      if_else(tool=='RoB 2','',paste0(' (',tool,')')),
      if_else(is.na(note_marks),'',paste0(' [',note_marks,']'))),
    `Rules in code`=rules_applied_in_code,
    `Rules enforced during assessment`=rules_enforced_during_assessment,
    `Rule breaks measured`=rule_breaks_measured,
    `Quotations verified`=quotations_verified_against_stored_source,`Audit file`=audit_file,
    `Agent with tools`=agent_with_tools,`Independent reference or adjudication`=independent_reference_or_adjudication,
    `Registry or protocol given to the model`=registry_or_protocol_given) |>
    mutate(across(-Study,~if_else(.x=='Not reported','NR',.x)))
}
prior_work_note <- function() {
  paste('Yes, documented; No, affirmative absence; NR, Not reported (presence or absence unclear).',
    'Partly means: code, spreadsheet or incomplete rules; enforcement, some configurations or incomplete answer checks; breaks, overall-only or qualitative checks; quotations, semantic judging without occurrence/integrity checks; audit, retained responses without a verifiable source bundle; agent, enabled browsing or retrieval without demonstrated agent tool calls; reference, limited re-review, historical independent teams or text-relevance review; registry/protocol, compressed or restricted delivery.',
    'Structured prompting alone is not enforced rules. Registry/protocol includes SAPs and available records; a registration number alone does not qualify.',
    paste0('This study gave both compared arms identical inputs; other matched model/workflow comparisons also used identical underlying sources (see eTable ',supplement_number('Evidence and quotation locations for the prior-work comparison'),').'),
    'a, Compressed ancillary records; overall-only checks. b, Post hoc Excel derivation; six development trials. c, Prompt rules. d, RoB 2 cohort; protocols when available. e, Masked panel; actual browsing unmeasured. f, One trial, 38 runs. g, Retrieval and retained edits. h, Post hoc support judging. i, ROBINS-I; selected concordant references. j, Recorded overrides permitted; none in 510 domains; disputed-cell adjudication. k, RobotReviewer used RoB 1; its blinded panel judged text relevance.',
    paste0('Reference callouts resolve in the manuscript bibliography. Condensed cell evidence and quotation locations: eTable ',supplement_number('Evidence and quotation locations for the prior-work comparison'),'.'))
}
