# ARBITER: an evidence-linked workflow for AI-assisted risk-of-bias assessment

## Front-matter notes

Article type: Research and Applications. Main displays comprise five figures and three tables.

Author: Ali Salman, MBBS. Affiliations: [Department, institution, city and country]. Correspondence: [Postal address, email and telephone]. [Confirm complete author list and order].

Keywords: artificial intelligence; risk of bias; evidence synthesis; reproducibility; clinical trials.

Word counts: abstract 198; main body 3077 (excluding headings, abstract, front matter, back matter and references).

## Abstract

### Objective

To compare an evidence-linked RoB 2 workflow with minimal prompting using the same reported model identifier, and evaluate agreement and inspectability.

### Materials and Methods

ARBITER records sources, selected evidence and signalling answers; software derives proposed ratings. ARBITER and minimal prompting (Unassisted) assessed identical supplied documents for 102 trials from 16 reviews. We compared published labels, independent human reviewer ratings and conditional blinded label choices. Paired intervals resampled trials within fixed reviews.

### Results

Against published labels, ARBITER minus Unassisted exact agreement was −1.8 percentage points (95% CI, −5.1 to 1.6). Agreement with Human Review 1 was 371/510 (72.7%) versus 332/510 (65.1%), a gain of 7.6 points (95% CI, 5.1–10.2); with Human Review 2, it was 433/510 (84.9%) versus 400/510 (78.4%), a gain of 6.5 (3.5–9.4). All 510 adopted ARBITER domain ratings conformed to the decision rules. Median runtime was 7.6 versus 0.5 minutes per trial.

### Discussion

Agreement depended on the reference and domain. Structural source checks did not validate evidence support, and label choices did not evaluate reasoning. The complete-workflow comparison cannot isolate component effects or establish reviewer benefit.

### Conclusion

In this single-run benchmark, ARBITER preserved an inspectable assessment pathway and agreed more often with both independent human reviewers, without a clear published-label agreement advantage.

## Introduction

### Background and significance

Risk-of-bias assessment requires reviewers to connect a judgment to the particular trial result and evidence that justify it. RoB 2 formalizes the transition from signalling answers to proposed ratings,[1] but reaching those answers still requires interpretation across reports, registries and supporting documents. In a cross-sectional exercise involving four raters and 70 trial outcomes, overall Fleiss κ was 0.16 (95% CI, 0.08–0.24), and assessment took a mean 28 minutes per outcome.[2] Agreement can also change as teams develop shared conventions. In one multiple-sclerosis review, calibration and review-specific signalling-question instructions preceded an increase in overall κ from −0.15 during calibration to 0.11 for the first five studies assessed with the instructions and 0.42 for the remaining 11.[3] That sequential, single-team evaluation cannot separate instruction effects from discussion, practice or study order. Together, these findings identify interpretation and implementation as consequential parts of appraisal, even with a structured instrument.

Automated assistance must therefore preserve the connection between a result-specific judgment and its evidential basis. In living evidence synthesis, newly available trials and supporting documents require repeated appraisal; retaining the basis of earlier judgments could help reviewers revisit them when evidence changes, consistent with frameworks integrating automation and human oversight.[4] RobotReviewer paired classifications with supporting sentences for the earlier Cochrane instrument, evaluating text relevance separately from classification.[5] ROBOTO2 combines document parsing, retrieved passages, signalling answers and editable RoB 2 assessments;[6] RoBGuard adds multimodal parsing and collaboration among model roles.[7] These systems make evidence available for inspection, but a source-linked quotation can be authentic yet irrelevant to the assessed result, and a plausible rating can conflict with the answers offered to justify it. Source fidelity, support for an answer and conformity to decision rules therefore require distinct evaluation.

### Objective

We developed the Agentic Risk of Bias Inference Tool for Evidence Reviews (ARBITER) to preserve this pathway for experienced evidence reviewers. The model selects evidence and interprets it; software applies decision rules to the recorded answers. We asked what assessment record the workflow preserves and how its ratings compare with published review labels and independent human reviewer ratings. We compared the complete workflow with minimal prompting using the same reported model identifier, comparable configuration and identical supplied trial documents.

## Materials and methods

### System design

ARBITER separates evidence interpretation from rating derivation (Figure 1). The model identifies the result, examines documents and answers the signalling questions. Software checks permissible answers, required question paths and evidence references, then computes the proposed domain ratings. An interactive reviewer can approve the proposed target before assessment; our automated harness accepted it unchanged.

ARBITER retains source documents and their extracted text. Reading and search tools return passage references. The model selects a passage using those references, page/line ranges or copied text as a locator. Copied text must match the captured source; unmatched or ambiguous selections are rejected. The accepted quotation is stored from the actual captured source slice, with its page and character offsets. Thus, the tool constrains fabricated quotation wording within this pathway, while errors in document extraction, incomplete selection and inappropriate interpretation remain possible. Visual evidence instead links a rendered page and selected region to a model-written transcription, which is not independently verified.

Each answer retains evidence and justification, with provision for uncertainty and counterevidence. The algorithm-derived proposal and adopted rating are separate. Adopting a different rating requires a rationale and supporting evidence linked to the answers. Exported HTML reports and audit files retain the assessment pathway. Figure 2 illustrates the AVATAR assessment of all-cause death after early surgery versus watchful waiting in asymptomatic severe aortic stenosis. The case illustrates the workflow rather than typical performance; its stored documents did not establish a dated analysis plan for the assessed result.

### Benchmark and assessment arms

We selected reviews purposively across 15 medical specialties. We searched Europe PMC for 2025–2026 meta-analyses of randomized trials, prioritizing journal standing and citation counts and requiring explicit RoB 2 use with extractable trial-level domain labels. Search dates and ranking records are unavailable. Within reviews, we took up to seven obtainable eligible trials in table order, replacing unavailable reports with the next eligible trial and removing duplicates. The source set comprised 105 trials from 16 reviews; we excluded three trials outside the supported design scope, leaving 102. The supplementary benchmark table documents reviews, specialties and source availability.

Initial targets followed trial-primary outcomes. Before the runs, 43 of 105 targets were revised toward the results underlying published labels. Final prompts specified outcome, comparison, time point and numerical result. Alignment with published labels remained partial, inferred, different or indeterminate for some targets, and some labels covered several outcomes. We retained all domain cells and considered this uncertainty qualitatively.

Both arms received identical underlying trial evidence from the captured input set: articles, supplements, registry copies, protocols and analysis plans, with availability varying by trial. Unassisted received copies of registry records and acquired documents from the ARBITER run rather than newly retrieved versions. A supplied record could concern the wrong trial; sharing inputs did not establish their completeness or correctness.

Unassisted received the task sentence and one fixed output-format sentence, without RoB 2 guidance. It could read and search local documents but could not access ARBITER's software service, assessment instructions or the web. ARBITER additionally received packaged workflow instructions and RoB 2 guidance through an assessment skill. Structured-prompt alternatives have been evaluated elsewhere.[8,9,10]

Both arms used `claude-sonnet-5-5`, medium effort, in Claude Code 2.1.278, with isolated settings, external connectors and memory disabled. ARBITER ran on 12 October 2026 and Unassisted on 14 October 2026, once per trial per arm. An identical immutable model snapshot across dates was not established. The protocol permitted “Continue.” at most twice per phase without coaching. The benchmark was not used to develop the workflow. Development included ten prostate-cancer trials and synthetic diagnostic cases. Complete development-exposure history, prompt and assessment-skill selection history, and version-freeze documentation remain pending. We evaluated [this source revision](https://github.com/AliSalman-et-al/ARBITER/tree/2848c7926a2acc25402345a42be39d695a99861a); [public ARBITER 1.0.0 source](https://github.com/AliSalman-et-al/ARBITER/tree/2f549ae30f056ff441ea61a04b719968716f2219) is available. eMethods describes prompts and invocation details.

### Independent human reviews

Two blinded human reviewers, published researchers from BEACON Lab, independently assessed all five domains for every trial. Their independent assessments are labeled Human Review 1 and Human Review 2. A trial–domain pair constituted a cell. Each human reviewer recorded and froze signalling answers and domain ratings before seeing offered labels, without AI assistance. Human reviewers received the same trial materials, supplements and ClinicalTrials.gov records as the arms, the same target prompt specifying outcomes, contrasts and numerical anchors, and access to Cochrane guidance. [Pending: individual qualifications and RoB 2 experience, training/calibration and conventions for targets containing several outcomes.]

Subsequently, each human reviewer saw Published, Unassisted and ARBITER labels in an order randomized by cell, without source identities or rationales, and chose the most defensible label. Human reviewers could then revise their ratings and answers. We use the frozen independent ratings for agreement comparisons and report the blinded choices separately; blinded adjudication in data extraction provided a procedural precedent.[11] Completed workbooks are available in the study repository. [Pending: original blank assessment form.]

### Outcomes

We report published-label agreement first, followed by agreement with independent human reviews and process/resource outcomes. Conditional label choices and signalling-answer comparisons provide supporting evidence. The reporting scope was reduced after analysis for focus, without a formal outcome hierarchy or a claim of prospective specification. The supplement records omitted analysis families and the Git revision retaining them.

For Published, we calculated exact agreement and paired percentage-point differences across 510 cells, followed by linearly weighted Cohen's κ. An All-Low rule described prevalence, with κ suppressed because predictions lacked variance. Missing predictions counted as disagreement. We compared each source with each human reviewer's independent ratings separately, pooled and by domain, using exact agreement and weighted κ. Paired contrasts compared ARBITER with Unassisted. Between human reviews agreement and category distributions describe the references.

The conditional label-choice analysis included the cells where the arms differed and both human reviewers chose the same label. Its numerator counted agreed labels matching ARBITER. Sensitivities used each human reviewer's choices over all arm disagreements and counted split choices as ARBITER losses without assigning Unassisted wins. Credit followed label equality. Choices measured label matches, not endorsement of reasoning.

Supporting domain summaries and complete paired question results compare signalling answers with five-level coding (yes, probably yes, no, probably no, no information) and collapsed coding that combines yes/probably yes and no/probably no, retaining no information separately. Matching used trial, domain, question and explicitly named answer component. Missing, inactive, inapplicable, unmatched and unresolved answers were excluded. Paired contrasts required evaluability in both arms; the supplement gives eligible denominators. Compact exploratory checks compare recorded arm Overall ratings with each human reviewer's worst independent domain rating and recompute contradictory Unassisted labels from their recorded answers. These checks neither supply directly rated human reviewer Overall judgments nor isolate component effects.

We applied official RoB 2 algorithms to each arm's own answers, using effect of assignment for deviations from intended interventions.[1] We checked proposed and adopted ARBITER ratings separately because documented overrides were permitted. Contradictory ratings and required-question omissions were rule breaks; absent ratings and answer sets were unevaluable. Process checks also counted active required answers citing evidence, source/location records and assessment-file integrity. The structural source audit did not independently re-extract quotations or assess whether they supported the answers.

Computational runtime summed model-turn elapsed durations. Application programming interface (API) list-price equivalents used recorded tokens and fixed provider rates, with cached inputs and additional calls detailed in eMethods. Subscription-based runs did not incur these reconstructed amounts as expenditure.

### Statistical analysis

We used 10,000 stratified trial-cluster bootstrap resamples (seed 20261018), sampling trials within each of 16 fixed reviews, retaining review sizes and carrying both arms and all domains together. Paired contrasts shared weights. Percentile 95% CIs describe trial variation conditional on these reviews, human reviewers and observed runs, not variation across new reviews, human reviewers or repeated runs. We used no P values or multiplicity adjustments. TRIPOD-LLM and GRRAS informed reporting, with an accompanying item map and author-completion fields.[12,13]

## Results

The 102 included trials yielded 510 trial–domain cells, all independently assessed by both human reviewers (Figure 3; Table 1). Published labels were Low in 427/510 cells (83.7%), compared with 277/510 (54.3%) for Human Review 1 and 346/510 (67.8%) for Human Review 2. An all-Low rule matched 83.7% of Published domain labels. Against Published across all 510 cells, ARBITER matched 386/510 (75.7%) and Unassisted 395/510 (77.5%), a paired difference of −1.8 points (95% CI, −5.1 to 1.6).

Across the full cohort, ARBITER agreed more often with both independent human reviewers (Figure 4). It matched Human Review 1 in 371/510 cells (72.7%) versus 332/510 (65.1%) for Unassisted, a paired gain of 7.6 percentage points (95% CI, 5.1–10.2). Against Human Review 2, agreement was 433/510 (84.9%) versus 400/510 (78.4%), a gain of 6.5 points (3.5–9.4). The human reviewers agreed in 388/510 cells (76.1%). Weighted κ values were 0.51 and 0.69 for ARBITER, compared with 0.35 and 0.53 for Unassisted; weighted κ between the human reviews was 0.59.

Agreement gains varied by domain, alongside disagreement between human reviewers. Selection of the reported result (D5) had the largest observed gains of 19.6 points (95% CI, 11.8–27.5) and 11.8 (2.9–20.6) against Human Reviews 1 and 2. For missing outcome data (D3), ARBITER matched 43/102 ratings from Human Review 1 (42.2%) and 80/102 from Human Review 2 (78.4%); the human reviewers agreed in 54/102 cells.

In the supporting label-choice exercise, the arms differed in 80 cells; human reviewers chose the same label in 60 and split in 20. The agreed label matched ARBITER in 53/60 cells (88%; 95% CI, 80–96%) and Unassisted in 7/60 (12%). Counting every split choice against ARBITER gave 53/80 (66%). Table 2 gives choice sensitivities.

Signalling-answer agreement depended on coding (Figure 5). In D3 against Human Review 1, the five-level paired difference was −10.3 points (95% CI, −17.2 to −3.2), whereas the collapsed difference was +8.5 (3.5–13.7), both using 165 paired components. For question 4.1, five-level differences favored Unassisted against both human reviewers, whereas collapsed differences were zero. The supplement gives complete paired question results, both codings and eligible denominators.

All 510 adopted ARBITER domain outputs conformed to the algorithms, with no recorded domain overrides (Table 3). Unassisted had rule breaks in 65/509 evaluable domain outputs, comprising 26 contradictory ratings and 39 required-question omissions; one cell was unevaluable. All 1538 active required answers cited a passage or image. All 1407/1407 text spans and 14 image records passed source-provenance checks, and all 102 exported assessment records passed structural verification. These checks did not assess whether evidence supported the answers.

Median runtime was 7.6 versus 0.5 minutes per trial. Median API list-price equivalents were US$3.78 versus US$0.09. Table 3 gives distributions and paired resource differences. Human verification time and expenditure were not measured.

## Discussion

ARBITER showed no clear agreement advantage over minimal prompting against published labels, whereas it agreed more often with each independent human reviewer. Published labels were predominantly Low and did not always concern an exactly aligned result. Broader published targets could make an apparently discordant rating appropriate for a different result; review-level conventions could also differ from those applied to our specified task. These are plausible explanations for investigation, rather than demonstrated causes of the observed pattern. The independent ratings provide a complementary comparison because human reviewers assessed the same inputs and target prompts before seeing offered labels. Their disagreement, particularly for missing outcome data, also shows why neither human reviewer can be treated as an error-free standard.

Reference dependence is visible even when human comparators assess the same trial set. In Gandhi's study of 50 RCTs sampled from 50 meta-analyses, overall exact agreement was 46% between ChatGPT-o3 and a masked panel, 36% between the model and original systematic review authors, and 54% between the two human sources.[8] Agreement therefore describes a relationship between assessments, rather than an intrinsic property of a model. Reporting each reference separately preserves the distinction between reproducing a review's published judgments and agreeing with independently elicited assessments. Our subsequent blinded choices add a narrower perspective: 53 labels matched ARBITER among the 60 arm-discordant cells with an agreed human reviewer choice, with another 20 split choices. Since human reviewers saw labels without rationales, this finding concerns conditional label matching rather than endorsement of the underlying reasoning.

The domain and answer findings show where the apparent improvement needs closer examination. D5 had the largest observed domain-rating gains, but its collapsed-answer contrast against Human Review 2 included no difference. In D3 against Human Review 1, an unfavorable five-level contrast became favorable after yes was combined with probably yes and no with probably no. Collapsing these clinical answer categories changes the distinctions being tested; it does not resolve the adverse five-level result. Inspection should therefore address both the interpretation of missing outcome data and the choice between a definite and probable answer. Separate intervals do not test differences between domains, and the present study did not identify the reasons for these disagreements.

Executable rules settle one part of this pathway: the transition from recorded answers to proposed ratings. All adopted ARBITER ratings followed their answers, with no overrides observed, whereas Unassisted sometimes contradicted its answers or omitted required questions. In Choi's single-trial pilot, ROBOTO2's entered ratings matched those implied by its answers in a mean 60% of domain judgments across 10 runs and five domains.[14] The repeated single-trial design examines within-trial variation rather than performance across a trial population, but illustrates why agreement with a human reviewer and conformity to one's own answers are different properties. Software fixes the answer-to-rating transition; the interpretation producing those answers remains the unresolved step.

That interpretive step is clinically consequential in selection of the reported result. The illustrative AVATAR assessment did not establish a dated analysis plan for the assessed mortality result from the supplied documents. A passage describing an analysis can establish what was reported without establishing that the plan preceded access to unblinded outcome data.[1] Retaining the source passage, signalling answer and justification lets a reviewer examine that temporal distinction and seek additional documentation. The example illustrates how an inspectable record can support scrutiny without making a claim about typical performance or the cause of the observed D5 gains.

Evidence support requires evaluating the relation between a claim and its source. In Liang's study of 97 trial reports from one Cochrane review, GPT-5's mean evidence support was 64.3% (SD 5.9%) under an automated retrieve-then-verify procedure.[15] These judgments depended on retrieved context and a single judge model, rather than independent human validation. The distinction is relevant to our structural findings: storing an actual captured slice establishes what text was selected, while a reviewer must determine whether it addresses the relevant result and sufficiently supports the answer. Omitted passages may change that interpretation, extraction may lose information, and image transcriptions remain model-written. Independent passage-to-answer assessment would test this unresolved relation.

The observed agreement differences belong to the complete workflows. ARBITER combined additional instructions, software and computation, so the comparison cannot isolate component effects. Minimal prompting also provides a limited comparator alongside structured alternatives.[8,9,10] Both arms used a common reported model identifier and configuration on different dates, without verified immutable snapshot identity. Purposive review selection, ordered and availability-dependent trial selection, target uncertainty, unsupported-design exclusions, two human reviewers and one run per arm restrict generalization. Bootstrap intervals describe trial variation conditional on the fixed reviews, human reviewers and observed runs. Prior model exposure to trial reports is unknown, and complete development and version-freeze documentation and human reviewer qualifications remain pending. Offered labels could anchor later choices despite source blinding. Findings concern the evaluated software revision.

The practical question is whether reviewers can detect unsupported interpretations and reach defensible judgments with less verification effort. Computational runtime does not measure that work. In a randomized within-reviewer study of four domains of the earlier Cochrane tool, 41 participants assessed articles with and without RobotReviewer assistance; modeled relative assessment time was 0.75 (95% CI, 0.62–0.92).[16] An implementation study in ongoing reviews found mixed acceptability and lacked a manual-only time comparator.[17] These studies make reviewer behavior and verification time central outcomes for an evaluation of ARBITER in use. Such a study should examine which unsupported interpretations reviewers detect, how suggestions affect final judgments, and the effort required to check them. In living reviews, the retained record also provides a basis for studying how reviewers revisit assessments when new reports or supporting documents become available.

### Conclusion

In this single-run benchmark, ARBITER showed no clear published-label agreement advantage and agreed more often with both independent human reviewers than minimal prompting using a comparably configured reported model. Evidence support and reviewer benefit remain untested. Its demonstrated contribution is an inspectable pathway connecting supplied sources and signalling answers to rule-conformant ratings.

## Back matter

### Acknowledgments and AI use

[Non-author contributors and acknowledgments]. OpenAI GPT-6-Astra, GPT-6.1-Sol and GPT-6-Luna, accessed through T3 Code, assisted literature research, drafting and editorial checks in this revision. Final author review, approval and accountability remain pending; any AI assistance before this revision remains to be confirmed. [Author to verify the complete disclosure, including any AI use in code, data processing or figures, and provide matching cover-letter disclosure]. The human reviewer assessments and forced-choice adjudication used no AI.

### Funding

[Funding sources, grant identifiers and funder role, or an explicit statement of no funding].

### Competing interests

[Author-specific competing interests, including relevant relationships to ARBITER, or an explicit declaration of none].

### Author contributions

[Author names mapped to CRediT roles; confirmation of final approval and accountability].

### Ethics, registration and public involvement

[Ethics approval or exemption determination and consent requirements, including the human reviewer assessment and forced-choice component]. [Study registration status and identifier, if applicable]. [Patient and public involvement statement].

### Data availability

The [public study repository](https://github.com/AliSalman-et-al/arbiter-JAMIA) provides analysis code, derived data, human reviewer assessment sheets, prompts and reproducibility materials. An archival DOI and complete dataset citation remain pending. ARBITER source is available at [the public software commit](https://github.com/AliSalman-et-al/ARBITER/tree/2f549ae30f056ff441ea61a04b719968716f2219). The [results report](https://alisalman-et-al.github.io/arbiter-JAMIA/results.html) and [supplement](https://alisalman-et-al.github.io/arbiter-JAMIA/supplement.html) provide the figures, editable tables and reproduction links. Trial PDFs will not be redistributed; trial DOIs and source-file hashes will identify the inputs. Author declarations and archival registration remain pending completion.
