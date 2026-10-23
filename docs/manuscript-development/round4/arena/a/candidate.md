# ARBITER: an inspectable RoB 2 workflow evaluated against a same-model minimal-prompt comparator

## Abstract

### Objective

To evaluate an inspectable RoB 2 workflow against the same model given minimal instructions.

### Materials and Methods

ARBITER retains sources, evidence and signalling answers and applies decision rules in software. Its Sonnet workflow and a same-model minimal-prompt comparator (Unassisted) assessed identical supplied documents for 102 trials from 16 reviews. Two experts independently rated 510 trial–domain assessments before choosing among blinded labels. The primary endpoint was label matching among agreed expert choices where workflows disagreed; independent agreement was secondary. Paired intervals resampled trials within fixed reviews.

### Results

Among 80 workflow disagreements, experts agreed on 60 label choices and split on 20. ARBITER matched 53/60 agreed choices (88%; 95% CI, 80–96%). Independent agreement was 371/510 (72.7%) versus 332/510 (65.1%) against Expert 1 and 433/510 (84.9%) versus 400/510 (78.4%) against Expert 2. Paired gains were 7.6 percentage points (95% CI, 5.1–10.2) and 6.5 (3.5–9.4). Against published labels, ARBITER minus Unassisted agreement was −1.8 points (−5.1 to 1.6). All 510 ARBITER domain outputs conformed to executable rules. Source checks did not assess whether evidence supported answers. Median computational runtime was 7.6 versus 0.5 minutes per trial.

### Discussion

Agreement depended on domain and reference. The complete-workflow comparison cannot isolate effects of instructions, tools or computation, or establish reviewer benefit.

### Conclusion

ARBITER retained an inspectable assessment pathway and agreed more often with both independent experts in this benchmark.

## Introduction

### Background and significance

AI-assisted RoB 2 assessment combines interpretation of trial evidence with application of decision rules.[1] An assessment can follow those rules yet rest on an unsupported interpretation. Conversely, disagreement with a published judgment may reflect differences in the assessment target or human reference. Evaluating a specified workflow therefore requires examining both its judgments and the record from which they were derived.

Evidence-linked and structured assessment already have substantial precedent. RobotReviewer coupled judgments with supporting sentences for the earlier Cochrane instrument and evaluated their relevance separately.[5] For RoB 2, ROBOTO2 allows reviewers to inspect and edit retrieved evidence, answers and judgments,[6] while RoBGuard combines question reformulation, multimodal document parsing and collaboration among model roles.[Ji et al., 2025, https://aclanthology.org/2025.coling-main.84/] Structured prompts have been compared with human RoB 2 assessments,[7,8] and same-model comparisons of direct and constrained prompts have been studied with the earlier instrument.[9] These studies establish relevant alternatives without determining the performance of another implementation or the effects of its individual components.

ARBITER retains supplied documents, quoted evidence, signalling answers and rating decisions. The model interprets the evidence; software computes proposed ratings from its answers. This separation makes the route to a rating inspectable, while leaving the interpretation open to challenge. We compared the complete workflow with the same model given minimal instructions and identical supplied trial documents. Holding the model and documents constant makes the contrast informative about these two ways of organizing assessment, although instructions, tools and computation remain bundled. Independent expert ratings and subsequent blinded label choices address different questions about their outputs.

### Objective

We evaluated ARBITER's inspectable implementation and its complete Sonnet workflow against a same-model minimal-prompt comparator, Unassisted. The primary endpoint concerned agreed expert label choices where the workflows differed. Secondary and supporting outcomes assessed agreement with independent expert ratings across all 510 trial–domain assessments, algorithm conformance, source records and computation.

## Discussion

ARBITER's complete workflow agreed more often with both independent experts than Unassisted, while retaining the evidence and decisions behind its outputs. The formal primary result concerned a narrower population: of 80 arm-discordant assessments, experts agreed on 60 blinded label choices and split on 20. ARBITER matched 53/60 agreed choices (88%; 95% CI, 80–96%). Because experts saw labels without source identities or rationales, this result measures label matching in a selected subset, not endorsement of ARBITER or its reasoning. The secondary comparisons across all 510 assessments used independent ratings frozen before label exposure and provide the broader evidence of an agreement advantage.

That advantage was neither uniform nor reference-independent. Selection of the reported result (D5) had the largest observed domain-rating gains, whereas missing outcome data (D3) showed marked disagreement between experts. Against Expert 1, the paired D3 signalling-answer contrast favored Unassisted with five-level coding, −10.3 percentage points (95% CI, −17.2 to −3.2), but favored ARBITER after combining probable with definite answers, +8.5 (3.5–13.7). Collapse changes the distinction being measured and does not remove the unfavorable five-level finding. The smaller collapsed D5 contrast against Expert 2, +3.7 points (−0.3 to 7.4), also qualifies a uniform account of improvement. These patterns do not identify which interpretations or workflow components produced the differences.

The Published comparison further limits the claim. ARBITER minus Unassisted agreement was −1.8 percentage points (95% CI, −5.1 to 1.6), compatible with either direction. Published labels were predominantly Low, and some concerned broader, inferred or different assessment targets. Such differences are possible explanations rather than established causes. Prior RoB 2 evaluations comparing published assessments with fresh reviewer or panel judgments also make reference construction consequential.[7,8] Here, the experts' disagreement and unequal access to additional sources preclude treating either as an error-free standard. Intervals for individual estimates do not test differences between domains or references.

The implementation offers a record in which those disagreements can be examined. Quotations are extracted from stored documents and linked to source locations; the recorded signalling answers determine a proposed rating through software. A different adopted rating requires evidence and a rationale. All 510 adopted ARBITER domain outputs conformed to the algorithms, with no recorded overrides. That observed conformance is distinct from the software's determination of proposed ratings. Choi and colleagues likewise examined expert agreement and answer-to-rating conformance, but with repeated assessments of a single trial.[18] LogiMed-RoB audits logical consistency across the RoB 2 hierarchy; its evidence-faithfulness track uses RoB 1 and should be distinguished from its RoB 2 logic track.[Huang et al., 2026, arXiv:2609.11185v1, https://arxiv.org/abs/2609.11185] These studies support evaluating consistency explicitly, without making consistency equivalent to a defensible interpretation.

ARBITER's source checks established that quotations and image records were bound to stored sources, not that those sources justified the linked answers. Image descriptions also remained model-written. Liang and colleagues evaluated evidence support separately by retrieving trial passages and using another model to classify support for generated RoB 2 claims.[16; https://ai.jmir.org/2026/1/e93761] Their verifier provides a model-based assessment rather than independent human adjudication. For ARBITER, the next evidence-level evaluation should examine whether each passage or image supports its recorded answer. The retained record makes that evaluation possible; the present structural checks do not supply its result.

The comparator also defines the scope of inference. Minimal prompting is one baseline, rather than a proxy for the structured RoB 2 workflows already evaluated.[6–8] Rule-constrained assessment is also represented by the RoB2-Evaluator preprint.[17] ARBITER received additional instructions, tools and computation, so the observed difference cannot be attributed to its rules, evidence records or any other component. Rules-only recomputation describes internal consistency but cannot recover those component effects. With one run per trial per arm, the benchmark also does not establish repeatability.

Generalization is bounded by ordered, availability-dependent trial selection, 16 fixed reviews and two experts. The bootstrap quantifies trial variation within those reviews, conditional on the observed experts and runs. Prior model exposure to trial reports is unknown, and experts could consult sources beyond the arms' inputs. The unrelated De Waal registry record shows why source identity requires checking even when inputs are shared. Offered labels could influence subsequent choices and revised ratings; derived Overall ratings reuse domain assessments and add no independent confirmation. The evaluated revision and installable public release remain distinct: documented correspondence of assessment commands does not establish equivalence of the complete releases.

Practical value requires observation of reviewers using the workflow. Soboczenski and colleagues randomized manual and RobotReviewer-assisted tasks and measured reviewer time and corrections using four domains of the earlier Cochrane instrument.[Soboczenski et al., 2019, doi:10.1186/s12911-019-0814-z] Jardim and colleagues observed use in ongoing reviews, including consultation of original reports, but lacked a manual-only comparison.[19] These designs distinguish output evaluation from evaluation of assistance in practice. ARBITER required longer computational runtime and higher API list-price equivalents; neither measures reviewer time. Whether its records help reviewers detect unsupported interpretations, how long verification takes and how suggestions affect final judgments require direct study, without treating acceptance or correction rates as semantic validation.

### Conclusion

In this single-run benchmark, ARBITER's complete workflow had greater agreement with both independent experts than a same-model minimal-prompt comparator, with domain and reference dependence. Its retained sources, signalling answers, cited evidence and rating decisions make the assessment pathway inspectable, including the interpretations that remain open to disagreement.
