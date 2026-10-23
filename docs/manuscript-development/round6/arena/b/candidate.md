# ARBITER: an evidence-linked workflow for AI-assisted risk-of-bias assessment

## Front-matter notes

Article type: Research and Applications. Main displays comprise five figures and three tables.

Author: Ali Salman, MBBS. Affiliations: [Department, institution, city and country]. Correspondence: [Postal address, email and telephone]. [Confirm complete author list and order].

Keywords: artificial intelligence; risk of bias; evidence synthesis; reproducibility; clinical trials.

Word counts: see candidate-specific counts in rationale.md; final journal counts remain to be generated.

## Abstract

### Objective

To evaluate whether an evidence-linked RoB 2 workflow improves agreement over same-model minimal prompting while preserving an inspectable assessment pathway.

### Materials and Methods

ARBITER records sources, selected evidence and signalling answers; software derives proposed ratings. ARBITER and minimal prompting (Unassisted) assessed identical supplied documents for 102 trials from 16 reviews. We compared published labels, independent expert ratings and conditional blinded label choices. Paired intervals resampled trials within fixed reviews.

### Results

Against published labels, ARBITER minus Unassisted exact agreement was −1.8 percentage points (95% CI, −5.1 to 1.6). Agreement with Expert 1 was 371/510 (72.7%) versus 332/510 (65.1%), a gain of 7.6 points (95% CI, 5.1–10.2); with Expert 2, it was 433/510 (84.9%) versus 400/510 (78.4%), a gain of 6.5 (3.5–9.4). Among 80 workflow disagreements, experts agreed on 60 blinded choices and split on 20; 53/60 agreed choices matched ARBITER (88%; 95% CI, 80–96%). All 510 adopted ARBITER domain ratings conformed to the decision rules. Median runtime was 7.6 versus 0.5 minutes per trial.

### Discussion

Agreement depended on the reference and domain. Structural source checks did not validate evidence support, and label choices did not evaluate reasoning. The complete-workflow comparison cannot isolate component effects or establish reviewer benefit.

### Conclusion

In this single-run benchmark, ARBITER preserved an inspectable assessment pathway and agreed more often with both independent experts, without a clear published-label agreement advantage.

## Introduction

Risk-of-bias assessment requires reviewers to connect a judgment to the particular trial result and evidence that justify it. RoB 2 formalizes the transition from signalling answers to proposed ratings,[1] but reaching those answers still requires interpretation across reports, registries and supporting documents. In a cross-sectional exercise involving four raters and 70 trial outcomes, overall Fleiss κ was 0.16 (95% CI, 0.08–0.24), and assessment took a mean 28 minutes per outcome.[2] Agreement can also change as teams develop shared conventions. In one multiple-sclerosis review, calibration and review-specific signalling-question instructions preceded an increase in overall κ from −0.15 during calibration to 0.11 for the first five studies assessed with the instructions and 0.42 for the remaining 11.[3] That sequential, single-team evaluation cannot separate instruction effects from discussion, practice or study order. Together, these findings identify interpretation and implementation as consequential parts of appraisal, even with a structured instrument.

Automated assistance must therefore do more than return a plausible rating. The same need recurs as reviews are updated, motivating frameworks that integrate automated review tasks with human oversight.[4] RobotReviewer linked classifications to supporting sentences for the earlier Cochrane instrument and evaluated text relevance separately.[5] More recent workflows combine document parsing, retrieval, signalling answers and editable judgments, as in ROBOTO2,[6] or add multimodal parsing and collaboration among model roles, as in RoBGuard.[7] These capabilities make assessment pathways accessible to computation. They also create distinct questions: Was the source passage retained accurately? Does it justify the answer? Does the rating follow from the answers? Agreement with a final human label cannot resolve all three.

We developed the Agentic Risk of Bias Inference Tool for Evidence Reviews (ARBITER) to preserve this pathway for experienced reviewers. The model selects evidence and interprets it; software applies the decision rules to the recorded answers. To determine how this complete workflow performs relative to minimal prompting, we compared both approaches using the same reported model and identical supplied trial documents. We examined agreement with published review labels, independently recorded expert ratings and subsequent blinded label choices, alongside answer-level variation, rule conformance, source records and computational burden.

## Materials and methods

### Assessment workflow

ARBITER separates evidence interpretation from rating derivation (Figure 1). The model identifies the result, examines documents and answers the signalling questions. Software checks permissible answers, required question paths and evidence references, then computes the proposed domain ratings. An interactive reviewer can approve the proposed target before assessment; our automated harness accepted it unchanged.

To retain the evidential basis, ARBITER stores documents with cryptographic hashes that identify their contents and separately versions extracted page text. Reading and search tools return passage references. The model selects a passage using those references, page/line ranges or copied text as a locator. Copied text must match the captured source; unmatched or ambiguous selections are rejected. The accepted quotation is stored from the actual captured source slice, with its page and character offsets. Thus, the tool constrains fabricated quotation wording within this pathway, while errors in document extraction, incomplete selection and inappropriate interpretation remain possible. Visual evidence instead links a rendered page and selected region to a model-written transcription, which is not independently verified.

Each answer retains evidence and justification, with provision for uncertainty and counterevidence. The algorithm-derived proposal and adopted rating are separate: adopting a different rating requires a rationale and supporting evidence linked to the answers. We checked both. Exported HTML reports and audit files retain the assessment pathway. Runtime text matching, assessment-file verification and our structural source-provenance audit are separate checks; the audit did not re-extract quotations independently or test whether they justified the answers. Figure 2 illustrates the AVATAR assessment of all-cause death after early surgery versus watchful waiting in asymptomatic severe aortic stenosis, with its complete trace in the supplement. This illustrative case did not establish typical performance; its stored documents did not establish a dated analysis plan for the assessed result.

### Benchmark and comparison

We assembled a purposive benchmark spanning 15 medical specialties. The selection team reported searching Europe PMC for 2025–2026 meta-analyses, prioritizing journal standing and citation counts and requiring explicit RoB 2 use with extractable trial-level domain labels. Search and ranking records were not recovered, so neither selection dates nor ranking claims could be verified. Within reviews, we took up to seven obtainable eligible trials in table order, replacing unavailable reports with the next eligible trial and removing duplicates. The source set comprised 105 trials from 16 reviews; three author-designated unsupported designs were excluded, leaving 102. Atwine was author-designated unsupported, but its specific subtype remains unverified and its stored classification is disputed. The supplementary benchmark table documents reviews, specialties and source availability.

Initial targets followed trial-primary outcomes. Before the runs, 43 of 105 targets were revised toward the results underlying published labels. Final prompts specified outcome, comparison, time point and numerical result. Alignment with published labels remained partial, inferred, different or indeterminate for some targets, and some labels covered several outcomes. We retained all domain cells and considered this uncertainty qualitatively.

Both arms received identical underlying trial evidence from the captured input set: articles, supplements, registry copies, protocols and analysis plans, with availability varying by trial. Unassisted received copies of registry records and acquired documents from the ARBITER run rather than newly retrieved versions. The supplied De Waal registry record concerned another trial and could not establish information about the assessed result.

Unassisted received the task sentence and one fixed output-format sentence, without RoB 2 guidance. It could read and search local documents but could not access ARBITER's software service, assessment instructions or the web. ARBITER additionally received packaged workflow instructions and RoB 2 guidance through an assessment skill. This comparison therefore concerned complete workflows, including differences in guidance and computation; it did not isolate component effects or represent the structured-prompt alternatives evaluated elsewhere.[8,9,10]

Both arms used `claude-sonnet-5-5`, medium effort, in Claude Code 2.1.278, with isolated settings, external connectors and memory disabled. ARBITER ran on 12 October 2026 and Unassisted on 14 October 2026, once per trial per arm. An identical immutable model snapshot across dates was not established. The protocol permitted “Continue.” at most twice per phase without coaching. eMethods provides prompts, invocation details and the evaluated software revision. The author confirms that this benchmark was not used in development; recovered development records do not establish an exhaustive exposure history. [Pending: complete prompt and assessment-skill selection history and version-freeze documentation.]

### Expert assessment

Two blinded experts, published researchers from BEACON Lab, independently assessed all five domains for every trial. A trial–domain pair constituted a cell. Each expert recorded and froze signalling answers and domain ratings before seeing offered labels, without AI assistance. Experts received the same trial materials, supplements and ClinicalTrials.gov records as the arms, the same target prompt specifying outcomes, contrasts and numerical anchors, and access to Cochrane guidance. [Pending: individual qualifications and RoB 2 experience, training/calibration and conventions for targets containing several outcomes.]

Subsequently, each expert saw Published, Unassisted and ARBITER labels in an order randomized by cell, without source identities or rationales, and chose the most defensible label. Each then supplied a revised rating, potentially different from all offered labels, and recorded whether answers were retained or changed. We analyzed independent ratings, choices and revised ratings separately; blinded adjudication in data extraction provided a procedural precedent.[11] Completed workbooks are available in the study repository, and eMethods summarizes the sequence. [Pending: original blank assessment form.]

### Outcomes and analysis

We report published-label agreement first, followed by independent-expert agreement, conditional label choices, domain/answer detail and process outcomes. This order was adopted after analysis and does not imply prospective specification or a formal outcome hierarchy.

For Published, we calculated exact agreement and paired percentage-point differences across 510 cells, followed by linearly weighted Cohen's κ, sensitivity for Some concerns or High, and specificity; Gwet's AC2 is supplementary. An All-Low rule described prevalence, with κ suppressed because predictions lacked variance. Missing predictions counted as disagreement. We separately compared each source with each expert's independent ratings using exact agreement, paired differences and weighted κ. Supporting analyses included expert-to-expert agreement, unweighted κ, confusion matrices, expert means and cells where experts agreed.

The conditional label-choice analysis included the cells where the arms differed and both experts chose the same label. Its numerator counted agreed labels matching ARBITER. Credit followed label equality, including credit to multiple sources with the same label or neither arm if neither matched. Identical labels from all sources could not distinguish sources. Sensitivities examined each expert's choices over all arm disagreements and counted split choices as ARBITER losses without assigning Unassisted wins. These outcomes measured label matches, not endorsement of reasoning.

We compared signalling answers with five-level coding (yes, probably yes, no, probably no, no information) and collapsed coding that combined probable and definite answers of the same polarity. Matching used trial, domain, question and explicitly named answer component, such as an outcome; undivided answers formed one component, and different named components were not pooled. Missing, inactive, inapplicable, unmatched and unresolved answers were excluded. Paired contrasts required evaluability in both arms.

We applied official RoB 2 algorithms to each arm's own answers, using effect of assignment for deviations from intended interventions.[1] Contradictory ratings and required-question omissions were rule breaks; absent ratings and answer sets were unevaluable. A sensitivity analysis recursively resolved invalid required answers as negative or no information. Overall checks allowed escalation for multiple Some concerns domains. Process outcomes also counted required active answers citing evidence, source/location records and assessment-file integrity; none measured semantic evidence support.

Computational runtime summed model-turn elapsed durations. API list-price equivalents used recorded tokens and fixed provider rates, with cached inputs and additional calls detailed in eMethods. Subscription-based runs did not incur these reconstructed amounts as expenditure.

Exploratory analyses examined derived Overall ratings, disagreement severity/direction and rules-only recomputation. Overall used the worst independent domain rating without optional escalation and was not an independent sixth domain. Expert comparisons included 102 trials; Published Overall used 81 with observed labels, excluding 21 without. Directional analyses partitioned stricter or more lenient ratings than Published into expert matches to the arm, Published or neither. Rules-only recomputation replaced contradictory Unassisted ratings but retained invalid sequences and missing ratings; original disagreement sets stayed fixed, and new ties could credit both arms. Binary expert comparisons and severity strata were exploratory. Choices across all disputed cells and revised ratings were descriptive because offered labels could anchor responses.

We used 10,000 stratified trial-cluster bootstrap resamples (seed 20261018), sampling trials within each of 16 fixed reviews, retaining review sizes and carrying both arms and all domains together. Paired contrasts shared weights; expert means averaged expert-specific estimates within each resample. Percentile 95% CIs describe trial variation conditional on these reviews, experts and observed runs, not variation across new reviews, experts or repeated runs. We used no P values or multiplicity adjustments. TRIPOD-LLM and GRRAS informed reporting, with an accompanying item map and author-completion fields.[12,13]

## Results

The 102 included trials yielded 510 trial–domain cells, all independently assessed by both experts (Figure 3; Table 1). Published labels were Low in 427/510 cells (83.7%), compared with 277/510 (54.3%) for Expert 1 and 346/510 (67.8%) for Expert 2. An all-Low rule matched 83.7% of Published domain labels. Against Published across all 510 cells, ARBITER matched 386/510 (75.7%) and Unassisted 395/510 (77.5%), a paired difference of −1.8 points (95% CI, −5.1 to 1.6).

Across the full cohort, ARBITER agreed more often with both independent experts (Figure 4). It matched Expert 1 in 371/510 cells (72.7%) versus 332/510 (65.1%) for Unassisted, a paired gain of 7.6 percentage points (95% CI, 5.1–10.2). Against Expert 2, agreement was 433/510 (84.9%) versus 400/510 (78.4%), a gain of 6.5 points (3.5–9.4). The experts agreed in 388/510 cells (76.1%); Published labels matched the experts in 301/510 and 362/510 cells. Weighted κ values were 0.51 and 0.69 for ARBITER, compared with 0.35 and 0.53 for Unassisted; expert-to-expert weighted κ was 0.59.

The arms' ratings differed in 80 cells; the experts chose the same label in 60 and split in 20. The agreed label matched ARBITER in 53/60 cells (88%; 95% CI, 80–96%) and Unassisted in 7/60 (12%); Table 2 summarizes these choices. Across all 80 disagreements, the label chosen by Expert 1 matched ARBITER in 63/80 (79%), and that chosen by Expert 2 matched ARBITER in 61/80 (76%). Counting every split choice against ARBITER gave 53/80 (66%).

Agreement gains varied by domain, alongside disagreement between experts. Selection of the reported result (D5) had the largest observed gains: 19.6 points (95% CI, 11.8–27.5) and 11.8 (2.9–20.6) against Experts 1 and 2. For missing outcome data (D3), ARBITER matched 43/102 ratings from Expert 1 (42.2%) and 80/102 from Expert 2 (78.4%); the experts agreed in 54/102 cells.

Signalling-answer agreement depended on whether probable and definite answers were distinguished (Figure 5). In D3 against Expert 1, the five-level paired ARBITER minus Unassisted difference was −10.3 points (95% CI, −17.2 to −3.2), whereas the collapsed difference was +8.5 (3.5–13.7), both using 165 paired components. In D5, collapsed gains were +11.3 points against Expert 1, using 301 paired components, and +3.7 (−0.3 to 7.4) against Expert 2, using 300. The supplement reports complete question-level results and source-specific absolute rates, whose eligible denominators may differ from those of the paired contrasts. Exploratory rules-only recomputation changed 26 Unassisted labels while retaining their recorded answers, invalid answer sequences and missingness.

All 510 adopted ARBITER domain outputs conformed to the algorithms, with no recorded domain overrides (Table 3). Proposed ratings are determined algorithmically; the absence of overrides and conformance of adopted ratings were observations in this benchmark. Unassisted had rule breaks in 65/509 evaluable domain outputs: 26 contradictory ratings and 39 required-question omissions; one cell was unevaluable. All 1538 active required answers cited a passage or image. All 1407/1407 text spans and 14 image records passed source-provenance checks, and all 102 exported assessment records passed completeness and consistency checks. These audits counted different objects and did not establish whether the cited evidence supported the answers.

ARBITER required more computation. Median (IQR) runtime was 7.6 (6.1–10.5) versus 0.5 (0.4–0.5) minutes per trial; the paired mean difference was 11.0 minutes (95% CI, 8.4–14.1). Median (IQR) API list-price equivalents were US$3.78 (3.46–4.10) versus US$0.09 (0.07–0.13), with a paired mean difference of US$3.68 (3.61–3.75).

## Discussion

ARBITER's agreement advantage depended on the reference against which it was assessed. It showed no clear advantage over minimal prompting against published labels, whereas it agreed more often with each independent expert. This distinction matters because the published labels were predominantly Low and did not always concern an exactly aligned result. Broader published targets could make an apparently discordant rating appropriate for a different result; review-level conventions could also differ from the independently applied task. These are plausible explanations to examine in the retained records, not demonstrated causes of our agreement pattern or evidence that the published assessments were wrong. The independent ratings offer a separate comparison: experts assessed the same inputs and target prompts before seeing offered labels, but their own disagreement precludes treating either as an error-free standard.

Reference dependence is also visible when several human comparators assess the same trial set. In Gandhi's study of 50 trials, overall exact agreement was 46% between ChatGPT-o3 and a masked panel, 36% between the model and ophthalmic surgical research assessors, and 54% between the two human sources.[8] These pairwise results do not identify the correct reference; they demonstrate why the comparator belongs in the interpretation of agreement. Our expert advantage and published-label result likewise answer different questions. The subsequent blinded choices add a conditional perspective: 53 labels matched ARBITER among the 60 arm-discordant cells with an agreed expert choice, with another 20 split choices. Because experts saw labels without rationales, that result cannot validate ARBITER's evidence interpretation or establish a preference for its workflow.

The domain and answer findings further constrain a general superiority claim. D5 had the largest observed domain-rating gains, but the collapsed answer contrast against Expert 2 remained uncertain. D3 was particularly dependent on the expert and coding scheme: the unfavorable five-level contrast against Expert 1 became favorable after probable and definite answers were combined. Collapsing categories asks whether answers have the same direction while discarding their degree of certainty. It therefore reveals a different aspect of agreement rather than resolving the adverse finding. These patterns identify where inspection is especially valuable; they do not identify the causes of disagreement or test whether gains differ between domains.

Rule conformance establishes a narrower, directly testable property of the assessment pathway. All adopted ARBITER ratings followed their recorded answers, with no overrides observed, whereas Unassisted sometimes contradicted its answers or omitted required questions. A single-trial pilot by Choi et al. found that ROBOTO2's entered ratings matched those implied by its answers in a mean 60% of domain judgments across 10 runs and five domains.[14] That repeated single-trial experiment cannot estimate a general failure rate or serve as a head-to-head comparison here. It does show why label agreement and internal conformance require separate measurement. ARBITER makes proposed ratings deterministic once answers are fixed; neither that design nor recomputing Unassisted ratings can establish whether those answers were justified or explain the complete-workflow agreement difference.

Documentary support requires another kind of evaluation. In Liang's study of 97 trial reports from one Cochrane review, GPT-5's mean evidence support was 64.3% (SD 5.9%), as judged by an automated retrieve-then-verify procedure.[15] The support judgments depended on retrieved context and a single judge model, so they do not constitute independent human validation or estimate ARBITER's support rate. They nevertheless expose the unresolved link between a categorical answer and the evidence offered to justify it. Our text-selection tool stores an actual captured slice, and our audits check source binding and record integrity. They cannot determine whether the selected passage is sufficient, whether omitted evidence changes the answer, or whether a model-written image transcription is correct. An independent passage-to-answer assessment is needed before these records can be described as semantically validated.

The paired design holds supplied trial evidence constant, but the observed differences belong to complete workflows. ARBITER received additional instructions, software and computation, and minimal prompting is a limited comparator alongside structured alternatives.[8,9,10] The runs also occurred on different dates without verified immutable snapshot identity. Purposive review selection, ordered and availability-dependent trial selection, target uncertainty, two experts and one run per arm limit transportability. The bootstrap intervals condition on the fixed reviews and observed experts and runs. Development-benchmark independence is author-confirmed, but exhaustive development exposure, prior model exposure to trial reports and version-freeze history remain incompletely documented. Source blinding cannot prevent offered labels from anchoring subsequent choices or revised ratings. Findings concern the evaluated revision; command correspondence does not establish equivalence of the complete public release.

Finally, computational burden and reviewer workload are different outcomes. ARBITER took longer and had higher reconstructed list-price equivalents, but we did not measure the time required to verify its assessments. Direct reviewer studies illustrate what is needed. In a randomized within-reviewer study of four domains of the earlier Cochrane tool, 41 participants completed 82 RobotReviewer-assisted and 82 manual article assessments. Mean times were 755 and 824 seconds; a mixed model estimated a relative time of 0.75 (95% CI, 0.62–0.92).[16] The modeled 25% reduction is distinct from the raw mean comparison and cannot be transferred to ARBITER or RoB 2. An implementation study in ongoing reviews found mixed acceptability and lacked a manual-only time comparator.[17] Evaluating ARBITER in use should therefore measure verification time, detection of unsupported interpretations and effects on final judgments, rather than infer benefit from computational speed, label acceptance or inspectability alone.

### Conclusion

In this single-run benchmark, ARBITER showed no clear published-label agreement advantage and agreed more often with both independent experts than same-model minimal prompting. Evidence support and reviewer benefit remain untested. Its demonstrated contribution is an inspectable pathway that connects supplied sources and signalling answers to rule-conformant ratings.

## Back matter

### Acknowledgments and AI use

[Non-author contributors and acknowledgments]. OpenAI GPT-6-Astra, GPT-6.1-Sol and GPT-6-Luna, accessed through T3 Code, assisted literature research, drafting and editorial checks in this revision. Final author review, approval and accountability remain pending; any AI assistance before this revision remains to be confirmed. [Author to verify the complete disclosure, including any AI use in code, data processing or figures, and provide matching cover-letter disclosure]. The expert assessments and forced-choice adjudication used no AI.

### Funding

[Funding sources, grant identifiers and funder role, or an explicit statement of no funding].

### Competing interests

[Author-specific competing interests, including relevant relationships to ARBITER, or an explicit declaration of none].

### Author contributions

[Author names mapped to CRediT roles; confirmation of final approval and accountability].

### Ethics, registration and public involvement

[Ethics approval or exemption determination and consent requirements, including the expert assessment and forced-choice component]. [Study registration status and identifier, if applicable]. [Patient and public involvement statement].

### Data availability

The [public study repository](https://github.com/AliSalman-et-al/arbiter-JAMIA) provides analysis code, derived data, expert assessment sheets, prompts and reproducibility materials. An archival DOI and complete dataset citation remain pending. ARBITER source is available at [the public software commit](https://github.com/AliSalman-et-al/ARBITER/tree/2f549ae30f056ff441ea61a04b719968716f2219). The [results report](https://alisalman-et-al.github.io/arbiter-JAMIA/results.html) and [supplement](https://alisalman-et-al.github.io/arbiter-JAMIA/supplement.html) provide the figures, editable tables and reproduction links. Trial PDFs will not be redistributed; trial DOIs and source-file hashes will identify the inputs. Author declarations and archival registration remain pending completion.
