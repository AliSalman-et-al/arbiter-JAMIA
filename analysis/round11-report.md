# Round 11 implementation report

Date: 18 October 2026. Starting commit: `9792c55`. Branch: `main`.
Implementation commit: `6632f16`; publication outputs and this report follow in a separate commit.
No push or publication was performed.

## Changes

- Read the revised ANALYSIS-PLAN.md section 7 and GLOSSARY.md before implementation.
  The plan and glossary were not edited.
- Main outputs now follow Figure 3 flow, Figure 4 weak Published reference,
  Figure 5 primary endpoint, and Figure 6 decisive questions. Figure 3 adds the
  four-arm box; Figure 4B has domain-specific 100% direction bars; Figure 5A is
  an ARBITER-only forest with the 50% reference and all outcome counts; Figure
  5B shows vindicated disagreements. Figure 6 adds cell-based grey remainders.
- Reserved “departure” for algorithm failures. Moved the former primary-endpoint
  tile matrix to eFigure 2, using disagreement terminology. Replaced its stale
  `figure3-panelB.csv` export with `efigure2-disagreement-patterns.csv`; counts
  remain unchanged. The existing per-meta-analysis forest remains eFigure 1.
- Table 2 shows coefficients/percentages with CIs, with cell, Not Low and Low
  denominators in block labels. AC2 and the All-Low rule remain. The notes retain
  both composite caveats and add the Overall/adjudication and Published-severity
  caveats. Full fractions remain in the supplement.
- Table 3 drops the requested rows and separate CI column, places Unassisted CIs
  inside cells, and marks the four algorithm/path design-guarantee rates. Recorded
  overrides remain empirical, separate from the server's proposal guarantees.
- Added eTable 12 post hoc severity-stratified win share, eTable 13 full vindication
  outcomes including splits, and eTable 31 complete AVATAR trace. Later eTables
  are renumbered from the common registry. Supplement.docx and supplement.html
  use the same 31 eTables and two eFigures in the same order.
- The AVATAR trace includes all 22 signalling questions, active/inactive status,
  every basis type and full evidence-record quote, source file/page/lines and
  source/evidence hash prefixes, justification, unknowns, counterevidence,
  proposed/adopted domain judgements and Overall. Unassisted answers come from
  the requested results-102 export (byte-identical to the versioned shared export, which is the fallback when the ignored results-102 folder is absent); its five
  domain rationales are copied verbatim into a small committed JSON file. A
  committed bundle projection makes rendering independent of gitignored logs.
  Quotes remain complete, including extracted tables and original line breaks.
- results.qmd now gives a short introduction, Figures 1–6 with legends, Tables
  1–4, primary/time/cost results, and reproduction/code links. Main text uses
  ARBITER, Unassisted, Published, Adjudicator 1 and Adjudicator 2. The combined
  legend file has the requested Figure 1/2 placeholders and rewritten Figure
  3–6 legends and alt text.

## Numbers and uncertainty

Existing numerical estimates and statistical CSVs are unchanged, apart from
relabelling/replacing the obsolete matrix export. New descriptive counts carry
no newly invented CIs. The post hoc endpoint uses the existing stratified
trial-cluster bootstrap: 10,000 replicates, seed 20261018, percentile type 7.
All replicates are valid in both strata.

| Post hoc direction, ARBITER vs Unassisted | ARBITER wins (95% CI, %) | Unassisted wins (95% CI, %) | Neither (95% CI, %) |
|---|---|---|---|
| More severe, N = 45 | 44/45, 97.8 (92.7–100.0) | 1/45, 2.2 (0.0–7.3) | 0/45, 0.0; collapsed interval |
| Less severe, N = 17 | 10/17, 58.8 (35.7–80.0) | 6/17, 35.3 (14.3–57.9) | 1/17, 5.9 (0.0–18.2) |

For context, the unchanged Figure 5A ARBITER win shares are consensus 54/62,
87.1% (79.0–94.3); Adjudicator 1 60/80, 75.0% (66.7–83.3); Adjudicator 2
64/80, 80.0% (72.3–87.2); and split sensitivity 54/80, 67.5% (58.7–76.3).
The corresponding ARBITER/Unassisted/neither counts are 54/7/1, 60/16/4,
64/15/1 and 54/7/19.

| Source and disagreement direction vs Published | Vindicated | Published upheld | Other | Consensus N | Split | All N |
|---|---:|---:|---:|---:|---:|---:|
| ARBITER more severe | 73 | 2 | 2 | 77 | 11 | 88 |
| ARBITER less severe | 22 | 6 | 0 | 28 | 8 | 36 |
| Unassisted more severe | 48 | 10 | 1 | 59 | 10 | 69 |
| Unassisted less severe | 19 | 17 | 2 | 38 | 8 | 46 |

Consensus totals are 95/105 ARBITER and 67/97 Unassisted vindicated disagreements.
Figure 5B excludes splits from its plotted denominators and prints their counts.

Published less/equal/more severe than preferred: D1 9/2/7, D2 11/11/10,
D3 19/5/0, D4 9/3/2, D5 30/8/3; pooled 78/29/22.

No individually decisive question, ARBITER/Unassisted: D1 0/0, D2 0/2,
D3 2/7, D4 1/5, D5 0/4. Distinct cells with at least one decisive question
are respectively 1/3, 4/6, 0/1, 0/1 and 2/18. These pairs sum to the eligible
losses, 10 ARBITER and 47 Unassisted; question frequencies can exceed cell counts.

## Verification and QA

- `quarto render` in analysis/ completed successfully for both HTML reports.
  `testthat::test_dir('tests/testthat')`: **372 passed assertions in 54 test blocks**,
  zero failures, errors, skipped tests or test warnings. New tests cover every
  domain direction count, all vindication outcomes/splits and totals, post hoc
  counts/intervals with the shared bootstrap, primary-figure counts/intervals,
  every grey remainder, all matrix counts, complete trace questions/rationales,
  exact reconstruction of every basis quote, and main-table layout/denominators.
- `verify-round11.R` passes: clean reader-facing Word, PDF, HTML and legend scans;
  no banned arm/internal labels and no “departed from Published”. Verbatim lower-case
  clinical “baseline” in source quotes/rationale is deliberately preserved.
- Figures 3–6 and eFigures 1–2 have embedded Fira Sans, 174 mm width, vector PDF,
  and 600-dpi LZW TIFF. Minimum PDF text: 8.68, 7.97, 7.11, 7.97, 8.00 and
  7.50 pt, respectively. PNGs, actual PDF raster previews, greyscale and severity-1
  protanopia/deuteranopia/tritanopia simulations were generated and inspected.
- Native Word PDF export and PNG/contact-sheet rendering completed. Inspected
  all 76 supplement pages, four one-page main tables and the two-page checklist.
  Supplement has 82 real editable Word tables; main tables each have one and the
  checklist one. All table runs use Arial 9 pt. All 87 full-quote chunks are found
  in the Word-rendered PDF after whitespace normalization; none is clipped away.
- The Windows PowerShell 5 subprocess stalled in Word COM export; the same native
  Word script succeeds when invoked directly from PowerShell 7 (`& ./render-word-qa.ps1`).
  The script now uses an ordinary foreach loop, logs opens/exports, and processes
  the main documents before the long supplement. No source Word document is saved
  by the renderer. Initial overlapped build/Word-export attempts were discarded;
  final generation and export were sequential.

## Files

Implementation: `R/round11.R`, `R/avatar-trace.R`, `R/manuscript-figures.R`,
`R/manuscript-tables.R`, `R/manuscript-supplement.R`, `R/manuscript-legends.R`,
`R/figures.R`, `run.R`, `results.qmd`, `supplement.qmd`,
`extract-avatar-trace.py`, `render-word-qa.ps1`, `qa-round11.R`,
`verify-round11.R`, `tests/testthat/test-round11.R`, `DEVIATIONS.md` and this report.

Committed derived data: `data-derived/avatar-trace.json` and
`data-derived/avatar-unassisted-rationale.json`.

New numerical CSVs under `output/tables/`: `published-direction-domain.csv`,
`vindicated-disagreements.csv`, `severity-win-share.csv`, `no-decisive-counts.csv`,
`efigure2-disagreement-patterns.csv`. Removed `figure3-panelB.csv`.

Publication outputs under `output/manuscript/`: Figure3–Figure6 and eFigure2
PDF/PNG/TIFF; rebuilt eFigure1 PDF (same content); Table1–Table4.docx,
Supplement.docx, TRIPOD-LLM.docx and figure-legends.md. QA contains figure PDF
rasters and accessibility simulations, Word PDFs/page PNGs/contact sheets,
extracted document text, the test result object and verification-round11.txt.
The HTML reports and Word-page QA intermediates remain generated local files,
following the repository's existing ignore rules.

## Deviations and remaining integration

DEVIATIONS.md entries 34–35 record the requested post hoc estimand and the
presentation/trace choices: consensus-only vindication bars with splits alongside;
small-segment counts in a summary column; distinct-cell reconciliation; contiguous
quote chunks; verbatim clinical wording and native Word rendering. No other
methodological deviation was needed, so ANALYSIS-PLAN.md is unchanged.

Figure 1/2 files, `analysis/figure1/**`, and `legends-fig1-2.md` were not written,
deleted or renamed. Their final artwork and legends still come from the parallel
task. The combined legend placeholders are intentional. results.html references
the required PNG paths and will incorporate the supplied legend sections when
that file is present and the page is rebuilt. Until the parallel task is merged,
its existing local Figure 2 PNG still displays the earlier flow image. No claim
is made to have QA-reviewed the parallel task's new artwork.
