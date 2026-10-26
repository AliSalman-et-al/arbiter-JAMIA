# Evidence record for the supplement reduction

Scope is the 26 October 2026 author-directed reduction and neutral human-review labels. Existing literature assertions are unchanged. Their recorded source identities, exact numerical spans and access limits remain in docs/manuscript-development/round6/external-facts.tsv. This revision adds no external empirical claim.

## Sources

- S1 is the complete earlier release at Git revision 54645d75e7a8b32bbf09968893e7be45faa4cab4. It owns the earlier calculations and reporting inventory.
- S2 is ANALYSIS-PLAN.md, amended after analysis with author approval. It records the retained scope and omitted families without claiming prospective specification.
- S3 is the original pair of human-adjudication workbooks and the source arm labels/answers. These files remain unchanged.
- S4 is the current analysis/output/tables CSV set. It owns the retained estimates, denominators and uncertainty.
- S5 is analysis/figure1/build.py and the captured AVATAR assessment. Its assertions establish that both later D5 choices match Some concerns while Published D5 is Low. This is separate from the derived Overall comparison.
- S6 is docs/analysis-simplification.md. It records the three independent content-defense reviews, synthesis, reversals of proposed cuts and final dispositions.

## Claims and results checked

| Claim | Source and identity | Qualification |
|---|---|---|
| Published agreement is 386/510 versus 395/510, paired difference -1.8 points | S4 agreement-meta.csv and agreement-meta-differences.csv, D1-D5, accuracy | No clear advantage; retain its interval and All-Low context. |
| Human Review 1 agreement is 371/510 versus 332/510, gain 7.6 points | S4 independent-estimates.csv and independent-differences.csv, adjudicator 1, D1-D5, accuracy | Frozen independent ratings; paired trial bootstrap. |
| Human Review 2 agreement is 433/510 versus 400/510, gain 6.5 points | Same files, adjudicator 2 | A separate reference, not another sample of reviewers. |
| The human assessments agree on 388/510 cells | S4 expert-reliability.csv, D1-D5, accuracy | Neither is established as error-free. |
| Conditional choices match ARBITER on 53/60 agreed choices from 80 disagreements, with 20 splits | S4 primary-endpoint.csv and adjudication-analysis-cells.csv | Post-label-exposure choice, not full-cohort accuracy or endorsement of reasoning. |
| D3's paired answer contrast changes direction with coding | S4 signalling-differences.csv, group D3, adjudicator 1, both levels, n=165 | Five-level and collapsed coding estimate different agreement quantities. |
| Q4.1 five-level contrasts are unfavorable against both human reviews while collapsed contrasts are zero | Same file, group 4.1, adjudicators 1/2, paired n=101/102 | Complete paired question results remain available, including sparse rows. |
| Derived Overall agreement is lower and reference-dependent | S4 independent-estimates.csv, Overall, All trials; expert-reliability.csv | Worst independent domain rating, no optional escalation imposed; not directly rated expert Overall. |
| Repairing 26 contradictory Unassisted labels does not close the expert-agreement gap | S4 rules-only-changed.csv and rules-only-agreement.csv, pooled separate references | Counts become 324/510 and 391/510; post hoc arithmetic check, not causal ablation. |
| Rule/source checks establish conformity and structural properties | S4 table3.csv, audit-summary.csv and bundle-domain-checks.csv | Distinct objects and denominators; evidence support remains untested. |
| Runtime and API equivalents describe computation | S4 table5.csv, api-cost-summary.csv and api-token-reconciliation.csv | Medians/IQRs versus paired means; reconstructed prices are not expenditure or reviewer time. |

The prior IMRaD number audit was removed with the article draft. Current retained counts are reconciled by analysis/verify-output.R, and table presentation is checked by docs/manuscript/verify-presentation.py. Retained numerical rows, including their full scientific identifiers and intervals, must match S1 under scripts/verify-reduction.py. That script also checks source-input identity and its changed-value, swapped-identity and duplicate-row controls. Updated reporting-checklist locators are metadata, checked separately from numerical identity.

The selection inventory accounts for omitted families. Important adverse diagnostics remain in the current supplement. Full AVATAR answer and evidence records remain directly linked. Peripheral retired code and outputs remain recoverable from S1.

## Scope limits

These checks assess traceability, preservation and publication consistency. They do not validate semantic evidence support, isolate component effects, establish reviewer benefit or supply missing author qualifications/declarations. Those limits remain explicit in the manuscript. Final build, visual and deployment results are recorded in review.md.
