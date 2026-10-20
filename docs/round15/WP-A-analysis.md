# WP-A (Round 15): clean analysis rebuild on the full-coverage adjudication

Baseline: the current `main` commit (the parent of this round), plus the uncommitted `GLOSSARY.md` and `docs/round15/` edits.

Read first:

- `docs/round15/BRIEF.md`, which is the specification. It wins over anything older.
- `GLOSSARY.md`
- `ANALYSIS-PLAN.md`. Its §4–§7 describe the superseded design. Use them for the mechanics that are unchanged: bootstrap, Table 1, Table 3, the audit, cost, Table 4 and production standards.
- `analysis/README.md`, `analysis/run.R`, `analysis/R/*.R`

The authors asked for **a clean, polished analysis**, not another layer on top of the old one.

## Tasks

### 1. Load the new workbooks

Replace the A/Z loader in `R/load.R`.

- **Inputs:** read `human-adjudication/adjudication-with-explanations-{1,2}.xlsx` with `readxl`. If `readxl` is missing, install it into the renv library and record that in the lockfile. R 4.3.3 against a 4.6.1 lock is a known, documented substitution.
- **Joins:** join the Adjudications sheet to the arm label files by slug and domain.
  - Assert that the workbook's Human, Kit and No-kit columns equal the pipeline's meta, ARBITER and baseline labels for all 510 cells.
  - Stop on any mismatch.
- **Exclusions:** apply `EXCLUDED`, and assert that exactly 102 trials remain.
- **Signalling evidence:**
  - Parse the Signalling evidence sheet into one row per trial × phase × domain × question × answer component.
  - Normalise "Retained or changed" to `retained`, `changed` or `mixed`, with the from and to answers where they are stated.
  - Write the parse to `data-derived/` with a README note.
  - Report every row you could not parse.
- **Derived Overall:** compute it for both experts from their independent domain ratings, using the existing RoB 2 Overall rule in `R/algorithms.R`.
  - Validate against file 2's `Overall (derived)` sheet, for every column it has.
  - Report the mismatches; do not hide them.

### 2. Remove the superseded design

Delete code, outputs and tests that only serve the discarded design:

- the A/Z adjudication;
- the composite reference;
- "vindicated disagreement";
- error localisation / decisive questions;
- the question 5.1 descriptive.

Then clear out the round-specific scaffolding that no longer runs or no longer matters: the `verify-round*.R` and `.py` files, `report-round*.R`, `qa-round*.R`, `test-round*.R`, `build-round12.R`, `round14-round2.R` and similar.

- The end state is one pipeline (`run.R`), one test suite (`tests/testthat`) and one output verification script (`verify-output.R` or a successor).
- Move the old `round*-report.md` files to `analysis/archive/` and leave their contents unedited. The git history keeps everything else.
- Keep the exclusion manifest (`round14-public-release-exclusions.txt`). Rename it to a neutral name, and update every reference to it.

### 3. Implement the analyses in `docs/round15/BRIEF.md`

Each analysis below gets its own small, named function and a CSV in `output/tables/`.

- **Primary endpoint and its sensitivities:**
  - consensus on the discordant cells;
  - per adjudicator on all 80 discordant cells;
  - split cells counted as ARBITER losses;
  - post hoc strictness strata.
- **Independent-rating agreement:**
  - per expert, the mean of the two experts, the agreed reference, by domain and for derived Overall;
  - exact agreement and linear weighted κ;
  - paired differences with CIs.
- **Expert-to-expert agreement and κ.**
- **Direction of disagreement against the experts.**
- **Signalling-question agreement:**
  - five-level and collapsed;
  - per question, per domain, overall;
  - with CIs on the ARBITER − Unassisted paired difference.
  - Before comparing, map question IDs in both arms onto the experts' question numbering, and document the mapping.
  - Multi-component answers: match by component where both sides give components. Otherwise mark the comparison not evaluable and count those cases.
- **Rules-only recomputation** against the new references.
- **Forced choice on all 154 disputed cells**, descriptive.
- **Revised ratings and retained/changed answers**, descriptive.
- **Unchanged items:**
  - Table 1 against published labels;
  - Table 3 rule-consistency audit;
  - bundle and quotation audit;
  - runtime and cost;
  - the Table 4 data.

  Their numbers must equal the numbers at the parent commit. Prove it with a diff of their CSVs.

### 4. Displays

Rebuild per the BRIEF display table.

- Fig 1 and Fig 2 must be byte-identical to the parent commit.
- Follow the existing figure style, palette and fonts, and the production standards in `ANALYSIS-PLAN.md` §7.
- Figure titles state the finding.
- Regenerate:
  - `figure-legends.md`;
  - `results-sentences.md` (one sentence per Results step, every number traceable);
  - Tables 1–4 as .docx;
  - `Supplement.docx` and `supplement.html`, numbered by expected citation order, following the BRIEF order;
  - `TRIPOD-LLM.docx`;
  - `results.html`.
- Remove every eTable, eFigure and output file that belongs to the discarded design.

### 5. Plan and records

- Rewrite `ANALYSIS-PLAN.md` §4–§7 so it describes the Round 15 design cleanly.
  - State which analyses are prespecified and which are post hoc.
  - Treat everything new in this round as defined by the authors on 2026-10-21, after the adjudication data were collected.
- Add a dated `DEVIATIONS.md` entry recording the change of adjudication design for internal records. The manuscript will not mention it.
- Update `analysis/README.md`.
- Write a new `analysis/round15-report.md` covering:
  - what was built;
  - every number in `results-sentences.md`;
  - validation results;
  - unparsed rows;
  - the derived-Overall mismatches;
  - open issues.

### 6. Verify

- Run the full test suite. Add tests for:
  - the loader assertions;
  - the tie rule;
  - the primary endpoint on a small fixture;
  - derived Overall;
  - signalling-answer parsing and matching;
  - the direction-of-disagreement counts.
- Run the output verification script: every number in `results-sentences.md`, the legends and the tables must trace to a CSV.
- Recompute the provisional numbers from the BRIEF independently. Report any that differ, and say which is right.
- Visual QA: render every figure and every page of the supplement and tables to PNG with LibreOffice and pdftoppm. Inspect them for clipping, overlap, empty panels and legibility, and fix what you find.
- Run a leak scan of all outputs for: Haiku; kit / no-kit / meta label as reader-facing text; A/Z; composite; vindicated; decisive; over-flagging; "first"; accuracy (used for the primary endpoint).

### 7. Version control

Do not commit or push. Do not edit `docs/manuscript/`; that is WP-M.

## Final message

Report:

1. Files deleted, moved and added.
2. Loader assertion results and the derived-Overall validation.
3. The full `results-sentences.md`.
4. Every verification result, including tests, traces, invariance diffs, visual QA and the leak scan.
5. Anything in the BRIEF that the data contradicted, or that you had to interpret.
