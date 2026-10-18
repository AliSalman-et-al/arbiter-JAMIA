# Reproducible ARBITER figures

Figure 1 is a 174 × 125 mm workflow with plain-language actor/action labels and secondary grey tool names. Figure 2 is a 174 × 225.5 mm AVATAR storyboard: five domains link questions, quotations, AI answers, software checks, full answer chips and computed ratings. Its expanded D5 row explains the Some concerns result; a source strip, typed snippets, counter-evidence and open points show the basis of the answers. See STYLE-REFERENCE.md for the book's visual grammar.

## Build and verify

Run from this worktree root:

```powershell
uv sync --project analysis/figure1 --locked
uv run --project analysis/figure1 --locked python analysis/figure1/build.py --logs-root C:/Users/Ali-Salman/Documents/Analysis/arbiter-JAMIA --arbiter-root C:/Users/Ali-Salman/Documents/Code/ARBITER
uv run --project analysis/figure1 --locked python analysis/figure1/verify.py --data-root . --logs-root C:/Users/Ali-Salman/Documents/Analysis/arbiter-JAMIA --arbiter-root C:/Users/Ali-Salman/Documents/Code/ARBITER
uv run --project analysis/figure1 --locked python analysis/figure1/inspect_tiffs.py
```

All writes stay in this worktree. The bundle and versioned CSVs are read here; ignored logs are read from --logs-root. The ARBITER implementation and scientific-pack guidance are read-only references. Both figures are rebuilt. Frozen rejection-count CSV/JSON audits are retained; AVATAR tool/log audit hashes are rechecked.

Each build checks bundle manifest hashes, source linkage, all 22 question positions (15 active answers and seven inactive branches), domain/Overall ratings, ordered verbatim quote selections, verbatim justification excerpts and every semantic SVG row string, both Without ARBITER label exports, the uncited log claim, adjudicators' consensus, published D5 and the archived verified receipt. The D5 rule is checked against the scientific-pack Algorithm section. Figure 2's rendered text and extracted PDF text fail on eh_, sha256, underscore identifiers, span, adopted or proposal. Both figures retain the rob2 legacy-name guard.

Deliverables are analysis/output/manuscript/Figure{1,2}.{svg,pdf,png,tiff}. Figure 2 PDF is entirely vector with subset-embedded bundled Fira fonts. Figure 1 retains its vector diagram and embedded Fira fonts, with one faithful raster screenshot of the real HTML table (smallest captured text 7.08 pt); TIFF is PDF-rendered at 600 dpi with LZW compression. Minimum text is 7.0866 pt. SVG uses outlined glyphs. Source/model/software/person/check/cross glyphs use vectors. The qa directory includes final-size, PDF, greyscale and deuteranopia/protanopia/tritanopia proofs.

geometry.py checks actual SVG shapes and bundled-font glyph bounds: text/stroke clearance ≥0.3 mm, arrow/text clearance ≥0.8 mm, no text overlap, no overlapping pills, no unrelated-box penetration, and all content in frame. Height limits are 125 mm and 230 mm. verify.py runs seven geometry regression fixtures and compares 38 artifacts across two builds. inspect_tiffs.py tiles both 600-dpi TIFFs for complete coverage at 4× final size, recording crop bounds and final TIFF hashes in visual-inspection.json. Inspection images stay in ignored .inspection/. See visual-review.md for the clinician walkthrough and actual review.

Legends and alt text explain paraphrases, evidence types, source identities, verbatim model justification excerpts, counter-evidence, open points, archived verifier scope and the illustrative status of AVATAR. figure1-notes.md preserves full answers, evidence and source provenance. Full official questions and trace appear in eTable 31. Audit files store source identities and evidence quotations rather than complete trial PDFs. Overall was not adjudicated.

The exact run-build report now renders successfully with rob2-kit 2848c79 (0.13.0). Raw and product-name-only relabelled HTML are committed under html-report/. `relabel_report.py` is run by every figure build; it asserts byte equality with only the documented substitutions and writes full counts and a unified diff. No trial text, decision, number, CSS or layout is changed. The earlier 1.0.0 schema error is historical, superseded by the successful exact-build render.

To reproduce the original render and screenshots (all commands from this worktree root):

```powershell
uv venv "$env:TEMP/arbiter-avatar-2848c79"
uv pip install --python "$env:TEMP/arbiter-avatar-2848c79/Scripts/python.exe" C:/Users/Ali-Salman/Documents/Code/rob2-kit playwright
& "$env:TEMP/arbiter-avatar-2848c79/Scripts/rob2.exe" report kit-sonnet-5.5/bundles/banovic26-avatar-2024.rob2.zip --output analysis/figure1/html-report/raw
uv run --project analysis/figure1 --locked python analysis/figure1/relabel_report.py
& "$env:TEMP/arbiter-avatar-2848c79/Scripts/python.exe" -m playwright install chromium
& "$env:TEMP/arbiter-avatar-2848c79/Scripts/python.exe" analysis/figure1/screenshot_report.py
```

The report source must be commit 2848c7926a2acc25402345a42be39d695a99861a. Its non-editable installed module was verified under the temporary environment's Lib/site-packages, with direct_url.json dir_info `{}`. The renderer verifies the bundle before writing HTML. The thumbnail is a native 400 px responsive trial-page view, cropped to domain navigation and the first domain card. The full batch-summary table is also retained in QA. The AVATAR trial-page screenshot is retained separately at qa/avatar-html-report.png. Screenshots use headless Chromium 156.0.8078.4 through Playwright installed by uv, full-page proof viewport 780 × 1000 and detail viewport 400 × 900, device scale 2. No page styling is injected. The screenshot and HTML are frozen figure inputs, so rebuilding figures needs no browser installation.

Figure 2 has no curved annotation arrows. The evidence legend uses visual yellow/grey/dashed boxes, plus light not-needed hatching. Fingerprints are omitted. Recorded trace IDs map directly to the result pills; the D5 driver outlines 5.1. The scene checks every source/AI/server/result row string against the provenance CSV, then greps semantic aria-label strings in the final SVG. Source and algorithm citations, with file/line numbers, appear in figure1-notes.md.

The readability pass restores two representative grey tool labels per phase (all eight original labels), plus arbiter review/report. Figure 1 shows the audit file and the report as distinct outputs, with a smaller natural trial-page crop. Figure 2 uses 7.51 pt primary questions/answers, 7.09 pt secondary text, 12-unit primary leading and 11-unit quote leading, abbreviated domain headings and full-width counter-evidence/open-point lines. Repeated rule and quote-check lines are omitted, domain frames have uniform strokes, and source icons distinguish reports, registry and amendment.
