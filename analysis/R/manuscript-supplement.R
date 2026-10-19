METHODS_APPENDIX <- c(
  'Algorithms and validation' = paste('The official 22 August 2019 RoB 2 algorithms were implemented for D1 randomisation,',
    'D2 deviations (effect of assignment), D3 missing outcome data, D4 outcome measurement and D5 selection of the reported result.',
    'Numbered questions map to the 22 exported signalling questions. Required NA or missing answers make a nonempty path invalid;',
    'absent labels or wholly absent answer sets are not evaluable. Overall is the worst domain judgement, with High permitted',
    'when at least two domains have Some concerns. The guidance was cross-checked with ARBITER 1.0.0 source (commit 2f549ae).',
    'Unit tests cover the decision paths and required-answer checks. Bundle proposals reproduce 510/510 Sonnet and 505/505',
    'observed Haiku domain outputs. One Haiku adoption overrides a Low proposal to Some concerns; rationale and evidence are retained.',
    'All required active answers in the ARBITER domain histories are present. Unassisted invalid-path sensitivity recursively',
    'resolves required invalid answers as N/PN, then NI; off-path answers are not imputed.'),
  'API list-price reconstruction' = paste('Costs are frozen-rate API list-price equivalents, not expenditure. USD rates per million tokens are:',
    'Sonnet input 2.00, 1-hour cache write 4.00, 5-minute write 2.50, cache read 0.10, output 10.00;',
    'Haiku at prompts of at most 100,000 tokens: 0.10, 0.20, 0.125, 0.01, 0.50; above 100,000: 0.50, 1.00, 0.625, 0.05, 2.50.',
    'Rates were frozen from the provider pricing documentation on 18 October 2026.',
    'Main-thread assistant events are deduplicated by message identity within turn; synthetic zero-usage events are excluded.',
    'Prompt length is input plus cache creation plus cache read. Terminal output is allocated by request share for the point estimate',
    'and wholly to lower/higher tiers for bounds. Thinking tokens are already included in output.',
    'Signed terminal-minus-request input residuals, including negative retry residuals, are retained and allocated at lower-tier,',
    'request-share and higher-tier rates. Side calls are total recorded model usage minus terminal usage. Compaction uses high-tier pricing and',
    'one-hour writes; five-minute writes are a sensitivity. Side-call turns without a compaction boundary are flagged and bounded.',
    'All trial bounds are ordered; Sonnet bounds coincide. Routing was global, with no geography multiplier.',
    'Harness costs are unusable: unrecognised model and unknown cost basis; retained only as supplementary diagnostics.'),
  'Error localisation' = paste('Losses are consensus cells where a source label differs from preferred. A reference adjudicator is usable only',
    'when their independent judgement equals consensus preferred. Primary requires both; sensitivity at least one. Haiku is excluded.',
    'Y/PY collapse to Y and N/PN to N; NI and NA remain separate. Discordance requires all usable adjudicators to agree on a parsed',
    'answer different from the losing answer. Adjudicator disagreements are separately flagged, never errors.',
    'A single replacement is decisive if it changes a valid algorithm output, even if the new output is not preferred.',
    'Other answers, including inactive NA, stay fixed; invalid substituted paths are not decisive.',
    'First applicable cell class: judgement departs from own answers; single decisive question; several decisive questions;',
    'jointly decisive (all discordant replacements reach preferred); no discordant questions with complete comparisons; not attributable.',
    'The no-discordance class can contain adjudicator-disagreement questions. Reference-judgement departures from their own answers are flagged.',
    'Frequencies count all individually decisive questions regardless of cell class; joint sets contribute none.',
    'Ambiguous or qualified answers are not imputed. Published losses cannot be localised without signalling answers.'),
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
  'Inference and references' = paste('All estimates use the fixed 102-trial set. CIs use 10,000 trial-cluster bootstrap replicates stratified by',
    'meta-analysis, percentile intervals (quantile type 7), seed 20261018; the same weights support paired differences.',
    'Missing predictions count as wrong. For ordinal coefficients a missing prediction receives maximal disagreement; a paired observed-cell',
    'Haiku sensitivity is reported. Independent signalling-answer agreement uses the earlier exploratory Y/PY, N/PN and NI/NA collapse.',
    'Higgins JPT, Savović J, Page MJ, Sterne JAC, editors. Revised Cochrane risk-of-bias tool for randomized trials (RoB 2), 22 August 2019. https://www.riskofbias.info/welcome/rob-2-0-tool/current-version-of-rob-2.',
    'Salman A et al. ARBITER 1.0.0, public source release, commit 2f549ae. https://github.com/AliSalman-et-al/ARBITER/tree/2f549ae30f056ff441ea61a04b719968716f2219.',
    'Anthropic. Claude API pricing. Accessed 18 October 2026. https://platform.claude.com/docs/en/about-claude/pricing.'))

SUPPLEMENT_ABBREVIATIONS <- paste('CI, confidence interval; IQR, interquartile range; USD, US dollars;',
  'AC2, Gwet’s linearly weighted agreement coefficient; κ, linearly weighted Cohen’s kappa; RoB 2, risk of bias tool for randomised trials; D1–D5, its five domains;',
  'Y/PY, yes/probably yes; N/PN, no/probably no; NI, no information; NA, not applicable.',
  'All counts are numbers of the units named in the headers; — means undefined or not applicable.')
trial_display <- function(x) {
  # Author/year is the benchmark's reader-facing trial identifier.
  vapply(strsplit(x,'-',fixed=TRUE),function(z) {
    year <- z[grepl('^[12][0-9]{3}$',z)]
    author <- if(z[1]=='award') toupper(paste(z[1:2],collapse='-')) else tools::toTitleCase(z[1])
    paste(author,paste(year,collapse=' / '))
  },character(1),USE.NAMES=FALSE)
}
reader_field <- function(x) {
  map <- c(arm='Source',source='Source',domain='Domain',analysis='Analysis',metric='Measure',
    status='Measure',value='n/N (%)',n='Eligible cells (n)',missing='Missing predictions (n)',
    count='Count (n)',question='Question',adjudicator='Adjudicator',population='Population',
    proposed='Proposed judgement',adopted='Adopted judgement',rationale='Recorded rationale',
    slug='Trial',raw='Recorded answer',issue='Parsing issue',short_text='Signalling question',
    consensus_losses='Ratings not chosen (cells)',primary='Primary eligible (cells)',sensitivity='Sensitivity eligible (cells)',
    original_violations='Original violations (cells)',invalid_paths='Invalid paths (cells)',
    additional_violations='Additional violations (cells)',resolution='Replacement answer',violations='Violations after replacement (cells)',
    answer_code_only='Answer-code-only fields (n)',Field='Field',Value='Value',comparison='Comparison')
  result <- unname(map[x]); unknown <- is.na(result)
  result[unknown] <- gsub('_',' ',x[unknown],fixed=TRUE)
  result[unknown] <- paste0(toupper(substr(result[unknown],1,1)),substr(result[unknown],2,nchar(result[unknown])))
  result
}
wide_diagnostics <- function(x,labels,digits=0) {
  vals <- lapply(setdiff(names(x),'arm'),function(k) {
    tibble(Measure=unname(labels[k]),arm=x$arm,Value=if(digits==0) fmt_process_text(format(x[[k]],trim=TRUE,scientific=FALSE,big.mark=',')) else fmt_number(x[[k]],digits))
  }) |> bind_rows()
  stopifnot(!anyNA(vals$Measure))
  vals |> pivot_wider(names_from=arm,values_from=Value)
}
confusion_display <- function(x) {
  # Keep a Missing column only in the source/domain block that needs it.
  pred <- c(LABELS,if(any(x$predicted=='Missing' & x$n>0)) 'Missing')
  x |> filter(predicted %in% pred,meta %in% LABELS) |>
    mutate(meta=factor(meta,levels=LABELS),predicted=factor(predicted,levels=pred)) |>
    arrange(meta,predicted) |> select(Published=meta,predicted,n) |>
    pivot_wider(names_from=predicted,values_from=n,names_expand=TRUE,values_fill=0)
}
supplement_estimates <- function(x,ids) {
  if('quoted' %in% names(x)) x$count <- x$quoted
  if('correct' %in% names(x)) x$count <- x$correct
  x[['Estimate (95% CI)']] <- fmt_estimate(x,'count' %in% names(x))
  if('metric' %in% names(x)) x[['Estimate (95% CI)']][x$metric=='kappa' & (is.na(x$estimate)|x$lower==x$upper)] <- '—'
  x |> select(all_of(ids),`Estimate (95% CI)`)
}
supplement_registry <- function(inputs) {
  entries <- list()
  add <- function(caption,data,note=CI_NOTE,blocks=NULL) {
    entries[[length(entries)+1L]] <<- list(caption=caption,data=data,
      note=paste(note,SUPPLEMENT_ABBREVIATIONS),blocks=blocks)
  }
  metadata <- readr::read_csv('data-curated/meta-analyses.csv',show_col_types=FALSE)
  add('Published label distributions by domain',manuscript_data('table1') |>
    select(meta_id,Trials=trials,D1:D5) |> left_join(metadata |> select(meta_id,specialty,topic),by='meta_id') |>
    arrange(specialty!='General medicine',specialty,topic) |> select(Specialty=specialty,Topic=topic,Trials,D1:D5),
    paste('Each D1–D5 cell gives Low / Some concerns / High counts; 102 trials. Source journals and years are in main Table 1.',TOPIC_ABBREVIATIONS))
  add('Time, cost and token use per trial by model',bind_rows(
    manuscript_data('table5') |> rename(ARBITER=`ARBITER-Sonnet`,Unassisted=`Baseline-Sonnet`) |> mutate(Model='Sonnet 5.5',.before=1),
    manuscript_data('table5-haiku') |> rename(ARBITER=`ARBITER-Haiku`,Unassisted=`Baseline-Haiku`) |> mutate(Model='Haiku 5.5',.before=1)),
    paste('102 trials per arm; per-trial median [IQR] and paired mean ARBITER minus Unassisted difference (95% CI). USD denotes API list-price equivalent, not expenditure; thinking is included in output.',CI_NOTE))
  # Redundant process-summary export is deliberately not a reader table.
  for(ref in c('meta','composite')) {
    x <- manuscript_data(paste0('agreement-',ref))
    if(ref=='composite') x <- filter(x,metric %in% c('kappa','AC2','accuracy'))
    add(if(ref=='meta') 'Agreement against Published, all sources and domains' else 'Agreement against the composite reference, Sonnet only',
      agreement_display(x),if(ref=='meta') paste(AGREEMENT_NOTE,CI_NOTE) else paste('Linearly weighted κ and AC2; exact agreement is n/N (x.x%; 95% CI a–b). The composite uses the adjudicators’ agreed choice on cells where both adjudicators agreed and Published elsewhere; split cells are excluded. Adjudicators chose among three offered labels. Cells where both arms matched Published were never adjudicated and are assumed correct. Both features inflate absolute composite values.',CI_NOTE))
  }
  consistency <- manuscript_data('table3-supplement') |> mutate(status=coalesce(unname(MEASURE_LABELS[status]),status))
  consistency$value <- fmt_fraction(consistency$count,consistency$n)
  add('RoB 2 consistency and structural audit, all sources and domains',consistency |>
    select(domain,status,arm,value) |> pivot_wider(names_from=arm,values_from=value),paste('Values are n/N (%). Proposed judgements determine ARBITER domain consistency; adopted overrides are separate. Overall exact worst-domain agreement and permitted escalation are separate. Evidence coverage uses active signalling answers as the denominator and answers citing at least one evidence record as the numerator. Unassisted and Published evidence traces are unavailable. Binding and independent verification are structural checks, not clinical correctness. Visual transcriptions are model-written and not checked against images.'))
  add('Invalid answer path sensitivity',manuscript_data('invalid-path-sensitivity') |>
    mutate(Group=paste(reader_label(arm,TRUE),'— replacement:',resolution)) |>
    select(Group,Domain=domain,`Evaluable (n)`=n,`Original violations (n)`=original_violations,`Invalid paths (n)`=invalid_paths,
      `Additional violations (n)`=additional_violations,`Total violations (n)`=violations),
    'Required invalid answers recursively resolve as N/PN then NI, including newly required questions. No off-path imputation; these are counts, not new assessments.')
  costs <- manuscript_data('api-cost-summary')
  labels <- c(point_total='Primary estimate: total (USD)',point_median='Primary estimate: median per trial (USD)',
    lower_total='Lower reconstruction bound: total (USD)',lower_median='Lower bound: median per trial (USD)',
    upper_total='Upper reconstruction bound: total (USD)',upper_median='Upper bound: median per trial (USD)',
    harness_total='Harness diagnostic: total (USD)',harness_median='Harness diagnostic: median per trial (USD)',
    side_5m_point_total='5-minute write sensitivity: total (USD)',side_5m_point_median='5-minute write sensitivity: median per trial (USD)',
    side_5m_lower_total='5-minute sensitivity lower bound: total (USD)',side_5m_lower_median='5-minute sensitivity lower bound: median per trial (USD)',
    side_5m_upper_total='5-minute sensitivity upper bound: total (USD)',side_5m_upper_median='5-minute sensitivity upper bound: median per trial (USD)')
  add('API cost reconstruction: estimates and bounds',wide_diagnostics(costs,labels,2),
    'USD. Reconstruction bounds are not sampling CIs. Five-minute side-call cache writes are a sensitivity. Harness figures are unusable: unrecognised model and unknown cost basis.')
  tokens <- manuscript_data('api-token-reconciliation')
  labels <- c(requests='Main-thread requests (n)',high_requests='Requests with prompts >100,000 tokens (n)',
    compaction_events='Compaction events (n)',turns_with_side_calls='Turns with side calls (n)',
    turns_with_request_excess='Turns with request counts above terminal counts (n)',side_without_compaction='Side-call turns without compaction (n)')
  for(prefix in c('request','result','side','gap')) for(kind in c('input','write1','write5','read','output')) {
    k <- paste(prefix,kind,sep='_')
    labels[k] <- paste(c(request='Main-thread request',result='Terminal',side='Side-call',gap='Terminal minus request')[prefix],
      c(input='input',write1='1-hour cache write',write5='5-minute cache write',read='cache read',output='output')[kind],'tokens (n)')
  }
  add('Token reconciliation and compaction diagnostics',wide_diagnostics(tokens,labels),
    'Token totals across trials. Terminal minus request is signed, including retry residuals. Side calls are total model usage minus terminal usage; output already includes thinking.')
  matrices <- manuscript_data('confusion-matrices')
  blocks <- list()
  for(a in unique(matrices$arm)) for(d in c(paste0('D',1:5),'Overall')) {
    block <- filter(matrices,arm==a,domain==d)
    blocks[[length(blocks)+1L]] <- list(title=paste(reader_label(a,TRUE),d,sep=' — '),data=confusion_display(block))
  }
  add('Confusion matrices against Published',NULL,
    'Each grid contains counts of cells: Published rows × predicted columns, ordered Low / Some concerns / High. Missing predictions appear only when nonzero. Overall uses the 81 labelled trials.',blocks)
  forest <- manuscript_data('forest-meta') |> left_join(metadata |> select(meta_id,specialty,topic),by='meta_id')
  add('Per-meta-analysis weighted κ',supplement_estimates(forest,c('specialty','topic','arm')) |>
      pivot_wider(names_from=arm,values_from=`Estimate (95% CI)`) |> arrange(specialty!='General medicine',specialty,topic),
    paste(TOPIC_ABBREVIATIONS,'Weighted κ (95% CI). eFigure 1 displays the defined nondegenerate estimates. A coefficient with no variance, or a degenerate bootstrap interval, is shown as —.',CI_NOTE))
  add('Post hoc severity-stratified win share',supplement_estimates(manuscript_data('severity-win-share'),c('direction','metric')),
    paste('Post hoc Sonnet 5.5 analysis of consensus cells where the two arms disagreed, stratified by ARBITER severity relative to Unassisted. Fractions are label-based wins / cells in that severity stratum.',CI_NOTE))
  add('Adjudicators usually agreed with ARBITER when it disagreed with Published',manuscript_data('vindicated-disagreements') |>
    select(source,direction,outcome,Count=n,consensus_n,all_n),
    'Both sources use Sonnet 5.5. Figure 5B uses disagreements where both adjudicators agreed as the denominator; split cells are displayed separately. Adjudicators agreed with it means their agreed choice equals the source label; Published upheld means their agreed choice equals the published review label; Other label means neither. Count is the outcome count; Agreed n excludes divided decisions and All n includes them.')
  add('Per-adjudicator and split-cell win-share sensitivity',supplement_estimates(manuscript_data('primary-endpoint'),c('analysis','metric')),
    paste('Fractions are label-based wins / cells where the two arms disagreed. Consensus is primary and includes only cells with the same choice from both adjudicators; each single-adjudicator analysis includes split cells. Split cells are forced ARBITER losses in the split sensitivity; Neither includes these forced losses.',CI_NOTE))
  for(ref in c('meta','composite')) {
    x <- manuscript_data(paste0('agreement-',ref,'-differences'))
    if(ref=='composite') x <- filter(x,metric %in% c('kappa','AC2','accuracy'))
    add(paste('Paired differences against',if(ref=='meta') 'Published' else 'the composite reference'),agreement_display(x,c('comparison','domain'),TRUE),
      paste('ARBITER minus Unassisted; coefficients in original units, proportions in percentage points.',if(ref=='composite') COMPOSITE_NOTE else '',CI_NOTE))
  }
  sensitivity <- function(difference=FALSE) bind_rows(lapply(c('A','Z'),function(a) {
    x <- manuscript_data(paste0('composite-',a,if(difference) '-differences' else '')) |>
      filter(metric %in% c('kappa','AC2','accuracy'))
    agreement_display(x,if(difference) c('comparison','domain') else c('arm','domain'),difference) |>
      mutate(Adjudicator=reader_label(a),.before=1)
  }))
  add('Composite-reference sensitivity estimates by adjudicator',sensitivity(),
    paste('510 cells per Sonnet arm. Each adjudicator’s selected label replaces Published on disputed cells. Only three labels were offered; unadjudicated cells are assumed correct.',CI_NOTE))
  add('Composite-reference paired differences by adjudicator',sensitivity(TRUE),
    paste('ARBITER minus Unassisted, coefficient units or percentage points; 510 paired cells per arm. Only offered labels could be chosen; unadjudicated cells are assumed correct.',CI_NOTE))
  add('Haiku agreement after excluding missing judgements',NULL,
    paste('Both Haiku arms exclude the same missing domain and Overall cells. Fractions give eligible-cell denominators. Sensitivity uses Some concerns or High as positive; specificity uses Low. κ and AC2 are linearly weighted. Paired differences use coefficient units or percentage points.',CI_NOTE),
    list(list(title='Estimates',data=agreement_display(manuscript_data('missing-sensitivity'))),
      list(title='Paired ARBITER minus Unassisted differences',data=agreement_display(manuscript_data('missing-sensitivity-differences'),c('comparison','domain'),TRUE))))
  add('Localisation population eligibility',manuscript_data('error-localisation-eligibility'),
    'Primary requires both independent judgements equal to consensus preferred; sensitivity requires at least one. Published losses lack signalling answers. Haiku was not adjudicated.')
  add('Error-localisation classes, both populations',manuscript_data('error-localisation-counts') |>
    arrange(population,class_order) |> select(population,class,source,n) |> pivot_wider(names_from=source,values_from=n),
    'Counts of losing cells. First applicable class is assigned; classes sum to eligible losses. No-discordance can include adjudicator disagreements, flagged separately.')
  add('Decisive-question frequencies, both populations',manuscript_data('error-localisation-frequency') |>
    select(population,domain,question,short_text,source,n) |> pivot_wider(names_from=source,values_from=n),
    'Counts of individually decisive questions; all 22 questions are retained. A cell may contribute several. Jointly decisive sets contribute none. Short question texts follow the 2019 guidance; D2 uses effect of assignment.')
  add('Unresolved independent answer',manuscript_data('error-localisation-issues') |> mutate(slug=trial_display(slug)),
    'The qualified answer is preserved without selecting a time point. This cell is outside both localisation populations because neither independent judgement equals consensus preferred.')
  override <- manuscript_data('recorded-overrides') |> mutate(slug=trial_display(slug)) |>
    select(arm,slug,domain,proposed,adopted,rationale) |> pivot_longer(everything(),names_to='Field',values_to='Value')
  override$Field <- reader_field(override$Field)
  # Clinical wording retained in the machine export; reader text avoids an internal arm-name collision.
  override$Value <- gsub('baseline balance','preintervention balance',override$Value,fixed=TRUE)
  add('Recorded model override',override,
    'Hill 2017 D1: 1.1 = NI, 1.2 = PY, 1.3 = N. Proposed Low; adopted Some concerns. Answer codes and clinical balance terminology are expanded for readability; the original rationale remains in the accompanying CSV. The rationale is model text, not endorsed guidance. Evidence identities remain in the accompanying CSV.')
  add('Quotation syntax in active justifications',supplement_estimates(manuscript_data('grounding'),'arm'),
    paste('Quoted active answers / all active answers. Paired double quotes enclose at least five words. Syntax is not verification and understates ARBITER bundle-based grounding.',CI_NOTE))
  add('Unassisted justification content',manuscript_data('baseline-justification-content') |>
    transmute(arm,`Answer-code-only / exported fields (%)`=fmt_fraction(answer_code_only,n)),
    'Codes are Y, PY, PN, N, NI or NA. This describes exported fields without inferring absent reasoning.')
  signals <- supplement_estimates(manuscript_data('signalling-agreement'),c('arm','adjudicator','question')) |>
    mutate(question=as.character(question)) |> left_join(question_map(TRUE) |> select(question,short_text),by='question')
  blocks <- lapply(c('A','Z'),function(a) list(title=reader_label(a),data=signals |> filter(adjudicator==a) |>
    select(Question=question,`Signalling question`=short_text,arm,`Estimate (95% CI)`) |>
    pivot_wider(names_from=arm,values_from=`Estimate (95% CI)`)))
  add('Exploratory signalling-answer agreement',NULL,
    paste('Correct collapsed answers / eligible questions (95% CI) on disputed domains. Independent answers define reference; Y/PY, N/PN, NI/NA collapse. Missing predictions are wrong. Includes Haiku without a preferred-judgement endpoint.',CI_NOTE),blocks)

  add('AVATAR complete trace',NULL,
    'Illustrative all-cause-death assessment (Banovic 2024). Part A gives all questions, answers, evidence types, justifications, unknowns, counterevidence and Unassisted rationales. — means none recorded in those fields; inactive questions follow branching. Part B preserves 16 archived records (15 cited by current answers). Quotes and rationales are verbatim; quote line breaks display as spaces. Source locations and hashes identify captured versions. References within quotations concern original documents. Full trace: analysis/data-derived/avatar-trace.json.',avatar_trace_blocks(inputs))
  add('Independent and selected ratings: full agreement including AC2',
    agreement_display(manuscript_data('table4-reliability'),'comparison'),
    paste('154 disputed cells per comparison, selected because at least one Sonnet arm differed from the published review label. Independent ratings preceded label presentation; selected ratings chose among three offered labels. κ and AC2 are linearly weighted; raw agreement is n/N (x.x%; 95% CI a–b). This selected population cannot estimate full-benchmark agreement.',CI_NOTE))
  for(i in seq_along(entries)) {
    entries[[i]]$caption <- reader_label(entries[[i]]$caption)
    entries[[i]]$note <- reader_label(entries[[i]]$note)
  }
  # Citation order in the main figures, main tables, then time/cost results.
  first <- c('AVATAR complete trace','Adjudicators usually agreed with ARBITER when it disagreed with Published',
    'Post hoc severity-stratified win share','Per-adjudicator and split-cell win-share sensitivity',
    'Decisive-question frequencies, both populations','Localisation population eligibility',
    'Error-localisation classes, both populations','Published label distributions by domain',
    'Agreement against Published, all sources and domains','Agreement against the composite reference, Sonnet only',
    'Paired differences against Published','Paired differences against the composite reference',
    'RoB 2 consistency and structural audit, all sources and domains','Invalid answer path sensitivity',
    'Recorded model override','Independent and selected ratings: full agreement including AC2',
    'Time, cost and token use per trial by model')
  captions <- vapply(entries,`[[`,character(1),'caption')
  cited <- match(reader_label(first),captions)
  stopifnot(!anyNA(cited))
  entries[c(cited,setdiff(seq_along(entries),cited))]

}
supplement_table <- function(entry,data=entry$data) {
  x <- if(entry$caption=='AVATAR complete trace') as.data.frame(data) else display_frame(data,TRUE)
  if(entry$caption=='AVATAR complete trace' && 'Full verbatim quote' %in% names(x))
    x[['Full verbatim quote']] <- gsub('\n',' ',x[['Full verbatim quote']],fixed=TRUE)
  names(x) <- reader_field(names(x))
  names(x) <- gsub('¹','',names(x),fixed=TRUE)
  if(entry$caption=='Exploratory signalling-answer agreement') {
    names(x)[names(x)=='Question'] <- 'SQ'
    entry$note <- paste('SQ, signalling question.',entry$note)
  }
  if('Measure' %in% names(x)) x$Measure <- gsub('_',' ',x$Measure,fixed=TRUE)
  grouped <- FALSE
  group_col <- if('Group' %in% names(x)) 'Group' else if('Weighted κ' %in% names(x) && 'Domain' %in% names(x)) names(x)[1] else NULL
  if(startsWith(entry$caption,'Composite-reference')) group_col <- NULL
  if(!is.null(group_col)) {
    keys <- unique(x[[group_col]])
    x <- bind_rows(lapply(keys,function(k) group_row(x[x[[group_col]]==k,setdiff(names(x),group_col),drop=FALSE],k)))
    grouped <- TRUE
  }
  ft <- house_table(x,entry$note)
  widths <- rep(6.85/ncol(x),ncol(x))
  if(entry$caption=='Published label distributions by domain') widths <- c(1.15,2,.5,rep(.64,5))
  else if(startsWith(entry$caption,'Composite-reference')) widths <- c(.9,1.8,.55,1.05,1.05,1.5)
  else if(entry$caption=='Time, cost and token use per trial by model') widths <- c(.9,2,1.25,1.25,1.45)
  else if(grepl('^Confusion',entry$caption)) widths <- c(2.05,rep(4.8/(ncol(x)-1),ncol(x)-1))
  else if(entry$caption=='Per-meta-analysis weighted κ') widths <- c(1.1,2.15,rep(.9,4))
  else if(entry$caption=='Exploratory signalling-answer agreement') widths <- c(.5,2.15,rep(1.05,4))
  else if(entry$caption=='Recorded model override') widths <- c(1.25,5.6)
  else if(entry$caption=='Token reconciliation and compaction diagnostics' || startsWith(entry$caption,'API cost')) widths <- c(2.65,rep(1.05,4))
  else if(grepl('^RoB 2 consistency',entry$caption)) widths <- c(.65,1.9,rep(.86,ncol(x)-2))
  else if(startsWith(entry$caption,'Questions that alone changed the rating: frequencies')) widths <- c(.8,.65,.65,2.45,1.15,1.15)
  else if(grepl('Error-localisation classes',entry$caption)) widths <- c(1,3.25,1.3,1.3)
  else if(entry$caption=='Unresolved independent answer') widths <- c(.8,.65,.85,.75,1.9,1.9)
  else if(entry$caption=='Invalid answer path sensitivity') widths <- c(.65,.8,1.35,1.2,1.45,1.4)
  else if(grouped && ncol(x)==6) widths <- c(.6,.85,.85,1.5,1.55,1.5)
  else if(grouped && ncol(x)==4) widths <- c(.65,1.55,1.55,3.1)
  else if(ncol(x)==2) widths <- c(2.5,4.35)
  else if(entry$caption=='AVATAR complete trace') widths <- if(ncol(x)==7) c(1.1,.8,1.45,2.7,.85,1.1,2.2) else c(1.45,1.4,.4,.55,1,5.4)
  else if(ncol(x)==3) widths <- c(1.8,2.4,2.65)
  ft <- flextable::width(ft,j=seq_len(ncol(x)),width=widths)
  if(entry$caption=='AVATAR complete trace') ft <- ft |>
    flextable::fontsize(size=8,part='all') |> flextable::padding(padding=2,part='all') |>
    flextable::set_table_properties(layout='fixed',opts_word=list(split=TRUE,repeat_headers=TRUE))
  if(grouped) ft <- style_group_rows(ft,x)
  ft
}
supplement_end_section <- function(doc,landscape=FALSE) {
  officer::body_end_block_section(doc,officer::block_section(officer::prop_section(
    page_size=officer::page_size(width=8.27,height=11.69,orient=if(landscape) 'landscape' else 'portrait'),
    page_margins=officer::page_mar(top=.6,bottom=.6,left=.65,right=.65))))
}
build_supplement <- function(inputs) {
  METHODS_APPENDIX <- reader_label(METHODS_APPENDIX)
  entries <- supplement_registry(inputs)
  doc <- manuscript_doc() |> manuscript_par('ARBITER: Supplementary material',style='heading 1')
  doc <- manuscript_par(doc,'Contents',style='heading 2')
  doc <- manuscript_par(doc,'Methods appendix · Supplementary results · Prompt templates and example · Run provenance')
  for(i in seq_along(entries)) doc <- manuscript_par(doc,paste0('eTable ',i,'. ',entries[[i]]$caption))
  doc <- manuscript_par(doc,'eFigure 1. Agreement with Published varied across meta-analyses')
  doc <- manuscript_par(doc,'eFigure 2. ARBITER-only choices outnumbered Unassisted-only choices')
  doc <- officer::body_add_break(doc)
  doc <- manuscript_par(doc,'Methods appendix',style='heading 1')
  for(i in seq_along(METHODS_APPENDIX)) {
    if(i==3L) doc <- officer::body_add_break(doc)
    doc <- doc |> manuscript_par(names(METHODS_APPENDIX)[i],style='heading 2') |> manuscript_par(METHODS_APPENDIX[i])
  }
  for(i in seq_along(entries)) {
    e <- entries[[i]]
    if(e$caption=='AVATAR complete trace') doc <- supplement_end_section(doc)
    else if(i==1L || entries[[i-1L]]$caption!='AVATAR complete trace') doc <- officer::body_add_break(doc)
    doc <- manuscript_par(doc,paste0('eTable ',i,'. ',e$caption),style='heading 2')
    if(is.null(e$blocks)) doc <- flextable::body_add_flextable(doc,supplement_table(e))
    else for(k in seq_along(e$blocks)) {
      per_page <- if(startsWith(e$caption,'Confusion')) 6L else if(e$caption=='AVATAR complete trace') 1000L else 1L
      if(k>1 && (k-1)%%per_page==0) {
        doc <- officer::body_add_break(doc)
        doc <- manuscript_par(doc,paste0('eTable ',i,' (continued). ',e$caption),style='heading 2')
      }
      block <- e$blocks[[k]]
      doc <- manuscript_par(doc,block$title,style='heading 2')
      # The note is attached once per source's six grids.
      be <- e; be$note <- if(k%%per_page==0 || k==length(e$blocks)) e$note else NULL
      doc <- flextable::body_add_flextable(doc,supplement_table(be,block$data))
    }
    if(e$caption=='AVATAR complete trace') doc <- supplement_end_section(doc,TRUE)
    if(e$caption=='Per-meta-analysis weighted κ') {
      doc <- officer::body_add_break(doc) |> manuscript_par('eFigure 1. Agreement with Published varied across meta-analyses',style='heading 2') |>
        officer::body_add_img(src='output/manuscript/eFigure1.png',width=6.7,height=6.7*200/174) |>
        manuscript_par(paste('Weighted kappa and 95% CIs; source symbols distinguish model and assistance.',
          'Undefined coefficients are omitted. Specialty and topic identify each meta-analysis. Descriptive estimates only; no statistical tests.',CI_NOTE))
    }
  }
  doc <- doc |> manuscript_par('eFigure 2. ARBITER-only choices outnumbered Unassisted-only choices',style='heading 2') |>
    officer::body_add_img(src='output/manuscript/eFigure2.png',width=6.7,height=6.7*95/174) |>
    manuscript_par('ARBITER-only choices were more frequent than Unassisted-only choices. Rows group disputed cells by disagreement with the published review label; columns show the adjudicators’ agreed choice or split. Counts use label equality; shared labels count as both arms preferred. A cell is one trial × domain.')
  prompts <- manuscript_data('prompt-template-example')
  doc <- officer::body_add_break(doc)
  doc <- manuscript_par(doc,'Prompt templates and a filled example',style='heading 1')
  for(slug in inputs$trials$slug) prompts$prompt <- gsub(slug,trial_display(slug),prompts$prompt,fixed=TRUE)
  for(i in seq_len(nrow(prompts))) doc <- doc |>
    manuscript_par(reader_label(prompts$type[i],TRUE),style='heading 2') |>
    manuscript_par(prompts$prompt[i])
  doc <- doc |> manuscript_par('Run provenance',style='heading 1') |>
    manuscript_par(paste('Models claude-sonnet-5-5 and claude-haiku-5-5; effort medium; Claude Code 2.1.278;',
      'isolated configuration homes. ARBITER 1.0.0, public commit 2f549ae30f056ff441ea61a04b719968716f2219.',
      'ARBITER with Sonnet ran 12 October 2026 (12:12-19:17 EDT); other arms ran 14 October 2026.',
      'Harness approved the proposed result unchanged and replied Approved.; uncoached Continue. replies were permitted at most twice per phase.',
      'Each trial ran once in each arm; run-to-run variability is not estimated.',
      'Unassisted access was limited to Read, Glob and Grep, without an MCP server, skills or web tools.',
      'Supplied registry Markdown and acquired protocol/SAP documents preserved input parity.',
      'Trial PDFs are not redistributed; source DOIs and FILES.csv hashes identify them.',
      'Bootstrap seed 20261018, 10,000 replicates; R/renv/Quarto versions are recorded in the project lockfile and session-info.txt.'))
  print(doc,target='output/manuscript/Supplement.docx')
  checklist <- reporting_checklist() |> select(-source) |>
    rename(Guideline=guideline,Item=item,Topic=topic,Page=page,Section=section,Notes=applicability_and_notes)
  doc <- manuscript_doc() |> manuscript_par('TRIPOD-LLM and GRRAS checklist skeleton',style='heading 1') |>
    manuscript_par('Abbreviated topic labels map to official item identifiers. Authors must assess applicability and complete Page, Section and Notes against the full checklists. This skeleton is not a claim of reporting compliance.') |>
    flextable::body_add_flextable(house_table(checklist,paste('TRIPOD-LLM:',
      'https://www.tripod-statement.org/wp-content/uploads/2025/01/TRIPOD-LLM-Checklist.pdf;',
      'GRRAS: https://www.equator-network.org/wp-content/uploads/2012/12/GRRAS-checklist-for-reporting-of-studies-of-reliability-and-agreement.pdf')))
  print(doc,target='output/manuscript/TRIPOD-LLM.docx')
  invisible(entries)
}

# Resolve numbers once per R build; each lookup otherwise reloads all raw inputs.
supplement_number <- local({
  numbers <- NULL
  function(caption) {
    if(is.null(numbers)) {
      entries <- supplement_registry(load_inputs())
      numbers <<- setNames(seq_along(entries),vapply(entries,`[[`,character(1),'caption'))
    }
    number <- unname(numbers[reader_label(caption)])
    stopifnot(!is.na(number))
    number
  }
})
