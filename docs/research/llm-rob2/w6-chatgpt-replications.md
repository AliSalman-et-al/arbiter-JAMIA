# ChatGPT replications and related LLM RoB studies

## Rose et al. 2025, Cochrane Evidence Synthesis and Methods: ChatGPT-4o agreement with human reviewers

- **DOI / IDs**: 10.1002/cesm.70048; PMID 41050682; PMCID PMC12442625.
- **Full text read**: Yes; Europe PMC full-text XML (including methods, results, discussion, and references). Supporting-information link is present; its detailed contents were not separately retrieved.
- **Design**: Prespecified, peer-reviewed protocol; agreement study. 100 Cochrane review–trial pairs were sampled, 25 for prompt development and 75 for evaluation.
- **Sample**: One trial sampled from each eligible Cochrane review. Evaluation set: 75 trials from 75 reviews across 35 review groups. All reviews used RoB1. Trials span 1977–2021. Primary endpoint overall RoB; exploratory domain endpoint randomization.
- **Tool**: Cochrane RoB1, despite the paper title’s broad “risk of bias” wording; not a RoB2 domain assessment study.
- **Models and dates**: GPT-4o, February 2025. Prompt development June–October 2024.
- **Inputs**: Trial methods section only, manually copied from HTML or PDF. No full reports, protocols, supplements, statistical plans, or ancillary reports. Authors retained copy artefacts. Each evaluation used a new chat; ChatGPT users were not blinded to the published human labels.
- **Prompting / system design**: One selected prompt, developed iteratively on 25 cases; candidate prompts included RoB2 flowcharts/guidance and signaling questions. Simpler prompts appeared to work better. No agent, RAG, or tools.
- **How domain judgements were produced**: ChatGPT was asked to state overall RoB and randomization-domain ratings itself. It was not asked for a full set of RoB2 signaling answers with code-based application of the RoB2 algorithm.
- **Rule-consistency checked?**: No algorithmic consistency audit reported; not a RoB2 application.
- **Evidence handling**: Input text was copied and pasted. Full model responses were saved, but no passage citations or verification against a stored source were required/reported; no evidence audit trail.
- **Reference standard**: Consensus-based Cochrane review labels by independent reviewers. The paper explicitly discusses human-human agreement and uses it as a comparator, reporting prior agreement range of 16%–81% and higher-end estimates around 80%. It does not re-adjudicate or estimate correctness of the reference labels. Human labels themselves had been reached through consensus/adjudication within reviews.
- **Adjudication of disagreements**: Not for the study’s human–ChatGPT disagreements. Review screening disagreements were settled by consensus or third author, but that is separate.
- **Headline results**: Overall human–ChatGPT agreement 50.7% (95% CI 39.3–62.0), Cohen’s κ=0.215 (0.072–0.359; slight). Randomization agreement 78.7% (69.4–88.0). ChatGPT–ChatGPT overall agreement 74.7% (64.8–84.6). Overall results did not use kappa to compare diagnostic accuracy; ChatGPT tended toward low ratings on some cases. Human labels were the comparator, not an error-corrected gold standard.
- **Repeatability, time, cost**: Duplicate independent ChatGPT ratings; the paper reports ratings in seconds and uses them to motivate efficiency, but no cost estimate.
- **Authors' stated limitations**: Only overall and randomization assessments were studied; the model saw methods text alone. They also note possible training-data recall of Cochrane ratings.
- **Authors' conclusions**: GPT-4o had nontrivial agreement, but overall agreement was below the highest reported human-human agreement; LLMs may help streamline evidence synthesis.
- **Quotable sentences**:
  - “We assessed agreement between human consensus‐based RoB assessments of trials obtained from Cochrane reviews and RoB assessments made by ChatGPT using trial methods text.” (Methods)
  - “The main limitations of the study are that we only studied agreement for ‘Overall RoB’ and ‘RoB due to the randomization process’” (Discussion, Strengths and Limitations)
  - “We hope our work illustrates how researchers might assess potential future AI developments, such as agentic AI” (Discussion)
- **Bearing on G1–G5**:
  - **G1 supports**: model directly states ratings; no algorithmic derivation or rule-consistency test.
  - **G2 supports**: no verified citations, immutable source, or audit record.
  - **G3 supports**: Cochrane consensus labels used as comparator without validation.
  - **G4 supports**: no blinded expert adjudication of model/reference disagreements.
  - **G5 supports**: chat prompt workflow; agentic tools are described as future work.
- **Implication for ARBITER manuscript**: This study is a useful human-comparator point, but its RoB1 overall/randomization endpoints and methods-only input make it a different target than outcome-specific RoB2 signalling-question inference. Its explicit human-human benchmark strengthens the case for not treating a single published label as unquestioned truth.

## Descamps et al. 2025, Journal of Evidence-Based Medicine: replication and comparative analysis

- **DOI / IDs**: 10.1111/jebm.70046; PMCID PMC12174634.
- **Full text read**: Yes; Europe PMC full-text XML, including tables and supporting-information descriptions.
- **Design**: Letter/replication of Kuitunen et al. on the same 100 RCTs; compares original GPT-4o outputs, a new GPT-4o run, GPT-4o through a commercial document framework, and o1. No preregistration reported.
- **Sample**: Same 100 RCTs / six reviews from Kuitunen; five duplicated articles occurred in the parent sample. Five RoB2 domains plus overall rating.
- **Tool**: Cochrane RoB2; ratings against published review assessments.
- **Models and dates**: GPT-4o as originally reported by Kuitunen; GPT-4o new iteration (“4o-new”); GPT-4o with DeepDocs DAM Assess Version 1.25.01 (“4o-fram”); OpenAI o1. The letter reports updated model comparison but does not give precise run dates in the text.
- **Inputs**: ChatPDF/full-text PDF in Kuitunen; for 4o-fram, OCR-converted full-text PDFs represented as linked JSONL files, subsequently structured in Excel. The precise access to supplementary trial material is not established in this letter.
- **Prompting / system design**: Replicated standardized short prompt; the 4o-fram is a multi-step document-processing framework with an evaluation grid and structured table output. No agent/server or explicit signaling-question workflow described.
- **How domain judgements were produced**: LLM directly generated domain and overall labels. Authors point out that overall RoB is algorithmically determined from domain ratings and “does not necessarily require a generative LLM”; they do not report code applying RoB2’s algorithm to model answers.
- **Rule-consistency checked?**: No check that the stated overall judgement follows the RoB2 domain algorithm.
- **Evidence handling**: 4o-fram used full text and a structured evaluation grid; no claim that quotations were verified against a stored immutable source or that an audit trail was independently checkable. Kuitunen supplement has assessments, but not a passage-verification system.
- **Reference standard**: Published assessment labels from the original dataset, treated as ground truth. They note human RoB assessments across reviews can disagree (citing 57%–81% human agreement) but do not adjudicate/reference-correct the labels.
- **Adjudication of disagreements**: None reported.
- **Headline results**: Fleiss κ for original GPT-4o ranged from −0.13 to 0.31 across domains; new GPT-4o −0.29 to −0.05 (overall −0.07); 4o-fram −0.07 to 0.37 (overall 0.01); o1 −0.16 to 0.11 (overall −0.16). Raw global agreement: 67%, 38.83%, 68.83%, and 54.17%, respectively. They highlight same-paper, different-output instability and improved agreement for 4o-fram in several domains. These are agreement metrics, not adjudicated accuracy.
- **Repeatability, time, cost**: Demonstrates output variability across model iterations; no time or cost comparison. Framework requires specialized processing infrastructure and full text.
- **Authors' stated limitations**: Same 100 cases limits generalizability; no weighted Fleiss κ due to reproducibility challenges; did not analyze reasons for disagreement; 4o-fram requires full text and infrastructure.
- **Authors' conclusions**: Structured frameworks may improve reliability/precision, while model/protocol variation remains a reproducibility concern.
- **Quotable sentences**:
  - “The rule‐based determination of the overall RoB (low/some concerns/high) from domain‐specific ratings itself is algorithmic and does not necessarily require a generative LLM for completion” (Introduction)
  - “The variability between the original 4o and our 4o-new outputs likely reflects intrinsic fluctuations in LLM responses” (Results)
  - “Finally, our evaluation focused primarily on agreement metrics rather than exploring the underlying reasons for disagreements” (Limitations)
- **Bearing on G1–G5**:
  - **G1 supports**: direct model judgments; authors explicitly recognize the opportunity to make overall classification algorithmic, but do not implement it.
  - **G2 partly contradicts / mostly supports**: full-text OCR and structured output are a meaningful input-processing framework, but no evidence binding/verification or audit trail is reported.
  - **G3 supports**: label disagreements are acknowledged, but labels remain the benchmark.
  - **G4 supports**: no blinded disagreement adjudication.
  - **G5 partly contradicts**: multi-step document framework goes beyond a bare chat prompt, but is not an agent using tools/server-enforced evidence and rules.
- **Implication for ARBITER manuscript**: This is important prior work for the claim that structured ingestion can improve agreement, and for output instability. Distinguish ARBITER’s rule execution and quote verification from 4o-fram’s OCR-to-table structuring.

## Kuitunen et al. 2024, Journal of Evidence-Based Medicine: ChatGPT-4o performance

- **DOI / IDs**: 10.1111/jebm.12662; PMCID PMC11684499.
- **Full text read**: Yes; Europe PMC full-text XML. Supplementary file is cited and contains trial-level comparisons.
- **Design**: Prespecified OSF protocol (10.17605/OSF.IO/J67W4); evaluation of agreement with published reviews.
- **Sample**: 100 RCTs from six recent meta-analyses in The Lancet, JAMA, or BMJ. Human reference ratings extracted by a third author; model ratings entered by another author.
- **Tool**: Cochrane RoB2, main trial outcome, five domains plus overall.
- **Models and dates**: ChatGPT-4o available at study time; exact model snapshot/run date not specified.
- **Inputs**: Each RCT PDF uploaded to ChatGPT with a standardized short prompt. Prompt asks for RoB2 analysis of the main outcome and labels for domains 1–5 and overall. No registry/protocol inputs described.
- **Prompting / system design**: Single short prompt naming RoB2. No reported signaling-question-by-question response, RAG, agent, or external tool.
- **How domain judgements were produced**: ChatGPT directly returned labels; no code applies the domain or overall RoB2 algorithm.
- **Rule-consistency checked?**: No.
- **Evidence handling**: Whole PDF supplied; authors published a supplement with the human/model ratings. No requested source quotations, quote verification, immutable storage, or audit trail.
- **Reference standard**: RoB2 assessments in six published meta-analyses. Protocol registered; no test or correction for reference-label reliability.
- **Adjudication of disagreements**: None reported.
- **Headline results**: Weighted Fleiss κ overall 0.24 (95% CI 0.10–0.37). Highest domain agreement in randomization, κ=0.31 (0.10–0.50); lowest selection of reported result, κ=−0.11 (−0.16 to −0.04). Other domain κ: missing outcome data 0.12; deviations 0.06; measurement −0.03. ChatGPT assigned high risk in only three single-domain cases and no overall-high ratings; authors describe ratings as overly positive.
- **Repeatability, time, cost**: One assessment per study; no repeatability/time/cost outcome.
- **Authors' stated limitations**: Short communication; limitations include use of a short prompt and reliance on review assessments; model performed poorly and over-optimistically.
- **Authors' conclusions**: ChatGPT-4o with simple prompts was not suitable for RoB assessments.
- **Quotable sentences**:
  - “The weighted kappa for the overall risk of bias analysis for the primary outcome was 0.24” (Results)
  - “We found that the performance of ChatGPT‐4o was poor in the risk of bias analyses, and mainly, because it was too positive with the assessments.” (Discussion)
  - “The findings of this study highlighted that ChatGPT‐4o was not suitable for risk of bias assessments with simple prompts.” (Discussion)
- **Bearing on G1–G5**:
  - **G1 supports**: model states risk labels, with no algorithm enforcement or consistency audit.
  - **G2 supports**: PDF upload but no verified answer-to-passage binding or audit log.
  - **G3 supports**: published labels serve as ground truth without reliability correction.
  - **G4 supports**: no adjudication of disagreements.
  - **G5 supports**: single chat prompt, not an agentic/tool workflow.
- **Implication for ARBITER manuscript**: Directly comparable RoB2 baseline; cite its weak agreement and optimistic classifications, while being explicit that it used a single prompt and published-review comparator.

### Kuitunen et al. 2025, Neonatology: neonatal evidence brief

- **DOI / IDs**: 10.1159/000544857.
- **Full text read**: No. Publisher PDF endpoint returned 403; no open full text found in this pass. This was requested as a brief, and no quantitative claims are used here.
- **Design / sample / tool / method**: Not reliably extractable from accessible full text.
- **Bearing on G1–G5**: Not assessed from full text; do not cite as evidence for or against any gap until verified.
- **Implication for ARBITER manuscript**: Bibliographic lead only; no substantive claim should rely on it without obtaining the paper.

## Barsby et al. 2025, BMJ Evidence-Based Medicine: pilot study on LLMs and RoB

- **DOI / IDs**: 10.1136/bmjebm-2024-112990; PMID 38782561.
- **Full text read**: Yes; BMJ full-text PDF. Supplement is mentioned but not retrieved separately.
- **Design**: Pilot study embedded within a systematic review (PROSPERO CRD420212479050); 15 full-length papers assessed. No prospective registration of this LLM comparison reported.
- **Sample**: 15 studies, six RoB domains plus added overall rating. Two human reviewers did independent assessments; conflicts settled by discussion, with a third reviewer available but not needed.
- **Tool**: RoB domains in the study’s prior review; the paper uses the original Cochrane-style six-domain assessment rather than RoB2 signaling/algorithm workflow.
- **Models and dates**: ChatGPT 3.5 and GPT-4, accessed December 2023. Gemini tried but could not complete assessments.
- **Inputs**: Full-text PDFs uploaded to ChatPDF.com, a ChatGPT3.5 plug-in; GPT-4 repeated by same AI reviewer. No trial registries or protocol inputs stated.
- **Prompting / system design**: Prompts asked about each of six domains; prompts were not standardized, and some questions repeated. ChatPDF interface, no agent or external evidence tools.
- **How domain judgements were produced**: ChatGPT stated classifications itself; no programmatic algorithm.
- **Rule-consistency checked?**: No.
- **Evidence handling**: Full PDFs provided; responses recorded in a Microsoft Office form. No answer-level quoted evidence verification or durable audit trail reported.
- **Reference standard**: Human reviewers’ decisions called “gold standard.” The two reviewers resolved conflicts by discussion; third reviewer was available. Human reference was not independently reliability-tested beyond this process.
- **Adjudication of disagreements**: Human-human disagreements were resolved by discussion; third-party arbitration available but unused. No separate blinded adjudication of AI-vs-human disagreements.
- **Headline results**: 105 decisions each for GPT3.5 and GPT4. GPT3.5 concurrent with human in 41/105 (39.0%), opposite in 10/105 (9.5%), indeterminate in 54/105 (51.4%). GPT4 concurrent in 34/105 (34.3%), opposite in 15/105 (14.3%), indeterminate in 54/105 (51.4%). GPT4’s selective-reporting rating was 14/15 correct, while GPT3.5’s was 10/15. Most responses were indeterminate.
- **Repeatability, time, cost**: GPT3.5 and GPT4 were each tried; no formal repeatability, time, or cost analysis.
- **Authors' stated limitations**: Nonstandard prompts aimed to emulate users; frequent indeterminate responses; only 15 papers and an early snapshot of models.
- **Authors' conclusions**: Moderate agreement, but performance insufficient for real-world use.
- **Quotable sentences**:
  - “Any conflicts were resolved by discussion, with a third reviewer (KDB) available for arbitration, although this was not required.” (Methods)
  - “Both ChatGPT3.5 and ChatGPT4 delivered an indeterminate response on 54/105 (51.4%) decisions.” (Results)
  - “While encouraging, this suboptimal performance precludes us from recommending ChatGPT be used in real-world RoB assessment.” (Discussion)
- **Bearing on G1–G5**:
  - **G1 supports**: direct model classifications, no algorithm or consistency test.
  - **G2 supports**: source PDFs supplied but no evidence binding/verification or audit.
  - **G3 partly contradicts**: human reference ratings were independently assessed and resolved internally, but their reliability/correctness was not quantified and they were still treated as gold standard.
  - **G4 supports**: adjudication was not blind AI-vs-reference disagreement adjudication.
  - **G5 supports**: ChatPDF prompt interface, not an agent/tool server.
- **Implication for ARBITER manuscript**: This paper demonstrates that human review itself can include an explicit consensus step, but its small pilot and high indeterminate fraction differ substantially from modern structured RoB2 assessment.

## Xiong et al. 2026, BMJ Evidence-Based Medicine: prompt engineering comparison

- **DOI / IDs**: 10.1136/bmjebm-2025-114055.
- **Full text read**: No. BMJ PDF endpoint returned HTTP 403 and the article was not available in PMC or indexed full text in this search. The user-provided details (“formula-constrained output”; reference “reviewed and revised”) are treated as leads to verify, not as confirmed findings.
- **Design, sample, model, inputs, results**: Not established because full text was inaccessible.
- **How domain judgements were produced / rule consistency**: Not established. In particular, cannot determine whether formula-constrained output meant RoB2 algorithm execution or merely constrained-format prompting.
- **Evidence handling**: Not established.
- **Reference standard**: Not established. “Reviewed and revised” requires the paper’s methods to identify who reviewed, how revisions were made, whether blind, and whether ratings were independently adjudicated; unavailable here.
- **Adjudication of disagreements**: Not established.
- **Bearing on G1–G5**: Unassessed pending full text. The title alone cannot substantiate a gap claim.
- **Implication for ARBITER manuscript**: Obtain the article and supplement before asserting novelty around formula constraints or revised reference ratings.

## Li et al. 2026, BMC Medical Research Methodology: human-AI collaboration

- **DOI / IDs**: 10.1186/s12874-025-02763-3; PMCID PMC12903640; PMID 41559613.
- **Full text read**: Yes; Europe PMC full-text XML, including methods, results, discussion, and supplement description. Supplementary Material 1 is referenced but not separately fetched.
- **Design**: Model comparison and human-AI collaboration study using a constructed dataset from systematic-review trial labels; no preregistration reported.
- **Sample**: 768 reviews from 2020–2022 yielded 4,661 unique RCTs. Dataset uses seven RoB1 domains. Models assessed 300 instances per domain (2,100 total); collaboration evaluation used 60/domain, with two junior human reviewers and a senior supervisor.
- **Tool**: Cochrane RoB1, not RoB2.
- **Models and dates**: DeepSeek V3 and Qwen-plus. Authors describe them as recent models; exact inference dates are not stated in inspected text.
- **Inputs**: Full-text trial reports retrieved from PubMed, mostly PDFs parsed with pdfminer3k and cleaned. Review supplemental tables supplied published RoB judgements and rationales. Prompt directs extraction from methods, statistical analysis, figure captions, and context/supplements as needed.
- **Prompting / system design**: Structured domain-specific prompts; model gives verbatim evidence, classification, reasoning, confidence, and JSON. Three modes: M1 evidence extraction; M2 evidence plus reasoning; M3 second-model disagreement triggers human review. Models work in a pipeline, but this is not an autonomous evidence-review agent.
- **How domain judgements were produced**: Models directly classified each domain; humans make final judgements in collaboration modes. The tool is RoB1 and no separate code application of an official algorithm is reported.
- **Rule-consistency checked?**: No formal algorithmic rule-consistency evaluation reported.
- **Evidence handling**: Direct evidence extraction and quote-like verbatim text are required; outputs stored as JSON and parsed to Excel. This is stronger evidence traceability than simple chat studies. They do not report automated verification that every extract exists in an immutable source or an independently verifiable audit trail.
- **Reference standard**: Cochrane Database of Systematic Reviews annotations, with “most recent date priority” used to select a label where reviews conflicted. They also manually reassessed 60 RCTs/domain for collaboration experiments; senior reviewer with five years’ experience had Cohen κ 0.724–0.942 against the dataset annotations. They ran sensitivity analyses on conflicting labels (all McNemar p>0.05), but explicitly acknowledge the priority rule’s limitations. This is a meaningful reliability check, though not full adjudication of every label.
- **Adjudication of disagreements**: Human assessment occurs in M1–M3. M3 triggers a human when the two models disagree; reviewers resolve with evidence and model outputs. It is not blinded expert adjudication specifically on model-vs-published-label disagreements. Senior supervision and a separate rater check are reported.
- **Headline results**: Standalone accuracy ranged 0.403–0.777 across domains. Human-AI M2/M3 accuracy ranged 0.633–0.900. M2 had highest accuracy in most tasks; M3 reduced intervention in selected structured/moderate tasks. Human consistency improved with reasoning support. These are RoB1 categories and task-specific results, so do not compare directly with RoB2 kappas.
- **Repeatability, time, cost**: Evaluates intervention rate and accuracy trade-offs; no wall-clock/cost data reported.
- **Authors' stated limitations**: RoB1 rather than RoB2; “most recent date priority” for conflicting reference labels has limitations; models are only DeepSeek V3/Qwen-plus, limiting generalizability.
- **Authors' conclusions**: Standalone LLMs cannot replace experts, but structured human-AI collaboration can improve accuracy and reduce workload.
- **Quotable sentences**:
  - “To establish a single, traceable Risk of Bias (RoB) reference label (Ground Truth) for each RCT, we implemented a prioritization rule” (Methods)
  - “a senior reviewer with five years of experience independently reassessed the 60 RCTs per domain used in the Human–AI collaboration evaluation cohort.” (Methods)
  - “The study employs the Cochrane RoB 1.0 tool, which has been updated to RoB 2.0.” (Discussion, limitations)
- **Bearing on G1–G5**:
  - **G1 supports**: no formal code-derived RoB algorithm or model-answer consistency audit; it is RoB1.
  - **G2 partly contradicts**: verbatim evidence extraction, JSON records, and structured pipeline exist, but no verified source binding or auditable tamper-resistant record.
  - **G3 partly contradicts**: assesses one reviewer’s agreement with labels on collaboration subset and does sensitivity analysis for conflicting labels; still uses Cochrane labels as ground truth and does not adjudicate all cases.
  - **G4 partly contradicts**: humans resolve model disagreements in workflow, but no blinded expert review of model/reference disagreements.
  - **G5 partly contradicts**: multimodel trigger workflow is a human-AI system; it is not an agent taking actions through a rule-enforcing server.
- **Implication for ARBITER manuscript**: This is the strongest nearby precedent for structured evidence extraction and human intervention, and it makes broad G2/G4/G5 novelty claims untenable without narrowing them to verified binding, blinded model-reference adjudication, RoB2 algorithm enforcement, and agent/server auditability.

## Worker summary

The RoB2 replications by Kuitunen and Descamps strongly support G1–G4: model-authored labels, no rule-consistency checks, no source-bound audit, and published review ratings used as the benchmark. Descamps adds a structured full-text processing framework, which narrows any claim that prior work was only a bare chat prompt. Barsby includes human-human consensus but not blinded adjudication of AI disagreements. Rose explicitly frames human-human agreement as a comparator and calls agentic AI a future possibility. Li is the closest workflow precedent: it extracts verbatim evidence, stores structured outputs, checks reference-label reliability on a subset, and uses model disagreement to trigger human review. Thus G2, G3, G4, and G5 should be narrowly stated: prior work has some traceability, reference checks, human review, and collaboration, but the reviewed papers do not document ARBITER’s specific combination of verified immutable-source quotations, RoB2 algorithm execution in code, blinded expert correction of model/reference disagreement, and a tool-using agent with independent auditability. Xiong and Kuitunen 2025 neonatal could not be fully assessed from accessible text and should not support a categorical novelty claim. A surprising comparator point is Rose’s argument that modest human–LLM agreement may still save effort when human-human agreement itself is imperfect; that is not evidence that published reference labels are error-free.
