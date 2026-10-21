# ARBITER JAMIA analysis plan

Status: the primary estimand and bootstrap were fixed on 2026-10-18. Independent-rating comparisons, expert reliability, signalling-answer agreement, published-label agreement, the rule audit, time and cost were also prespecified in the 2026-10-18 plan. Terms follow `GLOSSARY.md`.

## 1. Framing

ARBITER is reported as a system and auditability paper. The manuscript reports the two Sonnet arms only; see section 7. The primary quantitative evidence is forced choice on discordant cells, supported by independent blinded expert ratings of every domain. Agreement with meta labels is reported in full as evidence that published RoB 2 labels are a noisy reference. It is not the headline.

Only the primary endpoint (section 4) is confirmatory. Every other analysis is secondary or exploratory. Results are reported as estimates with 95% CIs. There are no p-values and no multiplicity correction.

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

- Analysis set: 102 trials. atwine-2020, haney-2004 and herrmann-2016 are excluded from every arm and every analysis because ARBITER does not support their design. The flow diagram reports them. No analysis uses the 105-trial set.
- D1 to D5 cells: 102 × 5 = 510 per arm.
- Overall cells: trials with a meta Overall label (81 in the analysis set).
- All 510 domain cells were independently rated by both experts. Disputed and discordant subsets are recomputed from arm labels.
- Agreed reference: equal independent ratings, with no substitution of published labels.
- Missing model labels remain missing and count as disagreement.

## 4. Primary endpoint

The prespecified estimand is the share of discordant domain cells where the experts preferred ARBITER's rating. The 2026-10-18 plan specified independent comparisons on disputed cells. These comparisons are applied to all cells because the experts assessed every cell. The estimand, label-based credit and bootstrap retain the prespecified mechanics.

A discordant cell has different ARBITER and Unassisted labels. The primary population retains only cells where the two experts made the same forced choice. Credit goes to every source whose label equals that choice. The selected reviewer letter is ignored. Concordant cells, where all three labels match, are excluded from preference analyses. Neither source receives credit when the choice matches neither arm.

Report the primary share, numerator, denominator and 95% CI. Sensitivities use each expert separately on all discordant cells, and count every split choice as an ARBITER loss without assigning an Unassisted win. Exploratory strata distinguish ARBITER stricter from ARBITER more lenient than Unassisted. Severity is Low < Some concerns < High. These preference estimates are not measures of accuracy.

All intervals use 10,000 trial-cluster bootstrap replicates stratified by source meta-analysis, seed 20261018. Resampling retains each stratum's trial count and all cells belonging to each sampled trial. Percentile intervals use quantile type 7. Paired contrasts and expert means use the same weights. Undefined replicates are excluded, their count is retained, and no p-values or multiplicity adjustments are used.

## 5. Prespecified secondary and exploratory comparisons

### 5.1 Independent-rating agreement (prespecified domains; exploratory derived Overall)

For new expert-reference Overall comparisons, ARBITER and Unassisted use all 102 trials. Published uses only the 81 observed Overall labels: 21 published reviews gave no Overall label, and missing labels never count as disagreements. Also report ARBITER and Unassisted on the same 81 trials. Every paired Overall contrast involving Published uses those 81 trials. The agreed reference restricts each population further to equal expert ratings. Print n on every row and explain the 21 absent labels and population denominators in every relevant footnote. This author clarification was supplied on 2026-10-21; D1–D5 and unchanged analyses are unaffected.


Compare ARBITER, Unassisted and Published labels with each expert's frozen independent rating across all domain cells. Report exact agreement and linearly weighted Cohen's κ, pooled across D1–D5, by domain and for derived Overall. Report each expert separately, the arithmetic mean of expert-specific estimates, and the agreed-reference sensitivity restricted to equal independent ratings. The mean of κ values is not a pooled κ.

Report paired ARBITER minus Unassisted, ARBITER minus Published and Unassisted minus Published differences with bootstrap CIs. Each contrast uses the same reference and trial resample. Exact-agreement differences are percentage points. Report expert-to-expert exact agreement and weighted κ as a reference line, with unweighted κ and confusion matrices in the supplement. The reference line describes observed expert reliability, not a mathematical upper bound.

Overall is derived from each expert's five independent domain ratings as their worst domain. RoB 2 permits escalation to High with multiple Some concerns domains, but does not require it. No optional escalation is imposed. Validate every available column of file 2's Overall sheet and export every difference, including absent published Overall labels and permitted escalations. Published and model Overall labels stay as reported in agreement analyses.

### 5.2 Direction of disagreement (exploratory)

For each arm, select cells where its label is stricter, or more lenient, than Published. For each independent expert separately, report the share whose rating equals the arm, equals Published or equals neither. These exhaustive categories use the entire directional population, without filtering on forced-choice consensus. Report numerators, denominators and bootstrap CIs.

### 5.3 Signalling-question agreement (prespecified)

Map ARBITER semantic IDs through `question-map.csv` onto official RoB 2 question numbers. Unassisted and expert numeric IDs already use that numbering. Compare each arm against each expert's independent answers, by question, domain and overall. Five-level exact agreement distinguishes Y, PY, N, PN and NI. Collapsed agreement combines Y/PY and N/PN, leaving NI separate.

Only explicit answers to the same trial, domain, question and component are evaluable. Match components by their explicit names when both sides provide components. Never broadcast a scalar across outcomes. NA, inactive or missing answers, unmatched components and unresolved text are not evaluable. Export their counts and every parse issue. Paired ARBITER minus Unassisted differences retain only components evaluable in both arms and receive trial-cluster CIs. The expanded parse preserves raw text, phase, workbook row, normalised retained/changed/mixed status and stated transitions.

### 5.4 Published-label agreement and rule consistency

The published-label analysis is unchanged: weighted κ, AC2, exact agreement, sensitivity for Some concerns or High, specificity, paired differences and an All-Low rule. D1–D5 use all domain cells. Overall uses only trials with a published Overall label. All-Low has no variance, so κ, AC2 and sensitivity are suppressed by the reporting rule. Unweighted κ is supplementary. Missing predictions fail exact and binary agreement. For ordinal coefficients, they receive maximal disagreement, as in the parent analysis.

Apply the official 22 August 2019 RoB 2 domain algorithms to each arm's own answers, with the effect-of-assignment D2 algorithm. Required missing or NA answers make a nonempty path invalid. Separate ratings contradicting their answers, invalid paths and wholly unevaluable cells. Resolve invalid paths recursively as N/PN and NI in the existing sensitivity. ARBITER proposals must reproduce the official algorithms for every domain, adopted labels must match the exported labels and every override must be recorded. Stop if the gate fails. No ARBITER domain overrides were recorded in these runs.

For Overall, distinguish the worst-domain rule, permitted escalation to High when at least two domains have Some concerns, and violations. Do not count permitted escalation as a violation. Published labels have no signalling answers and receive only the Overall check.

### 5.5 Audit runtime and cost

Keep the parent bundle, quotation, runtime, cost and prior-work numbers unchanged. Reports read committed derived metrics. Explicit extraction commands require the raw inputs and stop if they are absent. Check active-answer coverage, text and visual source binding, content hashes, domain lineage and archived verification receipts. Quotation occurrence is described as "found in the stored source". Structural verification does not establish clinical correctness or whether a quotation supports an answer.

Runtime is the sum of harness wall time across trial turns. Report per-trial medians and IQRs and paired mean differences. Tokens include input, cache creation, cache read, output and thinking, with thinking already included in output pricing. Cost is a frozen-rate API list-price equivalent, not subscription expenditure. Deduplicate assistant requests by message identity. Reconcile request, terminal and side-call usage. Retain signed reconciliation gaps. Primary side-call writes use one-hour rates, with five-minute writes as a sensitivity. The frozen USD rates per million tokens are input 2.00, one-hour cache write 4.00, five-minute write 2.50, cache read 0.10 and output 10.00. Preserve the parent reconstruction bounds, long-context handling and diagnostics exactly.

## 6. Exploratory and descriptive analyses

Rules-only recomputation replaces Unassisted algorithm violations with the output implied by its own answers. Invalid paths and missing ratings remain unchanged. Keep the original discordant population fixed even when repairs create ties. Score preference by label after repair, so both arms may receive credit on a new tie. Report all changed cells, how many were originally discordant, primary and sensitivity shares and independent-rating agreement against the new references. This is an exploratory analysis of the arithmetic contribution.

Forced-choice summaries on all disputed cells are descriptive. Credit every matching source, so shares may sum to more than 100%. Revised ratings and signalling-answer retention or change are descriptive and cannot replace the independent reference. Count retained, changed and mixed statuses at the original question-row level and preserve component details in derived data. Do not add source-based sensitivities when experts consult additional sources.

Only the primary endpoint is confirmatory. Independent domain comparisons, expert-to-expert agreement, signalling-answer agreement, published-label agreement, the rule audit, time and cost are prespecified secondary analyses. Derived Overall against the experts, direction of disagreement, rules-only recomputation, strictness strata, severity distributions and binary comparisons against experts are exploratory. Unchanged analyses retain their parent methods.

2026-10-21: prespecified comparisons from the 2026-10-18 plan applied to all 510 cells because the experts assessed every cell; additions listed as exploratory.

Severity distributions count Low, Some concerns and High for Published, ARBITER, Unassisted, Expert 1 and Expert 2 on 510 domain cells, with Overall denominators of 81 for Published and 102 otherwise. Binary sensitivity and specificity treat Some concerns or High as positive against each independent expert. Report pooled and per-domain results and paired ARBITER − Unassisted differences with the shared stratified trial-cluster bootstrap.

## 7. Outputs and production

The Results sequence is benchmark and reference, primary endpoint, independent-rating agreement, strictness, published-label benchmark, signalling answers and rules-only recomputation, process integrity, then time and cost. Each paragraph leads with the pattern and gives traceable numbers.

Figures 1 and 2 are byte-protected against fee1225. Figure 3 shows the independent-rating and forced-choice branches. Figure 4 retains the primary forest with Expert labels. Figure 5A shows paired exact-agreement differences against Published and each expert on 510 domain cells and the same 81 Overall trials; Figure 5B retains directional bars. Figure 6 compares domain agreement before and after rules-only recomputation with paired collapsed signalling agreement. Absolute domain agreement and question-level signalling differences move to eFigures. No figure has an internal title.

Table 1 describes the benchmark, available documents, severity distributions and expert reliability. Table 2 compares each source against each expert and Published, with matched Overall denominators and paired differences. Binary comparisons, mean-of-experts, agreed-reference, All-Low and AC2 results appear in eTables. Table 3 combines rule and evidence checks with runtime and cost. Table 4 is unchanged. Display numbering follows Results citation order; the generated mapping records Round 15 to Round 16 identifiers.

Use the glossary reader labels. Tables use Arial 9 pt and the established three-line style, with abbreviations and denominators defined. Figure colours retain JAMA roles: ARBITER #00A1D5, Unassisted #DF8F44, Published #374E55 and light grey for unavailable values. Use Fira Sans for plots and Fira Sans Condensed for diagrams. Figures are 84 or 174 mm wide, with text at least 7 pt, bold capital panel tags and no internal titles. Export vector PDF and 600-dpi LZW TIFF. Render each document page and each figure to PNG, inspect for clipping and readability, and check figures in greyscale and colour-vision simulations.

Titles state the finding. Legends describe the marks and method concisely and include alt text. Report coefficients to two decimals, proportions as n/N and one decimal percent, costs to two decimals and minutes to one decimal. Use an en dash for positive CI bounds and "to" with a true minus sign for negative bounds. Do not use "first", "over-flagging", or "accuracy" for primary preference. Use "assistant", "content-hashed" and "found in the stored source" as applicable. Strictness claims apply to RoB 2 only.

Limitations include two experts with modest agreement, especially in D3; access to extra sources; possible anchoring by offered labels; derived rather than directly rated Overall; system-level attribution; no structured-prompt comparator; a single run; possible training exposure; unassessed quotation support; outcome mismatch; and the De Waal input error.

## 8. Reporting

- Follow TRIPOD-LLM, plus GRRAS for the agreement and reliability parts.
- Methods state the model IDs, the effort setting, the run dates and the ARBITER commit. Take these from the run READMEs and `meta.json`:
  - Model `claude-sonnet-5-5`, effort medium
  - Claude Code 2.1.278, with an isolated home (`claude-home-settings.json`)
  - ARBITER 1.0.0 (public commit `2f549ae`), the code used for the runs
- Call the tool ARBITER and the skill `/arbiter-assess` throughout, including in the analysis code, figures and tables. rob2-kit is an earlier name for the same software. File names and identifiers in the data, such as `rob2kit_*` columns, `/rob2-assess` in the logs and `kit_commit`, are internal and are never shown in outputs. The version cited in Methods must resolve in the public ARBITER repository or its Zenodo archive.
- The baseline prompt is the same minimal prompt without the skill, followed by the output-format instruction in `no-kit-*/nokit-format.txt`. Methods must quote it, and must not call the two prompts identical.
- In the ARBITER arms, the harness approved the proposed result unchanged and replied "Continue." at most twice per phase (see the kit READMEs). Report this as part of the protocol.
- Each arm ran each trial once. Report this as a limitation: run-to-run variability is not estimated.

## 9. Implementation

- Quarto project in `analysis/`. The R package environment is managed by `renv`. Python through `uv` is used only if a task needs it.
- One function per estimand, in `analysis/R/`. Tests use `testthat` and cover at least:
  - the overall algorithm and domain algorithms, including the validation gate in section 5.4
  - the bootstrap resampler
  - the win-share scoring, with hand-built cells
  - a reproduction of the baseline-Sonnet D1 to D5 count of 395/510 from `no-kit-sonnet-5.5/accuracy.md`
- From `analysis/`, run `Rscript run.R` to rebuild all numerical CSVs, figures, Word documents and HTML views. Run `Rscript -e 'testthat::test_dir("tests/testthat")'` and `Rscript verify-output.R` for verification. Quarto renders the final CSV and Word artifacts; it does not rerun the analysis itself.
- Code and adjudication sheets go to a public repository with a Zenodo DOI. Trial PDFs are not redistributed; DOIs and the `FILES.csv` hashes are given instead.

