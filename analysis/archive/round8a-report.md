# Round 8a implementation report

Implemented section 7 presentation outputs on main, without pushing. Starting
HEAD was 44a29a82fcfb8319555594869e24c8dde90635be. ANALYSIS-PLAN.md, GLOSSARY.md,
the curated metadata and every other input folder remain unchanged. No analysis
statistic or value-bearing CSV changed. No genuine statistical error was found.

Figure 1 is owned by the other worktree: analysis/R/figures.R, the existing
Figure 1 image files and the Figure 1 slot in results.qmd remain unchanged.
The pipeline now invokes a separate Figures 2-5 builder rather than the legacy
all-figure builder. Its default legend follows the new AVATAR specification.

## Milestones

- 98b8cf0: shared presentation layer, vendored OFL fonts, installer, formatting
  tests and renv-locked dependencies.
- 9eefa21: four editable main Word tables and matching main HTML display objects.
- 4568d6d: Figures 2-5 and supplemental forest in vector PDF, 600-dpi LZW TIFF
  and PNG preview formats.
- 5c78697: numbered Word supplement, reporting checklist and matching HTML view.
- The final legends/QA commit containing this report records visual refinements,
  figure legends, verification scripts and QA evidence.

## Output file list

Publication files in analysis/output/manuscript/:

- Table1.docx, Table2.docx, Table3.docx, Table4.docx.
- Figure2.pdf, Figure2.tiff, Figure2.png.
- Figure3.pdf, Figure3.tiff, Figure3.png.
- Figure4.pdf, Figure4.tiff, Figure4.png.
- Figure5.pdf, Figure5.tiff, Figure5.png.
- eFigure1.pdf, eFigure1.tiff, eFigure1.png (per-meta-analysis forest).
- Supplement.docx: 29 ordered eTables, one eFigure, methods appendix, prompt
  templates/filled example and provenance; 37 pages in the Word QA renderer.
- TRIPOD-LLM.docx: checklist skeleton with GRRAS items; two pages.
- figure-legends.md: legends and Alt text lines for Figures 1-5.

The plan's second legend location, analysis/output/figure-legends.md, contains
the same text. analysis/results.html and analysis/supplement.html are regenerated
self-contained working views, ignored by Git. QA PNGs, extracted Word text,
session information and verification output are in output/manuscript/qa/.
Full Word renders/contact sheets remain local QA intermediates; scripts rebuild
them. Statistical CSVs remain the frozen machine-readable analysis exports.

## Presentation implementation

presentation.R contains pure label/number/CI/fraction helpers, JAMA role colours,
the Fira Sans plot theme, and the Arial 9 pt three-line flextable style. CI bounds
use an en dash when nonnegative and “to” with true minus signs when negative.
Question identifiers retain one decimal (1.1, not 1.10); counts use n/N (x.x%).
Formatting is tested separately from the analysis. Tables contain Word cells,
not images, with Arial 9 pt in headers, bodies and notes. Footers stay with the
last row across page breaks. The four main tables each occupy one page.

Table 1 joins curated specialty/journal/year/topic to existing label counts,
sorts specialty then journal, pools D1-D5, reports Overall availability and adds
totals (102 trials; 427/69/14 Low/Some concerns/High labels; 81 Overall labels).
The old per-domain table1.csv is unchanged and supplies eTable 1, augmented in
memory with journal/year identifiers. Table 2 visibly labels its three blocks;
the composite and its paired difference show the three section 5.2 metrics.
Table 3 separates proposed domain consistency, overrides, exact Overall
consistency, permitted escalation, text-span/visual binding and verification.
Table 4 is reliability only; localisation class counts are supplementary.

The supplement includes both process tables and totals, all-arm published
agreement, composites and per-adjudicator sensitivities, missing-judgement
sensitivity, confusion matrices, forest estimates, full consistency/audit,
invalid paths, the verbatim override rationale, cost bounds/reconciliation,
quotation syntax, exploratory answer agreement, both localisation populations,
all 22 decisive-question frequencies and the parse issue. The four requested
methods topics are explained in the appendix. Wide diagnostics are pivoted to
measure/value rows; the override uses Field/Value rows so its rationale is readable.

## Visual QA, per regenerated figure

All figures are 174 mm wide. PDFs embed Fira Sans (Condensed in the flow);
TIFFs are 4110 pixels wide, 600 x 600 pixels/inch, LZW. PDF text extraction
independently measures minimum font sizes below. No image contains a title;
multi-panel tags are bold capitals.

- Figure 2: 174 x 174 mm; minimum 8.68 pt. Orthogonal exclusion connector avoids
  boxes. Inclusion, exclusion and adjudication counts agree with frozen outputs.
  No clipped or overlapping labels; greyscale and all CVD simulations are clear.
- Figure 3: 174 x 180 mm; minimum 7.5 pt. Requested four row labels and JAMA
  source roles; point shapes distinguish arms. Panel B retains all 154 counts,
  shared labels and splits. Labels/counts are legible; greyscale and all CVD
  simulations preserve interpretation through shapes and labelled columns.
- Figure 4: 174 x 160 mm; minimum 8 pt. Panel A includes D1-D5 and pooled weighted
  kappa against Published only. Panel B shows the unchanged 78/29/22 direction
  counts, with denominators. Removed a crowded y-axis title near tag B. No
  clipping/overlap; greyscale and all CVD simulations remain interpretable.
- Figure 5: 174 x 215 mm; minimum 7.97 pt. Paired bars have question numbers,
  short text, printed counts and domain loss denominators for both sources.
  Labels wrap within margins. No clipped counts/overlap; bar order and explicit
  values preserve interpretation in greyscale and all CVD simulations.
- eFigure 1: 174 x 200 mm; minimum 8 pt. Four source/model series have distinct
  open/filled shapes; Haiku uses lighter role tints. Legend uses two rows to
  avoid clipping. Greyscale and all CVD simulations retain the series mapping.

Actual PDF renditions at 160 dpi, original PNG previews, greyscale and severity-1
protanopia/deuteranopia/tritanopia simulations were inspected. Every page of the
37-page Word supplement, four one-page main tables and two-page checklist was
also inspected using Word PDF renders and PNG/contact sheets. Officer opens all
six documents; the supplement has 29 real tables and each other document one.

## Verification

- The complete testthat suite passes 246 assertions, with no failures, warnings
  or skips. Startup still emits the existing four Windows C.UTF-8 locale warnings;
  presentation explicitly sets a supported UTF-8 LC_CTYPE for Unicode output.
- A fresh R/Quarto render succeeds after deleting both HTML files and every
  generated top-level manuscript artifact, preserving Figure 1 and local QA.
  Caching is disabled. Both reports and all manuscript outputs are regenerated.
- verify-round8a.R compares every repository CSV against immutable starting HEAD:
  all 88 are byte-identical under Git newline normalisation, with no added or
  removed CSV. The initial pre-edit Git CSV diff was also empty.
- The same verifier checks real Word cells, table font runs, embedded PDF fonts,
  minimum PDF font sizes, physical widths and 600-dpi LZW TIFF metadata.
- Reader-facing name scans pass the six Word text extractions, Figures 2-5 and
  eFigure 1 PDF text, both legend copies, supplement.html, and results.html outside
  its unchanged Figure 1 slot. The verifier confirms that slot equals starting
  HEAD. No unqualified global scan claim is made for the separately owned slot.
- Git diff checks confirm protected inputs, plan/glossary and Figure 1 code/files
  are unchanged. git diff --check passes. No push was performed.

## Choices, deviations and remaining uncertainty

DEVIATIONS.md entries 24-28 record every round 8a choice: vendored fonts/session
loading without an Arial figure fallback; display-only joins and layout; direction
bars and domain loss facets; diagnostic reshaping/Word supplement order; and the
explicit Figure 1 scan boundary. No estimand, denominator or source value changed.
The verbatim override's clinical phrase “baseline balance” is preserved, while
internal source labels are translated. Both requested legend locations are written.

The lead must reconcile Figure 1's old report slot with the separately produced
image; its final legend should be checked if the other agent uses the ASCET
fallback instead of AVATAR. Author checklist page/section/applicability fields
remain blank by design. The pre-existing ARBITER Zenodo DOI still requires author
completion; no DOI was invented. No statistical uncertainty or genuine analysis
error was newly identified in this presentation round.
