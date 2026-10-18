# Figure 1: ARBITER workflow and trace

Round 8b. Reproducible, programmatic book-style illustration, 174 × 204 mm.

## Build

From the repository root, with uv installed:

```powershell
uv sync --project analysis/figure1 --locked
uv run --project analysis/figure1 --locked python analysis/figure1/build.py --data-root C:/Users/Ali-Salman/Documents/Analysis/arbiter-JAMIA --arbiter-root C:/Users/Ali-Salman/Documents/Code/ARBITER
```

`--data-root` defaults to this repository. This worktree uses the main checkout's existing data in place. `--arbiter-root` must point to the ARBITER 1.0.0 checkout used to inspect the MCP definitions. No changes are made to either input checkout. Output paths always resolve to this worktree.

Inputs read at runtime:

- AVATAR `canonical.json`, all manifest-listed contents, cited evidence JSON and archived `verification.json`, directly from its ZIP.
- Published, ARBITER and Unassisted domain CSVs and the adjudication analysis cells CSV.
- MCP server definitions and the skill's Domain 5 guidance in ARBITER.

The build verifies manifest content hashes, evidence/source linkage, all six ARBITER strip labels against canonical records, D5's driver, the absence of an override and the adjudicators' preferred-label agreement. It checks required tool definitions and obtains their source line numbers dynamically. Clinical reasoning is faithfully summarized from the recorded justification; it is not independently re-adjudicated.

## Outputs and editing

`analysis/output/manuscript/` receives `Figure1.svg`, `Figure1.pdf`, `Figure1.tif`, `Figure1.png` and `figure1-notes.md`. Notes include all 18 tools, source references, the exact excerpt and locator, proposed/adopted judgements, a draft legend and alt text. The shared figure-legends document is outside this agent's ownership and is intentionally not edited; the lead can copy the draft legend there.

Edit `build.py` to change the scene. Coordinates are quarter-millimetres. All text is converted to vector paths with fontTools from the bundled Fira Sans Condensed Regular/Bold and Fira Code Regular OFL fonts. SVG includes accessible text labels and titles for each outlined text run. The PDF contains only vector paths, with no font or raster dependencies. The SVG is converted to PDF with svglib/ReportLab; resvg independently renders the PNG; PyMuPDF renders the vector PDF at 600 dpi for the RGB LZW TIFF. PDF metadata is invariant for repeatable builds.

Font provenance:

- Fira Sans Condensed Regular/Bold and `OFL.txt`: `https://github.com/google/fonts/tree/main/ofl/firasanscondensed`.
- Fira Code Regular: locally installed OFL distribution, bundled here with the upstream license from `https://github.com/tonsky/FiraCode/blob/master/LICENSE`.
- Fonts are versioned here so rebuilds never need a font download or installation.

## QA evidence

- `qa.json`: physical dimensions, minimum text size (7.23 pt), TIFF dimensions/metadata and trace identities.
- `qa-pdf.png`: 240-dpi render of the vector PDF, visually inspected against the independent resvg preview.
- `qa-final-size.png`: 658-pixel-wide proof, equivalent to 174 mm on a 96-dpi display. Screen scaling varies; physical dimensions and point sizes are checked numerically.
- `qa-grayscale.png`: no meaning depends on colour; all judgements and phase/actor distinctions have text and outlines.
- `qa-deuteranopia.png`: approximate diagnostic using the Machado deuteranopia matrix on display RGB, not a calibrated vision simulation. Together with grayscale it checks that colour shifts do not lose information.

Visual checks passed: no clipped/overlapping text; clear phase separation; approval arrow enters the domain phase; tool arrows represent requests and the final arrow represents packaging. The source excerpt and answer share yellow highlighting and remain linked by outlines in grayscale. Source locator and hash prefix are readable at final size. Pastel lanes, heavy rounded outlines, a single human icon, blue/lavender LLM typography, and dotted dividers follow the supplied book references. There is no overall title inside the figure; A/B have the requested panel headings.

## Trace interpretation

AVATAR 5.1 is No information. The 11-word excerpt is context, explicitly identified as such in the figure. A report describing an endpoint as prespecified does not itself date the analysis plan before unblinded data. The recorded answer considers the registry, reports and protocol amendment together. The displayed SHA-256 prefix identifies the searchable source projection, not PDF bytes. The archive's verifier receipt says verified; that result does not certify clinical correctness. No ASCET fallback was necessary.
