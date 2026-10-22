# Implementation report

Status: **PASS for implementation. ISSUES remain for author-supplied submission information. BLOCKED: none.** Independent review remains with the parent.

## Scope and checkout

Baseline and final HEAD: `951dddd3e28e0d6316c641491667353e0b851a78`. No commits, pushes, PRs, model experiments or subagents were used. The accepted `GLOSSARY.md` edits and pre-existing research/design files were preserved. Raw inputs, expert workbooks, input logs and historical plans/reports were not edited.

Applied the four requested Pstack leaf skills: sequence-verifiable-units, prove-it-works, technical-writing and unslop. The document skill supplied rendered QA guidance; the existing journal/publication layout governed the artifacts.

## Delivered

- Rewrote the manuscript around the available inspectable workflow and its complete same-model evaluation. Kept the conditional formal primary endpoint, separate expert references, full-cohort Published comparison, fixed-review bootstrap interpretation, and bounded process/resource claims. Omitted study-history declarations. Current count: **220 abstract words; 2,931 main-text words**, below 250 and 4,000 respectively.
- Preserved Figures 1–2. Rebuilt Figure 3 as paired outputs followed by the separate full-cohort and conditional-choice paths. Figure 4 pairs absolute rates with paired gains against each expert, plus the full-cohort Published line. Figure 5 retains every domain, both experts, paired eligibility denominators and separate five-level/collapsed contrasts. Main figure count is five.
- Rebuilt Table 1 as benchmark/reference context, Table 2 as the primary endpoint and three core sensitivities, and Table 3 as separate conformance, structural-record and computational-resource sections. Main table count is three. Retired the obsolete Figure 6 and Table 4 current exports.
- Organized the supplement into seven numbered sections, a one-page navigation map, 23 numbered tables, supporting displays, complete signalling diagnostics, derived Overall/missingness, prompts and the worked assessment trace. Removed duplicate contrast collections and the legacy feature-score literature matrix. The evidence ledger uses primary-source links. Review-level figures retain all 16 reviews, including degenerate or undefined estimates.
- Synchronized the two current HTML views with Word/display exports. Fixed a Windows encoding defect that had truncated the supplementary HTML before its tables. Kept the formal 53/60 result visible across current outputs.
- Added `analysis/build-publication.R` so presentation can be regenerated from finalized estimates without rerunning the bootstrap. Added a generated manuscript DOCX. Fixed Word style export after actual Word rendering exposed an invalid transparent-color encoding and template numbering.

## Sources and artifacts

Main source: [manuscript.md](../manuscript/manuscript.md), [references.md](../manuscript/references.md), and [number verifier](../manuscript/verify-numbers.py).

Generators: `analysis/R/displays.R`, `manuscript-figures.R`, `manuscript-legends.R`, `manuscript-supplement.R`, `display-numbering.R`, `presentation.R`, `results-sentences.R`, and `checklist.R`; `analysis/results.qmd`, `analysis/supplement.qmd`, `analysis/build-publication.R`, and `analysis/verify-output.R`. A complete tracked-path inventory is in [implementation-changed-files.json](implementation-changed-files.json); its pre-existing GLOSSARY entry is explicitly identified.

Current deliverables:

- [Manuscript.docx](../../analysis/output/manuscript/Manuscript.docx)
- [Supplement.docx](../../analysis/output/manuscript/Supplement.docx)
- [Results HTML](../../analysis/results.html) and [supplement HTML](../../analysis/supplement.html)
- `analysis/output/manuscript/Figure1–5.{pdf,png,tiff}`; protected Figures 1–2 also retain SVGs.
- `analysis/output/manuscript/Table1–3.docx`, `TRIPOD-LLM.docx`, `figure-legends.md`, and `results-sentences.md`.
- `analysis/output/tables/display-*.csv` and the current display-source trace.

Some new/current generated artifacts follow the repository's existing output ignore rules. They exist on disk and should be included deliberately when the parent assembles a release; no staging was performed.

## Numerical and artwork guarantees

[implementation-invariance.json](implementation-invariance.json) reports **38 numerical exports unchanged**, including estimates, intervals, numerators, denominators and valid replicate counts. The independent output verifier also reproduces workbook equality counts, signalling disagreement counts, Overall populations and binary numerators/denominators. Presentation CSVs intentionally change structure and are verified separately against their builders and rendered documents.

Retained numerical spine: 102 trials, 16 reviews, 510 domain cells; 80 arm-discordant cells, 60 agreed choices and 20 splits; primary 53/60, 88.3% (79.7–96.3); independent exact agreement 371/510 versus 332/510 and 433/510 versus 400/510; paired gains 7.6 and 6.5 points; full-cohort Published difference −1.8 points. Derived Overall retains 102 expert trials and 81 observed Published labels, with 21 missing labels excluded. Bootstrap mechanics, seed and estimands were not changed.

**4,639 protected files** covering the Figure 1–2 source-artwork tree and eight publication outputs match captured SHA-256 hashes. All eight publication output hashes also match their protected Git blobs. See [implementation-baseline.json](implementation-baseline.json) for per-file hashes and [implementation-invariance.json](implementation-invariance.json) for zero mismatches. The Figure 1 PNG hash is `675eacde50fc7a317e19c540621adc5efcfe586c290896840d3adc2a2eb2cb6d`; Figure 2 PNG is `e42fd187b63adbd7097442df85feb3b5b3b849fb4f7273fc314872570cffe79c`.

No Published-target-matching subgroup was added. Reporting is Sonnet-only for this study. Source-specific answer rates and paired eligible differences remain distinct; percentage-point units replace percentage units for paired display contrasts. The split-loss assumption is distinguished from observed neither-arm choices.

## Commands and results

Commands below ran from `analysis/` unless a root-relative path is shown. R executable: `C:/Program Files/R/R-4.6.1/bin/Rscript.exe`.

| Command | Result/evidence |
|---|---|
| `Rscript run.R` | PASS; full statistical pipeline and both HTML renders; `implementation-build.log` |
| `Rscript -e 'testthat::test_dir("tests/testthat")'` | PASS, 220 assertions, zero failures/warnings/skips; `implementation-tests.log` |
| `Rscript build-publication.R` | PASS; accepted publication rebuild in `implementation-build-accepted.log`; focused final supplement refresh in `implementation-supplement-final.log` |
| `Rscript verify-output.R` | PASS; current five/three inventory, all display/Word/HTML cells, source trace, workbook checks, numerical invariance and model/reader scans; `implementation-verification.log` |
| `C:/Python314/python.exe docs/manuscript/verify-numbers.py` | PASS; number trace, word limits, references and citation order; `implementation-manuscript-check.log` |
| `C:/Python314/python.exe docs/rethink-2026-10-22/verify-rebuild.py` | PASS; 4,639 protected files and 38 numerical exports unchanged |
| `git diff --check` | PASS |
| `render-word.ps1` then managed Python `render-qa.py` | PASS; all six DOCX files open in Word and export to PDF; page images/contact sheets and page bounds checks under `rendered/` |

R emitted the existing startup locale warnings; the builds completed. The supplementary Quarto generator now explicitly uses UTF-8 and a file-based Pandoc transfer.

## Actual rendered QA

Figures 3–5 were inspected at full publication width; Figure 4's interval ends remain inside the −10 to +30-point contrast scale. Color and grayscale Figure 4 proofs preserve circle/square arm identification and neutral paired contrasts. The full 16-review supplementary forest was inspected after restoring degenerate/undefined rows.

All six final documents were opened by installed Word and exported, then rasterized. The manuscript has 11 pages, the supplement 106, the reporting map five, and the main tables one each: **125 pages total**, with no empty pages or text outside page bounds. Every page was available as a PNG; contact sheets across the full documents and selected pages at reading size were inspected. Final changed section starts, the split-loss row, full-width figures, reporting map and manuscript headings received additional inspection. QA files are internal evidence, not alternate publication deliverables.

The packaged LibreOffice renderer was attempted and returned `FileNotFoundError: LibreOffice soffice.exe was not found on PATH`. Word was used successfully instead. T3 browser snapshots timed out twice. A direct browser-executable launch was rejected by automatic approval review with `blocked by policy`; it was not retried. T3's headless HTML preview rendered static proofs retaining the current HTML content/CSS and exact figure bytes, with scripting/icon-font payload removed and viewport units fixed for the expanding preview frame. Browser automation/navigation was not independently certified. The full, unmodified HTML files passed exhaustive display-cell and Results-sentence checks, including every supplementary table. These browser limitations do not affect the inspected Word/publication files.

## Issues for parent/author review

No known unresolved computational, numerical or protected-artwork defect remains. The parent should perform the independent review requested in the handoff.

Submission still requires author names/affiliations, expert qualifications/training, acknowledgements and AI disclosure details, funding, competing interests, CRediT roles, ethics/registration/public-involvement determinations, and the study archive DOI/public URLs. These are explicit author-completion fields; they were not fabricated. The live ARBITER repository and evaluated commit are linked separately. The study-data archive is described as pending, not already public.
