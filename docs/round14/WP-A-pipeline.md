# WP-A: pipeline, statistics, figures, tables, supplement

Read `docs/round14/BRIEF.md` first. This package covers everything in `analysis/` except Figures 1–2 and the manuscript prose.

## A1. Remove Haiku from all outputs

Apply this across loaders, builders, tests, figures, tables, supplement, results.html, legends, results sentences and the TRIPOD checklist.

- Fig 3 shows two arms. Remove the arm-chip tint key and all Haiku text.
- The section 5.4 validation gate keeps its Sonnet checks.
- The Haiku hill-2017 override and the missing-judgement sensitivity disappear from the outputs.
- Tests that assert Haiku numbers are removed or rewritten to cover Sonnet only. State which ones in the report.

## A2. Post hoc analyses (ANALYSIS-PLAN section 6)

Write each as a pure function in `R/`, with `testthat` tests built on hand-made cells.

1. **Rules-only recomputation** of Unassisted.
   - Replace each Violation label with the algorithm's output. Invalid answer paths stay as reported.
   - Outputs:
     - changed cells, listed
     - win share on consensus discordant cells, with the section 4 bootstrap CI
     - agreement with published labels, D1–D5: weighted κ and exact agreement
     - agreement with the agreed choice on consensus cells
   - Export to `output/tables/rules-only-recomputation*.csv`. The eTable is labelled post hoc.
2. **Direction of disagreement.**
   - For each Sonnet arm and each direction, the share of consensus cells where the agreed choice equals the arm's label, with bootstrap CI.
   - Report split cells as counts, along with "Published upheld" and "other label".
   - Export to `output/tables/direction-of-disagreement.csv`.
3. **Unweighted Cohen's κ** and exact agreement against published labels, by domain and Overall, for both arms, with bootstrap CIs. Supplement only.

## A3. Main displays (ANALYSIS-PLAN section 7 "Main text")

- **Table 1** = agreement with published labels (the current Table 2 content), renumbered.
- **Table 2** = reliability of the reference (the current Table 4 content), renumbered.
- **Table 3** = rule breaks and audit. Keep the Round 13 design. Overrides are stated as 0/510; there is no override eTable.
- **Table 4** = comparison with prior work. Build it from `analysis/data-curated/prior-work-comparison.csv`, which WP-T is writing in parallel. If that file is absent when you reach this step, build the table code against the schema in `docs/round14/WP-T-prior-work.md` and a temporary fixture under `tests/`. Do not invent content. Report that the table awaits WP-T.
- **Fig 4**:
  - A: unchanged (κ by domain).
  - B: new, the direction-of-disagreement estimand. Rows are ARBITER and Unassisted × stricter and more lenient. Show the share where the adjudicators agreed with the model, with 95% CI, and n/N printed beside each row. Split counts appear as text.
  - Title states the finding. Legend is 120 words or fewer. Colours follow the arm palette.
- **Fig 5**:
  - Keep the existing four analyses.
  - Add a visually separated group labelled "Post hoc: by which arm was stricter", with the rows ARBITER stricter than Unassisted (44/45) and ARBITER more lenient (10/17). Take the CIs from severity-win-share.csv.
  - Panel B is removed; its content now lives in Fig 4B.
- **Fig 6**: unchanged in content. The legend points to the rules-only eTable.
- **Old Fig 4B** (published label against the agreed choice) moves to the supplement as an eFigure or eTable.
- **Old Table 1** (benchmark set) moves to the supplement.

## A4. Supplement (ANALYSIS-PLAN section 7 "Supplement")

- Rebuild the eTable and eFigure inventory exactly as listed there, numbered in citation order.
- Drop:
  - every Haiku item
  - the recorded-override eTable
  - the disagreement-pattern tile matrix (eFigure 2)
- Add:
  - unweighted κ
  - rules-only recomputation (post hoc)
  - published label against the agreed choice by domain
  - an eMethods paragraph stating input parity: both arms received identical article, supplement, registry, protocol and SAP files. The source is `no-kit-sonnet-5.5/README.md`. Quote only facts stated there.

## A5. Results sentences and legends

- **`results-sentences.md`**:
  - One or two finding-first sentences per step, in the R1–R7 order of section 7.
  - Include the new sentences for Fig 4B and for the rules-only recomputation.
  - Follow the reader labels.
  - Never use "over-flagging" or "supported by evidence".
  - No sentence starts with a numeral.
- **Legends** follow the Round 12 order and length rules.
- **`results.html`** follows the new manuscript order.

## A6. Verification

- `verify-round14*.R` or `.py` must cover:
  - invariance of every retained Sonnet number against the parent commit
  - reproduction of the preliminary numbers in the brief
  - no reader-facing "Haiku" anywhere in `output/manuscript`, `output/tables`, `output/figures` or the rendered HTML (grep)
  - no internal labels in outputs
- The full test suite passes.
- Visual QA: render every main and supplementary figure to PNG and inspect it. Convert every DOCX to PDF and check pages for overflow and truncation.
- Write `analysis/round14-report.md`.
