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
- **Validation gate:** on the ARBITER arms, the algorithm must reproduce the reported domain labels. Do not adjust the algorithm to fit. The gate passes if ARBITER-Sonnet reproduces 100% and any ARBITER-Haiku mismatch is isolated: a single cell, with answers that the official guidance and the ARBITER source both map to a different label. Each such mismatch is reported in Table 3 and the supplement as an ARBITER consistency exception, and flagged for the authors to check against the run bundle. A systematic pattern of mismatches means the algorithm is wrong, and the analysis stops.
  - Amended 2026-10-18 after the first run. ARBITER-Sonnet reproduced 510/510 labels and ARBITER-Haiku 504/505. The exception is hill-2017 D1: answers 1.1=NI, 1.2=PY, 1.3=N map to Low, but the reported label is Some concerns.
  - Resolved 2026-10-18 from the run bundles. The exception is a recorded model override, not an export error. ARBITER's server proposes the algorithm judgement. The assessing model may adopt a different judgement only through a reasoned override, which the bundle records with its rationale and evidence (`decision.proposed`, `decision.adopted`, `decision.adjudication`). Across the analysis set, the bundles record 0 overrides in 510 ARBITER-Sonnet domains and 1 in 505 ARBITER-Haiku domains (hill-2017 D1, Low → Some concerns). The reported labels are kept as the system produced them.
  - Table 3 therefore reports two rates for each ARBITER arm. The first is agreement of the proposed judgement with the official algorithm, which should be 100%; check it from the bundles. The second is the override rate, with every override listed in the supplement with its recorded rationale. Do not describe ARBITER judgements as algorithm-determined "by construction". Describe them as algorithm-proposed, with any departure recorded and auditable. For the baseline arms, an algorithm violation is an unrecorded departure, because no rationale or trace exists.
- Report the violation rate per arm and per domain. Meta labels have no signalling answers, so the meta labels get the overall check only.
- Amended 2026-10-18: each baseline domain cell gets one of three statuses:
  - **Consistent:** the reported label equals the algorithm's output.
  - **Violation:** the answer path is complete, and the reported label differs from the algorithm's output.
  - **Invalid answer path:** a question that the RoB 2 path requires was answered NA or not answered, so the algorithm cannot reach a judgement. For example, 4.3=NA after 4.1=N and 4.2=N.

  Report each rate, and their sum as "departure from RoB 2 structure". Run a sensitivity analysis that resolves each invalid NA first as N/PN and then as NI, and report the violation counts under each. For the ARBITER arms, confirm from the bundles that every required question was answered.

### 5.5 Reliability of the reference standard (Table 4)

Report on the 154 disputed cells:

- Agreement between adjudicators A and Z on independent judgements and on preferred judgements: weighted κ, AC2 and raw agreement.
- For each adjudicator, agreement of the independent judgement with the meta label, the ARBITER-Sonnet label and the baseline-Sonnet label.
- Direction of meta-label error: a 3×3 table of meta label against consensus preferred judgement, summarised as the share where the meta label is less severe, equal or more severe.

### 5.6 Error localisation by signalling question (Table 4 or supplement)

Amended 2026-10-18. This replaces the human-coded taxonomy. No human or LLM coding is used. The adjudicators' independent signalling answers serve as the reference, because each adjudicator wrote them before seeing the three blinded labels.

**Population**

- Consensus cells where a Sonnet arm lost, meaning its label differs from the consensus preferred judgement. The losing sources are ARBITER-Sonnet and Baseline-Sonnet. Haiku was not adjudicated and is excluded.
- Meta-label losses cannot be localised, because meta-analyses publish no signalling answers. Report only their count, and point to section 5.5 for their direction.

**Reference answers**

- Parse `signalling_answers_independent` for each adjudicator.
- An adjudicator's answers are usable for a cell only if that adjudicator's independent judgement (`own`) equals the consensus preferred judgement.
- **Primary analysis:** cells where both adjudicators' answers are usable.
- **Sensitivity analysis:** cells where at least one adjudicator's answers are usable.
- Report any answers that cannot be parsed, by cell.

**Answer collapse**

Collapse Y and PY to Y, and N and PN to N. Keep NI and NA as separate values.

**Question classification**

- **Discordant question:** the loser's collapsed answer differs from the reference answer, and every usable adjudicator gives that same reference answer.
- **Adjudicators differ:** the usable adjudicators give different answers to the question. Report this separately; it is not an error.
- **Decisive question:** a discordant question where substituting the reference answer into the loser's answers, with nothing else changed, changes the official algorithm's output.

**Cell classification**

Assign each losing cell to exactly one class, checking the classes in this order:

1. **Judgement departs from own answers.** The loser's label differs from the algorithm applied to its own answers. This is a violation, an invalid path, or a recorded override for ARBITER.
2. **Single decisive question.** One question is decisive. Name the question.
3. **Several decisive questions.** Two or more questions are each decisive.
4. **Jointly decisive.** No single substitution changes the output, but substituting all the discordant questions together reaches the preferred judgement.
5. **Answers agree, judgement differs.** There are no discordant questions. Also flag cells where the adjudicators' own judgement differs from the algorithm applied to their own answers.
6. **Not attributable.** Anything else.

**Outputs**

- Counts by losing source and class.
- Decisive-question frequencies by losing source, domain and question number, labelled with the RoB 2 question text.
- A CSV of 3 to 5 candidate cells per losing source with the adjudicators' explanation text, for authors to quote in the Discussion.

Use the domain algorithms already validated in section 5.4.

### 5.7 Grounding metric

Report the share of signalling answers whose justification contains a verbatim quotation, for each Sonnet arm. A quotation is text inside straight or curly double quotes with at least 5 words. Only answers marked `active` count. Report this as descriptive only. It is not a measure of whether the quotes were verified.

Amended 2026-10-18: this metric goes to the supplement only. ARBITER stores cited passages as evidence records in the bundle, not as quotations inside its justification text, so the share of quoted justifications understates its grounding. The main grounding measures are evidence coverage and bundle verification (section 5.8).

### 5.8 Process and audit metrics (added 2026-10-18; Table 5 or supplement)

The sources are the run logs (`<arm>/logs/<slug>/meta.json` and `turn*.jsonl`), `continues.csv` and, for the ARBITER arms, the bundles (`<arm>/bundles/<slug>.rob2.zip`, containing `canonical.json` and `verification.json`). The raw logs are about 1.1 GB and are not committed. A script, `analysis/R/extract-run-metrics.R` or a uv Python script if streaming JSON in R is impractical, writes one committed derived CSV per arm to `analysis/data-derived/`. The reports read only these derived CSVs. The script must be re-runnable, and it must stop with an error if the logs are absent rather than writing empty files.

Per trial and arm:

- **Wall-clock time:** sum of the `seconds` values across turns.
- **Tokens:** input, cache creation, cache read, output and thinking tokens, summed across turns.
- **Cost:** reconstructed API list-price cost (amended 2026-10-18). The harness cost is unusable. Claude Code logged `unrecognized_model` for both models and marks its cost basis as unknown. Report the harness figure in the supplement only.
  - **Rates** are in USD per million tokens, from https://platform.claude.com/docs/en/about-claude/pricing, fetched 2026-10-18:

    | Model | Input | 1-hour cache write | 5-minute cache write | Cache read | Output |
    |---|---|---|---|---|---|
    | Sonnet 5.5 | 2.00 | 4.00 | 2.50 | 0.10 | 10.00 |
    | Haiku 5.5, prompt ≤100,000 tokens | 0.10 | 0.20 | 0.125 | 0.01 | 0.50 |
    | Haiku 5.5, prompt >100,000 tokens | 0.50 | 1.00 | 0.625 | 0.05 | 2.50 |

    Routing was `global` in every run, so no 1.1× geography multiplier applies. Thinking tokens are output tokens.
  - **Main-thread requests** are the `assistant` events in each `turn*.jsonl`, deduplicated by `message.id`. The input-side counts per request are final, because they are fixed when the request starts. These are input, cache creation split into 5-minute and 1-hour writes, and cache read.
    - A Haiku request's prompt length is input + cache creation + cache read. It pays the >100K rates if that sum exceeds 100,000.
    - Any input-side gap between the summed requests and `result.usage` is unattributed. Price it at the ≤100K rates for the lower bound and the >100K rates for the upper bound, and allocate it by request share for the point estimate.
  - **Main-thread output** is `result.usage.output_tokens`. Output per request is not recoverable, because the `assistant` events hold streaming snapshots. For Haiku, price output three ways:
    - lower bound: all at the ≤100K rate
    - upper bound: all at the >100K rate
    - point estimate: split in proportion to the share of main-thread requests in each tier
  - **Side calls** are `modelUsage` minus `result.usage`, field by field. They are Claude Code's auto-compactions, every one recorded with a prompt of 161,797 to 231,976 tokens, so Haiku side calls are priced at the >100K rates. Side-call cache writes are priced as 1-hour writes, because every observed main-thread write is 1-hour; give a sensitivity analysis at 5-minute. If a turn has side-call tokens but no `compact_boundary` event, flag it, and price its side calls with the lower and upper bounds.
  - Sonnet has a single rate card, so its three estimates coincide.
  - **Outputs:** per trial and arm, the point estimate, lower and upper bounds and harness cost, plus the token components and tier counts, in `analysis/data-derived/`. Table 5 uses the point estimate, with the Haiku bounds in a footnote. Call it an API list-price equivalent, not what was paid.
- **Turns and agent steps:** turns, and `num_turns` per turn.
- **Continue prompts:** the number of "Continue." replies, from `continues.csv` and `meta.json`.
- **Approval:** whether the result-approval step occurred (ARBITER arms).

Report the median [IQR] and the total per arm, and the paired ARBITER minus baseline difference for Sonnet, with a bootstrap CI as in section 4.

From the ARBITER bundles, per arm:

- The share of active signalling answers with at least one evidence basis. Also report the distribution of evidence bases per answer.
- Bundle verification outcome, from `verification.json`, as the share of bundles that pass.
- The proposed-judgement check and override list required by section 5.4.

Baseline arms have no evidence trace. Report them as "not available" rather than 0.

## 6. Exploratory analyses

- Signalling-answer agreement with each adjudicator's independent answers, on disputed domains only (`signalling_answers_independent`). Report it per question, collapsed to Y/PY, N/PN and NI/NA.
- A forest plot by meta-analysis: weighted κ against the meta label per arm. Descriptive, with no tests (supplement).

## 7. Outputs

Revised 2026-10-18 for JAMIA's Research and Applications limits: at most 4 tables and 6 figures, tables as editable Word tables, figures as separate files with legends and alt text. Supplementary material is unlimited. Every output must be ready for the manuscript as produced.

### Story

Published RoB 2 labels are a weak reference. An unassisted model matches them about as well as ARBITER does. But ARBITER follows the RoB 2 rules, ties every answer to a cited passage, and is the arm blinded experts prefer when the two arms disagree, at a known cost per trial. Figures follow the argument: Action (Fig 1–3), Challenge (Fig 4), Resolution (Fig 5–6). Each main item serves one part of this story. Items that do not serve it go to the supplement. No item repeats another.

### Main text

| Item | Content |
|---|---|
| Fig 1 | "How ARBITER works" (revised 2026-10-18, round 11, final design). Double column, ≤110 mm tall. Swimlanes for Reviewer, LLM agent, ARBITER server ("deterministic; no model calls") and Bundle; real MCP tool names in monospace on agent↔server arrows; phases Capture → Propose & approve → Assess each domain → Review & export; Reviewer approval via `arbiter review`. No title text inside the image. No red rejection arrow or label. The legend states: the server saves nothing from an incomplete or unbound answer; across the 102 trials it rejected 53 of 637 `save_domain_judgment` calls (32 evidence/citation structure, 21 other input errors), and every affected domain was saved after resubmission. |
| Fig 2 | "One trial, under the hood" (redesigned 2026-10-18 after studying the book; grammar in `analysis/figure1/STYLE-REFERENCE.md`). Full page, 174 mm wide, ≤230 mm tall. AVATAR, ARBITER-Sonnet bundle and log. **A, under the hood, one answer (D5, question 5.1):** sequence diagram with an LLM agent lifeline (lavender) and an ARBITER server lifeline (mint), with the source documents (7 captured and hashed) attached to the server side. Numbered badges ❶–❻ with verb-led titles and real MCP tool names in monospace pills: get_domain_context → questions and guidance; read_pages → tabbed evidence tags with verbatim quotes (report "Prespecified secondary end points … Time to death"; registry "Primary outcome 1: all cause death, MACE …"); agent reasoning box (verbatim justification excerpt); save_domain_judgment payload (5.1 No information, cited evidence handles); server check (✓ spans match hashed sources) and official algorithm (5.1 NI · 5.2 PN · 5.3 PN → Some concerns, returned as the proposed judgement); review_trial · finalize_batch → bundle verified. At most three italic annotations on curved arrows. **B, same machinery, every domain:** D1–D5 rows, each with a tabbed evidence tag holding one short verbatim phrase, the full answer-chip pattern (not-asked hatched) and the judgement pill; then Overall. **C, same trial, D5, with and without ARBITER:** trajectory rows with agent glyphs. ARBITER: tool-call blocks with real counts from the log → Output Some concerns → Adjudicators ✓. Unassisted: one Thought block with the verbatim "registered 5-year time frame" claim tagged "no citation" → Low → ✗. Note "D4: 4.3 skipped → invalid answer path". The Outcome header has a person glyph ("Adjudicators' preferred D5 judgement"); Published Low is shown as a note. Full trace in eTable 31. |
| Fig 3 | Study flow, CONSORT style, full width, centred. Adds an arms box: 4 arms each assessed 102 trials; Sonnet 5.5 ARBITER and Unassisted (main), Haiku 5.5 (supplement). |
| Fig 4 | "Published labels are a weak reference" (Challenge). **A:** weighted κ against Published by domain and pooled, ARBITER and Unassisted, 95% CIs. **B:** one 100% stacked bar per domain plus All: Published less severe / equal / more severe than the consensus preferred judgement, with counts (D5 30/41 and D3 19/24 less severe). |
| Fig 5 | Primary endpoint (Resolution). **A:** forest plot of the ARBITER win share with 95% CI for: both adjudicators (consensus), Adjudicator 1, Adjudicator 2, split cells counted against ARBITER; dashed 50% line "no preference"; right-hand text column with ARBITER / Unassisted / neither counts. **B:** vindicated disagreements: for each source (ARBITER, Unassisted), stacked bars split by direction of disagreement with Published (more / less severe): vindicated / Published upheld / other label / adjudicators split. Consensus counts: ARBITER 95/105 vindicated (more severe 73/77, less severe 22/28); Unassisted 67/97 (48/59, 19/38). The old tile matrix moves to the supplement. |
| Fig 6 | Decisive signalling questions (section 5.6, primary population). Paired horizontal bars, ARBITER above Unassisted. Each domain facet adds a grey row "No single decisive question" so the bars reconcile with the facet n. Tighter vertical spacing. |
| Table 1 | Benchmark set. One row per meta-analysis, sorted by specialty. Columns: specialty; journal and year; topic; trials in the analysis set; published D1–D5 labels pooled as Low / Some concerns / High counts; Overall labels given (yes/no). A totals row closes the table. Specialty, journal, year and topic come from `analysis/data-curated/meta-analyses.csv`. |
| Table 2 | Agreement. Block 1: against published labels, for ARBITER, Unassisted and the All-Low rule, on D1–D5 pooled and on Overall. Block 2: against the composite reference, D1–D5. Block 3: the paired ARBITER − Unassisted differences. Denominators go in headers or block labels; cells read "66.3 (57.3–74.7)" (no n/N in cells; full n/N in eTable). AC2 kept. Footnotes: both composite caveats; Overall judgements were not adjudicated and Published is lenient (cross-reference Fig 4). |
| Table 3 | RoB 2 rule consistency and audit, for ARBITER and Unassisted (sections 5.4 and 5.8): consistent; violation; invalid answer path; departure; recorded overrides; Overall consistency and permitted escalation; evidence coverage; evidence binding (text spans and visual, separately); bundle verification. Drop "All evidence bound", "Proposed judgement matches algorithm" and the Overall violation row. CIs inside the cells, no separate CI column. ARBITER structural zeros carry a footnote mark: guaranteed by design. |
| Table 4 | Reliability of the reference standard (section 5.5): Adjudicator 1 vs Adjudicator 2 on independent and on preferred judgements, and each adjudicator's independent judgement against the Published, ARBITER and Unassisted labels, on disputed cells only. The footnote states the selection. |

Results text gives the time and cost per trial (median [IQR]) and the paired differences. Their table is in the supplement.

### Supplement

One `Supplement.docx`, built by the pipeline, with eTables and eFigures numbered in the order they are cited. Each has a caption and footnotes. It holds:

- a short methods appendix: the RoB 2 algorithms and validation; the API list-price reconstruction; the error-localisation rules; the evidence-binding criteria
- Table 1 per domain
- process metrics (former Table 5), Sonnet and Haiku
- the Haiku arms on every analysis except the adjudication analyses
- confusion matrices
- per-meta forest plot
- per-adjudicator, split-cell and missing-judgement sensitivity analyses
- error-localisation class counts, both populations, and the decisive-question frequency table
- the recorded override
- grounding by quote syntax
- exploratory signalling-answer agreement
- the prompt template and one filled example
- run provenance
- eFigure: the former Fig 3B tile matrix (all 154 disputed cells by disagreement pattern × preferred label)
- eTable: post-hoc severity-stratified win share (ARBITER more vs less severe than Unassisted: 44/45 and 10/17), recorded in DEVIATIONS.md
- eTable: complete AVATAR trace (all ARBITER answers with full quotes, evidence types, justifications, unknowns, source/page/lines/hash; all Unassisted answers and rationale)

`TRIPOD-LLM.docx` is a separate file: the checklist skeleton, with GRRAS items.

`results.html` is reviewer-facing: it follows the manuscript order (Fig 1–6, Tables 1–4) with legends, plus a short reproduction section and code links, and is published on GitHub Pages and cited in the Data availability statement. `supplement.html` mirrors Supplement.docx.

### Production standards

- **Reader-facing labels:** follow the GLOSSARY table: ARBITER, Unassisted, Published, All-Low rule, Adjudicator 1 and Adjudicator 2. In the supplement, add the model, e.g. "ARBITER (Sonnet 5.5)". Internal names never appear.
- **Tables:** flextable, written to `.docx` with matching HTML. Arial 9 pt. Three-line style: rules above and below the header and at the foot only. Abbreviations defined in a footnote. Save each main table as its own `.docx` (`Table1.docx` … `Table4.docx`).
- **Colours:** ggsci JAMA palette with fixed roles: ARBITER `#00A1D5`, Unassisted `#DF8F44`, Published `#374E55`, split or not applicable light grey. Haiku uses lighter tints of the same hues. Check the result in greyscale and under colour-vision-deficiency simulation.
- **Fonts:** Fira Sans (OFL) in every figure, via `systemfonts` and `ragg`: Fira Sans Condensed for diagram text, Fira Sans for plots. Use Arial throughout if Fira Sans cannot be installed reproducibly.
- **Figures:**
  - Sizes: 84 mm (single column) or 174 mm (double column) wide.
  - Text at least 7 pt at final size.
  - Panel tags in bold capitals (A, B); no titles inside images.
  - Export as vector PDF plus 600-dpi TIFF (LZW).
  - Fig 1 is generated as SVG by a script in the repo, styled after Grootendorst & Alammar's *An Illustrated Guide to AI Agents*: heavy black rounded outlines, pastel lane fills (lavender for the LLM, mint for the server, pale yellow for the bundle), highlighter pills for evidence, and monospace tool calls.
- **Legends:** `analysis/output/figure-legends.md` holds each figure's legend, followed by an "Alt text:" line.
- **Numbers:**
  - κ and AC2 to 2 decimals.
  - Proportions as n/N (x.x%).
  - 95% CIs in parentheses with an en dash ("0.26–0.42"), or "to" when a bound is negative, using a true minus sign ("−0.03 to 0.14").
  - US$ to 2 decimals; minutes to 1 decimal.
  - No p-values. State "95% CI" once, in the column header.

## 8. Reporting

- Follow TRIPOD-LLM, plus GRRAS for the agreement and reliability parts.
- Methods state the model IDs, the effort setting, the run dates and the ARBITER commit. Take these from the run READMEs and `meta.json`:
  - models `claude-sonnet-5-5` and `claude-haiku-5-5`, effort medium
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
- Running `quarto render analysis/` rebuilds every number, figure and table from the CSVs.
- Code and adjudication sheets go to a public repository with a Zenodo DOI. Trial PDFs are not redistributed; DOIs and the `FILES.csv` hashes are given instead.
