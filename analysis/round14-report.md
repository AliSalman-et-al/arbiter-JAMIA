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

## Round 2

Baseline: `7befa34` on `main`. No commit or push. WP-T2 owns the curated
prior-work CSV and notes; its edits and the orchestrator's REVIEW.md additions
are concurrent work, not WP-A2 edits. All arm, adjudication, benchmark and
`data-derived/` inputs and all protected Figure 1–2 files remain read-only.

### WP-A2 queued items

1. **Preferred-share wording — complete.** Figure 5, the sensitivity/strictness
   eTables and rules-only blocks identify preference among adjudicated arm
   disagreements. They do not call the primary endpoint accuracy or correctness.
2. **Composite split — complete.** Existing composite eTable 11 adds four
   explicitly post hoc descriptive rows. ARBITER: agreed-choice **116/129
   (89.9%)**, retained Published **356/356 (100.0%)**. Unassisted: **69/129
   (53.5%)** and **356/356 (100.0%)**. The partitions reproduce **472/485** and
   **425/485** overall agreement. No new intervals or endpoint.
3. **Independent paired differences — complete.** Table 2 adds post hoc paired
   differences, all **154** disputed cells, using the existing shared 10,000
   trial-cluster bootstrap replicates within meta-analysis (seed 20261018):
   Adjudicator 1 **24.7 percentage points (95% CI 16.2–32.9)**, from 107 versus
   69 matches; Adjudicator 2 **28.6 (19.8–37.4)**, from 120 versus 76. The note
   confirms the rating was made and frozen before any label was seen.
4. **Question 5.1 mechanism description — complete.** New post hoc eTable 21 and
   one Results sentence describe the **18** primary Unassisted losses where
   question 5.1 alone changed the algorithm output. **13/18** had an inventoried
   registry record, protocol or SAP; **5/18** did not. All 13 have a registry
   record, so generic supplement classification cannot change this combined
   availability count. **0/18** Unassisted justifications mention any such
   document. Answers are **16 PY versus NI**, **1 Y versus NI**, and **1 Y
   versus N**; both adjudicators agree on every reference answer. The full export
   preserves both arms' question 5.1 justifications, both adjudicators' answers
   and source inventories. De Waal 2021's supplied registry belongs to a different
   trial: availability does not establish relevance or pre-specification.
5. **Label-target matching — complete.** eMethods describe the benchmark's
   outcome/time-point/contrast binding and its explicit versus inferred evidence.
   Recomputed match categories among 102 trials: **33 same**, **11 same across
   several covered outcomes**, **32 same inferred**, **7 partly**, **9 different**,
   **10 unknown**. Non-single-result labels are disclosed as **12 trial-wide sets
   (60 domain labels)**, **7 joint pain/disability sets (35 labels)**, and **10
   unknown-result sets (50 labels)**: **29 sets / 145 domain labels** altogether.
   **62 sets** have inferred binding, overlapping the unknown category; these
   are not an additional disjoint population. Exports `label-target-summary.csv`
   and `label-target-binding-counts.csv` reproduce the counts.
6. **Dates — complete.** eMethods report trial publication years **1996–2025**
   and source-review years **2025–2026**, with the possibility of training exposure
   in Limitations. The provider documents a **June 2026** training-data cut-off,
   verified on 19 October 2026 from its [model documentation](https://platform.claude.com/docs/en/models/sonnet-5-5/overview)
   and [training-data help page](https://support.claude.com/en/articles/8114494-how-up-to-date-is-claude-s-training-data).
   No date-stratified analysis was added.
7. **Runtime and cost labels — complete.** Process rows read “System runtime
   (min/trial)” and “API list-price equivalent (US$/trial)”. Results, the eTable
   note and eMethods state that runs used a subscription. eMethods show the
   per-token formula and frozen US$/million-token rates: input **2**, 1-hour
   cache write **4**, 5-minute cache write **2.5**, cache read **0.1**, output **10**.
   All retained runtime and price-equivalent estimates are unchanged.
8. **TRIPOD-LLM — mapping complete; author details remain flagged.** The separate
   Word reporting map and CSV map all **49 TRIPOD-LLM** and **15 GRRAS** items to
   named displays/eMethods/manuscript locations or justified N/A. The official
   checklist was read; instruction-tuning item 11 is N/A because no alignment
   training was performed. Rater credentials, ethics, funding, competing interests,
   registration and public involvement cannot be invented from analysis inputs;
   their planned manuscript locations are explicitly marked for author completion.
   Final manuscript pagination and author-assembled Introduction/Discussion/abstract
   remain to be checked. This is a reporting map, not a claim of completed compliance.
9. **Table 4 — complete against WP-T2's final schema.** Built last, after its
   schema arrived; no polling delay was needed. RobotReviewer is first; all eight
   requested feature columns are displayed, including Rule breaks measured.
   References use `reference_key` callouts. NR means Not reported and is kept
   distinct from No. Feature-specific Partly definitions and the difference between
   prompt instructions and enforced rules are condensed in the notes. No DOI list,
   internal project name, model name or misleading RobotReviewer evaluation n is
   shown. The extra design columns stay out of the display.

   **Resolved brief conflict:** the originally requested “Only this study gave
   both compared arms identical inputs” footnote is false under the reverified
   schema. Seven rows are Yes for input identity; Choi and this study are Yes for
   a fixed model with/without a workflow. The orchestrator's subsequent WP-T2
   clarification/review in `docs/round14/REVIEW.md` expressly drops exclusivity.
   The table therefore says this study gave both arms identical inputs and that
   other matched comparisons also used identical underlying sources.

### WP-A round 1 review items

1. **Figure 4B post hoc label — complete.** Removed from the axis; the legend
   marks the intervals as added post hoc. The Results sentence describes the
   pre-specified counts without calling them a post hoc analysis. Deviation 40
   records why the scope of entry 39 was refined.
2. **Rules-only framing — complete.** Results and the eTable title/note state
   that **3/62** changed, each to ARBITER's preferred rating, and **59** were
   unchanged. These three become ties, not new exclusive Unassisted wins. The
   original 62-cell denominator remains; overlapping label-equality credit is
   disclosed. The existing supplementary numbers remain **7→10**, **395→385/510**
   and **69→64/129**, with their existing intervals unchanged.
3. **Strictness — complete.** Pipeline recomputation and tests verify ARBITER
   **88/124** and Unassisted **69/115**, using `all_n` and including split decisions.
   Both appear in the R2 Results sentence.
4. **R6 — complete.** Results state “zero domain rule breaks by design” and
   “every quotation was found in its content-hashed stored source”; no claim of
   semantic support was added.
5. **Table 4 — complete.** Rule-break column restored; quotation-check title,
   reference callouts and condensed definitions/notes applied.
6. **Main-text model names — complete.** Removed from Figure 3, the results
   introduction and Table 2/4 notes; the model is documented in Methods/provenance.
   Main Word tables are checked for the absence of “Sonnet”.
7. **Rejected saves — investigated and flagged.** `verify-round14-bundles.py`
   scans all **102 included committed bundles / 1,888 JSON members**. No rejected-
   save, attempted-save, error or validation-event keys exist. Successful histories
   cannot supply an attempted-save denominator. **53/637 is not reproducible from
   the committed bundles.** No invented derived metric was written; Figure 1 and
   its legend remain untouched. `round2-rejected-saves.json` records the finding;
   tests check the scan inventory and explicit non-reproducibility result. Authors
   must supply the underlying event logs or approve removal of the claim.
8. **Figure 5 post hoc counts — complete.** Recomputed and displayed
   **44 / 1 / 0; N = 45** and **10 / 6 / 1; N = 17** for ARBITER / Unassisted /
   neither, using the same outcome columns as the upper rows.

### Protected Figure 1–2 wording flags

Read-only PDF text extraction and the protected legend identify these author-review
items; no protected source, image, legend or notes file was changed:

- **Figure 1: “Store an unchangeable copy of each source”.** Direct conflict with
  the content-hashed-source wording rule; replace only with author approval.
- **Figure 1: “LLM agent”.** Conflicts with the glossary's approved lane label
  “AI model (LLM agent)”; author approval is needed for the protected figure.
- **Figure 2: “direct support”.** Potential conflict with the rule that quotation
  occurrence does not establish semantic support; it labels a model's evidence
  relationship, not an independently assessed finding. Authors should approve a
  label or clarify that distinction.
- **Figure 1: “Review the answers and supporting evidence”.** Related potential
  ambiguity: support was not assessed in this evaluation. This is a human review
  action, so it is a flag rather than a demonstrated false verification claim.

Neither figure calls ARBITER a second reviewer or uses “tamper-proof”. Figure 2's
“all found in the stored sources” and independent-verifier wording comply with the
new rules. Separately, the protected Figure 1 legend's **53/637** needs sourcing as
noted above; it is not a wording-only correction.

### Invariance and verification

Round-2 verification uses **7befa34**, not the round-1 ancestor. The exhaustive
`verify-round14-numbers.py` comparison retains every baseline CSV and compares
all numeric fields at full precision after reversible label decoding. It also
compares the numeric body cells and retained footer numbers of main Tables 1–3,
plus every tracked frozen input/protected file. Declared changes are restricted
to the runtime/cost labels, filled checklist mapping fields, new Table 2 paired
rows, four composite component rows, the new descriptive eTable, and the revised
curated Table 4. Table 4 is a changed literature comparison, not a retained
statistical endpoint. All guideline/item/topic/source identifiers in the checklist
are retained. New rows do not excuse changes to retained estimates.

`verify-round14-tables.R` reconstructs retained supplementary tables from baseline
CSV values using the current display code and compares every numeric body token.
It additionally opens the actual Supplement.docx XML and checks all **49 current
table bodies** against generated numeric tokens, including new rows. The post hoc
paired-difference test includes a hand-built paired example; composite tests prove
the partition and recover total agreements; question 5.1, strictness, severity and
new-tie tests independently recompute their counts. Deviation 41 declares the new
post hoc additions. Environment substitutions remain those disclosed in round 1;
`renv.lock` is not changed.

### Round 2 final results and reproduction

- `quarto render` completed the numerical pipeline and both HTML reports.
  Presentation-only rebuilds then applied the final labels, notes and pagination;
  `quarto render supplement.qmd` refreshed the final supplementary HTML.
- `Rscript --vanilla test-round14.R`: **608 assertions passed; zero failures,
  errors, warnings or skips**. The old blank-checklist assertion was replaced by
  the requested populated-location contract; no statistical assertion was relaxed.
- `python3 verify-round14-numbers.py`: **58 retained CSVs / 7,651 retained numeric
  cells**, **79 numeric body cells in main Tables 1–3**, retained main-table footer
  numbers and **541 frozen/protected files** match `7befa34`. Only the two retained
  CSV files `table5.csv` (labels only) and `reporting-checklist-skeleton.csv` (filled
  mapping fields) differ in the working tree. Six new CSV exports contain the
  declared additions. No tolerance or rounding exemption is used for invariance.
- `Rscript --vanilla verify-round14-tables.R`: **30 retained supplementary table
  constructions**, with **4,692 current numeric body tokens**, agree with displays
  reconstructed from baseline CSVs. This current token total includes the declared
  new composite component rows, independently checked by the partition tests.
  The new question 5.1 eTable is excluded from the baseline comparison. The actual
  Supplement.docx passes all **49 table-body** token checks against generated data.
- `Rscript --vanilla verify-round14.R` and `verify-round14-round2.R` pass, including
  reproduction of all preliminary rules-only counts, the independent paired
  differences, composite partitions, label-binding counts, the three new ties,
  main-table terminology and complete checklist mapping.
- The release scan finds **zero Haiku matches in 105 publication artifacts**.
  The complete exclusion manifest now has **261 paths**. The round-1 listing above
  still applies; the two additional exclusions are
  `analysis/round14-verification/round2-release.log` and `docs/round14/REVIEW.md`.
  `round14-public-release-exclusions.txt` is the current complete inventory.

Logs are under `analysis/round14-verification/round2-*`; current structured audits
are `round14-invariance.json`, `retained-supplement-tables.csv` and
`round2-supplement-word-tables.csv`. The full test result remains in
`tests-round14.rds` / `tests-round14.txt`. Deviation entries 40–41 record the new
judgement calls. The retained package substitutions are disclosed in the round-1
environment section; the lockfile and all frozen inputs are unchanged.

### Round 2 visual QA and numbering

LibreOffice replaced native Microsoft Word, as in round 1. Final publication
layout checks pass: all four main tables occupy one page, Supplement.docx has
**61 pages**, the reporting map has **four pages**, and there are no blank pages
or out-of-page text spans. All figures retain 174-mm width; new figures have at
least 7.11-pt text; TIFFs are 600-dpi LZW. The rendered supplement retains all
**16/16 complete archived quotations**. Existing protected-artwork PDF font
warnings remain environmental diagnostics; those files were not modified.

Visual inspection covered main Tables 1–4, Figures 3–6, the supplementary forest,
all supplement pages represented in contact sheets, the four reporting-map pages,
and full-size changed Methods/composite/mechanism pages. The new composite rows
fit with the retained grid and its note on one page using wider labels and reduced
vertical padding. Table 4 uses NR to avoid splitting “reported” within its narrow
columns. The mechanism table uses unambiguous benchmark trial labels; the AVATAR
label removes the benchmark's attached reference-number artefact. The existing
26-cell rules-only listing still spans two pages with a repeated header; no cells
were dropped. Greyscale and deuteranopia checks keep the arms distinguishable.

Inspected paths relative to `analysis/`:

- `output/manuscript/Figure3.png` through `Figure6.png`, and `eFigure1.png`.
- `output/manuscript/qa/round14-Table1/page-1.png` through
  `round14-Table4/page-1.png`; Table 2 and Table 4 were re-rendered after note and
  NR changes.
- `output/manuscript/qa/round14-Supplement-contact-1.png` through `-8.png`;
  full-size `round14-Supplement/page-3.png`, `page-4.png`, `page-32.png` (composite
  split), and `page-44.png` (mechanism description).
- `output/manuscript/qa/round14-TRIPOD-LLM/page-1.png` through `page-4.png` and
  `round14-TRIPOD-LLM-contact-1.png`.
- `output/manuscript/qa/round14-Figure4-grayscale.png`,
  `round14-Figure4-deuteranopia.png`, `round14-Figure5-grayscale.png`, and
  `round14-Figure5-deuteranopia.png`.

Figures and main tables retain their round-1 numbering. eTables 1–20 retain their
numbers; new mechanism description is **eTable 21**. Former eTables 21–30 become
**22–31**; the rules-only analysis is now **eTable 23**, the full audit is 24,
required-question sensitivity 25, and time/cost 28. eFigure 1 is unchanged.
`output/manuscript/qa/round14-supplement-inventory.txt` records the complete current
inventory. References in Word/HTML/Results resolve through the same registry.

### Round 2 open issues

- Authors must source or approve removal of protected Figure 1's 53/637 claim.
- The protected labels listed above need author decisions; no Figure 1–2 edits
  were made.
- The reporting map flags missing author declarations/credentials and final
  manuscript assembly/pagination; it does not fabricate those statements.
- Input-identity exclusivity is resolved against the claim: the verified evidence
  and orchestrator review require nonexclusive wording. No missing WP-T2 schema
  issue remains.

No commit or push was performed. HEAD remains `7befa34`; the lockfile and frozen
inputs are unchanged. `git diff --check` passes.
