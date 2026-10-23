# Reporting repair

The supporting reporting sources, documentary CSVs, Word supplement, reporting-map Word file and local reader supplement are synchronized. This repair changes reporting only. It does not rerun statistics, alter study estimates or populations, modify the canonical manuscript or references, or change Tables 1–3 or figures. No git command, commit, push or deployment was performed; no nested agents were used. The requested scientific baseline is `5d3ad76`, and framing baseline is `ffa8ab2`; these identifiers were supplied in the brief and were not independently resolved with git.

## Changes and evidence

TRIPOD-LLM 9a and 9b are explicitly **Partial**. Final templates and a filled example document evaluation inputs, but do not establish prompt design/selection, development data, benchmark overlap or version-freeze provenance. The supplement requests author completion without asserting that development, tuning or overlap did or did not occur. TRIPOD-LLM 5a and 8a and GRRAS 7 and 8 are also partial for initial review selection and original assessment guidance. Existing partial credentials entries (TRIPOD-LLM 7d/8c and GRRAS 4/12) remain partial. Six map rows, or twelve section/note cells, change in the Word map. No original form, assessor qualifications, training record, target brief or first-stage selection history is represented as recovered.

The eMethods definition follows `analysis/R/signalling.R::parse_answer_components()` and `match_signalling()`: a bare code supplies one unnamed component; explicitly named clauses supply components with lowercased, trimmed names; ambiguous/duplicate syntax is flagged. Comparisons match trial, domain, question and component without broadcasting scalar answers. The expert domain ratings are read directly from `Adjudications!Independent` by `analysis/R/load.R::load_inputs()` and carried by `adjudication_cells()`; they are not computed from component aggregation. Multi-outcome assessor judgment conventions remain an author-completion item. No parser or statistical logic changed.

`kit-sonnet-5.5/run_case.py:25` and the runner README specify `/rob2-assess`. The prompt CSV, R materials source and supplement now reproduce that command prefix for the template and filled example. The source placeholders and example contents are otherwise retained. The provenance paragraph distinguishes evaluated rob2-kit commit `2848c7926a2acc25402345a42be39d695a99861a` from public ARBITER 1.0.0 commit `2f549ae30f056ff441ea61a04b719968716f2219`, and identifies `/arbiter-assess` as the public command name. The correspondence is supported by the inspected `analysis/provenance/rename-equivalence.md` normalization map and its scope finding for assessment skill/prompts. The audit explicitly rejects equivalence of the complete releases. This repair does not rerun that Git-object audit or claim whole-release identity.

`docs/round15/BRIEF.md` documents the expert sequence and author-confirmed conduct. Completed workbooks and the brief are described as documentation of the sequence, rather than as the original blank form or instructions. `rob2-meta-benchmark-set/README-FOR-ALI.md` documents within-review table-order selection and availability-dependent replacement; the added text requests the initial review identification and eligibility account. No systematic search, selection chronology or recovered assessor history is invented.

## Builder dependencies and chosen path

Inspected before editing: `analysis/run.R`, `analysis/build-publication.R`, `analysis/build-manuscript.R`, `analysis/R/load.R`, `analysis/R/displays.R`, the three owned builders, `scripts/report-refresh.py`, `scripts/build-manuscript.py`, `analysis/supplement.qmd` and `analysis/_quarto.yml`.

- `analysis/run.R` runs analyses, writes `reporting-checklist-skeleton.csv` through `save_table(reporting_checklist(), ...)`, and invokes broad publication builders. It is unsuitable for this documentary task.
- `analysis/build-publication.R` loads inputs and calls `build_displays()`, which writes main tables, optionally figures, supplement, legends, results sentences and main manuscript. It was not run.
- `build_materials(inputs, cells)` writes statistical `table1`, `table2` and `table2-differences` and uses global `meta_agreement` before writing the prompt table. It was not invoked merely to repair the prompt prefix.
- `build_supplement(inputs)` consumes retained display CSVs, builds the supplement and calls `build_reporting_map()`. `add_paginated_table()` writes the display reporting-map CSV. `build_reporting_map()` obtains current entries directly from `reporting_checklist()`, not from the stale skeleton CSV. The original skeleton has unrelated legacy assembly/pagination locators; only the six affected rows were updated there.
- The eMethods prose comes from `METHODS_APPENDIX`. `supplement.qmd` includes `.quarto/supplement-page.md`. `scripts/report-refresh.py` converts the Word supplement and refreshes both results and supplement pages, with hard-coded publication invariants. It was inspected but not run because it also writes results and broader QA outputs. Both local supplement surfaces instead received the exact six paragraph replacements.

Rscript exists, but `requireNamespace()` returned FALSE for dplyr, tidyr, readr, readxl, officer, flextable and gt. The project renv library contains renv but no usable installation of those packages. The full R builder path and statistical verification scripts are therefore **unrun**. No package installation or statistical computation was attempted.

The authorized deterministic fallback was used. Candidate files were backed up and SHA-256 hashed before editing, then repaired in `/tmp/arbiter-reporting-repair/stage`. Both DOCX files preserve every ZIP member except `word/document.xml`, including styles, relationships, embedded images and metadata. Paragraph/cell text was replaced without rebuilding tables. HTML editing changes six paragraph spans and leaves all table and image content unchanged. A before-hash guard prevented copying over concurrent edits.

The document operation marker ran successfully once immediately before the first authoring command (`edit`, expected output count 2, DOCX). Document authoring and rendering used managed Python `/home/ali/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/bin/python3` and the packaged renderer. Runtime identity was inspected in that runtime's `runtime.json`; the packaged `dependencies/bin/override/soffice` was used, not desktop LibreOffice. No workspace-dependency loader tool was exposed; the installed runtime manifest and existing repository rendering script supplied the managed paths.

## Verification

- All three modified R files pass base-R `parse()`.
- The first four top-level eMethods source expressions were evaluated with base R, without loading inputs or analyses. All **nine** resulting eMethods paragraphs exactly match the Word text.
- All six edited supplement paragraphs match Word, the Quarto include and the rendered local HTML after whitespace normalization. The prompt CSV has the evaluated prefix in its two ARBITER rows and retains all remaining fields.
- All 64 rows of the display reporting-map CSV exactly match the corresponding Word table rows. The six repaired skeleton rows match the same section/note text.
- The supplement retains **98 tables and 7,675 physical cells**, with every cell's complete text identical before/after. The reporting map retains **8 tables and 368 cells**; exactly twelve documentary section/note cells change. Every numerical token in every Word table cell is identical.
- Every purely numerical cell in all three documentary CSVs is identical. Numerical tokens outside the skeleton's documentary Section locators are identical. Three skeleton Section cells acquire current eTable locators (TRIPOD-LLM 5a/9b and GRRAS 7); these are cross-reference identifiers, not study values. The display map and prompt CSV have no numerical-token differences.
- All HTML table cells and image source strings are identical before/after in both supplementary reader surfaces. All unedited paragraph spans are retained verbatim.
- The before-hash inventory covers 187 candidate/protected artifacts. Exactly the ten listed repair files changed; the other **177** inventoried CSV, Word and figure/data-derived artifacts are byte-identical. This includes the statistical CSVs and main table/figure artifacts in that inventory. The canonical manuscript and its Word document belong to the parent writer and were not written by this task.
- All 149 rendered pages contain extracted text, with no word bounding boxes outside page boundaries (managed pdfplumber check).
- Both revised Word files rendered successfully with the packaged renderer: Supplement **141 pages**, reporting map **8 pages**. All pages were reviewed in contact sheets; the three changed supplement pages (5, 6, 141) and all eight map pages were also inspected individually at full image size. Text is readable with no newly observed clipping, overlap or table damage. The supplement was also rendered before repair: 138 pages are pixel-identical; only pages 5, 6 and 141 differ, with no pagination shift. This is differential visual QA, not a claim that all 141 pages were individually inspected at 100 percent.

The local Word/HTML documentary sync is complete. The broad R, Quarto, report-refresh and manuscript-publication paths remain unrun. No deployment or website publishing occurred. Temporary QA evidence and scripts are under `/tmp/arbiter-reporting-repair/` (`before-hashes.json`, `after-hashes.json`, `checks.json`, `page-comparison.json`, `repair.py`, `publish.py`, rendered pages and before copies); the hashes below preserve the essential evidence in the repository report.

## Outstanding facts and parent integration

The authors still need to supply prompt-development inputs/process and freeze provenance; any benchmark overlap; original blank form and instructions; assessor qualifications/training; the target brief and multi-outcome judgment conventions; initial review identification and eligibility; and the exclusion rationale for Atwine 2020 identified in the methods report. None was inferred from completed templates or workbooks. The main writer owns removal of unsupported confirmatory wording and the main-text form cross-reference. Main Table 3's proposed/adopted distinction remains outside this assignment. Author declarations and archival information remain pending as described in the parent reports.

## Exact changed files and hashes

The ten repair files below plus this report are the complete task write set. SHA-256 values are full-length.

### `analysis/.quarto/supplement-page.md`

Before: `c6c8e9f9cc9b30defe110efb66fde315964e797c751d768f7883e150ea8a547e`

After: `b545509098658a115ac9f0308a09fd4f6cbf82c363a187c0a7da5688935d5822`

### `analysis/R/checklist.R`

Before: `734edb86f6b2d45d2551490d09790538b9666ecadf6ff02ff02397aa215f9a6a`

After: `6f664435ec7e84f1f2562ef47e04e39acf7db155027cc077f4a903bbacf2866f`

### `analysis/R/manuscript-supplement.R`

Before: `b9edf0982df00162e481a9118008a8bc0892dc841acd5d12f0ec913383716adc`

After: `f312d743b36978608fe7d42e526c4d599dbba81748647b742e3b225ed7883cbb`

### `analysis/R/materials.R`

Before: `3c44f72b9c2348518f090d22dc5bd86bde87f0b684b22bffb8c8a565b8e162ad`

After: `06410dad8eda04e1c2261c20de7486651752b5d8deeccafbbb7bd9fcc98b88e7`

### `analysis/output/manuscript/Supplement.docx`

Before: `264321266fc30f86d78f70ca648fe7a40538334d377cbe55f5890c8bb8dd9568`

After: `1d35215f5bede9afa2b89729457f271e62bf57edf6c18e9594d3f416c0462cc7`

### `analysis/output/manuscript/TRIPOD-LLM.docx`

Before: `82085c83989bd7b7c847fb93bf70cd313cf2c5a8747f94c35f61511662bff88a`

After: `9a3fbd6267de10247b417c59298bc73ba916368ab628be2c58c4fd38ba3440ae`

### `analysis/output/tables/display-supplement-reporting-map.csv`

Before: `1042aaf23e01c12b463ab519a8979e742394fb37942cdf7766705fb427493e97`

After: `2b5c4bec75cef84c16246484af0e92a357c393d6acf914498e346a06c37f0c0c`

### `analysis/output/tables/prompt-template-example.csv`

Before: `481263a32bc2407b80c1e0457140e14b59e0e0c38abc318d32a828ec640e53f6`

After: `bc68b9b2c0821b97385e217e991681898416e327c5d9e21b787fd4332e6bcbaa`

### `analysis/output/tables/reporting-checklist-skeleton.csv`

Before: `13799f75e2e5752158d6bf4322cf618d57f49cec4ce4663aabf2d0c37d6a1fe6`

After: `06cbd10e3fd6645b80b273e1ea3c0c530f4130b0948343b1eed579be136ca12e`

### `analysis/supplement.html`

Before: `8bcf26e89398fe0a1ea2995b51c30c12921d362ed6a5be7ada03a3d8eb81e252`

After: `fb5d5f919a43cf6ced8a8228f556e86f5f6583bab69ae98c8ac861e3c414906b`

## Source diff

The applied source changes are reproduced here for review without running the broad builders.

```diff
--- before/analysis/R/checklist.R
+++ after/analysis/R/checklist.R
@@ -88,8 +88,20 @@
   map$section[map$guideline=='TRIPOD-LLM' & map$item=='5c'] <- 'Text-date coverage is not reported; author information required'
   map$section[map$guideline=='TRIPOD-LLM' & map$item=='14c'] <- 'Manuscript Statistical analysis; formal primary endpoint and exploratory analyses; protocol/archive identifier requires author confirmation'
   map$section[map$guideline=='GRRAS' & map$item=='9'] <- 'Manuscript Independent expert references; eMethods Blinded expert assessment'
+  map$section[map$guideline=='TRIPOD-LLM' & map$item=='5a'] <- 'eMethods Input parity and label targets; eTable 1; initial review identification and eligibility require author completion'
+  map$section[map$guideline=='TRIPOD-LLM' & map$item=='8a'] <- 'eMethods Algorithms and validation; Blinded expert assessment; original blank form, instructions, target brief and multi-outcome judgment conventions require author completion'
+  map$section[map$guideline=='TRIPOD-LLM' & map$item=='9a'] <- 'Supplement Prompt templates and run provenance; prompt design, selection and version-freeze provenance require author completion'
+  map$section[map$guideline=='TRIPOD-LLM' & map$item=='9b'] <- 'Supplement Prompt templates and run provenance; eTable 1; development data and any benchmark overlap require author completion'
+  map$section[map$guideline=='GRRAS' & map$item=='7'] <- 'eTable 1; Manuscript Benchmark and assessment arms; eMethods Input parity and label targets; initial review identification and eligibility require author completion'
+  map$section[map$guideline=='GRRAS' & map$item=='8'] <- 'eMethods Blinded expert assessment; original blank form, instructions, target brief and multi-outcome judgment conventions require author completion'
   map <- map |> mutate(page='Stable section/display locator',
     applicability_and_notes=case_when(
+      guideline=='TRIPOD-LLM' & item=='5a'~'Partial: initial review identification and eligibility require author completion',
+      guideline=='TRIPOD-LLM' & item=='8a'~'Partial: original annotation materials and target guidance require author completion',
+      guideline=='TRIPOD-LLM' & item=='9a'~'Partial: final templates do not establish the prompt-development process',
+      guideline=='TRIPOD-LLM' & item=='9b'~'Partial: final templates and a filled example do not establish development data',
+      guideline=='GRRAS' & item=='7'~'Partial: within-review sampling is described; initial review selection requires author completion',
+      guideline=='GRRAS' & item=='8'~'Partial: assessment sequence is described; original materials and target guidance require author completion',
       startsWith(section,'N/A:')~'Not applicable: fixed model and task',
       grepl('author completion|author confirmation|author information|author information required',section,ignore.case=TRUE)~'Partial: author information required',
       TRUE~'Reported at the named current section or display'))
--- before/analysis/R/materials.R
+++ after/analysis/R/materials.R
@@ -19,9 +19,10 @@
     domain %in% c('D1-D5','Overall')),'table2')
   save_table(meta_agreement$differences |> filter(comparison=='ARBITER-Sonnet minus Baseline-Sonnet',
     domain %in% c('D1-D5','Overall')),'table2-differences')
-  template_text <- '/arbiter-assess Assess risk of bias for {outcome} defined as {definition} in {trial}.'
+  # Evaluated command: kit-sonnet-5.5/run_case.py and README.md.
+  template_text <- '/rob2-assess Assess risk of bias for {outcome} defined as {definition} in {trial}.'
   example <- inputs$targets |> arrange(slug) |> slice_head(n=1)
-  filled <- paste0('/arbiter-assess Assess risk of bias for ',example$assess_outcome,
+  filled <- paste0('/rob2-assess Assess risk of bias for ',example$assess_outcome,
     ' defined as ',example$assess_values_as_printed,' in ',example$slug,'.')
   baseline_template <- 'Assess risk of bias for {outcome} defined as {definition} in {trial}.'
   format_instruction <- paste(readLines('../no-kit-sonnet-5.5/nokit-format.txt',warn=FALSE),collapse='\n')
--- before/analysis/R/manuscript-supplement.R
+++ after/analysis/R/manuscript-supplement.R
@@ -28,13 +28,13 @@
     'Bundle verification does not establish clinical correctness or completion. Unassisted evidence traces are not available.'),
   'Inference'='All confidence intervals use stratified trial-cluster resampling within meta-analysis, 10000 replicates, percentile intervals and seed 20261018. Paired comparisons share weights. No P values are used.')
 METHODS_APPENDIX <- c(METHODS_APPENDIX,
- 'Blinded expert assessment'=paste('Two blinded human experts independently rated every trial domain, without AI, and froze their ratings and signalling answers before viewing labels. They then made a forced choice among three labels shown in random order without rationales, followed by a revised rating. Choice is scored by label; ties credit every matching source. Concordant cells are excluded from preference summaries. The primary estimate uses arm disagreements with equal choices. Revised ratings are descriptive.'),
+ 'Blinded expert assessment'=paste('Two blinded human experts independently rated every trial domain, without AI, and froze their ratings and signalling answers before viewing labels. They then made a forced choice among three labels shown in random order without rationales, followed by a revised rating. Choice is scored by label; ties credit every matching source. Concordant cells are excluded from preference summaries. The primary estimate uses arm disagreements with equal choices. Revised ratings are descriptive. The assessment sequence is documented in the expert assessment specification and completed workbooks. Author completion is required for the original blank form and instructions, assessor qualifications and training, the target brief, and conventions for judging targets containing several outcomes.'),
  'Independent reference and Overall'=paste('Agreement is evaluated against each independent rating, the arithmetic mean of the two expert-specific estimates, and the agreed reference. Derived Overall is the worst independent domain rating; optional escalation is not imposed. The workbook validation separately records every difference in all available columns. Published Overall is compared only on observed labels (n = 81); 21 trials had no observed Published Overall label and are excluded, never counted as disagreements. ARBITER and Unassisted use all trials (n = 102) and the same observed subset (n = 81). Every paired Overall contrast involving Published uses that subset (n = 81). Agreed-reference denominators are restricted further to equal expert ratings and printed on each row.'),
- 'Signalling question mapping and eligibility'=paste('The ARBITER semantic question identifiers map one-to-one to the official numbered questions (see Signalling question mapping and eligibility); Unassisted numeric identifiers already match the experts. Comparisons require explicit answers to the same question and component on both sides. Scalar answers are never broadcast across components. NA, inactive questions, missing answers, unmatched components and unresolved strings are not evaluable and are counted separately. Five-level matching distinguishes Y, PY, N, PN and NI. Collapsed matching combines Y/PY and N/PN; NI remains separate. Paired differences retain only components evaluable in both arms.'),
+ 'Signalling question mapping and eligibility'=paste('The ARBITER semantic question identifiers map one-to-one to the official numbered questions (see Signalling question mapping and eligibility); Unassisted numeric identifiers already match the experts. A component is an explicitly named part of a signalling answer; a bare answer code has one unnamed component. Component names are lowercased and trimmed; unresolved or duplicate components are flagged. Matching requires the same trial, domain, question and component. Comparisons require explicit answers to the same question and component on both sides. Scalar answers are never broadcast across components. NA, inactive questions, missing answers, unmatched components and unresolved strings are not evaluable and are counted separately. Five-level matching distinguishes Y, PY, N, PN and NI. Collapsed matching combines Y/PY and N/PN; NI remains separate. Paired differences retain only components evaluable in both arms. Independent expert domain ratings are read directly from the Independent column of the Adjudications sheet; the analysis does not derive these ratings by aggregating signalling-answer components.'),
  'Input parity and label targets'=paste('Both arms received the same supplied articles, supplements, registry records and protocol or SAP files. The De Waal registry input belongs to a different trial. Published-label target bindings can be broad, inferred or mismatched; the benchmark and label-target tables document these categories.'),
  'Interpretive limits'=paste('The formal primary endpoint is conditional on arm disagreement and equal expert choices. Independent comparisons cover all 510 domain cells against each expert separately. Derived Overall, direction, rules-only recomputation, severity strata and binary analyses are exploratory. Only two experts contributed; experts could consult sources beyond the arms’ inputs. Label exposure may anchor subsequent choices and revised ratings. One run per arm, possible training exposure and unassessed semantic evidence support limit interpretation. Published labels may refer to broad or different assessment targets; all 510 domain cells remain in Published-reference comparisons. The De Waal registry input belongs to another trial.'))
 METHODS_APPENDIX['Inference'] <- 'Frequency percentages and percentage confidence limits use whole numbers for denominators below 100 and one decimal otherwise. Paired percentage-point effects retain one decimal and ordinal coefficients two decimals. All analytical values retain full stored precision. Intervals use 10,000 percentile bootstrap replicates, seed 20261018. Trials are sampled with replacement within the 16 fixed reviews, retaining paired arms and all domain ratings. These intervals do not sample new reviews, experts or model runs. Supporting analyses are secondary or exploratory; no P values or multiplicity adjustments are used.'
-METHODS_APPENDIX['Input parity and label targets'] <- 'Both arms received identical supplied trial documents, including available ancillary records. Assessment prompts specified outcome, time point, contrast and printed result. Published assessment targets can be broad, inferred or mismatched. No target-matching subset, filter, stratum or sensitivity is used.'
+METHODS_APPENDIX['Input parity and label targets'] <- 'Both arms received identical supplied trial documents, including available ancillary records. Assessment prompts specified outcome, time point, contrast and printed result. Published assessment targets can be broad, inferred or mismatched. No target-matching subset, filter, stratum or sensitivity is used. The benchmark README specifies within-review selection by table order and availability-dependent replacement. Author completion is required for initial review identification and eligibility.'
 SUPPLEMENT_SPECS <- list(
  c('Confusion matrices against each independent expert','independent-confusion','raw'),
  c('Full independent agreement and paired contrasts','independent-estimates','expert'),
@@ -379,7 +379,7 @@
   doc <- officer::body_add_break(doc) |> manuscript_par('Prompt templates and run provenance',style='heading 2')
   prompts <- read_display('prompt-template-example')
   for(i in seq_len(nrow(prompts))) doc <- doc |> manuscript_par(prompts$type[i],style='heading 2') |> manuscript_par(prompts$prompt[i])
-  doc <- manuscript_par(doc,'Model claude-sonnet-5-5, medium effort; Claude Code 2.1.278; ARBITER 1.0.0 public commit 2f549ae30f056ff441ea61a04b719968716f2219. Each trial ran once per arm. Runs used a subscription; costs are frozen-rate API list-price equivalents. The reproducibility records include the R and package versions.')
+  doc <- manuscript_par(doc,'Model claude-sonnet-5-5, medium effort; Claude Code 2.1.278; evaluated rob2-kit commit 2848c7926a2acc25402345a42be39d695a99861a; public ARBITER 1.0.0 commit 2f549ae30f056ff441ea61a04b719968716f2219. Each trial ran once per arm. Runs used a subscription; costs are frozen-rate API list-price equivalents. The reproducibility records include the R and package versions. The evaluated runner invoked /rob2-assess; /arbiter-assess is the public command name. The retained release audit documents this command-name correspondence but does not establish equivalence of the complete releases. Final templates and a filled example document the evaluation inputs; author completion is required for prompt design and selection, development data, any benchmark overlap and version-freeze provenance.')
   message('Supplement: writing Word document')
   print(doc,target='output/manuscript/Supplement.docx')
   message('Supplement: reporting map')
```
