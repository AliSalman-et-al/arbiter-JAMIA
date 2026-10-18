# Figures 1 and 2: workflow and AVATAR trace

Reproducible SVG illustration sources with bundled OFL Fira fonts. Figure 1 is a standalone workflow at 174 × 112.5 mm; Figure 2 is an AVATAR trace at 174 × 223.875 mm, with a provisional Unassisted column. No titles or panel tags appear inside either image.

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
- `qa/Figure2-without-unassisted.png`: wider evidence rows at 174 × 214.125 mm; matching final-size, greyscale and CVD proofs use the same filename prefix.
- `qa/Figure{1,2}-{final-size,grayscale,deuteranopia,protanopia,tritanopia,pdf}.png`: visual proofs.
- `figure1-notes.md`: both figures' provenance, every displayed quote, full bound spans, handles, source IDs, pages, line ranges and complete hashes.
- `legends-fig1-2.md`: legends and alt text for integration by the parent task.

`analysis/figure1/`:

- `save-rejections.csv`: one row per call, including successful calls so the denominator is auditable, with domain and attribution source. Turn files are sorted numerically; unique call insertion order records chronology. One malformed JSON call retains its literal domain; one domain-less call is attributed only after asserting that both flanking retries name D1. Error excerpts exclude generic recovery/example boilerplate.
- `save-rejections-summary.json`: 637 calls, 53 rejections (32 evidence/basis construction; 21 other validation/input errors); AVATAR 1/7. All 47 trial-domain assessments with rejections ended successfully; 0/510 domains lacked an accepted save. All 53 rejected calls have a later accepted save in that domain, including one domain-less PALOMA-2 call contextually attributed to D1 and flagged in the CSV.
- `avatar-save-retry.json`: failed and accepted AVATAR basis objects and exact tool-use IDs.
- `qa.json`: physical dimensions, text minima, vector PDF and embedded font checks.
- `verify.py`, `reproducibility.json`: two-build byte comparison and artifact hashes.

## Rendering and QA

Coordinates are quarter-millimetres. All text is at least 7 pt at final width (Figure 1 minimum 7.23 pt; Figure 2 minimum 7.09 pt). SVG text is outlined from bundled Fira Sans Condensed Regular/Bold and Fira Code Regular, with accessible labels. PDF uses the identical glyph positions and subset-embedded Fira TrueType fonts; no raster images or system-font dependency. ReportLab draws the vector SVG shapes and text; PyMuPDF renders the vector PDF at 600 dpi for LZW TIFF. An independent resvg rendering supplies PNG previews. Standard-font resources introduced by the converter are unused and removed.

Accessible SVG text and extracted PDF text are checked for the forbidden legacy product-name substring. A 658-pixel proof approximates 174 mm on a 96-dpi display; the numeric dimension and point-size checks are authoritative. Greyscale and approximate Machado full-severity deuteranopia, protanopia and tritanopia proofs retain written evidence types, domain/answer labels and dashed inference borders. These RGB diagnostic transforms are not calibrated clinical simulations.

The supplied book pages 000202, 000090 and 000110 were inspected. Heavy rounded outlines, pastel role lanes, linked highlighting and curved keyword callouts follow their visual vocabulary. Final-size proofs, independent PDF proofs and all four diagnostic views were inspected after layout iteration.

Font provenance: Fira Sans Condensed Regular/Bold from the Google Fonts OFL distribution; Fira Code Regular from the local upstream OFL distribution. Fonts and licenses remain versioned in `fonts/`; rebuilding does not download fonts.

## Important interpretation

AVATAR's rejected D3 save flattened the span locator into the basis. The accepted retry nested that locator under `bases[].evidence`; it did **not** send a literal `eh_…` handle string. The server bound the reference and archived a handle. This corrects the brief's narrower account without changing the intended validation mechanism.

Context is lavender, direct support yellow, and inference an unfilled dashed outline. D5's missing dated source remains plain text because a context quotation cannot itself prove an absence. The footer compares D5 preferred judgements; Overall was not adjudicated. The verifier status is read from the archive, not re-executed, and does not establish clinical validity. See `DEVIATIONS.md` for scope and display decisions.

## PI revision

Answer pills follow questions, including 4.4; labelled Justification lines distinguish the agent’s words from source quotations. D5 and Overall chips have pale ARBITER-blue fill, and D5 has a heavier border. All four numbered curved arrows touch their targets without crossing glyphs. The unknown is grey with a bold label and an adjacent callout. The Unassisted comparison uses the same unfilled orange outline (#DF8F44) for all three author-flagged issues: 4.3 NA, the unblinding phrase and the registered-time-frame phrase, with no gutter-crossing arrows. The legend and alt text identify these as author flags. The Unknown label has a five-unit gap before its text, with wrapped lines aligned under the text start. The Unassisted explanatory notes wrap to two lines to preserve ≥7 pt type in the narrow column. Main quote, question and justification type increased from 7.30 to 7.51 pt.

Figure 1 moves the assessment request/response arrows outward and places a straight red return between the response text and black up-arrow. The red return runs continuously through the server lane to its pill below the lane, using the broader invalid-or-unbound wording. The count variant has been removed; the legend holds the precise rejection and recovery counts. The Overall rule uses plain language.
