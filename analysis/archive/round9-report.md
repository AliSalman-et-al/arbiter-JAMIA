# Round 9 implementation report

Presentation polishing on main, without pushing. Starting commit:
912f641c1f91f2e3b064ccc0f7704ac74c71fbdc. No statistic, value-bearing CSV,
protected input, curated metadata, plan or glossary changed.

## Milestones

- f6ad38f — R0–R4: main-table presentation and Figure 1 TIFF extension.
- c299270 — R5–R8: compact flow and clarified adjudication/localisation figures.
- 8c2290b — R9: reader-ready supplementary tables and ordered confusion grids.
- The final commit containing this report — R10, final layout corrections,
  combined legends and complete QA evidence.

## Required items

- **R0:** Figure1.tif becomes Figure1.tiff; builder, README and reproducibility
  manifest updated. Rebuilding preserves all Figure 1 publication bytes.
- **R1:** Year is a separate text column; abbreviated journals free width;
  General medicine precedes alphabetical specialties. The pooled counts header
  names Published D1–D5 and Low / SC / High; SC and topic abbreviations are
  defined. Specialty and journal words fit. One portrait page.
- **R2:** Spanning Published D1–D5, Published Overall, composite D1–D5 and paired
  difference groups replace stacked row labels. Source rows remain ARBITER,
  Unassisted and All-Low rule where available. CIs for proportions use percent;
  paired proportion differences use percentage points. Not Low is explicit in
  sensitivity/specificity headers; both composite caveats remain.
- **R3:** Domain, Overall and evidence/audit group rows use the requested measure
  wording. Values are n/N (%); only Unassisted departure-type rates have a
  separate percent-scale CI column. Unavailable traces are explicitly labelled.
- **R4:** Between-adjudicator and each independent-adjudicator comparison groups;
  Published capitalised consistently; raw agreement CIs on the percent scale.
- **R5:** Figure 2 is 174 × 95 mm. Exclusion branches horizontally from the
  main spine directly into its side box. Names are Atwine 2020, Haney 2004 and
  Herrmann 2016; restrained condensed typography and heavier outlines.
- **R6:** Figure 3 consensus points carry 54/62 and 7/62 annotations; the rest
  of the figure is preserved.
- **R7:** Figure 4B has 0–100% ticks, n/N (%) labels and the requested axis text
  split across two readable lines.
- **R8:** Figure 5 omits zero-count bars/text. Fixed source positions keep
  ARBITER above Unassisted and first in the legend, including one-source rows.
  Domain loss headers remain; counts are directly labelled. The 0–20 range
  accommodates the largest unchanged count of 18.
- **R9:** Supplement.docx has 28 eTables, one eFigure, contents, methods appendix,
  prompts/example and provenance. The redundant process-summary dump was dropped
  under the explicit R9 option. Process tables retain per-trial summaries; cost
  totals/bounds and token diagnostics are wide source-comparison tables. Every
  matrix is an ordered Published-by-predicted grid; Missing appears only when
  nonzero. Specialty/topic replace meta-analysis IDs. Undefined/degenerate κ
  displays — with a note. Repeated sources/comparisons use group rows. The long
  exploratory answer table is two side-by-side source grids, one per adjudicator.
  All headers/units/abbreviations are reader-facing. SQ is defined to avoid a
  mid-word header wrap. Methods cite the 2019 RoB 2 guidance, frozen pricing
  source and ARBITER 1.0.0 public commit. All sections remain portrait.
- **R10:** One canonical combined legend file remains in output/manuscript/.
  Figure 1's exact merged legend and alt text are read from its notes; later
  legends reflect the new labels/layouts. The duplicate output/figure-legends.md
  is deleted. The working report displays the merged Figure 1.

## QA evidence

Final Supplement.docx: **40 portrait pages**, 28 numbered eTables represented
by 52 editable Word grids, one eFigure. Main Tables 1–4: **one page each**.
The separate author-completion checklist: two pages.

- Regenerated Figure 1 with its locked uv environment and Figures 2–5/eFigure 1
  through Quarto. Every figure was viewed in colour, actual PDF rendition,
  greyscale and severity-1 protanopia, deuteranopia and tritanopia simulations.
- Used the repository's hidden native Word PDF renderer; rendered every document
  page to PNG. Viewed all 40 supplement pages, all four main-table pages and both
  checklist pages. Fixed narrow headers and pagination; re-rendered and viewed
  the final eTable 28 correction. Every rendered Word text box stays within its
  physical page bounds.
- The complete testthat suite passes without failures, warnings or skips.
  Four existing Windows C.UTF-8 startup warnings remain; presentation sets a
  supported UTF-8 character locale. New tests cover percentage CIs, range
  punctuation, group rows, trial/field names, ordered matrices with conditional
  Missing, and value-preserving diagnostic reshaping.
- Clean uncached `quarto render` succeeds after removing generated HTML and
  manuscript artifacts. A final supplement-only render updates the last header
  correction and its matching HTML view.
- All **88 repository CSVs** are byte-identical to starting HEAD under Git
  newline normalization; no added/removed CSV. Initial and final Git CSV diffs
  are empty. verify-round9.R records the invariant baseline.
- All publication Word, PDF/SVG and canonical-legend prohibited-name scans pass;
  both HTML views also pass. Word text additionally passes raw snake-case,
  meta-analysis ID and trial-slug checks. No unchanged Figure 1 report-slot
  exclusion remains. Figure 1 SVG accessible text is scanned; its PDF is outlined.
- Word tables remain editable Arial 9 pt. Figures 2–5/eFigure 1 embed Fira Sans,
  minimum 7.5 pt or larger. Figure 1's own builder confirms minimum 7.23 pt.
  All figures use 174 mm widths and 600-dpi LZW TIFFs.
- Figure 1 PDF/PNG/SVG and renamed TIFF hashes equal the starting artifacts.
  Protected files and Figure 1 content are unchanged; git diff --check passes.

Scripts and extracted text/figure previews are in output/manuscript/qa/;
full Word-page renders are local, reproducible QA intermediates.

## Choices and uncertainty

DEVIATIONS.md entries 29–32 record the display choices. No genuine statistical
error or unresolved publication-layout issue was identified. The canonical
legend location follows the lead's R10 request instead of the older plan path.
Clinical wording and the No information code in the override are expanded for
readability and explicitly footnoted; the original CSV rationale is untouched.
Figure 1's separate technical notes retain historical source-file paths as
provenance, under the instruction to preserve its content. These are absent
from the publication figures, Word documents and combined legends. The
reporting checklist remains an author-completion skeleton, as before.

No push was performed.
