METHODS_APPENDIX <- c(
  'Algorithms and validation' = paste('The official 22 August 2019 RoB 2 algorithms were implemented for D1 randomisation,',
    'D2 deviations (effect of assignment), D3 missing outcome data, D4 outcome measurement and D5 selection of the reported result.',
    'Numbered questions map to the 22 exported signalling questions. Required NA or missing answers make a nonempty path invalid;',
    'absent labels or wholly absent answer sets are not evaluable. Overall is the worst domain judgement, with High permitted',
    'when at least two domains have Some concerns. The guidance was cross-checked with ARBITER 1.0.0 source (commit 2f549ae).',
    'Unit tests cover the decision paths and required-answer checks. Bundle proposals reproduce 510/510 domain outputs; no overrides were recorded.',
    'All required active answers in the ARBITER domain histories are present. Unassisted invalid-path sensitivity recursively',
    'resolves required invalid answers as N/PN, then NI; off-path answers are not imputed.'),
  'API list-price reconstruction' = paste('Costs are frozen-rate API list-price equivalents, not expenditure. USD rates per million tokens are:',
    'Sonnet input 2.00, 1-hour cache write 4.00, 5-minute write 2.50, cache read 0.10, output 10.00;',
    'Rates were frozen from the provider pricing documentation on 18 October 2026.',
    'Main-thread assistant events are deduplicated by message identity within turn; synthetic zero-usage events are excluded.',
    'Thinking tokens are included in output. Side calls are total recorded model usage minus terminal usage.',
    'One-hour side-call cache writes are primary; five-minute writes are a sensitivity. Reconstruction bounds coincide.',
    'Routing was global, with no geography multiplier.',
    'For each trial, equivalent US$ = (2 × input + 4 × 1-hour cache writes + 2.5 × 5-minute cache writes + 0.1 × cache reads + 10 × output tokens) / 1,000,000, summed over recorded model calls. Runs used a subscription; these equivalents are not subscription expenditure.',
    'Harness costs are unusable: unrecognised model and unknown cost basis; retained only as supplementary diagnostics.'),
  'Evidence binding and verification' = paste('Each distinct evidence identity cited in bases or counterevidence by current active answers is counted once',
    'per bundle; superseded histories are excluded. Visual records (figure kind or render field) take precedence over text spans.',
    'Text spans (narrative kind or quote/start/end fields) require a nonblank quote and source version, source identity matching a',
    'captured bundle source, finite page/start/end, and start less than end. Quotes are server-extracted spans cited by handle.',
    'Visual binding requires render source matching the record and a captured source, positive integer page, nonblank PNG hash,',
    'four finite region coordinates in [0,1] with ordered corners, and nonblank transcription. Images are server-rendered and hash-bound;',
    'transcriptions are model-written and are not machine-checked against the image. Unknown or missing records are other and unbound',
    'in the overall denominator. Empty bundles contribute no cited records. Trials using visual evidence use all 102 trials as denominator.',
    'These are structural checks, without PDF re-extraction or a judgement of whether a passage supports an answer.',
    'Bundle verification does not establish clinical correctness or completion. Unassisted evidence traces are not available.'),
  'Inference'='All confidence intervals use stratified trial-cluster resampling within meta-analysis, 10000 replicates, percentile intervals and seed 20261018. Paired comparisons share weights. No p-values are used.')
METHODS_APPENDIX <- c(METHODS_APPENDIX,
 'Blinded expert assessment'=paste('Two blinded human experts independently rated every trial domain, without AI, and froze their ratings and signalling answers before viewing labels. They then made a forced choice among three labels shown in random order without rationales, followed by a revised rating. Choice is scored by label; ties credit every matching source. Concordant cells are excluded from preference summaries. The primary estimate uses arm disagreements with equal choices. Revised ratings are descriptive.'),
 'Independent reference and Overall'=paste('Agreement is evaluated against each independent rating, the arithmetic mean of the two expert-specific estimates, and the agreed reference. Derived Overall is the worst independent domain rating; optional escalation is not imposed. The workbook validation separately records every difference in all available columns. Published Overall is compared only on observed labels (n = 81); 21 published reviews gave no Overall label and are excluded, never counted as disagreements. ARBITER and Unassisted use all trials (n = 102) and the same observed subset (n = 81). Every paired Overall contrast involving Published uses that subset (n = 81). Agreed-reference denominators are restricted further to equal expert ratings and printed on each row.'),
 'Signalling question mapping and eligibility'=paste('The ARBITER semantic question identifiers map one-to-one to the official numbered questions (eTable 5); Unassisted numeric identifiers already match the experts. Comparisons require explicit answers to the same question and component on both sides. Scalar answers are never broadcast across components. NA, inactive questions, missing answers, unmatched components and unresolved strings are not evaluable and are counted separately. Five-level matching distinguishes Y, PY, N, PN and NI. Collapsed matching combines Y/PY and N/PN; NI remains separate. Paired differences retain only components evaluable in both arms.'),
 'Input parity and label targets'=paste('Both arms received the same supplied articles, supplements, registry records and protocol or SAP files. The De Waal registry input belongs to a different trial. Published-label target bindings can be broad, inferred or mismatched; the benchmark and label-target tables document these categories.'),
 'Design status and limitations'=paste('The primary estimand and stratified trial bootstrap were prespecified. All new reference analyses were defined by the authors on 21 October 2026 after adjudication data collection; strictness strata and rules-only analyses are post hoc. There are only two experts, with modest agreement, especially in D3. Experts could consult sources beyond the arms’ inputs. Forced choice among three labels may anchor choices. Overall is derived rather than rated directly. System-level attribution, no structured-prompt comparator, a single run per arm, possible training exposure, unassessed quotation support, outcome mismatch and the De Waal input error limit interpretation.'))
METHODS_APPENDIX <- c(METHODS_APPENDIX,
  'Published-label target matching' = paste('The benchmark label-target documentation links each published label to its review, source table, outcome, time point and contrast, with quoted binding evidence where stated and an explicit inference otherwise. The assessment prompt targets the labelled result rather than automatically the trial primary outcome, with the definition, printed result and locator from the trial report. Among the 102 included trials, 33 targets match an explicitly stated result, 11 match one of several covered outcomes, and 32 match an inferred result; 7 partly match, 9 differ and 10 have unknown binding. These categories are retained rather than treating all targets as exact matches. Twelve published label sets (60 domain labels) cover every outcome taken from a trial; another 10 label sets (50 domain labels) have no identified result, and seven more label sets (35 domain labels) jointly cover pain and disability; thus 29 sets (145 domain labels) do not isolate a single result (19 broad and 10 unknown). Binding was inferred rather than explicitly stated for 62 label sets, overlapping these categories. The benchmark documentation and per-review binding evidence support these categories (eTable 11).'),
  'Dates and training exposure' = paste('Trial reports span publication years 1996–2025; the 16 source reviews were published in 2025–2026. Years come from the benchmark trial summaries and trial-label years where that field is blank (eTable 11); the benchmark documentation identifies the SANCTUARY report as 2025. Anthropic documents June 2026 as the training-data cut-off for claude-sonnet-5-5 (model documentation, https://platform.claude.com/docs/en/models/sonnet-5-5/overview, and provider help, https://support.claude.com/en/articles/8114494-how-up-to-date-is-claude-s-training-data; checked 19 October 2026). Dates cannot establish whether a report was used in training.'))
SUPPLEMENT_SPECS <- list(
 c('Confusion matrices against each independent expert','independent-confusion','raw'),
 c('Full independent agreement and paired contrasts','independent-estimates','expert'),
 c('Forced choice on disputed cells','forced-choice','raw'),
 c('Revised ratings and retained or changed answers','revised-ratings','raw'),
 c('Full signalling question agreement','signalling-estimates','estimate'),
 c('Rules only recomputation','rules-only-primary','estimate'),
 c('Agreed reference and paired contrasts','independent-differences','estimate'),
 c('Expert reliability','expert-reliability','estimate'),
 c('Direction of disagreement against independent experts','direction-of-disagreement','estimate'),
 c('Primary endpoint sensitivities and post hoc strata','primary-endpoint','estimate'),
 c('Benchmark trials','benchmark-set','raw'),
 c('Published label agreement','agreement-meta','estimate'),
 c('Unweighted agreement with published labels','agreement-unweighted','estimate'),
 c('Rule consistency and audit','table3-supplement','raw'),
 c('Invalid answer path sensitivity','invalid-path-sensitivity','raw'),
 c('Time cost and token use','table5','raw'),
 c('API cost estimates and reconstruction bounds','api-cost-summary','raw'),
 c('Token reconciliation','api-token-reconciliation','raw'),
 c('Evidence binding','audit-summary','estimate'),
 c('Derived Overall validation differences','derived-overall-validation','mismatches'),
 c('Evidence and quotation locations for the prior-work comparison','prior-work-evidence','raw'))
supplement_number <- function(caption) match(caption,vapply(SUPPLEMENT_SPECS,`[`,character(1),1))
clean_display <- function(x) {
  if('measure' %in% names(x)) x$measure <- tools::toTitleCase(gsub('_',' ',x$measure,fixed=TRUE))
  if('estimate' %in% names(x) && all(c('count','n') %in% names(x))) {
    x$estimate <- paste0(x$count,'/',x$n,' (',fmt_number(100*x$estimate,1),'%)')
    names(x)[names(x)=='estimate'] <- 'Share'
  }
  for(k in names(x)) {
    x[[k]] <- if(is.numeric(x[[k]])) vapply(x[[k]],function(v) if(is.na(v)) '—' else if(v==as.integer(v)) as.character(v) else fmt_number(v),character(1)) else as.character(x[[k]])
    x[[k]][is.na(x[[k]])] <- '—'
    x[[k]] <- reader_label(x[[k]])
  }
  names(x) <- tools::toTitleCase(gsub('_',' ',names(x),fixed=TRUE))
  names(x)[names(x)=='Arm'] <- 'Source'
  x
}
unweighted_display <- function(x) {
  if('population' %in% names(x)) x <- x |> mutate(domain=if_else(domain=='Overall',
    if_else(population=='Observed Published Overall','Overall (observed)','Overall (all)'),domain)) |> select(-population)
  x <- estimate_display(x)
  x$metric[x$metric=='kappa'] <- 'Unweighted κ'
  x
}
signalling_display <- function(x,difference=FALSE) {
  x$value <- if(difference) paste0(fmt_number(100*x$estimate,1),' ',fmt_ci(100*x$lower,100*x$upper,1)) else fmt_estimate(x,TRUE)
  x$level <- if_else(x$level=='five','Five-level exact','Collapsed exact')
  x |> select(adjudicator,any_of('source'),group,any_of(if(difference) 'n' else character()),level,value) |>
    pivot_wider(names_from=level,values_from=value)
}
expert_confusion_display <- function(x) {
  x |> filter(adjudicator %in% c('1','2')) |>
    complete(adjudicator,source,domain,reference=LABELS,predicted=c(LABELS,'Missing'),fill=list(n=0)) |>
    pivot_wider(names_from=predicted,values_from=n,values_fill=0) |>
    select(adjudicator,source,domain,reference,all_of(c(LABELS,'Missing'))) |>
    group_by(adjudicator,source,domain) |> mutate(N=sum(Low+`Some concerns`+High+Missing)) |> ungroup() |>
    arrange(adjudicator,source,domain,match(reference,LABELS)) |> rename(Expert=adjudicator)
}
supplement_entries <- function(inputs) {
  lapply(seq_along(SUPPLEMENT_SPECS),function(i) {
    spec <- SUPPLEMENT_SPECS[[i]]
    if(spec[2]=='prior-work-evidence') {
      x <- readr::read_csv('data-curated/prior-work-evidence-condensed.csv',show_col_types=FALSE)
      readr::write_csv(x,'output/tables/prior-work-evidence.csv',na='')
    } else x <- read_display(spec[2])
    if(spec[2]=='prior-work-evidence') x <- x |> mutate(across(where(is.character),reader_evidence_references))
    if(spec[3]=='expert') x <- bind_rows(expert_display(x),
      expert_display(read_display('independent-differences') |> mutate(source=comparison,count=NA_integer_)),
      expert_display(read_display('expert-reliability') |> mutate(adjudicator='Expert-to-expert',source='Adjudicator 2')))
    if(spec[3]=='estimate') {
      x <- if(spec[2]=='signalling-estimates') signalling_display(x) else
        if(spec[2]=='independent-differences') expert_display(mutate(x,source=comparison,count=NA_integer_)) else
        if(spec[2]=='agreement-meta') agreement_display(x) else
        if(spec[2]=='agreement-unweighted') agreement_display(x) |> rename(`Unweighted κ`=`Weighted κ`) else estimate_display(x)
    }
    if(spec[3]=='mismatches') x <- filter(x,!matches) |> mutate(column=dplyr::recode(column,
      human='Published',kit='ARBITER',nokit='Unassisted',independent='Independent',chosen_label='Forced choice',revised='Revised'))
    if(spec[2]=='independent-confusion') x <- expert_confusion_display(x)
    if(spec[2]=='table3-supplement') x <- x |> select(arm,domain,status,count,n)
    if(spec[2]=='table5') x <- x |> mutate(across(where(is.character),fmt_process_text))
    if(spec[2]=='benchmark-set') x <- benchmark_table(inputs)
    if(spec[2]=='api-cost-summary') x <- x |> pivot_longer(-arm,names_to='measure',values_to='value')
    if(spec[2]=='api-token-reconciliation') x <- x |> pivot_longer(-arm,names_to='measure',values_to='value')
    if(spec[2]=='prior-work-evidence') x <- x |> tidyr::separate_longer_delim(`Quoted cell evidence and locations`,delim='\n')
    list(number=i,title=spec[1],data=clean_display(x),source=spec[2])
  })
}
add_paginated_table <- function(doc,x,title,note='',rows_per_page=25L) {
  slug <- tolower(gsub('[^A-Za-z0-9]+','-',title))
  readr::write_csv(x,paste0('output/tables/display-supplement-',slug,'.csv'),na='')
  # Explicit chunks prevent narrow tables from spilling without their context.
  index <- seq_len(nrow(x))
  chunks <- ceiling(index/rows_per_page)
  if(nrow(x)%%rows_per_page==1L && length(unique(chunks))>1L)
    chunks <- floor((index-1L)*length(unique(chunks))/nrow(x))+1L
  groups <- split(index,chunks)
  if(!length(groups)) return(manuscript_par(doc,'No rows.'))
  for(k in seq_along(groups)) {
    if(k>1) doc <- officer::body_add_break(doc) |> manuscript_par(paste(title,'continued'),style='heading 2')
    ft <- house_table(x[groups[[k]],,drop=FALSE],if(k==length(groups)) note else NULL)
    if(ncol(x)==5L && names(x)[1]=='Guideline') ft <- flextable::width(ft,j=1:5,width=c(.7,.4,1.05,2.75,1.95))
    if(ncol(x)==6L && names(x)[1]=='Reference') ft <- flextable::width(ft,j=1:6,width=c(1,1,1.4,.35,1.8,1.3))
    if(ncol(x)==3L && names(x)[1]=='Study') ft <- flextable::width(ft,j=1:3,width=c(1.1,4.85,.9))
    doc <- flextable::body_add_flextable(doc,ft)
  }
  doc
}
supplement_note <- function(e) {
  population <- if(e$number %in% c(1,2,7)) paste(expert_population_note(),table2_note()) else if(e$number==6)
    'n = 60 for equal choices; n = 80 for expert-specific and split-sensitivity rows. Label ties credit both arms, so preference counts can overlap.' else if(e$number==8)
    'n = 510 for pooled D1–D5; n = 102 for each domain and derived Overall.' else if(e$number==20)
    'All n = 29 differences from n = 612 column–trial checks are shown: 21 published reviews gave no Overall label; seven High escalations are permitted; one Published Low label differs from derived Some concerns. Missing Published labels are excluded from expert agreement, never counted as disagreements.' else ''
  paste(paste0('eTable ',e$number,'.'),CI_NOTE,population,
    'SC, Some concerns; NI, no information; NA, not applicable. Counts and denominators refer to the named cells or answers.')
}
build_supplement <- function(inputs) {
  entries <- supplement_entries(inputs)
  doc <- manuscript_doc() |> manuscript_par('ARBITER supplementary methods and results',style='heading 1') |>
    manuscript_par('Two independent expert references support the assessment of all trial domains. Tables follow the expected order of citation. All estimates are generated from the accompanying CSV files.')
  for(e in entries) doc <- manuscript_par(doc,paste0('eTable ',e$number,' ',e$title))
  for(k in seq_along(METHODS_APPENDIX)) {
    if(k%%3==1) doc <- officer::body_add_break(doc)
    doc <- doc |> manuscript_par(names(METHODS_APPENDIX)[k],style='heading 2') |> manuscript_par(METHODS_APPENDIX[k])
  }
  for(e in entries) {
    message('Supplement eTable ',e$number,': ',e$title)
    doc <- officer::body_add_break(doc) |> manuscript_par(paste0('eTable ',e$number,' ',e$title),style='heading 2')
    doc <- add_paginated_table(doc,e$data,e$title,supplement_note(e),
      if(e$number==21L) 5L else if(ncol(e$data)>6) 18L else 25L)
    if(e$number==2) {
      doc <- officer::body_add_break(doc) |> manuscript_par('Unweighted agreement with each expert',style='heading 2') |>
        add_paginated_table(clean_display(unweighted_display(read_display('expert-unweighted'))),'Unweighted agreement with each expert',paste(expert_population_note(),CI_NOTE))
    }
    if(e$number==4) {
      x <- clean_display(read_display('answer-changes'))
      doc <- officer::body_add_break(doc) |> manuscript_par('Retained and changed signalling answers',style='heading 2') |>
        add_paginated_table(x,'Retained and changed signalling answers','Counts use original workbook question rows, including mixed component changes.')
    }
    if(e$number==5) {
      doc <- officer::body_add_break(doc) |> manuscript_par('Five-level disagreement types (eTable 5)',style='heading 2') |>
        add_paginated_table(clean_display(read_display('signalling-disagreement-types')),'Five-level disagreement types',
          'All evaluable answers for each source and expert. Within-direction: Y↔PY or N↔PN. Cross-direction: disagreements between Y/PY, N/PN or NI. The two counts partition five-level disagreements; N includes agreements.')
      doc <- officer::body_add_break(doc) |> manuscript_par('Paired signalling differences',style='heading 2') |>
        add_paginated_table(clean_display(signalling_display(read_display('signalling-differences'),TRUE)),'Paired signalling differences',CI_NOTE)
      doc <- officer::body_add_break(doc) |> manuscript_par('Signalling comparison eligibility',style='heading 2') |>
        add_paginated_table(clean_display(read_display('signalling-eligibility')),'Signalling comparison eligibility')
    }
    if(e$number==6) {
      doc <- officer::body_add_break(doc) |> manuscript_par('Independent agreement after rules only recomputation',style='heading 2') |>
        add_paginated_table(clean_display(expert_display(read_display('rules-only-agreement'))),'Independent agreement after rules only recomputation',paste(expert_population_note(),CI_NOTE))
      doc <- officer::body_add_break(doc) |> manuscript_par('Cells changed by rules only recomputation',style='heading 2') |>
        add_paginated_table(clean_display(read_display('rules-only-changed')),'Cells changed by rules only recomputation')
    }
  }
  doc <- officer::body_add_break(doc) |> manuscript_par('eFigure 1 Published label agreement varied across reviews',style='heading 2') |>
    officer::body_add_img(src='output/manuscript/eFigure1.png',width=6.7,height=7.7) |> manuscript_par(CI_NOTE)
  doc <- officer::body_add_break(doc) |> manuscript_par('eFigure 2 Domain level signalling agreement',style='heading 2') |>
    officer::body_add_img(src='output/manuscript/eFigure2.png',width=6.7,height=5.4) |> manuscript_par(paste('ARBITER: blue circles; Unassisted: orange squares. Experts are separated by facet. Five-level and collapsed exact agreement, with all domain denominators in eTable 5.',CI_NOTE))
  doc <- officer::body_add_break(doc) |> manuscript_par('eFigure 3 All signalling question paired differences',style='heading 2') |>
    officer::body_add_img(src='output/manuscript/eFigure3.png',width=6.7,height=8.0) |> manuscript_par(paste('Both collapsed and five-level scales are shown, including questions with fewer than 20 paired answers. Blue circles show ARBITER − Unassisted; expert identity is given by row labels. Full numerical values are in eTable 5.',CI_NOTE))
  doc <- officer::body_add_break(doc) |> manuscript_par('AVATAR complete trace',style='heading 1')
  for(b in avatar_trace_blocks(inputs)) {
    readr::write_csv(b$data,paste0('output/tables/avatar-trace-',if(startsWith(b$title,'Part A')) 'answers' else 'evidence','.csv'),na='')
    doc <- manuscript_par(doc,b$title,style='heading 2')
    for(i in seq_len(nrow(b$data))) {
      if(i>1L && (i-1L)%%2L==0L) doc <- officer::body_add_break(doc)
      doc <- manuscript_par(doc,as.character(b$data[[1]][i]),style='heading 2')
      for(k in names(b$data)[-1]) {
        value <- as.character(b$data[[k]][i])
        if(!is.na(value) && nzchar(value)) doc <- manuscript_par(doc,paste0(k,': ',value))
      }
    }
  }
  doc <- officer::body_add_break(doc) |> manuscript_par('Prompt templates and run provenance',style='heading 2')
  prompts <- read_display('prompt-template-example')
  for(i in seq_len(nrow(prompts))) doc <- doc |> manuscript_par(prompts$type[i],style='heading 2') |> manuscript_par(prompts$prompt[i])
  doc <- manuscript_par(doc,'Model claude-sonnet-5-5, medium effort; Claude Code 2.1.278; ARBITER 1.0.0 public commit 2f549ae30f056ff441ea61a04b719968716f2219. Each trial ran once per arm. Runs used a subscription; costs are frozen-rate API list-price equivalents. The reproducibility records include the R and package versions.')
  print(doc,target='output/manuscript/Supplement.docx')
  build_reporting_map()
  invisible(entries)
}

build_reporting_map <- function() {
  checklist <- reporting_checklist() |> select(guideline,item,topic,section,applicability_and_notes)
  doc <- manuscript_doc() |> manuscript_par('TRIPOD LLM and GRRAS reporting map',style='heading 1') |>
    add_paginated_table(clean_display(checklist),'Reporting map','Author credentials, declarations and final pagination require author completion.',15L)
  print(doc,target='output/manuscript/TRIPOD-LLM.docx')
}

# Reader citations preserve the technical locators in the source CSV, outside the display.
reader_evidence_references <- function(x) {
  replacements <- c('bundle-domain-checks.csv'='eTable 14',
    'table3-supplement.csv'='eTable 14', 'audit-summary.csv'='eTable 19',
    'canonical.json and verification.json'='canonical bundle records and verification receipts',
    'docs/round15/BRIEF.md'='the full-coverage expert assessment specification')
  for(old in names(replacements)) x <- gsub(old,replacements[[old]],x,fixed=TRUE)
  x
}
