# Figures 1 and 2: workflow and AVATAR engineering trace

Reproducible vector illustrations with bundled OFL Fira fonts. Figure 1 is 174 × 107 mm. Figure 2 is 174 × 224.25 mm; the identical-layout variant without the Unassisted strip is 174 × 201.75 mm. Figure 2 replaces the former document layout and per-domain Unassisted column with aligned Evidence → LLM agent → ARBITER server lanes.

## Build

From this worktree root:

```powershell
uv sync --project analysis/figure1 --locked
uv run --project analysis/figure1 --locked python analysis/figure1/build.py --data-root C:/Users/Ali-Salman/Documents/Analysis/arbiter-JAMIA --arbiter-root C:/Users/Ali-Salman/Documents/Code/ARBITER
uv run --project analysis/figure1 --locked python analysis/figure1/verify.py --data-root C:/Users/Ali-Salman/Documents/Analysis/arbiter-JAMIA --arbiter-root C:/Users/Ali-Salman/Documents/Code/ARBITER
uv run --project analysis/figure1 --locked python analysis/figure1/inspect_tiffs.py
```

The main checkout is a read-only data source. All writes use this worktree. `--data-root` defaults to the worktree, but the archived bundles and untracked run logs must be available there. `--arbiter-root` supplies the public ARBITER implementation used to verify representative tools, CLI and bundle extension. No unrelated figures, shared manuscript legends, tables or supplement files are changed.

## Data assertions

Every build checks all AVATAR manifest file hashes; canonical domain decisions; basis types and source-version linkage; exact selected quotations, reasoning and unknowns; official question wording and numbered guidance locators from archived MCP responses; published, ARBITER, Unassisted and adjudicated labels; the archived verifier receipt; and the Unassisted D4 invalid-path classification.

All server answer chips come from `domain_records[...].answers`; inactive chips come from `inactive_questions`. Official numbers come from archived guidance locators, with unique-number assertions. The 15 active answers / seven inactive questions are asserted. The bundle strip reads seven captured sources with valid projection hashes, 16 archived evidence JSON records and `verification.json` status verified. Source-hash prefixes refer to searchable projections, not PDF bytes.

The rejection audit scans exactly 102 analysis-set Sonnet trials, matching unique save-call tool-use IDs to results. The build asserts 637 calls, 53 rejections, 32 evidence/basis errors and 21 other input errors; all affected domains and all rejected calls recover with later accepted saves. Figure 1 moves this information into the legend, removing the red return arrow and its label. `count_save_rejections.py` also runs independently with `--data-root`; its CSV includes successes, retry chronology and the explicitly flagged contextual attribution of one domain-less PALOMA-2 call to D1.

## Layout and outputs

Figure 1 retains four role lanes and phase-aligned request/response arrows, with at least 3 mm between neighbouring phase arrows and one orthogonal approval bend. Smaller agent/server and server/bundle gaps restore a compact height. Figure 2 uses row heights driven by the tallest of its three cells, centred left-to-right gutter arrows and a fixed right-hand judgement column aligned across D1–D5 and Overall, white evidence cards, lavender agent cells and mint server cells. Yellow means direct support, pale grey means context and an unfilled dashed outline means inference. Selected questions have heavier chip outlines; inactive questions have diagonal hatch fills, grey numbers and solid grey outlines. Pale-blue chips identify Some concerns. There are no numbered callouts. Only D4 and D5 appear in the pale-orange Unassisted contrast strip; the yellow bundle strip has no rejection item.

`analysis/output/manuscript/` contains:

- `Figure{1,2}.{svg,pdf,png,tiff}` and `qa/Figure2-without-unassisted.{svg,pdf,png,tiff}`.
- Matching `qa/*-{final-size,grayscale,deuteranopia,protanopia,tritanopia,pdf}.png` proofs. Obsolete Figure 1/2 QA suffixes from earlier designs are removed; other figures’ proofs are untouched.
- `figure1-notes.md`: every displayed quote and reasoning excerpt, full bound spans, handles, source/page/lines/full hashes, complete server answer patterns and bundle-strip source inventory.
- `legends-fig1-2.md`: current legends and alt text, ready for parent integration.

`analysis/figure1/` contains the save-call audit, AVATAR retry record, `qa.json`, `reproducibility.json` and `visual-inspection.json`. `verify.py` runs seven geometry regression fixtures and builds twice, comparing every export/audit/proof artifact byte for byte. `inspect_tiffs.py` tiles all three TIFFs with complete coverage into local, ignored `.inspection/` crops at 4× final size on a 96-dpi display; the manifest records source TIFF hashes and crop bounds. See `visual-review.md` for inspection evidence.

## Hard rendering gates

Coordinates are quarter-millimetres: 696 units = 174 mm. Text is at least 7 pt (Figure 1 7.23 pt; Figure 2 7.09 pt). SVG text is outlined from bundled Fira Sans Condensed Regular/Bold and Fira Code Regular; PDF uses identical positions with subset-embedded Fira TrueType fonts and no raster images. TIFFs are rendered independently from vector PDFs at 600 dpi with LZW compression; resvg supplies PNG previews. Fonts and OFL licences are versioned; no system-font lookup or font download is needed.

`geometry.py` checks the actual SVG shapes against exact bundled-font glyph extents: text/stroke clearance ≥0.3 mm, no overlapping non-nested pills/outlines, arrow-tip/text clearance ≥0.8 mm, no unrelated-box penetration, no text overlap and no content outside the frame. Layout containers may enclose their own children; borders still clear text. Dashed paths use conservative continuous stroke envelopes; curve sampling intervals are ≤0.0375 mm. Failure stops the build **before export**. Figure 1 has a 110 mm height gate; Figure 2 retains an explicit 235 mm hard gate and also asserts the stricter 225 mm polish target (within the 230 mm design limit).

SVG labels and extracted PDF text retain the `rob2` legacy-name guard. Final-size, greyscale and approximate Machado full-severity CVD proofs complement the physical dimension and geometry checks. CVD transforms are diagnostic RGB approximations. The supplied book pages 000202 and 000037 were inspected; heavy rounded card outlines, role pastels and linked highlighter text follow that illustration vocabulary.

AVATAR is illustrative, not representative. The footer compares adjudicated **D5**, not an adjudicated Overall. The verifier is an archived structural/binding receipt, not a new execution or evidence of clinical validity. The accepted AVATAR D3 retry nested a span locator under `bases[].evidence`; it did not submit a literal handle string. The server subsequently archived the bound handle. See `DEVIATIONS.md` for display decisions.
