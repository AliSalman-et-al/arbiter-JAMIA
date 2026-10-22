# Final vision B: ISSUES

Independent read-only review, 22 October 2026. Baseline HEAD: `951dddd3e28e0d6316c641491667353e0b851a78`. Reviewed the shared final proof, not a committed release.

**Coverage PASS: 76/76 assigned pages individually inspected with `view_image` at readable full-page resolution: Supplement 70–137 (68 pages), TRIPOD-LLM 1–8 (8 pages). Zero blocked or uninspected pages.** No contact sheets substituted for page inspection. `coverage.csv` identifies each page, outcome, proof path, resolution and SHA-256 at report generation.

**Publication-readiness verdict: ISSUES. Four actionable P2 correction groups remain.** These are required by the supplied presentation/standalone-definition/trace-pagination contract, rather than optional stylistic preferences. No P1 defect or demonstrated changed numerical estimate was found in this slice.

## Required corrections

### VB01 — eTable 16 footnote contradicts the displayed contrast direction (P2)

- **Location:** Supplement pp84–86, eTable 16; proof files `remediation/proof-jama/Supplement/page0001-084.png` through `086.png`. Production definition: `analysis/R/manuscript-supplement.R:241`.
- **Evidence:** Each repeated note states “paired differences are ARBITER minus the named comparator.” The body also includes **Unassisted minus Published**, for example Expert 1 −3.7 pp (−14.8 to 6.2) on p84, Expert 2 4.9 pp (−7.4 to 16.0) and expert mean 0.6 pp (−9.3 to 10.5) on p85, and agreed reference 2.4 pp (−16.3 to 19.0) on p86. `analysis/output/tables/independent-differences.csv` confirms that those are indeed Unassisted-minus-Published estimates.
- **Action:** Say differences follow the ordered contrast printed in the Source column (first source minus second), in percentage points for exact agreement and on the coefficient scale for κ. Retain every value. Refresh all three repeated notes and the corresponding HTML/native table note.

### VB02 — AVATAR evidence metadata and answer context still split across pages (P2)

- **Location:** Supplement AVATAR complete trace, pp123–124 and 129–136; corresponding numbered PNGs in the same proof directory. Generator: `analysis/R/manuscript-supplement.R:343–354`.
- **Evidence:** `eh_58abdac52262aa33` has its handle/source/page at the bottom of p129, but lines/hash/quote at the top of p130. `eh_92eed84c7b98e37c` has all metadata at the bottom of p130 and its quote starts p131. `eh_d54a2600ddc753b3` has handle/source/page/lines at the bottom of p134, but hash and quote start p135. `eh_f625637d366df2a0` has handle/source/page at the bottom of p135, but lines/hash/quote start p136. Separately, the isolated “Unassisted: Not applicable” opening p124 belongs to question 4.3 on p123; no continued-question identifier accompanies it.
- **Action:** Keep each evidence handle, source, page, lines, hash and beginning of quote together. Allow long quotes to flow, with the evidence handle repeated as continuation context. Keep the terminal comparator answer with its question block or repeat its question identifier on the continuation page. Preserve all verbatim content. This is the previously requested B06 correction, which remains incomplete despite the remediation disposition.

### VB03 — Supplementary figures lack standalone domain/coding definitions (P2)

- **Location:** eFigure 1 p105; eFigure 2 D1–D5 panels pp106–110; eFigure 4 p112; eFigure 5 D1–D5 panels pp113–117. Source: `analysis/R/manuscript-legends.R:9–13`.
- **Evidence:** D1–D5 appear in axes/panel titles without domain names in these local captions. eFigure 2 says “Y/PY and N/PN, with NI separate” without expanding these answer codes. eFigures 4 and 5 name five-level and collapsed coding without defining the categories or collapse. A reader extracting a figure cannot recover those definitions from its own legend. Their presence in the main Figure 5 legend or earlier eMethods does not make these figures standalone.
- **Action:** Add the relevant domain names to each figure/panel legend, expand Yes/Probably yes/No/Probably no/No information, and define the collapse locally. Retain current plots and estimates; captions can carry these definitions without shrinking labels.

### VB04 — eFigure 4 percentages have no numeric denominators (P2)

- **Location:** Supplement p112, eFigure 4; `remediation/proof-jama/Supplement/page0001-112.png`. Source `analysis/R/manuscript-figures.R:141` onward and `analysis/output/tables/signalling-estimates.csv`.
- **Evidence:** The figure plots exact-agreement percentages for each domain, source and expert. Its note says only “evaluable source-specific answers contribute”; neither marks nor legend supply their counts/denominators or a precise numbered table locator for them. These denominators vary: Expert 1 D1 five-level ARBITER is 208/306, whereas Unassisted is 187/303. The plot’s source-specific populations must not be read as the paired n printed in neighboring eFigures 2 and 5.
- **Action:** Provide source/expert/domain n (and preferably numerator/denominator for percentage summaries) in a readable adjacent key or small supporting table, with an exact local locator if kept separate. Explicitly distinguish these denominators from paired intersections. Use existing exported counts; no new estimate is required.

## Checks that passed and limits

Tables in the assigned slice are readable and use restrained rules, repeated column context and visible pagination. The repaired rules-only table explicitly describes 20 assumed split losses plus one neither result; the changed-cell listing identifies Unassisted and fixed original flags. Invalid-path notes define N/PN and NI. The process tables distinguish structural binding from semantic support. Cost/reconciliation notes now define US$ equivalents, total/per-trial quantities, cache sensitivities, reconstruction bounds, unusable harness diagnostics, tokens and event/turn units. No inappropriate generic bootstrap note remains on those deterministic resource/count displays.

The question figures are materially more legible: all five domain panels have repeated axes, readable expert/question/paired-n labels, sparse rows, and explicit zero-n “Not estimable” entries. All 16 review rows and readable undefined-κ annotations remain in eFigure 3. No actual clipped interval, lost trace text, overlapping table text, or missing printed page number was observed. The short D1 continuation on p119 and generous whitespace are not themselves treated as mandatory defects.

**Reporting-map PASS for all 8 pages in the assigned visual/content scope:** current named sections/display numbers replace planning-file references; text-date coverage and author-dependent credentials/declarations/archive fields remain honestly partial. No invented completion statement was found. Minor midword wrapping in the Topic column is readable and is not an unresolved mandatory objection. This pass is not independent certification against every external guideline item or visual reinspection of out-of-scope manuscript pages.

Read the parent findings, JAMA contract, supplement-B audit, numerical audit, and remediation report. Applied the PDF skill’s rendered-page inspection workflow. Targeted read-only source/CSV checks corroborated the contrast-note and denominator findings. No new statistical runs, protected F1/F2 inspection/modification, production edits, browser actions, commit or push occurred. Only `report.md` and `coverage.csv` in this directory were written. Whole-package gt provenance/numerical invariance remain with their owning audits; this review does not claim to have rerun them.

**Unresolved objections: VB01–VB04. Optional preferences requiring action: none.** Reproof the affected pages after correction; metadata pagination can shift neighboring trace pages.
