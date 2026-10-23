## Abstract

### Objective

To present an inspectable workflow for the Cochrane risk-of-bias tool for randomised trials (RoB 2) and evaluate its judgments against independent experts.

### Materials and Methods

ARBITER retains sources, evidence and signalling answers, then applies RoB 2 decision rules in software. We compared its Sonnet workflow with a same-model minimal-prompt comparator using identical supplied documents for 102 trials from 16 reviews. Two experts independently rated 510 trial–domain assessments before choosing among blinded labels. The formal primary endpoint was ARBITER preference where workflows disagreed and both experts chose the same label. All-cell agreement was secondary. Paired intervals resampled trials within fixed reviews.

### Results

ARBITER received 53/60 agreed choices (88%; 95% CI, 80–96%), from 80 workflow disagreements with 20 split choices. Exact agreement was 371/510 versus 332/510 against Expert 1 and 433/510 versus 400/510 against Expert 2. Paired gains were 7.6 percentage points (95% CI, 5.1–10.2) and 6.5 (3.5–9.4). Published-label agreement differed by −1.8 points (−5.1 to 1.6). All 510 ARBITER domain outputs followed executable rules. Structural checks did not assess whether evidence supported the answers. Median runtime was 7.6 versus 0.5 minutes per trial.

### Discussion

Agreement varied by domain and reference. Instructions, tools and computation differed between workflows; the comparison does not isolate component effects or measure reviewer benefit.

### Conclusion

ARBITER preserves an inspectable assessment pathway and had greater agreement with both independent experts in this benchmark.

## Background and significance

A risk-of-bias judgment is a conclusion about a particular trial result. To examine that conclusion, a reviewer needs to follow the supporting evidence through the assessment. The Cochrane risk-of-bias tool for randomised trials (RoB 2) makes this pathway explicit through signalling questions and algorithms that translate answers into domain judgments.[1] Interpretation remains necessary at each question. Experienced assessors have reported application difficulties and disagreement; condition-specific implementation instructions and calibration were followed by improved agreement in one review setting.[2–3] Studies using the earlier Cochrane instrument also found different interpretations of the same trial information across reviews.[4] For AI-assisted assessment, the relevant problem is therefore how to preserve a judgment's basis while evaluating the judgment itself.

Earlier systems establish that evidence display and structured assessment are practical approaches to this problem. RobotReviewer paired automated judgments with extracted supporting sentences for the earlier instrument.[8] ROBOTO2 extends evidence-linked assessment to an interactive RoB 2 workflow in which reviewers can inspect and change proposed answers and judgments.[9] Structured RoB 2 prompting has also been evaluated against human assessments, including checks of whether domain ratings follow from signalling answers.[10–11] These approaches make different parts of an assessment available for examination. Their existence shifts the evaluation question toward the properties and performance of a specified implementation.

Three properties require separate assessment. A source link establishes where quoted text occurs; it does not establish that the text supports the answer. Applying the decision rules establishes how recorded answers produce a rating; it does not establish that those answers are appropriate. Agreement then depends on the human reference, as studies using published labels and fresh assessments illustrate.[10–11,13] ARBITER preserves the source-to-answer-to-rating pathway and evaluates its complete workflow in a paired, same-model benchmark. This design connects an inspectable implementation to measured agreement without treating either as proof of the other.

## Objective

We evaluated what ARBITER makes inspectable and how its complete Sonnet workflow compares with the same model given minimal instructions and identical supplied trial evidence. Outcomes comprised conditional expert preference as the formal primary endpoint, secondary agreement with each independent expert across all domains, procedural checks and computational burden.

## Discussion

ARBITER preserved the evidence and decisions behind each assessment and agreed more often with both independent experts than the same-model minimal-prompt comparator, Unassisted. Across all 510 trial–domain assessments, agreement was 371/510 versus 332/510 against Expert 1 and 433/510 versus 400/510 against Expert 2. The paired gains of 7.6 percentage points (95% CI, 5.1–10.2) and 6.5 (3.5–9.4) describe the magnitude of the difference across the full cohort. These secondary comparisons used independent ratings frozen before experts saw the offered labels.

The formal primary endpoint answered a narrower question about disputed ratings. Among 80 assessments in which the workflows differed, both experts chose the same blinded label in 60 and split in 20. ARBITER matched the agreed choice in 53/60 (88%; 95% CI, 80–96%). This measures conditional label preference, not endorsement of ARBITER's reasoning: experts saw labels without source identities or rationales. The all-cell comparisons provide the broader context for interpreting that preference.

The retained record makes the route to a rating examinable. For selection of the reported result, a reviewer can inspect the signalling answers and their cited passages to ask whether the stored documents establish a dated analysis plan for the assessed result. The AVATAR illustration shows this distinction concretely: the stored documents did not establish a dated analysis plan for the result under assessment. ARBITER copies quotations directly from stored documents, links them to source locations and applies the decision rules to the recorded answers. Departures from a proposed rating require a recorded rationale and evidence. Proposed and adopted ratings are checked separately; no domain overrides were recorded in this benchmark.

All 510 ARBITER domain outputs followed the executable rules, but the quoted evidence still requires interpretation. The source checks established the integrity of the links and exported records, not whether each passage justified its answer; image descriptions also remained model-written. Liang and colleagues addressed evidence support as a separate outcome in RoB 2 assessment by retrieving trial passages and using another model to classify support for generated claims.[DOI:10.2196/93761] Their automated verification is an evaluation approach rather than independent human adjudication. It identifies a directly relevant task for ARBITER's next evaluation: checking whether the recorded evidence supports the interpretation attached to it.

The comparison estimates the difference between complete workflows. Both used the same model and supplied trial evidence, but ARBITER received additional guidance, tools and computation. The observed gains cannot be assigned to its decision rules, evidence records or another component, and minimal prompting does not represent the structured alternatives already studied.[9–11] RoB2-Evaluator, described in a recent preprint, is another rule-constrained RoB 2 implementation.[24] Choi and colleagues separately examined repeated outputs and algorithm conformance in a single-trial pilot.[16] Their design and this multi-trial, single-run benchmark address complementary questions; ARBITER's results do not establish repeatability.

Domain findings limit a uniform account of the agreement advantage. Selection of the reported result had the largest observed gains, whereas missing outcome data (D3) yielded agreement of 43/102 with Expert 1 and 80/102 with Expert 2. For D3 signalling answers against Expert 1, the paired difference was unfavorable with five-level coding, −10.3 points (95% CI, −17.2 to −3.2), but favorable after combining probable with definite answers, +8.5 (3.5–13.7). Collapsing categories changes the question being measured and does not remove the unfavorable result. Rules-only recomputation likewise describes consistency, without identifying which component caused the agreement differences.

Agreement with Published labels showed a different pattern: the paired difference was −1.8 points (95% CI, −5.1 to 1.6). Published labels were predominantly Low, and some assessment targets were broader, inferred or different from those evaluated here. Target differences and judgment thresholds are possible explanations, not established causes. The separate expert estimates and D3 disagreements also show why fresh assessments cannot be treated as an error-free standard. Intervals on individual estimates do not test differences between domains or references.

Generalization is bounded by ordered, availability-dependent trial selection, 16 fixed reviews, two experts and one run per arm. The bootstrap quantifies trial variation within those reviews, conditional on the experts and observed runs. Experts could consult additional sources, and prior model exposure to trial reports is unknown. The unrelated De Waal registry record illustrates the importance of checking supplied sources. Offered labels could influence forced choices and revised ratings; derived Overall ratings reuse the domain assessments and provide no independent confirmation.

Human use remains a separate empirical question. In Jardim and colleagues' study of RobotReviewer in ongoing reviews using the earlier instrument, reviewers used snippets to locate material and checked the original report when needed.[DOI:10.1186/s12874-022-01649-y] That study lacked a manual-only comparison and could not estimate time savings. ARBITER's longer runtime and higher list-price equivalents quantify computation, not reviewer workload. Whether its records help reviewers identify unsupported interpretations, how long checking takes and whether reviewers accept inappropriate suggestions require direct observation of reviewers using the workflow.

## Conclusion

ARBITER makes the pathway from source evidence through signalling answers to RoB 2 ratings inspectable. Its complete workflow had greater agreement with both independent experts than a same-model minimal-prompt comparator, with important domain and reference dependence. The available implementation preserves the evidence and decisions needed to examine individual judgments alongside these agreement results.
