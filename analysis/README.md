# Rebuild the ARBITER analysis

Run from analysis/ with R, Quarto, Python, python-docx and lxml available. Set ARBITER_PYTHON to the Python executable when it is not on PATH.

```sh
Rscript -e 'renv::restore()'
Rscript run.R
Rscript -e 'testthat::test_dir("tests/testthat")'
Rscript verify-output.R
python ../scripts/verify-reduction.py
python ../docs/manuscript/verify-presentation.py
```

The source inputs remain read-only. The current contract is ../ANALYSIS-PLAN.md. The selection rationale and item-by-item defense are in ../docs/analysis-simplification.md. The complete earlier analysis and report remain recoverable at Git revision 54645d75e7a8b32bbf09968893e7be45faa4cab4.

## Current scope

The main report retains five figures and three tables. The reduced supplement has six numbered table families and no supplementary figure families. It keeps separate expert references, Published agreement, prevalence/reliability context, one pooled category-disagreement table, compact exploratory Overall and rules-only checks, complete paired signalling questions, both answer codings and eligibility accounting. Exact prompts and methods remain available. The complete AVATAR answer and evidence records are directly linked rather than printed in full.

Expert means, agreed-reference restrictions, extra source contrasts, revised/post-exposure summaries, directional/strictness strata, extra binary/unweighted metrics and redundant graphical/table expansions have been removed from the supported current pipeline. The reporting-scope note records these post-analysis decisions. No prospective outcome hierarchy is claimed.

All intervals retain 10,000 trial-cluster bootstrap replicates within the 16 fixed reviews, seed 20261018. Paired contrasts share weights. verify-reduction.py compares every retained analytical CSV row with the earlier release, including its scientific identifiers, values and intervals. It also checks study-input content, Figure 1 byte identity and that Figure 2 changes only its authorized footer clarification. verify-output.R independently reconciles retained counts with the original workbooks and matched answer components. Neither check establishes semantic evidence support.

Reader-facing outputs label the independent human assessments Human Review 1 and Human Review 2. Original workbook identifiers and numerical CSV keys remain stable. Figure 2's footer identifies the later blinded D5 choices, not independently rated Overall judgments.

The group key Overall in signalling CSVs means pooled answers. Overall in the independent-rating tables means an exploratory worst-domain expert reference. It is not a directly assessed sixth domain. The legacy primary-endpoint.csv filename identifies conditional blinded choices and confers no scientific priority.

The active IMRaD draft, its bibliography and its Word/HTML outputs were removed on 26 October 2026 for a fresh manuscript. The main analysis summaries, tables, figures and supplement remain. Earlier drafts are available in Git history; historical audit records do not define the next manuscript.

## Publication builds

```sh
Rscript build-publication.R
```

This reuses finalized numerical exports without resampling. The native editable tables originate in gt. The shared finalizer adds pagination and stable heading bookmarks to the standalone tables, supplement and reporting map. HTML refresh checks every source table cell, figure and local link, then exports Main-analysis.docx from the analysis page with the same text, embedded figures and native editable tables.

To refresh only web pages from already finalized artifacts, run from the repository root:

```sh
python scripts/report-refresh.py
python scripts/stage-pages.py .audit/pages-stage
```

Direct Quarto rendering does not regenerate its intermediate includes. The presentation check must run after refresh. The reporting map is a separate attachment; pending author declarations and assessor details remain explicit. Inspect rendered Word documents and figures before release.

## Extraction and provenance

Rebuilding numerical results uses committed derived metrics, not raw logs. These explicit extractors regenerate metrics when their raw inputs are available and stop if inputs are absent:

```sh
Rscript R/extract-run-metrics.R
Rscript extract-bundle-review.R
Rscript extract-api-costs.R
python reverify-bundles.py
```

Original expert workbooks, trial targets, source manifests and captured-input hashes remain available. Trial PDFs are not redistributed. Runtime is computation time, and API list-price equivalents are reconstructed values, not subscription expenditure or reviewer cost.

Publication remains a separate action. scripts/publish-pages.sh stages the verified artifacts and records source revision, file sizes and SHA-256 hashes. scripts/verify-pages.py checks a deployed release against that manifest.
