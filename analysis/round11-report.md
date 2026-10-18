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


## Round 11B-2

Date: 18 October 2026. Started on `main` at `c6d6a09` after the Figure 1/2
merge. Implementation is committed separately from regenerated publication
outputs and this report. No push was performed.

### Changes

- Figure 1/2 legends and alt text now load at build time from the final
  `output/manuscript/legends-fig1-2.md`. The shared reader handles that file's
  bold figure labels; the prior HTML loader incorrectly expected Markdown
  headings. Both `figure-legends.md` and results.html use the shared reader.
  The optional instruction for a column-free Figure 2 variant is excluded
  because the final supplied Figure 2 includes the Unassisted column.
- results.html embeds the current six PNGs and supplies actual HTML alt
  attributes, checked against the exact publication PNG bytes. Numbering is
  Figure 1 workflow, Figure 2 AVATAR trace, Figure 3 flow, Figure 4 weak
  Published reference, Figure 5 primary endpoint, Figure 6 decisive questions.
  Table 2 refers to Figure 4; eTable 13 refers to Figure 5B; the Figure 5 legend
  refers to eTable 13. The supplied Figure 2 legend contains no manuscript
  Table 3/Figure 6 cross-reference. References inside verbatim source quotations
  retain their original numbers; the eTable footnote explains this.
- eTable 31 now has Part A (22 question rows, five domain judgement/rationale
  rows and Overall) and Part B (16 unique archived evidence records). Part A
  retains full justifications, unknowns, counterevidence, basis handles/types,
  every Unassisted answer and each verbatim domain rationale. Inactive ARBITER
  questions say “Not asked (inactive; branching)”. Part B retains complete
  quotes, source filenames/registry, page, lines and source-version hash prefix.
  Only displayed quote line breaks collapse to spaces; the data objects and
  committed `analysis/data-derived/avatar-trace.json` retain the original text.
  The footnote names that repository path and the landscape/Arial 8 pt exception.
- Figure 3 is 174 × 120 mm (previously 145 mm high), with its main column centred,
  consistent explicit box widths, exclusion box on the right at 105→102, and
  symmetric consensus/split branches. Figure 4B reverses the ramp, with dark
  Published-colour less-severe segments and white counts, then mid-grey equal
  and light-grey more-severe segments with dark counts, ordered left to right.
  An explicit grouping fixes text-stack ordering, tested against segment centres.
- Figure 5A offsets “no preference” beside the top of the reference line.
  Figure 5B uses “73/77 vindicated · 11 split” labels; eTable 13 retains all small
  segment counts. Its legend states the consensus denominators and split exclusion.
- Figure 6 uses light blue/orange cell-remainder bars, one paired-tint legend
  entry, no empty D1 remainder row, and “Count” on the x-axis. Its legend
  distinguishes question occurrences from cells. Updated Figure 3–6 legends/alt
  text accompany the changes.

### Final rendering and verification

- Final native Word supplement: **52 pages**, down from 76. AVATAR eTable:
  **9 landscape pages, pp 42–50**, below the ≤12-page target. All 16 complete
  quotes are present in the Word PDF; the verification uses raw cell reading
  order and removes only repeated Part B headers when joining across pages.
  There are 56 editable supplement tables. Only the last two (eTable 31 Parts
  A/B) use Arial 8 pt; other tables retain Arial 9 pt. The four main tables each
  remain one page; the checklist remains two pages. Removed an extra blank page
  at the landscape-to-portrait transition and retained the original margins.
- `quarto render` succeeded for both reports; the final Word-only column-width
  refinement was rebuilt through `build_supplement()` and followed by
  `quarto render supplement.qmd`. Native Word export, page PNGs/contact sheets,
  actual figure PDF rasters, greyscale and all three severity-1 colour-vision
  simulations were regenerated and reviewed. The final trace pages were also
  inspected individually. The final PDF contact sheet is regenerated by the QA
  script, rather than retaining the preceding round's image.
- Full test suite: **414 passing assertions in 54 test blocks**, zero failures,
  errors, skipped tests or test warnings. Tests reconstruct every basis quote
  exactly from its unique evidence record, preserve the verbatim rationales,
  and assert figure centring/symmetry, ramp/order, text alignment, label offset,
  tint colours, omitted D1 remainder, axis title and shared supplied legends.
- `verify-round11.R` passes: banned-term scans of reader-facing Word/PDF/HTML/
  legends; font/size/TIFF checks; full alt attributes and exact embedded PNGs;
  quote fidelity, landscape pagination and no blank pages. Figure 3–6 minimum
  PDF text sizes are 7.97, 7.97, 7.11 and 7.97 pt respectively; each is 174 mm,
  vector PDF and 600-dpi LZW TIFF. R's existing Windows startup locale warnings
  remain environmental; the test suite itself reports no warnings.
- All numerical CSVs are unchanged from `c6d6a09`. Final Figure1.*, Figure2.*,
  `analysis/figure1/**` and `legends-fig1-2.md` are unchanged from that commit.
  Generated results.html, supplement.html and Word-page QA intermediates remain
  local ignored build products, consistent with the repository's existing rules.

### Deviations

The archive has 16 evidence records but only 15 are cited by the current
answers. All 16 are retained once, and the footnote states that one additional
captured record is included. This distinction and the requested presentation
exceptions are recorded in DEVIATIONS.md entry 36. No statistical-method or
numerical-estimate change was needed.

## Round 11B-3

Date: 18 October 2026. Started on `main` at `e02a09c`. Implementation and
regenerated publication/QA outputs are committed separately. No push performed.

### Changes

- Figure 3: widened the exclusion box and reflowed its text into the requested
  two lines. Shifted the main column left, retained symmetric branches about
  that column, and expanded the three-line arms and outcome boxes. Font-metric
  tests require at least 2 mm of horizontal and vertical inner clearance in
  every box. The plot has 3 mm margins; the rightmost box is 7.5 mm from the
  figure edge (before the negligible outline half-width).
- Figure 6: one compact, left-aligned legend row, with equal 3 mm keys and
  equal entry spacing. The paired light-blue/light-orange swatches are side by
  side within one key labelled “No individually decisive question (cells)”.
  The existing full legend retains its explanation of lighter bars and the
  distinction between question occurrences and cells.
- Table 2: explicit Source/κ/AC2/exact/sensitivity/specificity widths of
  1.02/1.18/1.26/1.11/1.08/1.26 inches, totalling 6.91 inches within the
  6.97-inch portrait text area. Horizontal padding is 2 pt. Every numerical
  value, including paired differences with negative CI bounds, remains on one
  line in native Word. The Source descriptions may wrap. Arial **9 pt** is
  retained throughout; the 8.5 pt fallback was unnecessary.
- Table 3: Unassisted departure cells now use one parenthesis, for example
  `26/509 (5.1%; 3.3–6.9)`. The footnote defines the range after the semicolon
  as the 95% CI in percent. All value cells remain on one line.
- eTable 31: both arms use Yes, No, Probably yes, Probably no, No information
  and Not applicable; inactive ARBITER questions retain “Not asked (inactive;
  branching)”. Evidence types use spaces. Empty recorded unknowns and
  counterevidence use “—”, defined in the footnote. Verbatim evidence and
  Unassisted domain rationales remain intact.
- Scanned all main/supplement Word tables, both HTML reports, legends and
  Word-rendered supplement text for raw internal codes and snake_case fields.
  Shared reader formatting expands remaining answer/judgement codes. The
  verifier rejects unexpected underscored tokens, with explicit exceptions
  for literal tool/function names, evidence handles and filenames. HTML scans
  preserve paragraph/cell boundaries so adjacent cells cannot manufacture
  false internal-code matches.

### Verification and visual QA

- Full suite: **493 passing assertions in 57 test blocks**, zero failures,
  errors, skipped tests or test warnings. Added font-metric width checks for
  every value column in Tables 2–3 (Arial 9 pt, padding plus a 0.025-inch Word
  allowance), physical flow-box padding/edge checks, trace label checks and
  raw-code scans of the full supplement registry and final reader outputs.
- `quarto render` completed for both HTML reports; results.qmd was rendered
  again after the final flow-box height adjustment. Final native Word export
  followed the completed build. `verify-round11.R` passes, including an actual
  PDF-baseline check for every Table 2–3 value, current embedded PNG bytes,
  complete evidence-quote fidelity and the protected-file checks.
- Native Word: four one-page portrait main tables; two-page checklist;
  52-page supplement with 56 editable tables. The AVATAR trace remains nine
  landscape pages (42–50), using its existing Arial 8 pt exception. Inspected
  the main tables, checklist, all supplement page previews/contact sheets and
  all nine trace pages individually. No clipping or new pagination defect.
- Regenerated actual PDF rasters, greyscale and severity-1 protanopia,
  deuteranopia and tritanopia previews. Personally inspected the final Figure
  3 exclusion and Figure 6 legend crops at 4× final size (384 dpi at a 96-dpi
  display scale), plus their full accessibility previews. The crop/full-view
  PNGs are retained in `output/manuscript/qa/` and reproducible with
  `qa-round11.R`. Figure 3–6 minimum embedded text remains 7.97, 7.97, 7.11
  and 7.97 pt; all are 174 mm vector PDFs and 600-dpi LZW TIFFs.
- All numerical CSVs and protected Figure 1/2 paths are unchanged from
  `e02a09c`. HTML and Word PDF/page QA intermediates retain the existing
  ignore policy. R startup locale warnings, and an intermittent renv sandbox
  activation-delay warning under concurrent QA, are environmental; the test
  suite reports no warnings.

### Deviations

No methodological or numerical deviation. Main tables remain Arial 9 pt;
the earlier AVATAR landscape/8 pt exception is unchanged. Used the repository's
native Microsoft Word export workflow requested for this task.
