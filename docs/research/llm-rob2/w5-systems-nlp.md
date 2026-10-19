# Systems and NLP literature: LLM-assisted risk-of-bias assessment

## Šuster et al. 2024, Research Synthesis Methods: Zero- and few-shot prompting

- **DOI / IDs**: 10.1002/jrsm.1749; PMID 39176994.
- **Full text read**: yes; Wiley full text including appendices/online material.
- **Design**: Benchmark study of direct prediction and decomposed signalling-question prompting; not described as preregistered.
- **Sample**: Cochrane-derived data; direct prediction test set n=5,993. The paper also uses a smaller RoB 2 question/answer dataset for decomposed assessment and experiments varying available article text. See Methods and Results.
- **Tool**: RoB 2, compared with direct RoB prediction and question-answer decomposition. The model is given assessment instructions; the work tests whether prompting alone makes general models useful.
- **Models and dates**: Generative LLMs including GPT-3.5 variants and Flan-T5 XL variants; paper reports model-specific setup in Methods and experiments conducted against then-current versions (see Methods, model details). Do not treat results as current model performance.
- **Inputs**: Trial report text, with full-paper input explored where context length permitted; Cochrane-derived question/answer and labels used as training/evaluation data. Protocol/registry inputs are not the central setup.
- **Prompting / system design**: Direct RoB 2 label prediction versus “decomposition”: LLM answers signalling questions and the RoB decision follows. Prompted QA, not agent/tool use or retrieval system.
- **How domain judgements were produced**: Decomposition explicitly makes the RoB decision after signalling answers. The article distinguishes this task from direct label prediction; it does not establish an independently validated, official RoB 2 algorithm server that computes labels from the answers. Treat its decomposition method as prompt/task decomposition, not evidence of ARBITER-style enforcement.
- **Rule-consistency checked?**: No reported independent check that the model’s domain label follows the RoB 2 algorithm given its answers.
- **Evidence handling**: The task concerns answers and labels; no answer-to-quote binding against a frozen source, quote verification, or auditable source record is described.
- **Reference standard**: Cochrane review labels/annotations. Authors acknowledge the data do not include lengthy excerpts from the primary studies or Cochrane reviews; no correction/adjudication of reference-label error is reported.
- **Adjudication of disagreements**: No blinded expert adjudication of model-versus-review disagreements reported.
- **Headline results**: Direct RoB 2 prediction test set n=5,993 yielded F1 around 0.1–0.2 (paper abstract/results); zero/few-shot LLM performance was weak. For decomposition, consult the paper’s task-specific result tables; results vary by domain and setup. No basis for claiming model judgements are algorithm-consistent.
- **Repeatability, time, cost**: No operational time/cost comparison central to the paper. Dataset release supports reuse, but model outputs remain dependent on prompt/model/version.
- **Authors' stated limitations**: Dataset “does not include lengthy text excerpts from either primary studies or Cochrane reviews” (Discussion/limitations).
- **Authors' conclusions**: Prompting general LLMs alone gives weak RoB 2 assessment; decomposing into signalling questions does not by itself solve the problem.
- **Quotable sentences**:
  - “We distinguish between two modelling tasks: directly predicting RoB2 from text; and employing decomposition, in which a RoB2 decision is made after the LLM responds to a series of signalling questions.” (Abstract, Wiley full text)
  - “On the direct RoB2 prediction test set (n = 5993), LLMs perform akin to the baselines (F1: 0.1-0.2).” (Abstract)
  - “This data set does not include lengthy text excerpts from either primary studies or Cochrane reviews” (Discussion, dataset limitation)
- **Bearing on G1–G5**: G1 supports gap (decomposition studied, but no independent code algorithm or rule-consistency audit); G2 supports gap (no verified answer-to-source citation/audit); G3 supports gap (Cochrane labels used without adjudicating their error); G4 supports gap (no blinded disagreement adjudication); G5 supports gap (prompting rather than an agent operating tools against a verification server).
- **Implication for ARBITER manuscript**: Cite as evidence that decomposed QA has already been tried, so distinguish ARBITER by externally enforced computation and source-bound answer checking, not by decomposition alone. Note the weak performance and reference-label limitations.

## Hevia et al. 2025, EMNLP Demonstrations: ROBoto2

- **DOI / IDs**: arXiv:2511.03048; EMNLP 2025 demo paper.
- **Full text read**: yes; arXiv HTML, including method, evaluation, limitations and appendices.
- **Design**: Interactive system paper plus dataset and model/retrieval evaluation. Not preregistered (not stated).
- **Sample**: 521 pediatric trial reports and 8,954 signalling-question instances; 1,202 evidence passages. The manually assessed evaluation subset comprises 245 reports; 276 additional reports used LLM-assisted annotation. Twenty reports (440 questions) were double annotated for reliability (Methods, Dataset; Results).
- **Tool**: RoB 2. The system elicits signalling-question answers and applies RoB 2 flowchart logic to generate domain and overall ratings.
- **Models and dates**: Evaluation includes Llama-3.3-70B-Instruct, GPT-3.5-Turbo, GPT-4o and Claude 3.5-Sonnet. Original assisted annotation used GPT-3.5-Turbo-0125 and retrieval (early 2024); versions/settings are specified in Methods.
- **Inputs**: Uploaded trial PDF parsed into paragraphs; within-document retrieval supplies evidence to per-question prompts. Full-text context and oracle/human evidence passages are compared experimentally. No registry/protocol integration described.
- **Prompting / system design**: RAG-like within-document retrieval; one QA step per RoB 2 signalling question; interactive human review, edits and feedback. Not an autonomous agent using external tools.
- **How domain judgements were produced**: RoB 2 logic is implemented in software after question answers: “The final risk assessment is produced by implementing the flowchart logic provided by the ROB2 tool.” (System pipeline, answering questions/domain judgement sections). This directly contradicts a broad G1 claim that no prior system computes domain ratings from answers in code. It does not report ARBITER-style rejection of incomplete/unbound answers or an independent consistency audit.
- **Rule-consistency checked?**: Flowchart computation is part of system design. No separate measured rate of model-produced judgement contradictions is reported; model provides question answers and software derives rating.
- **Evidence handling**: Retrieved passages are displayed and users may add passages, vote on retrieval, and edit answers/rationales. System preserves original LLM response/rationale and user-confirmed/edited version for dataset. Evidence is not described as verified against an immutable stored copy, nor as a tamper-evident independently checkable audit log.
- **Reference standard**: 245 expert manual assessments using the Cochrane ROB2 Excel tool with macros; five expert annotators with relevant graduate training and systematic-review experience. A subset of questions has manually copied supporting evidence. Inter-rater kappa on 20 double-coded papers was 0.40 across four aggregated response classes (Results). The paper acknowledges expert disagreement and the possibility that viewing model outputs biases annotations. No correction against a separate blinded adjudication standard.
- **Adjudication of disagreements**: No blinded expert adjudication of disagreements between model and published labels. Human review is integral to the assisted workflow, but is not the ARBITER-versus-review-label blinded design.
- **Headline results**: Four LLMs remain overly conservative versus human reviewers, often choosing High risk or No Information despite evidence; larger context and more evidence mitigate this. Results report item and domain F1, retrieval recall and comparisons to manual assessments, rather than one overall kappa. Manual inter-rater kappa 0.40 (20 papers/440 questions). See Results & Discussion, tables.
- **Repeatability, time, cost**: ROBoto2 publicly available with code/data. The paper discusses potential efficiency but does not establish a controlled end-to-end time/cost advantage; model/retriever selection includes low-cost settings.
- **Authors' stated limitations**: The authors identify risk of model-output exposure biasing annotations, dataset imbalance, potential quality/efficiency gains needing further assessment, and limited diversity of models.
- **Authors' conclusions**: ROBoto2 is an interactive human-AI workflow and benchmark; full automation remains challenging and users should review/correct model suggestions.
- **Quotable sentences**:
  - “The final risk assessment is produced by implementing the flowchart logic provided by the ROB2 tool.” (System pipeline, Domain-level and overall judgments)
  - “We measure risk of bias of randomized trials using the Cochrane ROB2 tool.” (Methods)
  - “retains the original LLM responses and rationales, as well as the versions confirmed or edited by expert users.” (System implementation / feedback capture)
  - “LLMs remain overly conservative compared to human reviewers, frequently opting for high-risk or ‘No Information’ judgments even when evidence is present.” (Abstract/Results)
- **Bearing on G1–G5**: G1 **contradicted in its broad form**: software applies RoB 2 flowchart logic after answer generation; however no reported consistency audit or completeness rejection. G2 partly addressed: evidence passages and original/revised outputs are retained, but no immutable source binding, quote verification, or external audit trail reported. G3 supported: manual assessments are reference and their reliability is modest; no estimate of published-label error/correction. G4 supported: no blinded adjudication of arm disagreements. G5 partly contradicts: interactive system, retrieval, and flowchart logic exist; it is human-in-the-loop web software rather than a tool-using agent with a separate verifier/server.
- **Implication for ARBITER manuscript**: Explicitly credit ROBoto2 for the closest precedent: retrieved evidence passages, interactive correction, and coded RoB 2 flowchart application. Narrow the novelty claim to verified binding against stored originals, strict validation/rejection, independently checkable audit, and comparative adjudication/reference-noise analysis.

## Li, Mathrani & Susnjak 2025, arXiv: GEPA-trained programmatic prompting

- **DOI / IDs**: arXiv:2512.01452.
- **Full text read**: yes; arXiv HTML, including appendices and results.
- **Design**: Method-development and evaluation study using prompt optimization and manually authored prompt comparisons; not preregistered (not stated).
- **Sample**: 100 English-language RCTs randomly sampled from ten meta-analyses (111 initially identified); clinical areas include cardiovascular, metabolic, women’s health and pediatrics. Seven RoB 1 domains (Methods, Table 1).
- **Tool**: Original Cochrane RoB 1, not RoB 2.
- **Models and dates**: Open-weight pair Mistral Small 3.1 plus GPT-oss-20b; commercial pair GPT-5 Nano and GPT-5 Mini. Manual-prompt comparison used Claude 3.5 Sonnet. Model versions reported in Methods.
- **Inputs**: Full-text RCT reports. No explicit protocol/registry/supplement integration reported.
- **Prompting / system design**: DSPy/GEPA programmatically optimizes domain-specific prompts; structured modular pipeline and inspectable execution traces. LLM produces domain judgments, not an autonomous evidence-retrieval agent.
- **How domain judgements were produced**: Model outputs Low/High/Unclear labels. The framework makes prompt optimization and execution inspectable, but the paper does not describe applying an official RoB algorithm in code to model signalling answers; this is RoB 1 and domain-level predictions.
- **Rule-consistency checked?**: No reported test that domain ratings conform to a separate RoB decision algorithm.
- **Evidence handling**: Full texts are input, but no verified quotations, source passage binding, immutable storage, or audit trail for evidence is described. “Inspectable execution traces” refer to optimization/prompt execution, not a source-provenance audit for each rating.
- **Reference standard**: Authors’ RoB 1 judgments in the source meta-analyses, called “Gold Labels”; no reliability assessment or adjudication of reference error. They note imbalance in gold label distribution (notably Domain 6; Results).
- **Adjudication of disagreements**: No expert adjudication of model/reference disagreements.
- **Headline results**: Commercial models generally achieved higher overall accuracy and domain consistency than open-weight pair. GEPA prompts exceeded three manual prompts with Claude 3.5 Sonnet, particularly improving random sequence generation and selective reporting by 30–40% (Abstract/Results). Results compared to imbalanced meta-analysis labels, not an independently adjudicated standard.
- **Repeatability, time, cost**: Authors report computational efficiency and affordability in Table 3. GEPA generates inspectable/reproducible prompt traces; no human assessment-time comparison or source audit.
- **Authors' stated limitations**: Treat as preliminary (“A First Look”); evaluation limited to 100 trials, RoB 1 and the selected labels/models. See Limitations.
- **Authors' conclusions**: GEPA offers a structured and reproducible way to optimize prompts, with competitive classification performance, but the work does not establish faithful/verified evidence chains or algorithm enforcement.
- **Quotable sentences**:
  - “GEPA refines LLM reasoning through Pareto-guided search and produces inspectable execution traces, enabling transparent replication of every step in the optimization process.” (Abstract)
  - “Full-text RCTs constituted the textual corpus for automated RoB evaluation, with author-reported RoB 1 judgments from the original meta-analyses acting as the initial human reference standard” (Methods, Study design)
  - “the gold-standard label distribution was markedly imbalanced in several domains” (Results)
- **Bearing on G1–G5**: G1 supports gap (prompt optimization, no coded RoB algorithm); G2 supports gap (traces are not verified evidence provenance); G3 supports gap (review labels as gold, no reliability correction); G4 supports gap; G5 supports gap (programmatic prompting is not an agentic tool workflow).
- **Implication for ARBITER manuscript**: Distinguish computationally reproducible prompting traces from a verifiable audit of source evidence and deterministic rules. Also emphasize RoB 1 and label imbalance when comparing.

## Dias et al. 2025, Journal of Biomedical Informatics: RoBIn

- **DOI / IDs**: arXiv:2410.21495; published as “RoBIn: A Transformer-based model for risk of bias inference with machine reading comprehension,” Journal of Biomedical Informatics (2025; DOI shown by publisher record; verify exact DOI before citing).
- **Full text read**: yes; arXiv HTML full paper.
- **Design**: Dataset construction and transformer model development/evaluation; automated NLP rather than conversational LLM assessment.
- **Sample**: Automatically annotated open-access clinical-trial corpus of about 2,200 reports; RoBIn reports MRC and inference experiments. Uses a Cochrane-derived dataset and primarily RoB 1-style bias categories/questions (Methods/Results).
- **Tool**: RoB 1/legacy Cochrane categories and binary low vs high/unclear classification; not RoB 2 domain algorithms.
- **Models and dates**: Extractive RoBInExt and generative RoBInGen transformer variants; benchmarked against traditional ML and LLMs, including ChatGPT/Claude settings.
- **Inputs**: Trial-report text segmented into sentences/contexts; question and context used for evidence extraction and classification.
- **Prompting / system design**: Machine reading comprehension: retrieve/extract evidence sentence, then classify. LLM baselines prompted for question answer and supporting excerpt; no agent or external tools.
- **How domain judgements were produced**: Learned classifier predicts binary RoB from extracted evidence, rather than official RoB 2 code applying signalling answers.
- **Rule-consistency checked?**: No RoB 2 algorithm consistency test.
- **Evidence handling**: Evidence sentence extraction is a core model task and is an advance over label-only classification. However the dataset authors note source linkage limitations: review evidence may be reviewer commentary and is not always explicitly linked to a corresponding passage in the cited primary article. No immutable-source verification/audit trail.
- **Reference standard**: Cochrane Database of Systematic Reviews labels and supporting text used as distant supervision. Authors explicitly note limitations in linking supporting sentences to the cited article and the presence of reviewer comments. This is label noise/provenance risk, not adjudicated human correction.
- **Adjudication of disagreements**: No blinded expert adjudication.
- **Headline results**: Best RoBIn variants achieved ROC AUC 0.83 in most settings and often beat traditional ML and LLM baselines (Abstract). False positives can mean high/unclear trials misclassified low risk (Discussion).
- **Repeatability, time, cost**: Dataset is public; no human time/cost evaluation central to work.
- **Authors' stated limitations**: Distant supervision, imperfect linkage between extracted reviewer evidence and trial passages, binary collapsing of high/unclear, and class imbalance are limitations discussed in the paper.
- **Authors' conclusions**: Evidence extraction plus classification is useful for automated RoB inference, while evidence provenance and data quality remain challenges.
- **Quotable sentences**:
  - “The model employs a dual-task approach, extracting evidence from a given context and assessing the RoB based on the gathered evidence.” (Abstract)
  - “This absence of direct connections between references and supporting sentences might pose challenges for traceability and verification in the annotation process.” (Dataset creation)
  - “RoBIn performs a binary classification to decide whether the trial is at a low RoB or a high/unclear RoB.” (Abstract)
- **Bearing on G1–G5**: G1 supports gap (learned classifier; no RoB 2 algorithm); G2 partially addressed in evidence extraction but supports gap in verified provenance; G3 supports gap and explicitly exposes reference annotation traceability issues; G4 supports gap; G5 supports gap.
- **Implication for ARBITER manuscript**: RoBIn shows that evidence extraction is established NLP work, so avoid claiming novelty for evidence passages alone. Emphasize verification against the actual stored source and deterministic answer-to-rating enforcement.

## Ji et al. 2025, COLING: RoBGuard

- **DOI / IDs**: COLING 2025, pages 1258–1277; ACL Anthology paper `2025.coling-main.84`.
- **Full text read**: yes; ACL Anthology full PDF.
- **Design**: Framework and dataset development with experiments.
- **Sample**: RoB-Item: 53 RCTs with item-level answers/rationales; RoB-Domain: 319 RCTs with domain labels. (Paper, dataset construction.)
- **Tool**: RoB 2.
- **Models and dates**: RoBGuard framework evaluated with Llama-3-8B and GPT-4o; compare vanilla models.
- **Inputs**: Multimodal parsing of trial documents including text, tables, and flowcharts.
- **Prompting / system design**: Medical-knowledge-based question reformulation, multimodal document parsing, and multi-expert LLM collaboration; staged reasoning rather than one simple prompt.
- **How domain judgements were produced**: Framework combines LLM reasoning/collaboration and predicts item/domain outcomes. No evidence in the paper of an independent deterministic implementation of the official RoB 2 flowchart for enforcing final ratings from validated answers.
- **Rule-consistency checked?**: No distinct algorithm-consistency metric reported.
- **Evidence handling**: Item-level rationales and multimodal information are used; no verified quote-to-immutable-source binding or independent audit trail described.
- **Reference standard**: Dataset labels are constructed from trial/review sources and expert annotation processes described in the paper. This is a curated benchmark, but not a study of published-label error with blinded adjudication.
- **Adjudication of disagreements**: Multi-expert collaboration is part of the model framework; not blinded human adjudication between model arm and published review labels.
- **Headline results**: RoBGuard improves over Llama/GPT-4o baselines on most items; for item 5.2, accuracy 0.91 vs Llama 0.34. Domain-level improvements are reported, with variation by item (Results, Tables 2–3).
- **Repeatability, time, cost**: Code/data announced for release; authors identify computational overhead and consensus logic as areas for improvement.
- **Authors' stated limitations**: Multi-step reasoning can add complexity or misinterpret evidence; computational overhead and edge cases in expert-agent disagreement remain (Discussion).
- **Authors' conclusions**: Medical knowledge, multimodal inputs, and collaboration can improve LLM assessment, but do not remove item-level errors.
- **Quotable sentences**:
  - “RoBGuard integrates medical knowledge-enhanced question reformulation, multimodal document parsing, and multi-expert collaboration” (Abstract)
  - “In item 4.3, RoBGuard does not outperform the baselines” (Results, item-level evaluation)
- **Bearing on G1–G5**: G1 supports gap (no deterministic official algorithm enforcement demonstrated); G2 supports gap (rationales, not verified bound citations); G3 partly supports gap (benchmark labels, no reference-noise correction); G4 supports gap (multi-agent consensus is not blinded expert adjudication); G5 partly contradicts simplistic single-prompt claim (multi-expert LLM collaboration), but not server-mediated evidence-verification agent design.
- **Implication for ARBITER manuscript**: Acknowledge multi-step and collaborative LLM systems. ARBITER’s distinguishable contribution is external deterministic enforcement and verifiable source provenance, evaluated against adjudication that recognizes noisy published labels.

## Additional relevant system papers located

**Pitre et al. 2024, medRxiv, “ChatGPT for assessing risk of bias of randomized trials using the RoB 2.0 tool: A methods study.”** This is an additional RoB 2 prompting study, cited by the above systematic review and papers. I did not obtain a complete paper text in this search, so do not rely on it for detailed claims here. It appears to use prompted ChatGPT assessments and published/human assessments as comparison; full text should be checked before drawing conclusions about algorithm computation, evidence citations, or adjudication.

**Lai et al. 2025, npj Digital Medicine, “Language models for data extraction and risk of bias assessment in complementary medicine.”** Peer-reviewed full text located. This evaluates language models on extraction and RoB in complementary-medicine reviews and includes human review; it is a prompt-based workflow rather than a source-verifying agent. Not included as a full extraction because the assigned paper set is already covered and the study’s modified RoB instrument is not directly comparable to RoB 2. It should be considered in broad related-work coverage.

**Lai et al. 2024, JAMA Network Open, “Assessing the Risk of Bias in Randomized Clinical Trials With Large Language Models.”** Full text and supplements read. Study assessed 30 RCTs from three reviews with modified Cochrane domains, using ChatGPT and Claude (two assessments each); three senior experts independently rated and resolved their own disagreements by consensus to create criterion standard. The model was given converted trial text and a carefully iterated prompt, not protocol/registry/supplements; it itself stated domain answers. It used model judgments against the consensus standard and measured correctness/repeatability, but no coded algorithm or source-quote verification. This is non-RoB-2 modified-tool work, so it is secondary precedent. Exact full-text details and supplements at JAMA article DOI 10.1001/jamanetworkopen.2024.12687.

**Scope note:** Search across arXiv, ACL Anthology and medRxiv located the above systems, RoBIn, RoBGuard, Pitre et al., and ROBUST-RCT/ROBUST feasibility work. I did not find a 2024–2026 RoB 2 system explicitly using MCP or a separate quote-verification server. “RoBIn” is a 2025 journal publication/preprint and is an NLP model rather than an LLM agent.

## Worker summary

The strongest qualification is ROBoto2: it already combines retrieved evidence passages, human editing, and code implementing RoB 2 flowchart logic. Therefore G1 and G5 must be narrowed; they are not wholly absent from prior work. What remains unreported there is ARBITER’s stricter answer validation, verification of every passage against an immutable source, independently checkable audit record, and quantified rule-consistency. Šuster, GEPA, RoBIn, and RoBGuard support the narrower gaps around source verification and/or algorithm enforcement. Published/Cochrane labels remain common references, while RoBIn explicitly identifies evidence-to-source linkage problems and ROBoto2 measures only modest expert inter-rater agreement; none of the core system papers performs ARBITER-style blinded adjudication of disagreements and reference-label error analysis. No paper found in this search reports MCP-based assessment.
