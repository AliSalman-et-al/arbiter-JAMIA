# Results and supplement HTML refresh

Status: PASS for finalized-source HTML generation, content/integrity verification and complete package staging. No statistical analyses were recomputed. No commit, push, deployment or publication command ran. A new visual-layout audit remains unverified because browser captures failed.

This fresh worker round follows `publishing-report.md` and resolves its existing-results/supplement packaging blocker. The style contract and accepted `docs/rethink-2026-10-22/final-audit/acceptance.md` were read. The earlier `parent-final-review.md` is a historical corrections-pending review; the later acceptance governs the finalized artifacts. The manuscript pipeline and its previous Word proof are outside this worker's ownership and must still receive the parent's final manuscript checks.

## Owned changes

- `analysis/results.qmd`: removes R analysis/presentation imports and missing gt QA fragments; includes generated finalized-source content, uses shared table styling and links to the manuscript.
- `analysis/supplement.qmd`: removes the obsolete personal Windows Python path and R conversion chunk; includes generated finalized-source content and links to the manuscript.
- `scripts/report-refresh.py`: portable Python/Quarto HTML-only refresh and integrated source-equality checks. Reads final Table1–3.docx, Supplement.docx, results-sentences.md, figure-legends.md and final images. Uses shared `manuscript-sources.py` legend/alt metadata without editing it. Pandoc converts the finalized gt-produced Word tables to native HTML. The existing `native-table-html.py` requires unavailable gt HTML fragments, so the helper retains its heading/contents policy without needing those fragments or modifying the converter. Tables retain horizontal rules, readable shared 10-point type, cell gutters and scroll containers.
- `analysis/README.md`: documents prerequisites, invocation, generated includes, evidence and the distinction between an HTML refresh and a full R presentation build.
- `analysis/results.html` and `analysis/supplement.html`: rebuilt locally; these follow the repository's existing ignored-HTML convention.
- This report.

Disposable generated includes/media and `analysis/.quarto/report-refresh-verification.json` are ignored. The evidence file records protected-file SHA-256 hashes, rendered HTML hashes and inventories.

No edits were made to canonical manuscript/reference sources, shared metadata, `scripts/build-manuscript.py`, statistical CSVs, figures, standalone Word tables, Supplement.docx or TRIPOD-LLM.docx. Manuscript.docx belongs to the concurrent parent workflow and is intentionally excluded from this worker's invariance assertion.

## Commands and results

From the repository root:

```sh
/home/ali/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/bin/python scripts/report-refresh.py
python3 scripts/stage-pages.py /tmp/arbiter-report-refresh-pages
python3 scripts/stage-pages.py /tmp/arbiter-report-refresh-pages --check-only
python3 scripts/test-pages.py
python3 -m py_compile scripts/report-refresh.py
git diff --check
```

All pass. The interpreter has python-docx and lxml; Quarto is on PATH. No R restore, analysis function, resampling, table/figure rebuild or Word assembly was invoked.

- Results: exactly three native tables and five embedded final figures. Every origin cell and note matches the finalized standalone Word tables. Results paragraphs match `results-sentences.md`; all five complete captions and alt texts match finalized/shared metadata. All five embedded PNG byte streams equal the final Figure1–5.png files. No Table4.docx link remains.
- Supplement: exactly 98 native tables, 13 embedded images, 62 contents links, 288 retained paragraphs (including table paragraphs), and all 233 finalized AVATAR trace paragraphs. All source table values, notes and order match Supplement.docx. Every extracted Word-image byte stream equals its embedded HTML counterpart. The historical accepted audit counted 241 original trace cells; this finalized Word document represents the trace as headed paragraphs. This worker preserves that finalized representation rather than reconstructing an older trace table.
- Equality handles Word vertical-merge continuation cells as HTML rowspans and ignores whitespace plus Pandoc's U+FE0E text-style selector on arrow glyphs. It does not change source values or discard nonempty cells.
- Both pages: unique IDs, resolving in-page fragments, embedded images and manuscript navigation pass. The existing project navigation include and packager insertion put manuscript navigation on every staged page.
- Invariance: all 155 protected artifacts are byte-identical before/after the refresh: 98 CSVs, five standalone DOCX files, 20 PNGs, 20 PDFs, 10 TIFFs and two SVGs.
- Full package: 50 files staged; all 54 local file links resolve. Nine Pages packaging tests pass. The previous `results.html: output/manuscript/Table4.docx` staging failure is resolved.

## Boundaries and remaining verification

The helper is the supported build entry point for these two HTML pages. On a fresh checkout, their `.quarto/*-page.md` includes do not exist until the helper runs. Direct Quarto rendering does not refresh those includes. The full existing R presentation builder still requires its R dependencies; if using it, prepare the includes with the helper first and rerun the helper after it changes finalized sources. This worker did not change the parent-owned publication/manuscript builders. The README documents this ordering. The HTML-only path itself works without R packages.

T3 preview opened the staged results page, but both snapshot calls returned `Preview automation snapshot timed out after 15000ms.` The permitted local Chrome fallback produced blank screenshots, including a retry with a virtual-time budget. These are failed capture attempts, not visual evidence. No new browser layout pass is claimed. Content/DOM/image-byte/source-equality checks passed; the parent should inspect rendered layouts before release under the style contract. Prior accepted Word/figure proofs were not regenerated or replaced.

Staging uses the current manuscript HTML present in the checkout. After the parent finishes canonical prose/Word changes, rerun its manuscript builder and stage again; this report makes no claim that those concurrent manuscript edits have received final approval or live verification.
