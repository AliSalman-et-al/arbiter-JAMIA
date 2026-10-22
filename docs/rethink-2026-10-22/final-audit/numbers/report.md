# Numerical audit: ISSUES

**Actual HEAD:** `951dddd3e28e0d6316c641491667353e0b851a78`, identical to requested baseline. Method: `git rev-parse HEAD` at entry and completion, inspect current uncommitted files, original expert workbooks and arm exports, source-code tracing, existing verifiers/tests, independent arithmetic recounts, and direct viewing of existing rendered pages. No production edits, commits, push, rebuild, rendering, model runs, new resampling or nested agents. Only this audit directory was written. The accepted rebuild brief, consolidated blueprint, book principles and implementation report were read. Applied the requested Pstack Prove It Works leaf.

**PASS:** audited headline arithmetic, retained intervals, source/workbook contracts and figure/table numerical mappings. **ISSUES:** interpretation/labeling and table-specific notes below. **BLOCKED:** none within the assigned numerical scope. This is not an unconditional publication clearance.

The numerical story supports the accepted OCAR hierarchy: separate all-cell expert gains explain the conditional primary result; domain/reference dependence and signalling coding remain visible; process checks and computational burden remain distinct from judgment validity and human work. None of the issues below requires a new estimate, experiment or bootstrap.

## Coverage and evidence

- [display-ledger.csv](display-ledger.csv): **all five main figures, five supplementary figures, three main tables and 23 numbered supplementary tables**, plus ten attached/unnumbered components. Records sources, generator functions, populations, units, intervals, inspected pages and issue/pass status.
- [page-ledger.csv](page-ledger.csv): all **125 existing document pages**, explicitly distinguishing actual page-image inspection from text/source/CSV verification. I directly inspected the three current one-page main tables and 31 full supplementary page images, including the final page/footnote of every numbered supplementary table and all five supplementary figure pages. Also inspected all five main figure PNGs. No contact sheet or stale standalone `rendered/Table3.png` was used. Full layout/vision review of other pages remains with its assigned owners; I do not claim to have visually read all 125 pages.
- [supplement-mapping.csv](supplement-mapping.csv): regenerated, read-only, 23-table specification and complete current footnotes.
- [claim-ledger.csv](claim-ledger.csv), [manuscript-verifier.log](manuscript-verifier.log): independent headline counts/resource records plus exhaustive manuscript digit-token trace. The latter is a traceability instrument, not semantic proof; surrounding claims were separately read against source logic.

### Executed checks

All final runs exited 0. Commands run from repository root unless noted; executables were the specified R 4.6.1 and Python 3.14 installations.

| Check | Evidence |
|---|---|
| Existing `analysis/verify-output.R`, audit-local copy with all provenance writes redirected here; run from `analysis/` | [verify-output.log](verify-output.log), [verify-output-audit.R](verify-output-audit.R). Original workbook/arm equality, every exported proportion, Overall populations, binary numerators/denominators, all current display/Word/HTML row contracts, figure inventory, forest retention, source scans, 38 unchanged numerical exports. |
| Existing `testthat::test_dir("tests/testthat")`, from `analysis/` | [tests.log](tests.log): **220 pass; zero failures, warnings or skips**. Uses existing test fixtures; no production resampling. |
| Existing `docs/manuscript/verify-numbers.py --verbose` | [manuscript-verifier.log](manuscript-verifier.log): PASS, word limits/citations/number trace. |
| Existing `verify-rebuild.py`, audit copy with only report destination and root resolution adapted | [invariance.log](invariance.log), [invariance.json](invariance.json): **4,639 protected files, zero mismatches; 38 numerical exports unchanged**. |
| Additional read-only source contract checks | [source-contracts.R](source-contracts.R), [source-contracts.log](source-contracts.log): all **9,172** persisted signalling rows reproduce from both original workbook evidence sheets and original arm exports across **28 fields**; all eligibility counts/reasons; **224 absolute** and **112 paired** signalling rows; plotted interval ranges. No bootstrap. |
| Independent Python arithmetic, without R agreement helpers | [independent-counts.py](independent-counts.py), [independent-counts.log](independent-counts.log): every expert domain exact count and confusion cell; every expert Overall confusion cell using correct 102/81 populations; primary counts and reliability; all **204** Sonnet trial cost equivalents from token components; all process summary quantiles/totals; structural record counts. |

The auxiliary audit scripts initially needed CSV-serialization handling (`NA` is a literal signalling answer), Sonnet filtering, raw harness-to-reconstructed-cost replacement as specified in `unchanged.R`, and Boolean numeric conversion. These were audit-instrument corrections, not production defects. Final logs are passing.

## Material corrections (P2)

### N1 — Confusion-matrix note does not describe its rows

**Location/evidence:** Supplement eTable 5, pp. 19–24, visually inspected p. 24; `manuscript-supplement.R:109–116,178–180`. The body has reference-label rows with predicted-category columns and repeats **N=102** on each of the three rows in each matrix (Published Overall has 81). The note says “N is the denominator on each row,” then describes pooled 510, agreed-reference 388/52/42, exact-agreement percentages and paired differences, none of which appears in this table. For example, Expert 2 / Unassisted / D1 / Low sums to **80**, not 102. The data are correct; N is the total matrix population, not the reference-row total.

**Reader effect:** a reader normalizing a row can use the wrong denominator, and may infer that agreed-reference or paired analyses are present.

**Correction:** give a dedicated matrix note: rows are independent-expert categories; columns are source predictions; entries are cell counts; N is the total across all three reference rows for that expert/source/domain matrix; domains have 102, Overall 102 for model arms and 81 for Published. Remove unrelated pooled/agreed-reference/contrast wording. Optionally label the column group “Predicted label.” Do not change the valid matrix counts or N values.

### N2 — Published binary metrics lack their defining footnote

**Location/evidence:** eTable 6, pp. 25–26, visually inspected p. 26. Heading is **Sensitivity¹**, but no footnote 1 exists; the only note is the bootstrap sentence. `manuscript-tables.R:6–9` defines the intended positive class and suppression rules, but `supplement_note()` never attaches that information to this table. `agreement.R` correctly uses reference rows: sensitivity is detected Published Some concerns/High divided by Published-positive count; specificity uses Published Low. Published Overall uses 81, whereas domains use 102 and pooled domains 510. All-Low sensitivity/coefficients are deliberately suppressed, not unavailable observations.

**Reader effect:** the reference direction and positive class are ambiguous, and dashes can be mistaken for undefined sensitivity rather than deliberate omission.

**Correction:** attach a table-specific note defining Published as reference, Some concerns/High as positive, denominators and percent CI bounds, 510/102/81 populations, and the intentional All-Low suppression policy. Remove the orphan superscript or supply its exact numbered note. Existing numerical results need no change.

### N3 — Paired signalling table omits contrast direction and units

**Location/evidence:** unnumbered attachment to eTable 13, Supplement pp. 46–48; visually inspected p. 48. `signalling_display(...,TRUE)` multiplies estimates/intervals by 100, but headings are just “Five-Level Exact” / “Collapsed Exact”; values such as **50.0 (21.4–76.9)** have neither `%` nor `pp`. The table's note at `manuscript-supplement.R:240` is only `CI_NOTE`. Neither note nor title states ARBITER minus Unassisted.

**Reader effect:** a positive value can be read as an absolute percent agreement rather than a paired percentage-point gain; direction is unstated.

**Correction:** label columns “ARBITER − Unassisted, percentage points (95% CI)” or add that precise note, and define n as the shared eligible component count. Reuse the existing Figure 5 definitions; do not subtract source-specific absolute rates.

### N4 — Rules-only split sensitivity calls assumed losses observed “Neither”

**Location/evidence:** eTable 14, Supplement p. 53. Final row says **Neither, 21/80, 26.2% (19.0–33.7)**. `win-share.R` sets `other <- !arbiter & !baseline`; the saved row's note explicitly says “Neither includes split cells forced as ARBITER losses.” The display drops that note. The special relabel at `manuscript-supplement.R:131` fixes this only for `primary-endpoint`, not `rules-only-primary`.

**Reader effect:** 21 looks like observed expert agreement that neither repaired arm was defensible. It combines **20 assumed split losses and one observed neither-arm result**.

**Correction:** preserve the 21/80 calculation but explicitly label the combined category and state its 20+1 composition. Keep the original discordant population and label-tie credit rule. Do not relabel all 21 simply as “split losses.”

### N7 — Cost/reconciliation tables do not identify what their numbers mean

**Location/evidence:** eTables 21–22, Supplement pp. 72–76, visually inspected pp. 73 and 76. Each uses generic `Measure` / `Value` and only the bootstrap note. eTable 21 places **Harness Total 1140.34 / Harness Median 11.11** beside reconstructed ARBITER equivalents **386.07 / 3.78**, without the methods' explicit warning that harness costs are unusable and have an unknown basis. “Lower/Upper” are reconstruction bounds, not bootstrap limits. eTable 22 presents `Request Write1`, `Gap Write1`, `High Requests`, etc., without units or definitions.

**Reader effect:** readers can mistake harness values for alternative expenditure estimates, reconstruction bounds for 95% CIs, or token totals for rates/per-trial quantities.

**Correction:** provide table-specific notes: eTable 21 values are US$ equivalents, totals cover 102 trials, medians are per trial, primary side-call write assumption is one hour, 5m is a cache-duration sensitivity, lower/upper are reconstruction bounds, and harness figures are retained diagnostics with unknown/unusable cost basis. eTable 22 values are aggregate token counts or event/turn counts; define request/result/side/gap, Write1=one-hour writes, Write5=five-minute writes, and the >100,000-token “high request” threshold. No generic bootstrap claim belongs beneath either table.

### N10 — Directional disagreement table leaves the direction's reference implicit

**Location/evidence:** eTable 11, Supplement pp. 35–36, visually inspected p. 36. Title says “against independent experts,” rows say “Stricter” / “More lenient,” and note is only the bootstrap sentence. `expert-agreement.R::direction_of_disagreement` actually defines direction by **arm versus Published**, then classifies the independent expert as matching the arm, Published, or neither.

**Reader effect:** “stricter” can be read as stricter than the independent expert, changing the analysis's meaning.

**Correction:** add a short table-specific note explicitly defining direction relative to Published and the subsequent expert-match partition. Retain all counts/intervals.

## Minor corrections (P3; not headline-result defects)

**N5 — Numeric column separation in eTable 15.** On rendered p. 61, several lower rows visually join `n=102` and `Original violations=12` as `102 12` with almost no column gap (also 509/26). The values are correct in CSV. Widen the numeric gutters or restructure/narrow source labels; add the missing definitions of N/PN and NI resolution and state these are count summaries, not CI estimates. Source: `add_paginated_table` automatic widths and `supplement_note` default. This is a legibility correction; the image-review owner can coordinate it.

**N6 — Bootstrap boilerplate attached to deterministic count tables.** Confirmed on the final rendered pages of eTables **1,3,5,10,12,15,17,18,21,22**. The stated 10,000-replicate CI method does not describe any displayed interval in these count/validation/reconciliation tables. Remove the CI note where no interval is shown and use relevant object/population definitions. This is particularly misleading for the deterministic reconstruction bounds in N7. The numerical verifier currently confirms exact reproduction of this inappropriate note; that pass is not a semantic check.

**N8 — Duplicate CI expansion in every supplementary figure legend.** Confirmed on actual Supplement pp. **78–82** and current `figure-legends.md`. Each says “CI, confidence interval. CI, confidence interval; ...”. Cause: `manuscript-legends.R:9–13` appends `CI_NOTE` to text already containing the expansion. Delete one expansion; retain the method.

**N9 — Stale population prose and one unfulfilled distribution pointer.** eTable 2 (domains only), eTable 4 (domains only), and eTable 16 (Overall only) retain references to populations not shown in the respective table. Most conspicuous in eTables 2/5/16 is the same all-purpose expert note. Also Table 1 promises detailed distributions “for all sources and derived Overall,” while displayed eTable 3 explicitly filters to D1–D5; Overall distributions remain only in the source CSV (or can be reconstructed from confusion counts). Tailor notes to each table and either restore existing Overall distribution rows or correct the Table 1 pointer. These do not establish a wrong estimate.

**N11 — Optional eligibility-table clarification.** Supplement pp. 49–52 list counts and TRUE/FALSE flags with no footnote. The independent reconstruction passes all counts and reasons. A short note that counts are reference question components by source/expert, exclusions follow the stated matching/active/answer-validity order, and paired analyses use the intersection would make it self-contained. This is an optional clarity improvement, not evidence of a faulty eligibility algorithm.

## Numerical conclusions and boundaries

Verified: 102 trials/16 reviews/510 cells; 80 discordant/60 agreed/20 split; 53/60 and 63/80,61/80,53/80; 371/510 versus 332/510 and 433/510 versus 400/510; gains 7.6/6.5 points with retained intervals; D5 gains and D3 reference dependence; 386/510 versus 395/510 Published; 388/510 expert agreement; separate 102/81 Overall cohorts; correct reference direction for both expert and Published sensitivity/specificity; 26 repaired labels; 65/509 rule breaks partitioned 26+39; 1,538 active answered bases, 1,407 text/14 image records, 102 bundles; runtime medians/IQR and paired mean difference; reconstructed cost medians/IQR and paired mean difference. Current figure-source filters and scales preserve every selected interval, all 16 reviews, and sparse/zero paired question rows. Headline intervals/retained estimates were checked for invariance, not recomputed.

Protected Figure 2 is illustrative: 15 active + 7 inactive questions, seven captured sources and 16 stored quote records are compatible with **15 distinct currently cited evidence records**; the total stored-record count and active-cited count are different denominators. Both experts' independent AVATAR D5 is Some concerns. No artwork edit is proposed.

The external sample sizes in eTable 23 were independently checked: Xiong **158 trials** in the [primary indexed abstract](https://pubmed.ncbi.nlm.nih.gov/42144258/), and Gandhi **50 RCTs** in the [primary article](https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0353155). This was a numeric spot verification, not a replacement for the separate literature audit.

No new target-matching stratification was introduced. Observed Published Overall missingness is ordinary exclusion, not an error category. Structural checks remain distinct from semantic evidence support; list-price equivalents and runtime remain computational resources. Full graphical/layout and clinical-source interpretation reviews are owned elsewhere. After parent corrections, recheck modified notes/labels against the actual refreshed pages and rerun existing publication-row contracts; no statistical rerun is needed for these findings.
