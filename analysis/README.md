# ARBITER JAMIA analysis

The amended section 5.4 gate passes, with the isolated ARBITER-Haiku exception
documented in [DEVIATIONS.md](DEVIATIONS.md). Main results and supplement rebuild
all numerical outputs directly from the source inputs.

From this directory, using R 4.6.1 and Quarto 1.10.19:

```powershell
& 'C:/Program Files/R/R-4.6.1/bin/Rscript.exe' -e "renv::restore()"
& 'C:/Program Files/R/R-4.6.1/bin/Rscript.exe' -e "testthat::test_dir('tests/testthat')"
$env:QUARTO_R = 'C:/Program Files/R/R-4.6.1/bin'
quarto render
```

Rendering results.qmd rebuilds outputs; supplement.qmd reads those outputs in project render order. No cached computations are required. Inputs in the parent directory are read-only. HTML is local review material and ignored by git. Human coding belongs in output/coding/coding-sheet.csv; the pipeline preserves that file and checks row identities before use. Bootstrap seed: 20261018; 10,000 replicates. Coding-sample seed: 20261019.

The analysis uses R only. `R/` contains pure estimands and resampling functions;
`run.R` orchestrates numerical exports, materials and figures. Tables retain
full precision, interval bounds and valid bootstrap counts. All missing-data
and denominator choices are documented in DEVIATIONS.md. Re-render after human
coding is complete to replace the taxonomy placeholder. Do not delete a filled
working coding sheet when cleaning generated outputs.

The binding section 5.8 amendment is included. `data-derived/` contains four
committed per-arm process/audit CSVs. To regenerate them with the raw logs and
bundles present, run `Rscript R/extract-run-metrics.R` from analysis/. It streams
JSONL, validates usage against metadata and stops if logs are absent. Rendering
reads only those derived CSVs, never raw logs or bundles. ARBITER proposals are
checked independently against the official algorithms; recorded overrides are
listed separately from baseline algorithm violations.

`round2-report.md` records all requested headline numbers and the complete
deviation log. Generate it after rendering with `Rscript report-round2.R`.

Round 3 additionally reads two committed bundle-review CSVs. Regenerate these
with `Rscript extract-bundle-review.R` from analysis/; this needs committed
bundles, not raw turn logs. It checks every domain history record's active
questions and answers, then extracts trace candidates from cited evidence.
`round3-report.md` records review fixes and verification. Table CSVs retain
numeric precision; rendered tables format percentages and confidence intervals.

The author amendment 69c73c6 supersedes harness pricing. Run
`Rscript extract-api-costs.R` to reconstruct the frozen API list-price equivalents
from raw logs. Table 5 uses per-trial point estimates. The supplement contains
Haiku bounds, five-minute side-write sensitivity, unusable harness figures and
request/result/side-call token reconciliation. Re-run `Rscript report-round3.R`
after rendering to update the round 3 report from the committed table outputs.
