# WP-A round 3 (small, final)

Read `docs/round14/BRIEF.md` and the "Author decisions" section of `docs/round14/REVIEW.md`.

1. **Figure 1 and Figure 2 label edits (authorised exception to the protection rule).**
   - Change only these strings in the generating source:
     - Fig 1: "Store an unchangeable copy of each source" becomes "Store a content-hashed copy of each source".
     - Fig 1: "supporting evidence" becomes "cited evidence".
     - Fig 2: "direct support" becomes "direct quotation".
   - Re-render SVG, PDF, PNG and TIFF.
   - Prove the change is limited to those strings: compare the SVG text before and after, and diff the rendered images.
   - Change nothing else in `analysis/figure1/`.
2. **Remove the rejected-saves sentence (53/637)** from the Figure 1 legend, its alt text, the figure notes and every other output. Grep to prove it is gone.
3. **Table 4.**
   - "[ref: This study]" becomes "This study (ARBITER)".
   - The notes cite the supplementary eTable that holds the cell evidence, not a repository file. Add that eTable to the supplement if it is missing: a condensed evidence table, one row per study, with the quotation locations.
4. **Methods and Limitations text in the supplement and plan:**
   - Disclose the label-to-result match distribution (33 same, 11 same across outcomes, 32 inferred, 7 partly, 9 different, 10 unknown).
   - Disclose the De Waal 2021 registry mismatch.
   - Add to Limitations that disagreement with a published label may partly reflect outcome mismatch.
5. Run the full verification against `120b332`. Append "Round 3" to `analysis/round14-report.md`. Do not commit.
