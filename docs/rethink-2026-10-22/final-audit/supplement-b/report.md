# Supplement B final audit

**ISSUES.** All 52 assigned Supplement pages (55–106) and all five TRIPOD-LLM/GRRAS pages were inspected individually with vision at reading size. No assigned page is blocked or uninspected. Seven concrete correction groups follow; two further presentation refinements are optional. No discovered numerical discrepancy requires new estimates, a bootstrap, or a model run.

Baseline requested and actual HEAD at start and end: `951dddd3e28e0d6316c641491667353e0b851a78`, obtained with `git rev-parse HEAD`. This is an audit of the shared uncommitted package at that HEAD, not a claim that the package is committed. No production edit, rebuild, commit, push, or nested agent was performed. Writes are confined to this directory.

## Method and evidence

Read the accepted `rebuild-brief.md`, `second-review/blueprint.md`, `book-principles.md`, and `implementation-report.md`; the consolidated brief/blueprint governed interpretation over raw review suggestions. Applied the requested [Pstack Prove It Works leaf](C:/Users/Ali-Salman/.codex/plugins/cache/pstack-claude/pstack/0.9.101/skills/principle-prove-it-works/SKILL.md). Read the previously verified `second-review/literature/report.md` and retained `docs/manuscript/references.md`, then independently compared every displayed prior-work entry with the consolidated evidence. No unresolved factual literature claim required browsing.

Opened every assigned PNG with `tools.view_image`, in batches of 3–5 individual pages. Inspected actual full pages, not contact sheets. Proofs: `rendered/Supplement/page0001-055.png` through `page0001-106.png` and `rendered/TRIPOD-LLM/page0001-1.png` through `page0001-5.png`. Did not use stale `Table3.png`. [coverage.csv](coverage.csv) gives all 57 page/display outcomes.

Read generators `analysis/R/manuscript-supplement.R`, `manuscript-figures.R`, `checklist.R`, `expert-agreement.R`, `algorithms.R`, `load.R`, `avatar-trace.R`, `api-cost.R`, `unchanged.R`, and relevant presentation transforms. Read the relevant display CSVs. [verify_slice.py](verify_slice.py) independently checks 12 table/trace exports against rendered PDF text after the visual review, tests count arithmetic, and records proof SHA-256 hashes in [verification.json](verification.json). It passed: **1,646 table/trace cells present**, seven count checks true. Cell presence is an export check; it does not establish that source evidence semantically supports a model answer. The report does not endorse AVATAR model judgments as clinical truth.

Scope limits: figures/main tables and Supplement pages 1–54 are other audit slices. I did not revalidate their full source estimates, protected artwork bytes, or the whole experiment. Pages 55–58 are the continuation of a table beginning outside this slice; their visible rows, headers, denominators and ending note were inspected here.

## Required corrections

### B01 — Table notes describe analyses the displayed tables do not contain (P2)

**Locations/evidence:** Supplement p61 eTable 15, p65 eTable 17, p69 eTable 18, p73 eTable 21 and p76 eTable 22 all print the generic confidence-interval/10,000-bootstrap/seed note. These displays contain raw counts, mismatch records, point cost summaries or token reconciliation, with no bootstrap intervals. The cause is `supplement_note()` in `manuscript-supplement.R:194`, which adds `CI_NOTE` to every source except literature. For example, p61 contains 26 original contradictions, 39 invalid paths and 3/36 additional violations; its note explains none of those columns and instead describes a bootstrap.

**Reader consequence:** The note implies inferential treatment of deterministic audit listings and leaves the actual table interpretation unexplained. A reader cannot tell locally what N/PN versus NI replacement means, or why a raw audit row lacks a value.

**Correction:** Select notes by table type. Remove CI boilerplate from count/listing/reconciliation displays. On eTable 15 define original contradictions, invalid paths, recursive replacement, additional contradictions and final total; preserve 29 and 62 as currently computed. On eTables 18–19 define `—` as unavailable/not measured for comparator trace checks, not zero. On p70 eTable 19 the CI note is appropriate, but the `Value` heading should explicitly say proportion (95% CI) and the absent comparator dashes need that local definition. Retain the existing structural-versus-semantic boundary and 21/7/1 validation explanation.

### B02 — Changed-cell table does not identify the arm or what its flags mean (P2)

**Locations/evidence:** Supplement pp59–60, “Cells changed by rules only recomputation,” columns `Original`, `Recomputed`, `Discordant`, `Consensus`, with raw TRUE/FALSE and no note. `expert-agreement.R:119–123` shows these are **Unassisted** original/recomputed labels joined to fixed original-cell flags. `load.R:92` defines arm discordance; `load.R:113` defines consensus from equal **forced-choice labels**, not equal independent expert ratings.

**Reader consequence:** Readers may interpret “Consensus” as agreement between the independent expert assessments, or “Discordant” as a disagreement created by repair. The table does not itself say whose labels changed. Those distinctions determine the endpoint population.

**Correction:** Name Unassisted in the title or note; relabel flags “Original arms differed” and “Experts chose the same label,” use Yes/No, and state that original eligibility stays fixed after repair. Retain all 26 observed changes. Give this unnumbered subtable an explicit parent-table locator or subpanel identifier.

### B03 — Cost-reconstruction table lacks displayed currency and measure definitions (P2)

**Locations/evidence:** Supplement pp72–73 eTable 21: heading `Value`, entries `Point Total 386.07`, `Harness Total 1140.34`, `Side 5m Point Total 365.88`, etc. No US$ label, number of trials, meaning of lower/upper or Side 5m, or warning on harness estimates appears in this table's note. The eMethods generator does explain that harness costs are unusable due to an unrecognized model/unknown cost basis and that five-minute side-call writes are a sensitivity. Those facts do not accompany the actual display.

**Reader consequence:** A detached display can be read as expenditure or alternative valid cost estimates. The larger harness number appears equally credible to the reconstructed primary estimate.

**Correction:** Label values “API list-price equivalent (US$)” and distinguish totals across 102 trials from medians per trial. Define point/bounds and the side-call cache-write sensitivity. Explicitly mark harness figures as unusable diagnostic records with unknown cost basis. Keep the subscription-versus-equivalent-cost distinction; do not imply invoices or human time.

### B04 — Reconciliation output exposes undefined implementation fields and mixed units (P2)

**Locations/evidence:** Supplement pp74–76 eTable 22: `Request Write1`, `Result Write1`, `Side Write1`, `Gap Write1 −3041`, `High Requests 3272`, `Turns with Request Excess 3`, all under one generic `Value` column. No glossary or mixed-unit note appears. `api-cost.R:65–81` defines request counters, terminal result counters, side usage and gap = terminal result minus deduplicated request counters; `unchanged.R:31–37` aggregates tokens and event counts.

**Reader consequence:** A JAMIA reader cannot reconstruct what is being reconciled, which values are token counts versus events/turns, or whether the negative gap signals missing usage or a calculation failure. “High Requests” is especially opaque and is not a risk-of-bias judgment.

**Correction:** Separate token totals from request/turn/event counts, define all measures, spell out one-hour/five-minute cache writes, define request/result/side/gap and its sign convention, and explain the high-request threshold if retaining that diagnostic. Use grouped integers for long token totals. Do not alter the underlying counts or broaden model reporting.

### B05 — Question-level plots are compressed and their row labels are too small (P2)

**Locations/evidence:** Supplement pp79 and 82 (eFigures 2 and 5) have tiny question/expert/paired-n labels; p80 (eFigure 3) has very small undefined-kappa annotations. Independently visible in the full-page images. `question_difference_plot()` configures y labels at **6.5 pt** (`manuscript-figures.R:165`). Both question figures export at 174 × 245 mm (`:216,219`) but are placed at 6.7 × 8 inches = approximately 170 × 203 mm (`manuscript-supplement.R:254–257`). The placement compresses the vertical dimension approximately 17%, giving about 5.4 pt vertical label height. The undefined-kappa text uses `geom_text(size=2)` (`manuscript-figures.R:23`), approximately 5.7 pt before placement.

**Reader consequence:** Paired eligibility denominators and expert identities are part of the scientific meaning but become the hardest elements to read. eFigure 5's completeness is nominal if its rows require substantial enlargement; anisotropic scaling also distorts its text.

**Correction:** Preserve the native aspect ratio and split the question plots into readable multi-page/domain panels with repeated axes and legends; target at least the accepted 8–10 pt figure-label range at final size. Enlarge undefined-kappa annotations or use a readable status column. Keep every question, both experts, sparse/zero-answer rows, 95% intervals and all 16 review rows. No observed interval needs a new estimate or data omission.

### B06 — Mechanical trace pagination separates the inspectable chain (P2)

**Locations/evidence:** Supplement pp83–96, especially p87 and p90: each contains only two inactive question entries, with most of the page empty. D4's judgment is on p91 but its answers start on p92; D5's judgment is on p94 but its answers start on p95. On p102 the next evidence handle `eh_c8e0958840636206`, source, page and lines are at the bottom, while its hash and quote start p103. Generator `manuscript-supplement.R:267` forces a page break after every two rows, regardless of length; metadata paragraphs can still split.

**Reader consequence:** The core system claim is a record a reader can inspect. A 23-page trace with tiny two-row fragments and separated identifiers makes following a judgment to its answer and evidence unnecessarily difficult. This is a navigation defect, not an objection to preserving the complete record.

**Correction:** Remove fixed two-row breaks in favor of domain/record-aware flow. Keep each question heading with its answer, keep evidence handle/source/page/lines/hash together with the beginning of its quote, and start new domains where useful. Preserve all original model text and full evidence exports; do not edit model reasoning to make it seem stronger. Reproof the resulting pagination.

### B07 — Reporting map remains a draft map and overstates some locations (P2)

**Locations/evidence:** All five TRIPOD-LLM/GRRAS pages. Examples: p1 item 1 points to “Manuscript title (ANALYSIS-PLAN section 7)”; abstract/background and p4 discussion rows still say “author assembly”; pp1–5 repeatedly say only “supplementary table.” GRRAS 6–7 on p5 reference internal `Benchmark README-FOR-ALI.md`. Item 5c “Text dates” is marked “Reported at the named display or supplement location,” pointing to Interpretive limits, whose actual text does not give text-date coverage. `checklist.R` is the source of these locators/statuses; `build_reporting_map()` drops the page field rather than replacing pending pagination with actual locators.

**Reader consequence:** A reader cannot use the reporting checklist to find the claimed material, and “Reported” can imply an item is complete when the named section does not supply it. Current manuscript prose already exists, so draft “assembly” labels obscure what is actually complete.

**Correction:** Update the map against the finished manuscript/supplement: real section titles, eTable/eFigure numbers, page locators when finalized, and truthful complete/partial/not-reported status. Remove internal planning-file references from reader locators. For text-date coverage, mark the actual reporting state; do not fabricate dates or introduce prohibited study-history declarations. Preserve explicit unresolved author fields (expert qualifications, ethics, funding/conflicts, registration, public involvement and archive details) as author-completion items. Their absence is already acknowledged and is distinct from stale map generation.

## Optional refinements, not numerical/material defects

- **B08 (P3):** Every inspected Supplement page lacks a visible printed page number. A 106-page appendix with tables continuing over several pages would be easier to navigate with page numbers and a page-linked contents map. This is an additional usability recommendation, not evidence of lost content.
- **B09 (P3):** eFigures 1–5 appear together at pp78–82 after the prior-work ledger rather than next to the questions/sections they explain. Relocate or explicitly index them by supporting section. Shorten duplicated caption phrases such as “CI, confidence interval. CI, confidence interval” (pp78–82). No result changes are needed.

## Checked claims and numerical boundaries

- eTable 16 keeps 102-trial expert Overall separate from 81 observed Published labels and from the 52/42 agreed-reference restrictions; the printed note excludes the 21 missing labels. Paired contrasts use pp, and the expert-to-expert Overall row is identifiable. No missing-label-as-error inference was found in that comparison.
- eTable 17 contains 29 differences: 21 absent Published Overall values, seven permitted High escalations (six Published, one ARBITER), and one Published Low versus derived Some concerns. All match its CSV and explanatory count note; no new discrepancy was inferred from ordinary missingness.
- The changed-cell listing contains 26 distinct rows; all Original/Recomputed labels actually differ. eTable 15 totals satisfy original + additional = final: 26 + 3 = 29 and 26 + 36 = 62. Its presentation problems are B01/B02, not a count error.
- eTables 18–19 keep 1,538 answers, 1,421 distinct evidence records, 1,407 text spans, 14 image records and 102 bundles separate. Their section/caption explicitly bounds structural checks. eTable 20 distinguishes medians [IQR] from paired mean differences [95% CI] and labels runtime/cost units; no human-time-saving claim was found in these pages.
- eFigure 1 labels the 102/81 Overall population difference. eFigure 2 states the n≥20 threshold; eFigure 5 retains sparse and zero-n rows. Five-level and collapsed coding remain separate. eFigure 3 retains all 16 reviews, including undefined/degenerate values; negative kappa is within its axis. No clipped interval was observed in the assigned figures. B05 concerns the readability of labels, not hidden data.
- eTable 23's RobotReviewer, ROBoto2, Huang, Xiong, Gandhi, Li and Lai entries agree with the parent-verified evidence and retained citations (references 8–12, 15 and 22); ARBITER's evaluated commit matches p106. It does not claim unique inspectability, rule use, first same-model prompting, superior cross-study percentages, or transferred workload benefit. No literature correction is requested.
- The AVATAR answer/evidence prose matches all 28 answer/rating rows and all 16 evidence records in the retained trace CSVs. Raw extracted evidence includes flattened tables and incomplete sentence boundaries, which are preserved data; I do not recommend silently rewriting those quotes. The trace's semantic judgments remain model outputs, distinct from structural preservation.

**PASS:** complete assigned-page inspection and source/export/count checks. **ISSUES:** B01–B07. **BLOCKED:** none for this audit. Parent correction and final reproof remain necessary before calling the assigned slice publication-ready.
