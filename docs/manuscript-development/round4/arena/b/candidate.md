# ARBITER: an inspectable RoB 2 workflow compared with same-model minimal prompting

## Abstract

### Objective

To present ARBITER, an inspectable workflow for the Cochrane risk-of-bias tool for randomised trials (RoB 2), and compare its judgments with same-model minimal prompting.

### Materials and Methods

ARBITER retains sources, evidence and signalling answers and applies decision rules in software. Its Sonnet workflow and a minimal-prompt comparator (Unassisted) assessed identical supplied documents for 102 trials from 16 reviews. Two experts independently rated 510 trial–domain assessments before choosing among blinded labels. The primary endpoint measured agreed label choices matching ARBITER where workflows disagreed. Independent expert agreement was secondary. Paired intervals resampled trials within fixed reviews.

### Results

Among 80 workflow disagreements, experts agreed on 60 label choices and split on 20; 53/60 agreed choices matched ARBITER (88%; 95% CI, 80–96%). Exact agreement was 72.7% versus 65.1% against Expert 1 and 84.9% versus 78.4% against Expert 2. Paired gains were 7.6 percentage points (95% CI, 5.1–10.2) and 6.5 (3.5–9.4). Against published labels, the difference was −1.8 points (−5.1 to 1.6). All 510 ARBITER domain outputs followed executable rules. Structural checks did not assess evidence support. Median runtime was 7.6 versus 0.5 minutes per trial.

### Discussion

Label matching does not endorse ARBITER's reasoning. Agreement varied by domain and reference. The complete-workflow comparison cannot isolate component effects or establish reviewer benefit.

### Conclusion

ARBITER preserved an inspectable assessment pathway and agreed more often with both independent experts in this single-run benchmark.

## Introduction

### Background and significance

AI-assisted RoB 2 assessment requires both interpretation of trial evidence and consistent application of the decision rules.[1] An assessment record can expose how a judgment was reached, but its interpretive quality remains an empirical question. RoB 2 reliability studies have documented disagreement and application difficulties; review-specific instructions and calibration were followed by improved agreement in one setting.[2,3] Work with the earlier Cochrane instrument also identified different interpretations of the same information across reviews.[4] These findings make the reference assessment and the basis of each judgment material to evaluating an automated workflow.

Existing systems already make evidence and intermediate decisions available for review. RobotReviewer paired judgments with supporting sentences for the earlier instrument and evaluated text relevance separately from classification.[5] ROBOTO2 provides an interactive RoB 2 workflow with retrieved evidence and editable answers and judgments.[6] RoBGuard combines question reformulation, multimodal document parsing and collaboration among model roles for RoB 2 assessment (Ji et al., 2025; https://aclanthology.org/2025.coling-main.84/). Structured RoB 2 prompting has been compared with human assessments,[7,8] and same-model comparisons of direct and constrained prompts have been studied with the earlier instrument.[9] These precedents support evaluating what a specified implementation adds under a defined comparison.

ARBITER retains trial documents, cited evidence, signalling answers and rating decisions. The model interprets the evidence; software derives proposed ratings from the recorded answers. Comparing this complete workflow with minimal prompting of the same model, using identical supplied documents, holds the model and documentary inputs constant while allowing instructions, tools and processing to differ. Independent expert ratings, blinded label choices and process audits then address distinct aspects of its output.

### Objective

We evaluated ARBITER's inspectable implementation and its complete-workflow comparison with same-model minimal prompting. The formal primary endpoint concerned agreed blinded label choices among arm-discordant assessments. Secondary and supporting outcomes examined independent expert agreement across all assessments, rule conformance, source records and computation.

## Discussion

ARBITER retained an inspectable assessment pathway and had greater agreement with both independent experts than Unassisted across the 510 trial–domain assessments. These secondary comparisons used ratings frozen before experts saw offered labels. The formal primary endpoint concerned a selected subset: among 80 arm-discordant assessments, experts agreed on 60 blinded label choices and split on 20; 53/60 agreed choices matched ARBITER (88%; 95% CI, 80–96%). Because experts saw labels without source identities or rationales, this result measures conditional label matching. It does not establish endorsement of ARBITER or its reasoning. The independent ratings provide the broader agreement comparison.

That agreement advantage was not uniform. Selection of the reported result (D5) had the largest observed domain-rating gains, whereas missing outcome data (D3) showed marked reference dependence. For D3 signalling answers against Expert 1, the paired ARBITER minus Unassisted difference was unfavorable with five-level coding, −10.3 percentage points (95% CI, −17.2 to −3.2), and favorable with collapsed coding, +8.5 (3.5–13.7). Combining probable with definite answers changes the distinctions being assessed; the favorable collapsed estimate does not remove the adverse five-level finding. The D5 collapsed contrast against Expert 2 was also smaller, +3.7 points (−0.3 to 7.4). Neither pattern identifies why the experts or workflows differed, and intervals for individual estimates do not test differences between domains.

The reference also changed the overall interpretation. Against Published labels, the paired difference was −1.8 percentage points (95% CI, −5.1 to 1.6), compatible with either direction. Published labels were predominantly Low, and some covered broader, inferred or different assessment targets. These differences qualify their use as a reference without establishing the cause of disagreement. Huang and Gandhi likewise evaluated model assessments against both review-derived and fresh human references,[7,8] while Nyrhi used published assessments in separate RoB 1 and RoB 2 corpora.[10] Those designs do not supply interchangeable standards. Our experts could consult sources beyond the arms' inputs, and their own disagreement, especially in D3, precludes treating fresh ratings as error-free truth.

The retained record allows these interpretations to be examined. In the illustrative AVATAR assessment, stored documents did not establish a dated analysis plan for the assessed result; the answers and cited passages preserve the basis for that judgment. ARBITER binds text quotations and image regions to stored sources and records their locations. Software computes proposed ratings, while a different adopted rating requires evidence and a rationale. All 510 adopted domain outputs conformed to the executable rules, and no domain overrides occurred. This observed conformance concerns the transition from recorded answers to ratings. It leaves the appropriateness of those answers open to assessment.

Conformance is already an explicit evaluation target in related work. Choi and colleagues examined expert agreement, rule conformance and repeated outputs in a single-trial pilot.[18] Their questions overlap with ours, but their repeated single-trial design and this multi-trial, single-run comparison address different sources of variation. LogiMed-RoB audits hierarchical consistency in a RoB 2 track and evidential faithfulness in a separate RoB 1 track (Huang et al., 2026, arXiv:2609.11185v1; https://arxiv.org/abs/2609.11185). Its evidence track should not be read as RoB 2 semantic validation. ARBITER's source checks likewise establish source binding and record integrity without determining whether passages justify answers; image descriptions remained model-written. Liang's RoB 2 retrieve-then-verify study addresses evidence support using a judge model, rather than independent human adjudication.[16] Independent assessment of each passage-to-answer relation, including image-derived interpretations, remains necessary to evaluate that property in ARBITER.

The observed differences belong to the complete workflows. Identical supplied trial documents and the same model make the comparison informative, but ARBITER also received additional guidance, tools and computation. The study cannot attribute its agreement advantage to rule enforcement, evidence recording or another component. Minimal prompting also does not represent the structured alternatives already evaluated.[6–9] RoB2-Evaluator, described in a preprint, is another rule-constrained RoB 2 implementation.[17] ARBITER required greater computation: median runtime was 7.6 versus 0.5 minutes per trial, with higher API list-price equivalents. These quantities describe computational burden; the subscription-based runs did not incur those reconstructed list-price amounts as expenditure.

Generalization is bounded by ordered, availability-dependent trial selection, 16 fixed reviews, two experts and one run per trial per arm. Bootstrap intervals describe trial variation within those reviews, conditional on the observed experts and runs. They do not quantify variation across new reviews, assessors or repeated runs. Prior model exposure to reports is unknown. Offered labels could influence forced choices and revised ratings, despite source blinding. Results pertain to the evaluated software revision; documented assessment-command correspondence does not establish equivalence with the complete public release.

Reviewer use requires a separate evaluation. Soboczenski and colleagues randomized manual and RobotReviewer-assisted tasks using four domains of the earlier instrument, directly observing assessment time and reviewer behavior (2019; doi:10.1186/s12911-019-0814-z). Jardim's study in ongoing reviews found mixed acceptability and lacked a manual-only time comparison.[19] These studies show why output agreement, checking time and adoption merit separate outcomes. They do not establish benefit for ARBITER. A reviewer study should examine whether users detect unsupported interpretations, how long verification takes and how suggestions affect their final judgments. ARBITER's computational runtime cannot answer those questions.

### Conclusion

ARBITER preserves the pathway from supplied sources through signalling answers to RoB 2 rating decisions. Its complete workflow agreed more often with both independent experts than same-model minimal prompting, with domain and reference dependence. The retained record supports inspection; evidence support and benefit during reviewer use remain to be evaluated.
