# Reproducible ARBITER figures

Figure 1 is a 174 × 107 mm workflow with plain-language actor/action labels and secondary grey tool names. Figure 2 is a 174 × 229.75 mm AVATAR storyboard: five domains link questions, quotations, AI answers, software checks, full answer chips and computed ratings. Its expanded D5 row explains the Some concerns result; a source strip, typed snippets, counter-evidence and open points show the basis of the answers. See STYLE-REFERENCE.md for the book's visual grammar.

## Build and verify

Run from this worktree root:

```powershell
uv sync --project analysis/figure1 --locked
uv run --project analysis/figure1 --locked python analysis/figure1/build.py --logs-root C:/Users/Ali-Salman/Documents/Analysis/arbiter-JAMIA --arbiter-root C:/Users/Ali-Salman/Documents/Code/ARBITER
uv run --project analysis/figure1 --locked python analysis/figure1/verify.py --data-root . --logs-root C:/Users/Ali-Salman/Documents/Analysis/arbiter-JAMIA --arbiter-root C:/Users/Ali-Salman/Documents/Code/ARBITER
uv run --project analysis/figure1 --locked python analysis/figure1/inspect_tiffs.py
```

All writes stay in this worktree. The bundle and versioned CSVs are read here; ignored logs are read from --logs-root. The ARBITER implementation and scientific-pack guidance are read-only references. Both figures are rebuilt. Frozen rejection-count CSV/JSON audits are retained; AVATAR tool/log audit hashes are rechecked.

Each build checks bundle manifest hashes, source linkage, all 22 question positions (15 active answers and seven inactive branches), domain/Overall ratings, ordered verbatim quote selections, key justification excerpts, both Without ARBITER label exports, the uncited log claim, adjudicators' consensus, published D5 and the archived verified receipt. The D5 rule is checked against the scientific-pack Algorithm section. Figure 2's rendered text and extracted PDF text fail on eh_, sha256, underscore identifiers, span, adopted or proposal. Both figures retain the rob2 legacy-name guard.

Deliverables are analysis/output/manuscript/Figure{1,2}.{svg,pdf,png,tiff}. PDF is vector, with subset-embedded bundled Fira fonts and no raster images; TIFF is PDF-rendered at 600 dpi with LZW compression. Minimum text is 7.0866 pt. SVG uses outlined glyphs. Source/model/software/person/check/cross glyphs use vectors. The qa directory includes final-size, PDF, greyscale and deuteranopia/protanopia/tritanopia proofs.

geometry.py checks actual SVG shapes and bundled-font glyph bounds: text/stroke clearance ≥0.3 mm, arrow/text clearance ≥0.8 mm, no text overlap, no overlapping pills, no unrelated-box penetration, and all content in frame. Height limits are 110 mm and 230 mm. verify.py runs seven geometry regression fixtures and compares 27 artifacts across two builds. inspect_tiffs.py tiles both 600-dpi TIFFs for complete coverage at 4× final size, recording crop bounds and final TIFF hashes in visual-inspection.json. Inspection images stay in ignored .inspection/. See visual-review.md for the clinician walkthrough and actual review.

Legends and alt text explain paraphrases, evidence types, source fingerprints, model justification summaries, counter-evidence, open points, archived verifier scope and the illustrative status of AVATAR. figure1-notes.md preserves full answers, evidence and source provenance. Full official questions and trace appear in eTable 31. Audit files store source identities and evidence quotations rather than complete trial PDFs. Overall was not adjudicated.

The ARBITER 1.0.0 HTML-report proof failed because this older archive has a `rob2-kit.bundle.v0.3` schema. Both figures therefore retain audit-file wording only. See qa/html-report-proof.md for exact commands and failure. No trial-page screenshot exists. The three annotation curves point to a quote-check line, the rule column and the No information pill. The optional fourth note was omitted to preserve the height and typography gates.
