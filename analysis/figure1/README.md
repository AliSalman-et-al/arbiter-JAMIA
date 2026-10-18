# Figures 1 and 2: workflow and AVATAR trace

Reproducible SVG illustration sources with bundled OFL Fira fonts. Figure 1 is a standalone workflow at 174 × 125 mm; Figure 2 is an AVATAR trace at 174 × 289 mm, with a provisional Unassisted column. No titles or panel tags appear inside either image.

## Build

From the repository root:

```powershell
uv sync --project analysis/figure1 --locked
uv run --project analysis/figure1 --locked python analysis/figure1/build.py --data-root C:/Users/Ali-Salman/Documents/Analysis/arbiter-JAMIA --arbiter-root C:/Users/Ali-Salman/Documents/Code/ARBITER
```

The main checkout is read-only. `--data-root` defaults to this worktree, but untracked run logs must be available there. The command fails if any analysis-set trial log is absent. `--arbiter-root` identifies the public ARBITER source checkout used to verify the tool definitions, CLI and bundle extension. Outputs always go to this worktree. No R code, unrelated figures, shared legends, tables or supplement files are changed.

The build reads and checks:

- All AVATAR manifest content hashes, canonical domain decisions, answer/basis types, bound evidence/source linkage and archived verifier receipt.
- Official question wording from archived MCP responses in AVATAR's logs, including the branching IDs for 2.4, 2.5 and 2.7.
- Exact selected quotes, justification excerpts, unknowns and Unassisted rationale from the bundle and final.md. Only whitespace and two PDF extraction word breaks are joined; omissions use ellipses.
- Published, ARBITER and Unassisted label CSVs, the consensus D5 adjudication cell and the Unassisted D4 invalid-path classification.
- All Sonnet save calls in exactly 102 analysis-set trial logs, matched by unique tool-use ID to results. The three unsupported-design trials are excluded. `count_save_rejections.py` can also run independently with `--data-root`.

## Outputs

`analysis/output/manuscript/`:

- `Figure1.{svg,pdf,png,tiff}`: workflow, without benchmark count.
- `Figure2.{svg,pdf,png,tiff}`: trace with Unassisted column.
- `qa/Figure2-without-unassisted.{svg,pdf,png,tiff}`: wider evidence rows at 174 × 276.75 mm; matching final-size, PDF, greyscale and CVD proofs use the same filename prefix.
- `qa/Figure{1,2}-{final-size,grayscale,deuteranopia,protanopia,tritanopia,pdf}.png`: visual proofs.
- `figure1-notes.md`: both figures' provenance, every displayed quote, full bound spans, handles, source IDs, pages, line ranges and complete hashes.
- `legends-fig1-2.md`: legends and alt text for integration by the parent task.

`analysis/figure1/`:

- `save-rejections.csv`: one row per call, including successful calls so the denominator is auditable, with domain and attribution source. Turn files are sorted numerically; unique call insertion order records chronology. One malformed JSON call retains its literal domain; one domain-less call is attributed only after asserting that both flanking retries name D1. Error excerpts exclude generic recovery/example boilerplate.
- `save-rejections-summary.json`: 637 calls, 53 rejections (32 evidence/basis construction; 21 other validation/input errors); AVATAR 1/7. All 47 trial-domain assessments with rejections ended successfully; 0/510 domains lacked an accepted save. All 53 rejected calls have a later accepted save in that domain, including one domain-less PALOMA-2 call contextually attributed to D1 and flagged in the CSV.
- `avatar-save-retry.json`: failed and accepted AVATAR basis objects and exact tool-use IDs.
- `qa.json`: physical dimensions, text minima, vector PDF, embedded fonts, and geometric clearance checks for all three layouts.
- `verify.py`, `reproducibility.json`: two-build byte comparison and artifact hashes.

## Rendering and QA

Coordinates are quarter-millimetres. All text is at least 7 pt at final width (Figure 1 minimum 7.23 pt; Figure 2 minimum 7.09 pt). SVG text is outlined from bundled Fira Sans Condensed Regular/Bold and Fira Code Regular, with accessible labels. PDF uses the identical glyph positions and subset-embedded Fira TrueType fonts; no raster images or system-font dependency. ReportLab draws the vector SVG shapes and text; PyMuPDF renders the vector PDF at 600 dpi for LZW TIFF. An independent resvg rendering supplies PNG previews. Standard-font resources introduced by the converter are unused and removed.

Accessible SVG text and extracted PDF text are checked for the forbidden legacy product-name substring. A 658-pixel proof approximates 174 mm on a 96-dpi display; the numeric dimension and point-size checks are authoritative. Greyscale and approximate Machado full-severity deuteranopia, protanopia and tritanopia proofs retain written evidence types, domain/answer labels and dashed inference borders. These RGB diagnostic transforms are not calibrated clinical simulations.

The supplied book pages 000202, 000090 and 000110 were inspected. Heavy rounded outlines, pastel role lanes, linked highlighting and curved keyword callouts follow their visual vocabulary. Final-size proofs, independent PDF proofs and all four diagnostic views were inspected after layout iteration.

Font provenance: Fira Sans Condensed Regular/Bold from the Google Fonts OFL distribution; Fira Code Regular from the local upstream OFL distribution. Fonts and licenses remain versioned in `fonts/`; rebuilding does not download fonts.

## Important interpretation

AVATAR's rejected D3 save flattened the span locator into the basis. The accepted retry nested that locator under `bases[].evidence`; it did **not** send a literal `eh_…` handle string. The server bound the reference and archived a handle. This corrects the brief's narrower account without changing the intended validation mechanism.

Context is lavender, direct support yellow, and inference an unfilled dashed outline. D5's missing dated source remains plain text because a context quotation cannot itself prove an absence. The footer compares D5 preferred judgements; Overall was not adjudicated. The verifier status is read from the archive, not re-executed, and does not establish clinical validity. See `DEVIATIONS.md` for scope and display decisions.

## PI fine-detail revision

All four numbered callouts use cubic Bézier arcs with tangent-aligned solid heads; the shaft ends beneath the head, and each tip stops 1.05 mm from the target text box. Labels sit in dedicated clear space and leaders shorten to nearby targets. Highlight rows have 18-unit pitch and 16-unit height (0.35 mm clear between their strokes). D4 question 4.4 has additional clearance above its inference box. Dashed boxes use fitted straight-run dash patterns joined to solid corners. Orange outlines include adjacent comma/period punctuation with padding; complete question–answer units wrap only at separators. No scientific wording changed, so the legends are unchanged.

Figure 1 places the red return between the server top edge and agent bottom edge, with its label in the gap. Neighbouring phases' black arrows are separated by at least 5 mm; the red arrow has at least 3 mm centreline separation from either neighbouring black arrow. The approval connector has one horizontal run and one vertical drop. Figure heights increase to preserve clearance and type size.

`geometry.py` parses the built SVG vector shapes, excluding glyph paths, and uses exact bundled-font outline extents from the scene text registry. It checks text against stroked paths and solid arrowheads with 0.3 mm clearance, non-nested pill/outline overlap, arrow tips against text with 0.8 mm clearance, tips penetrating unrelated boxes, text/text overlap, and frame containment. Layout containers may enclose children; their borders still have to clear text. Dashed paths use conservative continuous envelopes. Bézier sampling intervals are at most 0.0375 mm. Failed preflight writes all layout check reports to `qa.json` and stops before export.

`verify.py` runs seven regression fixtures before the double build and compares 36 output artifacts. `inspect_tiffs.py` produces 39 complete-coverage TIFF-derived crops at 4× final size in local `.inspection/`; `visual-inspection.json` records crop bounds and source TIFF hashes. See `visual-review.md` for every inspected region and final results.
