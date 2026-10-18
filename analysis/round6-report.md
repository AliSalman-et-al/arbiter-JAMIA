# Round 6 implementation report

The binding metric now separates text-span and visual evidence. All work is on main in the single local commit containing this report, titled "Split evidence binding by text-span and visual kind". Nothing was pushed; the repository has no remote. ANALYSIS-PLAN.md, GLOSSARY.md and the input data folders are unchanged.

## Binding results

- ARBITER-Sonnet: text 1407/1407 (100.0%); visual 14/14 (100.0%); overall 1421/1421 (100.0%). Eight of 102 trials use visual evidence (7.8%). Other records: 0.
- ARBITER-Haiku: text 1255/1255 (100.0%); visual 5/5 (100.0%); overall 1260/1260 (100.0%). Four of 102 trials use visual evidence (3.9%). Other records: 0.

The same distinct cited identity per bundle denominator is retained: current active answers, bases and counterevidence, excluding superseded histories. Visual records take precedence when both definitions match. Figure kind or any render field identifies visual evidence; remaining narrative records or any quote/start/end field identify text-span evidence. Missing or unmatched records are explicitly other and unbound overall. The per-trial derived CSV contains each kind's denominator and bound count, other count and a visual-trial indicator.

Text-span checks are unchanged. Visual checks require a render source matching the record source and a captured bundle source, positive integer render page, nonblank PNG hash, four finite coordinates within [0,1] with x0 < x1 and y0 < y1, and nonblank transcription. The PNG hash is checked for presence, as requested; it is not independently recomputed. Region arrays are accepted in both R numeric-vector and JSON list representations, without coercing strings to numbers.

Table 3, its caption, the supplement, the audit caption and the Figure 1 caption distinguish server-extracted text-span quotes from server-rendered, hash-bound visual regions. Visual transcriptions are model-written and not machine-checked against the image. No evidence-support judgement or PDF text re-extraction is inferred. DEVIATIONS.md entry 19 replaces the round 5 visual-failure interpretation.

## Validation

- Bundle-only extraction regenerated all 204 analysis-set per-trial binding rows. Other extraction outputs were unchanged.
- From analysis/: `Rscript -e "testthat::test_dir('tests/testthat', reporter='summary')"` passes all 188 assertions, with zero failures, errors or skips. Hand-built tests cover text, valid visual records, malformed sources/pages/hashes/regions/transcriptions, hybrid precedence, unknown/missing records, repeated citations, counterevidence, inactive answers, historical records and empty bundles.
- `quarto render` successfully rebuilt both reports using the project renv environment.
- `Rscript verify-output.R` passes artifact, display and reconciliation checks: five 600-dpi PNGs, five one-page PDFs, both reports and required tables.
- `Rscript verify-round6.R` compares all 84 tracked CSVs to the immutable starting HEAD 657b949f3f367ea6c1c35ed2027e1ba5561e42e0. Exactly four CSVs change: data-derived/bundle-binding-counts.csv and output/tables/audit-summary.csv, table3.csv and table3-supplement.csv. Every other CSV and every non-binding audit row is unchanged.
- The prohibited-name scan passes for both rendered HTML reports, all output CSV/Markdown files and extracted text from all five figure PDFs.
- All five regenerated PDFs have identical extracted text to HEAD; incidental regenerated PDF changes were discarded. The known Windows Unicode conversion in the generated coding README was also discarded. PNGs are unchanged.
- `git diff --check` passes. Existing Windows R startup locale warnings remain; testthat itself reports no warnings.

## Choices and uncertainty

No unresolved metric-definition uncertainty remains. Hybrid-record precedence and unknown/missing-record handling are explicit choices recorded in DEVIATIONS.md. The existing bootstrap rules are retained (10,000 stratified trial-cluster replicates, seed 20261018). Visual-binding replicates with no visual evidence have undefined denominators and are excluded from that interval; valid-replicate counts remain in the audit CSV. All observed visual binding rates and their defined bootstrap replicates are 100%.

Existing author tasks (final trace selection, human taxonomy coding, checklist completion and Zenodo DOI) remain outside this metric fix.
