# Supplement A independent final audit

**ISSUES.** Visual coverage complete: Supplement pages 001–054, each opened individually with `view_image` at reading size, in batches of four or five. No assigned page was reviewed only from a contact sheet or text extraction. No visual-review blocker. No production edits, rebuild, model runs, bootstrap, commits, pushes or nested agents.

Baseline requested and actual HEAD at inspection: `951dddd3e28e0d6316c641491667353e0b851a78` (`git rev-parse HEAD`). The package is uncommitted; `git status --short` was inspected. Findings concern the existing final Word proofs `rendered/Supplement/page0001-001.png` through `page0001-054.png`, not stale standalone tables. Physical PDF/image page numbers below are one-based; the document itself lacks printed page numbers.

Read authorities: rebuild-brief.md, second-review/blueprint.md, book-principles.md, implementation-report.md, and the Pstack principle-prove-it-works leaf. Applied the accepted scope: 510 independent domain cells; conditional primary 53/60 from 80 discordant cells with 20 splits; 81 observed Published Overall; no new analyses or target-matching differentiation. This slice contains text and tables, **no graphs**; graph axes, legends and uncertainty marks are therefore not applicable to these 54 pages. Graph review belongs to the other assigned slice.

## Material clarity/scientific-reporting findings

### SA01 — P2: Paired signalling effects lack units and subtraction direction

Location: pp46–48, “Paired signalling differences,” within eTable 13. Headings remain “Five-Level Exact” and “Collapsed Exact”; values include `11.0 (8.1–13.9)` and D3 Expert 1 `−10.3 (−17.2 to −3.2)`. The sole endnote is the generic bootstrap sentence. It does not say percentage points or ARBITER minus Unassisted. Nor do the table's headings identify the intervals as 95%.

Why it matters: a reader cannot interpret the sign or distinguish a relative percentage change from a paired percentage-point difference from this display alone. The D3 sign reversal is central scientific evidence, so this is more than typography.

Evidence: `signalling_display(..., difference=TRUE)` in `analysis/R/manuscript-supplement.R:105` multiplies by 100 but writes no unit; the paired-table call at line 240 supplies only `CI_NOTE`. Raw `signalling-differences.csv` confirms D3 Expert 1 n=165, −0.1030303 and +0.0848485.

Correction: headings “Five-level Δ, pp (95% CI)” and “Collapsed Δ, pp (95% CI)”; note “ARBITER minus Unassisted; n counts components evaluable in both arms. Positive values favor ARBITER. Five-level distinguishes Y/PY/N/PN/NI; collapsed combines Y/PY and N/PN, with NI separate.” Replace `— —` for n=0 with a single dash and define it as no eligible paired component. Preserve all estimates.

### SA02 — P2: Rules-only split sensitivity again presents assumed losses as observed “Neither”

Location: p53, eTable 14, final row: “Counting split decisions against ARBITER / Neither / 21 / 80 / 26.2%.”

Why it matters: 21 does not mean 21 observed choices of neither arm. The raw row explicitly says “Neither includes split cells forced as ARBITER losses”; it combines 20 assumed split losses with one remaining neither result. The original eTable 9 correctly relabels its 20 assumed losses on p33, making the inconsistency especially misleading.

Evidence: `rules-only-primary.csv` records the explanatory `note`; `estimate_display`/the eTable 14 rendering drops it. The special relabelling at `manuscript-supplement.R:131` applies only to `primary-endpoint`, not `rules-only-primary`. The p53 endnote mentions ties but never distinguishes this assumed component.

Correction: relabel as “Neither or assumed split losses” and note “21 comprises one neither result plus 20 split choices counted against ARBITER by assumption.” Keep 21/80 and all existing intervals. Explicitly retain that source-match rows can overlap after repair because ties credit both arms; 53+8+1 exceeds 60 for this reason, not an arithmetic defect.

### SA03 — P2: Published-reference table loses its substantive definitions and footnote

Location: pp25–26, eTable 6; `Sensitivity¹` has no corresponding numbered note. Its only note is the generic bootstrap line. AC2, linear weighting of κ, the binary positive class, the All-Low reporting restriction and dash meaning are not defined here.

Why it matters: sensitivity could be read as detection of High alone, whereas the intended positive class is Some concerns or High. The unexplained dash for All-Low sensitivity can suggest non-computability; it is an intentional existing reporting restriction, not a request to estimate it anew.

Evidence: `analysis/R/manuscript-tables.R:6–9` already defines `AGREEMENT_NOTE` with these concepts, but `supplement_note()` never supplies it for `agreement-meta`. The display CSV retains `Sensitivity¹` and All-Low dashes. The original restriction is visible in `analysis/R/unchanged.R:59`.

Correction: use a concise table-specific note: “Linearly weighted Cohen κ; Gwet AC2. Some concerns or High is positive. Sensitivity/specificity use Published-positive/Published-Low denominators. Overall uses the 81 observed Published labels. All-Low reports agreement and specificity only by reporting convention; — marks an omitted/not-applicable coefficient. Parentheses are 95% CIs.” Resolve or remove the superscript. Do not introduce new estimates. Apply the relevant coefficient/Overall definitions to eTable 7 p27 as well.

### SA04 — P2: Direction and severity strata have different comparators but neither table says so

Location: p33 eTable 9 “Post hoc: Stricter / More lenient”; pp35–36 eTable 11 “Direction: Stricter / More lenient.” Both footnotes omit what the direction is relative to.

Why it matters: in eTable 9 direction means ARBITER versus Unassisted; in eTable 11 it means the named source versus Published. Readers can easily carry the first definition into the second and infer the wrong population. eTable 11's title “against independent experts” does not define the selection rule.

Evidence: `analysis/R/expert-agreement.R:87–104`: `direction_of_disagreement()` compares source with `meta`; `primary_analyses()` compares `kit` with `nokit` among agreed, arm-discordant cells. eTable 11 populations are 88/36 for ARBITER and 69/46 for Unassisted.

Correction: p33 note “Stricter/more lenient describes ARBITER relative to Unassisted among the 60 agreed choices.” eTable 11 caption “Expert ratings among source–Published directional disagreements”; note “Direction compares the named source with Published. n counts those differing domain cells; outcomes partition independent expert matches to the source, Published or neither. Exploratory.” No target-matching strata are needed.

### SA05 — P2: Generic notes describe analyses/populations absent from their tables

Locations and concrete examples:

- p6 eTable 1: a benchmark inventory receives a CI/bootstrap note despite having no intervals. SC and the clinical abbreviations in Topic remain undefined.
- p17 eTable 3: category counts receive the bootstrap note and a sentence about missing Published Overall even though every row is D1–D5.
- p14 eTable 2: the note devotes most of its text to Overall all/observed and n=52/42, although Overall was removed from this table.
- p16 unweighted expert table: its note describes agreed-reference analyses and paired differences that are absent from this display.
- p18 eTable 4: note says “each domain and derived Overall” although Overall is absent.
- p24 eTable 5: the confusion-matrix note describes exact-agreement percentages and paired differences, neither of which is displayed; it fails to explain explicitly that rows are expert labels and columns source labels.
- p34 eTable 10 and p37 eTable 12: count/share tables without intervals receive the generic CI/bootstrap note.

Why it matters: these are misleading metadata, not simply long prose. They obscure which denominator and method apply to the displayed evidence, contrary to the brief's explicit instruction to replace generic footnotes.

Evidence: `supplement_note()` at `manuscript-supplement.R:178–194` adds `CI_NOTE` to every numbered table except literature; it reuses `expert_population_note()` without filtering it to actual content. `TOPIC_ABBREVIATIONS` exists in manuscript-tables.R but is not included in eTable 1's note.

Correction: use notes keyed to actual table content. eTable 1: define SC and topic abbreviations; state that counts summarize five domain labels per trial and Overall given denotes availability. eTable 3: “Counts partition the 510 domain cells for each source.” eTable 2: retain only domain/pooled and agreed-reference denominators plus interval/contrast units. eTable 4: name the two experts and explain exact agreement versus linearly weighted κ. eTable 5: “Rows: independent expert label; columns: named source label. Counts; N is the total for each expert/source/domain block. Overall uses 102 trials for the arms and 81 observed Published labels.” Remove bootstrap prose where no uncertainty is displayed.

### SA06 — P2: Disputed-choice table does not explain nonexclusive source credits

Location: p34, eTable 10. Expert 1 counts 38+128+78=244 across n=154; Expert 2 counts 41+131+89=261 across n=154. These are valid label-match credits, not mutually exclusive choices.

Why it matters: without a table-specific tie explanation, readers will reasonably treat a forced-choice source table as a partition and perceive impossible totals or a large arithmetic error. The method on p3 supplies the rule, but the standalone table does not.

Correction: append “Choices are scored by label. When sources share the chosen label, each receives credit; source counts therefore overlap and need not sum to 154.” Remove its irrelevant CI note. Preserve counts.

## Navigation and layout findings

### SA07 — P2: Navigation map omits page locations and substantial unnumbered supporting displays

Location: p1 map and all pp1–54. There are no printed page numbers. The map lists only the 23 numbered tables, omitting e.g. unweighted expert agreement pp15–16, paired binary differences p32, retained answers p38, and the disagreement/paired/eligibility displays pp45–52. Continuation captions drop the eTable number (e.g. pp8,10,13), and automatic spill pages such as p9 carry only the repeated column header.

Why it matters: the 106-page supplement is difficult to navigate and cite precisely. A reader trying to find the paired diagnostic evidence supporting Figure 5 has no map entry. A continuation page cannot reliably identify itself when detached from its preceding page.

Correction: add printed page numbers; map each table and supporting display to a page or clickable bookmark; include supplementary figures and prompt/trace/reporting appendices in the map. Use “eTable 13B. Paired signalling differences (continued)” or equivalent stable subpanel identifiers on continuation pages. This needs only presentation changes.

### SA08 — P3, optional compactness improvement: fixed row chunks fragment coherent evidence and waste comparison space

Locations: eTable 2 occupies pp7–14; unweighted agreement pp15–16; binary agreement pp28–31; signalling absolute/paired/eligibility pp39–52. Examples: Expert 2 pooled ARBITER/Unassisted are at the bottom of p7 and Published starts p8; p8 ends mid-D3 expert-mean block; p49 ends with the first Unassisted D1 exclusion row and its evaluable row starts p50. Many pages retain substantial empty lower space.

Evidence: `add_paginated_table()` at manuscript-supplement.R:152–176 groups by fixed 18/20-row chunks rather than reference/domain blocks; long auto-spills add further pages. Header repetition and 9-point type remain legible; I found no clipped or overlapping cells in this slice.

Proposed compact improvement: keep reference/domain blocks together; make absolute estimates and contrasts explicit A/B panels; use side-by-side arm columns for signalling rows, and combine eligibility reasons into columns per expert/source/domain. Do not shrink the font or delete unfavorable/sparse results. This is an editorial improvement, not a numerical blocker.

### SA09 — P3: Eligibility table reads as an unexplained software dump

Location: pp49–52, “Signalling comparison eligibility.” `Evaluable TRUE/FALSE` repeats the Reason field, no local note defines component counting or the reason hierarchy, and an expert/source/domain block is split over pages.

Why it matters: counts such as D2 340 inactive +17 unmatched +4 not applicable +362 evaluable are component counts, not trial counts; readers need that unit to avoid comparing 723 directly with 102 trials.

Correction: remove redundant boolean column or replace it with a clear status heading. Add “Counts are question components in the comparison frame, not trials; evaluable requires the same explicit question/component on both sides; exclusions are mutually exclusive recorded eligibility reasons.” Point to the mapping appendix with its actual stable location. Verify the exclusion hierarchy against signalling.R before wording it more specifically.

## Verification and interpretation boundaries

The primary table on p33 independently shows 53/60, 88.3% (79.7–96.3), both expert sensitivities and the explicitly assumed 20 split losses. All-cell rows on pp7–8 show 371/510 vs332/510 and 433/510 vs400/510. D3/D5 rows and paired effects on pp10–13 and pp46–48 agree with the frozen source exports inspected. p45's disagreement counts partition correctly. Confusion-matrix diagonals and binary counts were additionally cross-checked against source estimate CSVs with the read-only audit script; see verification.json. That script validates relationships among existing counts only, not new estimates or bootstrap/model output.

Methods pp2–4 explicitly separate structural binding from semantic support and computational price equivalents from expenditure; p3 states trial resampling within 16 fixed reviews and excludes inference to new reviews/experts/model runs. No forbidden target-matching stratum, alternative-model experiment, chronology declaration, or semantic-validation/human-time claim was found on assigned pages. Overall n=81 vs102 remains explicit where shown; missing Published labels are not reclassified as errors.

This is a presentation/source-consistency audit, not a fresh raw-data statistical reproduction or independent validation of clinical answer support. Later pages/figures, F1/F2 bytes, the main manuscript and other package files are outside this slice. `coverage.csv` records every assigned physical page and local finding/pass. `page-manifest.csv` hashes the actual inspected PNGs so the parent can detect whether a subsequent regeneration supersedes this audit. No claim is made that a future rebuild inherits these visual passes.
