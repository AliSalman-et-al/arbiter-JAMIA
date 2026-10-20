# Round 13 manuscript polish

Parent commit: `7c3474a` on `main`. Work was performed directly in this checkout and committed locally; no push.

## Q1–Q8 implementation

- **Q1 — Overall compliance:** Table 3 now has one row, “Overall rating follows the RoB 2 rules (incl. permitted escalation)”, showing **102/102 (100.0%) in both arms**. The note identifies the single permitted ARBITER escalation. The supplement retains the separate exact-agreement and escalation counts for auditability.
- **Q2 — Rule breaks:** “Algorithm violation” → “Rating contradicts its own answers”; “Invalid answer path” → “Required question skipped”; “Any departure” → “Any rule break”. Domain totals use “D1 rule breaks”, etc. Audit labels now describe quoted text, image regions and source links; “Bundle passes independent verification” → “Audit file passes the independent verifier”. The main note uses short sentences and removes hash-bound/active-answer/bundle jargon. Shared supplementary rows use the same labels.
- **Q3 — Plain labels:** Figure 5A uses “Both adjudicators agreed”, “Adjudicator 1”, “Adjudicator 2” and “Counting split decisions against ARBITER”; its axis and count header match the approved wording. Figure 5B uses the approved disagreement axis. Figure 3 replaces analysis-set/disputed/consensus/split-cell labels with inclusion, ratings reviewed and adjudicator decisions; its terminal counts remain 62 and 18. Figure 6 uses “Ratings the adjudicators did not choose”, with plain, non-bold, two-line facet totals. Table 2 replaces positive N with “Some concerns or High: N”, explains specificity as the share of published Low ratings also rated Low, and uses the adjudicators’ agreed choice. Its approved shortened title is “ARBITER detected more flagged risk, with lower specificity”. Table 4 uses independent ratings, ratings chosen after seeing labels, and own-rating comparisons. Figure 3–6 legends use matching plain language (65, 86, 94 and 94 words); finding titles are retained.
- **Q4 — Flow styling:** Figure 3 remains 174 × 120 mm. Rounded neutral boxes have approximately 1.5-mm corners and 1.2-pt black outlines; exclusions have a dashed outline. Black arrows have filled heads and clearance from their target boxes. Counts/titles use the genuine Fira Sans Condensed bold font, now vendored alongside the regular face. Arm chips use blue/orange and their Haiku tints. The font file was copied from the existing protected asset; no file in `analysis/figure1/` was modified. The font installer skips identical installed bytes to avoid Windows font-file locks.
- **Q5 — Intervals:** Count estimates and their CIs share one pair of parentheses, e.g. `114/154 (74.0%; 68.2–79.9)`. Coefficients use `0.34 (0.26–0.42)`, including en dashes for intervals crossing zero. Table 2 retains its existing percentage-only estimates and block denominators; percentage signs now make those cells explicit. Shared supplementary formatters use the same punctuation. Results retain their existing prose count form and CI numbers.
- **Q6 — Benchmark table:** Journal and Year merge into “Journal and year”. Column widths are explicitly **1.46, 1.15, 2.50, 0.40, 0.92, 0.54 inches**, totalling the 6.97-inch page text width. Topic is wider; native Word rendering shows 13 of 16 topics within two lines. The published-label header is “Published D1–D5 labels (Low/SC/High)”; it wraps because the complete single-line header cannot fit at the retained 9-pt size in the available portrait width. All values and full journal/year text remain present.
- **Q7 — Direct labels:** Figure 4B names its three segments once on the All bar and removes that panel’s legend. Figure 5B places source-choice labels and Published upheld inside sufficiently wide segments; smaller segments retain their counts. Its four-entry legend is removed, with only a one-line Other label explanation. Labels are at least 7 pt and were visually checked.
- **Q8 — Results:** “16 meta-analyses…” → “Sixteen meta-analyses…”. Figure 4 reports 78/129 as the data-derived **60.5%**. Figure 6 accurately distinguishes **47 eligible Unassisted losses**, **29 with at least one question that alone changed the rating**, and **18 without one**; question 5.1 changes the rating in 18 of the 47 eligible losses. The 29 is not the overall eligibility denominator. Sentences are regenerated from the frozen CSVs.

`GLOSSARY.md` and the Round 13 section of `ANALYSIS-PLAN.md` record the reader labels and approved decisions. Six main figures and four main tables remain.

## Numerical invariance

`verify-round13-numbers.py` compares every number token in the complete results sentences and all four Word tables, including their titles and notes. Complete before/after streams are saved in `output/manuscript/qa/round13-number-token-streams.json`; the exhaustive changed-span diff is `output/manuscript/qa/round13-number-token-diff.txt`.

Every numeric body value in Tables 1, 2 and 4 is identical. Table 3 changes only the approved Overall display: ARBITER’s 101/102 exact agreement plus 1/102 permitted escalation becomes 102/102 compliance; Unassisted’s 102/102 plus 0/102 becomes the same single row. The component counts remain in the supplement. No estimate, interval, count or estimand was recomputed differently.

The literal token streams are not wholly identical, for the author-approved reasons above: results add 60.5 and 47, and spell out 16; Table 3 consolidates its Overall row and changes the note’s label references; Table 4 adds “95” in the CI-format explanation. Tables 1 and 2 have completely identical number-token streams. The audit explicitly records these differences rather than treating them as unchanged tokens.

All **1,474** frozen CSV and protected-artwork files checked match the parent state (CSV line endings normalised for Windows). `analysis/data-derived/`, statistical CSV contents, Figures 1–2 and `analysis/figure1/` remain unchanged. Rebuilt files whose content did not change were restored to avoid metadata-only binary diffs.

## Reproduction and validation

Commands were run from `analysis/`:

1. `quarto render` (full numerical pipeline; both reports succeeded).
2. `Rscript run.R` (succeeded on retry after a Windows read/write file lock during concurrent testing).
3. Display iterations: `ARBITER_PRESENTATION_ONLY=1 quarto render`, then `quarto render results.qmd` with that environment variable for final main-layout/font corrections. The final supplement HTML uses the current supplementary display code.
4. `Rscript -e "testthat::test_dir('tests/testthat')"`; saved results: `output/manuscript/qa/tests-round13.rds` and `.txt`.
5. `./render-word-qa.ps1` (native, hidden Microsoft Word; source documents opened read-only); PDF pages rendered with `pdftools::pdf_convert`.
6. `Rscript verify-round13.R` and `python verify-round13-numbers.py`.

The suite passes **615 assertions** with no failures, errors, test warnings or skips. Numeric checks were retained. Superseded single-line checks for intentionally wrapped prose columns were replaced by complete Word-PDF text checks; numeric values still have single-line checks. New Round 13 assertions check merged journal/year display, page width, both Overall counts, the Table 4 CI string and numeral-free sentence starts. R emits environmental startup locale warnings, separate from test warnings.

Visual QA viewed every final Figure 3–6 PNG at full image size, Figure 3 at 320 dpi, all four main tables as native Word PDF/PNG, and the affected supplementary agreement/audit/reliability pages. All main tables fit one page. No text overlap or clipping remained. Supplement pagination is 51 pages, including 9 landscape AVATAR trace pages (pages 4–12); all 16 complete distinct evidence quotes are retained. The PDF verifier checks embedded Fira fonts, text at least 7 pt, 174-mm figure width, 600-dpi LZW TIFFs, clean reader labels/codes, full Word table text, complete verbatim supplementary quotes, and six current PNGs embedded in the HTML.

## Review artifacts

Paths are relative to `analysis/`:

- `output/manuscript/Figure3.png`, `Figure4.png`, `Figure5.png`, `Figure6.png` (PDF and TIFF companions alongside).
- `output/manuscript/qa/round13-Figure3-zoom-1.png` (320 dpi).
- `output/manuscript/qa/round13-Table1-1.png` through `round13-Table4-1.png`.
- `output/manuscript/qa/Table1-word.pdf` through `Table4-word.pdf`.
- `output/manuscript/qa/Supplement-word.pdf`; inspected PNGs `round13-Supplement-21.png`, `-22.png`, `-23.png`, `-26.png`, `-27.png`, `-30.png`.
- `output/manuscript/qa/verify-round13.txt`, `tests-round13.txt`, `run-round13.txt`, `render-round13.txt`, `render-round13-final-results.txt`, `word-round13.txt`.

The only layout concession is the conditional single-line Table 1 published-label header: it wraps at the retained size. No requested task is otherwise outstanding. No push was performed.

## Round 13b

Parent commit: `116fd4b`. This reviewer pass supersedes the earlier Round 13 decisions about negative CI separators, the shortened Table 2 title and the Table 1 header concession. Work remained display-only, directly in this checkout; no push.

### Changes

- Restored ` to ` whenever either CI bound is negative; positive-only intervals retain the en dash. The shared main/supplement formatter and report formatters agree. Estimates and bounds are unchanged.
- Table 1 explicitly displays `Published D1–D5 labels` and `(Low/SC/High)` on two lines. Word joiners keep the range together and nonbreaking spaces keep the first line together. Its column widths are now 1.46, 1.15, 1.92, 0.40, 1.50 and 0.54 inches (6.97 inches total). A thin rule precedes Total, and the Total label is bold. All topics and values remain present on one page.
- Table 2 uses “ARBITER detected more of the risk flagged by published reviews, at lower specificity” in its shared title source, Word output and rendered report. Table 3 block headings use “Domain ratings (D1–D5)” and “Overall rating”.
- Figure 3 has equal-width, equal-height branch pairs centred symmetrically under the main column. Both adjudicator-decision labels fit one line. Each arm chip pair immediately precedes its label; the complete key is centred using measured text widths. The legend identifies dark Sonnet and light Haiku chips and remains below 120 words. The size remains 174 × 120 mm.
- Figure 4A uses “Weighted κ with published label (95% CI)”. Figure 5B has a light-grey Other label swatch and four complete “adjudicators split on …” labels. Retaining the original bar width avoids collisions between the direct labels inside its final bar; all right-hand labels fit within the page.
- The Figure 3 results sentence spells out “four arms” from the CSV-derived arm count. The Figure 6 sentence is exactly the requested wording, with every number obtained from CSVs. An independent audit of distinct primary Unassisted loss records verifies 47 eligible ratings, 29 with at least one deciding question, and 18 where question 5.1 alone changes the rating. The separate 18 without a deciding question is no longer repeated in that sentence.

### Number invariance and validation

`verify-round13b-numbers.py` compares against `116fd4b`. Every number token in Tables 1–4 and the complete supplement is identical, including titles and notes. Figures 3–6 have identical complete number multisets (layout may change PDF reading order). The results stream matches only the two authorised prose replacements, with Figure 6 independently reconciled to the underlying cell CSV. All 145 tracked CSV/protected files and all 1,474 files in the Round 13 frozen-input/artwork manifest pass. Windows checkout filters are honoured for tracked text; CSV line endings are normalised. No CSV, statistic, count or file under `analysis/figure1/` changed.

Reproduction, from `analysis/`:

1. `quarto render` — full numerical pipeline and both reports passed.
2. `Rscript run.R` — standalone full rebuild passed.
3. `ARBITER_PRESENTATION_ONLY=1 quarto render`, followed by presentation-only `quarto render results.qmd` for the final Word header correction — passed.
4. `Rscript test-round13b.R` — **626 assertions passed**, zero failures, errors, test warnings or skips. The runner saves the complete test result and assertion count.
5. `./render-word-qa.ps1` — native hidden Word export with read-only source opens; `pdftools::pdf_convert` produced the table PNGs. Table 1 was also exported during the header-fit iteration.
6. `Rscript verify-round13b.R` and `python verify-round13b-numbers.py` — passed. The R check retains all Round 13 publication checks, verifies the exact two-line header in the Word PDF and checks all Figure 3–5 text bounds.

Full-size visual inspection covered Figure 3, 4 and 5 PNGs and all four native Word table PNGs. No overlap or clipping remains; each main table fits one page. The supplement remains 51 pages, including the nine AVATAR trace pages, with all 16 complete distinct evidence quotes verified. Environmental R startup locale warnings are separate from test warnings. Unchanged Figure 6/eFigure PDF rebuilds were restored after verifying their PNG and TIFF bytes were identical; the unchanged TRIPOD document was restored after checking that only its core metadata differed.

### Review artifacts

Paths below are relative to `analysis/`:

- `output/manuscript/Figure3.png`, `Figure4.png`, `Figure5.png` (PDF/TIFF companions alongside).
- `output/manuscript/qa/round13b-Figure3-zoom-1.png` (320 dpi).
- `output/manuscript/qa/round13b-Table1-1.png`, `round13b-Table2-1.png`, `round13b-Table3-1.png`, `round13b-Table4-1.png` (native Word, 160 dpi).
- `output/manuscript/qa/Table1-word.pdf` through `Table4-word.pdf`, and `Supplement-word.pdf`.
- `output/manuscript/qa/round13b-number-audit.txt` and `round13b-number-token-streams.json`.
- `output/manuscript/qa/tests-round13b.txt`, `tests-round13b.rds`, `tests-round13b-console.txt`, `verify-round13b.txt`, `word-round13b.txt`.
- `output/manuscript/qa/render-round13b.txt`, `run-round13b.txt`, `render-round13b-final.txt`, `render-round13b-final-results.txt`.

All requested reviewer fixes are complete. Committed locally; no push.
