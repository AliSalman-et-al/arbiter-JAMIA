# WP-A round 2 (queued until WP-A round 1 has been reviewed)

Scope rule from the authors: add only what serves the story in ANALYSIS-PLAN section 7. Do not over-build. Every addition lives in the supplement unless this file says otherwise.

## From the landscape review (Q42, pruned by the orchestrator)

1. **Estimand wording.** Every title, legend, footnote and results sentence for the primary endpoint reads as a *preferred* share among adjudicated disagreement cells. Never "accuracy" or "correct".
2. **Composite split (supplement).** In the existing composite eTable, add two rows per arm:
   - cells scored against the adjudicators' agreed choice
   - cells that kept the published label

   Give counts and agreement for each. No new estimand.
3. **Independent-rating paired difference (Table 2).**
   - Add one row per adjudicator: agreement of their independent rating with ARBITER, minus agreement with Unassisted, on the 154 disputed cells, with the trial-cluster bootstrap CI.
   - Footnote: the rating was made and frozen before the adjudicator saw any label.
4. **How the question 5.1 errors arose (supplement; one Results sentence).** Use the cells in Fig 6 where the unassisted model lost on question 5.1. For each, record descriptively:
   - whether a registry record, protocol or SAP was among that trial's inputs
   - whether the unassisted model's justification mentions the registry, protocol or SAP
   - the unassisted answer against the adjudicators' answer

   Counts only, no inference. The source is each arm's justification text in its signalling-answers file.
5. **Label-target match (Methods sentence).** Confirm from `rob2-meta-benchmark-set/LABEL-TARGETS.csv` and its README how each published label was tied to an outcome or result. State in eMethods how this matching was done. If any published labels are not result-specific, count them.
6. **Dates (Methods and Limitations text; no stratified analysis).**
   - Report the range of trial publication years and source-review publication dates (2025–2026).
   - State the model's documented training cut-off if Anthropic publishes one, or say that none is published.
7. **Cost and time labels.** "System runtime (min/trial)" and "API list-price equivalent (US$/trial)". A footnote states that the runs used a subscription. The eMethods give the formula and rates.
8. **TRIPOD-LLM.** Map every item to a manuscript or supplement location, or a justified N/A.

Dropped as overbuilding: a date-stratified contamination analysis, further rule-break classes beyond Table 3, and the tamper test.

## From the WP-T review (`docs/round14/REVIEW.md`)

9. Table 4 changes:
   - Rename the input-parity column to "Registry or protocol given to the model". Footnote: only this study gave both compared arms identical inputs. Re-check each cell against the new definition.
   - Define "Partly" for each column in the notes.
   - Keep "Not reported" separate from "No".
   - Add a footnote separating structured prompting from rules that are enforced.
   - Add a RobotReviewer row (Marshall 2016, *JAMIA*; RoB 1), verified from full text the same way as the other rows.

## Fig 1 wording (flag only; protected)

Do not edit Figure 1. List in the report every Figure 1 or 2 label that conflicts with the wording rules in ANALYSIS-PLAN section 7, such as "Store an unchangeable copy", so the authors can approve each change.
