# Round 15 implementation and verification report

Author-defined design dated 2026-10-21. Baseline: `c2980a7ea75a8be44962e6288effa01795b3e809` plus the pre-existing uncommitted glossary and Round 15 specification. No commit or push was made. `docs/manuscript/` was not edited.

## Implementation

The single `run.R` pipeline now loads both full-coverage expert workbooks with readxl, validates source-label joins, computes independent and derived Overall references, label-based forced choices, primary sensitivities, directional agreement, signalling agreement, reliability, descriptive revised ratings and rules-only recomputation. New calculations live in small named functions in `R/expert-agreement.R` and `R/signalling.R`. Presentation consumes numerical CSVs through a source-cell trace. Figures 3–6, four Word tables, the complete supplement, reporting map and both HTML views are generated together.

The superseded adjudication, composite, localisation and isolated question 5.1 analysis code, tests and outputs were deleted. Historical round reports were moved unchanged to `archive/`. The release exclusion manifest is now `public-release-exclusions.txt`. `provenance/round15-file-inventory.csv` lists every changed path, and `provenance/archive-invariance.csv` proves all 13 moved reports are byte-identical. Figure 1 notes containing source provenance were moved out of reader outputs into `provenance/figure1-notes.md`.

The analysis plan sections 4–7 describe the replacement design and distinguish the retained primary estimand and bootstrap from the new author-defined analyses, post hoc strictness strata and rules-only recomputation. The README and dated deviation record document implementation and environment. The R 4.3.3 substitution for the frozen R 4.6.1 environment remains explicit; the original lockfile is unchanged, including its recorded readxl dependency.

## Loader and population checks

Both workbooks contain 510 unique trial-domain cells covering all 102 eligible trials. All 3,060 source-label assertions match published, ARBITER and Unassisted exports (three sources × 510 cells × two experts). Each workbook has 4,488 signalling-evidence rows and 204 trial-source rows. All independent, chosen and revised domain ratings are valid. The source-column reviewer letter is ignored for preference scoring.

Published Overall is absent for 21 trials. Per the author's explicit clarification, expert comparisons use observed Published Overall labels only (n = 81), never a penalty for a missing label. ARBITER and Unassisted use all trials (n = 102) and are additionally shown on the same n = 81 subset. Every paired Overall contrast involving Published uses that observed subset. The agreed reference further restricts to equal expert ratings: n = 52 Overall, including n = 42 with observed Published Overall. Each displayed row gives n, and relevant footnotes explain the missing labels and denominators. D1–D5 and all unchanged analyses retain their original populations.

## Full generated Results sentences

All 102 trials from 16 meta-analyses received two independent expert assessments of all 510 domain cells (Figure 3).

Among cells where the arms disagreed and the adjudicators made the same forced choice, they preferred ARBITER’s rating in 53/60 (88.3%; 95% CI 79.7–96.3; Figure 4).

Adjudicator 1 independently agreed with ARBITER on 371/510 cells (72.7%), Unassisted on 332/510 (65.1%) and Published on 301/510 (59.0%); the paired ARBITER − Unassisted difference was 7.6 percentage points (95% CI 5.1–10.2; Table 1).

Adjudicator 2 independently agreed with ARBITER on 433/510 cells (84.9%), Unassisted on 400/510 (78.4%) and Published on 362/510 (71.0%); the paired ARBITER − Unassisted difference was 6.5 percentage points (95% CI 3.5–9.4; Table 1).

On the 81 trials with observed Published Overall, the paired ARBITER − Unassisted difference in agreement with derived Overall was 13.6 percentage points (95% CI 6.2–21.0) for Adjudicator 1 and 17.3 (8.6–25.9) for Adjudicator 2 (Table 1).

For ARBITER ratings stricter than Published, the independent expert rating matched ARBITER in 64/88 cells for Adjudicator 1 and 65/88 for Adjudicator 2 (Figure 5B).

Unassisted broke the RoB 2 rules in 65/509 evaluable domain ratings (12.8%; 95% CI 10.0–15.6), while all 1407/1407 cited text records were bound to quotations found in content-hashed stored sources (Table 2).

Agreement with Published was poor for both arms (weighted κ 0.34 for ARBITER and 0.28 for Unassisted; Table 3).

Median [IQR] system runtime was 7.6 [6.1–10.5] minutes per trial for ARBITER and 0.5 [0.4–0.5] for Unassisted; API list-price equivalents were US$3.78 [3.46–4.10] and US$0.09 [0.07–0.13] per trial, respectively (eTable 16).

Rules-only recomputation changed 26 Unassisted domain ratings, including 6 of the original arm-discordant cells. On the 60 cells with an agreed forced choice, Unassisted matched that choice in 7 cells before recomputation and 8 afterwards. Agreement with the independent ratings fell from 332/510 to 324/510 for Adjudicator 1 and from 400/510 to 391/510 for Adjudicator 2; applying the rule fix did not raise agreement with either expert (eTable 6).

Across evaluable signalling answers, collapsed agreement was 80.4% and 74.9% for ARBITER and Unassisted against Adjudicator 1, and 90.9% and 87.4% against Adjudicator 2. On paired answers, the ARBITER − Unassisted differences were 5.0 percentage points (95% CI 3.6–6.4) and 3.3 (1.9–4.7), respectively (Figure 6; eTable 5).

For Adjudicator 1, the largest collapsed domain gap was in D5: 11.3 percentage points (95% CI 8.2–14.6). For Adjudicator 2, the D5 gap was 3.7 (95% CI −0.3 to 7.4), and the largest gap was in D3 (7.9; 95% CI 2.8–13.6). Question-specific paired differences are shown in Figure 6 and domain-level agreement in eFigure 2.

Within-direction choices (Y↔PY or N↔PN) accounted for about half of five-level disagreements against Adjudicator 1 (ARBITER 322/617, 52.2%; Unassisted 377/732, 51.5%) and about three-quarters of five-level disagreements against Adjudicator 2 (ARBITER 368/504, 73.0%; Unassisted 388/566, 68.6%) (eTable 5); cross-direction counts include NI versus either direction.

The experts independently agreed on 388/510 domain ratings (76.1%; weighted κ 0.59); agreement was lowest in D3 (54/102; eTable 8).


## Numerical trace

The sentences are generated by `results_sentences()` directly from these CSVs, with formatting only: primary sentence → `primary-endpoint`; independent agreements → `independent-estimates`; directional counts → `direction-of-disagreement`; rule breaks → `table3`; quotations → `audit-summary`; published κ → `table1`; median/IQR runtime and cost → `table5`; repaired cells → `rules-only-changed`, `rules-only-primary`, `rules-only-agreement` and `primary-endpoint`; signalling agreements and paired differences → `signalling-estimates` and `signalling-differences`; within/cross-direction disagreement counts → `signalling-disagreement-types` (from `data-derived/expert-signalling-comparisons.csv`); independent and matched Overall contrasts → `independent-differences`; expert equality and κ → `expert-reliability`. `display-source-trace.csv` records the underlying source cells for all generated displays and prose. Confidence intervals are stratified trial-cluster percentile intervals with 10,000 replicates and seed 20261018.

## Overall validation: every difference

All 612 workbook-column comparisons are exported. There are 29 differences: 21 absent Published Overall entries, six permitted Published High escalations from multiple Some concerns domains, one Published Low versus derived Some concerns (gupta-2024), and one permitted ARBITER High escalation. All independent, chosen, revised and Unassisted Overall entries agree with derivation. Stored published/model labels are preserved; optional escalation is not imposed on expert-derived Overall. A missing workbook Published entry is a validation difference, not an agreement failure.

| slug | column | workbook | calculated |
|---|---|---|---|
| abbasi-2012 | human | High | Some concerns |
| aboelfadl-2022 | human | High | Some concerns |
| albert-2013 | human | High | Some concerns |
| ashar-2022 | human | High | Some concerns |
| baillard-2006 | human |  | High |
| baillard-2018 | human |  | Low |
| barratt-2024 | human |  | Low |
| bendix-1996 | human | High | Some concerns |
| bendix-2000 | human | High | Some concerns |
| canvas-program | human |  | Low |
| chua-2022 | human |  | High |
| dapa-hf | human |  | Low |
| declare-timi-58 | human |  | Low |
| deliver | human |  | Low |
| empa-reg-outcome | human |  | Low |
| emperor-preserved | human |  | Low |
| emperor-reduced | human |  | Low |
| envision | human |  | Low |
| frat-2019 | human |  | Low |
| fulop-2021 | kit | High | Some concerns |
| guitton-2019 | human |  | Low |
| gupta-2024 | human | Low | Some concerns |
| jaber-2016 | human |  | Low |
| lv-2023 | human |  | Some concerns |
| nefigard | human |  | Low |
| rosen-2021 | human |  | High |
| sanctuary | human |  | Low |
| stop-igan | human |  | Some concerns |
| testing | human |  | Some concerns |

## Signalling parse and eligibility

The expanded parse has 9,181 rows and preserves workbook row, phase, raw text, answer component, normalised retained/changed/mixed status and any stated transitions. Exact semantic question mappings are exported in `question-map.csv`. Multi-component matches require explicit matching names on both sides; a scalar is never broadcast. NA, inactive questions, missing answers, unmatched components and unresolved syntax are not evaluable. Paired differences use only jointly evaluable components. The full comparison and its exclusions are exported, rather than silently dropping them.

The ten unresolved rows below are all Adjudicator 2, Becker 2015. Their Answer cell says Split or Split (see JSON); no referenced JSON was supplied. The evidence narrative was retained verbatim but was not used to invent structured answers. Five Independent rows are excluded from agreement; the five comparison-phase rows remain descriptive parse issues.

| adjudicator | slug | phase | domain | question | workbook_row | raw_answer | issue |
|---|---|---|---|---|---|---|---|
| 2 | becker-2015 | Independent | D4 | 4.3 | 1074 | Split (see JSON) | Unresolved component syntax |
| 2 | becker-2015 | Independent | D4 | 4.4 | 1075 | Split | Unresolved component syntax |
| 2 | becker-2015 | Independent | D4 | 4.5 | 1076 | Split | Unresolved component syntax |
| 2 | becker-2015 | Independent | D5 | 5.2 | 1078 | Split | Unresolved component syntax |
| 2 | becker-2015 | Independent | D5 | 5.3 | 1079 | Split | Unresolved component syntax |
| 2 | becker-2015 | Reviewer comparison | D4 | 4.3 | 1096 | Split | Unresolved component syntax |
| 2 | becker-2015 | Reviewer comparison | D4 | 4.4 | 1097 | Split | Unresolved component syntax |
| 2 | becker-2015 | Reviewer comparison | D4 | 4.5 | 1098 | Split | Unresolved component syntax |
| 2 | becker-2015 | Reviewer comparison | D5 | 5.2 | 1100 | Split | Unresolved component syntax |
| 2 | becker-2015 | Reviewer comparison | D5 | 5.3 | 1101 | Split | Unresolved component syntax |

## Interpretation and open items

All provisional counts in the brief reproduce independently: 154 disputed, 80 discordant, 60 equal forced choices, 53 ARBITER and seven Unassisted choices, 388 equal independent ratings and 356 all-three concordant cells. No provisional count needed correction. Rules-only repairs affect 26 domain labels, including six original arm-discordant cells and three in the consensus primary population; the fixed primary population and label-based tie scoring are retained after repair.

Derived Overall uses the worst independent domain judgement, with optional multiple-Some-concerns escalation reported separately in workbook validation. The published Overall missingness policy is the explicit author clarification above. Revised ratings and retained/changed answers are descriptive. No source-stratified sensitivity was added; the experts could consult sources beyond the arm inputs, as stated in limitations.

The ten Split rows require the original structured component answers if authors want them evaluated. The workbook Overall differences are transparently reported without editing inputs. The reporting map leaves credentials, declarations, registration and final manuscript pagination for author completion. No other data clarification blocks the implemented analyses.


## Round 1 verification snapshot (presentation counts superseded below)

- Full pipeline: `Rscript run.R` completed successfully and rendered both HTML views. Presentation refinements were then applied to the generators and the affected Word/HTML views; the final verifier proves that the current R display builders reproduce all 21 supplemental display CSVs and Word footnotes exactly. Historical parent data were not changed by these refinements.
- Full suite: **204 passing assertions, zero failures, errors, warnings or skips**. Coverage includes workbook joins and coverage, label ties, a hand-built primary fixture, derived Overall, scalar/component parsing and matching, nonuniform directional counts, observed Published Overall cohorts for weighted and unweighted agreement, and question-row denominators after component expansion. Log: `provenance/round15-tests.txt`.
- Independent base-R recomputation from both workbooks reproduces every provisional count, all six independent domain agreement counts and every full/matched Overall numerator. Directional outcomes partition each eligible population, and every exported count/n proportion equals its point estimate.
- **17 invariant numerical CSVs have an empty git diff** against the baseline: `provenance/unchanged-analysis.diff` is zero bytes. These cover Table 3, Table 2, audit, rule checks, cost, runtime and their paired contrasts/sensitivities. All fields in the prior-work comparison are identical except the authorised reference-standard description. `provenance/prior-work-data.diff` records that text-only change. This study's evidence locators were updated to the rewritten plan and exported as `prior-work-evidence.csv`; other studies' evidence was preserved.
- The protected AVATAR example also agrees with the new expert ratings: both experts rated D1–D4 Low and D5 Some concerns, giving derived Overall Some concerns.
- **All eight protected Figure 1/2 files are byte-identical** to the baseline, recorded in `provenance/protected-artwork.csv`. All 13 historical reports are byte-identical to their former paths, recorded in `provenance/archive-invariance.csv`.
- **35,743 source-cell trace records resolve** to final CSVs. Results prose and legends regenerate exactly. Every main-table cell and every supplementary/reporting-map row appears in its Word artifact. Every AVATAR answer, rationale and full evidence-record field is present. Current supplemental builders reproduce the saved display data and footnotes. Every Results sentence and main/supplementary display cell also appears in the final HTML. HTML checks normalise quotation typography and code-delimiter backticks, without normalising numerical values.
- Visual QA rendered **107 Word-document pages**: Supplement 97, TRIPOD-LLM 5, Table 3 one, Table 1 two, Table 2 one and Table 4 one. Every page was inspected in contact sheets, with main tables and representative/affected dense pages or crops checked at full size. All seven figures (Figures 1–6 and eFigure 1) were rendered from PDF and inspected, including greyscale and deuteranopia simulations. There are **zero words outside page bounds**, no empty pages, clipped content, overlapping text or empty figure panels. Source-trace pages can be sparse because they retain two records per page. Review images are in `/tmp/round15-qa/`; the durable page and review records are `provenance/round15-page-checks.csv` and `round15-visual-review.csv`.
- QA refinements shortened the narrow confusion-matrix header, balanced single-row continuation chunks, used a plain dash for undefined values, standardised runtime interval punctuation, and gave primary, reliability and validation tables their own relevant denominator notes. The affected pages were re-rendered and inspected. Five new TIFFs are 600 dpi with LZW compression; `provenance/figure-production.csv` records dimensions and metadata. Plots use vector PDFs, 174 mm width and the established Fira Sans/JAMA styling.
- Contextual leak scan: no unreported model name, A/Z, vindicated, decisive or over-flagging text remains in outputs. Raw source IDs (`kit`, `nokit`) and `accuracy` metric codes occur only in machine data or trace records. Reader-facing occurrences of *composite*, *first* and *accuracy* are all preserved AVATAR trial quotations or rationale: clinical composite outcomes, chronology/authorship/hospitalisation, and the source authors' statement about data accuracy. None describes the retired reference design, claims novelty or calls the primary preference endpoint accuracy. Every occurrence is available in `provenance/round15-leak-contexts.csv`, with review in `round15-leak-review.txt`.
- Poppler text extraction reported nonfatal font-resource diagnostics for the two protected PDFs. Their PDF-to-PNG renders and corresponding SVG/PNG text/visual checks succeeded. Their bytes were preserved as required. The R 4.3.3 substitution and renv startup notice about unused missing lockfile packages are environmental records; required analysis functions, tests and exports completed.
- `git diff --check` passes. The lockfile, source workbooks and `docs/manuscript/` have no diff. HEAD remains the baseline commit; no commit or push was made. The file inventory excludes the pre-existing glossary and Round 15 specification edits, and distinguishes deletions from moves.

Final logs and all output-verification assertions are in `provenance/round15-output-verification.txt` and `provenance/output-verification.txt`. No scientific discrepancy from the provisional brief remains. The ten unresolved Split rows, the documented Overall differences and author-supplied reporting-map fields are the open data/reporting items described above.

Round 1 file-inventory counts: added: 80, deleted: 279, modified: 64, moved: 14, moved/updated: 1.

## WP-A round 2 presentation revision

All eight revision items are implemented without changing an estimate. All 58 numerical/source CSVs checked against the start of round 2 are byte-identical; the reporting-map CSV and display CSVs are presentation text. Durable SHA-256 pairs are in `provenance/round15-a2-estimate-invariance.csv`.

Table 1 now has nine rows on one page, ordered by reference, with two cohorts per reference and an expert-to-expert foot row. All source comparisons on its Overall line use observed Published Overall: 81 trials, restricted to 42 for the agreed reference. Fractional mean agreement counts are explicitly identified as means. Full independent agreement and all paired contrasts, including all-trial Overall, occupy eTable 2 (187 rows); its earlier abbreviated display CSV was replaced. The surrounding eTable numbering remains in the established expected citation order. New eFigures 2 and 3 follow eFigure 1, and their citations, captions and reporting-map locations were propagated.

| Reference | Domain | ARBITER | Unassisted | Published | ARBITER − Unassisted |
| --- | --- | --- | --- | --- | --- |
| Adjudicator 1 | D1–D5 | 371/510 (72.7%); κ 0.51 | 332/510 (65.1%); κ 0.35 | 301/510 (59.0%); κ 0.21 | 7.6 (5.1–10.2) |
| Adjudicator 1 | Overall | 32/81 (39.5%); κ 0.20 | 21/81 (25.9%); κ 0.13 | 24/81 (29.6%); κ 0.11 | 13.6 (6.2–21.0) |
| Adjudicator 2 | D1–D5 | 433/510 (84.9%); κ 0.69 | 400/510 (78.4%); κ 0.53 | 362/510 (71.0%); κ 0.29 | 6.5 (3.5–9.4) |
| Adjudicator 2 | Overall | 60/81 (74.1%); κ 0.66 | 46/81 (56.8%); κ 0.47 | 42/81 (51.9%); κ 0.38 | 17.3 (8.6–25.9) |
| Mean of experts | D1–D5 | 402/510 (78.8%); κ 0.60 | 366/510 (71.8%); κ 0.44 | 331.5/510 (65.0%); κ 0.25 | 7.1 (4.8–9.4) |
| Mean of experts | Overall | 46/81 (56.8%); κ 0.43 | 33.5/81 (41.4%); κ 0.30 | 33/81 (40.7%); κ 0.24 | 15.4 (8.0–22.8) |
| Agreed reference | D1–D5 | 349/388 (89.9%); κ 0.79 | 313/388 (80.7%); κ 0.57 | 281/388 (72.4%); κ 0.32 | 9.3 (6.3–12.2) |
| Agreed reference | Overall | 30/42 (71.4%); κ 0.57 | 21/42 (50.0%); κ 0.37 | 20/42 (47.6%); κ 0.25 | 21.4 (7.5–35.0) |
| Expert-to-expert | D1–D5 | 388/510 (76.1%); κ 0.59 |  |  |  |

Each source entry is n/N (%) followed by weighted κ; the last column is the exact-agreement difference in percentage points (95% CI). Mean-of-experts counts and estimates are arithmetic means, with intervals computed from the mean of the paired estimates within each shared bootstrap replicate. The agreed reference restricts to equal independent expert ratings. Twenty-one missing Published Overall labels are excluded. The expert-to-expert foot row compares the experts, across the source columns in Word.

Figure changes:

- Figure 3: equal-height boxes and attached, evenly spaced arrows; concordant-cell and expert-derived Overall side notes.
- Figure 5A: independent left margin; consistent blue circles, orange squares and dark-grey triangles in ARBITER, Unassisted, Published order. Figure 5B: all arm/direction/adjudicator populations partitioned into three neutral-fill outcomes, ARBITER first, with segment counts and row denominators.
- Figure 4: separate primary, sensitivity and post hoc headers, with both arms’ preference counts in the labels. Adjudicators are identified by row text.
- Figure 6: paired differences for each signalling question, grouped by domain, with collapsed and five-level columns, expert row labels and paired n. Questions below 20 paired answers are enumerated in the legend and retained in eFigure 3, including explicit not-estimable rows when n is zero.
- eFigure 1: Unassisted changed to the shared orange-square encoding. eFigure 2 contains the former domain-level signalling display. eFigure 3 contains every question, including sparse rows. All source plots use the same ordered source encoding; difference forests use the ARBITER blue circle.

The requested D5 framing required qualification: D5 has the largest collapsed domain difference for Adjudicator 1 (11.3 points), whereas Adjudicator 2’s largest is D3 (7.9 points); Adjudicator 2’s D5 difference is 3.7 points. The title and prose state this directly. No estimate or CI was changed to fit the requested framing.


### Round 2 final verification

- Display rebuild and both final Quarto HTML renders completed successfully. The final output verifier exits 0. No estimation routine was edited or rerun for this presentation revision.
- Tests: 204 passing assertions, no failures, errors, warnings or skips (`provenance/round15-a2-tests.txt`).
- Estimate preservation: all 58 numerical/source CSVs are byte-identical to their round-1 snapshot. All 17 unchanged-analysis CSVs still have an empty diff against HEAD (`unchanged-analysis.diff`, zero bytes). All eight Figure 1/2 artifacts remain byte-identical to HEAD. All 13 archived reports remain byte-identical to the parent originals.
- Loader: 102 trials, 510 unique cells per expert, all 3,060 workbook source-label assertions pass. Independent workbook recomputation reproduces all provisional counts, all six source/expert pooled counts and every full/matched Overall count. Directional counts partition their denominators; every exported count/n equals its estimate.
- Overall validation remains 29 differences in 612 checks: 21 absent Published labels, seven permitted High escalations, and one Published Low versus derived Some concerns. Expert independent, chosen and revised Overall labels all match derivation. These accepted findings are unchanged.
- Number trace: 20,252 unique source-cell records resolve. Results prose and legends regenerate exactly. Compact Table 1 regenerates cell for cell. Every main-table cell and supplementary/reporting-map row is present in Word; every Results sentence and display cell is present in final HTML. All supplemental builders reproduce their saved CSVs and Word footnotes, including the full long agreement table. The entire AVATAR trace is preserved.
- Figure checks: Figure 6 includes only question/expert rows with at least 20 paired answers; eFigure 3 retains sparse and zero-answer rows. All nine figures were rendered and inspected. Seven regenerated TIFFs are 600 dpi with LZW compression (`figure-production.csv`); PDFs remain vector exports.
- Page QA: 112 Word pages rendered (Supplement 103, reporting map 5, each main table 1), with zero words outside page bounds and no empty pages. Ninety-one pages are pixel-identical to prior inspected pages. All 21 changed/new pages were inspected at full size and cross-checked with independent PDFium renders and contact sheets. No clipping, overlap, broken tables or empty panels remains. Some Poppler raster resolutions dropped glyphs; PDFium renders and extracted PDF text confirmed that the PDF and Word content are intact. Review images are in `/tmp/round15-a2-qa/` and `/tmp/round15-a2-pdfium/`; durable page checks, comparisons and review records are in `provenance/round15-a2-*`.
- Leak scan: no unreported model, retired A/Z/vindicated/decisive/over-flagging labels, or reader-facing raw arm terminology. Remaining reader occurrences of composite, first and accuracy are unchanged AVATAR source quotations/rationale, never the primary endpoint or retired reference. All contexts are retained in `round15-leak-contexts.csv`; current review is `round15-a2-leak-review.txt`. Nonfatal font-resource diagnostics remain confined to the protected PDFs.
- `git diff --check` passes. The input workbooks, lockfile and `docs/manuscript/` have no diff. HEAD remains c2980a7ea75a8be44962e6288effa01795b3e809. No commit or push was made.

The existing unresolved component-answer rows and author-completion reporting fields remain as recorded above. No new scientific or data issue was introduced. The D5 framing qualification above is the only interpretation required by the revision request.

## WP-A round 3 polish

The preceding round-specific presentation snapshots are historical; this section and the generated Results above describe the final artifacts. Figure 6 now shows only collapsed per-question paired differences, with the in-image title removed and all domain groupings and paired n labels retained. eFigure 3 retains both five-level and collapsed scales, including sparse questions. Its image title was also removed. Table 1's mean-of-experts rows show percentages and κ only; the footnote explains averaging the two expert estimates. Domain-gap wording treats each expert separately. No existing estimate was changed or recomputed.

All evaluable answers for each source–expert comparison contribute to the new disagreement partition. Within-direction means Y↔PY or N↔PN. Cross-direction means a disagreement between Y/PY, N/PN or NI, including NI versus either direction. These categories partition every five-level disagreement. The raw counts and denominators are in `output/tables/signalling-disagreement-types.csv`; the four rows are displayed under eTable 5 in Word and HTML. The legend and Results sentence are generated from that CSV. Existing eTable 1–21 and eFigure 1–3 numbering is preserved; the reporting map points to the new section and clarifies scale placement.

| adjudicator | source | n | five_level_disagreements | within_direction | cross_direction |
| --- | --- | --- | --- | --- | --- |
| 1 | ARBITER | 1507 | 617 | 322 | 295 |
| 1 | Unassisted | 1417 | 732 | 377 | 355 |
| 2 | ARBITER | 1501 | 504 | 368 | 136 |
| 2 | Unassisted | 1414 | 566 | 388 | 178 |

Final Figure 6 legend:

Figure 6 ARBITER generally agreed more often with the experts on individual signalling questions. Question-level paired ARBITER − Unassisted differences compare collapsed agreement with each expert’s independent answer. Blue circles encode the ARBITER contrast, with expert identity and n printed on each row, grouped by domain. Collapsed agreement combines Y/PY and N/PN, with NI separate. Only explicit matched answers evaluable in both arms contribute. Questions with fewer than 20 paired answers are omitted: 2.4 (Adjudicator 1, n = 0); 2.4 (Adjudicator 2, n = 0); 2.5 (Adjudicator 1, n = 0); 2.5 (Adjudicator 2, n = 0); 2.7 (Adjudicator 1, n = 5); 2.7 (Adjudicator 2, n = 5); 3.4 (Adjudicator 1, n = 19); 4.4 (Adjudicator 1, n = 15); 4.4 (Adjudicator 2, n = 16); 4.5 (Adjudicator 1, n = 5); 4.5 (Adjudicator 2, n = 4). All questions, including these sparse rows and the five-level scale, are shown in eFigure 3 and eTable 5. Domain-level agreement is in eFigure 2. Alt text: Collapsed per-question paired differences and intervals for both experts, grouped by domain. Within-direction choices (Y↔PY or N↔PN) accounted for about half of five-level disagreements against Adjudicator 1 (ARBITER 322/617, 52.2%; Unassisted 377/732, 51.5%) and about three-quarters of five-level disagreements against Adjudicator 2 (ARBITER 368/504, 73.0%; Unassisted 388/566, 68.6%) (eTable 5); cross-direction counts include NI versus either direction. CI, confidence interval; 10,000 percentile bootstrap replicates, trials resampled within meta-analysis; seed 20261018.


### Round 3 verification

- Changed displays were rebuilt and finalised; the generated count page, notes and figure were propagated into the accepted supplement, and both Quarto HTML renders completed. The complete R generator was updated; its slow unchanged AVATAR rebuild was interrupted after all tables and figures had built, then all preserved AVATAR fields were verified against their CSVs. The output verifier exits 0. No existing estimate was changed or recomputed.
- Full test suite: 208 passing assertions, no failures, warnings or skips (`round15-a3-tests.txt`), including a synthetic fixture covering both probability directions, cross-direction changes, NI, exact matches and excluded answers.
- Both independent Python answer-code counting and independent R answer-code counting reproduce every new count. The new partition also reconciles to the unchanged five-level disagreement totals. Raw denominators and both categories are exported and traced in Word, HTML, the Results and the legend.
- All 58 original numerical/source CSVs are byte-identical to the round-2 snapshot (`round15-a3-estimate-invariance.csv`). All 17 unchanged-analysis CSVs have an empty diff against HEAD. All eight protected Figure 1/2 files are byte-identical to HEAD. All 13 archived reports remain unchanged.
- All 20276 source-cell trace records resolve. Results and legends regenerate exactly; every main/supplementary display cell is present in final Word and HTML. The full AVATAR trace is preserved. The verifier checks that Figure 6 contains only collapsed rows with n ≥ 20, no plot title, and no mean-row counts in Table 1. eFigure 3 retains both scales and all sparse/zero-answer rows.
- Page QA: 113 Word pages rendered with LibreOffice and rasterised; no empty pages or out-of-page words. 106 pages are pixel-identical to prior inspected pages; all 7 changed pages were inspected. Both changed figures were inspected, and the other seven PNGs are pixel-identical to round 2. All nine figure PDFs were rasterised; regenerated TIFFs are 600 dpi with LZW compression. Records: `round15-a3-page-checks.csv`, `round15-a3-page-comparison.csv`, `round15-a3-visual-review.csv`, `round15-a3-figure-comparison.csv` and `figure-production.csv`. Rendered pages are in `/tmp/round15-a3-qa/`.
- Both HTML views also received browser DOM checks at the changed Results, Table 1 and new supplement count section. All images load and both pages fit their viewport.
- Leak scan passes: no unreported model, retired reference terminology or reader-facing raw arm labels. Remaining flagged composite, first and accuracy contexts are the previously accepted AVATAR quotations/rationale and machine metric names, never the primary endpoint. Contexts and final review are in `round15-leak-contexts.csv` and `round15-a3-leak-review.txt`. Nonfatal font diagnostics remain confined to protected PDFs.
- `git diff --check` passes. Workbooks, lockfile and `docs/manuscript/` have no diff. HEAD remains the parent commit; no commit or push was made (`round15-a3-git-checks.txt`).

The ten previously unresolved component-answer rows and the documented Overall validation differences remain unchanged. No new data issue was introduced.


## WP-A round 4 wording and complete clean rebuild

The Figure 6 legend, Results sentence and their copies in this report now distinguish the experts. Within-direction shares are computed directly from the disagreement CSV by the shared sentence generator, with one decimal place; no percentage is a typed constant. Cross-direction still includes NI versus either direction. The four counts, denominators and all existing estimates are unchanged. The generated sentence is:

Within-direction choices (Y↔PY or N↔PN) accounted for about half of five-level disagreements against Adjudicator 1 (ARBITER 322/617, 52.2%; Unassisted 377/732, 51.5%) and about three-quarters of five-level disagreements against Adjudicator 2 (ARBITER 368/504, 73.0%; Unassisted 388/566, 68.6%) (eTable 5); cross-direction counts include NI versus either direction.

Reader-facing filenames were replaced by eTable citations or descriptive source labels in the shared supplement and sentence generators and the Results HTML source. This includes eTable footnotes, methods, eTable 21 evidence locators, AVATAR source labels and reproduction prose. Technical filenames and link destinations remain in machine provenance and download links. The verifier explicitly scans rendered prose for filenames and rejects the superseded disagreement wording.

### Clean rebuild and accepted-content comparison

Before the build, the accepted output tree and HTML files were saved in `/tmp/round15-a4-before/`. All generated table CSVs, Word artifacts, Figures 3–6/eFigures and both HTML files were removed; only protected Figure 1/2 artwork, the supplied Figure 1/2 legends and input material were retained. The removal manifest is `provenance/round15-a4-clean-state.json`. The background `Rscript run.R` completed with exit status 0 in **1499.482 seconds (24 minutes 59.5 seconds)**, including the original 10,000-replicate estimation, every Word document and both Quarto HTML renders. Timing is measured around the complete subprocess, without including QA; see `round15-a4-rebuild-time.json` and `round15-a4-pipeline.txt`. No accepted Word document was patched or copied back into the build.

The regenerated Supplement preserves all **479 body paragraphs and 71 tables**. Exact paragraph and ordered table-cell comparison passes after applying only the requested filename-to-citation/source-label replacements to the accepted content. No unexpected text or cell change remains. Tables 1–4 and TRIPOD-LLM match the accepted paragraphs and table cells exactly, without normalisation. The comparison script, per-document text/cell diffs and `round15-a4-document-comparison.json` are retained in provenance. All AVATAR quotations, handles, pages, line ranges and source-version hashes are unchanged; only descriptive source labels replace filenames.

A clean build exposed **five stale CSVs** left in the old output directory but not produced by the current pipeline: `rules-only-recomputation-agreement.csv`, `rules-only-recomputation-changed.csv`, `rules-only-recomputation-agreed_choice.csv`, `rules-only-recomputation-win_share.csv` and `signalling-agreement.csv`. These include retired analysis populations and are deliberately absent from the clean outputs. Current rules-only and signalling estimates are generated under their current names and reproduce the accepted active data. Of the previous 58-file snapshot, 52 regenerated files are byte-identical, one changes descriptive AVATAR source labels only, and five are these stale files. Across all **55 current non-display CSVs**, **54 are byte-identical** to the accepted copy and the only difference is that source-label text; no estimate changed. `round15-a4-estimate-invariance.csv` records the snapshot comparison and explicitly distinguishes stale removals.

### Round 4 final verification

- Tests: **208 passing assertions**, zero failures, warnings or skips (`round15-a4-tests.txt`).
- The final output verifier exits **0**. All **46,037 source-cell trace records (20,276 unique)** resolve. Results and legends regenerate exactly from CSVs; every main/supplementary display cell occurs in final Word and HTML. Current supplement builders reproduce their CSVs and footnotes. Complete AVATAR evidence remains present (`round15-a4-output-verification.txt`).
- Independent Python answer-code counting reproduces all four within/cross-direction partitions and the percentages; the independent R check also passes. The five-level totals and denominators reconcile (`round15-a4-independent-counts.json`).
- All **17 unchanged-analysis CSVs** have an empty diff against parent HEAD (`unchanged-analysis.diff`, zero bytes). All **eight protected Figure 1/2 artifacts** are byte-identical to HEAD. All **nine figure PNGs** are byte-identical to the accepted round-3 copy (`round15-a4-figure-comparison.csv`). All 13 archived reports remain byte-identical to their parent originals.
- Word visual QA: **113 pages** rendered (Supplement 104, TRIPOD-LLM 5, Tables 1–4 one each). No empty pages or words outside page bounds. **80 pages** are pixel-identical to prior inspected pages; all **33 changed supplement pages** were visually inspected. Changes reflect filename removal and consequent wrapping only. Resolution-dependent raster glyph omissions were cross-checked with PDFium, alternate scales and extracted PDF text; document and table text is complete. No new clipping, overlapping layout, broken table or empty panel was found. Records: `round15-a4-page-checks.csv`, `round15-a4-page-comparison.csv`, `round15-a4-visual-review.csv`. Rendered pages: `/tmp/round15-a4-qa/` and `/tmp/round15-a4-pdfium/`.
- Leak scan passes, including the new filename scan across rendered reader text. Remaining reader flags (12 composite, 12 first and 2 accuracy contexts) are accepted AVATAR source quotations/rationale. Machine metric/arm codes stay in technical CSVs. Review and contexts: `round15-a4-leak-review.txt`, `round15-a4-leak-scan.txt`, `round15-leak-contexts.csv`. Nonfatal font-resource diagnostics remain confined to the protected Figure 1/2 PDFs.
- `git diff --check` passes. Source workbooks, lockfile and `docs/manuscript/` remain untouched. HEAD remains `c2980a7ea75a8be44962e6288effa01795b3e809`; no commit or push was made (`round15-a4-git-checks.txt`).

The full rebuild supersedes the round-3 interrupted-build limitation. The ten unresolved component-answer rows and the 29 previously documented Overall validation differences remain unchanged; no new scientific discrepancy was introduced.

## WP-P display numbering and manuscript polish

Baseline: `0cbdfc3`, with the supplied WP-M manuscript edits retained. No estimate was recomputed or changed. No commit or push was made.

The mapping is generated by `display_numbering()` and saved in `output/manuscript/qa/round15-display-numbering.csv`:

- Figures: old 1 → new 1; 2 → 2; 3 → 3; 5 → 4 (primary forest); 4 → 5 (independent agreement and direction); 6 → 6.
- Tables: old 2 → new 1 (independent expert agreement); 3 → 2 (rules and audit); 1 → 3 (published-label agreement); 4 → 4.

Main display filenames, legends, Results citations, supplement study cross-references, reporting-map locations and both HTML views use the new numbers. Statistical source CSV filenames remain stable; published display CSVs and Word filenames use the new table numbers. The curated prior-work evidence source points to the new audit-table number. Exact supplementary Word package comparison proves that only ten study table cross-references changed; all other text nodes, source quotations, media and formatting parts are unchanged.

The requested abstract wording, paired differences and intervals, split Background challenge, and flow-leading Results paragraph are in the manuscript. Abstract: 249 words. Main text: 3,470 words (Background 382; Objective 54; Materials and methods 1,396; Results 750; Discussion 888, including the 45-word conclusion). Back matter: 199 words, outside the main-text total. Existing author placeholders remain unchanged.

### WP-P verification

- Full test suite: 208 passing assertions; zero failures, warnings or skips (`round15-p-tests.txt`).
- Final output verifier exits 0 (`round15-p-final-output-verification.txt`). All 67,148 source-cell trace records resolve. Results and legends regenerate from current CSVs; every main/supplementary display cell appears in Word and HTML; current supplementary builders reproduce saved display CSVs and footnotes.
- Estimate invariance against `0cbdfc3`: all 17 required unchanged-analysis CSVs have an empty diff. Of all 55 non-display CSVs, 53 are byte-identical; the other two change display locators only (reporting checklist and prior-work evidence). All four main display CSVs are byte-identical under the map. Records: `round15-p-invariance.py`, `round15-p-invariance.txt`, `round15-p-estimate-invariance.csv`.
- All eight protected Figure 1/2 artifacts are byte-identical to the baseline. Figure 3–6 PNG/TIFF artwork is byte-identical under the map; original vector exports were retained under the corresponding numbers. Renamed figures were inspected at full size (`round15-p-figure-invariance.csv`).
- Final Word QA: 113 pages rendered; zero empty pages and zero out-of-page words (`round15-p-page-checks.csv`). Thirty-two pages are pixel-identical to the inspected baseline; 70 differ only in fewer than 100 outer table-rule endpoint pixels per page. All 11 pages with substantive raster differences were inspected: Tables 1–3, reporting-map pages 1/2/4, Supplement pages 76–80. No clipping, overlap, broken tables or missing content remains. Records: `round15-p-page-comparison.csv`, `round15-p-supplement-pixel-check.csv`, `round15-p-visual-review.csv`, `round15-p-supplement-content.json`. Renders: `/tmp/round15-p-qa/`.
- Both Quarto HTML renders completed. DOM checks confirm ordered main displays, six loaded main images and no horizontal overflow. Final screenshots of Results, Table 1, Figures 4/5 and the supplement prior-work section were inspected. T3 snapshot capture timed out twice; the fallback connector had no browser. Local headless Chrome supplied the visual checks (`round15-p-html-visual.txt`; screenshots in `/tmp/round15-p-html/`).
- Leak scan passes. Remaining reader flags are unchanged accepted AVATAR source quotations/rationale. No new prohibited reader terminology occurs (`round15-p-leak-contexts.csv`, `round15-p-leak-scan.txt`). Nonfatal PDF font diagnostics remain confined to protected artwork.
- `verify-numbers.py --verbose`: 397 numeric tokens; 221 output-traced; 176 classified non-result/editorial; zero untraced. Row-level checks include both abstract paired differences and intervals. Word limits and reference inventory pass (`round15-p-numbers.txt`).
- Citation-order assertion passes: Figures 1–6, Tables 1–4, eTables 1–21, eFigures 1–3. Five deliberately misordered/missing citation mutations are rejected; list, range and panel handling also passes (`round15-p-citation-check.txt`).
- `git diff --check` passes. Source workbooks and lockfile are unchanged. HEAD remains `0cbdfc3b78b1b62bb2afec670d520d430868a38c`. No commit or push was made.

No new scientific discrepancy was introduced. The documented unresolved component-answer rows and Overall validation differences remain unchanged. This pass used existing estimates and targeted presentation regeneration and citation changes; it did not rerun the estimation pipeline.
