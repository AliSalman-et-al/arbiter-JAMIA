METHODS_APPENDIX <- c(
  'Algorithms and validation'=paste('The official 22 August 2019 RoB 2 algorithms cover randomisation, deviations from intended interventions (effect of assignment), missing outcome data, outcome measurement and selection of the reported result. Required missing or not-applicable answers invalidate a nonempty question path; absent ratings or wholly absent answer sets are unevaluable. Checks compare each source with the rating implied by its own answers. Proposed and adopted ARBITER ratings are checked separately because a documented override is permitted. No domain overrides were recorded. Source occurrence and structural verification do not establish that evidence supports an answer.'),
  'Benchmark and supplied inputs'=paste('The source set contained 105 trials from 16 purposively selected reviews. Three unsupported designs, Atwine, Haney and Herrmann, were excluded, leaving 102 trials and 510 domain cells. The author confirms Atwine is unsupported despite its incorrect stored design classification; no more specific subtype is established. Reviews were selected across specialties using Europe PMC, prioritizing recent highly cited reviews in high-ranking journals with extractable RoB 2 labels. Search dates and ranking records are unavailable. Within reviews, selection followed table order, up to seven obtainable eligible trials, with availability-dependent replacement and deduplication. This is not a representative sample.'),
  'Targets and input parity'=paste('Before the runs, 43 of 105 trial-primary targets were revised toward the results underlying the published labels. Final tasks specified outcome, comparison, time point and numerical result. Some published labels covered broader, different or uncertain targets; no target-matching filter was applied. Both arms received the same captured trial inputs, with availability varying by trial. Unassisted received captured registry copies and documents acquired during the ARBITER run, rather than new retrievals. The supplied De Waal registry record concerned another trial. Equal inputs therefore do not establish completeness or correctness. The repository trial index retains full targets and source records.'),
  'Blinded expert assessment'=paste('Two blinded published researchers from BEACON Lab independently rated all five domains for all 102 trials without AI, freezing ratings and signalling answers before offered labels. They received the same trial materials and task targets as the arms, including available supplements and ClinicalTrials.gov records, with access to Cochrane guidance. Individual qualifications, prior experience, calibration and multi-outcome conventions remain unprovided. Each expert subsequently chose the most defensible of three labels in cell-randomized order without identities or rationales. Credit follows label equality. Conditional analyses retain the 80 cells where the arms differed; the agreed-choice estimate further retains 60 equal expert choices. The remaining 20 choices split. Expert-specific choices use all 80 cells. The split-loss sensitivity counts splits against ARBITER without assigning Unassisted wins. Later revised ratings were collected but are not analyzed in this focused report.'),
  'Signalling mapping and eligibility'=paste('The 22 semantic ARBITER question identifiers map to the official numbered questions; Unassisted identifiers are already numbered. An answer component is an explicitly named outcome or other part of an answer; a bare answer code has one unnamed component. Names are lowercased and trimmed. Matching requires the same trial, domain, question and component. Scalar answers are not broadcast across components. Missing, inactive, not-applicable, unresolved and unmatched components are excluded. The eligibility panel records exclusions. Absolute agreement uses each source-specific eligible set. Paired differences use the intersection evaluable in both arms. Five-level agreement distinguishes yes, probably yes, no, probably no and no information. Collapsed agreement combines yes/probably yes and no/probably no, retaining no information. The pooled answer group includes all five domains, not a derived Overall rating.'),
  'Exploratory diagnostic checks'=paste('Overall ratings are derived as the worst of the five independent expert domain ratings, without optional escalation for multiple Some concerns domains. They are not directly rated expert Overall judgments or an independent sixth domain. Comparisons retain all 102 trials and both model arms; Published Overall is not included. The post hoc rules-only diagnostic replaces Unassisted ratings that contradict their own signalling answers with the algorithm-implied rating. Invalid paths, missing answers and all other ratings remain unchanged. The 26 changed labels and pooled expert agreement before and after recomputation are descriptive checks, not an ablation or a causal estimate of the rule engine.'),
  'Inference'=paste('All intervals use 10,000 percentile bootstrap replicates, seed 20261018. Trials are sampled within each of the 16 fixed reviews, carrying both arms and all domains together. Paired contrasts share weights. Intervals describe trial variation conditional on these reviews, experts and observed runs. They do not sample new reviews, experts or model runs. No P values or multiplicity adjustments are used. Exact agreement is reported before linearly weighted Cohen κ. The All-Low rule shows the contribution of label prevalence.'),
  'Reporting scope'='Reporting order was adopted after analysis on 23 October 2026 without a formal primary, secondary or confirmatory hierarchy. On 26 October 2026, the author approved a focused report and deletion of redundant code and exports. Expert averages, agreed-reference restrictions, extra source contrasts, binary and extra unweighted metrics, post-exposure summaries, all-disputed choices and strictness/directional strata are omitted. Duplicate supplementary figures, repeated tables and the printed complete AVATAR trace are removed. Complete paired question contrasts, compact derived Overall and rules-only diagnostics, and the current linked AVATAR records remain available. The complete earlier release is recoverable at git revision 54645d75e7a8b32bbf09968893e7be45faa4cab4. Retained estimands, eligibility, numerical results and uncertainty are unchanged. This reduction does not establish prospective specification.',
  'Evidence records and source verification'=paste('ARBITER retains captured documents, versioned extracted text, selected evidence, signalling answers and proposed/adopted ratings. Text selection uses returned passage references, page/line ranges or copied text as a locator. Copied text must match the captured source; unmatched or ambiguous selections are rejected. Software stores the captured source slice with source identity, page and character offsets. The structural audit counts distinct cited records in current active answers, excluding superseded histories. Text spans require quotation, source/version identity and valid page/offset records. Visual records require a captured source, page, PNG hash, valid region and transcription. Image transcriptions are model-written. The audit did not independently re-extract quotations or judge their relevance, completeness or support. Assessment-file verification is a separate structural check. Unassisted evidence traces were unavailable. The repository AVATAR answer and evidence CSVs retain the worked example without duplicating its full trace here.'),
  'Runtime and API equivalents'=paste('Runtime sums recorded model-turn elapsed durations. API list-price equivalents use frozen 18 October 2026 rates in US dollars per million tokens. Sonnet uncached input 2.00, one-hour cache write 4.00, five-minute write 2.50, cache read 0.10 and output 10.00. Output includes thinking tokens. Main-thread events are deduplicated by message identity within turn; synthetic zero-usage events are excluded. Additional-call usage is total recorded model usage minus terminal usage, using one-hour cache writes for the main reconstruction. Equivalents sum the rate-weighted tokens over recorded calls and divide by one million. Routing was global without a geographic multiplier. Runs used a subscription, so equivalents are not expenditure. Source summaries are medians and IQRs; paired contrasts are mean differences. Alternative five-minute cache-write assumptions, reconstruction bounds and signed token gaps are retained in the linked current API ledgers. Human review time was not measured.'))
RUN_PROVENANCE <- c(
  'Both arms used claude-sonnet-5-5 at medium effort in Claude Code 2.1.278, once per trial. ARBITER ran on 12 October 2026 and Unassisted on 14 October. Immutable model-snapshot identity across dates was not established. Isolated settings disabled memory and external connectors. The protocol allowed Continue at most twice per phase without coaching. Unassisted received the task and fixed output-format instruction without RoB 2 guidance. ARBITER additionally received the packaged assessment instructions, RoB 2 guidance and software tools.',
  'The evaluated revision was 2848c7926a2acc25402345a42be39d695a99861a; public ARBITER 1.0.0 is 2f549ae30f056ff441ea61a04b719968716f2219. The evaluated command was /rob2-assess and the public command is /arbiter-assess. Findings concern the evaluated revision. Development included ten prostate-cancer trials and synthetic cases. Benchmark non-use in development is author-attested; complete exposure, prompt-selection and version-freeze histories remain pending.')
SUPPLEMENT_SPECS <- list(c('Benchmark targets and sources','benchmark-trials'),
  c('Agreement with Published labels','published-agreement'),
  c('Agreement with independent experts','expert-agreement'),
  c('Category distributions and disagreements','label-distributions'),
  c('Exploratory diagnostic checks','diagnostic-checks'),
  c('Signalling agreement and eligibility','signalling-agreement'))
supplement_number <- function(caption) match(caption,vapply(SUPPLEMENT_SPECS,`[`,character(1),1))
clean_display <- function(x) {
  for(k in names(x)) {
    if(is.logical(x[[k]])) x[[k]] <- ifelse(x[[k]],'Yes','No')
    x[[k]] <- if(is.numeric(x[[k]])) vapply(x[[k]],function(v) if(!is.finite(v)) '—' else if(v==trunc(v)) format(v,trim=TRUE,scientific=FALSE) else fmt_number(v),character(1)) else as.character(x[[k]])
    x[[k]][is.na(x[[k]])] <- '—'
    x[[k]] <- fmt_process_text(reader_label(x[[k]]))
  }
  names(x) <- tools::toTitleCase(gsub('_',' ',names(x),fixed=TRUE))
  x
}
expert_display <- function(x) {
  x$value <- vapply(seq_len(nrow(x)),function(i) {
    r <- x[i,]
    if(r$metric=='accuracy' && grepl(' minus ',r$source)) return(paste0(fmt_number(100*r$estimate,1),' ',fmt_ci(100*r$lower,100*r$upper,1)))
    fmt_estimate(r,r$metric=='accuracy')
  },character(1))
  x |> select(adjudicator,domain,source,n,metric,value) |>
    pivot_wider(names_from=metric,values_from=value) |>
    rename(Reference=adjudicator,Domain=domain,Source=source,N=n,`Exact agreement or difference (95% CI)`=accuracy,`Weighted κ or difference (95% CI)`=kappa) |>
    mutate(Reference=if_else(Reference %in% c('1','2'),paste('Expert',Reference),Reference))
}
published_supplement <- function() {
  x <- read_display('agreement-meta') |> filter(domain!='Overall',metric %in% c('accuracy','kappa')) |>
    mutate(source=reader_label(arm))
  x$source <- sub(' [(]Sonnet.*','',x$source)
  d <- read_display('agreement-meta-differences') |> filter(domain!='Overall',metric %in% c('accuracy','kappa'),
    comparison=='ARBITER (Sonnet 5.5) minus Unassisted (Sonnet 5.5)') |>
    mutate(source='ARBITER minus Unassisted',n=if_else(domain=='D1-D5',510L,102L),count=NA_integer_)
  bind_rows(x,d) |> mutate(adjudicator='Published') |> expert_display() |> select(-Reference)
}
independent_supplement <- function() {
  x <- read_display('independent-estimates') |> filter(domain!='Overall',adjudicator %in% c('1','2'))
  d <- read_display('independent-differences') |> filter(domain!='Overall',adjudicator %in% c('1','2'),comparison=='ARBITER minus Unassisted') |> mutate(source=comparison,count=NA_integer_)
  r <- read_display('expert-reliability') |> filter(domain!='Overall') |> mutate(adjudicator='Expert-to-expert',source='Expert 2')
  expert_display(bind_rows(x,d,r))
}
trial_index <- function(inputs) {
  x <- inputs$trials |> arrange(meta_id,slug)
  roles <- c(protocol='P',sap='A',registry='R',supplement='S')
  documents <- read_display('benchmark-documents') |> filter(available) |> arrange(match(document_type,names(roles))) |>
    group_by(slug) |> summarise(`Supplied sources`=paste(unname(roles[document_type]),collapse=', '),.groups='drop')
  targets <- inputs$targets |> select(slug,`Target alignment`=assess_vs_label)
  x |> transmute(Trial=slug,Review=meta_id) |> left_join(targets,by=c('Trial'='slug')) |>
    left_join(documents,by=c('Trial'='slug')) |> mutate(`Supplied sources`=replace_na(`Supplied sources`,'Article only'))
}
label_distribution_display <- function() {
  x <- read_display('severity-distribution') |> filter(population=='D1-D5')
  x$value <- fmt_fraction(x$count,x$n)
  x |> select(source,label,value) |> pivot_wider(names_from=label,values_from=value) |> rename(Source=source)
}
category_disagreements <- function() {
  x <- read_display('independent-confusion') |> filter(source %in% c('ARBITER','Unassisted'),domain!='Overall',adjudicator %in% c('1','2')) |>
    group_by(adjudicator,source,reference,predicted) |> summarise(n=sum(n),.groups='drop') |>
    complete(adjudicator,source,reference=LABELS,predicted=c(LABELS,'Missing'),fill=list(n=0L))
  x |> pivot_wider(names_from=predicted,values_from=n) |>
    mutate(adjudicator=paste('Expert',adjudicator)) |>
    rename(Reference=adjudicator,Source=source,`Expert rating`=reference) |>
    select(Reference,Source,`Expert rating`,all_of(c(LABELS,'Missing')))
}
overall_diagnostic <- function() {
  x <- read_display('independent-estimates') |> filter(domain=='Overall',metric=='accuracy',
    adjudicator %in% c('1','2'),source %in% c('ARBITER','Unassisted'),population=='All trials')
  x$value <- fmt_estimate(x,TRUE)
  x <- x |> select(adjudicator,source,value) |> pivot_wider(names_from=source,values_from=value)
  d <- read_display('independent-differences') |> filter(domain=='Overall',metric=='accuracy',
    adjudicator %in% c('1','2'),comparison=='ARBITER minus Unassisted',population=='All trials') |>
    transmute(adjudicator,`Paired difference (95% CI)`=paste0(fmt_number(100*estimate,1),' ',fmt_ci(100*lower,100*upper,1)))
  left_join(x,d,by='adjudicator') |> mutate(adjudicator=paste('Expert',adjudicator)) |> rename(Reference=adjudicator)
}
rules_diagnostic <- function() {
  before <- read_display('independent-estimates') |> filter(source=='Unassisted',domain=='D1-D5',metric=='accuracy',adjudicator %in% c('1','2'))
  after <- read_display('rules-only-agreement') |> filter(source=='Unassisted',domain=='D1-D5',metric=='accuracy',adjudicator %in% c('1','2'))
  tibble(Reference=paste('Expert',before$adjudicator),`Original Unassisted`=fmt_estimate(before,TRUE)) |>
    left_join(tibble(Reference=paste('Expert',after$adjudicator),`Recomputed Unassisted`=fmt_estimate(after,TRUE)),by='Reference')
}
signalling_supplement <- function() {
  x <- read_display('signalling-estimates') |> filter(group %in% c('Overall',paste0('D',1:5)))
  x$value <- fmt_estimate(x,TRUE)
  x <- x |> select(adjudicator,group,level,source,value) |> pivot_wider(names_from=source,values_from=value)
  d <- read_display('signalling-differences') |> filter(group %in% c('Overall',paste0('D',1:5))) |>
    transmute(adjudicator,group,level,`Paired N`=n,`Paired difference (95% CI)`=paste0(fmt_number(100*estimate,1),' ',fmt_ci(100*lower,100*upper,1)))
  left_join(x,d,by=c('adjudicator','group','level')) |>
    mutate(adjudicator=paste('Expert',adjudicator),group=if_else(group=='Overall','Pooled',group),level=if_else(level=='five','Five-level','Collapsed')) |>
    rename(Reference=adjudicator,Domain=group,Coding=level) |> select(Reference,Domain,Coding,ARBITER,Unassisted,everything())
}
paired_question_display <- function() {
  x <- read_display('signalling-differences') |> filter(grepl('^[1-5][.][0-9]+$',group))
  sizes <- x |> group_by(adjudicator,group) |> summarise(rows=n(),denominators=n_distinct(n),.groups='drop')
  stopifnot(all(sizes$rows==2L),all(sizes$denominators==1L))
  x$value <- paste0(fmt_number(100*x$estimate,1),' ',fmt_ci(100*x$lower,100*x$upper,1))
  x$value[x$n==0L] <- 'Not evaluable'
  x |> select(adjudicator,group,n,level,value) |> pivot_wider(names_from=level,values_from=value) |>
    arrange(adjudicator,as.numeric(group)) |> mutate(adjudicator=paste('Expert',adjudicator)) |>
    rename(Reference=adjudicator,Question=group,`Paired N`=n,`Five-level difference (95% CI)`=five,`Collapsed difference (95% CI)`=collapsed)
}
supplement_entries <- function(inputs) {
  data <- list(trial_index(inputs),published_supplement(),independent_supplement(),
    label_distribution_display(),overall_diagnostic(),signalling_supplement())
  lapply(seq_along(SUPPLEMENT_SPECS),function(i) list(number=i,title=SUPPLEMENT_SPECS[[i]][1],
    source=SUPPLEMENT_SPECS[[i]][2],data=data[[i]]))
}
SUPPLEMENT_HTML <- new.env(parent=emptyenv())
SUPPLEMENT_HTML$tables <- list()
supplement_display_slug <- function(title) tolower(gsub('[^A-Za-z0-9]+','-',title))
add_paginated_table <- function(doc,x,title,note='',rows_per_page=18L) {
  x <- reader_table(x)
  readr::write_csv(x,paste0('output/tables/display-supplement-',supplement_display_slug(title),'.csv'),na='')
  if(!nrow(x)) return(manuscript_par(doc,'No rows.'))
  groups <- split(seq_len(nrow(x)),ceiling(seq_len(nrow(x))/rows_per_page))
  for(k in seq_along(groups)) {
    if(k>1L) doc <- officer::body_add_break(doc) |> manuscript_par(paste0(title,' (continued ',k,')'),style='heading 2')
    tab <- house_table(x[groups[[k]],,drop=FALSE],note)
    SUPPLEMENT_HTML$tables[[length(SUPPLEMENT_HTML$tables)+1L]] <- gt::as_raw_html(tab,inline_css=FALSE)
    doc <- add_gt(doc,tab)
  }
  doc
}
supplement_note <- function(e) {
  specific <- switch(e$source,
    'benchmark-trials'='Target alignment reproduces the recorded relationship between the assessed result and Published target, including uncertainty. Source codes show availability in the captured input inventory: P, protocol; A, statistical analysis plan; R, registry; S, supplement. Every trial has an article. Availability does not establish completeness or correct identity. Complete targets, source identifiers and alignment notes are linked in the resource index.',
    'published-agreement'='Published is the reference. Pooled D1 to D5 has 510 cells; each domain has 102. All-Low predicts Low for every cell. Exact agreement is n/N (%); its paired difference is in percentage points. κ is linearly weighted; its paired difference is in coefficient units. A dash marks an undefined or omitted value.',
    'expert-agreement'='Each expert independently rated all 510 cells, 102 per domain, before seeing offered labels. The Expert-to-expert rows compare the two independent references. Exact agreement is n/N (%); its paired difference is in percentage points. κ is linearly weighted; its paired difference is in coefficient units. References are kept separate.',
    'label-distributions'='Each source contributes 510 domain labels. Categories are Low, Some concerns and High. Values are n/N (%). The following pooled cross-tabulation describes category disagreements against each expert; neither expert is treated as an error-free reference.',
    'diagnostic-checks'='Overall is the worst of five independent expert domain ratings, without optional escalation; it was not rated independently. Each arm comparison uses 102 trials. Paired differences are ARBITER minus Unassisted in percentage points. Published Overall is omitted because its available-label population differs. The following rules-only panel is a post hoc arithmetic diagnostic, not a component ablation.',
    'signalling-agreement'='ARBITER and Unassisted cells show matched/source-specific eligible components (%; 95% CI). Paired N is the intersection evaluable in both arms, so absolute rates need not subtract to the paired difference. Paired differences are percentage points. Five-level distinguishes yes/probably yes/no/probably no/no information. Collapsed combines yes/probably yes and no/probably no; no information stays separate. Pooled includes all five domains.')
  paste(specific,if(e$source %in% c('published-agreement','expert-agreement','diagnostic-checks','signalling-agreement')) CI_NOTE else '')
}
build_supplement <- function(inputs) {
  entries <- supplement_entries(inputs)
  SUPPLEMENT_HTML$tables <- list()
  doc <- manuscript_doc() |> manuscript_par('ARBITER supplementary methods and results',style='heading 1') |>
    manuscript_par('This focused supplement documents benchmark targets and sources, agreement with Published labels and each independent expert, category disagreements and diagnostic checks. Main Table 2 contains conditional-choice sensitivities and Table 3 contains process and resource results. The resource index links complete worked-example records and reproducibility materials.') |>
    manuscript_par('Contents and stable display locators',style='heading 2') |> officer::body_add_toc(level=2)
  for(k in seq_along(METHODS_APPENDIX)) doc <- doc |> manuscript_par(names(METHODS_APPENDIX)[k],style='heading 2') |> manuscript_par(METHODS_APPENDIX[k])
  for(e in entries) {
    doc <- officer::body_add_break(doc) |> manuscript_par(paste0('eTable ',e$number,'. ',e$title),style='heading 2')
    doc <- add_paginated_table(doc,e$data,e$title,supplement_note(e),if(ncol(e$data)>6L) 12L else 18L)
    if(e$source=='label-distributions') {
      doc <- manuscript_par(doc,'eTable 4A. Pooled category disagreements',style='heading 2') |>
        add_paginated_table(category_disagreements(),'Pooled category disagreements','Rows are each expert reference category; columns are the model prediction. Counts sum to 510 cells for every expert/arm pair. Missing predictions remain explicit. These are disagreements with imperfect references, not verified clinical errors.',12L)
    }
    if(e$source=='diagnostic-checks') {
      reliability <- read_display('expert-reliability') |> filter(domain=='Overall',metric=='accuracy')
      doc <- manuscript_par(doc,paste('The experts agreed on',fmt_fraction(reliability$count,reliability$n),'derived Overall ratings.')) |>
        manuscript_par('eTable 5A. Rules-only recomputation',style='heading 2') |>
        add_paginated_table(rules_diagnostic(),'Rules-only recomputation',paste('Exactly 26 Unassisted domain labels were replaced by the ratings implied by their own answers. Invalid paths and missingness were retained. Each expert comparison uses all 510 domain cells. This post hoc diagnostic does not isolate the causal contribution of software rules.',CI_NOTE),18L)
    }
    if(e$source=='signalling-agreement') {
      doc <- officer::body_add_break(doc) |> manuscript_par('eTable 6A. Complete paired question diagnostics',style='heading 2') |>
        add_paginated_table(paired_question_display(),'Complete paired question diagnostics',paste('All official questions and both codings are shown against each expert. Differences are ARBITER minus Unassisted in percentage points on the same paired eligible components. Sparse and zero-denominator rows remain visible; Not evaluable indicates zero paired components. Official wording is available in the linked question map.',CI_NOTE),18L)
      eligibility <- read_display('signalling-eligibility') |> mutate(adjudicator=paste('Expert',adjudicator)) |>
        rename(Reference=adjudicator,Source=source,Domain=domain,Evaluable=evaluable,Reason=reason,N=count) |> clean_display()
      doc <- officer::body_add_break(doc) |> manuscript_par('eTable 6B. Eligibility counts',style='heading 2') |>
        add_paginated_table(eligibility,'Signalling eligibility counts','Counts are question components in the comparison frame, not trials. Eligibility requires the same explicit question and component. Exclusion reasons are mutually exclusive within each source comparison. Paired contrasts use the intersection.',18L)
    }
  }
  doc <- officer::body_add_break(doc) |> manuscript_par('Prompt templates and run provenance',style='heading 2')
  prompts <- read_display('prompt-template-example')
  for(i in seq_len(nrow(prompts))) doc <- doc |> manuscript_par(prompts$type[i],style='heading 2') |> manuscript_par(prompts$prompt[i])
  for(line in RUN_PROVENANCE) doc <- manuscript_par(doc,line)
  doc <- manuscript_par(doc,'Linked source records and reproducibility materials',style='heading 2')
  resources <- c('Complete AVATAR answers'='analysis/output/tables/avatar-trace-answers.csv',
    'Complete AVATAR evidence and quotations'='analysis/output/tables/avatar-trace-evidence.csv',
    'Complete benchmark targets and alignment notes'='rob2-meta-benchmark-set/LABEL-TARGETS.csv',
    'Trial and source manifest'='rob2-meta-benchmark-set/TRIAL-SUMMARY.csv',
    'Official signalling-question map'='analysis/output/tables/question-map.csv',
    'The 26 labels changed by rules-only recomputation'='analysis/output/tables/rules-only-changed.csv',
    'Hypothetical invalid-path completion sensitivity'='analysis/output/tables/invalid-path-sensitivity.csv',
    'API reconstruction bounds and cache sensitivity'='analysis/output/tables/api-cost-summary.csv',
    'Signed token reconciliation'='analysis/output/tables/api-token-reconciliation.csv')
  for(label in names(resources)) doc <- officer::body_add_fpar(doc,officer::fpar(
    officer::hyperlink_ftext(text=label,href=paste0('https://github.com/AliSalman-et-al/arbiter-JAMIA/blob/main/',resources[[label]]))))
  save_manuscript_doc(doc,'output/manuscript/Supplement.docx')
  writeLines(paste(SUPPLEMENT_HTML$tables,collapse='\n<!--GT_TABLE_BOUNDARY-->\n'),'output/manuscript/qa/supplement-gt.html')
  build_reporting_map()
  invisible(entries)
}
build_reporting_map <- function() {
  SUPPLEMENT_HTML$tables <- list()
  checklist <- reporting_checklist()
  readr::write_csv(checklist,'output/tables/reporting-checklist-skeleton.csv',na='')
  checklist <- checklist |> select(guideline,item,topic,section,applicability_and_notes)
  doc <- manuscript_doc() |> manuscript_par('TRIPOD LLM and GRRAS reporting map',style='heading 1') |>
    add_paginated_table(clean_display(checklist),'Reporting map','The previous IMRaD draft was removed for a fresh manuscript. Pending manuscript sections, author credentials, declarations, text-date coverage and archive details require completion. Other locators identify retained analysis and supplement materials.',8L)
  save_manuscript_doc(doc,'output/manuscript/TRIPOD-LLM.docx')
  writeLines(paste(SUPPLEMENT_HTML$tables,collapse='\n<!--GT_TABLE_BOUNDARY-->\n'),'output/manuscript/qa/reporting-gt.html')
}
