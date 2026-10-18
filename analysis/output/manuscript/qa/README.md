# Round 9 visual checks

Rebuild from analysis/ with the vendored fonts installed:

1. Run `quarto render` (cache is disabled).
2. Rebuild Figure 1 using the command in `figure1/README.md`.
3. Run `Rscript qa-round9.R`.
4. Run `powershell -File render-word-qa.ps1`, then `Rscript render-qa-pages.R`.
5. Run `Rscript verify-round9.R` and `testthat::test_dir('tests/testthat')`.

`*-pdf-1.png` is the actual vector PDF rendered at 160 dpi.
`*-accessibility.png` shows greyscale, protanopia, deuteranopia and tritanopia
(top left, top right, bottom left, bottom right), severity 1. Individual
previews retain their original dimensions. Figure 1 is now included.

All six figures were inspected in colour, PDF rendition and every simulation.
Their shapes, source offsets, explicit categories and counts retain meaning
without hue. Figure 1's rebuilt publication bytes equal the starting files.
Figures 2–5 and eFigure 1 embed Fira Sans; Figure 1 outlines its bundled fonts.
All TIFFs are 600-dpi LZW.

All four main Word tables are one portrait page. Supplement.docx has 40
portrait pages, 28 numbered eTables represented by 52 editable Word grids,
and one eFigure. The reporting checklist is two pages. Every page was viewed;
the final correction to eTable 28 was re-rendered and inspected. Full Word
PDFs, page PNGs and contact sheets are local regenerable intermediates.

verify-round9.R compares all 88 CSVs with starting commit 912f641 and scans
all six Word documents, publication PDF/SVG text, both HTML views and the one
canonical legend file. It also rejects raw metric names, meta-analysis IDs
and trial slugs in Word text. It confirms editable Arial 9 pt table runs,
figure fonts/sizes and TIFF metadata. Figure 1's technical provenance notes
retain historical input paths and are unchanged; their legend/alt text alone
is incorporated into the canonical legend file.

## Round 10 table corrections

Run `Rscript verify-round10.R` for the same publication checks against round 10's
starting HEAD (8e0215b), including all 88 CSVs. Regenerated native Word PDFs,
page PNGs and contact sheets were inspected for Table 2, Table 3 and supplement
pages 7–8, 10–11, 28 and 36 (eTables 4, 6, 19 and 26). Page counts and page bounds
are unchanged. The coverage label names active signalling answers, and collapsed
proportion intervals are omitted. See round10-report.md for the changed cells.


## Round 11B-2 (current)

From analysis/: `quarto render`, `Rscript qa-round11.R`,
`& ./render-word-qa.ps1` in PowerShell 7, `Rscript render-qa-pages.R`,
`Rscript verify-round11.R`, and `testthat::test_dir('tests/testthat')`.
Final Figure 1/2 artwork, analysis/figure1/** and legends-fig1-2.md are read-only;
this round does not rebuild them. The two supplied legends load at build time.

The native Word supplement has 52 pages and 56 editable tables. The AVATAR
trace occupies nine landscape pages (42–50), with Arial 8 pt only in its two
parts; other tables use Arial 9 pt. All 16 complete evidence-record quotes are
verified in the PDF. Figures 3–6 and both eFigures have refreshed PDF rasters,
greyscale and colour-vision simulations, and round11-pdf-contact.png. The four
main Word tables remain one page each; the checklist remains two pages.
Tests: 414 passing assertions, 54 blocks, no failures/errors/skips/test warnings.
See analysis/round11-report.md, “Round 11B-2”, for details and the archive's
16-record/15-currently-cited distinction.

## Round 11B-3

Same build and QA commands as above. The final suite passes 493 assertions in
57 blocks. `verify-round11.R` also rejects raw reader-facing codes and checks
that every Table 2–3 value occupies one baseline in the native Word PDF.
Both tables retain Arial 9 pt; Table 2 has revised explicit column widths.
Supplement pagination remains 52 pages, with the trace on pages 42–50.
All Word page previews were inspected, including each trace page individually.

`Figure3-detail-4x.png` and `Figure6-detail-4x.png` show the exclusion box and
compact paired-swatch legend from the final vector PDFs at 384 dpi (4× final
size on a 96-dpi display). Full 4× views are retained too. Both details and
the greyscale/CVD previews were inspected. Protected Figure 1/2 files and all
numerical CSVs remain unchanged. See round11-report.md, “Round 11B-3”.
