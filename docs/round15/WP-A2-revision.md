# WP-A round 2: revisions after orchestrator review

The analysis numbers are accepted. The problems are in presentation and in how the results sentences are framed. Do not change any estimate. Do not commit.

## 1. Table 2 is too long and out of order

It has 49 rows, and the "Mean of experts" rows are interleaved between the Adjudicator 2 blocks.

- **Main Table 2:** use a compact wide layout.
  - **Rows:** Adjudicator 1, Adjudicator 2, Mean of experts and Agreed reference. Each reference has two lines, D1–D5 (510 cells; 388 for the agreed reference) and Overall.
  - **Columns:** ARBITER, Unassisted and Published, each as exact agreement n/N (%) with weighted κ beneath or beside. Then ARBITER − Unassisted, the exact-agreement difference with its 95% CI.
  - Add an expert-to-expert row at the foot.
  - **The Overall line uses the 81 trials with an observed published Overall for all three sources,** so the line is like-for-like. A footnote states the 21 missing labels.
  - Footnotes define the mean-of-experts estimate and its CI, and the agreed reference.
- **New supplement eTable:** the full long version. It includes Overall on all 102 trials and the ARBITER − Published and Unassisted − Published contrasts.

## 2. Results sentences

- **Rules-only.** "The agreed-choice primary share for ARBITER remained 53/60" is tautological, because ARBITER's labels do not change. Report instead:
  - On the 60 agreed cells, recomputation made Unassisted's rating equal the agreed choice in one more cell (7 → 8).
  - Unassisted's agreement with each expert's independent rating after recomputation, against before: Adjudicator 1 went from 332/510 to 324/510; give the Adjudicator 2 counts likewise.
  - The rule fix did not raise, and for Adjudicator 1 it lowered, Unassisted's agreement.
  - Keep "26 ratings changed, 6 of them discordant".
- **Independent agreement.** Add the paired ARBITER − Unassisted difference with its CI for each expert: 7.6 (5.1–10.2) and 6.5 (3.5–9.4).
- **Derived Overall.** Add one sentence on the 81 matched trials, with the ARBITER − Unassisted differences and CIs.
- **Signalling questions.** Add the paired collapsed differences with CIs (Adjudicator 1: 5.0, 3.6–6.4; give Adjudicator 2 likewise). State that the largest gap is in D5, using its numbers.
- **Expert-to-expert.** Add κ, and the D3 agreement (54/102) as the lowest domain.
- Keep every number traceable, and re-run the trace.

## 3. One visual encoding across all figures

Use the same marker and colour for each source in Figures 4–6 and every eFigure:

- ARBITER: blue circle;
- Unassisted: orange square;
- Published: dark-grey triangle.

Legends and dodge order are always ARBITER, Unassisted, Published. Distinguish adjudicators by facet or by row label, never by marker shape.

## 4. Figure 4

- **Panel A.** The y-axis title floats far left, and there is a wide empty margin, because the panel is aligned with B's long labels. Give A its own left margin, or align the plot areas without padding A.
- **Panel B** has become a stacked horizontal 100% bar for each arm × direction × adjudicator.
  - Each bar is split three ways: expert matches the arm, expert matches Published, expert matches neither.
  - Print the n on each row.
  - Put the ARBITER rows first.
  - This shows directly that the experts rarely sided with the published label when ARBITER was stricter (5/88 and 14/88).
  - Use neutral fills for the three outcome segments, distinct from the source palette, and state them in the legend.

## 5. Figure 5

- Group the rows under three headers: Primary (agreed choice), Sensitivity (each adjudicator; split cells counted as losses) and Post hoc strata.
- Print the Unassisted count in the right-hand label, for example "53/60 (Unassisted 7)".

## 6. Figure 6

At domain level, Fig 6 repeats Fig 4A's pattern. Change it to a **per-signalling-question forest of the paired difference** (ARBITER − Unassisted agreement with the expert's independent answer):

- Rows are questions, grouped by domain.
- There are two columns: collapsed and five-level.
- Show both experts, faceted or with a row offset.
- Print the n for each question.
- Leave out questions with fewer than 20 paired answers. List them in the legend, and show them in the supplement.
- The domain-level version moves to the supplement.
- The title states the finding, for example that the gap concentrates in D5.

## 7. Figure 3

- The arrows between boxes 3, 4 and 5 are unevenly spaced and detached. Fix the spacing.
- Add a side note at the 510-cell box: "356 cells where all three labels agreed (no forced-choice information)".
- Add a side note at the top: "Overall derived for 102 trials from each expert's domain ratings".

## 8. Propagate and verify

- Update the legends, results.html, supplement.html, Supplement.docx, its numbering (citation order), TRIPOD-LLM and round15-report.md.
- Re-run:
  - the tests;
  - the number trace;
  - the unchanged-analysis diff;
  - the Fig 1 and Fig 2 byte check;
  - visual QA at page level, inspected;
  - the leak scan.

## Final message

Report:

- the new Table 2, as text;
- the full new `results-sentences.md`;
- a description of each figure change;
- every verification result.
