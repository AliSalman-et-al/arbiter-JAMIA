source('R/load.R')
source('R/report.R')
t3 <- table_data('table3-supplement')
statuses <- c('Consistent','Violation','Invalid answer path','Departure')
domains <- t3 |> filter(domain %in% c('D1-D5',paste0('D',1:5)),status %in% statuses) |>
  mutate(value=paste0(count,'/',n,' (',percent(estimate),')')) |>
  select(arm,domain,missing,status,value) |> pivot_wider(names_from=status,values_from=value)
overall <- t3 |> filter(domain=='Overall') |>
  mutate(value=paste0(count,'/',n,' (',percent(estimate),')')) |>
  select(arm,missing,status,value) |> pivot_wider(names_from=status,values_from=value)
sensitivity <- table_data('invalid-path-sensitivity') |>
  select(arm,domain,n,original_violations,invalid_paths,resolution,violations) |>
  pivot_wider(names_from=resolution,values_from=violations,names_prefix='Violations after ')
trace <- table_data('figure1-draft-selection')
commits <- system2('git',c('log','--reverse','--format=%h:%s','170f5d4..HEAD'),stdout=TRUE)
bundle <- readr::read_csv('data-derived/bundle-path-checks.csv',show_col_types=FALSE) |>
  group_by(arm) |> summarise(history_records=n(),final_domains=sum(final),
    invalid_paths=sum(invalid_path),unanswered_active=sum(active_questions-active_answered),.groups='drop')
lines <- c('# Round 3 implementation report','',
  'R1-R10 are implemented. All work is committed locally on main; nothing was pushed. Inputs, the binding plan and glossary were not edited. No Python or human taxonomy coding was used.',
  '', '## Commits','',paste0('- ',commits),
  '- Final documentation commit: Record round 3 results and verification (contains this report and its generator).',
  '', '## Preserved results and validation','',
  '- Primary endpoint: 54 ARBITER versus 7 Baseline wins, and 1 neither, among 62 differing consensus cells. ARBITER share 87.1% (79.0% to 94.3%); Baseline share 11.3% (4.5% to 19.2%).',
  '- Composite weighted kappa: 0.941 for ARBITER-Sonnet and 0.691 for Baseline-Sonnet. Baseline-Sonnet exact agreement with meta labels remains 395/510 (77.5%).',
  '- Compared all estimates and interval bounds in primary-endpoint, agreement-meta, agreement-composite, composite-A, composite-Z, missing-sensitivity, process-summary, process-differences and audit-summary with commit 170f5d4: unchanged before the author cost amendment. The amendment subsequently changes the cost estimates only. Consistency numbers change as required by the invalid-path amendment.',
  '- Rscript -e "testthat::test_dir(\'tests/testthat\')": 129 assertions passed, zero failures, warnings or skips.',
  '- quarto render succeeded after clearing generated table/figure files, HTML and Quarto cache files; the human coding sheet was preserved. Bootstrap: 10,000 stratified trial-cluster replicates, seed 20261018.',
  '- Rscript verify-output.R passed: five one-page PDFs, five 600-dpi PNGs, required tables, both HTML reports, no scientific notation in rendered table cells, and empty human coding fields.',
  '- Prohibited-name scan of analysis/output, results.html and supplement.html: no matches. All five final PNGs were visually inspected; no labels are clipped or overlapping. Every image has no internal title; captions are in the QMD files.',
  '- R startup emits existing LC_* locale warnings on this Windows installation; testthat itself reports zero warnings and rendering completes.',
  '', '## Table 3: algorithm consistency and audit','',
  'Domain consistency for ARBITER means proposal agreement with the official algorithm. Recorded overrides are separate from unrecorded violations. The missing column counts Not evaluable cells: one Baseline-Sonnet cadet D1 cell has no answers; five ARBITER-Haiku award-1-2014 cells have no labels or answers. Invalid paths stay in the denominator. Departure = Violation + Invalid answer path.',
  '', as.character(show_table(domains)),
  '', 'Pooled rates with 95% CIs (complete per-domain intervals remain in output/tables/table3-supplement.csv):','',
  as.character(show_table(t3 |> filter(domain=='D1-D5') |> select(arm,status,n,count,missing,estimate,lower,upper))),
  '', 'ARBITER-Sonnet: 510/510 proposed agreement and 0/510 recorded overrides. ARBITER-Haiku: 505/505 proposed agreement and 1/505 (0.2%) recorded overrides. The unchanged hill-2017 D1 Low-to-Some-concerns override gives adopted-label agreement of 504/505 (99.8%); its rationale and evidence remain in the supplement.',
  '', '### Overall consistency','',as.character(show_table(overall)),
  '', '### Grounding and bundle verification','',
  as.character(show_table(table_data('audit-summary') |> select(arm,metric,n,count,estimate,lower,upper,note))),
  '', 'Both ARBITER arms have zero invalid paths in every checked domain history record, including earlier revisions. All active questions have answers. The empty Haiku bundle verifies structurally without supplying a completed assessment; it does not repair missing labels.',
  '',as.character(show_table(bundle)),
  '', '### Invalid-path sensitivity','',
  'Replace required invalid NA/missing answers recursively, including newly required questions, as N/PN (implemented as N), then as NI. Complete-path violations are retained. N and PN have identical algorithm branches. Answers off the resolved path are not imputed.',
  '',as.character(show_table(sensitivity)),
  '', 'The pooled Baseline-Sonnet violation counts are 29 under N/PN and 62 under NI (original complete-path violations: 26; invalid paths: 39). Baseline-Haiku has 162 and 180 (original violations: 132; invalid paths: 48). Baseline-Sonnet D4 alone has 32 invalid paths, including the 28 cells with 4.1=N, 4.2=N and 4.3=NA identified in the review.',
  '', '## Table 5: process metrics','',
  'Values are median [IQR] and paired mean ARBITER-minus-Baseline differences (95% CI), over 102 trials per arm. Time is minutes/trial, costs USD/trial to two decimals, tokens thousands/trial. Cost is a reconstructed API list-price equivalent under the amended plan, not expenditure. Harness figures are unusable (unrecognized_model; cost basis unknown) and supplementary only. Thinking tokens are included in output tokens and are not added twice. Native-unit totals remain in output/tables/process-summary.csv.',
  '', '### Sonnet (main text)','',as.character(show_table(table_data('table5'))),
  '', '### Haiku (supplement; exploratory paired contrasts)','',as.character(show_table(table_data('table5-haiku'))),
  '', '## Reconstructed costs: totals and per-trial medians', '', as.character(show_table(cost_summary_display(table_data('api-cost-summary')))), '', 'Lower, point and upper bounds use the amended plan rate card; harness is unusable and is preserved only as a diagnostic. Side-call cache-write sensitivity uses five-minute rather than one-hour writes.', '', as.character(show_table(table_data('api-token-reconciliation'))), '', '## Figure 1: selected bundle trace','',
  paste0('- Cell: ',trace$slug,' ',trace$domain,'.'),
  paste0('- Cited passage: "',trace$passage,'" (',trace$passage_words,' whitespace-separated words).'),
  paste0('- Source: ',trace$source,'; captured PDF page ',trace$page,'.'),
  paste0('- Evidence identity: ',trace$evidence_id,'.'),
  paste0('- Question ',trace$question,' = ',trace$answer,'; active domain answer set: ',trace$signalling_answers,'.'),
  paste0('- Proposed judgement: ',trace$proposed,'; meta label: ',trace$meta,'; consensus preferred judgement: ',trace$preferred,'.'),
  '- Five bundle-evidence candidates are exported in output/tables/worked-trace-candidates.csv. The trace is provisional for author selection, as the plan requires. It is sourced from a cited evidence record, not justification text.',
  '', '## Grounding, reliability, and provenance fixes','',
  'Quotation syntax moved to the supplement with the explanation that ARBITER evidence records are stored separately from justifications. Evidence coverage and bundle verification now appear in Table 3. Code-only baseline justification fields were counted directly:',
  '',as.character(show_table(table_data('baseline-justification-content'))),
  '', 'Thus Baseline-Sonnet is not uniformly code-only: 1344/1459 (92.1%) active exported fields are answer codes only; Baseline-Haiku has 1320/1782 (74.1%). Remaining fields contain other text or are empty. This describes the supplied exports, not unobserved model reasoning.',
  '', 'Table 4 source comparisons explicitly carry: "Disputed cells only (selected for disagreement with the meta label); not an estimate of overall meta-label accuracy". Methods give the documented model IDs, medium effort, Claude Code 2.1.278, isolated homes, ARBITER 1.0.0 public commit 2f549ae and run dates (Sonnet ARBITER: 12 October 2026; other arms: 14 October 2026). Only the ARBITER 1.0.0 Zenodo DOI placeholder remains.',
  '', '## DEVIATIONS.md changes and remaining uncertainty','',
  '- Entry 2 removes the obsolete provenance-confirmation placeholder.',
  '- Entry 7 replaces the justification-based trace convention with short excerpts from linked bundle evidence, source/page locators and evidence identities.',
  '- Entry 8 records the amended invalid-path classification, retained denominators, recursive N/PN and NI sensitivities, and separate proposal/override reporting. The human codebook and code fields are unchanged.',
  '- Entry 11 records supplementary quote syntax, factual code-only counts, Table 5 units and paired estimands, exploratory Haiku contrasts, reliability selection wording, and the requested zero reference line for All-Low. Entry 12 implements author cost amendment 69c73c6 with signed residuals, synthetic-message exclusions, side-call flags and cache-write sensitivity.',
  '- The author cost amendment in commit 69c73c6 supersedes the original R3 harness-cost wording. Request/result input gaps are signed: negative retry residuals are retained and explicitly reconciled, using the same lower/request-share/upper pricing allocation. Side-call turns without a compaction event use those allocations too and are flagged. Synthetic zero-usage messages are excluded from request counts. All lower/point/upper order checks pass. No unresolved implementation blocker remains. The plan treats All-Low kappa differently in tables and Figure 4: tables suppress it as directed; Figure 4 shows the requested zero reference and explains the reporting convention in its caption.',
  '- Author decisions remain: final choice among five worked traces, human taxonomy coding, checklist completion, and ARBITER 1.0.0 Zenodo DOI. Bundle verification is structural and does not prove judgement correctness or assessment completion.',
  '- Composite caveats remain explicit: adjudicators chose only among offered labels, and unadjudicated cells where both Sonnet arms matched meta are assumed correct. Run-to-run variability is not estimated.'
)
writeLines(enc2utf8(lines),'round3-report.md',useBytes=TRUE)
