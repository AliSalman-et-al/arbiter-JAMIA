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
