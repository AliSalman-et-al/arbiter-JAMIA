# WP-A round 3: small polish before commit

Round 2 is accepted apart from the items below. Do not change any estimate, and do not commit.

1. **Figure 6.** The main figure shows only the **collapsed** scale (Y/PY, N/PN, NI).
   - Remove the in-image title. No other manuscript figure has one; the finding goes in the legend.
   - Keep the n labels and the grouping by domain.
   - Move the five-level column into the supplement as its own eFigure, or merge it into eFigure 3.
   - Add a legend sentence, backed by a computed count: five-level differences mainly reflect the choice between "yes" and "probably yes" (and between "no" and "probably no"). Compute, for each arm and each expert, how many five-level disagreements are within-direction (Y↔PY or N↔PN) and how many cross direction. Put those counts in a supplement CSV and table row, and cite them.
   - The legend states the question-level finding plainly, with no D5-only claim.
2. **Table 2, mean-of-experts row.** Show percentages and κ only. Half counts such as "331.5/510" are not shown. The footnote explains that the row averages the two experts.
3. **Results sentence for D5 and D3.** Keep it, but phrase the domain gaps per expert without implying one pattern. Add one sentence using the new within- and cross-direction counts.
4. **Propagate and re-verify.** Update the legends, results.html, supplement.html, Supplement.docx, eTable and eFigure numbering, TRIPOD-LLM and round15-report.md. Run:
   - the tests;
   - the trace;
   - invariance checks;
   - the Fig 1 and Fig 2 byte check;
   - visual QA of every changed page;
   - the leak scan.

## Final message

Report:

- the new Figure 6 legend;
- the within- and cross-direction counts;
- the updated sentences;
- the verification results.
