METHODS_APPENDIX <- c(
  'Algorithms and validation' = paste('The official 22 August 2019 RoB 2 algorithms were implemented for D1 randomisation,',
    'D2 deviations (effect of assignment), D3 missing outcome data, D4 outcome measurement and D5 selection of the reported result.',
    'Numbered questions map to the 22 exported signalling questions. Required NA or missing answers make a nonempty path invalid;',
    'absent labels or wholly absent answer sets are not evaluable. Overall is the worst domain judgment, with High permitted',
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
    'Harness costs are unusable: unrecognized model and unknown cost basis; retained only as supplementary diagnostics.'),
  'Evidence binding and verification' = paste('Each distinct evidence identity cited in bases or counterevidence by current active answers is counted once',
    'per bundle; superseded histories are excluded. Visual records (figure kind or render field) take precedence over text spans.',
    'Text spans (narrative kind or quote/start/end fields) require a nonblank quote and source version, source identity matching a',
    'captured bundle source, finite page/start/end, and start less than end. Quotes are server-extracted spans cited by handle.',
    'Visual binding requires render source matching the record and a captured source, positive integer page, nonblank PNG hash,',
    'four finite region coordinates in [0,1] with ordered corners, and nonblank transcription. Images are server-rendered and hash-bound;',
    'transcriptions are model-written and are not machine-checked against the image. Unknown or missing records are other and unbound',
    'in the overall denominator. Empty bundles contribute no cited records. Trials using visual evidence use all 102 trials as denominator.',
    'These are structural checks, without PDF re-extraction or a judgment of whether a passage supports an answer.',
    'Bundle verification does not establish clinical correctness or completion. Unassisted evidence traces are not available.'),
  'Inference'='All confidence intervals use stratified trial-cluster resampling within meta-analysis, 10000 replicates, percentile intervals and seed 20261018. Paired comparisons share weights. No P values are used.')
METHODS_APPENDIX <- c(METHODS_APPENDIX,
 'Blinded expert assessment'=paste('Two blinded human experts independently rated every trial domain, without AI, and froze their ratings and signalling answers before viewing labels. They then made a forced choice among three labels shown in random order without rationales, followed by a revised rating. Choice is scored by label; ties credit every matching source. Concordant cells are excluded from preference summaries. The primary estimate uses arm disagreements with equal choices. Revised ratings are descriptive. The assessment sequence is documented in the expert assessment specification and completed workbooks. Author completion is required for the original blank form and instructions, assessor qualifications and training, the target brief, and conventions for judging targets containing several outcomes.'),
 'Independent reference and Overall'=paste('Agreement is evaluated against each independent rating, the arithmetic mean of the two expert-specific estimates, and the agreed reference. Derived Overall is the worst independent domain rating; optional escalation is not imposed. The workbook validation separately records every difference in all available columns. Published Overall is compared only on observed labels (n = 81); 21 trials had no observed Published Overall label and are excluded, never counted as disagreements. ARBITER and Unassisted use all trials (n = 102) and the same observed subset (n = 81). Every paired Overall contrast involving Published uses that subset (n = 81). Agreed-reference denominators are restricted further to equal expert ratings and printed on each row.'),
 'Signalling question mapping and eligibility'=paste('The ARBITER semantic question identifiers map one-to-one to the official numbered questions (see Signalling question mapping and eligibility); Unassisted numeric identifiers already match the experts. A component is an explicitly named part of a signalling answer; a bare answer code has one unnamed component. Component names are lowercased and trimmed; unresolved or duplicate components are flagged. Matching requires the same trial, domain, question and component. Comparisons require explicit answers to the same question and component on both sides. Scalar answers are never broadcast across components. NA, inactive questions, missing answers, unmatched components and unresolved strings are not evaluable and are counted separately. Five-level matching distinguishes Y, PY, N, PN and NI. Collapsed matching combines Y/PY and N/PN; NI remains separate. Paired differences retain only components evaluable in both arms. Independent expert domain ratings are read directly from the Independent column of the Adjudications sheet; the analysis does not derive these ratings by aggregating signalling-answer components.'),
 'Input parity and label targets'=paste('Both arms received the same supplied articles, supplements, registry records and protocol or SAP files. The De Waal registry input belongs to a different trial. Published-label target bindings can be broad, inferred or mismatched; the benchmark and label-target tables document these categories.'),
 'Interpretive limits'=paste('The formal primary endpoint is conditional on arm disagreement and equal expert choices. Independent comparisons cover all 510 domain cells against each expert separately. Derived Overall, direction, rules-only recomputation, severity strata and binary analyses are exploratory. Only two experts contributed; experts could consult sources beyond the arms’ inputs. Label exposure may anchor subsequent choices and revised ratings. One run per arm, possible training exposure and unassessed semantic evidence support limit interpretation. Published labels may refer to broad or different assessment targets; all 510 domain cells remain in Published-reference comparisons. The De Waal registry input belongs to another trial.'))
METHODS_APPENDIX['Inference'] <- 'Frequency percentages and percentage confidence limits use whole numbers for denominators below 100 and one decimal otherwise. Paired percentage-point effects retain one decimal and ordinal coefficients two decimals. All analytical values retain full stored precision. Intervals use 10,000 percentile bootstrap replicates, seed 20261018. Trials are sampled with replacement within the 16 fixed reviews, retaining paired arms and all domain ratings. These intervals do not sample new reviews, experts or model runs. Supporting analyses are secondary or exploratory; no P values or multiplicity adjustments are used.'
METHODS_APPENDIX['Input parity and label targets'] <- 'Both arms received identical supplied trial documents, including available ancillary records. Assessment prompts specified outcome, time point, contrast and printed result. Published assessment targets can be broad, inferred or mismatched. No target-matching subset, filter, stratum or sensitivity is used. The benchmark README specifies within-review selection by table order and availability-dependent replacement. Author completion is required for initial review identification and eligibility.'
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
ROUND15_SUPPLEMENT_SPECS <- SUPPLEMENT_SPECS
SUPPLEMENT_SPECS <- c(SUPPLEMENT_SPECS,list(c('Exploratory binary agreement against each expert','independent-binary','estimate')))
# Each section supports a reader question. Do not duplicate paired contrast collections.
SUPPLEMENT_SPECS <- Filter(function(x) !x[2] %in% c('independent-differences','prior-work-evidence'),SUPPLEMENT_SPECS)
SUPPLEMENT_SPECS <- c(SUPPLEMENT_SPECS,list(c('Category distributions','severity-distribution','raw'),
  c('Derived Overall agreement and paired contrasts','independent-estimates','overall'),
  c('Prior work evidence ledger','literature-ledger','raw')))
SUPPLEMENT_GROUPS <- list(
  '1. Reproducibility and methods'=c('benchmark-set'),
  '2. Full domain agreement evidence'=c('independent-estimates','severity-distribution','expert-reliability','independent-confusion','agreement-meta','agreement-unweighted','independent-binary'),
  '3. Primary endpoint and supporting analyses'=c('primary-endpoint','forced-choice','direction-of-disagreement','revised-ratings'),
  '4. Signalling diagnostics and rules-only recomputation'=c('signalling-estimates','rules-only-primary','invalid-path-sensitivity'),
  '5. Derived Overall and missingness'=c('overall','derived-overall-validation'),
  '6. Process and resources'=c('table3-supplement','audit-summary','table5','api-cost-summary','api-token-reconciliation'),
  '7. Prior work and reporting'=c('literature-ledger'))
spec_key <- function(x) if(x[3]=='overall') 'overall' else x[2]
keys <- vapply(SUPPLEMENT_SPECS,spec_key,character(1))
SUPPLEMENT_SPECS <- SUPPLEMENT_SPECS[match(unlist(SUPPLEMENT_GROUPS,use.names=FALSE),keys)]
supplement_group <- function(spec) names(SUPPLEMENT_GROUPS)[vapply(SUPPLEMENT_GROUPS,function(x) spec_key(spec) %in% x,logical(1))]
supplement_number <- function(caption) match(caption,vapply(SUPPLEMENT_SPECS,`[`,character(1),1))
# Keep comparator rows for a reference/domain together. Question panels use a
# complete domain block, never an arbitrary split partway through its questions.
display_block_parts <- function(x) {
  expert <- if('Expert' %in% names(x)) x$Expert else if('Reference' %in% names(x)) x$Reference else rep('',nrow(x))
  if('Group' %in% names(x)) {
    group <- as.character(x$Group)
    domain <- ifelse(grepl('^[1-5][.]',group),paste0('D',substr(group,1,1)),'Domain summaries')
  } else domain <- if('Domain' %in% names(x)) as.character(x$Domain) else rep('',nrow(x))
  list(expert=expert,domain=domain)
}
order_display <- function(x) {
  if(!any(c('Domain','Group') %in% names(x))) return(x)
  parts <- display_block_parts(x)
  domain_levels <- c('Domain summaries','D1–D5','D1-D5',paste0('D',1:5),'Overall','Overall (all)','Overall (observed)')
  dom <- match(parts$domain,domain_levels)
  dom[is.na(dom)] <- length(domain_levels)+match(parts$domain[is.na(dom)],unique(parts$domain[is.na(dom)]))
  source <- if('Source' %in% names(x)) sub(' [(]Sonnet.*','',as.character(x$Source)) else rep('',nrow(x))
  source_levels <- c('ARBITER','Unassisted','Published','All-Low rule','ARBITER minus Unassisted','ARBITER minus Published','Unassisted minus Published')
  sr <- match(source,source_levels);sr[is.na(sr)]<-length(source_levels)+match(source[is.na(sr)],unique(source[is.na(sr)]))
  gr <- if('Group' %in% names(x)) match(x$Group,unique(x$Group)) else rep(0,nrow(x))
  x[order(match(parts$expert,unique(parts$expert)),dom,gr,sr),,drop=FALSE]
}
clean_display <- function(x) {
  if('measure' %in% names(x)) x$measure <- tools::toTitleCase(gsub('_',' ',x$measure,fixed=TRUE))
  if('estimate' %in% names(x) && all(c('count','n') %in% names(x))) {
    x$estimate <- paste0(x$count,'/',x$n,' (',fmt_percent(x$estimate,x$n),'%)')
    names(x)[names(x)=='estimate'] <- 'Share'
  }
  if('share' %in% names(x) && all(c('count','n') %in% names(x))) {
    x$share <- fmt_fraction(x$count,x$n)
    names(x)[names(x)=='share'] <- 'No./total (%)'
  }
  for(k in names(x)) {
    if(is.logical(x[[k]])) x[[k]] <- ifelse(x[[k]],'Yes','No')
    x[[k]] <- if(is.numeric(x[[k]])) vapply(x[[k]],function(v) if(is.na(v)) '—' else if(v==as.integer(v)) format(v,trim=TRUE,scientific=FALSE,big.mark=',') else fmt_number(v),character(1)) else as.character(x[[k]])
    x[[k]][is.na(x[[k]])] <- '—'
    x[[k]] <- fmt_process_text(reader_label(x[[k]]))
  }
  names(x) <- gsub('_',' ',names(x),fixed=TRUE)
  names(x) <- paste0(toupper(substr(names(x),1,1)),substring(names(x),2))
  names(x)[names(x)=='Arm'] <- 'Source'
  names(x)[names(x)=='Adjudicator'] <- 'Expert'
  order_display(x)
}
unweighted_display <- function(x) {
  if('population' %in% names(x)) x <- x |> mutate(domain=if_else(domain=='Overall',
    if_else(population=='Observed Published Overall','Overall (observed)','Overall (all)'),domain)) |> select(-population)
  x <- estimate_display(x)
  x$metric[x$metric=='kappa'] <- 'Unweighted κ'
  x
}
signalling_display <- function(x,difference=FALSE) {
  x$value <- if(difference) ifelse(is.finite(x$estimate),paste0(fmt_number(100*x$estimate,1),' ',fmt_ci(100*x$lower,100*x$upper,1)),'—') else fmt_estimate(x,TRUE)
  x$level <- if(difference) if_else(x$level=='five','Five-level Δ, pp (95% CI)','Collapsed Δ, pp (95% CI)') else if_else(x$level=='five','Five-level exact','Collapsed exact')
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
    } else if(spec[2]=='literature-ledger') x <- literature_ledger() else x <- read_display(spec[2])
    if(spec[2]=='prior-work-evidence') x <- x |> mutate(across(where(is.character),reader_evidence_references))
    if(spec[3] %in% c('expert','overall')) {
      domain_filter <- function(d) if(spec[3]=='overall') filter(d,domain=='Overall') else filter(d,domain!='Overall')
      x <- bind_rows(expert_display(domain_filter(x)),
        expert_display(domain_filter(read_display('independent-differences')) |> mutate(source=comparison,count=NA_integer_)),
        expert_display(domain_filter(read_display('expert-reliability')) |> mutate(adjudicator='Expert-to-expert',source='Expert 2')))
    }
    if(spec[2]=='primary-endpoint') x <- x |> mutate(metric=if_else(analysis=='Split sensitivity' & metric=='Neither','Assumed losses from split choices',metric))
    if(spec[2]=='expert-reliability') x <- filter(x,domain!='Overall')
    if(spec[2]=='rules-only-primary') x <- x |> mutate(metric=if_else(analysis=='Split sensitivity' & metric=='Neither','Neither or assumed split losses',metric))
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
    if(spec[2]=='api-cost-summary') x <- x |> pivot_longer(-arm,names_to='measure',values_to='value') |> mutate(value=sprintf('%.2f',value))
    if(spec[2]=='api-token-reconciliation') {
      x <- x |> pivot_longer(-arm,names_to='measure',values_to='value') |>
        mutate(Unit=if_else(grepl('_(input|write1|write5|read|output)$',measure),'Tokens',if_else(grepl('requests',measure),'Requests',if_else(measure=='compaction_events','Events','Turns'))))
      x$measure <- gsub('write1','one-hour cache writes',x$measure,fixed=TRUE)
      x$measure <- gsub('write5','five-minute cache writes',x$measure,fixed=TRUE)
      x$measure <- gsub('_',' ',x$measure,fixed=TRUE)
    }
    if(spec[2]=='api-cost-summary') names(x)[names(x)=='value'] <- 'API list-price equivalent (US$)'
    if(spec[2]=='audit-summary') names(x)[names(x)=='value'] <- 'Proportion (95% CI)'

    if(spec[2]=='prior-work-evidence') x <- x |> tidyr::separate_longer_delim(`Quoted cell evidence and locations`,delim='\n')
    list(number=i,title=spec[1],data=clean_display(x),source=spec[2],group=supplement_group(spec))
  })
}
SUPPLEMENT_HTML <- new.env(parent=emptyenv())
SUPPLEMENT_HTML$tables <- list()
SUPPORT_LOCATORS <- c('Unweighted agreement with each expert'='eTable 2A',
 'Paired binary differences'='eTable 8A','Retained and changed signalling answers'='eTable 12A',
 'Five-level disagreement types'='eTable 13A','Paired signalling differences'='eTable 13B',
 'Signalling comparison eligibility'='eTable 13C','Independent agreement after rules only recomputation'='eTable 14A',
 'Cells changed by rules only recomputation'='eTable 14B')
add_paginated_table <- function(doc,x,title,note='',rows_per_page=20L) {
  slug <- tolower(gsub('[^A-Za-z0-9]+','-',title))
  readr::write_csv(x,paste0('output/tables/display-supplement-',slug,'.csv'),na='')
  locator <- unname(SUPPORT_LOCATORS[title])
  if(is.na(locator)) locator <- if(title=='Reporting map') 'Reporting map' else paste0('eTable ',supplement_number(title))
  if(title %in% names(SUPPORT_LOCATORS)) doc <- manuscript_par(doc,paste(locator,title),style='heading 2')
  # Keep contiguous reference/domain (or source/metric) blocks together. Long
  # narrative rows get their own panel; each panel repeats its title and note.
  if(any(c('Domain','Group') %in% names(x))) {
    parts <- display_block_parts(x)
    keys <- paste(parts$expert,parts$domain,sep=' | ')
  } else keys <- if('Guideline' %in% names(x)) paste(x$Guideline,x$Item) else rep('all',nrow(x))
  blocks <- split(seq_len(nrow(x)),cumsum(c(TRUE,keys[-1]!=keys[-length(keys)])))
  limit <- if(ncol(x)>6) 12 else if('Group' %in% names(x)) 20 else 17
  if(any(vapply(x,function(v) max(nchar(as.character(v)),na.rm=TRUE)>200,logical(1)))) limit <- 5
  if(title=='Benchmark trials') limit <- 9L
  if(title=='Reporting map') limit <- 8L
  limit <- min(limit,rows_per_page)
  groups <- list(); current <- integer()
  for(block in blocks) {
    if(length(current)+length(block)>limit && length(current)) { groups[[length(groups)+1L]]<-current; current<-integer() }
    if(length(block)>limit) {
      parts <- split(block,ceiling(seq_along(block)/limit)); groups <- c(groups,parts)
    } else current <- c(current,block)
  }
  if(length(current)) groups[[length(groups)+1L]]<-current
  if(!length(groups)) return(manuscript_par(doc,'No rows.'))
  for(k in seq_along(groups)) {
    if(k>1) {
      continued <- if(title=='Reporting map') title else paste0(locator,'. ',title)
      doc <- officer::body_add_break(doc) |> manuscript_par(paste0(continued,' (continued ',k,')'),style='heading 2')
    }
    tab <- house_table(x[groups[[k]],,drop=FALSE],note)
    SUPPLEMENT_HTML$tables[[length(SUPPLEMENT_HTML$tables)+1L]] <- gt::as_raw_html(tab,inline_css=FALSE)
    doc <- add_gt(doc,tab)
  }
  doc
}
SIGNALLING_NOTE <- paste('ARBITER minus Unassisted in percentage points (pp); positive values favor ARBITER.',
 'n counts question components evaluable in both arms. Five-level distinguishes Y/PY/N/PN/NI;',
 'collapsed combines Y/PY and N/PN, with NI separate. Y, yes; PY, probably yes; N, no; PN, probably no; NI, no information. —: no eligible paired component.',CI_NOTE)
ELIGIBILITY_NOTE <- 'Counts are question components in the comparison frame, not trials. Evaluable requires the same explicit question/component on both sides. Exclusions are mutually exclusive recorded eligibility reasons. Paired contrasts use the intersection. See eMethods Signalling question mapping and eligibility.'
supplement_note <- function(e) {
  specific <- switch(e$source,
 `benchmark-set`=paste('Counts summarize five Published domain labels per trial. Overall given denotes label availability. SC, Some concerns.',TOPIC_ABBREVIATIONS),
 `independent-estimates`=if(startsWith(e$group,'5.')) 'Derived Overall: all-label comparisons use 102 trials per expert for ARBITER and Unassisted; observed-label comparisons use the same 81 trials for all three sources and every paired contrast involving Published. Twenty-one missing Published labels are excluded. The agreed reference restricts to equal expert ratings: 52 trials for all-label comparisons and 42 for observed-label comparisons. Expert-to-expert Overall uses 102 trials. N is printed by row. Exact agreement is a percentage; paired differences subtract the second named source from the first, in percentage points for exact agreement and coefficient units for κ. κ is linearly weighted. Expert means average the two expert-specific estimates.' else 'D1–D5 pools 510 cells per expert; individual domains have 102. The agreed reference includes 388 pooled cells; domain-specific denominators are printed. Exact agreement is a percentage; paired differences subtract the second named source from the first, in percentage points for exact agreement and coefficient units for κ. κ is linearly weighted. Expert means average the two expert-specific estimates.',
 `severity-distribution`='Counts partition Low, Some concerns and High for each source. Domains pool 510 cells. Derived Overall uses 102 trials for the arms and experts, and 81 observed Published labels; 21 missing Published labels are excluded.',
 `expert-reliability`='Expert 1 versus Expert 2. Pooled D1–D5: 510 cells; each domain: 102. Exact agreement is the percentage of equal labels; κ is linearly weighted.',
 `independent-confusion`='Rows are independent-expert categories; columns are source predictions; entries are cell counts. N is the total across all three reference rows in each expert/source/domain matrix, not a row total. Each domain has 102 cells. Overall uses 102 trials for the arms and 81 observed Published labels.',
 `agreement-meta`='Published is the reference. Cohen κ is linearly weighted; AC2 is Gwet AC2. Some concerns or High is positive. Sensitivity uses Published-positive cells; specificity uses Published-Low cells. Exact agreement and binary metrics are n/N (%), with percentage CI bounds. Pooled domains: 510; each domain: 102; Overall: 81 observed labels. All-Low reports agreement and specificity only by reporting convention; — denotes an omitted or not-applicable coefficient.',
 `agreement-unweighted`='Published is the reference. κ is unweighted; exact agreement is n/N (%) with percentage CI bounds. Each domain has 102 cells; Overall uses 81 observed Published labels, excluding 21 missing labels.',
 `independent-binary`='Exploratory. Some concerns or High is positive. Sensitivity denominators are expert-positive cells; specificity denominators are expert-Low cells. D1–D5 pools 510 cells; each domain has 102. Paired ARBITER minus comparator differences are percentage points.',
 `primary-endpoint`='The formal primary row uses 60 agreed choices from 80 arm-discordant cells. Twenty split choices are counted against ARBITER by assumption only in the designated sensitivity. Expert-specific sensitivities use 80 cells. Stricter/more lenient describes ARBITER relative to Unassisted among the 60 agreed choices; these strata are exploratory.',
 `forced-choice`='Disputed cells include disagreement of either arm with Published, distinct from the 80 arm-discordant cells. Choices are scored by label. When sources share the chosen label, each receives credit; counts overlap and need not sum to 154.',
 `direction-of-disagreement`='Exploratory. Direction compares the named source with Published. n counts those differing domain cells; outcomes partition independent expert matches to the source, Published or neither.',
 `revised-ratings`='Post-exposure ratings follow label presentation and are descriptive, not independent reference assessments. Counts and shares refer to the named workbook population.',
 `signalling-estimates`='Absolute rates use source-specific eligible question components; paired differences use the shared eligible intersection (eTable 13B). Five-level distinguishes Y/PY/N/PN/NI; collapsed combines Y/PY and N/PN, with NI separate. Y, yes; PY, probably yes; N, no; PN, probably no; NI, no information. Numerators and denominators are printed in absolute-rate cells. — means no eligible source-specific question components.',
 `rules-only-primary`='Rules-only repair retains recorded answers, missingness and original endpoint eligibility. Equal-choice n=60; expert-specific and split sensitivity n=80. Label ties credit both arms, so source-match counts can overlap. Neither or assumed split losses (21) comprises one neither result plus 20 split choices counted against ARBITER by assumption.',
 `invalid-path-sensitivity`='Unassisted count summaries. Original contradictions are labels inconsistent with recorded answers; invalid paths omit required answers. Recursive replacement resolves required invalid answers as N/PN (No/Probably no) or NI (No information), without imputing off-path answers. Additional contradictions are newly exposed by replacement; final total is original plus additional (29 or 62 pooled).',
 `derived-overall-validation`='All 29 differences from 612 column–trial checks are retained: 21 absent Published Overall labels, seven permitted High escalations and one Published Low versus derived Some concerns. Missing labels are excluded in agreement comparisons.',
 `table3-supplement`='Counts use the named evaluable ratings. Audit rows count active answers, distinct evidence records or bundles, as named. — means unavailable or not measured for the comparator, not zero. Structural binding and source occurrence do not establish semantic evidence support.',
 `audit-summary`='Rows name distinct objects: active answers, text spans, image records or bundles. Values are proportions (95% CI). — means unavailable or not measured for the comparator, not zero. Structural checks do not establish that evidence supports an answer.',
 `table5`='Source summaries are medians (IQR); paired ARBITER minus Unassisted contrasts are mean differences (95% CI). Runtime is wall-clock minutes per trial; costs are frozen-rate API list-price equivalents in US$/trial across 102 paired trials, not invoices or human time.',
 `api-cost-summary`='All values are API list-price equivalents in US$. Totals cover 102 trials per arm; medians are per trial. Point is reconstructed recorded usage; lower/upper are reconstruction bounds, not confidence limits. Primary side-call cache writes assume one hour; Side 5m is the five-minute sensitivity. Harness figures are unusable diagnostic records: unrecognized model and unknown cost basis. Runs used a subscription; equivalents are not expenditure.',
 `api-token-reconciliation`='Input means uncached input tokens; Read means cached input tokens; Output includes generated and thinking tokens. Token totals and request/event/turn counts are distinguished by Unit. Request: deduplicated main-thread request counters; Result: terminal usage counters; Side: total recorded model usage minus terminal usage. Gap = Result minus Request, so negative gaps mean request counters exceed terminal counters. High requests exceed 100,000 input/cache tokens. Side without compaction counts turns with side usage and no recorded compaction; request excess counts turns with any negative gap.',
 `literature-ledger`='Targeted primary-source comparison, not a systematic review or performance ranking. Not reported differs from absent. URLs identify primary publications.', '')
 inferential <- e$source %in% c('independent-estimates','expert-reliability','agreement-meta','agreement-unweighted','independent-binary','primary-endpoint','direction-of-disagreement','signalling-estimates','rules-only-primary','audit-summary','table5')
 paste(specific,if(inferential) CI_NOTE else '')
}
build_supplement <- function(inputs) {
  entries <- supplement_entries(inputs)
  SUPPLEMENT_HTML$tables <- list()
  doc <- manuscript_doc() |> manuscript_par('ARBITER supplementary methods and results',style='heading 1') |>
    manuscript_par('This supplement follows seven questions: how to reproduce the evaluation; how domain ratings agree; how the conditional primary endpoint behaves; which signalling answers differ; how derived Overall and missingness are handled; what procedural checks and computation establish; and how the system relates to prior work. Estimates are generated from the accompanying analysis exports.')
  map <- c('Reproduce the evaluation: eMethods, eTable 1; full prompts and AVATAR trace at the end.',
   'Interpret domain agreement: eTables 2–8 and 2A/8A; eFigures 1 and 3.',
   'Read the conditional primary result: eTables 9–12 and 12A.',
   'Inspect signalling and rule diagnostics: eTables 13–15 and 13A–13C/14A–14B; eFigures 2, 4 and 5.',
   'Separate derived Overall and observed missingness: eTables 16–17.',
   'Distinguish process checks from computational burden: eTables 18–22.',
   'Locate prior work and reporting statements: eTable 23 and the separate TRIPOD-LLM/GRRAS map.')
  for(line in map) doc <- manuscript_par(doc,line)
  doc <- officer::body_add_break(doc) |> manuscript_par('Contents and stable display locators',style='heading 2') |> officer::body_add_toc(level=2)
  for(k in seq_along(METHODS_APPENDIX)) {
    if(k%%3==1) doc <- officer::body_add_break(doc)
    doc <- doc |> manuscript_par(names(METHODS_APPENDIX)[k],style='heading 2') |> manuscript_par(METHODS_APPENDIX[k])
  }
  previous_group <- ''
  for(e in entries) {
    new_group <- e$group!=previous_group
    if(new_group) {
      doc <- officer::body_add_break(doc) |> manuscript_par(e$group,style='heading 1')
      doc <- manuscript_par(doc,supplement_section_intro(e$group))
      previous_group <- e$group
    }
    message('Supplement eTable ',e$number,': ',e$title)
    if(!new_group) doc <- officer::body_add_break(doc)
    doc <- manuscript_par(doc,paste0('eTable ',e$number,' ',e$title),style='heading 2')
    doc <- add_paginated_table(doc,e$data,e$title,supplement_note(e),
      if(e$source=='prior-work-evidence') 5L else if(ncol(e$data)>6) 18L else 20L)
    if(e$source=='independent-binary') {
      doc <- officer::body_add_break(doc) |>
        add_paginated_table(clean_display(binary_difference_display(read_display('independent-binary-differences'))),'Paired binary differences',supplement_note(e),30L)
    }
    if(e$source=='independent-estimates' && startsWith(e$group,'2.')) {
      doc <- officer::body_add_break(doc) |>
        add_paginated_table(clean_display(unweighted_display(read_display('expert-unweighted'))),'Unweighted agreement with each expert',paste('Unweighted Cohen κ against each independent expert; each domain has 102 cells. Overall (all) uses 102 trials for ARBITER and Unassisted. Overall (observed) uses the common 81 trials with Published labels for every source, excluding 21 missing Published labels. N is printed by row.',CI_NOTE))
    }
    if(e$source=='revised-ratings') {
      x <- clean_display(read_display('answer-changes'))
      doc <- officer::body_add_break(doc) |>
        add_paginated_table(x,'Retained and changed signalling answers','Counts use original workbook question rows, including mixed component changes.')
    }
    if(e$source=='signalling-estimates') {
      doc <- officer::body_add_break(doc) |>
        add_paginated_table(clean_display(read_display('signalling-disagreement-types')),'Five-level disagreement types',
          'All evaluable answers for each source and expert. Y, yes; PY, probably yes; N, no; PN, probably no; NI, no information. Within-direction: Y↔PY or N↔PN. Cross-direction: disagreements between Y/PY, N/PN or NI. The two counts partition five-level disagreements; the N column counts eligible components, including agreements.')
      doc <- officer::body_add_break(doc) |>
        add_paginated_table(clean_display(signalling_display(read_display('signalling-differences'),TRUE)),'Paired signalling differences',SIGNALLING_NOTE)
      doc <- officer::body_add_break(doc) |>
        add_paginated_table(clean_display(read_display('signalling-eligibility') |> select(-evaluable)),'Signalling comparison eligibility',ELIGIBILITY_NOTE)
    }
    if(e$source=='rules-only-primary') {
      doc <- officer::body_add_break(doc) |>
        add_paginated_table(clean_display(expert_display(read_display('rules-only-agreement'))),'Independent agreement after rules only recomputation',paste(expert_population_note(),CI_NOTE))
      doc <- officer::body_add_break(doc) |>
        add_paginated_table(clean_display(read_display('rules-only-changed') |> rename(`Original arms differed`=discordant,`Experts chose the same label`=consensus)),'Cells changed by rules only recomputation','Unassisted original and recomputed labels. Original arms differed and Experts chose the same label are fixed original-cell flags; the latter concerns forced-choice labels, not independent ratings. Original endpoint eligibility remains fixed. All 26 changes are shown.')
    }
  }
  message('Supplement: figures')
  captions <- c('Absolute agreement by domain and derived Overall','Collapsed question-level paired differences',
    'Published label agreement across reviews','Domain-level signalling agreement','All signalling question paired differences')
  figure_manifest <- list()
  for(i in seq_along(captions)) {
    panels <- if(i %in% c(2,5)) paste0('eFigure',i,'-D',1:5) else paste0('eFigure',i)
    for(panel in panels) {
      title <- paste('eFigure',i,captions[i],if(length(panels)>1) paste0(' (',sub('.*-','',panel),' panel)') else '')
      w <- 6.86; h <- w*if(i %in% c(2,5)) 175/174 else c(150,175,200,140,175)[i]/174
      doc <- officer::body_add_break(doc) |> manuscript_par(title,style='heading 2') |>
        officer::body_add_img(src=paste0('output/manuscript/',panel,'.png'),width=w,height=h) |>
        manuscript_par(tail(figure_legend_sections(),5)[i])
      figure_manifest[[length(figure_manifest)+1L]] <- tibble(figure=paste0('eFigure',i),panel=panel,width_inches=w,height_inches=h,pdf=paste0(panel,'.pdf'),png=paste0(panel,'.png'))
    }
  }
  readr::write_csv(bind_rows(figure_manifest),'output/manuscript/qa/figure-panels.csv')
  message('Supplement: AVATAR complete trace')
  doc <- officer::body_add_break(doc) |> manuscript_par('AVATAR complete trace',style='heading 1')
  for(b in avatar_trace_blocks(inputs)) {
    readr::write_csv(b$data,paste0('output/tables/avatar-trace-',if(startsWith(b$title,'Part A')) 'answers' else 'evidence','.csv'),na='')
    doc <- manuscript_par(doc,b$title,style='heading 2')
    for(i in seq_len(nrow(b$data))) {
      if(i>1L && grepl('^D[1-5] judgement',b$data[[1]][i])) doc <- officer::body_add_break(doc)
      doc <- manuscript_par(doc,as.character(b$data[[1]][i]),style='heading 2')
      fields <- names(b$data)[-1]
      fields <- fields[vapply(fields,function(k) !is.na(b$data[[k]][i]) && nzchar(as.character(b$data[[k]][i])),logical(1))]
      for(k in fields) {
        value <- as.character(b$data[[k]][i])
        if(k=='Full verbatim quote') {
          # Bound paragraph height, retaining verbatim words in order. Each
          # continuation repeats the handle; metadata stays with quote start.
          chunks <- character()
          while(nchar(value)>900) {
            cut <- max(gregexpr('[[:space:]]',substr(value,1,900))[[1]])
            if(cut<1) cut <- 900
            chunks <- c(chunks,substr(value,1,cut))
            value <- substr(value,cut+1,nchar(value))
          }
          chunks <- c(chunks,value)
          for(j in seq_along(chunks)) {
            if(j>1) doc <- officer::body_add_fpar(doc,officer::fpar(
              officer::ftext(paste0('Context: ',b$data[[1]][i],' (quote continued)')),
              fp_p=officer::fp_par(keep_with_next=TRUE)),style='Manuscript body')
            doc <- officer::body_add_fpar(doc,officer::fpar(
              officer::ftext(paste0(if(j==1) paste0(k,': ') else '',chunks[j])),
              fp_p=officer::fp_par(keep_with_next=FALSE)),style='Manuscript body')
          }
        } else doc <- officer::body_add_fpar(doc,officer::fpar(
          officer::ftext(paste0(k,': ',value)),
          fp_p=officer::fp_par(keep_with_next=k!=tail(fields,1))),style='Manuscript body')
      }
    }
  }
  message('Supplement: prompts and provenance')
  doc <- officer::body_add_break(doc) |> manuscript_par('Prompt templates and run provenance',style='heading 2')
  prompts <- read_display('prompt-template-example')
  for(i in seq_len(nrow(prompts))) doc <- doc |> manuscript_par(prompts$type[i],style='heading 2') |> manuscript_par(prompts$prompt[i])
  doc <- manuscript_par(doc,'Model claude-sonnet-5-5, medium effort; Claude Code 2.1.278; evaluated rob2-kit commit 2848c7926a2acc25402345a42be39d695a99861a; public ARBITER 1.0.0 commit 2f549ae30f056ff441ea61a04b719968716f2219. Each trial ran once per arm. Runs used a subscription; costs are frozen-rate API list-price equivalents. The reproducibility records include the R and package versions. The evaluated runner invoked /rob2-assess; /arbiter-assess is the public command name. The retained release audit documents this command-name correspondence but does not establish equivalence of the complete releases. Final templates and a filled example document the evaluation inputs; author completion is required for prompt design and selection, development data, any benchmark overlap and version-freeze provenance.')
  message('Supplement: writing Word document')
  print(doc,target='output/manuscript/Supplement.docx')
  message('Supplement: reporting map')
  writeLines(paste(SUPPLEMENT_HTML$tables,collapse='\n<!--GT_TABLE_BOUNDARY-->\n'),'output/manuscript/qa/supplement-gt.html')
  build_reporting_map()
  invisible(entries)
}

build_reporting_map <- function() {
  SUPPLEMENT_HTML$tables <- list()
  checklist <- reporting_checklist() |> select(guideline,item,topic,section,applicability_and_notes)
  doc <- manuscript_doc() |> manuscript_par('TRIPOD LLM and GRRAS reporting map',style='heading 1') |>
    add_paginated_table(clean_display(checklist),'Reporting map','Author credentials, declarations, text-date coverage and archive details require author completion. Current section titles and stable display numbers identify reported material.',15L)
  print(doc,target='output/manuscript/TRIPOD-LLM.docx')
  writeLines(paste(SUPPLEMENT_HTML$tables,collapse='\n<!--GT_TABLE_BOUNDARY-->\n'),'output/manuscript/qa/reporting-gt.html')
}

# Reader citations preserve the technical locators in the source CSV, outside the display.
reader_evidence_references <- function(x) {
  replacements <- c('bundle-domain-checks.csv'=paste('eTable',supplement_number('Rule consistency and audit')),
    'table3-supplement.csv'=paste('eTable',supplement_number('Rule consistency and audit')), 'audit-summary.csv'=paste('eTable',supplement_number('Evidence binding')),
    'canonical.json and verification.json'='canonical bundle records and verification receipts',
    'docs/round15/BRIEF.md'='the full-coverage expert assessment specification')
  for(old in names(replacements)) x <- gsub(old,replacements[[old]],x,fixed=TRUE)
  gsub('(?<!e)Table 2[.]','Table 3.',x,perl=TRUE)
}

supplement_section_intro <- function(group) switch(substr(group,1,1),
  '1'='The methods above specify software, inputs, expert sequence, eligibility and inference. The benchmark table identifies the review populations. Complete prompts and the worked trace follow the results.',
  '2'='Separate expert references remain visible. Exact agreement and ordinal coefficients describe different aspects of agreement. Paired contrasts carry shared trial weights; expert agreement is context, not a performance ceiling.',
  '3'='The formal primary endpoint conditions on arm disagreement and agreed choices. Subsequent ratings and severity strata are supporting descriptive analyses.',
  '4'='Signalling diagnostics compare the same eligible question components. Collapsing answer levels changes the estimand. Rules-only recomputation retains recorded answers and invalid paths and cannot isolate a component effect.',
  '5'='Overall is derived from five domains and is not an independent sixth domain. Expert comparisons cover 102 trials; every Published Overall comparison uses only 81 observed labels. Twenty-one missing labels are excluded.',
  '6'='Rule conformance, structural record checks and computational burden answer separate questions. Source occurrence does not establish semantic support. Human workload and cost-effectiveness were not measured.',
  '7'='The evidence ledger situates this available workflow alongside related systems. The separate TRIPOD-LLM and GRRAS item map identifies reporting locations and author-completion fields.')
literature_ledger <- function() {
  tibble(Study=c('RobotReviewer (2016)','ROBoto2 (2025)','Huang et al. (2025)','Xiong et al. (2026)','Gandhi et al. (2026)','Li et al. (2026)','Lai et al. (2026)','ARBITER (this study)'),
    `Task and workflow`=c('RoB 1 automated judgments and supporting text','Interactive RoB 2 retrieval and user correction','Structured RoB 2 prompts; answer-derived ratings','RoB 1 direct command versus constrained prompts','Structured RoB 2 prompts','RoB 1 human–AI collaboration modes','RoB 2 decision logic in prompts; repeated assessments','RoB 2 model interpretation with executable rules and retained source records'),
    `Evaluation and interpretation`=c('Judgments and text relevance evaluated','System and evaluation dataset','Fresh reviewers and Cochrane references','158 trials; same-model prompt comparison','50 trials; review labels and fresh human panel','Human-use intervention; workload findings do not transfer here','Published review references','102 trials; two separate independent experts; full same-model workflow comparison'),
    `Primary source`=c('https://doi.org/10.1093/jamia/ocv044','https://aclanthology.org/2025.emnlp-demos.2/','https://www.jmir.org/2025/1/e70450','https://pubmed.ncbi.nlm.nih.gov/42144258/','https://doi.org/10.1371/journal.pone.0353155','https://pubmed.ncbi.nlm.nih.gov/41559613/','https://doi.org/10.2196/84915','https://github.com/AliSalman-et-al/ARBITER/tree/2f549ae30f056ff441ea61a04b719968716f2219'))
}
