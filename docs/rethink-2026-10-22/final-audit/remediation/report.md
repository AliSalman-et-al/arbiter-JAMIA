# Final presentation remediation

Status: PASS for implementation and artifact checks. Author completion and the parent's independent final visual/site audit remain outstanding. No commit, push, publication, new model run, bootstrap run, estimate, or raw-input edit was performed by this implementation worker.

The controlling requirements are `parent-findings.md`, both supplementary audit reports, `numbers/report.md`, and `jama-style-contract.md`. JAMA presentation follows the [official instructions](https://jamanetwork.com/journals/jama/pages/instructions-for-authors/) and table guidance; mandatory JAMIA assembly requirements take precedence where they differ. This report supersedes earlier implementation acceptance and remediation proof directories.

## Production changes

Every production table now originates in `gt::gt()`. The three main tables, 98 supplementary panels, and eight reporting-map panels use native `gt::as_word()` OOXML and `gt::as_raw_html()` from the same objects/data. The Word adapter applies deliberate widths and readable typography to native gt OOXML because gt 1.4.0's Word exporter does not honor those settings. It does not reconstruct tables from HTML. Tables have semantic stubs, appropriate groups/spanners, numeric alignment, restrained rules, 10-point text and notes, and repeated context. Prose and captions use 11-point double spacing; table cells use single spacing.

The manuscript has an actual title-page word count, separate structured abstract, journal heading hierarchy, three editable tables immediately after first-citing paragraphs, and five main legends with meaningful alt text at the end. Main artwork remains separate. The main text is 2931 words and the abstract 229 words. RoB 2 is expanded on first use; the conclusion states the available inspectable workflow and observed benchmark benefit. Gandhi/Huang citations and citation ranges are corrected. Public study/results/supplement URLs replace URL placeholders; archival DOI and author information remain explicitly pending.

The supplementary navigation includes stable subdisplay locators, updated Word contents/page fields, bookmarks and printed pages. Pagination respects domain/reference/question blocks with continued captions and repeated definitions. The complete AVATAR text flows by domain/question/evidence record. Reporting-map locations refer to current manuscript/supplement sections; text-date coverage and author-dependent items are honestly partial or require author completion.

eFigures 2 and 5 have five readable domain panels each, repeated axes and preserved aspect ratios. All question rows, expert identities, eligibility denominators, confidence intervals, sparse and zero-denominator evidence remain. Effective row labels are at least 8 points at insertion size. eFigure 3 retains both arms across all 16 reviews and uses readable undefined labels. Main Figures 3–5 keep the accepted design. Figures 1–2 retain protected bytes.

HTML uses native gt tables, preserves supplementary prose/figures/trace/prompts, has no blockquote cells or duplicate document h1, and provides local captions, meaningful main-image alt text, navigation and PDF/PNG downloads. The parent owns landing-page packaging and live-browser verification.

## Audit issue disposition

| Findings | Disposition |
|---|---|
| SA01, N3 | Paired signalling differences state ARBITER minus Unassisted, percentage-point units, paired eligibility n, interval method and unavailable-cell meaning. |
| SA02, N4 | Rules-only sensitivity explicitly distinguishes one observed neither result plus 20 assumed split losses; overlapping source credits remain visible. |
| SA03, N2 | Published-reference coefficient/binary tables define weighting, positive class, sensitivity/specificity denominators, All-Low suppression and dash. Removed orphan footnote marker. |
| SA04, N10 | Primary severity is ARBITER relative to Unassisted; directional-disagreement strata are the named source relative to Published. Both comparators are explicit. |
| SA05, B01, N1, N6, N9 | Table-specific notes replace generic CI/population boilerplate. Confusion N is the entire matrix. Deterministic count/reconciliation/bounds tables carry no bootstrap note. Existing Overall distribution rows are restored. Domain-only agreement/reliability notes describe their displayed populations. |
| SA06 | Disputed-choice label credits are explicitly nonexclusive; source counts can overlap. |
| SA07, B08 | Page-linked contents, bookmarks, printed page numbers and stable 2A, 8A, 12A, 13A–C, 14A–B locators include all supporting displays, figures, trace and prompts. |
| SA08 | Coherent reference/domain/question blocks replace arbitrary fixed-row chunks. Continued panels repeat titles and definitions. |
| SA09, N11 | Eligibility counts are question components, exclusion meanings and paired intersection are defined; redundant boolean eligibility column removed. |
| B02 | Changed-cell listing identifies Unassisted and defines original-cell flags, forced-choice status and fixed eligibility. Yes/No replaces raw booleans. All 26 changes remain. |
| B03, N7 | Cost tables identify US$, total versus per-trial median, 102-trial coverage, reconstruction bounds versus intervals, side-call cache assumption and unusable harness diagnostics. |
| B04, N7 | Reconciliation includes units and definitions for input/read/output, request/result/side/gap, high requests, event/turn counts and compaction-related fields. |
| B05 | eFigures 2/5 are domain-panel pages; eFigure 3 undefined labels are readable. Complete adverse/sparse/zero evidence retained. |
| B06 | AVATAR forced two-row page breaks removed; all original trace text retained without semantic editing. |
| B07 | Reporting map uses current actual sections/displays; no planning-file/stale author-assembly locations or invented text dates. |
| B09, N8 | Figure support is indexed in navigation; duplicated CI expansions removed. |
| N5 | Invalid-path table has deliberate numeric gutters and defines N/PN/NI, original/additional/final count meanings. |
| Parent 1–3 | Editable in-text tables, title/abstract/pages/headings/spacing, main legends/alts, narrative/citation corrections and Figure 5 domain names implemented. |
| Parent 4–5 | Actual gt designs, complete evidence, group-aware pagination, readable figures and truthful navigation/reporting map implemented. |
| Parent 6–7 | Native HTML tables and coherent reader journey implemented; all main local captions/alts/download links verified. |
| Parent 8 | Required assets are present; packaging, publication and live-browser QA belong to parent. |
| Parent 9 | Known public URLs included; DOI/authorship/declaration facts remain honest pending fields. |

## JAMA conventions and explicit exceptions

Frequency cells show numerator/denominator and percentage. Denominators below 100 use integer percentages and percentage CI bounds; larger denominators use one decimal. Coefficients use two decimals; paired percentage-point effects keep one decimal. Stored analytic CSV precision is unchanged. The formal primary result displays 53/60 (88%; 95% CI, 80%–96%), derived from the unchanged stored estimate/limits. Resources use median (IQR), with paired mean contrasts explicitly distinguished. Tables have short descriptive titles, units and definitions. Statistical summaries use point markers and uncertainty, with labeled scales/keys.

Exceptions are deliberate: protected Figures 1–2 are byte-unchanged; mandatory JAMIA abstract/placement/headings/limits and numbered bracket citation format remain; verbatim evidence/model output remains intact; counts-only confusion matrices and deterministic inventories remain counts without invented percentages; mean-of-expert estimates have no single observed numerator and are labeled averages. No P values, new tests, SDs or estimates were invented. Exact-source quotations can therefore retain their original P-value typography.

## Checks and proof

The final evidence is under `proof-jama/`; earlier `proof-v1/`, `proof-v2/`, `proof-v3/` and `table-proof/` are superseded. Installed Word exported all six DOCX files after updating fields and contents. Managed Python rasterized every exported page. `page-checks.csv` checks empty/outside-page content; `boundaries.csv` checks every printed page number and page boundary; `locators.csv` records actual display/page locations. `visual-coverage.csv` identifies reading-size visual inspections by layout pattern. This worker inspected representative final pages and every changed figure pattern; the parent owns independent exhaustive final-page visual coverage and live-browser inspection.

Exact final page counts and artifact hashes are recorded in `final-artifacts.json` and `artifact-hashes.csv`. The final check logs are:

- `tests-final.log`: 220 passed; 0 failed, warnings or skipped.
- `verify-output-final.log`: all retained scientific/workbook/source/export checks pass, including all 16 review forests.
- `verify-presentation.log`: all six editable DOCX inventories, spacing/footer checks, main legends/alts, all 241 original trace cells, native HTML tables, 62 supplementary contents anchors and local downloads pass.
- `manuscript-numbers.log`: no untraced manuscript numerical claims; counts, citation order/ranges and word limits pass.
- `jama-check.log`: 642 frequency cells, including 292 with denominators below 100, pass display-rounding checks.
- `invariance.json` / `invariance.log`: 4639 protected files and 38 numerical exports unchanged against 951dddd; zero mismatches. This includes protected Figures 1–2 and raw inputs/expert material.
- `raster-final.log`, `boundaries.log`: all 171 final pages and 53 Word contents targets checked; no empty/outside-page content, wrong page numbers or contextless supplementary table spills.
- `diff-check.log`: git whitespace check passes.

No bootstrap rerun was needed or performed. `renv.lock` adds gt 1.4.0 and only its missing dependency closure (V8, bigD, bitops, commonmark, htmlwidgets, juicyjuice, litedown, markdown, reactR, reactable); existing dependency versions are unchanged.

Visual proofing caught and corrected defects that earlier structural checks missed: a wrapped Recomputed header, supplementary legends leaking into the final main legend after punctuation normalization, an empty Word contents field, and a load-order-dependent CI note lacking the abbreviation expansion. Focused checks now reject legend leakage, empty/incorrect contents targets, absent CI definitions and domain boilerplate in the Overall-only table. The two CI-note definitions now agree. Final Word counts are Manuscript 23 pages, Supplement 137, reporting map 8, and each standalone main table 1: 171 pages in total. Final navigation uses Arial 10-point text. HTML has a separate clickable contents panel with validated anchors and a single document h1.

## Changed implementation files

`analysis/R/{presentation,displays,manuscript-tables,manuscript-supplement,manuscript-figures,manuscript-legends,checklist,results-sentences}.R`; `analysis/{results,supplement}.qmd`; `analysis/build-publication.R`; `analysis/snapshot-gt.R`; `analysis/renv.lock`; `analysis/verify-output.R`; `docs/manuscript/{manuscript.md,verify-numbers.py,assemble-publication.py,native-table-html.py,verify-presentation.py}`; generated main/supplement/reporting DOCX, HTML, figures, legends, display CSVs and manifests; and this remediation directory's focused proof scripts/logs. These sit on top of the accepted uncommitted rebuild. Parent-owned publishing scripts and audit findings were not edited.

## Author completion and handoff

Author names/degrees/order, affiliations/correspondence, expert qualifications/selection details, applicable acknowledgments/AI-use statement, funding/conflicts/contributions/ethics/registration/public-involvement declarations, text-date coverage and archival DOI/citation still require actual author information. No facts were fabricated. This is an implementation PASS, not a claim that those author fields are submission-complete or that the site has been deployed.

Parent should use all six final DOCX files; main Figure1–5 PDF/PNG; all canonical eFigure PDF/PNG plus domain-panel PDF/PNG. Canonical eFigure2/5 PDFs contain all five panels; their canonical PNG is the first-domain preview, with complete panels listed in `analysis/output/manuscript/qa/figure-panels.csv`. Parent performs final independent page coverage, live HTML QA, commit/push and GitHub Pages publication.
