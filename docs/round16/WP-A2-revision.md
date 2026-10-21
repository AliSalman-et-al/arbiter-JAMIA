# WP-A round 2 (Round 16): figure fixes and results sentences

WP-A is accepted apart from the items below. Its estimates, tables, numbering approach and release manifest are accepted. Do not change any estimate, and do not commit. Scope: `analysis/`, plus `docs/round16/release-manifest.md` if any path changes.

## 1. Figure 3 (flow)

The branches now split from "102 trials included". The disputed-cell branch is a subset of the 510 cells, though, not of the trials. The exclusion box and the side notes float unattached. Rebuild the figure as follows.

- Top box: "105 benchmark trials". Draw an arrow down to the next box, with a side box joined to it by a connector: "3 excluded: designs ARBITER does not support". (Resolved conflict: ARBITER exported 105 trials and Unassisted only the 102 included trials, so "assessed by both arms" is not supported.)
- "102 trials × D1–D5 = 510 domain cells, each rated independently by two blinded experts".
- From that box, two branches:
  - **Left:** "Independent-rating comparison: all 510 cells. Overall derived for 102 trials; compared on 81 with a published Overall".
  - **Right:** "154 disputed cells (either arm differs from Published)", with a side note joined to it: "356 cells with three equal labels (no forced-choice information)". Then "80 where the arms disagreed" → "60 with an agreed forced choice (primary)". Attach a side note to the 80 box with a connector: "20 split".
- All connectors and side notes are attached. Arrow lengths are even, and empty canvas is minimal.

## 2. Figure 4

Change the heading "Post hoc strata" to "Exploratory strata", to match the outcome labels. Change the legend to match.

## 3. Figure 5A

The per-facet n annotations overlap the zero line and the x tick labels. Remove them from the plotting area and give the denominators once, in the legend: "Pooled n = 510 cells; each domain n = 102; Overall n = 81 trials". Make no other change.

## 4. Figure 6

- The facets touch, so "90%" and "60%" collide at the boundary. Add panel spacing, or use a shared y-axis label column with separated facets.
- Use axis limits wide enough for every CI. Make the row labels the same size as in the other figures.
- Keep the encoding.

## 5. `results-sentences.md`

Rewrite these points. Every number must already exist in the outputs and trace.

- **Paragraph 1.** Lead with the pattern: both experts rated Low less often than any other source. Then give the five counts. Then expert-to-expert agreement and D3.
- **Paragraph 3.** Delete the redundant "within the range of agreement between the two experts" clause, so the κ sentence states the bracketing once. Add one clause bounding Overall:
  - absolute Overall agreement was lower for every source;
  - the experts agreed with each other on 42/81 matched Overall ratings (κ 0.33);
  - ARBITER's matched Overall agreement was 32/81 against Expert 1 and 60/81 against Expert 2.
- **Paragraph 4 (strictness).** Lead with the finding that answers the objection: ARBITER's higher sensitivity for Some concerns or High against each expert came without lower specificity. Specificity was 97.8% versus 95.7% against Expert 1 and 95.1% versus 95.1% against Expert 2. Then give the sensitivity numbers and paired differences. Then the direction bars, including the Published matches: 5/88 and 14/88.
- **Paragraph 5 (published benchmark).** Remove "compared with the advantages against the experts". State plainly that against published labels the arms showed no clear difference in exact agreement or κ (give both differences). Add the contrast: against published labels, ARBITER's higher sensitivity came with lower specificity (+15.7 and −4.4 points, with CIs from `agreement-meta-differences.csv`); against the experts it did not.
- **Paragraph 7 (process).** Add the ARBITER side:
  - zero domain rule breaks by design and no recorded overrides;
  - all 1538 required answers cited evidence;
  - 1407/1407 quotations found in the stored source;
  - all 102 audit files passed the independent verifier.
- **Throughout.**
  - Group callouts as ranges: "eTables 4–6", not "eTable 4; eTable 5; eTable 6".
  - Keep "prespecified" and "exploratory" labels to one word per paragraph lead, so they don't repeat in every sentence.

Propagate to results.html, the supplement and anywhere else these sentences feed.

## 6. Clean full rebuild

The WP-A pipeline was not re-run uninterrupted after the typo fix. After these edits, run the complete pipeline from a clean state, then repeat every WP-A verification:

- tests;
- trace;
- invariance against `fee1225`;
- byte check on Figures 1 and 2;
- visual QA of every changed page and figure;
- leak scan;
- display-numbering check.

## Final message

Report:

- a description of each figure change;
- the full new `results-sentences.md`;
- any numbering change;
- every verification result, including the clean-rebuild time.
