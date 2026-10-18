# Round 3 implementation report

R1-R10 are implemented. All work is committed locally on main; nothing was pushed. Inputs, the binding plan and glossary were not edited. No Python or human taxonomy coding was used.

## Commits

- 69c73c6:Plan: reconstruct API list-price cost from log token counts
- d231835:Classify invalid answer paths and verify ARBITER bundle histories
- 4137855:Rebuild algorithm audit and process tables with review denominators
- c8ed21f:Rebuild workflow and adjudication figures from bundle evidence
- 3a59239:Revise grounding reliability formatting and run provenance reports
- 331f475:Reconstruct API list-price equivalents and reconcile request and compaction tokens
- Final documentation commit: Record round 3 results and verification (contains this report and its generator).

## Preserved results and validation

- Primary endpoint: 54 ARBITER versus 7 Baseline wins, and 1 neither, among 62 differing consensus cells. ARBITER share 87.1% (79.0% to 94.3%); Baseline share 11.3% (4.5% to 19.2%).
- Composite weighted kappa: 0.941 for ARBITER-Sonnet and 0.691 for Baseline-Sonnet. Baseline-Sonnet exact agreement with meta labels remains 395/510 (77.5%).
- Compared all estimates and interval bounds in primary-endpoint, agreement-meta, agreement-composite, composite-A, composite-Z, missing-sensitivity, process-summary, process-differences and audit-summary with commit 170f5d4: unchanged before the author cost amendment. The amendment subsequently changes the cost estimates only. Consistency numbers change as required by the invalid-path amendment.
- Rscript -e "testthat::test_dir('tests/testthat')": 129 assertions passed, zero failures, warnings or skips.
- quarto render succeeded after clearing generated table/figure files, HTML and Quarto cache files; the human coding sheet was preserved. Bootstrap: 10,000 stratified trial-cluster replicates, seed 20261018.
- Rscript verify-output.R passed: five one-page PDFs, five 600-dpi PNGs, required tables, both HTML reports, no scientific notation in rendered table cells, and empty human coding fields.
- Prohibited-name scan of analysis/output, results.html and supplement.html: no matches. All five final PNGs were visually inspected; no labels are clipped or overlapping. Every image has no internal title; captions are in the QMD files.
- R startup emits existing LC_* locale warnings on this Windows installation; testthat itself reports zero warnings and rendering completes.

## Table 3: algorithm consistency and audit

Domain consistency for ARBITER means proposal agreement with the official algorithm. Recorded overrides are separate from unrecorded violations. The missing column counts Not evaluable cells: one Baseline-Sonnet cadet D1 cell has no answers; five ARBITER-Haiku award-1-2014 cells have no labels or answers. Invalid paths stay in the denominator. Departure = Violation + Invalid answer path.

|arm             |domain |missing |Consistent       |Violation       |Invalid answer path |Departure       |
|:---------------|:------|:-------|:----------------|:---------------|:-------------------|:---------------|
|ARBITER-Sonnet  |D1-D5  |0       |510/510 (100.0%) |0/510 (0.0%)    |0/510 (0.0%)        |0/510 (0.0%)    |
|ARBITER-Sonnet  |D1     |0       |102/102 (100.0%) |0/102 (0.0%)    |0/102 (0.0%)        |0/102 (0.0%)    |
|ARBITER-Sonnet  |D2     |0       |102/102 (100.0%) |0/102 (0.0%)    |0/102 (0.0%)        |0/102 (0.0%)    |
|ARBITER-Sonnet  |D3     |0       |102/102 (100.0%) |0/102 (0.0%)    |0/102 (0.0%)        |0/102 (0.0%)    |
|ARBITER-Sonnet  |D4     |0       |102/102 (100.0%) |0/102 (0.0%)    |0/102 (0.0%)        |0/102 (0.0%)    |
|ARBITER-Sonnet  |D5     |0       |102/102 (100.0%) |0/102 (0.0%)    |0/102 (0.0%)        |0/102 (0.0%)    |
|Baseline-Sonnet |D1-D5  |1       |444/509 (87.2%)  |26/509 (5.1%)   |39/509 (7.7%)       |65/509 (12.8%)  |
|Baseline-Sonnet |D1     |1       |96/101 (95.0%)   |5/101 (5.0%)    |0/101 (0.0%)        |5/101 (5.0%)    |
|Baseline-Sonnet |D2     |0       |95/102 (93.1%)   |3/102 (2.9%)    |4/102 (3.9%)        |7/102 (6.9%)    |
|Baseline-Sonnet |D3     |0       |97/102 (95.1%)   |3/102 (2.9%)    |2/102 (2.0%)        |5/102 (4.9%)    |
|Baseline-Sonnet |D4     |0       |67/102 (65.7%)   |3/102 (2.9%)    |32/102 (31.4%)      |35/102 (34.3%)  |
|Baseline-Sonnet |D5     |0       |89/102 (87.3%)   |12/102 (11.8%)  |1/102 (1.0%)        |13/102 (12.7%)  |
|ARBITER-Haiku   |D1-D5  |5       |505/505 (100.0%) |0/505 (0.0%)    |0/505 (0.0%)        |0/505 (0.0%)    |
|ARBITER-Haiku   |D1     |1       |101/101 (100.0%) |0/101 (0.0%)    |0/101 (0.0%)        |0/101 (0.0%)    |
|ARBITER-Haiku   |D2     |1       |101/101 (100.0%) |0/101 (0.0%)    |0/101 (0.0%)        |0/101 (0.0%)    |
|ARBITER-Haiku   |D3     |1       |101/101 (100.0%) |0/101 (0.0%)    |0/101 (0.0%)        |0/101 (0.0%)    |
|ARBITER-Haiku   |D4     |1       |101/101 (100.0%) |0/101 (0.0%)    |0/101 (0.0%)        |0/101 (0.0%)    |
|ARBITER-Haiku   |D5     |1       |101/101 (100.0%) |0/101 (0.0%)    |0/101 (0.0%)        |0/101 (0.0%)    |
|Baseline-Haiku  |D1-D5  |0       |330/510 (64.7%)  |132/510 (25.9%) |48/510 (9.4%)       |180/510 (35.3%) |
|Baseline-Haiku  |D1     |0       |92/102 (90.2%)   |10/102 (9.8%)   |0/102 (0.0%)        |10/102 (9.8%)   |
|Baseline-Haiku  |D2     |0       |47/102 (46.1%)   |16/102 (15.7%)  |39/102 (38.2%)      |55/102 (53.9%)  |
|Baseline-Haiku  |D3     |0       |84/102 (82.4%)   |17/102 (16.7%)  |1/102 (1.0%)        |18/102 (17.6%)  |
|Baseline-Haiku  |D4     |0       |60/102 (58.8%)   |35/102 (34.3%)  |7/102 (6.9%)        |42/102 (41.2%)  |
|Baseline-Haiku  |D5     |0       |47/102 (46.1%)   |54/102 (52.9%)  |1/102 (1.0%)        |55/102 (53.9%)  |

Pooled rates with 95% CIs (complete per-domain intervals remain in output/tables/table3-supplement.csv):

|arm             |status              |n   |count |missing |Estimate (95% CI)                   |
|:---------------|:-------------------|:---|:-----|:-------|:-----------------------------------|
|ARBITER-Sonnet  |Consistent          |510 |510   |0       |510/510 (100.0%) (100.0% to 100.0%) |
|ARBITER-Sonnet  |Proposed agreement  |510 |510   |0       |510/510 (100.0%) (100.0% to 100.0%) |
|ARBITER-Sonnet  |Recorded override   |510 |0     |0       |0/510 (0.0%) (0.0% to 0.0%)         |
|ARBITER-Sonnet  |Violation           |510 |0     |0       |0/510 (0.0%) (0.0% to 0.0%)         |
|ARBITER-Sonnet  |Invalid answer path |510 |0     |0       |0/510 (0.0%) (0.0% to 0.0%)         |
|ARBITER-Sonnet  |Departure           |510 |0     |0       |0/510 (0.0%) (0.0% to 0.0%)         |
|Baseline-Sonnet |Consistent          |509 |444   |1       |444/509 (87.2%) (84.4% to 90.0%)    |
|Baseline-Sonnet |Violation           |509 |26    |1       |26/509 (5.1%) (3.3% to 6.9%)        |
|Baseline-Sonnet |Invalid answer path |509 |39    |1       |39/509 (7.7%) (5.7% to 10.0%)       |
|Baseline-Sonnet |Departure           |509 |65    |1       |65/509 (12.8%) (10.0% to 15.6%)     |
|ARBITER-Haiku   |Consistent          |505 |505   |5       |505/505 (100.0%) (100.0% to 100.0%) |
|ARBITER-Haiku   |Proposed agreement  |505 |505   |5       |505/505 (100.0%) (100.0% to 100.0%) |
|ARBITER-Haiku   |Recorded override   |505 |1     |5       |1/505 (0.2%) (0.0% to 0.6%)         |
|ARBITER-Haiku   |Violation           |505 |0     |5       |0/505 (0.0%) (0.0% to 0.0%)         |
|ARBITER-Haiku   |Invalid answer path |505 |0     |5       |0/505 (0.0%) (0.0% to 0.0%)         |
|ARBITER-Haiku   |Departure           |505 |0     |5       |0/505 (0.0%) (0.0% to 0.0%)         |
|Baseline-Haiku  |Consistent          |510 |330   |0       |330/510 (64.7%) (61.4% to 68.2%)    |
|Baseline-Haiku  |Violation           |510 |132   |0       |132/510 (25.9%) (22.7% to 29.0%)    |
|Baseline-Haiku  |Invalid answer path |510 |48    |0       |48/510 (9.4%) (7.5% to 11.4%)       |
|Baseline-Haiku  |Departure           |510 |180   |0       |180/510 (35.3%) (31.8% to 38.6%)    |

ARBITER-Sonnet: 510/510 proposed agreement and 0/510 recorded overrides. ARBITER-Haiku: 505/505 proposed agreement and 1/505 (0.2%) recorded overrides. The unchanged hill-2017 D1 Low-to-Some-concerns override gives adopted-label agreement of 504/505 (99.8%); its rationale and evidence remain in the supplement.

### Overall consistency

|arm             |missing |Consistent       |Permitted escalation |Violation    |
|:---------------|:-------|:----------------|:--------------------|:------------|
|ARBITER-Sonnet  |0       |101/102 (99.0%)  |1/102 (1.0%)         |0/102 (0.0%) |
|Baseline-Sonnet |0       |102/102 (100.0%) |0/102 (0.0%)         |0/102 (0.0%) |
|ARBITER-Haiku   |1       |101/101 (100.0%) |0/101 (0.0%)         |0/101 (0.0%) |
|Baseline-Haiku  |0       |102/102 (100.0%) |0/102 (0.0%)         |0/102 (0.0%) |
|Meta            |21      |74/81 (91.4%)    |6/81 (7.4%)          |1/81 (1.2%)  |

### Grounding and bundle verification

|arm             |metric              |n    |count |note          |Estimate (95% CI)                     |
|:---------------|:-------------------|:----|:-----|:-------------|:-------------------------------------|
|ARBITER-Sonnet  |Evidence coverage   |1538 |1538  |NA            |1538/1538 (100.0%) (100.0% to 100.0%) |
|ARBITER-Sonnet  |Bundle verification |102  |102   |NA            |102/102 (100.0%) (100.0% to 100.0%)   |
|Baseline-Sonnet |Evidence coverage   |b
|Baseline-Sonnet |Bundle verification |b
|ARBITER-Haiku   |Evidence coverage   |1552 |1552  |NA            |1552/1552 (100.0%) (100.0% to 100.0%) |
|ARBITER-Haiku   |Bundle verification |102  |102   |NA            |102/102 (100.0%) (100.0% to 100.0%)   |
|Baseline-Haiku  |Evidence coverage   |b
|Baseline-Haiku  |Bundle verification |b

Both ARBITER arms have zero invalid paths in every checked domain history record, including earlier revisions. All active questions have answers. The empty Haiku bundle verifies structurally without supplying a completed assessment; it does not repair missing labels.

|arm            |history_records |final_domains |invalid_paths |unanswered_active |
|:--------------|:---------------|:-------------|:-------------|:-----------------|
|ARBITER-Sonnet |510             |510           |0             |0                 |
|ARBITER-Haiku  |509             |505           |0             |0                 |

### Invalid-path sensitivity

Replace required invalid NA/missing answers recursively, including newly required questions, as N/PN (implemented as N), then as NI. Complete-path violations are retained. N and PN have identical algorithm branches. Answers off the resolved path are not imputed.

|arm             |domain |n   |original_violations |invalid_paths |Violations after N/PN |Violations after NI |
|:---------------|:------|:---|:-------------------|:-------------|:---------------------|:-------------------|
|Baseline-Sonnet |D1-D5  |509 |26                  |39            |29                    |62                  |
|Baseline-Sonnet |D1     |101 |5                   |0             |5                     |5                   |
|Baseline-Sonnet |D2     |102 |3                   |4             |4                     |5                   |
|Baseline-Sonnet |D3     |102 |3                   |2             |5                     |5                   |
|Baseline-Sonnet |D4     |102 |3                   |32            |3                     |35                  |
|Baseline-Sonnet |D5     |102 |12                  |1             |12                    |12                  |
|Baseline-Haiku  |D1-D5  |510 |132                 |48            |162                   |180                 |
|Baseline-Haiku  |D1     |102 |10                  |0             |10                    |10                  |
|Baseline-Haiku  |D2     |102 |16                  |39            |45                    |55                  |
|Baseline-Haiku  |D3     |102 |17                  |1             |17                    |18                  |
|Baseline-Haiku  |D4     |102 |35                  |7             |35                    |42                  |
|Baseline-Haiku  |D5     |102 |54                  |1             |55                    |55                  |

The pooled Baseline-Sonnet violation counts are 29 under N/PN and 62 under NI (original complete-path violations: 26; invalid paths: 39). Baseline-Haiku has 162 and 180 (original violations: 132; invalid paths: 48). Baseline-Sonnet D4 alone has 32 invalid paths, including the 28 cells with 4.1=N, 4.2=N and 4.3=NA identified in the review.

## Table 5: process metrics

Values are median [IQR] and paired mean ARBITER-minus-Baseline differences (95% CI), over 102 trials per arm. Time is minutes/trial, costs USD/trial to two decimals, tokens thousands/trial. Cost is a reconstructed API list-price equivalent under the amended plan, not expenditure. Harness figures are unusable (unrecognized_model; cost basis unknown) and supplementary only. Thinking tokens are included in output tokens and are not added twice. Native-unit totals remain in output/tables/process-summary.csv.

### Sonnet (main text)

|Metric                                  |ARBITER-Sonnet                  |Baseline-Sonnet           |Paired mean difference (95% CI) |
|:---------------------------------------|:-------------------------------|:-------------------------|:-------------------------------|
|Time (minutes/trial)                    |7.6 [6.1 to 10.5]               |0.5 [0.4 to 0.5]          |11.0 (8.4 to 14.1)              |
|Cost (USD/trial)                        |3.78 [3.46 to 4.10]             |0.09 [0.07 to 0.13]       |3.68 (3.61 to 3.75)             |
|Input tokens (thousands/trial)          |0.096 [0.086 to 0.104]          |0.006 [0.006 to 0.006]    |0.090 (0.088 to 0.092)          |
|Cache creation tokens (thousands/trial) |493.973 [459.698 to 544.387]    |16.790 [10.759 to 25.805] |478.288 (469.390 to 487.124)    |
|Cache read tokens (thousands/trial)     |4964.973 [4483.251 to 5585.994] |24.690 [24.563 to 24.957] |4992.969 (4867.215 to 5117.104) |
|Output tokens (thousands/trial)         |21.362 [18.913 to 24.285]       |2.397 [1.927 to 2.924]    |19.495 (18.829 to 20.144)       |
|Thinking tokens (thousands/trial)       |3.451 [2.596 to 4.183]          |1.041 [0.673 to 1.348]    |2.498 (2.319 to 2.679)          |
|Agent steps/trial                       |60.0 [54.0 to 71.8]             |4.0 [4.0 to 5.0]          |58.6 (56.9 to 60.3)             |
|Continue prompts/trial                  |0.0 [0.0 to 0.0]                |0.0 [0.0 to 0.0]          |0.0 (0.0 to 0.0)                |
|Turns/trial                             |2.0 [2.0 to 2.0]                |1.0 [1.0 to 1.0]          |1.0 (1.0 to 1.0)                |

### Haiku (supplement; exploratory paired contrasts)

|Metric                                  |ARBITER-Haiku                   |Baseline-Haiku             |Paired mean difference (95% CI) |
|:---------------------------------------|:-------------------------------|:--------------------------|:-------------------------------|
|Time (minutes/trial)                    |8.0 [6.8 to 9.3]                |1.1 [0.9 to 1.4]           |10.1 (7.9 to 12.7)              |
|Cost (USD/trial)                        |1.12 [0.99 to 1.23]             |0.01 [0.01 to 0.02]        |1.14 (1.09 to 1.18)             |
|Input tokens (thousands/trial)          |0.116 [0.102 to 0.124]          |0.008 [0.006 to 0.010]     |0.107 (0.104 to 0.110)          |
|Cache creation tokens (thousands/trial) |567.770 [510.502 to 617.017]    |39.401 [26.737 to 59.889]  |521.435 (505.567 to 537.144)    |
|Cache read tokens (thousands/trial)     |5789.667 [5246.519 to 6297.647] |44.218 [24.767 to 125.434] |5663.085 (5496.685 to 5831.591) |
|Output tokens (thousands/trial)         |55.800 [48.436 to 63.792]       |12.027 [9.562 to 15.164]   |43.725 (41.715 to 45.712)       |
|Thinking tokens (thousands/trial)       |27.743 [23.728 to 32.435]       |9.976 [7.739 to 12.977]    |18.179 (16.905 to 19.443)       |
|Agent steps/trial                       |68.0 [63.0 to 74.0]             |6.0 [5.0 to 9.0]           |61.3 (59.4 to 63.1)             |
|Continue prompts/trial                  |0.0 [0.0 to 0.0]                |0.0 [0.0 to 0.0]           |0.0 (0.0 to 0.1)                |
|Turns/trial                             |2.0 [2.0 to 2.0]                |1.0 [1.0 to 1.0]           |1.0 (1.0 to 1.1)                |

## Reconstructed costs: totals and per-trial medians

|arm             |Basis   |Total (USD) |Median per trial (USD) |
|:---------------|:-------|:-----------|:----------------------|
|ARBITER-Sonnet  |point   |386.07      |3.78                   |
|ARBITER-Sonnet  |lower   |386.07      |3.78                   |
|ARBITER-Sonnet  |upper   |386.07      |3.78                   |
|ARBITER-Sonnet  |harness |1140.34     |11.11                  |
|Baseline-Sonnet |point   |10.49       |0.09                   |
|Baseline-Sonnet |lower   |10.49       |0.09                   |
|Baseline-Sonnet |upper   |10.49       |0.09                   |
|Baseline-Sonnet |harness |27.12       |0.24                   |
|ARBITER-Haiku   |point   |117.63      |1.12                   |
|ARBITER-Haiku   |lower   |109.19      |1.06                   |
|ARBITER-Haiku   |upper   |122.63      |1.17                   |
|ARBITER-Haiku   |harness |1447.29     |14.00                  |
|Baseline-Haiku  |point   |1.85        |0.01                   |
|Baseline-Haiku  |lower   |1.80        |0.01                   |
|Baseline-Haiku  |upper   |4.32        |0.04                   |
|Baseline-Haiku  |harness |80.10       |0.73                   |

Lower, point and upper bounds use the amended plan rate card; harness is unusable and is preserved only as a diagnostic. Side-call cache-write sensitivity uses five-minute rather than one-hour writes.

|arm             |request_input |request_write1 |request_write5 |request_read |result_input |result_write1 |result_write5 |result_read |result_output |side_input |side_write1 |side_write5 |side_read |side_output |gap_input |gap_write1 |gap_write5 |gap_read |requests |high_requests |compaction_events |turns_with_side_calls |turns_with_request_excess |side_without_compaction |
|:---------------|:-------------|:--------------|:--------------|:------------|:------------|:-------------|:-------------|:-----------|:-------------|:----------|:-----------|:-----------|:---------|:-----------|:---------|:----------|:----------|:--------|:--------|:-------------|:-----------------|:---------------------|:-------------------------|:-----------------------|
|ARBITER-Sonnet  |9794          |50698919       |0              |512761030    |9794         |50695878      |0             |512867801   |2237043       |5777447    |13464429    |0           |203137779 |2388538     |0         |-3041      |0          |106771   |4897     |3272          |322               |122                   |3                         |0                       |
|Baseline-Sonnet |644           |1910531        |0              |3585005      |644          |1910531       |0             |3585005     |248579        |0          |0           |0           |0         |0           |0         |0          |0          |0        |322      |0             |0                 |0                     |0                         |0                       |
|ARBITER-Haiku   |11760         |57557731       |0              |584364182    |11792        |57619249      |0             |586216581   |5718801       |4772002    |19882918    |0           |237650013 |4457402     |32        |61518      |0          |1852399  |5878     |3620          |356               |140                   |0                         |5                       |
|Baseline-Haiku  |872           |4432900        |0              |8581878      |872          |4432900       |0             |8581878     |1258831       |0          |0           |0           |0         |0           |0         |0          |0          |0        |436      |10            |0                 |0                     |0                         |0                       |

## Figure 1: selected bundle trace

- Cell: levin-2016 D2.
- Cited passage: "All analyses were conducted on the intent-to-treat sample." (8 whitespace-separated words).
- Source: j.drugalcdep.2015.11.025.pdf; captured PDF page 4.
- Evidence identity: sha256:7aa586b897bd8bbceac768c6d6080f1bda917f922bd77da08973578793031bb7.
- Question 2.6 = Y; active domain answer set: 2.1=PN; 2.2=PN; 2.6=Y.
- Proposed judgement: Low; meta label: Some concerns; consensus preferred judgement: Low.
- Five bundle-evidence candidates are exported in output/tables/worked-trace-candidates.csv. The trace is provisional for author selection, as the plan requires. It is sourced from a cited evidence record, not justification text.

## Grounding, reliability, and provenance fixes

Quotation syntax moved to the supplement with the explanation that ARBITER evidence records are stored separately from justifications. Evidence coverage and bundle verification now appear in Table 3. Code-only baseline justification fields were counted directly:

|arm             |n    |answer_code_only |
|:---------------|:----|:----------------|
|Baseline-Sonnet |1459 |1344             |
|Baseline-Haiku  |1782 |1320             |

Thus Baseline-Sonnet is not uniformly code-only: 1344/1459 (92.1%) active exported fields are answer codes only; Baseline-Haiku has 1320/1782 (74.1%). Remaining fields contain other text or are empty. This describes the supplied exports, not unobserved model reasoning.

Table 4 source comparisons explicitly carry: "Disputed cells only (selected for disagreement with the meta label); not an estimate of overall meta-label accuracy". Methods give the documented model IDs, medium effort, Claude Code 2.1.278, isolated homes, ARBITER 1.0.0 public commit 2f549ae and run dates (Sonnet ARBITER: 12 October 2026; other arms: 14 October 2026). Only the ARBITER 1.0.0 Zenodo DOI placeholder remains.

## DEVIATIONS.md changes and remaining uncertainty

- Entry 2 removes the obsolete provenance-confirmation placeholder.
- Entry 7 replaces the justification-based trace convention with short excerpts from linked bundle evidence, source/page locators and evidence identities.
- Entry 8 records the amended invalid-path classification, retained denominators, recursive N/PN and NI sensitivities, and separate proposal/override reporting. The human codebook and code fields are unchanged.
- Entry 11 records supplementary quote syntax, factual code-only counts, Table 5 units and paired estimands, exploratory Haiku contrasts, reliability selection wording, and the requested zero reference line for All-Low. Entry 12 implements author cost amendment 69c73c6 with signed residuals, synthetic-message exclusions, side-call flags and cache-write sensitivity.
- The author cost amendment in commit 69c73c6 supersedes the original R3 harness-cost wording. Request/result input gaps are signed: negative retry residuals are retained and explicitly reconciled, using the same lower/request-share/upper pricing allocation. Side-call turns without a compaction event use those allocations too and are flagged. Synthetic zero-usage messages are excluded from request counts. All lower/point/upper order checks pass. No unresolved implementation blocker remains. The plan treats All-Low kappa differently in tables and Figure 4: tables suppress it as directed; Figure 4 shows the requested zero reference and explains the reporting convention in its caption.
- Author decisions remain: final choice among five worked traces, human taxonomy coding, checklist completion, and ARBITER 1.0.0 Zenodo DOI. Bundle verification is structural and does not prove judgement correctness or assessment completion.
- Composite caveats remain explicit: adjudicators chose only among offered labels, and unadjudicated cells where both Sonnet arms matched meta are assumed correct. Run-to-run variability is not estimated.
