# Round 14 implementation brief

Owner of direction and review: the orchestrating agent. Implementers: delegated workers.

## Read first, in this order

1. `ANALYSIS-PLAN.md`: section 6 (new post hoc analyses) and section 7 (the Round 14 Story, Main text and Supplement lists). Section 7 is the specification for every output. The closing "Round 14 story and display revision" note maps old item numbers to new ones.
2. `GLOSSARY.md`: internal terms and the reader-facing label table. Every output uses the reader labels.
3. `analysis/DEVIATIONS.md` entries 38–39.
4. `docs/research/llm-rob2/SYNTHESIS.md`: the literature behind the story.
5. `analysis/README.md`, `analysis/round13-report.md`: how the pipeline and the previous round worked.

## Direction, in one paragraph

The paper argues as follows. Both models agreed poorly with published RoB 2 labels, mostly because they rated more strictly, and blinded adjudicators usually agreed with the stricter rating. When ARBITER and the unassisted model disagreed, the adjudicators chose ARBITER in 54 of 62 cells. Applying the RoB 2 rules to the unassisted model's own answers changes almost none of those cells, so the gain came from the answers the workflow produced, not from the arithmetic. ARBITER's software guarantees rule consistency and quotations found in stored sources. Every output should serve that argument, follow the Results order R1–R7 in section 7, and give each number a single home.

## Hard constraints

- **Inputs are read-only**: the arm folders, `human-adjudication/`, `rob2-meta-benchmark-set/` and `analysis/data-derived/`.
- **Figures 1 and 2 are protected.** Do not modify `analysis/figure1/`, `Figure1.*`, `Figure2.*` or their notes files. Their legends may only lose Haiku mentions, if any exist.
- **Haiku is removed from every output** as if it never existed: `output/manuscript/`, `output/tables/`, `output/figures/`, the supplement, `results.html`, `supplement.html`, the results sentences, legends, the TRIPOD-LLM checklist and `analysis/README.md`. Do not delete the Haiku data folders. Keep Haiku code only where removing it would be riskier than leaving it unused. List every remaining Haiku file or path in the report under "Public-release exclusions".
- **Sonnet estimates must not change** except where section 6 or section 7 says so. Prove this with a before/after comparison against the parent commit: every retained number, in every retained CSV and table.
- **Post hoc analyses** are labelled "post hoc" in every title, legend and footnote that shows them.
- **Preliminary numbers to reproduce** (from DEVIATIONS 39): 3 of 62 consensus discordant cells change; Unassisted wins 7 → 10; agreement with published labels 395 → 385 of 510; agreement with the agreed choice 69 → 64 of 129. If the pipeline gives different numbers, report both and explain the difference. Do not adjust anything to match.
- **Fig 4B estimand** (from vindicated-disagreements.csv), to reproduce: ARBITER 73/77 stricter and 22/28 more lenient; Unassisted 48/59 and 19/38. CIs come from the existing stratified cluster bootstrap (seed 20261018, B = 10,000).
- **Production standards** follow ANALYSIS-PLAN section 7 "Production standards" and the Round 12/13 rules: finding titles, legends of 120 words or fewer, reader labels, number formatting, fonts, sizes, three-line tables, colours.
- **Do not commit and do not push.** Leave all changes in the working tree; the orchestrator reviews and commits.

## Environment

- This machine runs Linux: R 4.3.3 at `/usr/bin/Rscript` and Quarto 1.10.19.
- The README commands and `render-word-qa.ps1` assume Windows with R 4.6.1 and Microsoft Word. If `renv` cannot restore exactly under R 4.3.3, report what you did. Do not silently upgrade or downgrade package versions in `renv.lock`.
- For DOCX visual QA, use LibreOffice (`soffice --headless --convert-to pdf`) if it is available, then rasterise the pages. State the substitution.

## Reporting

Write `analysis/round14-report.md`, following the shape of `round13-report.md`. It must contain:

- what changed, item by item, keyed to section 7
- the new numbering map
- the invariance proof and its script
- test results
- visual QA, including the PNG paths you inspected
- "Public-release exclusions"
- every judgement call or open issue, flagged plainly

Put new verification scripts under `analysis/` with the prefix `verify-round14`.
