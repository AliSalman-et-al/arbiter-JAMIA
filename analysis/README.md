# Rebuild the ARBITER analysis

Run these commands from `analysis/`:

```sh
Rscript -e 'renv::restore()'
Rscript run.R
Rscript -e 'testthat::test_dir("tests/testthat")'
Rscript verify-output.R
```

`run.R` reads the two Sonnet arms and the two full-coverage blinded expert workbooks, computes all estimates, and builds the figures, Word documents and HTML views. The inputs remain read-only. `tests/testthat/` is the single test suite. `verify-output.R` verifies CSV provenance, protected artwork, unchanged analyses, provisional counts, artifact presence and reader-facing leaks.

The frozen lockfile records R 4.6.1 and includes `gt` 1.4.0 for native editable Word and HTML tables. `output/session-info.txt` records the environment actually used. All intervals use 10,000 trial-cluster bootstrap samples within meta-analysis, seed 20261018, with shared weights for paired estimates.

For presentation-only changes, use `Rscript build-publication.R` to reuse finalized numerical exports without resampling. Quarto and Python with `python-docx` and `lxml` must be installed. The assembler uses Python on PATH; set `ARBITER_PYTHON` to select another interpreter. Main tables are built before insertion into the manuscript, and assembly checks every embedded cell against its standalone table. Update Word fields before exporting final visual proofs. The current audit, style contract and verification evidence are in `../docs/rethink-2026-10-22/final-audit/`.

To refresh only the Results and Supplement web pages from **already finalized** publication artifacts, run this from the repository root:

```sh
python3 scripts/report-refresh.py
python3 scripts/stage-pages.py /tmp/arbiter-pages
```

Use a Python interpreter with `python-docx` and `lxml` (for example, `"$ARBITER_PYTHON" scripts/report-refresh.py` when that variable names the interpreter); Quarto must be on PATH. This path requires no R packages and never recomputes analyses, tables, figures, or Word documents. It converts the three finalized `Table*.docx` files and `Supplement.docx` into native HTML, reads `results-sentences.md` and `figure-legends.md`, and renders `results.qmd` and `supplement.qmd`. The supplement retains all 98 tables, 13 images, full worked trace and 62 contents destinations. The helper checks every table cell and note, prose/legends, embedded image bytes, anchors, and unchanged protected artifact hashes. Evidence is in disposable `.quarto/report-refresh-verification.json`.

The `.quarto/results-page.md` and `.quarto/supplement-page.md` includes and extracted media are generated inputs; use the helper before rendering those QMD files in a fresh checkout, and rerun it after finalized artifacts change. Direct `quarto render` alone does not regenerate those inputs. A complete presentation build with `build-publication.R` still needs its R dependencies; it invokes the HTML refresh helper after producing finalized Word outputs. Staging also requires a current `manuscript.html`; build that with `scripts/build-manuscript.py --html-only` before staging when needed. Do not substitute this HTML refresh for numerical validation when analytical inputs change.

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

`signalling-disagreement-types.csv` partitions all evaluable five-level arm–expert disagreements into within-direction Y↔PY or N↔PN changes and cross-direction changes (including NI versus either direction). The counts appear in eTable 13A. Main Figure 5 shows domain-level paired differences. eFigure 2 shows collapsed question differences in five domain panels; eFigure 5 retains both scales and all sparse questions. The complete multipage PDFs accompany the individual domain-panel files.

After committing the verified source and artifacts, run `scripts/publish-pages.sh` from the repository root. The packager checks local links and records source commit, sizes and SHA-256 hashes in `publication-manifest.json`. `scripts/verify-pages.py` checks the deployed files against that manifest.
