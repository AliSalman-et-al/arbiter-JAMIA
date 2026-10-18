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
