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
  'Error localisation' = paste('Losses are consensus cells where a source label differs from preferred. A reference adjudicator is usable only',
    'when their independent judgement equals consensus preferred. Primary requires both; sensitivity at least one.',
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
    'Missing predictions count as wrong. For ordinal coefficients a missing prediction receives maximal disagreement; the same rule applies to all estimates.',
    'Independent signalling-answer agreement uses the earlier exploratory Y/PY, N/PN and NI/NA collapse.',
    'Higgins JPT, Savović J, Page MJ, Sterne JAC, editors. Revised Cochrane risk-of-bias tool for randomized trials (RoB 2), 22 August 2019. https://www.riskofbias.info/welcome/rob-2-0-tool/current-version-of-rob-2.',
    'Salman A et al. ARBITER 1.0.0, public source release, commit 2f549ae. https://github.com/AliSalman-et-al/ARBITER/tree/2f549ae30f056ff441ea61a04b719968716f2219.',
    'Anthropic. Claude API pricing. Accessed 18 October 2026. https://platform.claude.com/docs/en/about-claude/pricing.'))

METHODS_APPENDIX <- c(METHODS_APPENDIX,
  'Published-label target matching' = paste('LABEL-TARGETS.csv links each published label to its review, source table, outcome, time point and contrast, with quoted binding evidence where stated and an explicit inference otherwise. The assessment prompt targets the labelled result rather than automatically the trial primary outcome, with the definition, printed result and locator from the trial report. Among the 102 included trials, 33 targets match an explicitly stated result, 11 match one of several covered outcomes, and 32 match an inferred result; 7 partly match, 9 differ and 10 have unknown binding. These categories are retained rather than treating all targets as exact matches. Twelve published label sets (60 domain labels) cover every outcome taken from a trial; another 10 label sets (50 domain labels) have no identified result, and seven more label sets (35 domain labels) jointly cover pain and disability; thus 29 sets (145 domain labels) do not isolate a single result (19 broad and 10 unknown). Binding was inferred rather than explicitly stated for 62 label sets, overlapping these categories. Source: benchmark README-FOR-ALI.md, LABEL-TARGETS.csv and per-review BINDING.md; label-target-summary.csv recomputes matching categories.'),
  'Dates and training exposure' = paste('Trial reports span publication years 1996–2025; the 16 source reviews were published in 2025–2026. Years come from TRIAL-SUMMARY.csv and trial-label years where that field is blank; the benchmark README identifies the SANCTUARY report as 2025. Anthropic documents June 2026 as the training-data cut-off for claude-sonnet-5-5 (model documentation, https://platform.claude.com/docs/en/models/sonnet-5-5/overview, and provider help, https://support.claude.com/en/articles/8114494-how-up-to-date-is-claude-s-training-data; checked 19 October 2026). Dates cannot establish whether a report was used in training.'),
  'Adjudication process and primary endpoint' = paste('Two blinded adjudicators used no AI. Each rated the domain from the supplied documents and froze the independent rating before seeing any label. They then saw only the three labels, randomised in order for each cell, and chose the preferred label with a reason. They did not see model rationales or quotations. The primary endpoint is the share of adjudicated arm-disagreement cells where the adjudicators preferred ARBITER’s rating. Independent-rating paired differences added post hoc compare ARBITER and Unassisted agreement with the same frozen independent rating on all 154 disputed cells, using the shared stratified trial-cluster bootstrap.'),
  'Limitations' = paste('Adjudication selected cells on disagreement, so preferred shares are subject to discrepant-analysis selection and do not estimate full-benchmark accuracy. Adjudicators chose only among the offered labels; cells where both arms matched Published were not audited. Labels alone may have revealed an arm, although this risk was low because rationales and quotations were hidden. Each arm ran once; workflow, prompt and runtime contributions cannot be separated. Reports or reviews may have appeared in training before the documented June 2026 cut-off. Whether quotations support the answers was not assessed. Overall was not adjudicated. Some label-target bindings were inferred, broad or mismatched; disagreement with a published label may partly reflect outcome mismatch rather than a different judgement.'))

SUPPLEMENT_ABBREVIATIONS <- paste('CI, confidence interval; IQR, interquartile range; USD, US dollars;',
  'AC2, Gwet’s linearly weighted agreement coefficient; κ, Cohen’s kappa (linear weights unless explicitly unweighted); RoB 2, risk of bias tool for randomised trials; D1–D5, its five domains;',
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
  x[['Estimate (95% CI)']] <- vapply(seq_len(nrow(x)),function(i) {
    prop <- 'count' %in% names(x) && (!'metric' %in% names(x) || !x$metric[i] %in% c('kappa','AC2'))
    fmt_estimate(x[i,,drop=FALSE],prop)
  },character(1))
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
    paste('Each D1–D5 cell gives Low / Some concerns / High counts; 102 trials. Source journals and years are in the preceding benchmark eTable.',TOPIC_ABBREVIATIONS))
  add('Time, cost and token use per trial by model',manuscript_data('table5') |>
    rename(ARBITER=`ARBITER-Sonnet`,Unassisted=`Baseline-Sonnet`) |> mutate(Model='Sonnet 5.5',.before=1),
    paste('102 trials per arm; per-trial median [IQR] and paired mean ARBITER minus Unassisted difference (95% CI). US$ denotes API list-price equivalent; runs used a subscription. Thinking is included in output; eMethods give the reconstruction formula and rates.',CI_NOTE))
  # Redundant process-summary export is deliberately not a reader table.
  for(ref in c('meta','composite')) {
    x <- manuscript_data(paste0('agreement-',ref))
    if(ref=='composite') x <- filter(x,metric %in% c('kappa','AC2','accuracy'))
    display <- agreement_display(x)
    if(ref=='composite') {
      components <- manuscript_data('composite-components') |>
        transmute(arm,domain=paste0('Post hoc split: ',component),`Weighted κ`='—',AC2='—',
          `Exact agreement`=fmt_fraction(count,n))
      display <- bind_rows(display,components)
    }
    add(if(ref=='meta') 'Agreement against Published, all sources and domains' else 'Agreement against the composite reference, Sonnet only',
      display,if(ref=='meta') paste(AGREEMENT_NOTE,CI_NOTE) else paste('Weighted κ, AC2 and exact agreement. The composite uses the agreed choice on 129 cells and Published on 356; 25 split cells are excluded. Adjudicators chose among three labels; unreviewed cells matching Published are assumed correct. Both inflate absolute values. Post hoc component rows give n/N (%) without new intervals.',CI_NOTE))
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
  add('Post hoc: preferred shares among adjudicated arm disagreements by strictness',supplement_estimates(manuscript_data('severity-win-share'),c('direction','metric')),
    paste('Post hoc analysis among adjudicated arm disagreements where both adjudicators agreed, stratified by ARBITER severity relative to Unassisted. Fractions are cells where the named rating was preferred / cells in that stratum.',CI_NOTE))
  add('Adjudicators usually agreed with models when they disagreed with Published',manuscript_data('vindicated-disagreements') |>
    select(source,direction,outcome,Count=n,consensus_n,all_n),
    'Both sources use the same model. Figure 4B uses disagreements where both adjudicators agreed as the denominator; split cells are displayed separately. Adjudicators agreed with it means their agreed choice equals the source label; Published upheld means their agreed choice equals the published review label; Other label means neither. Count is the outcome count; Agreed n excludes divided decisions and All n includes them.')
  add('Preferred shares among adjudicated arm disagreements: sensitivities',supplement_estimates(manuscript_data('primary-endpoint'),c('analysis','metric')),
    paste('Fractions are adjudicated arm disagreements where the named rating was preferred / all adjudicated arm disagreements in that analysis. Consensus is primary and includes only cells with the same choice from both adjudicators; each single-adjudicator analysis includes split cells. Split cells are forced ARBITER losses in the split sensitivity; Neither includes these forced losses.',CI_NOTE))
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
  add('Localisation population eligibility',manuscript_data('error-localisation-eligibility'),
    'Primary requires both independent judgements equal to consensus preferred; sensitivity requires at least one. Published losses lack signalling answers. ')
  add('Error-localisation classes, both populations',manuscript_data('error-localisation-counts') |>
    arrange(population,class_order) |> select(population,class,source,n) |> pivot_wider(names_from=source,values_from=n),
    'Counts of losing cells. First applicable class is assigned; classes sum to eligible losses. No-discordance can include adjudicator disagreements, flagged separately.')
  add('Decisive-question frequencies, both populations',manuscript_data('error-localisation-frequency') |>
    select(population,domain,question,short_text,source,n) |> pivot_wider(names_from=source,values_from=n),
    'Counts of individually decisive questions; all 22 questions are retained. A cell may contribute several. Jointly decisive sets contribute none. Short question texts follow the 2019 guidance; D2 uses effect of assignment.')
  add('Unresolved independent answer',manuscript_data('error-localisation-issues') |> mutate(slug=trial_display(slug)),
    'The qualified answer is preserved without selecting a time point. This cell is outside both localisation populations because neither independent judgement equals consensus preferred.')
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
    paste('Correct collapsed answers / eligible questions (95% CI) on disputed domains. Independent answers define reference; Y/PY, N/PN, NI/NA collapse. Missing predictions are wrong. ',CI_NOTE),blocks)

  add('AVATAR complete trace',NULL,
    'Illustrative all-cause-death assessment (Banovic 2024). Part A gives all questions, answers, evidence types, justifications, unknowns, counterevidence and Unassisted rationales. — means none recorded in those fields; inactive questions follow branching. Part B preserves 16 archived records (15 cited by current answers). Quotes and rationales are verbatim; quote line breaks display as spaces. Source locations and hashes identify captured versions. References within quotations concern original documents. Full trace: analysis/data-derived/avatar-trace.json.',avatar_trace_blocks(inputs))
  add('Independent and selected ratings: full agreement including AC2',
    agreement_display(manuscript_data('table4-reliability'),'comparison'),
    paste('154 disputed cells per comparison, selected because at least one Sonnet arm differed from the published review label. Independent ratings preceded label presentation; selected ratings chose among three offered labels. κ and AC2 are linearly weighted; raw agreement is n/N (x.x%; 95% CI a–b). This selected population cannot estimate full-benchmark agreement.',CI_NOTE))
  add('Benchmark trials span sixteen meta-analyses',benchmark_table(inputs),
    paste('102 trials; SC, Some concerns. Overall given indicates availability of published Overall labels.',TOPIC_ABBREVIATIONS))
  add('Post hoc: unweighted agreement with published labels is modest',
    supplement_estimates(manuscript_data('agreement-unweighted'),c('arm','domain','metric')) |> mutate(metric=if_else(metric=='kappa','Unweighted κ','Exact agreement')),
    paste('Post hoc. Unweighted Cohen’s κ and exact agreement against published review labels, by domain and Overall. κ here is unweighted; exact agreement uses labelled trials.',CI_NOTE))
  add('Published labels were usually less severe than the agreed choice',manuscript_data('published-direction-domain'),
    'Published review label relative to the adjudicators’ agreed choice, on the 129 ratings where both adjudicators agreed. Directions compare severity on Low < Some concerns < High. Selected disputed ratings cannot estimate full-benchmark accuracy.')
  add('Post hoc: rules-only changes make three arm disagreements ties',NULL,
    paste('Post hoc. Three of 62 adjudicated arm disagreements changed to ARBITER’s preferred rating; 59 were unchanged. Only violations are recomputed from Unassisted answers; invalid paths stay as reported. The original denominator is retained. Three new ties credit both arms, so preferred shares overlap. Weighted κ; exact agreement is n/N (%).',CI_NOTE),
    list(list(title='Changed ratings (post hoc)',data=manuscript_data('rules-only-recomputation-changed') |>
      mutate(slug=trial_display(slug)) |> select(slug,domain,original,recomputed)),
      list(title='Preferred shares on original adjudicated arm disagreements (post hoc)',data=supplement_estimates(manuscript_data('rules-only-recomputation-win_share'),c('version','metric'))),
      list(title='Agreement with published labels (post hoc)',data=supplement_estimates(manuscript_data('rules-only-recomputation-agreement'),c('version','domain','metric'))),
      list(title='Agreement with the adjudicators’ agreed choice (post hoc)',data=supplement_estimates(manuscript_data('rules-only-recomputation-agreed_choice'),'version'))))
  add('Post hoc: supplied documents and answers in question 5.1 losses',
    manuscript_data('question51-mechanism') |>
      transmute(Trial=if_else(slug=='banovic26-avatar-2024','Banovic 2024 (AVATAR)',inputs$trials$trial_label[match(slug,inputs$trials$slug)]),`Registry, protocol or SAP supplied`=if_else(registry_or_protocol_or_sap,'Yes','No'),
        `Unassisted mentions these documents`=if_else(mentions_document,'Yes','No'),
        `Unassisted answer`=answer,`Adjudicators’ answer`=reference_A),
    'Post hoc description of 18 primary Unassisted losses where question 5.1 alone changed the rating. Supplied means a bundle-inventoried registry, protocol or SAP; relevance/timing are not implied. De Waal’s supplied registry is for another trial. Mentions include negated mentions in the Unassisted 5.1 justification. Both adjudicators agreed on each answer. Full justifications and inventories: question51-mechanism.csv. Y, yes; PY, probably yes; NI, no information.')
  # Keep each source's full agreement grid together, with no orphan Overall row.
  j <- which(vapply(entries,function(e) e$caption=='Agreement against Published, all sources and domains',logical(1)))
  wide <- entries[[j]]$data
  entries[[j]]$blocks <- lapply(unique(wide$arm),function(a) list(title=reader_label(a,TRUE),
    data=wide |> filter(arm==a) |> select(-arm)))
  entries[[j]]$data <- NULL
  add('Evidence and quotation locations for the prior-work comparison',
    readr::read_csv('data-curated/prior-work-evidence-condensed.csv',show_col_types=FALSE),
    paste('One row per Table 4 study; reference callouts resolve in the bibliography. Quotations condense documented feature decisions and their locations. NR means not reported, not absent; definitions are in Table 4. Text-relevance review is not risk-of-bias adjudication. Quotation occurrence does not establish support. Recorded overrides were permitted; none occurred in 510 domains.'))
  for(i in seq_along(entries)) {
    entries[[i]]$caption <- reader_label(entries[[i]]$caption)
    entries[[i]]$note <- reader_label(entries[[i]]$note)
  }
  # The polish map is generated from first citations in manuscript.md.
  numbering <- readr::read_csv('output/manuscript/qa/round14-polish-numbering.csv',show_col_types=FALSE) |>
    filter(kind=='eTable') |> arrange(new_number)
  captions <- vapply(entries,`[[`,character(1),'caption')
  cited <- match(numbering$caption,captions)
  stopifnot(!anyNA(cited),length(cited)==length(entries),!anyDuplicated(cited))
  entries[cited]

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
  group_col <- if('Group' %in% names(x)) 'Group' else if('Weighted κ' %in% names(x) && 'Domain' %in% names(x) && names(x)[1] %in% c('Source','Comparison')) names(x)[1] else NULL
  if(startsWith(entry$caption,'Composite-reference')) group_col <- NULL
  if(!is.null(group_col)) {
    keys <- unique(x[[group_col]])
    x <- bind_rows(lapply(keys,function(k) group_row(x[x[[group_col]]==k,setdiff(names(x),group_col),drop=FALSE],k)))
    grouped <- TRUE
  }
  ft <- house_table(x,entry$note)
  widths <- rep(6.85/ncol(x),ncol(x))
  if(entry$caption=='Evidence and quotation locations for the prior-work comparison') widths <- c(1.05,4.45,1.35)
  else if(entry$caption=='Benchmark trials span sixteen meta-analyses') widths <- c(1.46,1.15,1.92,.4,1.50,.54)
  else if(entry$caption=='Published label distributions by domain') widths <- c(1.15,2,.5,rep(.64,5))
  else if(startsWith(entry$caption,'Composite-reference')) widths <- c(.9,1.8,.55,1.05,1.05,1.5)
  else if(entry$caption=='Agreement against the composite reference, Sonnet only') widths <- c(1.7,1.45,1.45,2.25)
  else if(entry$caption=='Agreement against Published, all sources and domains') widths <- c(.55,1.1,1.1,1.3,1.4,1.4)
  else if(entry$caption=='Time, cost and token use per trial by model') widths <- c(.9,2,1.25,1.25,1.45)
  else if(grepl('^Confusion',entry$caption)) widths <- c(2.05,rep(4.8/(ncol(x)-1),ncol(x)-1))
  else if(entry$caption=='Per-meta-analysis weighted κ') widths <- c(1.1,2.15,rep(1.8,2))
  else if(entry$caption=='Exploratory signalling-answer agreement') widths <- c(.5,2.15,rep(2.1,2))
  else if(entry$caption=='Recorded model override') widths <- c(1.25,5.6)
  else if(entry$caption=='Token reconciliation and compaction diagnostics' || startsWith(entry$caption,'API cost')) widths <- c(2.65,rep(2.1,2))
  else if(grepl('^RoB 2 consistency',entry$caption)) widths <- c(.65,1.9,rep(4.3/(ncol(x)-2),ncol(x)-2))
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
  if(entry$caption=='Benchmark trials span sixteen meta-analyses') ft <- ft |>
    flextable::padding(padding.left=1,padding.right=1,padding.top=2,padding.bottom=2,part='all') |>
    flextable::set_header_labels(values=setNames('Published D1–D5 labels\n(Low/SC/High)',names(x)[5])) |>
    flextable::hline(i=nrow(x)-1,border=officer::fp_border(width=.6),part='body') |>
    flextable::bold(i=nrow(x),j=1,part='body')
  if(entry$caption=='Agreement against the composite reference, Sonnet only')
    ft <- flextable::padding(ft,padding.top=0,padding.bottom=0,part='all')
  if(entry$caption=='Exploratory signalling-answer agreement' || grepl('^Post hoc: rules-only changes',entry$caption))
    ft <- flextable::padding(ft,padding.top=1,padding.bottom=1,part='all')
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
      per_page <- if(startsWith(e$caption,'Confusion')) 3L else if(e$caption=='AVATAR complete trace') 1000L else 1L
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
  prompts <- manuscript_data('prompt-template-example')
  doc <- officer::body_add_break(doc)
  doc <- manuscript_par(doc,'Prompt templates and a filled example',style='heading 1')
  for(slug in inputs$trials$slug) prompts$prompt <- gsub(slug,trial_display(slug),prompts$prompt,fixed=TRUE)
  for(i in seq_len(nrow(prompts))) doc <- doc |>
    manuscript_par(reader_label(prompts$type[i],TRUE),style='heading 2') |>
    manuscript_par(prompts$prompt[i])
  doc <- doc |> manuscript_par('Run provenance',style='heading 1') |>
    manuscript_par(paste('Model claude-sonnet-5-5; effort medium; Claude Code 2.1.278;',
      'isolated configuration homes. ARBITER 1.0.0, public commit 2f549ae30f056ff441ea61a04b719968716f2219.',
      'ARBITER with Sonnet ran 12 October 2026 (12:12-19:17 EDT); other arms ran 14 October 2026.',
      'Harness approved the proposed result unchanged and replied Approved.; uncoached Continue. replies were permitted at most twice per phase.',
      'Each trial ran once in each arm; run-to-run variability is not estimated.',
      'Unassisted access was limited to Read, Glob and Grep, without an MCP server, skills or web tools.',
      'Supplied registry Markdown and acquired protocol/SAP documents preserved input parity.',
      'Trial PDFs are not redistributed; source DOIs and FILES.csv hashes identify them.',
      'Bootstrap seed 20261018, 10,000 replicates; R/renv/Quarto versions are recorded in the project lockfile and session-info.txt.'))
  print(doc,target='output/manuscript/Supplement.docx')
  checklist <- reporting_checklist() |> select(-source,-page) |>
    rename(Guideline=guideline,Item=item,Topic=topic,Section=section,Notes=applicability_and_notes)
  doc <- manuscript_doc() |> manuscript_par('TRIPOD-LLM and GRRAS reporting map',style='heading 1') |>
    manuscript_par('Abbreviated topic labels map to official item identifiers. Locations identify the manuscript display or supplement section; author declarations and rater credentials marked for author completion remain open. Page numbers are left to final manuscript pagination.') |>
    flextable::body_add_flextable(house_table(checklist,paste('TRIPOD-LLM:',
      'https://www.tripod-statement.org/wp-content/uploads/2025/01/TRIPOD-LLM-Checklist.pdf;',
      'GRRAS: https://www.equator-network.org/wp-content/uploads/2012/12/GRRAS-checklist-for-reporting-of-studies-of-reliability-and-agreement.pdf')) |>
      flextable::width(j=1:5,width=c(.7,.4,1.05,2.75,1.95)))
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

METHODS_APPENDIX <- append(METHODS_APPENDIX,c('Input parity'=paste(
  'Both arms received each trial folder as delivered, including the main article, supplements and sources list.',
  'For the original 105-trial runs, the Unassisted inputs also included the exact Markdown projection of the registry records shown in the ARBITER run',
  '(74 trials), and the 60 protocol and statistical analysis plan PDFs acquired from ClinicalTrials.gov.',
  'These inputs were copied from the ARBITER run; nothing was fetched again. For De Waal 2021, the registry record supplied to both arms belongs to a different trial. This shared input error means that registry availability does not establish relevance to the assessed trial. Source: no-kit-sonnet-5.5/README.md.')),after=1)
