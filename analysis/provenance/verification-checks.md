# Provenance task validation

Completed 18 October 2026 on `main`.

- Fresh run-build independent verification: 208/208 available bundles pass;
  102/102 per analysis arm, plus 3 excluded Sonnet and 1 excluded Haiku bundle.
  All fresh results agree with the archived receipts.
- Full R suite, run from `analysis/` with its renv environment:
  `Rscript -e "testthat::test_dir('tests/testthat', reporter='summary')"`.
  **532 passing assertions, zero failures, test warnings or skips.**
  The 20 new assertions read `bundle-reverification.csv`, check population
  membership/coverage, hashes, run-build identity, fresh outcomes and receipts.
  R's existing Windows startup locale warnings remain environmental.
- Both Python scripts pass syntax parsing. The generated residual appendix has
  101 hunks and the equivalence report has exactly 101 classification rows.
- `git diff --cached --check -- . ':(exclude)analysis/provenance/rename-residuals.md'`
  passes. The complete diff appendix intentionally retains unified-diff blank
  context markers (a single space), which Git flags as trailing whitespace.
  No Quarto rendering was performed because the
  equivalence condition failed and no tables were changed.
- Figure 1/2 paths and all existing tracked files are untouched. Both source
  repositories were read-only; the pre-existing untracked discussion document
  in the run-build repository was ignored. The wheel was built from Git archive
  bytes in a new temporary directory, not inside either source checkout.

The complete equivalence verdict and every residual are in
[rename-equivalence.md](rename-equivalence.md) and its linked appendix.
Behavioural differences prevent the proposed “identical apart from naming” claim;
the PI decides subsequent manuscript wording. No push was performed.
