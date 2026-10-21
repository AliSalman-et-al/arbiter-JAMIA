# WP-A (Round 16): analysis, displays and plan labels

Baseline: commit `fee1225` plus the uncommitted edits to `GLOSSARY.md` and `docs/round16/`. You own `analysis/`, `ANALYSIS-PLAN.md`, the deviations record and `docs/round16/release-manifest.md`. Do not edit `docs/manuscript/`; WP-M does that next. Do not commit.

## Read first

1. `docs/round16/BRIEF.md`. This is the specification. Its §3, §4, §6, §8, §9 and §12 are your scope.
2. `GLOSSARY.md`, which now uses Expert 1 / Expert 2.
3. `docs/round15/BRIEF.md` and the Round 15 WP-A briefs. Their encoding, bootstrap, tests and verification standards still apply.

## Tasks

### 1. New exploratory analyses (BRIEF §6)

- **Severity distributions.** Count Low, Some concerns and High (n/N, %) on 510 cells for each of five sources: Published, ARBITER, Unassisted, Expert 1 and Expert 2. Add Overall for the same five sources, with denominators stated: 81 trials for Published, 102 for the others. Write `severity-distribution.csv`.
- **Some concerns or High against each expert.** Treat Some concerns or High as one class. Against each expert's independent rating, compute sensitivity and specificity for ARBITER, Unassisted and Published. Add the paired ARBITER − Unassisted differences. Use the stratified trial-cluster bootstrap: B = 10,000, seed 20261018, percentile intervals. Report D1–D5 pooled, and per domain in the supplement. Write `independent-binary.csv` and `independent-binary-differences.csv`.
- **Tests.** Add tests for both analyses, including hand-checked counts on a small fixture.

### 2. Tables (BRIEF §8)

- **Table 1, benchmark and reference characteristics.** Include:
  - trials, meta-analyses and specialties;
  - available document types (counts of trials with protocol, SAP, registry and supplement, from existing benchmark data);
  - severity distributions for the five sources;
  - expert-to-expert exact agreement and weighted κ, overall and for the lowest domain (D3).
- **Table 2, agreement with each reference.**
  - **Layout.**
    - **Columns:** Expert 1, Expert 2 and Published.
    - **Rows:** ARBITER, Unassisted and Published. The Published row is blank under the Published column.
    - **Expert-to-expert row** at the foot.
  - **Cell contents.** Exact agreement n/N (%) and weighted κ.
  - **Paired-difference row.** Below each block, give the ARBITER − Unassisted exact-agreement difference and its 95% CI.
  - **Blocks.** Two: D1–D5 (510 cells), and Overall (the 81 trials with a published Overall label, used for every source).
  - **Sensitivity and specificity.** If Table 2 stays readable, add sensitivity and specificity for Some concerns or High as a compact sub-block. If it does not, put them in a new eTable and say so in your report.
  - **What moves out.** The mean-of-experts row, the agreed reference, All-Low and AC2 go to eTables. The current long eTable stays.
- **Table 3, rule conformance, evidence checks, time and cost.** Merge the current Table 2 (the rule audit) with the process metrics: runtime and API list-price equivalent, as median [IQR] and paired mean differences.
- **Table 4** is unchanged.
- **Notes and format.** Each table gets footnotes that define its denominators. Write each to Word and CSV as before.

### 3. Figures (BRIEF §9)

- **Figures 1 and 2** stay byte-identical in every format.
- **Figure 3, two-branch flow.**
  - **Exclusion side box:** "3 trials excluded: unsupported designs".
  - **Left branch:** "102 trials × D1–D5 = 510 cells, each rated independently by two blinded experts" leads to "Independent-rating comparison: 510 cells; Overall derived for 102 trials, compared on 81 with a published Overall".
  - **Right branch:** "154 disputed cells (either arm differs from Published)" → "80 where the arms disagreed" → "60 with an agreed forced choice (primary)", with a side note "20 split".
  - **Concordant cells:** note "356 cells with three equal labels (no forced-choice information)".
  - **Layout:** fill the canvas and use even arrows.
- **Figure 4.** Relabel only, "Adjudicator" → "Expert". Make no other change.
- **Figure 5A, two benchmarks.**
  - **Content:** the paired ARBITER − Unassisted difference in exact agreement (percentage points, 95% CI). Rows: D1–D5 pooled (bold or separated), D1 to D5, and Overall (81 trials). Three facets left to right: against Published, against Expert 1, against Expert 2. Use a shared x-axis and a zero line.
  - **Marker:** a neutral dark marker, since this panel shows differences, not sources.
  - **Labels:** the n under each facet.
- **Figure 5B.** Keep it, with labels changed to "Expert".
- **Figure 6, answers or arithmetic.**
  - **Facets:** one per expert.
  - **Rows:**
    - "Domain ratings (510 cells)": three dots, Unassisted, Unassisted after rules-only recomputation and ARBITER.
    - "Signalling answers, collapsed (paired)": two dots, Unassisted and ARBITER.
  - **Values:** agreement % with 95% CI.
  - **Encoding:**
    - ARBITER: blue circle.
    - Unassisted: orange square.
    - Rules-only: an orange open square, or another clearly derived Unassisted marker. State it in the legend.
  - **Legend:** say that recomputation does not change the answers.
- **eFigures.** The current Figure 5A becomes an eFigure: per-domain absolute agreement, with the expert-to-expert reference drawn as a short horizontal tick for each domain, not a joined line. The current Figure 6 (the per-question signalling forest) also becomes an eFigure. Keep the existing eFigures.
- **Common to all figures.** No in-image title. Use the Round 15 encoding everywhere: ARBITER blue circle, Unassisted orange square, Published dark-grey triangle, always in that order.
- **Legends.** Update `figure-legends.md` with legend skeletons: what the display shows, its population, the measure, the interval type and abbreviations. Do not state interpretation as fact.

### 4. Labels everywhere (BRIEF §3)

"Adjudicator 1/2" becomes "Expert 1/2" in all outputs: tables, figures (not Figures 1 and 2), legends, `results-sentences.md`, the supplement, `results.html`, `supplement.html`, the TRIPOD-LLM map and `round16-report.md`. Use "adjudication" only for the forced-choice step. Leave code identifiers and data-file names unchanged.

### 5. Outcome labels (BRIEF §4)

- **Mark as prespecified:** the primary endpoint; independent-rating agreement with each source; expert-to-expert agreement; signalling-answer agreement; published-label agreement; the rule audit; time and cost.
- **Mark as exploratory:** derived Overall against the experts; direction of disagreement; rules-only recomputation; strictness strata; the §1 analyses.
- **Wording.** Remove every "defined after data collection" or "author-defined … after data collection" statement for the prespecified items.
- **Where to change it:** `ANALYSIS-PLAN.md` (§4–7), `results-sentences.md`, legends, the supplement and the reports.
- **Dated note.** In the plan and the deviations record, add: "2026-10-21: prespecified comparisons from the 2026-10-18 plan applied to all 510 cells because the experts assessed every cell; additions listed as exploratory."
- **Earlier adjudication.** Do not describe it in any reader-facing output. Leave the historical text in old plan versions in git untouched.

### 6. Results sentences

Rewrite `results-sentences.md` in the BRIEF §7 order. Each paragraph leads with the pattern and follows with the numbers, and every number is traceable. Use the BRIEF §1 wording for the published-label benchmark: "no clear difference". Use the BRIEF §6 yardstick wording for κ relative to expert-to-expert agreement. Number displays in first-citation order, following BRIEF §7. Renumber the supplement in the order the Results cite it, and save the old-to-new mapping in `analysis/output/manuscript/qa/round16-display-numbering.csv`.

### 7. Release manifest (BRIEF §12)

Write `docs/round16/release-manifest.md`, listing what a clean-snapshot release should contain:

- code;
- derived data;
- the two expert sheets;
- prompts;
- the supplement, results.html and supplement.html;
- the plan, including the dated 2026-10-18 version extracted from commit `e1c0ccf`;
- the reproduction instructions.

It should also list what it excludes: trial PDFs, `analysis/archive/` and any files from the earlier adjudication. List only paths and reasons. Do not create the release.

### 8. Verify

Run each of the following:

- the full test suite;
- the number trace;
- the invariance check (every Round 15 estimate unchanged; diff the unchanged-analysis CSVs against `fee1225`);
- the byte check on Figures 1 and 2;
- visual QA of every new or changed figure and table page (render them and look at them);
- the leak scan (Haiku, the earlier adjudication's terms A/Z, "composite reference", "vindicated", "decisive question", and every banned word);
- a rebuild of results.html, supplement.html and Supplement.docx.

## Final message

Report:

- Tables 1–3 as text;
- the new estimates: severity distributions, and sensitivity and specificity with their differences;
- a description of each figure, and of anything that departs from this brief, with the reason;
- the full new `results-sentences.md`;
- the numbering map;
- every verification result;
- any conflict you found between the brief and the data.
