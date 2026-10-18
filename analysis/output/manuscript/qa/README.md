# Round 8a visual checks

`*-pdf-1.png` renders the actual vector PDF at 160 dpi. Each
`*-accessibility.png` shows greyscale (top left), protanopia (top right),
deuteranopia (bottom left), and tritanopia (bottom right), at severity 1.
Individual simulated images retain the original preview dimensions.

Rebuild from analysis/:

1. On Windows, run `powershell -File install-fonts.ps1` before starting R/Quarto.
2. Run `quarto render` (the project uses renv).
3. Run `Rscript qa-round8a.R`.
4. Run `powershell -File render-word-qa.ps1`, then `Rscript render-qa-pages.R`.
5. Run `Rscript verify-round8a.R` and the testthat suite.

Word is opened in a dedicated hidden instance, read-only. The source documents
are never saved by Word. Full Word PDFs, page PNGs and contact sheets are local
QA intermediates, excluded from Git. Officer independently confirms editable
tables and extracts the text into the committed `.docx.txt` files.

All regenerated figures were visually reviewed in colour, PDF rendition,
greyscale and all three simulations. Shapes, positions, printed counts and
explicit category labels retain the meaning when colours become similar.
All four main tables occupy one page, Supplement occupies 37 pages and the
checklist occupies two pages in the Word renderer. Every page was inspected.

The prohibited-name scan covers the six Word documents, Figures 2-5/eFigure 1,
both HTML views and both legend copies. The unchanged Figure 1 slot in results
is explicitly excluded, because another worktree owns it and its replacement.
Frozen machine-readable CSVs and legacy figure files are not publication views.
The clinical phrase “baseline balance” remains verbatim in the model override
rationale; it is not a source name.
