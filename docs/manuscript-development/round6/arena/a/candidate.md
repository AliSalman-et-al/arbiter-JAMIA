# ARBITER: an evidence-linked workflow for AI-assisted risk-of-bias assessment

## Front-matter notes

Article type: Research and Applications. Main displays comprise five figures and three tables.

Author: Ali Salman, MBBS. Affiliations: [Department, institution, city and country]. Correspondence: [Postal address, email and telephone]. [Confirm complete author list and order].

Keywords: artificial intelligence; risk of bias; evidence synthesis; reproducibility; clinical trials.

Word counts: see the candidate-specific counts in rationale.md.

## Abstract

### Objective

To evaluate whether an evidence-linked RoB 2 workflow improves agreement compared with same-model minimal prompting while preserving an inspectable assessment pathway.

### Materials and Methods

ARBITER retains sources, selected evidence and signalling answers; software derives proposed ratings. ARBITER and a minimal-prompt comparator (Unassisted) assessed identical supplied documents for 102 trials from 16 reviews. We compared judgments with published labels, independent expert ratings and conditional blinded label choices. Paired bootstrap intervals resampled trials within fixed reviews.

### Results

Against published labels, ARBITER minus Unassisted exact agreement was −1.8 percentage points (95% CI, −5.1 to 1.6). Exact agreement was 371/510 (72.7%) versus 332/510 (65.1%) against Expert 1 and 433/510 (84.9%) versus 400/510 (78.4%) against Expert 2; paired gains were 7.6 points (95% CI, 5.1–10.2) and 6.5 (3.5–9.4). Among 80 workflow disagreements, experts agreed on 60 blinded label choices and split on 20; 53/60 agreed choices matched ARBITER (88%; 95% CI, 80–96%). All 510 adopted ARBITER domain ratings conformed to the algorithms, without overrides. Median computational runtime was 7.6 versus 0.5 minutes per trial.

### Discussion

Agreement depended on reference and domain. Source and rule checks did not validate evidence interpretation. The single-run, complete-workflow comparison cannot isolate component effects or establish reviewer benefit.

### Conclusion

ARBITER agreed more often with both independent experts and retained an inspectable pathway from sources to ratings.

## Introduction

Risk-of-bias assessment requires reviewers to connect a judgment about a trial result to the evidence that justifies it. For RoB 2, this entails identifying the relevant outcome, comparison and analysis, interpreting information across reports and supporting documents, and applying decision rules to signalling answers.[1] Assistance with these operations must preserve the distinction between interpreting evidence and deriving a rating from that interpretation.

Both workload and disagreement make this distinction consequential. In a cross-sectional exercise, four raters assessed 70 trial outcomes; overall Fleiss κ was 0.16 (95% CI, 0.08–0.24), and mean assessment time was 28 minutes per outcome.[2] In a subsequent single-review evaluation of 80 results from 16 trials, calibration and review-specific signalling-question instructions preceded an increase in overall κ from −0.15 during calibration to 0.11 for the first five studies assessed with the instructions and 0.42 for the remaining 11.[3] Discussion, practice and study sequence accompanied the instructions, so the change cannot be attributed to guidance alone. These findings suggest that a useful computational workflow must make its interpretive decisions available for review, rather than merely reproduce a categorical judgment.

Automation already supports parts of this work. RobotReviewer paired classifications with supporting sentences for the earlier Cochrane instrument, evaluating text relevance separately from classification.[4] ROBOTO2 combines document parsing, retrieved passages, signalling answers and editable assessments for RoB 2.[5] Such systems make evidence available to reviewers, but evidence availability, support for an answer and conformity of a rating to decision rules remain distinct evaluation questions. A source-linked quotation can be authentic yet irrelevant to the assessed result; a plausible rating can conflict with the answers offered to justify it.

We developed the Agentic Risk of Bias Inference Tool for Evidence Reviews (ARBITER) to retain the pathway from supplied documents through selected evidence and signalling answers to software-derived rating proposals. To determine how this complete workflow compares with minimal prompting, we evaluated both approaches using the same reported model and supplied trial documents. We examined agreement with published labels and independent experts, conditional blinded label choices, rule conformance, source records and computational burden. The study evaluates agreement and inspectability without assuming that either establishes semantic correctness or benefit during reviewer use.

## Materials and methods

### Workflow and retained evidence

ARBITER assigns evidence interpretation to the model and application of the RoB 2 algorithms to software (Figure 1). The model proposes the result to assess, reads the available documents and answers the signalling questions. Interactive users can inspect the proposed target before domain assessment; the automated benchmark accepted it unchanged.

The source-selection tools bind evidence records to captured documents. Documents have cryptographic hashes identifying their contents, and extracted page text has a separate version identifier. The model selects text using a returned passage reference, page and line ranges, or copied text as a locator. Copied locators must match the captured source; unmatched or ambiguous selections are rejected. The accepted quotation is stored from the actual captured slice, with source, page and character offsets. This constrains fabricated quotation wording in this pathway, but extraction errors, incomplete selection and inappropriate interpretation can persist. Visual evidence links a rendered page and selected region to a model-written transcription, whose accuracy is not independently verified.

Each signalling answer retains evidence and justification, with provision for uncertainty and counterevidence. Software checks answer options, required question paths and evidence references, then computes a proposed rating. The adopted rating is recorded separately: an override requires a rationale and supporting evidence linked to the saved answers. Exported HTML reports and audit files retain this decision pathway. Runtime text matching, assessment-file verification and the study's structural provenance audit assess different properties; the provenance audit did not independently re-extract quotations or judge whether evidence supported answers.

The AVATAR example follows all-cause death after early surgery versus watchful waiting in asymptomatic severe aortic stenosis (Figure 2; complete trace in the supplement). Its stored documents did not establish a dated analysis plan for the assessed result. We use the case to illustrate inspection, without presenting it as typical performance.

### Benchmark and comparison

We evaluated 102 trials from 16 purposively selected reviews spanning 15 specialties. The selection team reported searching Europe PMC for 2025–2026 meta-analyses using RoB 2 with extractable trial-level judgments, prioritizing journal standing and citations. Search dates and ranking records were not recovered, precluding verification of this prioritization. Within reviews, selection followed table order, taking up to seven obtainable eligible trials, replacing unavailable reports with the next eligible trial and removing duplicates. Of 105 source trials, three author-designated unsupported designs were excluded. The author disputes Atwine's stored classification; its specific unsupported subtype remains unverified. The supplementary benchmark table identifies reviews, specialties and source availability.

Targets initially followed trial-primary outcomes; before the runs, 43 of 105 were revised toward the results underlying published labels. Final prompts specified the outcome, comparison, time point and numerical result from the revised ledger. Correspondence with published labels remained partial, inferred, different or indeterminate in some cases, including labels covering several outcomes. We retained all domain cells and considered this uncertainty qualitatively.

Both arms received identical underlying trial evidence: articles, supplements and captured registry records, protocols and statistical analysis plans, where available. Unassisted received copies of documents acquired during the ARBITER run, including registry records, rather than newly fetched versions. The supplied De Waal registry record concerned another trial. Unassisted received the assessment task and a fixed output-format sentence, could read and search local documents, and had no RoB 2 instructions, ARBITER service or web access. ARBITER additionally received a packaged assessment skill containing workflow instructions and guidance. Thus, this was a complete-workflow comparison, differing from structured-prompt evaluations,[6,7] rather than a test isolating software, guidance or computation.

Both arms used `claude-sonnet-5-5`, medium effort, in Claude Code 2.1.278, with isolated settings and external connectors and memory disabled. ARBITER ran on 12 October 2026 and Unassisted on 14 October 2026, once per trial per arm. Immutable model-snapshot identity across dates was not established. The author confirms that this benchmark was not used in development; available development records do not establish an exhaustive exposure history. [Pending: complete prompt and assessment-skill selection history and version-freeze documentation.] Results apply to the evaluated software revision identified in eMethods; correspondence between assessment commands does not establish equivalence with the complete public release. Prompt templates, a filled example and execution details are provided in eMethods.

### Expert assessments

Two blinded experts, published BEACON Lab researchers, independently assessed every trial–domain cell without AI. They received the same trial materials, supplements, ClinicalTrials.gov records and target task prompts as the arms, plus Cochrane guidance. Each froze signalling answers and domain ratings before seeing offered labels. [Pending: individual qualifications and RoB 2 experience, training/calibration and conventions for targets containing several outcomes.]

Experts then chose the most defensible of the Published, Unassisted and ARBITER labels, randomized within each cell and shown without source identities or rationales. They subsequently supplied revised ratings, which could differ from all offered labels, and recorded whether answers changed. We analyzed independent ratings, choices and revisions separately; later responses could be anchored by offered labels. Blinded adjudication in data-extraction research provided a design precedent.[8] eMethods describes the sequence, and completed workbooks are available in the repository. [Pending: original blank assessment form.]

### Outcomes and analysis

We report published-label agreement first, followed by independent-expert agreement, conditional choices, domain and answer detail, process checks and computation. This reporting order was adopted after analysis and does not imply prospective specification or an outcome hierarchy.

For Published and each independent expert, we calculated exact agreement and paired percentage-point differences, followed by linearly weighted Cohen's κ. Missing predictions counted as disagreement. Published-label analyses also assessed sensitivity for Some concerns or High, specificity and supplementary Gwet's AC2; an All-Low rule described prevalence, with κ suppressed because predictions lacked variance. Supporting expert analyses included expert-to-expert agreement, unweighted κ, confusion matrices, expert means and restriction to independently agreed cells.

For cells where the arms differed, we calculated the proportion of agreed expert label choices matching ARBITER. The denominator excluded split choices; credit followed label equality, so sources sharing a label shared credit and neither arm received credit when neither matched. Sensitivities used each expert's choices across all arm disagreements and counted every split as an ARBITER loss without assigning Unassisted wins. This outcome measures conditional label matching, without evaluating the reasoning behind a label.

We compared signalling answers using five levels—yes, probably yes, no, probably no and no information—and collapsed coding that combined probable with definite affirmative or negative answers. Matching used trial, domain, question and explicitly named answer component, such as outcome; undivided answers formed one component. Different named components were kept separate. Missing, inactive, not applicable, unmatched and unresolved answers were excluded; paired contrasts required both arms to be evaluable.

We applied official algorithms to each arm's own answers, using effect of assignment for deviations from intended interventions.[1] Contradictory ratings and required-question omissions were rule breaks; absent ratings and answer sets were unevaluable. A sensitivity analysis recursively resolved invalid required answers as negative or no information. Proposed and adopted ARBITER ratings were checked separately because overrides were permitted. Overall checks allowed escalation for multiple Some concerns. Evidence coverage counted required active answers citing text or images; provenance and file checks assessed source locations and record integrity, without semantic adjudication.

Computational outcomes were summed elapsed model-turn durations and API list-price equivalents reconstructed from tokens and fixed rates. Subscription runs did not incur these reconstructed amounts as expenditure. Exploratory analyses assessed derived Overall ratings, severity, direction of disagreement and rules-only recomputation. Derived Overall used the worst independent domain rating without optional escalation for multiple Some concerns and was not an independent sixth domain. Expert-reference analyses included all 102 trials; Published Overall comparisons included the 81 trials with observed labels, excluding 21 without them. Directional analyses partitioned ratings stricter or more lenient than Published into expert matches to the arm, Published or neither. Rules-only recomputation replaced contradictory Unassisted ratings while retaining invalid answer sequences and missingness. Original disagreement populations remained fixed, and new ties could credit both arms. Binary expert comparisons and severity strata were exploratory; choices across all disputed cells and revised ratings were descriptive.

We used 10,000 stratified trial-cluster bootstrap resamples, seed 20261018, sampling trials within each of the 16 fixed reviews while retaining review sizes and carrying both arms and all domains together. Paired contrasts shared weights; expert means averaged expert-specific estimates within each resample. Percentile 95% CIs describe trial variation conditional on these reviews, two experts and observed runs, excluding variation across new reviews, experts or repeated runs. We used no P values or multiplicity adjustments. Reporting was guided by TRIPOD-LLM and GRRAS, with an item map and author-completion fields.[9,10]

## Results

The 102 included trials yielded 510 trial–domain cells, all independently assessed by both experts (Figure 3; Table 1). Published labels were Low in 427/510 cells (83.7%), compared with 277/510 (54.3%) for Expert 1 and 346/510 (67.8%) for Expert 2. An all-Low rule matched 83.7% of Published domain labels. Against Published across all 510 cells, ARBITER matched 386/510 (75.7%) and Unassisted 395/510 (77.5%), a paired difference of −1.8 points (95% CI, −5.1 to 1.6).

Across the full cohort, ARBITER agreed more often with both independent experts (Figure 4). It matched Expert 1 in 371/510 cells (72.7%) versus 332/510 (65.1%) for Unassisted, a paired gain of 7.6 percentage points (95% CI, 5.1–10.2). Against Expert 2, agreement was 433/510 (84.9%) versus 400/510 (78.4%), a gain of 6.5 points (3.5–9.4). The experts agreed in 388/510 cells (76.1%); Published labels matched the experts in 301/510 and 362/510 cells. Weighted κ values were 0.51 and 0.69 for ARBITER, compared with 0.35 and 0.53 for Unassisted; expert-to-expert weighted κ was 0.59.

The arms' ratings differed in 80 cells; the experts chose the same label in 60 and split in 20. The agreed label matched ARBITER in 53/60 cells (88%; 95% CI, 80–96%) and Unassisted in 7/60 (12%); Table 2 summarizes these choices. Across all 80 disagreements, the label chosen by Expert 1 matched ARBITER in 63/80 (79%), and that chosen by Expert 2 matched ARBITER in 61/80 (76%). Counting every split choice against ARBITER gave 53/80 (66%).

Agreement gains varied by domain, alongside disagreement between experts. Selection of the reported result (D5) had the largest observed gains: 19.6 points (95% CI, 11.8–27.5) and 11.8 (2.9–20.6) against Experts 1 and 2. For missing outcome data (D3), ARBITER matched 43/102 ratings from Expert 1 (42.2%) and 80/102 from Expert 2 (78.4%); the experts agreed in 54/102 cells.

Signalling-answer agreement depended on whether probable and definite answers were distinguished (Figure 5). In D3 against Expert 1, the five-level paired ARBITER minus Unassisted difference was −10.3 points (95% CI, −17.2 to −3.2), whereas the collapsed difference was +8.5 (3.5–13.7), both using 165 paired components. In D5, collapsed gains were +11.3 points against Expert 1, using 301 paired components, and +3.7 (−0.3 to 7.4) against Expert 2, using 300. The supplement reports complete question-level results and source-specific absolute rates, whose eligible denominators may differ from those of the paired contrasts. Exploratory rules-only recomputation changed 26 Unassisted labels while retaining their recorded answers, invalid answer sequences and missingness.

All 510 adopted ARBITER domain outputs conformed to the algorithms, with no recorded domain overrides (Table 3). Proposed ratings are determined algorithmically; the absence of overrides and conformance of adopted ratings were observations in this benchmark. Unassisted had rule breaks in 65/509 evaluable domain outputs: 26 contradictory ratings and 39 required-question omissions; one cell was unevaluable. All 1538 active required answers cited a passage or image. All 1407/1407 text spans and 14 image records passed source-provenance checks, and all 102 exported assessment records passed completeness and consistency checks. These audits counted different objects and did not establish whether the cited evidence supported the answers.

ARBITER required more computation. Median (IQR) runtime was 7.6 (6.1–10.5) versus 0.5 (0.4–0.5) minutes per trial; the paired mean difference was 11.0 minutes (95% CI, 8.4–14.1). Median (IQR) API list-price equivalents were US$3.78 (3.46–4.10) versus US$0.09 (0.07–0.13), with a paired mean difference of US$3.68 (3.61–3.75).

## Discussion

ARBITER's agreement advantage depended on whose assessment was used as the reference. It showed no clear advantage over minimal prompting against published labels, but agreed more often with each independent expert across the full cohort. The experts had rated the same materials and specified targets before exposure to offered labels, making this a comparison of independently recorded judgments. The conditional blinded-choice finding reinforces that pattern within a narrower population: 53 agreed choices matched ARBITER, after restricting 80 arm disagreements to 60 cells with agreed choices and excluding 20 splits. Because experts saw labels without rationales, this is neither endorsement of ARBITER's reasoning nor evidence that the workflow was preferred.

Reference dependence is substantive rather than a statistical inconvenience. Published labels were predominantly Low, and an All-Low rule matched more of them than either workflow. Some also addressed broader or different targets; these differences qualify the comparison without establishing why disagreement occurred. In Gandhi's 50-trial study, exact agreement for overall judgments was 46% between ChatGPT-o3 and a masked panel, 36% between ChatGPT-o3 and ophthalmic surgical research assessors, and 54% between those assessors and the panel.[6] The same model therefore appeared different against different human references, while the human sources also disagreed. These findings support reporting references separately; they do not establish which reference is correct. Our independent experts likewise cannot be treated as error-free, particularly given their D3 disagreement.

The domain and answer results further limit a global claim of improved appraisal. D5 had the largest observed domain-rating gains, but the smaller collapsed-answer contrast against Expert 2 included no difference. In D3 against Expert 1, the unfavorable five-level contrast became favorable after probable and definite answers were combined. Collapsing these categories changes the distinctions being tested; it does not resolve the adverse result. The retained answers make those differences inspectable, but the study did not determine whether they arose from evidence selection, uncertainty thresholds or interpretation. Nor do intervals around separate estimates test differences between domains.

Rule conformance addresses a narrower, tractable part of this problem. In Choi's single-trial pilot, ten ROBOTO2 runs had a five-domain mean conformance of 60% between entered ratings and the ratings implied by their own answers.[11] That result measures internal consistency, separately from agreement with an expert, and cannot estimate performance across trials. ARBITER makes this distinction operational by computing proposed ratings in software and permitting a separately documented adopted override. All adopted ratings conformed here, and no overrides were recorded. This establishes consistency between recorded answers and adopted ratings in this benchmark while leaving the evidential appropriateness of the answers unresolved. The exploratory recomputation of Unassisted labels cannot isolate how much of the complete-workflow agreement difference came from this safeguard.

Documentary support requires a different evaluation. In Liang's study of 97 trials from one Cochrane review, GPT-5's mean evidence-support rate was 64.3% (SD 5.9%) under an automated retrieve-then-verify assessment.[12] The verifier classified generated claims using retrieved passages, assessing a relation that categorical agreement does not measure. Its judge-model findings require qualification and cannot be transferred to ARBITER. Our source checks addressed an earlier step: whether retained evidence identified captured sources and locations. A reviewer must still decide whether a passage addresses the relevant outcome and signalling question. That distinction explains why complete source records can coexist with uncertain interpretations. Source matching cannot recover information lost during extraction or validate a model-written image description. Evaluating passage-to-answer support would therefore add evidence that the present structural audits cannot supply.

The comparison also leaves the source of the agreement difference open. ARBITER combined guidance, source tools, rule application and substantially more computation. Sharing trial documents and a reported model identifier does not separate these contributions, establish immutable snapshot identity or represent a comparison with every structured-prompt alternative.[6,7] The purposive reviews and ordered, availability-dependent trial selection further restrict transfer. Search and ranking records were unavailable, prior model exposure to reports is unknown, and development independence is author-confirmed without exhaustive exposure records. With two experts and one run per arm, the bootstrap intervals quantify trial variation within the selected reviews, rather than reliability across new reviewers, reviews or repeated model runs. These boundaries apply to the evaluated revision, without establishing equivalence to the complete public release.

The higher computational burden cannot be interpreted as either a saving or a loss of human reviewer time. Direct user studies can answer that question. In a randomized within-reviewer evaluation of four domains of the earlier Cochrane tool, 41 participants completed 82 RobotReviewer-assisted and 82 manual article assessments.[13] Raw mean times were 755 versus 824 seconds; the participant-adjusted model estimated relative time of 0.75 (95% CI, 0.62–0.92). The modeled ratio, rather than the ratio of raw means, underlies the reported 25% reduction. A subsequent study in ongoing reviews found mixed acceptability and lacked a manual-only comparator for time.[14] Together, these designs show why output agreement and reviewer benefit need separate measurement. For ARBITER, the next relevant test is whether reviewers can identify unsupported interpretations and reach defensible judgments with less verification effort; neither source-link completeness nor label acceptance would establish that benefit.

### Conclusion

In this single-run benchmark, ARBITER agreed more often with both independent experts than same-model minimal prompting, while agreement with published labels showed no clear advantage. Semantic support and benefit during reviewer use remain unevaluated. The contribution is an inspectable assessment pathway that preserves the evidence, answers and rule-derived proposals underlying a judgment, allowing disagreement to be examined beyond the final label.

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
