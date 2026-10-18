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
    'request-share and higher-tier rates. Side calls are modelUsage minus terminal usage. Compaction uses high-tier pricing and',
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
    'RoB 2 guidance: https://www.riskofbias.info/welcome/rob-2-0-tool/current-version-of-rob-2.',
    'ARBITER source: https://github.com/AliSalman-et-al/ARBITER/tree/2f549ae30f056ff441ea61a04b719968716f2219.',
    'Pricing source: https://platform.claude.com/docs/en/about-claude/pricing.'))

supplement_estimates <- function(x,ids=NULL) {
  if(is.null(ids)) ids <- setdiff(names(x),c('estimate','lower','upper','valid_replicates','count','n','missing','note'))
  if('estimate' %in% names(x)) {
    if('quoted' %in% names(x)) x$count <- x$quoted
    if('correct' %in% names(x)) x$count <- x$correct
    x[['Estimate (95% CI)']] <- fmt_estimate(x,'count' %in% names(x))
    x <- x |> select(any_of(c(ids,'n','missing','Estimate (95% CI)')))
  }
  x
}
supplement_registry <- function(inputs) {
  entries <- list()
  add <- function(caption,data,note=CI_NOTE) {
    entries[[length(entries)+1L]] <<- list(caption=caption,data=data,note=note)
  }
  metadata <- readr::read_csv('data-curated/meta-analyses.csv',show_col_types=FALSE)
  add('Published label distributions by domain',manuscript_data('table1') |>
    select(meta_id,Trials=trials,D1:D5) |> left_join(metadata |> select(meta_id,specialty),by='meta_id') |>
    arrange(specialty) |> select(Specialty=specialty,Trials,D1:D5),
    'Domain cells show Low / Some concerns / High counts; 102 analysis-set trials. See main Table 1 for source journals and topics.')
  add('Process metrics: Sonnet 5.5',manuscript_data('table5'),paste('Median [IQR]; paired mean ARBITER minus Unassisted difference (95% CI).',
    'USD denotes API list-price equivalents, not expenditure. Thinking is part of output.',CI_NOTE))
  add('Process metrics: Haiku 5.5',manuscript_data('table5-haiku'),paste('Exploratory; units and summaries as eTable 2.',CI_NOTE))
  process <- manuscript_data('process-summary')
  for(j in c('median','q1','q3','total')) process[[j]] <- vapply(seq_len(nrow(process)),function(i) {
    v <- process[[j]][i]; metric <- process$metric[i]
    if(metric=='wall_seconds') fmt_number(v/60,1) else if(grepl('cost',metric)) fmt_number(v,2)
    else if(metric=='input_tokens') fmt_number(v,0) else fmt_number(v,1)
  },character(1))
  process$metric[process$metric=='wall_seconds'] <- 'Time (minutes)'
  add('Process totals and per-trial distributions, all arms',process,
    'Time is minutes and cost is USD; other counts use native units. Median, first and third quartile, and total. Thinking is included in output. Harness cost is an unusable diagnostic with unknown cost basis.')
  for(ref in c('meta','composite')) {
    x <- manuscript_data(paste0('agreement-',ref))
    if(ref=='composite') x <- filter(x,metric %in% c('kappa','AC2','accuracy'))
    add(if(ref=='meta') 'Agreement against Published, all arms and domains' else 'Agreement against the composite reference, Sonnet only',
      agreement_display(x),paste(AGREEMENT_NOTE,if(ref=='composite') COMPOSITE_NOTE else '',CI_NOTE))
    add(paste('Paired differences against',if(ref=='meta') 'Published' else 'the composite reference'),
      agreement_display(manuscript_data(paste0('agreement-',ref,'-differences')),c('comparison','domain'),TRUE),
      paste('ARBITER minus Unassisted; original coefficient/proportion units.',if(ref=='composite') COMPOSITE_NOTE else '',CI_NOTE))
  }
  add('Per-adjudicator and split-cell win-share sensitivity',supplement_estimates(manuscript_data('primary-endpoint'),c('analysis','metric')),
    paste('Split discordant cells are forced ARBITER losses, without fabricating an Unassisted win; Neither includes these forced losses.',CI_NOTE))
  for(a in c('A','Z')) {
    add(paste('Composite sensitivity using',reader_label(a)),agreement_display(manuscript_data(paste0('composite-',a))),
      paste('510 cells per Sonnet arm; the adjudicator preferred judgement replaces Published on every disputed cell.',
        'Only three labels were offered. Unadjudicated concordant cells are assumed correct; absolute values are inflated.',CI_NOTE))
    add(paste('Composite paired differences using',reader_label(a)),
      agreement_display(manuscript_data(paste0('composite-',a,'-differences')),c('comparison','domain'),TRUE),
      paste('Original coefficient/proportion units; 510 cells per arm; no consensus split exclusion.',CI_NOTE))
  }
  add('Missing-judgement sensitivity: paired observed Haiku cells',agreement_display(manuscript_data('missing-sensitivity')),
    paste('The same five absent domain cells and any absent Overall cell are removed from both Haiku arms.',CI_NOTE))
  add('Missing-judgement sensitivity: paired Haiku differences',
    agreement_display(manuscript_data('missing-sensitivity-differences'),c('comparison','domain'),TRUE),CI_NOTE)
  add('Confusion matrices against Published',manuscript_data('confusion-matrices') |>
    rename(Published=meta) |> pivot_wider(names_from=predicted,values_from=n),
    'Rows are Published; columns are predicted labels. Zero cells are retained. Missing predictions are a separate column.')
  add('Per-meta-analysis weighted kappa',supplement_estimates(manuscript_data('forest-meta'),c('meta_id','arm')),
    paste('eFigure 1 displays these estimates; undefined coefficients are omitted from the plot.',CI_NOTE))
  consistency <- manuscript_data('table3-supplement')
  consistency$value <- fmt_estimate(consistency,TRUE)
  add('RoB 2 rule consistency and structural audit, all arms and domains',consistency |>
    select(domain,status,arm,value) |> pivot_wider(names_from=arm,values_from=value),main_table_notes()[[3]])
  add('Invalid answer path sensitivity',manuscript_data('invalid-path-sensitivity'),
    'Required invalid answers recursively resolve as N/PN then NI, including newly required questions. No off-path imputation; counts are not new assessments.')
  add('Recorded model override',manuscript_data('recorded-overrides') |>
    select(arm,slug,domain,proposed,adopted,rationale),
    'hill-2017 D1: 1.1 = NI, 1.2 = PY, 1.3 = N. Rationale is verbatim model text, not endorsed guidance. Proposed Low; adopted Some concerns. Evidence identities remain in the accompanying CSV. The proposed-algorithm validation gate passes.')
  add('API cost reconstruction: point estimates and bounds',manuscript_data('api-cost-summary') |>
    mutate(across(where(is.numeric),~fmt_number(.x,2))),
    'USD. Lower/upper are reconstruction bounds, not sampling CIs; side_5m is the five-minute side-call write sensitivity. Harness figures are unusable (unrecognised model; unknown basis).')
  add('Token reconciliation and compaction diagnostics',manuscript_data('api-token-reconciliation'),
    'Native token counts. Result denotes terminal usage; gap is signed result minus request; side is modelUsage minus terminal usage. Side calls without a compaction boundary are flagged.')
  add('Quotation syntax in active justifications',supplement_estimates(manuscript_data('grounding'),'arm'),
    paste('Paired straight or curly double quotes must enclose at least five whitespace-separated words. Syntax is not verification; this understates ARBITER bundle-based grounding.',CI_NOTE))
  add('Unassisted justification content',manuscript_data('baseline-justification-content'),
    'Answer-code-only fields contain Y, PY, PN, N, NI or NA. This describes the exported fields without inferring absent reasoning.')
  add('Exploratory signalling-answer agreement',supplement_estimates(manuscript_data('signalling-agreement'),c('arm','adjudicator','question')),
    paste('Independent answers define eligible questions on disputed domains. Collapse is Y/PY, N/PN, NI/NA; missing model answers are wrong. Includes Haiku; no Haiku preferred-judgement endpoint is calculated.',CI_NOTE))
  add('Localisation population eligibility',manuscript_data('error-localisation-eligibility'),
    'Primary requires both independent judgements equal to consensus preferred; sensitivity at least one. Published losses cannot be localised. Haiku was not adjudicated.')
  add('Error-localisation class counts, both populations',manuscript_data('error-localisation-counts') |>
    arrange(population,class_order) |> select(population,class,source,n) |> pivot_wider(names_from=source,values_from=n),
    'First applicable class is assigned; classes sum to eligible losses. No-discordance can include adjudicator disagreements, which are separately flagged.')
  add('Decisive-question frequencies, both populations',manuscript_data('error-localisation-frequency') |>
    select(population,source,domain,question,short_text,n),
    'All 22 questions are retained, including zeros. A cell can contribute multiple individual questions; jointly decisive sets contribute none. Short texts abbreviate the official 2019 questions, D2 effect of assignment.')
  add('Unresolved independent answer',manuscript_data('error-localisation-issues'),
    'Both qualified answers are preserved. No time point was selected. This cell is outside both localisation populations because neither independent judgement equals consensus preferred.')
  entries
}
supplement_table <- function(entry) {
  x <- display_frame(entry$data,TRUE)
  # Long diagnostic tables are transposed into rows to retain 9 pt text.
  if(ncol(x)>8L) x <- tidyr::pivot_longer(x,cols=-1,names_to='Measure',values_to='Value')
  names(x) <- gsub('_',' ',names(x),fixed=TRUE)
  names(x)[names(x)=='arm'] <- 'Source'
  names(x)[names(x)=='meta id'] <- 'Meta-analysis'
  names(x)[names(x)=='n'] <- 'N'
  ft <- house_table(x,entry$note)
  if('short text' %in% names(x)) ft <- flextable::width(ft,j=seq_len(ncol(x)),width=c(.8,1.35,.4,.55,3.35,.4))
  if(ncol(x)==3) ft <- flextable::width(ft,j=1:3,width=c(1.4,2.5,2.95))
  ft
}
build_supplement <- function(inputs) {
  entries <- supplement_registry(inputs)
  doc <- manuscript_doc() |> manuscript_par('ARBITER: Supplementary material',style='heading 1')
  doc <- manuscript_par(doc,'Methods appendix',style='heading 1')
  for(i in seq_along(METHODS_APPENDIX)) doc <- doc |>
    manuscript_par(names(METHODS_APPENDIX)[i],style='heading 2') |>
    manuscript_par(METHODS_APPENDIX[i])
  doc <- manuscript_par(doc,'Supplementary results',style='heading 1')
  for(i in seq_along(entries)) {
    e <- entries[[i]]
    doc <- doc |> manuscript_par(paste0('eTable ',i,'. ',e$caption),style='heading 2') |>
      flextable::body_add_flextable(supplement_table(e))
    if(e$caption=='Per-meta-analysis weighted kappa') {
      doc <- doc |> manuscript_par('eFigure 1. Agreement against Published by meta-analysis',style='heading 2') |>
        officer::body_add_img(src='output/manuscript/eFigure1.png',width=6.7,height=6.7*200/174) |>
        manuscript_par(paste('Weighted kappa and 95% CIs; source symbols distinguish model and assistance.',
          'Undefined coefficients are omitted. Meta-analysis IDs match the accompanying CSV. Descriptive estimates only; no statistical tests.',CI_NOTE))
    }
  }
  prompts <- manuscript_data('prompt-template-example')
  doc <- manuscript_par(doc,'Prompt templates and a filled example',style='heading 1')
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
