# Clean-snapshot release manifest

| Path | Reason |
|---|---|
| `analysis/R/`, `analysis/run.R`, `analysis/verify-output.R`, `analysis/tests/` | Analysis, display generation, verification and tests. |
| `analysis/figure1/`, `analysis/extract-api-costs.R`, `analysis/extract-avatar-trace.py`, `analysis/extract-bundle-review.R`, `analysis/reverify-bundles.py` | Diagram source and optional extraction or independent-verification commands documented in the reproduction instructions. |
| `analysis/renv.lock`, `analysis/renv/activate.R`, `analysis/.Rprofile`, `analysis/_quarto.yml` | Frozen packages and report configuration; README documents the R version substitution. |
| `analysis/results.qmd`, `analysis/supplement.qmd`, `analysis/assets/` | Report sources and supporting assets. |
| `analysis/data-curated/` | Benchmark metadata and cited prior-work evidence. |
| `analysis/data-derived/arbiter-sonnet.csv`, `analysis/data-derived/baseline-sonnet.csv` | Reported-arm runtime and usage records. |
| `analysis/data-derived/api-cost-trials.csv`, `analysis/data-derived/api-cost-turns.csv` | Reproducible API list-price calculations. |
| `analysis/data-derived/bundle-binding-counts.csv`, `analysis/data-derived/bundle-path-checks.csv`, `analysis/data-derived/bundle-reverification.csv` | Derived evidence and rule checks. |
| `analysis/data-derived/expert-signalling-components.csv`, `analysis/data-derived/expert-signalling-comparisons.csv`, `analysis/data-derived/README.md` | Parsed expert answers, matched comparisons and data definitions. |
| `analysis/data-derived/avatar-trace.json`, `analysis/data-derived/avatar-unassisted-rationale.json` | Worked-example projections without trial PDFs. |
| `analysis/output/` | Final numerical CSVs, tables, figures, supplement, reporting map, numerical trace and session record. |
| `analysis/results.html`, `analysis/supplement.html` | Built reports. |
| `human-adjudication/adjudication-with-explanations-1.xlsx`, `human-adjudication/adjudication-with-explanations-2.xlsx` | Two independent expert sheets and forced choices. |
| `kit-sonnet-5.5/rob2kit-domain-labels.csv`, `kit-sonnet-5.5/rob2kit-signalling-answers.csv` | ARBITER labels and answers required by the loader. |
| `no-kit-sonnet-5.5/model-domain-labels.csv`, `no-kit-sonnet-5.5/model-signalling-answers.csv` | Unassisted labels and answers required by the loader. |
| `kit-sonnet-5.5/bundles/*.rob2.zip` | Source-role inventories, rule and evidence records required for reproduction; bundles contain no trial PDF files. |
| `no-kit-sonnet-5.5/nokit-format.txt`, `analysis/output/tables/prompt-template-example.csv` | Comparator instruction and both prompt templates with an instantiated example. |
| `rob2-meta-benchmark-set/TRIAL-SUMMARY.csv`, `rob2-meta-benchmark-set/LABEL-TARGETS.csv`, `rob2-meta-benchmark-set/FILES.csv` | Benchmark population, label targets and document hashes. |
| `ANALYSIS-PLAN.md`, `GLOSSARY.md`, `docs/round16/BRIEF.md` | Final analysis definitions, terminology and dated amendments. |
| `analysis/provenance/ANALYSIS-PLAN-2026-10-18.md` | Unedited dated plan extracted from commit `e1c0ccf`; evidence of prespecification. |
| `analysis/README.md`, `analysis/round16-report.md` | Reproduction instructions and verification record. |
| `analysis/provenance/output-verification.txt`, `analysis/provenance/round16-tests.txt`, `analysis/provenance/round16-number-trace.txt`, `analysis/provenance/round16-estimate-invariance.txt`, `analysis/provenance/round16-protected-artwork.txt`, `analysis/provenance/round16-independent-checks.json` | Current-round verification records supporting the report. |
| `analysis/output/manuscript/qa/round16-Table*/`, `analysis/output/manuscript/qa/round16-Supplement/`, `analysis/output/manuscript/qa/round16-TRIPOD/`, `analysis/output/manuscript/qa/round16-figure-pdfs/`, `analysis/output/manuscript/qa/round16-colour/` | Excluded: temporary rendered QA copies; retain the display-numbering and page-check CSVs. |
| `analysis/provenance/` | Excluded except the dated plan and current-round records listed above: historical working records and superseded assessment material. |
| `analysis/DEVIATIONS.md`, `analysis/public-release-exclusions.txt` | Excluded: internal historical records containing superseded assessment material; the final plan retains the current dated amendment. |
| `analysis/archive/` | Excluded: historical working reports. |
| `**/*.pdf` | Excluded: trial and source-review PDFs are not redistributed; generated PDFs in `analysis/output/` are retained. |
| `human-adjudication/adjudication-cells-with-explanations-A.xlsx`, `human-adjudication/adjudication-cells-with-explanations-Z.xlsx`, `analysis/provenance/round14*` | Excluded: files from the superseded assessment. |
| `.git/` | Excluded: release is a clean snapshot without repository history. |
