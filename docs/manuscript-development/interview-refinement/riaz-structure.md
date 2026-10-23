# How the closest papers develop Methods and order Results

Prepared 23 October 2026. Editorial analysis and proposed outline only; no manuscript revision or analysis change.

## Working agreement and the remaining choice

Parent update: the author has explicitly confirmed Published-label agreement before independent-expert agreement. The provisional-order language below reflects the worker's earlier information and is superseded by this confirmation; the formal primary endpoint remains unchanged.

The requested direction is to lead the substantive Results with **exact agreement**, then develop the evidence sequentially. The working outline below places **published review labels before independent expert ratings**, but that reference order remains a proposal pending the author's answer. It must not be described as an agreed preference. The confirmed interview directions in [author-interview.md](../author-interview.md) support a fuller clinical motivation, experienced evidence reviewers as intended users, the expansion **Agentic Risk of Bias Inference Tool for Evidence Reviews (ARBITER)**, and the title **ARBITER: an evidence-linked workflow for AI-assisted risk-of-bias assessment**.

Three different orders must remain distinct:

- **Expository order:** what the reader needs to understand next. This can put all-cell exact agreement before the selected-subset endpoint.
- **Assessment procedure:** experts independently rated and froze assessments before seeing offered labels, then made blinded choices and subsequently supplied revised ratings. Changing paragraph order must not change this sequence.
- **Formal outcome hierarchy:** the conditional agreed-label-choice endpoint remains primary; independent expert agreement remains secondary. Narrative prominence cannot reclassify outcomes or establish prospective specification.

The proposed story is: a source-linked RoB 2 workflow preserves intermediate decisions; its outputs show reference-dependent agreement in a paired benchmark; the conditional primary analysis, signalling-answer comparisons and structural audits answer different questions about those outputs. The record supports inspection, while semantic evidence support and benefit during reviewer use remain unestablished.

## Sources, versions and inspection limits

The discovery trail was the [round-four cache manifest](../round4/literature-cache-manifest.json) and the [Riaz](../round4/research/riaz/source-ledger.tsv), [Riaz-network](../round4/research/riaz_network/source-ledger.tsv) and [exemplar](../round4/research/exemplars/source-ledger.tsv) ledgers. Their `/tmp` paths were resolved to the persistent cache, not treated as currently available temporary files. The ledgers identify leads and provenance; the paragraph analysis below comes from reading actual article bodies.

1. **Khan et al., JAMIA 2025;32:638–647, DOI 10.1093/jamia/ocae325, PMC12005628.** Used the published-version [cached HTML](/home/ali/Documents/Code/arbiter-literature-cache/arbiter-r4-fulltexts/riaz/PMC12005628.html), checked against its retained text. Primary online identity: [published full text](https://pmc.ncbi.nlm.nih.gov/articles/PMC12005628/). Read Introduction, Background and significance, Methods, Results, Discussion, Conclusions and contributions. **PMC11469465 is the earlier medRxiv version of this same work; it is neither the structural authority here nor a second study.** Riaz is last and corresponding author. The published contribution statement credits original drafting to Khan, Ayub, Naqvi and Riaz, among their other roles. It does not identify who wrote any paragraph.
2. **Riaz et al., npj Digital Medicine 2025;8:347, DOI 10.1038/s41746-025-01646-7, PMC12152177.** Read the [cached publisher full text](/home/ali/Documents/Code/arbiter-literature-cache/arbiter-r4-fulltexts/riaz/nature_distillation.html): Introduction, Results, Discussion, Methods and contributions. [Publisher article](https://www.nature.com/articles/s41746-025-01646-7). Riaz is first and corresponding author; the contribution statement credits original drafting jointly to Riaz, Naqvi and Kehl. This is a matched clinical-AI evaluation exemplar, although its task is longitudinal oncology phenotyping, not evidence appraisal.
3. **Wang et al., “Accelerating clinical evidence synthesis with large language models,” npj Digital Medicine 2025;8:509, DOI 10.1038/s41746-025-01840-7, PMC12331930.** The network ledger listed this as a citation lead without inspected full text. For this memo, read the published [publisher full text](https://www.nature.com/articles/s41746-025-01840-7), including Introduction, all Results subsections, Methods, Discussion and contributions. The web reader encountered a publisher redirect and PMC browser check; a direct HTTP read of the publisher article returned the full article, including version-of-record metadata. No new cache file was written. **Riaz is not an author.** The contribution statement credits Wang with the initial draft and Jin, Lu and Sun with revisions. This is an adjacent evidence-synthesis exemplar, not evidence of Riaz's writing.

These are purposively chosen exemplars, not a systematic sample of a person's publications or proof of stable personal preferences. The published JAMIA paper is closest in journal and collaborative-review workflow; the distillation paper supplies a Riaz first-author comparative Methods example; TrialMind supplies the more directly relevant npj evidence-synthesis workflow. EviSearch and FD-SCoPE remain preprints in the inspected ledgers. The ROBINS-I framework lacked a complete local body. None is silently substituted for a fully read published article.

**Locator convention.** `¶` numbers count prose paragraphs within the named heading, excluding figure captions, tables and equations. A parent heading's introductory paragraphs are counted before its child headings. Section IDs refer to the inspected HTML, not to numbered sections printed in the article. Exact heading plus paragraph number is the durable locator; IDs provide a second check. Quoted headings identify locations, not endorsements of the authors' claims.

## 1. Published JAMIA collaborative-extraction paper

### Whole-paper OCAR and the route into Methods

The Introduction establishes the living-review workload problem (Introduction ¶1), develops the relevant NLP/LLM capabilities and limitations (¶2), and specifies the collaborative extraction question and hypothesis (¶3). A separate **Background and significance** then reviews task-specific precedents (¶1) and restates the unresolved boundary and proposed approach (¶2). These are `sec6` and `sec7` in the cached HTML.

This is recognizably OCAR, but it is not a perfectly linear funnel: the challenge appears before the separate Background section and is then sharpened again. For ARBITER, borrow the progression from clinical need to specific uncertainty; avoid duplicating the objective across two closing paragraphs merely because this article does so.

### Methods: every paragraph has an input or decision to hand forward

| Exact locator | Paragraph job and dependency |
| --- | --- |
| Data sources ¶1 (`sec9`) | Defines the clinical source, manually curated reference, publication unit and variable families. Establishes what can be extracted and what will count as a reference response. |
| Data processing ¶1 (`sec10`; Figure 1) | Follows PDF → extracted text → removal of ancillary material → overlapping chunks → table/figure page images. Each operation acts on the object just introduced; libraries and settings attach to the operation that uses them. |
| Sampling and prompting ¶1 (`sec11`) | Defines publication-level development/test allocation and the held-out role before describing prompt refinement. This permits readers to judge development overlap rather than infer independence from the word “test.” |
| Sampling and prompting ¶2 (`sec11`) | Moves from prepared text/images to named model APIs, settings and prompt contents. Supplies the actual extraction operation after its inputs and evaluation split are known. |
| Postprocessing ¶1 (`sec12`) | Turns separate model outputs into structured, deduplicated variable responses and resolves conflicting chunk/image responses. This constructs the objects subsequently compared. |
| Concordance assessment and cross-critique ¶1 (`sec13`) | Defines concordance, names the human assessors, sends discordant outputs to the other model with source content, and reassesses concordance. The paragraph contains a complete branch: compare → identify disagreements → critique → compare again. |
| Evaluation ¶1 (`sec14`) | Specifies publication-level evaluation, overlap sensitivity, reference comparison, metrics and statistical test. Establishes that model-to-model concordance and reference accuracy are separately measured. |
| Error analysis ¶1 (`sec15`) | Defines a further inspection of incorrect responses, after correctness has been defined. |
| Data availability ¶1 (`sec16`) | Provides the reproducibility destination. It does not create another experimental stage. |

The main structural achievement is **object continuity**. PDFs become inputs, inputs become responses, responses become comparable variables, and discordance determines which responses enter cross-critique. The prose supplies actors and operations rather than merely listing components. Figure 1 carries the overview; the paragraphs explain transformations.

### Actual Results order and paragraph jobs

| Exact locator, in reading order | What the paragraph establishes |
| --- | --- |
| Results ¶1 (`sec17`) | Corpus size, split and input burden. Gives the reader the population before any performance comparison. |
| Results ¶2 (`sec17`) | Response counts and branching before/after cross-critique. Previews the workflow's denominators before detailed performance. |
| Response evaluation in the single LLM approach ¶¶1–3 (`sec18`) | Development performance, held-out performance, then overlap sensitivity. Establishes the uncollaborated baseline first. |
| Collaborative approach → Concordant responses ¶¶1–3 (`sec20`) | Same development/test/sensitivity rhythm for the concordant subset; test paragraph compares this subset with single-model performance. |
| Collaborative approach → Discordant responses ¶¶1–3 (`sec21`) | Same rhythm for the difficult subset before critique. Makes the problem addressed by the next stage visible. |
| Response evaluation after cross-critique → Concordant responses after cross-critique ¶¶1–3 (`sec23`) | Reports responses that became concordant, with their own selected denominator and reference performance. |
| Same parent heading → Discordant responses after cross-critique ¶¶1–3 (`sec24`) | Retains unresolved cases, preventing the improved subset from becoming the entire story. |
| Error analysis ¶1 (`sec25`) | Changes from “how often” to error categories after the performance pattern is established. |

Thus, **Methods is predominantly processing order; Results is baseline → partition → attempted resolution → residual failure**. Results is not a mechanical copy of Methods, nor a simple ranking from most favorable to least favorable. The repeated development/test/sensitivity paragraphs create a stable comparison frame, although they are too repetitive to import wholesale into ARBITER.

The Discussion synthesizes the collaborative finding (¶1), develops strengths (¶2), addresses limitations (¶3), and extends to future workflows (¶4), followed by Conclusions (`sec26` and `sec27`). Its living-review and efficiency implications are broader than the narrow extraction comparison. ARBITER should borrow the structural return to the opening problem while keeping its own conclusion within observed agreement and inspectability.

**Critical non-transfer:** inter-model concordance is not truth, and agreement on an offered label is not accuracy. The JAMIA article evaluates extraction against a curated reference; ARBITER's conditional endpoint records which label two experts chose when arms differed. Similar branching diagrams do not make those estimands interchangeable. The publication-level split also cannot establish trial-level independence by itself; the paper's overlap sensitivity is precisely why that distinction matters.

## 2. Riaz first-author npj distillation paper

### OCAR and physical article order

Introduction ¶¶1–4 (`Sec1`) develop: need for clinical outcomes → longitudinal interpretation problem → sharing/privacy problem and teacher–student approach → unresolved distillation strategies and the specific comparison. The teacher–student idea is introduced because the preceding constraint makes it relevant. Results precedes Discussion and Methods in the published layout. **That physical placement is not a historical account of when experiments happened.** The Methods still provides the operational dependencies needed to interpret Results.

### Methods paragraph map

| Exact locator | Job |
| --- | --- |
| Methods introductory ¶1 (`Sec13`) | Reporting framework. |
| Primary patient cohort ¶¶1–2 (`Sec14`) | Defines source patients and linked records, then the timepoint-specific reference labels and two binary outcomes. |
| Core model architecture ¶1 (`Sec15`) | Patient-treatment unit → document tokens → document embeddings → timepoint pooling → longitudinal Transformer → numeric prediction. A long paragraph remains readable because it follows one transformation chain. Ends with implementation/access information. |
| Training and inference experiments ¶1 (`Sec16`) | Establishes teacher training, temporal-context ablation and patient-level train/validation/test split. |
| Same heading ¶2 | Constructs the in-domain public-data student: select relevant reports → teacher labels → sequences → freshly initialized student. |
| Same heading ¶¶3–4 | Introduces the out-of-domain comparison, explains why it tests a distinct question, then creates sequences compatible with the architecture. |
| Same heading ¶¶5–7 | Synthetic report generation → teacher relabeling and student training → student-only comparator omitting the teacher. “Next” and “Finally” denote operations within this described procedure. |
| Assessment of proxy datasets ¶1 (`Sec17`) | Operationalizes similarity between private and intermediary datasets. |
| Model evaluation ¶¶1–3 (`Sec18`) | Holds evaluation on the original private test population, excludes the trivial baseline timepoint, defines metrics, then subgroup analyses. |
| Differential privacy… ¶1 (`Sec19`); Vulnerability to membership inference attacks… ¶1 (`Sec20`) | Separate privacy-related experiments; the latter is explicitly post-hoc exploratory. |

The comparison is intelligible because the paper makes **what changes and what stays fixed** explicit: intermediary data and teacher involvement vary, while the target outcomes and evaluation population remain identifiable. ARBITER can use the same discipline for common input documents and model configuration versus different instructions and processing. It cannot borrow the component-attribution strength of an ablation design for its bundled workflow comparison.

### Results order and Methods correspondence

Results begins with the cohort and outcome prevalence (Results introductory ¶1, `Sec2`). **Distillation dataset alignment** (`Sec3`, ¶1) precedes model performance, even though the corresponding Methods assessment follows training experiments. This introduces a potentially relevant data property before the comparisons it helps readers interpret.

**Performance across training strategies** (`Sec4`, ¶1) establishes the reporting frame. The sequence is then teacher performance and removal of temporal context (`Sec5`, ¶¶1–2), MIMIC-IV student (`Sec6`, ¶1), Wiki-text student (`Sec7`, ¶1), and synthetic-data strategies (`Sec8`, ¶¶1–3). Within each strategy, the paper reports response and progression outcomes in a consistent order rather than making a separate section for every metric. The synthetic-data section moves from teacher-informed training to the weaker student-only strategy and then an explicitly post-hoc error analysis.

Demographic/cancer sensitivities (`Sec9`, ¶¶1–2) follow the main comparisons. Differential-privacy constraints (`Sec10`, ¶1) and attack experiments (`Sec11`, ¶1) then address the sharing premise. Discussion ¶1 (`Sec12`) states both the intended methodological contribution and that the models were not intended to replace RECIST annotations; subsequent paragraphs develop the pattern, future strategies, limitations and conclusion.

**Transferable:** establish the comparison frame once; keep a stable within-paragraph order; follow the main pattern with exceptions and boundary tests. **Do not transfer:** privacy assurance, performance magnitudes, causal interpretations of ARBITER components, or the distillation paper's documented post-hoc chronology. No ARBITER analysis may be described as prompted by an earlier result without author records supporting that history.

## 3. npj evidence-synthesis comparator: TrialMind

This paper supplies a useful adjacent structure, with **no Riaz authorship**. Paragraph locators below exclude figure captions. Its published physical order is Introduction → Results → Discussion → Methods.

### Paragraph jobs and order

| Exact locator | Structural job |
| --- | --- |
| Introduction (`Sec1`), ¶¶1–4 | Workload; cross-stage evaluation gap; pipeline; preview of evaluation. |
| Methods: Description of the TrialReviewBench dataset (`Sec11`), ¶¶1–7 | Figure overview; search; filtering; refinement; treatment categories; manual selection; final corpus. |
| Methods: `Sec12`, ¶¶1–7 | Defines prompting and workflow notation before implementation. |
| Methods: study search (`Sec13`), ¶¶1–6; screening (`Sec14`), ¶¶1–4; data extraction (`Sec15`), ¶¶1–3; result extraction (`Sec16`), ¶¶1–4 | Input → operation → intermediate output → next operation, in task order. |
| Methods: Experimental setup (`Sec17`), ¶¶1–6 | Search/screening metrics; criterion analysis; field checking; result checking/baselines; synthesis; raters. |
| Results: Creating TrialReviewBench (`Sec3`), ¶¶1–4; Build an LLM-driven system (`Sec4`), ¶1 | Establishes evaluation tasks and system before performance. |
| Results: retrieval (`Sec5`), ¶¶1–4; screening (`Sec6`), ¶¶1–5; extraction (`Sec7`), ¶¶1–8 | Follows workflow stages, then examines errors. |
| Results: human-AI collaboration (`Sec8`), ¶¶1–7 | Synthesis setup; preference; ratings; expertise; separate user-study procedure; quality/time findings. |

The transferable choice is to distinguish **output performance, preference and user benefit**. ARBITER has no equivalent user study. The published Results also contains procedural and interpretive material; its placement is not a template to copy uncritically. [Full published article](https://www.nature.com/articles/s41746-025-01840-7).

## 4. What OCAR and sequential prose actually require here

Schimel defines OCAR as functional story elements, not replacement section labels: [Writing Science, chapter 4, source line 338 onward](</home/ali/Documents/Code/skills/book-references/Schimel Joshua/Writing Science_ How to Write Papers t Cited and Proposals That Get Funded/index.html:338>), especially [§4.3, line 441](</home/ali/Documents/Code/skills/book-references/Schimel Joshua/Writing Science_ How to Write Papers t Cited and Proposals That Get Funded/index.html:441>). His [chapter 13, line 1458](</home/ali/Documents/Code/skills/book-references/Schimel Joshua/Writing Science_ How to Write Papers t Cited and Proposals That Get Funded/index.html:1458>) and [§13.1, line 1521](</home/ali/Documents/Code/skills/book-references/Schimel Joshua/Writing Science_ How to Write Papers t Cited and Proposals That Get Funded/index.html:1521>) explain how established information becomes the next unit's starting point. The principle is continuity of thought, not adding transition words to an unchanged list.

The local [clinical-research-writing skill](/home/ali/Documents/Code/skills/clinical-research-writing/SKILL.md), [manuscript workflow](/home/ali/Documents/Code/skills/clinical-research-writing/references/manuscript-workflow.md) and [revision guidance](/home/ali/Documents/Code/skills/clinical-research-writing/references/revision-and-coaching.md) translate this into clinical practice: one reader question per paragraph, precise units and references, distinct data/inference/interpretation, and structure before sentence polish. Its default primary-before-secondary Results order is a default; the author's requested exact-agreement-first exposition can be implemented while retaining explicit outcome hierarchy.

For ARBITER, use three kinds of connection accurately:

1. **Procedural:** stored documents supply quotations; recorded answers supply algorithm inputs; expert ratings are frozen before label choices. “Then” is justified when it describes these documented operations.
2. **Logical:** exact agreement answers whether labels match; signalling-answer comparisons examine intermediate judgments; rule checks assess internal consistency. Moving between these questions is an explanatory sequence, not a claim that one analysis happened because of another.
3. **Causal:** a workflow feature caused higher agreement, source linking prevented an error, or inspection reduced reviewer workload. These claims require evidence beyond this complete-workflow benchmark. Sequential prose must not smuggle them in through “therefore,” “because,” “led to,” or “as a result.”

The strongest transferable pattern is **need → defined task → common inputs and differing operations → comparison against named references → disagreement and boundary analyses → bounded interpretation**. The three exemplars support reader-oriented dependencies, not a universal published-label-first rule.

## 5. Concrete proposed ARBITER outline

### Introduction: four paragraph jobs

1. **Clinical opening:** RoB 2's place in judging trial evidence; assessment workload and the problem of keeping evidence current. Tie living evidence to motivation, using appropriate primary citations in a later manuscript revision. Do not claim ARBITER reduced that workload.
2. **Known approaches and the remaining problem:** synthesize prior automation by what it does and leaves uncertain, rather than inventorying products. Distinguish generating judgments, applying decision rules, retaining evidence and testing evidence support.
3. **Proposed solution:** introduce the full ARBITER name, the model/software division and retained assessment pathway. Explain how this addresses the specified problem without asserting that an inspectable record guarantees a sound interpretation.
4. **Challenge:** state the paired evaluation question, identify the same-model minimal-prompt comparison, and explicitly name conditional label choice as formally primary and full-cohort independent agreement as secondary. The objective should prepare both analyses without letting a reader mistake their denominators.

### Methods: develop the task before its measurements

The following are paragraph jobs, not a demand for thirteen separate subheadings. Combine adjacent jobs when they share one reader question.

1. **Design and evaluated task.** Orient the reader to a paired, single-run benchmark of complete workflows. Define the trial–domain cell and the specified result to assess. Distinguish the result-specific task from automatic selection of a trial's primary outcome.
2. **Benchmark construction.** Source reviews, table-order trial selection, availability and exclusions. Preserve missing review-selection facts and the unresolved exclusion rationale as author questions; do not supply a plausible sampling history.
3. **Published review labels.** Explain their extraction and possible target mismatch at first use. These labels are a comparison source, not a gold standard. Distinguish domain labels from the smaller observed Overall-label set.
4. **ARBITER pathway.** Documents → identified result → cited signalling answers → software-derived proposed ratings → adopted ratings and exported record. State model and software actors explicitly. Describe documented override rules where proposed/adopted ratings first diverge conceptually.
5. **Interactive use and illustration.** Explain the reviewer approval/inspection capability and distinguish the automated benchmark's unchanged acceptance of proposed targets. Keep AVATAR explicitly illustrative; put a long trace in the supplement.
6. **Paired comparator and execution.** Establish common underlying documents and configuration, then the different instructions, tools and processing. Identify evaluated revision, dates, run count, continuation allowance and limitations on immutable model identity. Templates and version detail can sit in eMethods. Do not describe this as an isolated test of rule enforcement or evidence linking.
7. **Independent expert procedure.** Qualifications/instructions/target alignment where documented, independent ratings and freezing, permitted source access. Keep unknowns visible. Original expert data and replacement full-coverage expert data must remain distinguishable wherever their provenance is discussed.
8. **Blinded label-choice and revised-rating procedure.** Only after the independent step: randomized offered labels without source identities/rationales → label choice → revised rating. This is a genuine procedural sequence and must survive any Results reordering.
9. **Outcome hierarchy and agreement analyses.** Open with the formal primary definition, its two selection conditions, equality-based credit and split sensitivities. Then define secondary all-cell exact agreement and paired differences against each independent expert, followed by supporting agreement coefficients and Published comparisons. A short hierarchy statement can precede this block; it need not be repeated throughout Methods.
10. **Signalling-answer analyses.** Five-level versus collapsed coding, component definition, matching and exclusion rules, and paired eligibility. This prepares the reader for different answer-level denominators and the adverse D3 result.
11. **Structural checks.** Rule conformance, evidence coverage, quotation/image source checks and audit-file checks, each with its counted object and limits. Define proposed/adopted rating checks separately. Structural integrity does not measure semantic evidence support.
12. **Computation and exploratory work.** Define runtime and API list-price equivalents, then label derived Overall, directional and rules-only analyses by their actual status. Place detailed algorithms in eMethods without losing denominator-defining rules.
13. **Uncertainty and reporting.** Trial-cluster resampling within the 16 fixed reviews, shared paired weights, interval construction and conditioning on these experts and runs. Preserve formal primary/secondary/exploratory status. Do not turn that status into an unsupported claim of prespecification or invent an original power rationale.

### Results: exact agreement first, reference order still provisional

**R1 — Benchmark and reference context.** Establish 102 trials, 16 reviews, 510 cells and independent coverage. Include the Published Low-label prevalence and all-Low comparison near the Published estimates; explain reference distributions through counts, not a methodological lecture. The 81-trial observed Published Overall subset belongs with Overall results, not the 510-cell domain comparison.

**R2 — Exact agreement against published review labels [proposed first reference].** Report ARBITER 386/510 (75.7%) versus Unassisted 395/510 (77.5%), paired difference −1.8 percentage points (95% CI, −5.1 to 1.6). The 83.7% Published Low-label prevalence makes the all-Low match material context. Do not call this evidence of equivalence or label it accuracy. Keep target correspondence qualifications in Methods and interpretation in Discussion.

**R3 — Exact agreement against independent experts.** Report Expert 1 separately: 371/510 (72.7%) versus 332/510 (65.1%), difference +7.6 points (95% CI, 5.1–10.2). Then Expert 2: 433/510 (84.9%) versus 400/510 (78.4%), +6.5 (3.5–9.4). Reference the expert-to-expert context, 388/510 (76.1%), without substituting an expert mean or consensus reference. Weighted κ can follow exact agreement or remain in the display; it should not displace the requested lead measure. If the author selects expert-first order, exchange R2 and R3, retaining reference-specific context with each.

**R4 — Conditional label-choice result, explicitly the formal primary endpoint.** Move from all assessed cells to the eligible subset transparently: 510 cells → 80 arm-discordant cells → 60 agreed expert label choices and 20 splits → 53/60 matching ARBITER (88%; 95% CI, 80–96%) and 7/60 matching Unassisted. Report 63/80 and 61/80 expert-specific matches and 53/80 split-as-loss sensitivity next to the primary estimate. Do not bury this endpoint in an appendix because its narrative position is later. Explain the denominator in Results without redoing the entire protocol.

**R5 — Domain variation.** Develop the pooled expert comparisons: D5's largest observed gains, D3's different expert-reference matches, and expert disagreement in D3. This qualifies the aggregate favorable expert pattern. It does not explain why Published and expert comparisons differ unless an analysis supports that explanation.

**R6 — Signalling answers and exploratory recomputation.** Show that agreement in final domain ratings and agreement in intermediate answers are distinct. Keep the adverse five-level D3 difference (−10.3 points; 95% CI, −17.2 to −3.2) alongside the collapsed +8.5 (3.5–13.7), both on 165 paired components. State changed denominators where relevant. Rules-only recomputation is exploratory and does not estimate the causal contribution of ARBITER's rules.

**R7 — Conformance and retained records.** Report algorithm conformance and source/record checks after the comparative judgments. Distinguish 510 outputs, 1538 active required answers, 1407 text spans, 14 image records and 102 assessment files. Place the semantic-support boundary in the same paragraph. These observations demonstrate which records passed which checks, not why expert agreement was higher.

**R8 — Computational burden.** Close the empirical sequence with runtime and reconstructed price equivalents. Median runtime 7.6 versus 0.5 minutes per trial describes computation, not reviewer time. Report API list-price equivalents as reconstructed quantities rather than expenditure. A workflow that requires more computation cannot be called more efficient for reviewers without a user evaluation.

This proposed sequence is **coverage → exact agreement by reference → selected-subset primary result → domain and intermediate-answer variation → structural properties → computational burden**. It gives readers the broad label comparisons before asking them to interpret a selected-subset percentage. The formal hierarchy remains visible in the objective, Methods, Results label and Discussion. Any later abstract revision must preserve that hierarchy too.

### Discussion: resolution at the width of the opening

1. Answer the question with the reference-dependent pattern: greater agreement with both independent experts, a different Published-label contrast, and the explicitly conditional primary result. Synthesize rather than replay every count.
2. Explain what the retained pathway exposes and what it does not establish. Separate executable-rule consistency, source provenance and semantic justification.
3. Relate the finding to prior workflow evaluations at the correct task level. Do not transfer extraction accuracy, preference ratings or reviewer time savings from another system.
4. Bound inference: complete-workflow comparator, target correspondence, selection, expert procedures, single runs, fixed reviews and unresolved development/specification history.
5. Return to experienced evidence reviewers: an inspectable proposed assessment can be examined and corrected, while evidence-support validation and reviewer-use benefit require direct evaluation. Close on the supported contribution, without promising autonomous appraisal or living-review effectiveness.

## 6. Sample prose showing the intended connections

These are candidate sentences for discussion, not edits to the canonical manuscript.

**Methods, object continuity:** “ARBITER retains the supplied trial documents and links each required signalling answer to a passage or image. Software applies the RoB 2 algorithms to the recorded answers to compute proposed domain ratings. The exported report preserves the answers, cited evidence and adopted ratings for inspection.”

**Methods, genuine sequence:** “Each expert independently recorded and froze domain ratings before seeing the offered labels. The expert then chose among labels displayed in randomized order without source identities or rationales. Independent ratings and subsequent label choices were analyzed separately.”

**Results, reference change without invented chronology:** “Against published review labels, exact agreement was 75.7% for ARBITER and 77.5% for Unassisted. Against the two independent experts, ARBITER had greater agreement, with paired gains of 7.6 and 6.5 percentage points.” The full paragraphs must retain the counts and CIs specified above. Avoid “Published agreement was poor, so we recruited experts”: that would invent a causal history.

**Results, changing population:** “The formal primary endpoint concerned cells in which the arms disagreed and both experts chose the same label. The arms differed in 80 cells; experts agreed on 60 choices and split on 20. Of the agreed choices, 53 matched ARBITER.” The next sentence supplies the estimate and interval. Avoid “Experts confirmed 88% accuracy” or “Experts preferred ARBITER's reasoning.”

**Transition to the audits:** “The record checks assessed rule conformance and source provenance.” This changes the question explicitly. Avoid “These gains resulted from complete evidence linkage”: no component experiment establishes that link.

## 7. Acceptance checks before any later manuscript rewrite

- Confirm the Published-versus-independent-expert reference order; exact agreement remains the leading substantive measure either way.
- Preserve the independent-rating → offered-label choice → revised-rating procedure, regardless of narrative order.
- Keep conditional primary status and the 80 → 60/20 → 53 pathway explicit; never convert label matching to accuracy, system endorsement or reasoning preference.
- Preserve the unfavorable Published contrast and adverse five-level D3 answer result beside the favorable expert pattern.
- Keep target uncertainty, missing author facts, development overlap and specification chronology unresolved until records answer them.
- Do not attribute a coauthored paragraph or an adjacent non-Riaz article to Riaz's personal preferences.
- Treat tables above as analytic maps of inspected prose, not a requirement to copy another journal's layout, every repeated statistic, or its breadth of interpretation.

Only this memo was authored for the present task. No canonical manuscript, literature ledger, cache file or analysis artifact was changed; no git operations or agents were used.
