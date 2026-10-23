# ARBITER JAMIA analysis plan

Status: current computational and reporting contract, reconciled on 23 October 2026 after analysis in response to the author interview. Evaluation outcomes have no formal primary/secondary or confirmatory hierarchy. Their presentation order is Published exact agreement, independent-expert agreement, conditional blinded-label choices, domain/signalling detail and supporting checks. This is an author-directed reporting change after analysis, not prospective prespecification. Estimands, eligibility, bootstrap methods and numerical results are retained.

The prior operative plan is preserved in `analysis/provenance/ANALYSIS-PLAN-2026-10-23-before-reconciliation.md` and git history; the 18 October plan remains in `analysis/provenance/ANALYSIS-PLAN-2026-10-18.md`. Historical statements in those records describe prior documentation, not the status claimed by this current report. See `docs/manuscript-development/round5/analysis-repair.md` for the computational assessment and validation boundaries. Terms follow `GLOSSARY.md`.

## 1. Framing and provenance

ARBITER is evaluated as a system and auditability workflow. Published review labels and independent expert ratings are distinct comparison sources; neither is established ground truth. Exact agreement precedes ordinal coefficients in reporting. Blinded-label choices describe preference conditional on arm disagreement and, for the agreed-choice estimate, equal expert choices. They are not measures of accuracy.

Experts were published researchers from BEACON Lab. According to the author, they received the same trial materials, available supplements and ClinicalTrials.gov records, and the same assessment task specifying outcome(s), contrast and numerical anchor as the arms; they had access to Cochrane RoB 2 guidance. Independent ratings and signalling answers were frozen before blinded label exposure. Individual training/calibration, qualifications beyond this description and multi-outcome aggregation conventions remain unconfirmed; do not invent them or infer additional-source use.

The benchmark was purposively assembled across specialties, with target revisions before the requested runs; it is not a systematic or representative sample. The author confirms it was not used in ARBITER development. The separately recovered development `eval/` corpus contains ten prostate-cancer trials. Bounded identity/document checks found no overlap with this benchmark, with completeness limits documented in `docs/manuscript-development/round5/development-provenance.md`. Do not promote author attestation or bounded checks into an exhaustive no-exposure claim. These clarifications do not add a target-matching filter or any new experiment, model or subgroup.

Report estimates with 95% CIs, no p-values and no multiplicity correction. Resampling scopes and conditional denominators are explicit below.

## 2. Data

| Source | File | Notes |
|---|---|---|
| ARBITER-Sonnet | `kit-sonnet-5.5/rob2kit-domain-labels.csv`, `rob2kit-signalling-answers.csv` | Domain labels in `rob2kit_D1` to `rob2kit_Overall`. Signalling-question IDs are `sq:<domain>:<name>`. |
| Baseline-Sonnet | `no-kit-sonnet-5.5/model-domain-labels.csv`, `model-signalling-answers.csv` | Domain labels in `model_*`. Signalling-question IDs are `1.1` to `5.3`. |
| Meta labels | `human_*` columns of the arm files; `rob2-meta-benchmark-set/LABEL-TARGETS.csv` | `(not given)` and `(not given per row)` mean missing. |
| Expert assessment | `human-adjudication/adjudication-with-explanations-1.xlsx` and `-2.xlsx` | Independent, forced-choice and revised ratings for all 510 trial-domain cells, with signalling evidence. |
| Benchmark set | `rob2-meta-benchmark-set/TRIAL-SUMMARY.csv`, `LABEL-TARGETS.csv` | Trial, meta and field metadata. |

Inputs are read-only. Analysis code never writes into the data folders.

Each signalling answer is one of `yes`, `probably_yes`, `probably_no`, `no`, `no_information` or `not_applicable`.

## 3. Population

- Analysis set: 102 trials. atwine-2020, haney-2004 and herrmann-2016 remain excluded from every arm and every analysis as unsupported designs. The author confirms Atwine is unsupported despite its incorrect stored model classification; no alternative subtype or independent design verification is claimed. The flow diagram reports them. No analysis uses the 105-trial set.
- D1 to D5 cells: 102 × 5 = 510 per arm.
- Overall populations: Published-label agreement uses 81 observed labels; expert-reference comparisons use 102 model Overall labels and also matched 81-trial comparisons, as specified in section 5.
- All 510 domain cells were independently rated by both experts. Disputed and discordant subsets are recomputed from arm labels.
- Agreed reference: equal independent ratings, with no substitution of published labels.
- Missing model labels remain missing and count as disagreement.

## 4. Published-label agreement

The published-label analysis is unchanged: exact agreement, weighted κ, AC2, sensitivity for Some concerns or High, specificity, paired differences and an All-Low rule. D1–D5 use all domain cells. Overall uses only trials with a published Overall label. All-Low has no variance, so κ, AC2 and sensitivity are suppressed by the reporting rule. Unweighted κ is supplementary. Missing predictions fail exact and binary agreement. For ordinal coefficients, they receive maximal disagreement, as in the parent analysis.

## 5. Independent-rating agreement and derived Overall

For new expert-reference Overall comparisons, ARBITER and Unassisted use all 102 trials. Published uses only the 81 observed Overall labels: 21 trials had no published Overall label, and missing labels never count as disagreements. Also report ARBITER and Unassisted on the same 81 trials. Every paired Overall contrast involving Published uses those 81 trials. The agreed reference restricts each population further to equal expert ratings. Print n on every row and explain the 21 absent labels and population denominators in every relevant footnote. The Overall population clarification was supplied on 2026-10-21; D1–D5 and unchanged analyses are unaffected.


Compare ARBITER, Unassisted and Published labels with each expert's frozen independent rating across all domain cells. Report exact agreement and linearly weighted Cohen's κ, pooled across D1–D5, by domain and for derived Overall. Report each expert separately, the arithmetic mean of expert-specific estimates, and the agreed-reference sensitivity restricted to equal independent ratings. The mean of κ values is not a pooled κ.

Report paired ARBITER minus Unassisted, ARBITER minus Published and Unassisted minus Published differences with bootstrap CIs. Each contrast uses the same reference and trial resample. Exact-agreement differences are percentage points. Report expert-to-expert exact agreement and weighted κ as a reference line, with unweighted κ and confusion matrices in the supplement. The reference line describes observed expert reliability, not a mathematical upper bound.

Overall is derived from each expert's five independent domain ratings as their worst domain. RoB 2 permits escalation to High with multiple Some concerns domains, but does not require it. No optional escalation is imposed. Validate every available column of file 2's Overall sheet and export every difference, including absent published Overall labels and permitted escalations. Published and model Overall labels stay as reported in agreement analyses.

## 6. Conditional blinded-label choices

The estimand is the share of discordant domain cells where the experts' agreed blinded choice matches ARBITER's rating. Expert-specific and split-choice sensitivities and the existing post hoc strictness strata are retained. This section specifies calculation mechanics without assigning scientific priority or confirmatory status.

A discordant cell has different ARBITER and Unassisted labels. The agreed-choice population retains only cells where the two experts made the same forced choice. Credit goes to every source whose label equals that choice. The selected reviewer letter is ignored. Concordant cells, where all three labels match, are excluded from preference analyses. Neither source receives credit when the choice matches neither arm.

Report the agreed-choice share, numerator, denominator and 95% CI. Sensitivities use each expert separately on all discordant cells, and count every split choice as an ARBITER loss without assigning an Unassisted win. Exploratory strata distinguish ARBITER stricter from ARBITER more lenient than Unassisted. Severity is Low < Some concerns < High. These preference estimates are not measures of accuracy.

All intervals use 10,000 trial-cluster bootstrap replicates stratified by source meta-analysis, seed 20261018. Resampling retains each stratum's trial count and all cells belonging to each sampled trial. Percentile intervals use quantile type 7. Paired contrasts and expert means use the same weights. Undefined replicates are excluded, their count is retained, and no p-values or multiplicity adjustments are used.

## 7. Supporting checks

### 7.1 Direction of disagreement

For each arm, select cells where its label is stricter, or more lenient, than Published. For each independent expert separately, report the share whose rating equals the arm, equals Published or equals neither. These exhaustive categories use the entire directional population, without filtering on forced-choice consensus. Report numerators, denominators and bootstrap CIs.

### 7.2 Signalling-question agreement

Map ARBITER semantic IDs through `question-map.csv` onto official RoB 2 question numbers. Unassisted and expert numeric IDs already use that numbering. Compare each arm against each expert's independent answers, by question, domain and overall. Five-level exact agreement distinguishes Y, PY, N, PN and NI. Collapsed agreement combines Y/PY and N/PN, leaving NI separate.

Only explicit answers to the same trial, domain, question and component are evaluable. Match components by their explicit names when both sides provide components. Never broadcast a scalar across outcomes. NA, inactive or missing answers, unmatched components and unresolved text are not evaluable. Export their counts and every parse issue. Paired ARBITER minus Unassisted differences retain only components evaluable in both arms and receive trial-cluster CIs. The expanded parse preserves raw text, phase, workbook row, normalised retained/changed/mixed status and stated transitions.

### 7.3 Rule consistency

Apply the official 22 August 2019 RoB 2 domain algorithms to each arm's own answers, with the effect-of-assignment D2 algorithm. Required missing or NA answers make a nonempty path invalid. Separate ratings contradicting their answers, invalid paths and wholly unevaluable cells. Resolve invalid paths recursively as N/PN and NI in the existing sensitivity. ARBITER proposals must reproduce the official algorithms for every domain, adopted labels must match the exported labels and every override must be recorded. Stop if the gate fails. No ARBITER domain overrides were recorded in these runs.

For Overall, distinguish the worst-domain rule, permitted escalation to High when at least two domains have Some concerns, and violations. Do not count permitted escalation as a violation. Published labels have no signalling answers and receive only the Overall check.

### 7.4 Audit runtime and cost

Keep the parent bundle, quotation, runtime, cost and prior-work numbers unchanged. Reports read committed derived metrics. Explicit extraction commands require the raw inputs and stop if they are absent. Check active-answer coverage, text and visual source binding, content hashes, domain lineage and archived verification receipts. Quotation occurrence is described as "found in the stored source". Structural verification does not establish clinical correctness or whether a quotation supports an answer.

Runtime is the sum of harness wall time across trial turns. Report per-trial medians and IQRs and paired mean differences. Tokens include input, cache creation, cache read, output and thinking, with thinking already included in output pricing. Cost is a frozen-rate API list-price equivalent, not subscription expenditure. Deduplicate assistant requests by message identity. Reconcile request, terminal and side-call usage. Retain signed reconciliation gaps. The main cost reconstruction uses one-hour side-call write rates, with five-minute writes as a sensitivity. The frozen USD rates per million tokens are input 2.00, one-hour cache write 4.00, five-minute write 2.50, cache read 0.10 and output 10.00. Preserve the parent reconstruction bounds, long-context handling and diagnostics exactly.

### 7.5 Supporting and descriptive analyses

Rules-only recomputation replaces Unassisted algorithm violations with the output implied by its own answers. Invalid paths and missing ratings remain unchanged. Keep the original discordant population fixed even when repairs create ties. Score preference by label after repair, so both arms may receive credit on a new tie. Report all changed cells, how many were originally discordant, agreed-choice and sensitivity shares and independent-rating agreement against the new references. This is an exploratory analysis of the arithmetic contribution.

Forced-choice summaries on all disputed cells are descriptive. Credit every matching source, so shares may sum to more than 100%. Revised ratings and signalling-answer retention or change are descriptive and cannot replace the independent reference. Count retained, changed and mixed statuses at the original question-row level and preserve component details in derived data. The author confirms matched supplied expert and arm materials; do not infer additional-source use or add a source-based sensitivity from earlier unsupported prose.

Rules-only recomputation and strictness strata were introduced post hoc; revised ratings and retention/change summaries remain descriptive. Retaining these provenance distinctions does not assign a primary/secondary or confirmatory hierarchy to evaluation outcomes. Historical plans and amendment records are preserved without retroactively claiming prospective specification.

Severity distributions count Low, Some concerns and High for Published, ARBITER, Unassisted, Expert 1 and Expert 2 on 510 domain cells, with Overall denominators of 81 for Published and 102 otherwise. Binary sensitivity and specificity treat Some concerns or High as positive against each independent expert. Report pooled and per-domain results and paired ARBITER − Unassisted differences with the shared stratified trial-cluster bootstrap.

## 8. Outputs and production

The Methods and Results sequence is benchmark and reference, Published exact agreement, independent-expert agreement, conditional blinded-label choices, domain and signalling detail, rules-only recomputation, process integrity, then time and cost. This sequence does not alter the actual expert procedure: independent ratings preceded blinded label exposure. Each paragraph leads with the pattern and gives traceable numbers.

Figures 1 and 2 are byte-protected against fee1225. The current five-figure/three-table publication inventory is defined in `analysis/R/display-numbering.R`. Retain the conditional-choice estimates and core sensitivities, absolute and paired expert/Published comparisons, directional and domain/signalling detail, benchmark/reference context and process/resource checks. Full estimates and supporting analyses remain in the supplement. Display numbering follows the current publication registry and Results citation order; historical Round 15/16 numbering is provenance, not a current inventory. No figure has an internal title.

Use the glossary reader labels. Tables use Arial 9 pt and the established three-line style, with abbreviations and denominators defined. Figure colours retain JAMA roles: ARBITER #00A1D5, Unassisted #DF8F44, Published #374E55 and light grey for unavailable values. Use Fira Sans for plots and Fira Sans Condensed for diagrams. Figures are 84 or 174 mm wide, with text at least 7 pt, bold capital panel tags and no internal titles. Export vector PDF and 600-dpi LZW TIFF. Render each document page and each figure to PNG, inspect for clipping and readability, and check figures in greyscale and colour-vision simulations.

Titles state the finding. Legends describe the marks and method concisely and include alt text. Report coefficients to two decimals, proportions as n/N and one decimal percent, costs to two decimals and minutes to one decimal. Use an en dash for positive CI bounds and "to" with a true minus sign for negative bounds. Do not use "first", "over-flagging", or "accuracy" for conditional preference. Use "assistant", "content-hashed" and "found in the stored source" as applicable. Strictness claims apply to RoB 2 only.

Limitations include two experts with modest agreement, especially in D3; incompletely reported expert training/calibration; possible anchoring by offered labels; derived rather than directly rated Overall; system-level attribution; no structured-prompt comparator; a single run; possible training exposure; unassessed quotation support; outcome mismatch; and the De Waal input error.

## 9. Reporting

- Follow TRIPOD-LLM, plus GRRAS for the agreement and reliability parts.
- Methods state the model IDs, the effort setting, the run dates and the ARBITER commit. Take these from the run READMEs and `meta.json`:
  - Model `claude-sonnet-5-5`, effort medium
  - Claude Code 2.1.278, with an isolated home (`claude-home-settings.json`)
  - Evaluated run revision `2848c79`; public ARBITER 1.0.0 commit `2f549ae` is the renamed release. Use the retained rename-equivalence audit and its limits; do not equate whole releases or imply the public commit was run.
- Call the tool ARBITER and the skill `/arbiter-assess` throughout, including in the analysis code, figures and tables. rob2-kit is an earlier name for the same software. File names and identifiers in the data, such as `rob2kit_*` columns, `/rob2-assess` in the logs and `kit_commit`, are internal and are never shown in outputs. The version cited in Methods must resolve in the public ARBITER repository or its Zenodo archive.
- The baseline prompt is the same minimal prompt without the skill, followed by the output-format instruction in `no-kit-*/nokit-format.txt`. Methods must quote it, and must not call the two prompts identical.
- In the reported ARBITER arm, the harness approved the proposed result unchanged with "Approved."; every case took two turns. The Unassisted stop rule permitted "Continue." at most twice per phase, but none was needed. Report the arm-specific protocol from the run READMEs.
- Each arm ran each trial once. Report this as a limitation: run-to-run variability is not estimated.

## 10. Implementation

- Legacy filenames `primary-endpoint.csv`, `rules-only-primary.csv` and `secondary.R` and the rules-only list key `primary` are retained for provenance and reader compatibility. They identify conditional-choice calculations or historical code organization, not scientific status. The computational entry point is `conditional_choice_analyses`; publication readers must use neutral labels. The RoB 2 signalling ID `selection:prespecified-analysis` refers to a trial's analysis plan, not this evaluation's specification chronology.

- Quarto project in `analysis/`. The R package environment is managed by `renv`. Python through `uv` is used only if a task needs it.
- One function per estimand, in `analysis/R/`. Tests use `testthat` and cover at least:
  - the overall algorithm and domain algorithms, including the validation gate in section 7.3
  - the bootstrap resampler
  - the win-share scoring, with hand-built cells
  - a reproduction of the baseline-Sonnet D1 to D5 count of 395/510 from `no-kit-sonnet-5.5/accuracy.md`
- From `analysis/`, run `Rscript run.R` to rebuild all numerical CSVs, figures, Word documents and HTML views. Run `Rscript -e 'testthat::test_dir("tests/testthat")'` and `Rscript verify-output.R` for verification. Quarto renders the final CSV and Word artifacts; it does not rerun the analysis itself.
- Code and adjudication sheets go to a public repository with a Zenodo DOI. Trial PDFs are not redistributed; DOIs and the `FILES.csv` hashes are given instead.

