# Rebuild the ARBITER analysis

Run these commands from `analysis/`:

```sh
Rscript -e 'renv::restore()'
Rscript run.R
Rscript -e 'testthat::test_dir("tests/testthat")'
Rscript verify-output.R
```

`run.R` reads the two Sonnet arms and the two full-coverage blinded expert workbooks, computes all estimates, and builds the figures, Word documents and HTML views. The inputs remain read-only. `tests/testthat/` is the single test suite. `verify-output.R` verifies CSV provenance, protected artwork, unchanged analyses, provisional counts, artifact presence and reader-facing leaks.

The frozen lockfile records R 4.6.1. This Linux rebuild uses the documented R 4.3.3 substitution. `readxl` 1.6.0 and its dependencies are already recorded in `renv.lock`; missing packages were installed into the project renv library. `output/session-info.txt` records the environment actually used. All intervals use 10,000 trial-cluster bootstrap samples within meta-analysis, seed 20261018, with shared weights for paired estimates.

The Round 16 specification is in `../docs/round16/BRIEF.md` and `../ANALYSIS-PLAN.md`. Prespecified domain comparisons from the 18 October plan apply to all 510 cells; additions are labelled exploratory. `round16-report.md` records results, data discrepancies and verification. `provenance/ANALYSIS-PLAN-2026-10-18.md` is the unedited plan extracted from `e1c0ccf`. `../docs/round16/release-manifest.md` lists the clean-snapshot release paths. Historical reports are retained unchanged in `archive/`. `public-release-exclusions.txt` records release exclusions for raw and historical material.

`R/load.R` checks every workbook label against the arm exports and requires exactly 102 trials and 510 unique domain cells per expert. `R/signalling.R` preserves answer components and records unresolved rows. `R/expert-agreement.R` implements the independent references, forced choice, direction counts and rules-only recomputation. `R/unchanged.R` retains the parent published-label, rule, audit and process calculations. Display CSVs, source traces and numerical estimates are in `output/tables/`; publication artifacts are in `output/manuscript/`.

Raw logs are not required to rebuild the analysis. The explicit extraction commands below regenerate committed derived metrics when their raw inputs are available and stop when those inputs are absent:

```sh
Rscript R/extract-run-metrics.R
Rscript extract-bundle-review.R
Rscript extract-api-costs.R
python3 reverify-bundles.py
```

The full AVATAR trace uses committed bundle projections. Trial PDFs are not redistributed; the benchmark records source identifiers and content hashes.

New expert-reference Overall comparisons use n = 102 for ARBITER and Unassisted, and n = 81 observed Published labels. Twenty-one published reviews gave no Overall label; these are excluded, never counted as disagreements. ARBITER and Unassisted are also reported on the same n = 81 trials, and every paired Overall contrast involving Published is restricted to that subset. Agreed-reference rows further restrict to equal expert ratings; each row prints n.

`signalling-disagreement-types.csv` partitions all evaluable five-level arm–expert disagreements into within-direction Y↔PY or N↔PN changes and cross-direction changes (including NI versus either direction). The counts appear under eTable 5. Figure 6 shows collapsed question differences; eFigure 3 retains both scales and all sparse questions.
