# Round 4 implementation report

P1–P4 are implemented on main, with one local commit per item. Nothing was pushed. ANALYSIS-PLAN.md, GLOSSARY.md and all input data folders remain unchanged.

## Commits

- P1: ab66203 — Align worked trace with workflow and select more-severe consensus example.
- P2: 6612042 — Remove repeated discordant count from consensus flow box.
- P3: 4681157 — Tag adjudication panels and distinguish zero-count tiles.
- P4: the commit containing this report, titled "Format process token units and record round 4 verification" — token units, captions, numeric-preservation script and final report.

## Chosen worked trace

- Trial/domain: award-10-2018 D2.
- Passage (25 whitespace-separated words): "One patient in the dulaglutide 0∙75 mg did not receive any doses of study drug and was therefore excluded from analysis in the intention-to-treat population."
- Locator: S2213-8587-18-30023-8.pdf, captured PDF page 5.
- Evidence: sha256:a54e3f2ee2f7afad8cd0e7e6159050710c49eab7a98976db1bdc117b22730806.
- Linked answer: 2.6 = PN. Active answers: 2.1=PN; 2.2=PN; 2.6=PN; 2.7=PN.
- Proposed/adopted judgement: Some concerns; meta and Baseline: Low; consensus preferred: Some concerns. This is a cell where only ARBITER departed from meta, with the more severe judgement preferred by both adjudicators.
- Exact verification-status text displayed: `verification.json: result = "verified"`; `Bundle checks include "content_hashes"`; `Bundle-level; no passage-level match status recorded`.
- verification.json checks: canonical_identity; content_hashes; proposal_gate; domain_lineage; snapshot_derivations; claims.
- Other candidates: clyman-2019 D4, boedt-2023 D5, potsiurko-2022 D4 (all more severe, only ARBITER departed, consensus preferred ARBITER), plus levin-2016 D2 as requested. Each has passage, locator and actual bundle verification status in worked-trace-candidates.csv.

Figure 1 now aligns each right-hand box with its workflow step. Figure 2 keeps the 62-cell/54–7–1 child while removing repetition in the consensus parent. Figure 3 has A/B tags, parallel row labels, and nearly white zero tiles with grey zeros. Table 5 and the Haiku counterpart use raw input counts (zero decimals, thousands separators), cache creation/read in millions (two decimals), and output/thinking in thousands (one decimal). Units apply to all displayed summaries and differences.

## Numeric diff and validation

- Snapshotted all 48 output/tables CSVs before editing. After the clean render and verify-output.R, 43 are byte-identical by SHA-256. Exactly five intentionally changed: figure1-draft-selection.csv, worked-trace-candidates.csv, figure3-panelB.csv, table5.csv, table5-haiku.csv.
- Figure 3 counts are identical after mapping the three renamed row labels. The trace tables deliberately replace the selected examples; retained values and excerpts are checked against their bundle-derived evidence. The two process display tables are regenerated from unchanged native-unit process summaries and the same paired differences. Formatting changes rounding only; no raw statistic, endpoint, cost, count or interval changed.
- `Rscript verify-round4.R <snapshot-directory>` passed. The script compares every CSV, restricts permitted changes, checks Figure 3 counts, verifies selected trace provenance, and reconstructs process displays from native values. For reuse, populate a baseline directory from the pre-round commit 331c121.
- Primary endpoint remains 54/7/1 of 62; composite kappa remains 0.941 versus 0.691; total API list-price equivalents remain USD 386.07 and USD 10.49 for the Sonnet arms.
- `Rscript -e "testthat::test_dir('tests/testthat')"` from analysis/: 138 assertions passed; zero failures, test warnings or skips.
- `quarto render` from analysis/ succeeded with generated tables, figures, HTML and .quarto moved aside first. The human coding sheet was preserved.
- `Rscript verify-output.R` passed: five 600-dpi PNGs, five one-page PDFs, both reports and required tables. Existing Windows R startup LC_* locale warnings persist; they do not prevent testing or rendering.
- Prohibited-name scan clean in both rendered HTML reports, output CSV/Markdown files and extracted text of all five figure PDFs.
- Inspected all five regenerated PNGs: no clipping or overlap; no internal figure titles. Figures 4 and the supplementary forest are unchanged. PDF timestamp-only regeneration changes were discarded, retaining the already generated and inspected P1–P3 PDFs.

## Uncertainty and author decisions

The bundles provide a bundle-level verified result and named checks, not a distinct passage-match outcome. Figure 1 states that limit explicitly rather than inventing a passage-specific claim. The default is selected as requested, while final author choice remains provisional under the binding plan. The original bundle excerpt includes the decimal glyph ∙ and a leading fragment "study."; the displayed contiguous excerpt drops only that fragment. Human taxonomy coding, checklist completion and the existing Zenodo DOI placeholder remain author work. No statistical uncertainty was resolved or changed in this presentation round.
