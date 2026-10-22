# Independent final visual review: Supplement pages 1–69

**ISSUES — not an unconditional PASS.** All **69/69 assigned pages** were individually opened using `view_image` at readable full-page resolution, in sequential batches. Zero pages were assessed only by contact sheet or programmatic extraction. Physical image/PDF page numbers agree with the visible printed numbers on all 69 pages. No visual-review blocker. This slice contains prose and tables, **no figures**; figure lettering, axes and labels are outside this assignment. TRIPOD-LLM and Supplement pages 70–137 were not inspected. No neighboring page outside the assignment was needed.

Read: `parent-findings.md`, `jama-style-contract.md`, `supplement-a/report.md`, `numbers/report.md`, and `remediation/report.md`. Used the PDF skill's visual review workflow. Baseline HEAD observed: `951dddd3e28e0d6316c641491667353e0b851a78`. Production artifacts are uncommitted; this report concerns the actual `remediation/proof-jama/Supplement/page0001-001.png` through `page0001-069.png` inspected in this turn, not earlier proofs. `coverage.csv` records every page, image SHA-256, display, method and finding. Only this report and that ledger were written. No production edits, rebuilds, statistical reruns, browser, commit, push or delegated agents.

## Mandatory corrections

### FVA01 — P2: eTable 2's note misstates one class of paired contrasts

**Exact location:** Supplement pp 9–21, eTable 2, repeated note; e.g. `remediation/proof-jama/Supplement/page0001-009.png`. Source: `analysis/R/manuscript-supplement.R:241`.

The note says “paired differences are ARBITER minus the named comparator in percentage points.” The table also contains **Unassisted minus Published** rows. On p 9, that row is 6.1 pp (2.9–9.0), distinct from ARBITER minus Published at 13.7 pp (10.6–16.9). The retained `analysis/output/tables/independent-differences.csv` independently confirms the two comparisons and values. The row labels are correct, but the blanket note contradicts them.

**Action:** define every difference as the first named source minus the second named source, with percentage-point units for exact agreement and coefficient units for κ. Preserve all estimates. Apply to every eTable 2 continuation. This is a definition correction, not a preference or a finding of faulty arithmetic.

### FVA02 — P2: many inferential displays omit the confidence level

**Exact locations:** eTable 2A pp 22–24; eTable 4 p 27; eTable 6 pp 40–41; eTable 7 p 42; eTable 8 pp 43–48; eTable 8A pp 49–50; eTable 9 pp 51–52; eTable 11 pp 54–55; eTable 13 pp 58–64. Corresponding image files are `page0001-022.png`–`024.png`, `027.png`, `040.png`–`052.png`, `054.png`–`055.png`, and `058.png`–`064.png` in the same proof directory. Source: shared `CI_NOTE` at `analysis/R/manuscript-tables.R:5`, appended by `supplement_note()` and support-table calls in `analysis/R/manuscript-supplement.R:263,302`.

These tables show limits but do not state **95%** in their title, headings or local notes. Expanding CI and naming the bootstrap procedure does not identify the confidence level. For example, eTable 9 shows the central 53/60 (88%; 80–96) result but never calls those bounds a 95% CI locally; eTable 4's generic “Value” is similarly underspecified. By contrast, eTable 2 and eTable 13B explicitly identify 95% CIs in their headers.

**Action:** state that displayed parentheses/bounds are 95% CIs and retain the existing percentile-bootstrap method. Prefer a concise common definition, retaining explicit labels where already present. Recheck rendered notes for fit after changing the shared string. No new intervals or computation are requested.

### FVA03 — P2: stale display notes remain in the unweighted tables

**Exact locations:** eTable 2A pp 22–24 (`page0001-022.png`–`024.png`); eTable 7 p 42 (`page0001-042.png`). Sources: `analysis/R/manuscript-supplement.R:302` and `:246` respectively.

- eTable 2A contains only **unweighted κ**, but its note says “Unweighted κ and exact agreement (%)” and mentions pooled 510 cells although no pooled row is shown. It also fails to define its actual “Overall (all)” versus “Overall (observed)” populations; those labels have N=102 versus 81. The original source `expert-unweighted.csv` identifies κ as the metric, confirming this is stale presentation metadata.
- eTable 7 contains **unweighted κ and exact agreement**, but its note explains AC2, sensitivity, specificity, the positive class, All-Low suppression, omitted-coefficient dashes and pooled domains. None of those metrics/rule/dashes/pooled rows appears in this table. This is the generic-note problem from SA05/N9, not fully resolved by the claimed table-specific remediation.

**Action:** tailor each note to its visible contents. For 2A, define κ and its CI plus the 102-trial all-label and common 81-trial observed-Published subsets and missing-label exclusion. For 7, retain Published as reference, unweighted κ, exact agreement, the 102-domain/81-observed-Overall populations and CI definition; remove metadata for absent analyses. Keep data unchanged.

### FVA04 — P2: absolute signalling tables still leave answer codes and zero-eligibility dashes undefined

**Exact locations:** eTable 13 pp 58–64, especially question 2.4/2.5 rows on pp 59 and 62 (`page0001-059.png`, `page0001-062.png`); eTable 13A p 65 (`page0001-065.png`). Source: `analysis/R/manuscript-supplement.R:252` and the “Five-level disagreement types” support-table note.

The absolute table refers to Y/PY/N/PN/NI but does not expand those abbreviations locally. Questions 2.4 and 2.5 have dashes with neither a printed eligible N nor a dash definition; a standalone reader cannot distinguish zero eligible components from omitted or unavailable output. eTable 13A also uses the codes without expansion. The paired table immediately following provides both the full code expansion and an explicit zero-eligibility dash definition, demonstrating the intended meanings are available.

**Action:** repeat the code expansion in the absolute/disagreement notes and define the absolute-table dash as no eligible question components after confirming the existing zero-N source rows. Preserve those rows and all stored values; do not convert undefined rates into 0%. The paired table's note can be reused with source-specific rather than paired eligibility wording.

## Optional presentation preference

### FVA05 — P3, preference: preserve short comparison blocks when paginating

**Exact locations:** eTable 2 pp 20–21 (Expert-to-expert D5 alone on p 21); eTable 3 pp 25–26 (Unassisted Overall Low/Some concerns on p 25, High alone at the top of p 26); eTable 9 pp 51–52 (More lenient ARBITER/Unassisted on p 51, Neither alone on p 52). Images: `page0001-020.png`, `021.png`, `025.png`, `026.png`, `051.png`, `052.png`. Pagination logic: `analysis/R/manuscript-supplement.R`, `add_paginated_table()`.

Titles, columns and notes repeat, so these are interpretable and do not lose data. Nevertheless, one-row continuation pages and splitting a three-category partition weaken the requested coherent reader impression. Keep each short reference/category or analysis/metric block together; a small reflow can avoid orphan rows without shrinking fonts. This is a preference, not an additional mandatory scientific failure.

## Passes and limits

**PASS for visual legibility and containment in this slice:** no clipped/overlapping cells, illegible tiny text, truncated headings or broken glyphs observed. Tables use restrained rules and readable cell/footnote text. Continuations retain their display identity and definitions. Contents p 2 correctly locates all table starts inspected here, including 2A, 8A, 12A and 13A–13C; visible page numbers run correctly from 1 through 69. Later contents destinations and hyperlink/bookmark behavior were not tested.

**PASS for the specific resolved issues visible here:** eTable 1 defines topic abbreviations/SC and has no irrelevant bootstrap note; eTable 3 restores Overall rows and separates 102 versus 81; eTable 5 defines matrix orientation and matrix-total N; eTable 6 supplies the positive class, reference denominators and All-Low reporting convention; eTable 9 distinguishes assumed split losses and states the severity comparator; eTable 10 explains nonexclusive label credits; eTable 11 states direction relative to Published; eTables 12/12A do not attach inappropriate CI boilerplate to deterministic counts; eTable 13B explicitly defines direction, pp, 95% CI, paired N, codes and zero eligibility; p 69 eligibility counts are explicitly components rather than trials with mutually exclusive reasons and no raw boolean column. The slice's methods distinguish structural binding from semantic support and computational price equivalents from expenditure.

Targeted source checks confirm displayed p 9 contrasts, the p 51 primary 53/60 result and integer rounding, p 58 absolute component denominators, and p 66 Expert 1 D3 −10.3 pp (−17.2 to −3.2), N=165, against retained CSVs. This is not a new exhaustive numeric reproduction; the numerical audit owns that. Native gt/editable-Word provenance is not established by raster images alone. Protected main Figures 1–2 and numerical-export invariance were not re-audited or changed. Author fields remain outside this slice; no declarations were invented.

**Completion:** 69 assigned / 69 individually visually inspected / 0 omitted / 0 blockers. **Unresolved objections:** FVA01–FVA04 require correction and refreshed-page verification; FVA05 is optional. Later rules-only sensitivity, resource tables, figures, AVATAR trace and reporting map belong to the other review slice, so this report does not clear them. Any regenerated pages require renewed visual coverage; hashes in the ledger identify this reviewed version.
