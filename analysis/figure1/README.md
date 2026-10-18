# Reproducible ARBITER figures

Figure 1 is final and unchanged by this revision. Figure 2 is rebuilt as a 174 × 229 mm, three-panel illustration: A follows six numbered agent–server exchanges for AVATAR D5 question 5.1; B summarizes every domain answer pattern and judgement; C compares the same trial’s ARBITER and Unassisted D5 trajectories against the adjudicators’ preferred judgement. Read STYLE-REFERENCE.md for the PI’s visual grammar.

## Build and verify

Run from this worktree root:

```powershell
uv sync --project analysis/figure1 --locked
uv run --project analysis/figure1 --locked python analysis/figure1/build.py --logs-root C:/Users/Ali-Salman/Documents/Analysis/arbiter-JAMIA --arbiter-root C:/Users/Ali-Salman/Documents/Code/ARBITER
uv run --project analysis/figure1 --locked python analysis/figure1/verify.py --data-root . --logs-root C:/Users/Ali-Salman/Documents/Analysis/arbiter-JAMIA --arbiter-root C:/Users/Ali-Salman/Documents/Code/ARBITER
uv run --project analysis/figure1 --locked python analysis/figure1/inspect_tiffs.py
```

All writes stay in this worktree. Data and the AVATAR zip are read directly from this worktree; only ignored archived logs are read from --logs-root. --arbiter-root is a read-only implementation reference for tool definitions, guidance and the public bundle extension. build.py produces Figure2 only and retains the existing Figure 1 audit and exports. The standalone count_save_rejections.py remains available for the frozen Figure 1 audit.

Every build checks all manifest hashes, source-version linkage, canonical domain judgements and active/inactive answers, exact selected source/justification excerpts, archived official question numbers, label tables, adjudicator consensus, Unassisted D4’s invalid path, the seven-source inventory and the archived verifier receipt. avatar-tool-counts.json is a committed derived file asserted against the unique tool-use IDs and log hashes on every build. Its counts include failures and retries. Both illustrated D5 context passages were returned by read_pages during D5; Panel C deliberately uses selected whole-trial counts (15 context calls, 14 page reads and seven save calls), labelled “this trial”.

## Deliverables and rendering

analysis/output/manuscript/Figure2.{svg,pdf,png,tiff} are the only Figure 2 variants. The obsolete without-Unassisted variant has been deleted. qa/Figure2-* contains the 174 mm final-size proof, PDF proof, greyscale and full-severity approximate Machado deuteranopia/protanopia/tritanopia proofs. figure1-notes.md records full provenance, bound spans, source inventory, handles and exact tool attribution; legends-fig1-2.md provides the updated Figure 2 legend and alt text while preserving Figure 1 text.

Bundled OFL Fira Sans Condensed Regular/Bold and Fira Code supply all type. Minimum text is 7.0866 pt. SVG glyphs are outlined; vector PDF text uses subset-embedded Fira fonts and has no raster images. TIFF is rendered from PDF at 600 dpi with LZW compression. Check/cross and source/agent/person icons are vector line glyphs, not system-font symbols.

geometry.py checks the actual SVG shapes and bundled-font glyph bounds: text/stroke clearance ≥0.3 mm, arrow-tip/text clearance ≥0.8 mm, no overlapping pills or unrelated-box penetration, no text overlap, nothing outside the frame. The Figure 2 height gate is 230 mm. The legacy-name guard checks SVG and extracted PDF text. verify.py runs all seven geometry regression fixtures and builds twice, comparing the deliverables, proofs and audit bytes; it also hashes frozen Figure 1 files. inspect_tiffs.py tiles the Figure 2 600-dpi TIFF with complete coverage at 4× final size on a 96-dpi display, recording crop bounds and TIFF SHA-256 in visual-inspection.json. Tiles live in ignored .inspection/. See visual-review.md for the actual inspection.

AVATAR is illustrative, not representative. Adjudicators preferred D5 Some concerns; Overall was not adjudicated. The independent-verifier status is the archived structural/binding receipt, not a new verification execution or a claim of clinical validity. Source hashes identify searchable projections, not PDF bytes. Full trace: eTable 31.
