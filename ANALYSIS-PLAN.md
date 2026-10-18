# ARBITER JAMIA analysis plan

Status: fixed on 2026-10-18, after data collection and before any analysis beyond the descriptive checks below. Terms follow `GLOSSARY.md`.

## 1. Framing

ARBITER is reported as a system and auditability paper. The primary quantitative evidence is blinded human adjudication of the disputed cells. Agreement with meta labels is reported in full as evidence that published RoB 2 labels are a noisy reference. It is not the headline.

Only the primary endpoint (section 4) is confirmatory. Every other analysis is secondary or exploratory. Results are reported as estimates with 95% CIs. There are no p-values and no multiplicity correction.

## 2. Data

| Source | File | Notes |
|---|---|---|
| ARBITER-Sonnet | `kit-sonnet-5.5/rob2kit-domain-labels.csv`, `rob2kit-signalling-answers.csv` | Domain labels in `rob2kit_D1` to `rob2kit_Overall`. Signalling-question IDs are `sq:<domain>:<name>`. |
| Baseline-Sonnet | `no-kit-sonnet-5.5/model-domain-labels.csv`, `model-signalling-answers.csv` | Domain labels in `model_*`. Signalling-question IDs are `1.1` to `5.3`. |
| ARBITER-Haiku | `kit-haiku-5.5/...` | Supplement only. |
| Baseline-Haiku | `no-kit-haiku-5.5/...` | Supplement only. |
| Meta labels | `human_*` columns of the arm files; `rob2-meta-benchmark-set/LABEL-TARGETS.csv` | `(not given)` and `(not given per row)` mean missing. |
| Adjudication | `human-adjudication/adjudication-cells-with-explanations-A.xlsx` and `-Z.xlsx` | One row per disputed cell. Both files have the same row order. |
| Benchmark set | `rob2-meta-benchmark-set/TRIAL-SUMMARY.csv`, `LABEL-TARGETS.csv` | Trial, meta and field metadata. |

Inputs are read-only. Analysis code never writes into the data folders.

Each signalling answer is one of `yes`, `probably_yes`, `probably_no`, `no`, `no_information` or `not_applicable`.

## 3. Population

- Analysis set: 102 trials. atwine-2020, haney-2004 and herrmann-2016 are excluded from every arm and every analysis because ARBITER does not support their design. The flow diagram reports them. No analysis uses the 105-trial set.
- D1 to D5 cells: 102 × 5 = 510 per arm.
- Overall cells: trials with a meta Overall label (81 in the analysis set).
- Disputed cells: 154. These are all the D1 to D5 cells where ARBITER-Sonnet or baseline-Sonnet differs from the meta label. Verify that the adjudication rows match this set exactly.
- Consensus cells: disputed cells where both adjudicators gave the same preferred judgement (129).
- Split cells: disputed cells where the adjudicators' preferred judgements differ (25).
- Missing judgements: an arm cell with no label counts as wrong. ARBITER-Haiku has 5 such D1 to D5 cells. A sensitivity analysis excludes them.

## 4. Primary endpoint

**ARBITER win share on discordant cells.** A discordant cell is a disputed cell where the ARBITER-Sonnet label differs from the baseline-Sonnet label.

Credit goes by label, not by the letter the adjudicator picked. On each discordant cell:

- ARBITER wins if the preferred judgement equals the ARBITER label.
- The baseline wins if the preferred judgement equals the baseline label.
- Otherwise neither wins. This happens when the preferred judgement is the meta label and that label differs from both arms.

The estimate is ARBITER wins ÷ discordant cells. Also report baseline wins ÷ discordant cells and the share where neither wins.

- **Primary analysis:** consensus discordant cells, using the agreed preferred judgement. Expected counts are about 54 ARBITER and 7 baseline wins. Recompute them; do not copy these numbers.
- **Per adjudicator:** the same estimate on every discordant cell, using that adjudicator's preferred judgement.
- **Sensitivity:** add split discordant cells and count each one as a loss for ARBITER.
- **95% CI:** stratified cluster bootstrap. Resample trials with replacement within each meta-analysis, keep the same number of trials per meta-analysis, and take all of each sampled trial's cells. Use 10,000 replicates, percentile intervals and a fixed seed. Report the seed.

## 5. Secondary analyses

### 5.1 Agreement with meta labels (Table 2, Fig 4)

Compute these for each arm and for the all-Low rule, on D1 to D5 pooled, by domain, and on Overall:

- Linearly weighted Cohen's κ on Low < Some concerns < High. This is the main agreement measure.
- Gwet's AC2 with linear weights.
- Exact accuracy.
- Sensitivity and specificity for Not Low, with the meta label as reference.
- Paired differences between ARBITER-Sonnet and baseline-Sonnet, with stratified cluster bootstrap 95% CIs as in section 4.

κ is undefined for the all-Low rule, which has no variance. Show it as "—" and report accuracy and specificity only.

### 5.2 Agreement with the composite reference (Fig 4)

The composite reference is the consensus preferred judgement on consensus cells and the meta label on all other D1 to D5 cells. Split cells are excluded, giving 485 cells per Sonnet arm. Report weighted κ, AC2 and accuracy for both Sonnet arms, plus their paired difference.

Methods and Limitations must state two caveats:

1. Adjudicators could only choose among the three labels offered.
2. Cells where both Sonnet arms matched the meta label were never adjudicated and are assumed correct.

Both caveats inflate the absolute values for the Sonnet arms. Do not present composite accuracy as an accuracy claim in the abstract.

Sensitivity analysis: use each adjudicator's preferred judgement on its own instead of the consensus.

### 5.3 Overall judgement

Report Overall against the meta label for each arm (section 5.1 metrics), on the 81 trials with a meta Overall label.

### 5.4 Algorithm consistency (Table 3)

**Overall algorithm.** Apply the RoB 2 overall rule to each source's own D1 to D5 labels. The sources are the meta labels, both baseline arms and both ARBITER arms.

- Consistent: Overall equals the worst domain judgement.
- Permitted escalation: Overall is High, no domain is High, and at least two domains are Some concerns. RoB 2 allows this, so report it separately and do not count it as a violation.
- Violation: anything else. This includes Overall less severe than the worst domain, and Overall more severe than the worst domain without a permitted escalation.

**Domain algorithms.** Apply the official RoB 2 domain algorithms to each arm's own signalling answers. Use the effect-of-assignment version for D2. Compare the algorithm's output with the arm's reported domain label.

- Take the algorithms from the RoB 2 full guidance (Higgins, Savović, Page, Sterne, eds, 22 August 2019). Cross-check them against the ARBITER source code at https://github.com/AliSalman-et-al/ARBITER.
- Map ARBITER question IDs to the numbered questions. The 22 IDs in the ARBITER signalling file are the RoB 2 questions 1.1 to 5.3.
- **Validation gate:** on the ARBITER arms, the algorithm must reproduce 100% of the reported domain labels. If it does not, stop and report the mismatches. Do not adjust the algorithm to fit.
- Report the violation rate per arm and per domain. Meta labels have no signalling answers, so the meta labels get the overall check only.

### 5.5 Reliability of the reference standard (Table 4)

Report on the 154 disputed cells:

- Agreement between adjudicators A and Z on independent judgements and on preferred judgements: weighted κ, AC2 and raw agreement.
- For each adjudicator, agreement of the independent judgement with the meta label, the ARBITER-Sonnet label and the baseline-Sonnet label.
- Direction of meta-label error: a 3×3 table of meta label against consensus preferred judgement, summarised as the share where the meta label is less severe, equal or more severe.

### 5.6 Error taxonomy (Table 4 or supplement)

This analysis needs human coding. The analysis pipeline only prepares the materials and summarises the result.

1. Draft a deductive codebook per domain from RoB 2 guidance concepts. Examples: allocation concealment misjudged; blinding or awareness misread; deviations ignored or overcounted; missing-data threshold; wrong result or outcome assessed; selective reporting evidence missed; algorithm not followed.
2. Build a coding sheet with one row per losing source per consensus cell. Include the adjudicators' explanation text and empty code columns. A losing source is any source whose label differs from the consensus preferred judgement.
3. One author codes every row. A second author codes a random 20% sample, drawn with a fixed seed. Report Cohen's κ between the two authors.
4. Summarise codes by losing source (ARBITER, baseline, meta) as a stacked bar or a table.

Until the coding is filled in, the report shows a placeholder for this analysis.

### 5.7 Grounding metric

Report the share of signalling answers whose justification contains a verbatim quotation, for each Sonnet arm. A quotation is text inside straight or curly double quotes with at least 5 words. Only answers marked `active` count. Report this as descriptive only. It is not a measure of whether the quotes were verified.

## 6. Exploratory analyses

- Signalling-answer agreement with each adjudicator's independent answers, on disputed domains only (`signalling_answers_independent`). Report it per question, collapsed to Y/PY, N/PN and NI/NA.
- A forest plot by meta-analysis: weighted κ against the meta label per arm. Descriptive, with no tests (supplement).

## 7. Outputs

### Main text

| Item | Content |
|---|---|
| Fig 1 | The ARBITER architecture with one worked trace. The trace runs from a quoted passage to a signalling answer, then through the algorithm to a domain judgement, then to the verifiable bundle. Use a consensus cell where ARBITER beat the meta label. The pipeline drafts the diagram and lists 3 to 5 candidate cells. The authors pick one. |
| Fig 2 | Flow diagram: 16 metas → 105 trials → 3 excluded (unsupported design) → 102 → 510 D1 to D5 cells → 154 disputed → 129 consensus and 25 split. |
| Fig 3 | Panel A: the primary endpoint, with win shares and CIs for consensus, adjudicator A, adjudicator Z and the split-cell sensitivity. Panel B: all 154 disputed cells grouped by which arm departed from the meta label, coloured by whose label the adjudicators preferred. |
| Fig 4 | By domain: weighted κ against the meta label and against the composite reference, for both Sonnet arms, with all-Low accuracy marked. |
| Table 1 | Benchmark set: one row per meta with field, journal, trial count and meta-label distribution by domain. |
| Table 2 | Agreement with meta labels (section 5.1) for ARBITER-Sonnet, baseline-Sonnet and all-Low, on D1 to D5 pooled and Overall. |
| Table 3 | Algorithm consistency (section 5.4). |
| Table 4 | Reliability of the reference standard (section 5.5), and the error taxonomy (section 5.6) if space allows. |

### Supplement

- Haiku arms on every analysis except the adjudication analyses (sections 4, 5.2 and 5.6).
- Full 3×3 confusion matrices per arm and domain.
- Forest plot by meta-analysis.
- Per-adjudicator results and the split-cell sensitivity analysis.
- The missing-judgement sensitivity analysis.
- The error-taxonomy codebook.
- The prompt template and one filled example.
- The TRIPOD-LLM checklist, with GRRAS items for the agreement analyses.

Figures are saved as PDF and as PNG at 600 dpi. Tables are saved as CSV and rendered in the report.

## 8. Reporting

- Follow TRIPOD-LLM, plus GRRAS for the agreement and reliability parts.
- Methods state the model IDs, the effort setting, the run dates and the ARBITER commit.
- Each arm ran each trial once. Report this as a limitation: run-to-run variability is not estimated.

## 9. Implementation

- Quarto project in `analysis/`. The R package environment is managed by `renv`. Python through `uv` is used only if a task needs it.
- One function per estimand, in `analysis/R/`. Tests use `testthat` and cover at least:
  - the overall algorithm and domain algorithms, including the validation gate in section 5.4
  - the bootstrap resampler
  - the win-share scoring, with hand-built cells
  - a reproduction of the baseline-Sonnet D1 to D5 count of 395/510 from `no-kit-sonnet-5.5/accuracy.md`
- Running `quarto render analysis/` rebuilds every number, figure and table from the CSVs.
- Code and adjudication sheets go to a public repository with a Zenodo DOI. Trial PDFs are not redistributed; DOIs and the `FILES.csv` hashes are given instead.
