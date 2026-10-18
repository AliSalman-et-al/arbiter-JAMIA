# Round 5 implementation report

F1-F3 are complete on main, with one local commit per item. Nothing was pushed. The binding plan, glossary and input data folders were not edited.

## Figure 1 (F1)

The selected trace remains award-10-2018 D2. Row 4 now reads (line wrapping follows the figure layout):

> Span bound to captured source: S2213-8587-18-30023-8.pdf, page 5, lines 45–47; source hash 6fecb407…
>
> Independent bundle verifier: verified (content hashes, claims, lineage)

The source label is matched through canonical.json source identifiers. Page, lines and source_version come from the actual selected evidence record; source_version is the captured text projection hash, matching the source projection_hash, rather than the original PDF byte hash. The verifier result and named checks come from verification.json. Its schema string is not displayed. The caption explains that passages are server-extracted spans cited by handle, so the model cannot cite text absent from the captured sources. Pure trace formatting is tested against the selected values.

## Structural evidence binding (F2)

- ARBITER-Sonnet: 1407/1421 (99.0%); bootstrap 95% CI 98.3%-99.6%.
- ARBITER-Haiku: 1255/1260 (99.6%); bootstrap 95% CI 99.2%-99.9%.

The unit is a distinct cited evidence identity within a bundle, pooled across the 102 analysis-set trials. Repeated citations count once per bundle. Citations in bases and counterevidence of current active answers count; superseded domain histories do not. The empty Haiku bundle contributes no cited records. A missing cited evidence record would remain in the denominator and fail. Source identifiers are checked against canonical batch trial sources. Required fields are a nonblank quote, matching source identifier, nonblank source_version, finite page and character offsets with start < end. Reports read committed per-trial counts and retain the existing stratified trial-cluster bootstrap (10,000 replicates; seed 20261018).

All 19 failures (14 Sonnet; 5 Haiku) are visual evidence records with region, render, transcription and provenance fields, rather than the required top-level text-span fields. They are retained as failures of this specific metric; this does not establish that they are fabricated or unsupported. The supplement states this distinction. Baseline arms receive no binding rate. The metric does not re-extract PDF text or establish that a passage supports an answer. Hand-built tests cover required fields, foreign sources, invalid offsets, missing evidence, repeated citations, counterevidence, inactive answers, historical records and empty bundles.

## Validation (F3)

- From analysis/: `Rscript -e "testthat::test_dir('tests/testthat', reporter='summary')"` passes all 154 assertions, with no test warnings, skips or failures. Existing Windows R startup locale warnings persist.
- `quarto render` succeeds after moving output tables, figures, HTML reports and .quarto aside; the human coding sheet is preserved. The backup is outside the repository in the Windows temporary directory.
- `Rscript verify-output.R` passes: five 600-dpi PNGs, five one-page PDFs, both reports and required tables.
- The regenerated Figure 1 PNG was inspected: row 4 fits, all rows align, and there is no internal title. Other PNGs are byte-identical to the prior artifacts. Regenerated PDF text matches the committed pre-clean-render figures; timestamp-only PDF changes were discarded. A pre-existing Windows Unicode conversion in the generated coding README was discarded to preserve the prior artifact.
- `Rscript verify-round5.R` compares every tracked CSV to the immutable pre-round HEAD 499ef07e9f55a2bb26d1169001da596d9f030871. Of 84 tracked CSVs (including the new binding-count file), only seven are changed/new: bundle-trace-evidence.csv, bundle-binding-counts.csv, worked-trace-candidates.csv, figure1-draft-selection.csv, audit-summary.csv, table3.csv and table3-supplement.csv. Exactly five of the 48 output/tables CSVs change. All pre-existing audit rows are numerically unchanged; only structural-binding rows are added. Trace tables add source binding fields and replace the former scope wording. All other CSVs, including every input CSV, are unchanged. A post-render diff of all CSVs against the F2 HEAD is empty.
- Prohibited-name scan passes for both rendered HTML reports, output CSV/Markdown files and extracted text of all five figure PDFs.
- `git diff --check` passes. The final working tree is clean.

## Commits and remaining uncertainty

- F1: 75b57fe — Show captured-source span binding in Figure 1.
- F2: 47f2852 — Report structural binding of cited ARBITER evidence.
- F3: the commit containing this report, titled "F3: Verify round 5 render and CSV preservation".

The explicit denominator choice is distinct evidence records per bundle, rather than citation occurrences; it is documented in DEVIATIONS.md. The visual evidence records were unexpected under the lead brief's span-only description, and were conservatively counted as failures of the requested structural check. No text was re-extracted and no support judgement was inferred. Final author selection of the provisional trace, human taxonomy coding, checklist completion and the existing Zenodo DOI placeholder remain unchanged author tasks.
