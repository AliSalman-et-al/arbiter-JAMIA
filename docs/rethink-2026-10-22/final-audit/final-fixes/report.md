# Final presentation fixes

Implementation and focused verification complete. **Parent independent visual reinspection of the changed pages and final staged site remains required; this is not a publication PASS.** No commit, push, deployment, nested agent, model run, bootstrap rerun, estimate change, or raw-input edit was performed. The five-main-figure/three-main-table scope, 53/60 primary result, Sonnet comparison, and full evidence remain.

## Mandatory finding disposition

| Finding | Source-based correction and evidence |
|---|---|
| Parent Table 3 consistency | `build_main_tables()` is a separate production stage, called before manuscript assembly. The assembler now rejects any mismatch in all three embedded versus standalone tables, including every cell and note, allowing whitespace differences. Current Word/PDF/HTML show 14/14 (100%). All affected proofs are generated together in the same Word export/raster pass. |
| Parent all-content JAMA spelling and P typography | Author prose, captions, alt text, general display labels and Figure 3 use American spelling: favored/favor, generalizability, organizations/emphasize, labeled, specialties, acknowledgments, judgment, gray, unrecognized. Main prose and supplement inference use italic uppercase P followed by “values.” Main Figures 4–5 were checked and their artwork is unchanged. |
| Parent Table 3 CI definition | Concise note defines Unassisted rule-break cells as No./total (%; 95% CI), with percentage bounds. Header stays concise. No value changed; standalone Table 3 remains one page and embedded cells/notes match exactly. |
| Parent HTML gutter/alignment | Native gt cells have 8px horizontal padding and explicit numeric alignment. Raw HTML fences prevent Quarto from interpreting gt CSS as Markdown; native tables disable Quarto processing. Browser computed-style checks confirm main numerical columns and all 3559 numeric cells in 98 supplementary tables are right-aligned, with 8px gutters, and no CSS paragraph leakage. |
| FVA01 / VB01 | Both eTables 2 and 16, including every continuation, define the ordered contrast as first named source minus second, in percentage points for exact agreement and coefficient units for κ. Unassisted-minus-Published rows retain their values. |
| FVA02 | Both shared `CI_NOTE` definitions now state “CI, 95% confidence interval” with the existing percentile-bootstrap method, review clustering, replicate count and seed. Local inferential notes, including support panels, receive the definition. |
| FVA03 | eTable 2A defines only unweighted Cohen κ, domain N=102, Overall (all) N=102 for the arms and common Overall (observed) N=81, excluding 21 missing Published labels. eTable 7 defines only displayed unweighted κ and exact agreement, with 102-domain/81-Overall populations; absent-metric and pooled-row metadata are removed. |
| FVA04 | eTables 13 and 13A locally expand Y/PY/N/PN/NI. eTable 13 defines a dash as no eligible source-specific question components. All 16 existing zero-N rows were checked: count=0 and their undefined rates remain dashes, not 0%. The N column in 13A is distinguished from answer-code N. |
| VB02 | Each answer block stays through its terminal Unassisted answer; question 4.3 and comparator are together on new p125. All evidence handle/source/page/lines/hash metadata stay with quote beginnings. Long quotes are divided only at whitespace into bounded paragraphs; explicit evidence-handle context precedes each continuation. All 241 original nonempty trace cells remain in sequence after ignoring added context labels. All 16 metadata/quote beginnings co-occur on their rendered pages. |
| VB03 | eFigures 1, 2, 4 and 5 now define all five domain names locally; 2, 4 and 5 also expand the answer codes and define the collapse. Every D1–D5 panel repeats its complete caption. Plots and stored values are unchanged. |
| VB04 | eFigure 4 points exactly to eTable 13, Full signalling question agreement, domain-summary rows, for existing numerator/denominator cells; it explicitly distinguishes source-specific eligibility from paired intersections in eFigures 2/5. Verified examples remain 208/306 versus 187/303 for Expert 1 D1 five-level. |

FVA05 is optional and was not changed: existing short comparison blocks retain repeated titles/columns/notes. This avoids additional pagination changes outside the mandatory fixes.

The earlier reported 100.0% versus 100% Table 3 discrepancy could **not** be reproduced in the retained `proof-jama` files at this task's inspection: both PDFs and the individually opened manuscript p12 PNG show 14/14 (100%). This observation is recorded in `focused-checks.json`; no old proof was modified to obtain it. The new assembly assertions and synchronized proof generation prevent a future embedded/standalone mismatch regardless of the earlier observation.

## Exact proof changes and carry-forward coverage

The final, current proofs are **`final-fixes/proof/`**. `proof-first-pass/` is this worker's superseded intermediate; do not review or publish it. Original `remediation/proof-jama/` and all prior review proofs remain untouched. All 145 old images referenced by the independent A/B coverage ledgers still match their recorded SHA-256 hashes (`retained-review-hashes.json`).

`proof/page-diff.csv` records old/new page text SHA-256 and PNG SHA-256, text/visual change flags and page counts for every page. `*-text.diff` contains word-level changes by page; `*-old.txt` and `*-new.txt` retain extracted page text. Rasterization uses the same Poppler, 105 dpi and PNG settings as the old proof. Hash-identical pages can carry their existing visual coverage forward. There are **114 changed/new page images and 61 unchanged images** among the 175 final pages. Supplement trace pagination increases 137 to 141 pages; all shifted/new pages are marked, with no omitted reflow.

| Artifact | Pages old → new | Changed/new visual pages | Hash-identical pages |
|---|---:|---|---|
| Manuscript | 23 → 23 | 1–3, 5–6, 8–10, 12–15, 19, 22–23 | 4, 7, 11, 16–18, 20–21 |
| Supplement | 137 → 141 | 2–3, 5, 9–24, 27, 40–52, 54–55, 58–68, 74–80, 84–86, 97–100, 105–141 | 1, 4, 6–8, 25–26, 28–39, 53, 56–57, 69–73, 81–83, 87–96, 101–104 |
| Table1 | 1 → 1 | None | 1 |
| Table2 | 1 → 1 | 1 | None |
| Table3 | 1 → 1 | 1 | None |
| TRIPOD-LLM | 8 → 8 | None | 1–8 |

`proof/bookmarks.csv` records every current Word bookmark, exact range text and actual printed destination page; `proof/bookmark-page-diff.csv` maps the heading text to old PDF page candidates and flags changes or ambiguity. Old DOCX bookmark IDs were not preserved in the original proof directory, so no invented old-ID equivalence is claimed. `proof/locators.csv` records all current display/trace destinations; `proof/boundaries.csv` records every page boundary. Contents has 53 checked destinations, including unchanged eFigure pages 105–117, AVATAR start p118 and prompt templates now p141. The current question-4.3 bookmark is p125; evidence records begin p127. Bookmark range destinations were obtained from Word, not guessed from filenames.

## Verification and practical limits

- `focused-checks.json` / `.log`: exact embedded/standalone main table text; actual italic P runs; tailored notes; 16 zero-eligibility rows; local caption definitions and denominator locator; all 241 trace cells; 82 metadata/context keep-with-next properties; raw export bytes unchanged; 49 non-Figure-3 artwork files unchanged.
- `invariance.json` / `.log`: **4639 protected files and 38 numerical exports**, zero mismatches against the accepted baseline. Protected Figures 1–2, expert/source material and analytical precision are unchanged. Figures 4–5 and every supplementary figure/panel also match this task's starting bytes.
- `verify-presentation.log`: all six editable Word inventories and native HTML inventories pass; 98 supplementary native gt tables; 62 HTML navigation anchors; original trace text retained.
- `manuscript-numbers.log`, `jama-check.log`: manuscript number/citation/word-limit checks and 642 frequency cells (292 with denominator below 100) pass. Main text is 2932 words; structured abstract is 229.
- `boundaries.log`: all **175 pages**, printed page numbers, 53 Word contents targets and supplementary table starts pass. `proof/page-checks.csv` has no empty or outside-page text.
- `trace-pagination.json` / `.log`: all 16 metadata blocks share pages with quote beginnings; continuation handles and question 4.3 location recorded.
- `browser-main.json`, `browser-supplement.json`: actual browser computed styles on production `analysis/results.html` and `analysis/supplement.html`; numeric alignment/gutters pass with zero CSS paragraph leakage. Parent still owns final staged/public site QA.
- `artifact-hashes.csv`: current production DOCX/HTML/main-figure and final proof hashes.

Worker individually inspected current standalone Table 3, manuscript p12 (including a readable crop), supplementary eFigure 4 p112, Figure 3, and new trace pages 125, 128–130, 133–134, 139–140. These confirm the changed layout patterns; **they do not replace the parent's independent reinspection of all 114 changed page images**. No uninspected page is claimed as an independent visual PASS.

Supplementary figure captions are deliberately 11-point single-spaced to keep the expanded standalone definitions beside full-size artwork, preserving readable figure labels. Supplement prose and trace remain double-spaced; table type remains 10 points. Main manuscript prose/captions remain double-spaced.

## Retained official spelling and other exceptions

“Cochrane risk-of-bias tool for randomised trials,” formal RoB 2 “signalling questions/answers,” and D1 “randomisation process” retain official terminology. Exact reference titles, trial quotes, AVATAR source/model responses (including judgement, analysed, centre, finalised and source P-value typography), verbatim prompts, identifiers and raw inputs retain their original text. Protected Figures 1–2 retain their artwork. The protected `legends-fig1-2.md` input is unchanged; the generated reader legend changes only its author-written “grey text” to “gray text.” Existing author-completion fields and archive DOI remain honestly pending.

## Reproduction and handoff

From `analysis/`, run `Rscript ../docs/rethink-2026-10-22/final-audit/final-fixes/rebuild.R`. This loads finalized exports and rebuilds presentation only; it does not resample. The normal supplement builder also emits the reporting map; its final eight page images are hash-identical, so its independent coverage carries forward. Only Figure 3 is regenerated; the PNG exporter now writes a fresh temporary image before replacement and checks success, avoiding a stale PNG when a Windows reader holds the prior image.

From the repository root, run `final-fixes/render-word.ps1`, `compare-pages.py`, `verify-focused.py`, `verify-trace-pagination.py`, `check-boundaries.py`, `verify-invariance.py`, and the existing manuscript presentation/number checks using the managed Python runtime. Re-render the two Quarto pages after Word updates fields. The retained `reassemble.R` is a focused main-document/normalization helper; the final source behavior is in the production assembler.

No mandatory implementation issue remains known. Parent owns the changed-page visual review, site staging/packaging and publication. Do not use prior proof paths for the changed-page recheck.
