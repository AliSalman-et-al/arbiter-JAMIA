# Concrete revision proposals

These are proposed edits, not applied changes. Preserve existing numerical citations and traceability during implementation.

## Introduction: specify the unknown

“For ARBITER, the empirical question is whether the complete workflow agrees more often with independent experts than the same model given a minimal prompt and identical supplied trial documents, and where disagreement remains.”

## Abstract: identify the observation

“The primary endpoint was the proportion of agreed expert choices matching ARBITER among cells where the two workflows disagreed; agreement across all 510 cells was secondary.”

“Among 80 cells where the workflows disagreed, experts selected the same label in 60 and split in 20. The agreed label matched ARBITER in 53/60 (88%; 95% CI, 80–96%).”

“Against published labels, ARBITER minus Unassisted agreement was −1.8 percentage points (95% CI, −5.1 to 1.6).”

Recheck the complete abstract's word count after insertion; these are replacements, not sentences to append indiscriminately.

## System design: capability and evaluated use

“In interactive use, a reviewer can approve the proposed result before domain assessment; in this benchmark, the harness accepted the proposal unchanged.”

## Benchmark: target correspondence

“We specified the assessed result using the review's reported outcome and available trial information. Correspondence to the published risk-of-bias label could be partial, inferred or indeterminate.”

Check this wording against the supplied target instructions. Do not turn ledger categories into new performance subgroups.

## Experts: truthful cross-reference now, factual completion later

“eMethods summarizes the assessment sequence; completed assessment records are available in the study repository.”

Replace this with a precise form/instruction link when those materials are supplied. Add actual qualifications, training, target instructions and guidance from records. A completed workbook alone does not establish the instructions given.

## Analysis hierarchy

“The formal primary endpoint was conditional agreement of expert label choices with ARBITER; other outcomes were secondary or exploratory as indicated.”

This replaces the unsupported confirmatory designation, not the endpoint. Retain the existing bootstrap specification and limitations.

## Methods completion slots

Document, without guessing:

- How the 16 reviews were identified and selected, and the eligibility/design exclusions.
- How each prompt and assessment skill was developed and selected, which data informed development, and what freeze records exist.
- Whether experts received the same specified target brief as the arms and how multiple outcomes were handled.
- The meaning of an outcome-specific signalling-answer component, separately from the directly recorded domain judgment.

Until completed, mark the affected reporting-map entries partial rather than reported.

## Process checks

Use observed zero counts in the table. A note can state: “Software computes proposed ratings from recorded answers. Adopted ratings were checked separately; no domain overrides occurred in this benchmark.”

Do not silently change statistical exports to implement a wording repair. Update the display-generation source and verify numerical parity.

## Literature: targeted additions

Suggested Choi sentence: “A recent RoB 2 pilot examined repeated-assessment variability and conformance between signalling answers and domain judgments using one trial and one expert reference. Our benchmark addresses a complementary question through one run per arm across multiple trials and two independent expert assessments.”

Suggested evidence-support sentence: “RoB-specific studies have evaluated the relevance or documentary support of generated explanations separately from label agreement.” Cite Armijo-Olivo and/or Liang, with a brief qualification that Liang used retrieval and an LLM verifier if its results are discussed. Do not compare their percentages with ARBITER's structural audit.

## Conclusion

“Within this benchmark, ARBITER agreed more often with both independent experts than a same-model minimal-prompt comparator, with domain and reference dependence qualifying the advantage. Its available workflow preserves the sources, answers and decisions behind each assessment, making the basis of a judgment open to inspection.”

## Revision gate

After implementation: recheck claim/citation fit, numerical traceability, abstract/body limits, display parity and all changed Word pages. Run the actual publishing path exercised; state any production path not run. Do not describe the manuscript as submission complete while required author declarations remain pending.
