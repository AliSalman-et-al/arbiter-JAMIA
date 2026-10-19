# Round 14 pipeline and display revision

Parent: `bfe7111` on `main`. WP-A implementation in the shared checkout; no commit or push. The prior-work CSV and its notes belong to WP-T and were not edited by this worker. Figures 1–2, their notes, `analysis/figure1/`, all arm folders, adjudication inputs, benchmark inputs and `analysis/data-derived/` were kept read-only.

## A1–A6 and section 7 changes

- **R1, Figure 3:** two Sonnet arms; the tint/chip key is removed. Trial inclusion and all adjudication counts are retained.
- **R2, Table 1 and Figure 4A:** former Table 2 becomes Table 1. Pooled and Overall agreement, the All-Low rule and paired differences remain unchanged. Figure 4A retains domain-specific weighted κ. AC2 remains supplementary.
- **R3, Figure 4B:** a post hoc forest shows adjudicator agreement with each model, stratified by stricter or more lenient than Published, with stratified trial-cluster bootstrap intervals and n/N. Split counts are printed separately; Published-upheld and other-label counts are exported. The previous published-versus-agreed-choice panel is now an eTable.
- **R4, Figure 5 and Table 2:** the four primary/sensitivity forest rows remain. A separated, explicitly post hoc group adds the existing severity-stratified estimates, 44/45 and 10/17, using their existing intervals. The old panel B is removed. Former Table 4 (reference reliability) becomes Table 2, retaining its estimates.
- **R5, Figure 6 and post hoc recomputation:** Figure 6 retains its localisation data and refers to the recomputation eTable. Pure functions in `R/posthoc.R` replace only Unassisted violations, retain invalid paths and original populations, and calculate agreement and win shares with the shared bootstrap. Changed cells and all requested agreement outputs are exported. Unweighted κ and exact agreement are supplementary, labelled post hoc.
- **R6, Table 3:** the Round 13 layout and counts are retained. The note states 0/510 overrides and drops the override eTable. The Sonnet algorithm and proposal validation gates remain mandatory.
- **Discussion, Table 4:** the builder consumes WP-T's schema, uses its notes and citations, and does not edit either curated file. A labelled schema-only test fixture supports a missing-file build without inventing study content.
- **Supplement and R7:** the benchmark moves to the supplement; the inventory follows section 7. The tile matrix, unreported-model items, missing-judgement sensitivity and override eTable are removed. An input-parity paragraph quotes only facts from the Unassisted run README. Time, cost and tokens remain supplementary, with time and cost in results prose. The separate TRIPOD-LLM/GRRAS skeleton is rebuilt.
- **Publication exports:** CSVs use reversible reader source/status labels; builders decode these labels without changing values. Main Word tables, figures, legends, results sentences, HTML and supplement are rebuilt. Historical QA artifacts with superseded displays were moved outside the publication tree to `/tmp/round14-legacy-qa/`; they remain recoverable from the parent commit. The obsolete pre-manuscript `output/figures/figure1.*` and `figure2.*` aliases (a different workflow and old flow diagram) were removed; the current protected `output/manuscript/Figure1.*` and `Figure2.*` were not changed. The old artifact-dimension CSV was removed with those obsolete aliases.

## Numbering map

- Old Table 1 → benchmark eTable 1; published per-domain distributions → eTable 2.
- Old Table 2 → Table 1; old Table 4 → Table 2; Table 3 stays Table 3; Table 4 is the new prior-work comparison.
- CSVs: old `table1.csv` → `benchmark-set.csv`; old `table2.csv` and `table2-differences.csv` → `table1.csv` and `table1-differences.csv`; old `table4-reliability.csv` → `table2-reliability.csv`.
- AVATAR trace → eTable 3. Old Figure 4B → eTable 10. Old Figure 5B → Figure 4B, now with bootstrap intervals. Figure 5 becomes one forest with an added post hoc group. Figure 6 retains its content.
- The meta-analysis forest remains eFigure 1. The old eFigure 2 tile matrix is dropped. The complete generated eTable inventory is saved in `output/manuscript/qa/round14-supplement-inventory.txt`.

## Post hoc reproduction

An independent check against the parent cell exports reproduced the preliminary script before the new R pipeline ran: 26 Unassisted violations are replaced, including three of the original 62 consensus disagreements; wins 7 → 10; exact agreement with Published 395 → 385 of 510; agreement with the agreed choice 69 → 64 of 129. No value was adjusted to match the preliminary script. The new R functions independently reproduce every preliminary count, with no discrepancy. The 26 changed cells are listed in `output/tables/rules-only-recomputation-changed.csv`; 13 lie among the 129 agreed-choice cells. The three changed cells in the original 62-cell comparison are Albert 2013 D3 (Some concerns → High), Ashar 2022 D3 (Some concerns → High) and Jindani 2016 D5 (Low → Some concerns).

**Interpretation:** the original 62-cell comparison is deliberately held fixed. Once a corrected Unassisted label ties ARBITER, both arms can receive label-equality credit. The recomputed shares therefore do not form an exclusive win/loss partition. The eTable footnote states this.

The direction-of-disagreement estimates also reproduce all brief counts. ARBITER: stricter **73/77 (94.8%; 95% CI 90.4–98.7)**, more lenient **22/28 (78.6%; 63.6–91.7)**. Unassisted: stricter **48/59 (81.4%; 73.2–89.4)**, more lenient **19/38 (50.0%; 34.4–65.8)**. Split counts are 11, 8, 10 and 8 respectively. All four intervals use the existing seed 20261018 and 10,000 stratified trial-cluster replicates; every replicate is valid.

## Numerical invariance

`verify-round14-numbers.py` compares every retained CSV row and numeric field against `bfe7111`, decoding only publication labels and applying the explicit numbering map. It also compares every numeric body cell of retained Tables 1–3 against old Tables 2, 4 and 3, and checks read-only inputs and protected artwork. It records complete audit results in `round14-verification/round14-invariance.json`. The dropped sensitivity/override/tile exports and obsolete artifact-dimension metadata are not retained estimates. New post hoc exports and the new prior-work table have no parent counterpart.

**Result: all retained values match.** The exhaustive audit covers **52 retained CSVs and 7,303 numeric cells**, every numeric body cell (including merged denominator rows) and retained footer number in the three retained main tables (allowing only renumbered eTable references and the requested new 0/510 override statement), and **537 tracked input/protected-artwork/protected-QA files**. Binary protected files are compared byte for byte; text line endings are normalised. CSV explanation fields also normalise CRLF/LF without changing their wording. No numerical tolerance or rounding exemption is used.

`verify-round14-tables.R` independently reconstructs the **28 retained supplementary table constructions** from parent CSV values and compares **4,322 numeric body tokens**. Every comparison passes. New unweighted-agreement and rules-only tables are excluded from that retained-table comparison, as declared additions. The audit is `round14-verification/retained-supplement-tables.csv`. `git diff --check` passes; `renv.lock` is unchanged.

## Environment, tests and verification

The frozen lock targets R 4.6.1; this host provides R 4.3.3 and Quarto 1.10.19. `renv.lock` is unchanged. A restore was attempted into `/tmp/round14-R-library`. Frozen MASS and Matrix require a newer R; local validation uses the host's R-compatible versions instead. Graphics development headers/libraries were extracted under `/tmp/round14-sysroot` without changing the OS installation. The final package inventory contains 117 packages: **112 match the frozen versions exactly**. The five host recommended-package substitutions are MASS 7.3-60.0.1 (locked 7.3-65), Matrix 1.6-5 (1.7-5), class 7.3-22 (7.3-23), mgcv 1.9-1 (1.9-4) and survival 3.5-8 (3.8-6). These substitutions were explicit in the restore selection; no lockfile versions were rewritten. `round14-verification/package-versions.csv` records every version. The initial exact restore failed; the subsequent restore used the temporary development-library search paths and excluded those five host packages. Final figures use the vendored Fira Sans/Fira Sans Condensed files installed under the local font directory. Word tables declare Arial; LibreOffice resolves it to Liberation Sans locally.

Commands were run from `analysis/`, with `R_LIBS_USER=/tmp/round14-R-library`, `LD_LIBRARY_PATH=/tmp/round14-sysroot/usr/lib/x86_64-linux-gnu`, `R_PROFILE_USER=/dev/null`, `RENV_CONFIG_AUTOLOADER_ENABLED=FALSE` and `QUARTO_R=/usr/bin`:

1. `quarto render` — complete numerical pipeline and both HTML reports passed.
2. `ARBITER_PRESENTATION_ONLY=1 quarto render` — final display/pagination iterations passed.
3. `Rscript --vanilla test-round14.R` — **571 assertions passed; zero failures, errors, warnings or skips**.
4. `Rscript --vanilla verify-round14.R`, `Rscript --vanilla verify-round14-tables.R`, and `python3 verify-round14-numbers.py` — passed.
5. `python3 verify-round14-release.py` — scanned 99 text, Word and PDF publication artifacts, with **zero Haiku matches**. The R verifier also rejects internal source labels/codes in Word and rendered HTML.
6. The isolated QA Python environment ran `verify-round14-layout.py`, `verify-round14-trace.py`, `verify-round14-contact-sheets.py`; `verify-round14-visual.R` produced greyscale and deuteranopia checks.

Final test results and console output are in `round14-verification/tests-round14.rds`, `tests-round14.txt` and `tests-console.txt`. Full numerical-render, final presentation-render, Word-render and verification logs are alongside them. The standalone post hoc tests passed 17 assertions; the final deliverable tests passed 41. The full-suite count is lower than the historical suite because unreported-model tests and superseded display contracts were replaced, not because retained statistical assertions were relaxed.

The Haiku-specific input missingness (`test-inputs.R`), gate exception (`test-estimands.R`), process override (`test-process.R`), bundle inventory (`test-bundle-reverification.R`), source-label presentation (`test-presentation.R`) and tier-pricing assertions (`test-api-cost.R`) were removed or rewritten for Sonnet. The dropped tile-matrix assertion was removed from `test-round11.R`. Historical display-contract tests in `test-round11.R`, `test-round12.R` and `test-round13.R` were updated for the new inventory, numbering and panels; statistical count/bootstrap/localisation assertions remain. New tests cover handmade replacement, invalid paths, original denominators after ties, third-label and split outcomes, and hand-calculated unweighted κ.

## Visual QA

DOCX QA uses LibreOffice in place of Microsoft Word, as authorised by the brief. The packaged renderer initially lacked `pdf2image`; an isolated uv environment supplies its rendering dependencies. The final output has four one-page main tables, a **59-page Supplement** and a three-page checklist. The supplement contains 12 landscape AVATAR trace pages (6–17). All **16 complete archived quotations** are present in the rendered PDF after normalising only typography/whitespace and repeated page headers; `verify-round14-trace.py` records the check. No blank pages or text outside page bounds remain. Every figure is one page and 174 mm wide; all TIFFs are 600 dpi/LZW, and the new figures’ smallest text is 7.11 pt or larger.

Inspected PNG paths (relative to `analysis/`):

- `output/manuscript/Figure3.png` through `Figure6.png`, and `eFigure1.png`; the protected PDFs were rendered read-only to `output/manuscript/qa/round14-protected-Figure1.png` and `round14-protected-Figure2.png` and inspected.
- `output/manuscript/qa/round14-Table1/page-1.png` through `round14-Table4/page-1.png`; Table 2 was also inspected as a magnified crop to confirm its source labels.
- Every page in `output/manuscript/qa/round14-Supplement/page-*.png` and `round14-TRIPOD-LLM/page-*.png` is represented in the inspected contact sheets: `round14-Supplement-contact-1.png` through `-8.png`, and `round14-TRIPOD-LLM-contact-1.png`. Page text and geometry were checked programmatically across all pages. Main tables and selected table/trace details were also inspected at full image size.
- `output/manuscript/qa/round14-colour-contact-grayscale.png` and `round14-colour-contact-deuteranopia.png`, backed by the individual `round14-Figure3/4/5/6/eFigure1-{grayscale,deuteranopia}.png` files.

The benchmark now fits one page. Full agreement grids are kept together by source. Confusion matrices use three complete grids per page. The changed-cell list uses two pages with a repeated header; this is a pagination concession, with all 26 cells retained. The rules-only agreement block has no intervening blank page, and both exploratory signalling-answer tables fit one page each. Table 4 header words fit without being split mid-word. All plots retain readable labels and arm distinctions under the colour checks.

The PDF renderer/scanner emits `font resource is not a dictionary` diagnostics for the existing protected artwork. Those files still render and were visually inspected; they were not changed. The actual publication-artifact checks pass.

## Public-release exclusions

The unreported data and unused extraction/pricing support remain in the working repository. They are not publication outputs. The exhaustive file/path manifest is `round14-public-release-exclusions.txt`, generated by `verify-round14-exclusions.py`. It lists all model-named paths, tracked text references and new analysis/docs text references, including the read-only `kit-haiku-5.5/` and `no-kit-haiku-5.5/` trees, mixed-model derived CSVs, historical reports/plans and remaining extraction/pricing code. The common pricing/tier and bundle-extraction code remains to preserve historical extraction/reconstruction; it is not used to report the unreported arms. The stale legacy palette/order entries were removed. A release packager must omit the unreported trees and use Sonnet-filtered copies of mixed-model input CSVs; this work did not rewrite frozen inputs. The publication scanner checks Word XML, PDF text, CSVs, Markdown, SVG, HTML and the README rather than relying only on grep of uncompressed files.

<details>
<summary>Complete public-release exclusion manifest (259 paths)</summary>

```text
ANALYSIS-PLAN.md
GLOSSARY.md
analysis/DEVIATIONS.md
analysis/R/api-cost.R
analysis/R/bundle-review.R
analysis/R/publication-io.R
analysis/data-derived/README.md
analysis/data-derived/api-cost-trials.csv
analysis/data-derived/api-cost-turns.csv
analysis/data-derived/arbiter-haiku.csv
analysis/data-derived/baseline-haiku.csv
analysis/data-derived/bundle-binding-counts.csv
analysis/data-derived/bundle-path-checks.csv
analysis/data-derived/bundle-reverification.csv
analysis/provenance/bundle-reverification-summary.md
analysis/provenance/rename-residuals.md
analysis/provenance/verification-checks.md
analysis/report-round12.R
analysis/report-round2.R
analysis/report-round3.R
analysis/reverify-bundles.py
analysis/round10-report.md
analysis/round12-report.md
analysis/round13-report.md
analysis/round14-public-release-exclusions.txt
analysis/round14-report.md
analysis/round14-verification/release-scan.txt
analysis/round14-verification/round14-invariance.json
analysis/round2-report.md
analysis/round3-report.md
analysis/round4-report.md
analysis/round5-report.md
analysis/round6-report.md
analysis/round7-report.md
analysis/round8a-report.md
analysis/tests/testthat/test-round14-deliverables.R
analysis/verify-output.R
analysis/verify-round14-exclusions.py
analysis/verify-round14-numbers.py
analysis/verify-round14-release.py
analysis/verify-round14-tables.R
analysis/verify-round14.R
analysis/verify-round4.R
analysis/verify-round5.R
analysis/verify-round6.R
docs/round14/BRIEF.md
docs/round14/WP-A-pipeline.md
kit-haiku-5.5/README.md
kit-haiku-5.5/accuracy.md
kit-haiku-5.5/bundles/aarnoutse-2017.rob2.zip
kit-haiku-5.5/bundles/abbasi-2012.rob2.zip
kit-haiku-5.5/bundles/aboelfadl-2022.rob2.zip
kit-haiku-5.5/bundles/albert-2013.rob2.zip
kit-haiku-5.5/bundles/allen-2014.rob2.zip
kit-haiku-5.5/bundles/allsop-2014.rob2.zip
kit-haiku-5.5/bundles/amini-2022.rob2.zip
kit-haiku-5.5/bundles/an-2021.rob2.zip
kit-haiku-5.5/bundles/apalla-2013.rob2.zip
kit-haiku-5.5/bundles/arezzo-2008.rob2.zip
kit-haiku-5.5/bundles/ascet.rob2.zip
kit-haiku-5.5/bundles/ashar-2022.rob2.zip
kit-haiku-5.5/bundles/atli-2005.rob2.zip
kit-haiku-5.5/bundles/attal-2016.rob2.zip
kit-haiku-5.5/bundles/attal-2021.rob2.zip
kit-haiku-5.5/bundles/award-1-2014.rob2.zip
kit-haiku-5.5/bundles/award-10-2018.rob2.zip
kit-haiku-5.5/bundles/award-chn3-2023.rob2.zip
kit-haiku-5.5/bundles/bagg-2022.rob2.zip
kit-haiku-5.5/bundles/baillard-2006.rob2.zip
kit-haiku-5.5/bundles/baillard-2018.rob2.zip
kit-haiku-5.5/bundles/banovic26-avatar-2024.rob2.zip
kit-haiku-5.5/bundles/barratt-2024.rob2.zip
kit-haiku-5.5/bundles/bausys-2023.rob2.zip
kit-haiku-5.5/bundles/becker-2015.rob2.zip
kit-haiku-5.5/bundles/beerendonk-1996.rob2.zip
kit-haiku-5.5/bundles/beerendonk-1999.rob2.zip
kit-haiku-5.5/bundles/bendix-1996.rob2.zip
kit-haiku-5.5/bundles/bendix-2000.rob2.zip
kit-haiku-5.5/bundles/bente-2014.rob2.zip
kit-haiku-5.5/bundles/boedt-2023.rob2.zip
kit-haiku-5.5/bundles/boeree-2017.rob2.zip
kit-haiku-5.5/bundles/cadet.rob2.zip
kit-haiku-5.5/bundles/canvas-program.rob2.zip
kit-haiku-5.5/bundles/caprie.rob2.zip
kit-haiku-5.5/bundles/castoldi-2020.rob2.zip
kit-haiku-5.5/bundles/chiba-2021.rob2.zip
kit-haiku-5.5/bundles/chua-2022.rob2.zip
kit-haiku-5.5/bundles/clyman-2019.rob2.zip
kit-haiku-5.5/bundles/dapa-hf.rob2.zip
kit-haiku-5.5/bundles/de-waal-2021.rob2.zip
kit-haiku-5.5/bundles/declare-timi-58.rob2.zip
kit-haiku-5.5/bundles/deliver.rob2.zip
kit-haiku-5.5/bundles/dian-2018.rob2.zip
kit-haiku-5.5/bundles/duration-8-2016.rob2.zip
kit-haiku-5.5/bundles/einarsson-2017.rob2.zip
kit-haiku-5.5/bundles/el-khuffash-2021.rob2.zip
kit-haiku-5.5/bundles/elixa.rob2.zip
kit-haiku-5.5/bundles/empa-reg-outcome.rob2.zip
kit-haiku-5.5/bundles/emperor-preserved.rob2.zip
kit-haiku-5.5/bundles/emperor-reduced.rob2.zip
kit-haiku-5.5/bundles/envision.rob2.zip
kit-haiku-5.5/bundles/espinos-2017.rob2.zip
kit-haiku-5.5/bundles/exscel.rob2.zip
kit-haiku-5.5/bundles/ferreira-2021.rob2.zip
kit-haiku-5.5/bundles/fr-as-2018.rob2.zip
kit-haiku-5.5/bundles/frat-2019.rob2.zip
kit-haiku-5.5/bundles/freeman-2020.rob2.zip
kit-haiku-5.5/bundles/fulop-2021.rob2.zip
kit-haiku-5.5/bundles/getgoal-duo1-2013.rob2.zip
kit-haiku-5.5/bundles/getgoal-f1-2013.rob2.zip
kit-haiku-5.5/bundles/getgood-2020.rob2.zip
kit-haiku-5.5/bundles/gillis-2014.rob2.zip
kit-haiku-5.5/bundles/grant-2017.rob2.zip
kit-haiku-5.5/bundles/guitton-2019.rob2.zip
kit-haiku-5.5/bundles/gupta-2024.rob2.zip
kit-haiku-5.5/bundles/hamido-2021.rob2.zip
kit-haiku-5.5/bundles/hanafiah-2022.rob2.zip
kit-haiku-5.5/bundles/harmony-outcomes.rob2.zip
kit-haiku-5.5/bundles/heemskerk-2016.rob2.zip
kit-haiku-5.5/bundles/herrmann-2016.rob2.zip
kit-haiku-5.5/bundles/hill-2017.rob2.zip
kit-haiku-5.5/bundles/host-exam.rob2.zip
kit-haiku-5.5/bundles/hundscheid-2022.rob2.zip
kit-haiku-5.5/bundles/ibrahim-2017.rob2.zip
kit-haiku-5.5/bundles/jaber-2016.rob2.zip
kit-haiku-5.5/bundles/jindani-2016.rob2.zip
kit-haiku-5.5/bundles/kang25-recovery-2020.rob2.zip
kit-haiku-5.5/bundles/leader.rob2.zip
kit-haiku-5.5/bundles/levin-2011.rob2.zip
kit-haiku-5.5/bundles/levin-2016.rob2.zip
kit-haiku-5.5/bundles/lv-2023.rob2.zip
kit-haiku-5.5/bundles/monaleesa-2.rob2.zip
kit-haiku-5.5/bundles/monaleesa-3.rob2.zip
kit-haiku-5.5/bundles/monaleesa-7.rob2.zip
kit-haiku-5.5/bundles/monarch-2.rob2.zip
kit-haiku-5.5/bundles/monarch-3.rob2.zip
kit-haiku-5.5/bundles/monarch-plus.rob2.zip
kit-haiku-5.5/bundles/nefigard.rob2.zip
kit-haiku-5.5/bundles/paloma-2.rob2.zip
kit-haiku-5.5/bundles/pioneer-6.rob2.zip
kit-haiku-5.5/bundles/potsiurko-2022.rob2.zip
kit-haiku-5.5/bundles/rewind.rob2.zip
kit-haiku-5.5/bundles/rosen-2021.rob2.zip
kit-haiku-5.5/bundles/sanctuary.rob2.zip
kit-haiku-5.5/bundles/smart-choice-3.rob2.zip
kit-haiku-5.5/bundles/stop-igan.rob2.zip
kit-haiku-5.5/bundles/stopdapt-2.rob2.zip
kit-haiku-5.5/bundles/stopdapt-3.rob2.zip
kit-haiku-5.5/bundles/sung-2020.rob2.zip
kit-haiku-5.5/bundles/sustain-6.rob2.zip
kit-haiku-5.5/bundles/testing.rob2.zip
kit-haiku-5.5/bundles/vel-squez-2018.rob2.zip
kit-haiku-5.5/claude-home-settings.json
kit-haiku-5.5/continues.csv
kit-haiku-5.5/continues.py
kit-haiku-5.5/results-102/accuracy.md
kit-haiku-5.5/results-102/rob2kit-domain-labels.csv
kit-haiku-5.5/results-102/rob2kit-domain-labels.xlsx
kit-haiku-5.5/results-102/rob2kit-signalling-answers.csv
kit-haiku-5.5/results-102/rob2kit-signalling-answers.xlsx
kit-haiku-5.5/rob2kit-domain-labels.csv
kit-haiku-5.5/rob2kit-domain-labels.xlsx
kit-haiku-5.5/rob2kit-signalling-answers.csv
kit-haiku-5.5/rob2kit-signalling-answers.xlsx
kit-haiku-5.5/run_all.py
kit-haiku-5.5/run_case.py
kit-haiku-5.5/score.py
no-kit-haiku-5.5/README.md
no-kit-haiku-5.5/accuracy.md
no-kit-haiku-5.5/build_nokit_inputs.py
no-kit-haiku-5.5/continues.csv
no-kit-haiku-5.5/model-domain-labels.csv
no-kit-haiku-5.5/model-domain-labels.xlsx
no-kit-haiku-5.5/model-signalling-answers.csv
no-kit-haiku-5.5/model-signalling-answers.xlsx
no-kit-haiku-5.5/nokit-format.txt
no-kit-haiku-5.5/registry-markdown/NCT00159679.md
no-kit-haiku-5.5/registry-markdown/NCT00217971.md
no-kit-haiku-5.5/registry-markdown/NCT00222261.md
no-kit-haiku-5.5/registry-markdown/NCT00302796.md
no-kit-haiku-5.5/registry-markdown/NCT00472160.md
no-kit-haiku-5.5/registry-markdown/NCT00554502.md
no-kit-haiku-5.5/registry-markdown/NCT00760149.md
no-kit-haiku-5.5/registry-markdown/NCT00763451.md
no-kit-haiku-5.5/registry-markdown/NCT00975286.md
no-kit-haiku-5.5/registry-markdown/NCT01020019.md
no-kit-haiku-5.5/registry-markdown/NCT01064687.md
no-kit-haiku-5.5/registry-markdown/NCT01131676.md
no-kit-haiku-5.5/registry-markdown/NCT01144338.md
no-kit-haiku-5.5/registry-markdown/NCT01147250.md
no-kit-haiku-5.5/registry-markdown/NCT01161732.md
no-kit-haiku-5.5/registry-markdown/NCT01251211.md
no-kit-haiku-5.5/registry-markdown/NCT01347762.md
no-kit-haiku-5.5/registry-markdown/NCT01356264.md
no-kit-haiku-5.5/registry-markdown/NCT01394952.md
no-kit-haiku-5.5/registry-markdown/NCT01408914.md
no-kit-haiku-5.5/registry-markdown/NCT01560052.md
no-kit-haiku-5.5/registry-markdown/NCT01566929.md
no-kit-haiku-5.5/registry-markdown/NCT01630278.md
no-kit-haiku-5.5/registry-markdown/NCT01720446.md
no-kit-haiku-5.5/registry-markdown/NCT01730534.md
no-kit-haiku-5.5/registry-markdown/NCT01740427.md
no-kit-haiku-5.5/registry-markdown/NCT01785186.md
no-kit-haiku-5.5/registry-markdown/NCT01952795.md
no-kit-haiku-5.5/registry-markdown/NCT01958320.md
no-kit-haiku-5.5/registry-markdown/NCT01986543.md
no-kit-haiku-5.5/registry-markdown/NCT02010281.md
no-kit-haiku-5.5/registry-markdown/NCT02018354.md
no-kit-haiku-5.5/registry-markdown/NCT02044250.md
no-kit-haiku-5.5/registry-markdown/NCT02044809.md
no-kit-haiku-5.5/registry-markdown/NCT02107703.md
no-kit-haiku-5.5/registry-markdown/NCT02128191.md
no-kit-haiku-5.5/registry-markdown/NCT02169882.md
no-kit-haiku-5.5/registry-markdown/NCT02229396.md
no-kit-haiku-5.5/registry-markdown/NCT02246621.md
no-kit-haiku-5.5/registry-markdown/NCT02278120.md
no-kit-haiku-5.5/registry-markdown/NCT02416960.md
no-kit-haiku-5.5/registry-markdown/NCT02422615.md
no-kit-haiku-5.5/registry-markdown/NCT02436655.md
no-kit-haiku-5.5/registry-markdown/NCT02465515.md
no-kit-haiku-5.5/registry-markdown/NCT02530957.md
no-kit-haiku-5.5/registry-markdown/NCT02597049.md
no-kit-haiku-5.5/registry-markdown/NCT02617693.md
no-kit-haiku-5.5/registry-markdown/NCT02619760.md
no-kit-haiku-5.5/registry-markdown/NCT02668458.md
no-kit-haiku-5.5/registry-markdown/NCT02692716.md
no-kit-haiku-5.5/registry-markdown/NCT02700321.md
no-kit-haiku-5.5/registry-markdown/NCT02763566.md
no-kit-haiku-5.5/registry-markdown/NCT02913404.md
no-kit-haiku-5.5/registry-markdown/NCT02938104.md
no-kit-haiku-5.5/registry-markdown/NCT03036124.md
no-kit-haiku-5.5/registry-markdown/NCT03057951.md
no-kit-haiku-5.5/registry-markdown/NCT03057977.md
no-kit-haiku-5.5/registry-markdown/NCT03131687.md
no-kit-haiku-5.5/registry-markdown/NCT03294148.md
no-kit-haiku-5.5/registry-markdown/NCT03396094.md
no-kit-haiku-5.5/registry-markdown/NCT03564106.md
no-kit-haiku-5.5/registry-markdown/NCT03619213.md
no-kit-haiku-5.5/registry-markdown/NCT03643965.md
no-kit-haiku-5.5/registry-markdown/NCT03758209.md
no-kit-haiku-5.5/registry-markdown/NCT03790449.md
no-kit-haiku-5.5/registry-markdown/NCT03841448.md
no-kit-haiku-5.5/registry-markdown/NCT03860428.md
no-kit-haiku-5.5/registry-markdown/NCT04223401.md
no-kit-haiku-5.5/registry-markdown/NCT04287985.md
no-kit-haiku-5.5/registry-markdown/NCT04291781.md
no-kit-haiku-5.5/registry-markdown/NCT04418479.md
no-kit-haiku-5.5/registry-markdown/NCT04564339.md
no-kit-haiku-5.5/registry-markdown/NCT04591626.md
no-kit-haiku-5.5/registry-markdown/NCT04609111.md
no-kit-haiku-5.5/results-102/accuracy.md
no-kit-haiku-5.5/results-102/model-domain-labels.csv
no-kit-haiku-5.5/results-102/model-domain-labels.xlsx
no-kit-haiku-5.5/results-102/model-signalling-answers.csv
no-kit-haiku-5.5/results-102/model-signalling-answers.xlsx
no-kit-haiku-5.5/run_all.py
no-kit-haiku-5.5/run_nokit_case.py
no-kit-haiku-5.5/score.py
no-kit-sonnet-5.5/run_nokit_case.py
```

</details>

## Judgement calls and open issues

- Keep the original 62-cell comparison after rules-only recomputation; disclose overlapping credit after ties rather than silently redefining the denominator.
- Keep the Round 13 audit-row design as WP-A requests. There is no derived rejected-save metric in the supplied committed inputs; no rejected-save count is invented. A new metric would require a separately specified extraction from raw logs, which this package does not modify.
- The existing missing-answer-set exclusion (509 evaluable Unassisted domain paths) remains, while agreement with Published continues to use all 510 reported labels.
- The brief's old display numbering is superseded by section 7; dynamic eTable references resolve to the current inventory without editing protected Figure 1–2 source legends or notes.
- Linux R and LibreOffice differ from the frozen Windows production environment; this is disclosed, and invariance and visual checks assess the resulting artifacts explicitly.

## Complete supplementary numbering

- eTable 1. Benchmark trials span sixteen meta-analyses
- eTable 2. Published label distributions by domain
- eTable 3. AVATAR complete trace
- eTable 4. Confusion matrices against Published
- eTable 5. Per-meta-analysis weighted κ
- eTable 6. Agreement against Published, all sources and domains
- eTable 7. Paired differences against Published
- eTable 8. Post hoc: unweighted agreement with published labels is modest
- eTable 9. Post hoc: adjudicators usually agreed with models when they disagreed with Published
- eTable 10. Published labels were usually less severe than the agreed choice
- eTable 11. Agreement against the composite reference, Sonnet only
- eTable 12. Paired differences against the composite reference
- eTable 13. Composite-reference sensitivity estimates by adjudicator
- eTable 14. Composite-reference paired differences by adjudicator
- eTable 15. Per-adjudicator and split-cell win-share sensitivity
- eTable 16. Post hoc severity-stratified win share
- eTable 17. Independent and selected ratings: full agreement including AC2
- eTable 18. Localisation population eligibility
- eTable 19. Error-localisation classes, both populations
- eTable 20. Questions that alone changed the rating: frequencies, both populations
- eTable 21. Unresolved independent answer
- eTable 22. Post hoc: recomputing Unassisted ratings changes few arm disagreements
- eTable 23. RoB 2 consistency and structural audit, all sources and domains
- eTable 24. Required question skipped sensitivity
- eTable 25. Quotation syntax in active justifications
- eTable 26. Unassisted justification content
- eTable 27. Time, cost and token use per trial by model
- eTable 28. API cost reconstruction: estimates and bounds
- eTable 29. Token reconciliation and compaction diagnostics
- eTable 30. Exploratory signalling-answer agreement

The only supplementary figure is eFigure 1 (per-meta-analysis weighted κ). No commit or push was performed; HEAD remains `bfe7111`.
