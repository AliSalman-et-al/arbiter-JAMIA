# W8 gap hunter: adversarial check of ARBITER claims G1–G5

**Search cut-off:** 19 October 2026. Searches included PubMed/PubMed Central and Europe PMC surfaced by web search, publisher full text, JMIR, BMJ, medRxiv, arXiv/ACL Anthology, and targeted Google Scholar-style queries. I also searched for agentic ROBINS-I and QUADAS-2 studies and analogous evidence-synthesis adjudication workflows. This is a targeted falsification search, not a registered systematic review; indexing and publication status can lag. I read the accessible full text of the items below, including methods, results, discussion, and available online appendices/supplements where reachable. For one publisher-hosted paper (Saadi et al.), the PDF was accessible via search results, while the publisher HTML fetch failed; its template notes this limit. Known studies listed in the brief are not re-extracted below. ROBoto2 is discussed only where the new pilot's direct evaluation bears on the gaps.

## Choi et al. 2026 (verified first author; worker originally wrote "Kim"), Journal of Evidence-Based Practice: variability, algorithm conformance, and accuracy of LLM-based RoB 2 tools

- **DOI / IDs**: [10.63528/jebp.2026.00011](https://doi.org/10.63528/jebp.2026.00011); J Evid-Based Pract. 2026;2(2):91–97; published online 29 September 2026.
- **Full text read**: Yes; full article and tables at [journal page](https://www.e-jebp.org/journal/view.php?number=21). No supplement linked.
- **Design**: Descriptive, repeated-assessment pilot in a conference workshop. One RCT was rated repeatedly by workshop participants. No preregistration reported.
- **Sample**: One RCT; 13 general Gemini runs, 15 Gemini Gems runs, and 10 ROBoto2 runs (38 assessments total); one experienced reviewer's reference assessment.
- **Tool**: RoB 2.0 (2019 final structure), five domains. General Gemini and Gems stated domain judgments; ROBoto2 was designed to aggregate using the official flowchart.
- **Models and dates**: The article reports configurations rather than a dated underlying Gemini model snapshot; tool versions were held identical within the workshop exercise. Avoid naming a specific Gemini model version.
- **Inputs**: Same single RCT report for all participants; official RoB 2 manual supplied as full in-context text for Gemini, RAG reference knowledge for Gems, and through a purpose-built ROBoto2 retrieval/prompting pipeline. No registry or supplementary trial sources reported.
- **Prompting / system design**: Identical prompt and tool versions per configuration. ROBoto2 combines document retrieval and LLM prompting with flowchart aggregation. No MCP/server architecture described.
- **How domain judgements were produced**: Gemini/Gems generated them. Authors separately encoded the official RoB 2 mapping in code and applied it to each run's own signalling answers to compute the implied judgment; ROBoto2 was designed to apply the flowchart itself.
- **Rule-consistency checked?**: Yes, directly. Mean five-domain conformance of entered judgment with algorithm-implied judgment was 43% for Gemini, 51% for Gems, and 60% for ROBoto2. Conformance was 68% in domain 1 and 42% in domain 2 averaged across configurations. Skip-logic violations appeared in at least one domain in 69%, 80%, and 100% of respective runs. Recomputing improved agreement with the expert for Gemini (mean change +0.34) and Gems (+0.24). The article also found apparent answer–judgment decoupling in ROBoto2, which limits interpretation of its recomputation result.
- **Evidence handling**: ROBoto2 uses retrieval, but this study does not test whether each answer's quotation is verified against an immutable stored source, nor does it describe a per-assessment auditable record.
- **Reference standard**: One experienced reviewer's assessment. The reviewer had three transcription errors, caught by the algorithm-conformance check and corrected. The corrected reference was algorithm-conformant in all five domains. No formal reliability study of reference judgments.
- **Adjudication of disagreements**: None; no blinded panel. Single reviewer reference.
- **Headline results**: Five-domain expert agreement was 60% for ROBoto2, 24% for general Gemini, and 5% for Gems. Mean reproducibility was 0.76, 0.59, and 0.66, respectively. Gems systematically under-rated risk in this one case. Recalculation from signalling answers raised Gemini agreement in every domain and substantially raised Gems agreement in domains 1, 2, and 4.
- **Repeatability, time, cost**: Repeatability quantified; no time/cost outcomes reported. Domain-2 pairwise agreement was 0.34 for Gemini and 0.42 for ROBoto2.
- **Authors' stated limitations**: “This is a pilot, hypothesis-generating study based on a single article, a single expert reference, and three configurations (38 assessments in total); generalization requires caution.” They say the reason for ROBoto2's answer–judgment decoupling “requires further examination of the tool itself.”
- **Authors' conclusions**: They recommend checking answer/judgment consistency and pairing human review with algorithmic aggregation. They propose using code for deterministic aggregation rather than delegating composite judgments to a model.
- **Quotable sentences**:
  - “We implemented in code the RoB 2.0 algorithm mapping signalling answers to domain judgments.” (Methods, RoB 2.0 Algorithm Implementation)
  - “For each run, we computed the agreement between the judgment implied by applying the algorithm to that run’s own signalling answers and the judgment the tool actually entered.” (Methods, Analysis Metrics)
  - “The five-domain mean conformance was 43% (95% CI 29–58%) for Gemini, 51% (39–63%) for Gems, and 60% (40–78%) for Roboto.” (Results, Algorithm Conformance)
- **Bearing on G1–G5**:
  - **G1: contradicts / falsifies broad wording.** It computes algorithm-implied judgments in code and reports rule-consistency of model-entered judgments. It is a one-study, diagnostic pilot and does not deploy an enforcement server that exclusively emits algorithm-derived judgments.
  - **G2: supports gap, with qualification.** Retrieval is present in ROBoto2, but verified per-answer quotations, immutable stored sources, and audit files were not studied.
  - **G3: supports gap.** No attempt to estimate/correct reference-label error; only one reviewer served as reference (although a code check caught transcription errors).
  - **G4: supports gap.** No blinded expert adjudication.
  - **G5: qualifies gap.** A purpose-built pipeline combines retrieval, prompting, and algorithmic aggregation, but it is not described as an agent using tools against a separate rule server.
- **Implication for ARBITER manuscript**: Do not claim novelty for implementing RoB 2 in code, measuring model-answer/domain-judgment inconsistency, or showing that recomputation can improve agreement. State the narrower distinction: ARBITER makes algorithmic aggregation the production path and blocks invalid/incomplete/unbound outputs; compare this pilot as a one-article diagnostic evaluation, not an equivalent workflow validation.

## Liang et al. 2026, JMIR AI: Retrieve-Then-Verify for evaluating evidence support and hallucination

- **DOI / IDs**: [10.2196/93761](https://doi.org/10.2196/93761); PMID 42748453; PMCID PMC13628037; JMIR AI 2026;5:e93761.
- **Full text read**: Yes; [full JMIR article](https://ai.jmir.org/2026/1/e93761/) including methods, results, discussion, and linked Multimedia Appendices 3–8 (algorithm, example prompt/verdict, example rationale, and sensitivity analysis). Large per-study appendix PDFs were listed but not individually reviewed.
- **Design**: Retrospective evaluation of a retrieve-then-verify (RtV) approach to measure source-document support and hallucination in LLM-generated medical information, using RoB as test case. Not preregistered in the article.
- **Sample**: 97 RCTs drawn from a 2023 Cochrane review (113 eligible; restricted to those with complete RoB data and accessible PDF full text), across seven outcome categories. Trials were published 1996–2022.
- **Tool**: RoB 2; model outputs included structured signalling questions and domain judgments.
- **Models and dates**: GPT-5 (August 2025), o3-mini (January 2025), GPT-3.5 Turbo (January 2024); accessed through OpenAI API.
- **Inputs**: Extracted text and tables from full trial reports. No registry/protocol sources reported. Source review's two-reviewer consensus labels (with disagreements resolved by discussion) were the reference for performance analyses.
- **Prompting / system design**: Schema-constrained Python prompt; structured JSON output and post-processing. After generation, each signalling question created a retrieval query by concatenating question, model response, and explanation. BM25 retrieved relevant source passages (default top five); a verifier assigned supported/contradicted/not found/out-of-scope verdicts with verbatim quotations. This is retrieve-then-verify evaluation, not a tool-using assessment agent enforcing evidence links before answers are accepted.
- **How domain judgements were produced**: Structured model output included both signalling responses and domain-level judgments; prompts/post-processing constrained choices. The methods do not describe replacing all model-entered judgments with a separately enforced official algorithm in the operational assessment workflow.
- **Rule-consistency checked?**: No model-answer vs official-algorithm conformance outcome reported. (It reports task accuracy and evidence-support metrics.)
- **Evidence handling**: Material counterexample to an unqualified G2: model claims were explicitly linked after generation to retrieved original-report passages and assigned support verdicts with verbatim quotations. This was a reproducible audit/evaluation of support, but the methods do not say quotations were verified against an immutable source copy, nor that an unsupported model answer was rejected at generation time. The paper's chief result—only 60–65% support—underscores the distinction between checking support after the fact and guaranteeing it in production.
- **Reference standard**: Published Cochrane RoB 2 assessments, assessed independently by two reviewers and resolved by consensus. No re-rating, error correction, or reliability-adjusted reference analysis. Authors explicitly use them as the reference standard.
- **Adjudication of disagreements**: No blinded expert re-assessment of model-versus-review labels. Source review's routine consensus resolution is not the requested blinded adjudication.
- **Headline results**: Binary risk-direction accuracy 90–98%, exact category accuracy 42–71%, quadratic kappa up to 0.81. Evidence support was about 60–65%; conservative hallucination 34–37%. GPT-5 mean support was 64.3%, strict hallucination 35.7%. Similar top-1 BM25 scores (roughly 30–31) suggested retrieval strength alone did not explain model differences.
- **Repeatability, time, cost**: No repeatability, workflow time, or monetary cost outcome reported. Sensitivity analyses varied retrieval depth and model reasoning depth.
- **Authors' stated limitations**: Their corpus is one Cochrane review with complete labels and accessible reports, and published labels serve as reference. The study is retrospective and uses a finite outcome corpus. The authors state that high decision accuracy does not guarantee documentary support.
- **Authors' conclusions**: Evidence support/hallucination measures add information that agreement metrics miss; retrieval-based verification is a reproducible way to evaluate support.
- **Quotable sentences**:
  - “A verification step assigned evidence verdicts (supported, contradicted, not found, or out of scope) with verbatim quotations.” (Abstract, Methods)
  - “Binary accuracy of AI-generated RoB judgments was high across all domains (90%-98%), whereas evidence support rates clustered at only 60%-65%.” (Discussion, Principal Findings)
  - “AI-generated medical information can achieve high decision-level accuracy while still lacking documentary support in a substantial proportion of outputs.” (Abstract, Conclusions)
- **Bearing on G1–G5**:
  - **G1: supports gap only for enforced production aggregation;** no rule-consistency check was reported in this study.
  - **G2: contradicts broad wording / qualifies the gap.** This is RoB-specific claim-to-passage retrieval with quoted verification verdicts. It does not establish immutable-source quotation binding or a hard rejection/audit server in the assessment path.
  - **G3: supports gap.** Published labels are used as reference; no label-error measurement/correction.
  - **G4: supports gap.** No blinded model/reference disagreement panel.
  - **G5: supports gap as narrowly defined.** Python schema prompting and post hoc retrieval verification are reported; no agent/tool-calling architecture or separate rules server.
- **Implication for ARBITER manuscript**: Cite this as direct RoB 2 precedent for evidence support auditing. Frame ARBITER's contribution as source integrity and enforced answer-to-evidence binding in the execution path, while acknowledging that Liang et al. already retrieve and verify claims post hoc and that support can remain poor despite high label agreement.

## Saadi et al. 2026, BMJ Digital Health & AI: LLM assessment with ROBINS-I

- **DOI / IDs**: [10.1136/bmjdth-2026-000034](https://doi.org/10.1136/bmjdth-2026-000034); BMJ Digit Health 2026;2:e000034; registered [OSF S9VBQ](https://osf.io/S9VBQ).
- **Full text read**: Full article was accessible through the indexed publisher PDF/search extracts and the paper's abstract/full-text passages; publisher HTML open failed in this search session. Reported this way rather than treating inaccessible HTML/supplement as read.
- **Design**: Secondary analysis of studies previously rated by two independent human teams. Each model assessed each study twice. Only studies with concordant human domain-level ratings were included. OSF registration reported.
- **Sample**: 171 nonrandomized studies, selected from a larger ROBINS-I data resource (full study flow not recovered from accessible extracts). Tool: ROBINS-I 2016.
- **Models and dates**: Claude, Gemini, and GPT; exact deployed model snapshots are not in the accessible abstract/extracts.
- **Inputs**: Full text of each study provided through platform document-upload features. Protocols and registry records not reported in accessible sections.
- **Prompting / system design**: “Agent-based structured implementations”: agent first identifies study characteristics, then evaluates ROBINS-I domains sequentially with domain-specific signalling questions, then supplies categorical domain rating and brief justification. The three vendors' interfaces/platform workflows are not described in the accessible extract as MCP tools or a separate deterministic server.
- **How domain judgements were produced**: The model/agent was required to provide a categorical domain-level judgment. Accessible abstract does not say a deterministic algorithm computed it from signalling answers.
- **Rule-consistency checked?**: Not reported in accessible full-text extracts.
- **Evidence handling**: Full article uploaded; no verified quotations, immutable source copy, or audit trail reported in accessible sections.
- **Reference standard**: Human domain assessments by two independent teams, with concordant ratings only analyzed. The authors caution that human consensus is agreement, not truth: ROBINS-I is difficult and “sometimes misapplied even by humans”; filtering to concordant ratings improves reference certainty but may limit generalizability. They do not correct the selected labels.
- **Adjudication of disagreements**: Human team concordance was a sample selection condition; no blinded adjudication of LLM-versus-human disagreement reported.
- **Headline results**: Abstract reports accuracy/agreement analyses, but detailed numerical results were not recoverable in the accessible publisher text during this search. Do not quote figures without checking the PDF directly.
- **Repeatability, time, cost**: Two assessments/model/study enable a repeat assessment design; no time/cost result available in accessible extracts.
- **Authors' stated limitations**: “Accuracy” is agreement with a human consensus reference rather than ground truth; restricting to concordant ratings limits generalisability to ambiguous cases.
- **Authors' conclusions**: This is direct evidence that an agent-based structured ROBINS-I workflow exists. It supports positioning ARBITER's distinction at specific architecture and verification features rather than claiming agentic RoB assessment is new.
- **Quotable sentences**:
  - “For each study, the agent (1) prompted the model to identify key study characteristics relevant to ROBINS-I, (2) evaluated each ROBINS-I domain sequentially using domain-specific signalling questions and (3) required a categorical domain-level judgement...” (Methods, LLM assessment workflow; publisher page)
  - “First, the human consensus ratings were treated as a reference standard, but risk-of-bias tools (including ROBINS-I) can be challenging to apply and are sometimes misapplied even by humans; therefore, ‘accuracy’ should be interpreted as agreement with human consensus rather than ground truth.” (Limitations; publisher PDF)
- **Bearing on G1–G5**:
  - **G1: not addressed** in the accessible report; no answer-to-algorithm consistency outcome found.
  - **G2: supports gap** in accessible report; no evidence binding or source-verified quotes found.
  - **G3: supports gap with caution already acknowledged.** Authors qualify the reference as fallible but do not measure/correct label error.
  - **G4: supports gap.** No blinded adjudication of model/reference disagreements.
  - **G5: contradicts broad “no agent” claim, but qualifies the server/tool version.** A ROBINS-I agent-based structured workflow is reported; no separate server, MCP, or enforceable source/rule boundary is reported.
- **Implication for ARBITER manuscript**: Acknowledge agent-based ROBINS-I work. The defensible novelty lies in the particular architecture (separate deterministic server, verified quotation binding, source lock, independent audit) and study's masked disagreement adjudication, not “first agent for RoB.”

## Gerke et al. 2025, Diagnostics: QUADAS-2 assessment by LLMs

- **DOI / IDs**: [10.3390/diagnostics15121451](https://doi.org/10.3390/diagnostics15121451); PMID 40564772; PMCID PMC12191753; Diagnostics. 2025;15(12):1451.
- **Full text read**: Yes; [PMC full text](https://pmc.ncbi.nlm.nih.gov/articles/PMC12191753/) and linked supplement with complete model responses/reasoning errors.
- **Design**: Small comparative evaluation of public LLM chat interfaces against human assessment. No preregistration reported.
- **Sample**: Ten recent full-text diagnostic-accuracy studies on diabetes-related topics across medical specialties, plus two unrelated articles to see whether QUADAS-2 was deemed inapplicable.
- **Tool**: QUADAS-2; four domains, signalling questions and low/high/unclear judgments.
- **Models and dates**: ChatGPT 4o, Grok 3, Gemini 2.0 Flash, DeepSeek V3; assessed in 2025.
- **Inputs**: Selected full-text articles. No registries or protocols described.
- **Prompting / system design**: Same prompt through public web interfaces. Models were asked to wait for domain signalling questions and provide yes/no/unclear/not applicable answers, then low/high/unclear domain judgments without comments. No agent or tool calls.
- **How domain judgements were produced**: LLM supplied both signalling answers and domain risk ratings. No coded QUADAS-2 algorithm reported.
- **Rule-consistency checked?**: No independent algorithm-conformance analysis. Correctness required both matching the human answer and an appropriate argument.
- **Evidence handling**: No source passage request/verification or audit trail reported; reasoning was included in supplement.
- **Reference standard**: Two authors independently assessed, resolving discrepancies by discussion/consensus. No measured reference reliability or correction of human labels.
- **Adjudication of disagreements**: Consensus discussion between two human assessors; not blinded and not a blinded panel adjudicating model-vs-reference differences.
- **Headline results**: Mean correct signalling-question assessments (including correct argument) was 72.95%; model range 67.27%–77.27%. Accuracy varied by domain; the authors found straightforward reasoning errors. No basis to claim adjudicated gold-standard accuracy.
- **Repeatability, time, cost**: No repeated runs, time, or cost results reported.
- **Authors' stated limitations**: Search selected recent free full texts from one database and may have limited topic diversity. Authors state that LLM performance with QUADAS-2 had not previously been studied (their literature search context).
- **Authors' conclusions**: LLMs may be complementary in systematic reviews but require human supervision.
- **Quotable sentences**:
  - “An assessment made by an LLM was considered correct only if it matched the human expert’s answer and included a proper argument.” (Methods, Statistical Analysis)
  - “To our knowledge, no prior studies have assessed LLM performance in evaluating risk of bias in diagnostic accuracy studies using QUADAS-2.” (Discussion)
- **Bearing on G1–G5**:
  - **G1: supports gap** for enforced algorithm and conformance measurement.
  - **G2: supports gap.** Full-text input and free-text reasoning are not source-verified quotation binding.
  - **G3: supports gap.** Consensus is the reference; label error not quantified/corrected.
  - **G4: supports gap, with distinction.** Two humans resolve their own disagreements by consensus, but there is no blinded model/reference disagreement adjudication.
  - **G5: supports gap.** Public chat interfaces, not agent/server architecture.
- **Implication for ARBITER manuscript**: QUADAS-2 expands the analog literature but does not close the architectural or adjudication gaps. Describe ordinary expert consensus as a reference procedure separately from blinded adjudication of disagreements.

## Gartlehner et al. 2025, Annals of Internal Medicine: AI-assisted extraction within reviews (analogous precedent)

- **DOI / IDs**: [10.7326/ANNALS-25-00739](https://doi.org/10.7326/ANNALS-25-00739); PMID 41183336; Ann Intern Med. 2025;178(12):1763–1771. Preprint: [medRxiv 10.1101/2025.03.20.25324350](https://doi.org/10.1101/2025.03.20.25324350).
- **Full text read**: Yes; [PMC full text](https://pmc.ncbi.nlm.nih.gov/articles/PMC13091441/) and medRxiv preprint/full PDF. Supplementary workflow and prompt material are referenced in the article; full appendices hosted by Annals were not all available in the opened PMC text.
- **Design**: Prospective parallel-group study within six ongoing systematic reviews (SWAR), workflow validation under real-world evidence synthesis conditions; protocol registered with the NIHR SWAR Network.
- **Sample**: 63 studies across six reviews; 9,341 paired data elements. Reviews included randomized and nonrandomized studies.
- **Tool**: LLM-assisted data extraction, not RoB assessment; direct precedent for independently adjudicating discrepancies between an AI-assisted and human workflow.
- **Models and dates**: Claude 2.1, Claude 3 Opus, Claude 3.5 Sonnet; model changed during the study in line with protocol.
- **Inputs**: Full-text PDFs uploaded to Claude. AI-assisted team had a human reviewer verify/revise model output against the original study report. No external registry inputs described.
- **Prompting / system design**: Review-specific prompts iteratively refined in a pilot. AI-generated initial extraction followed by human verification; teams worked independently.
- **How domain judgements were produced**: Not applicable (data extraction task); the analogous unit was extracted item.
- **Rule-consistency checked?**: Not applicable.
- **Evidence handling**: Both teams consulted original reports; disagreement adjudicators reviewed original reports. This is source-based factual checking, but not a formal per-item verified-quotation binding or immutable source/audit system.
- **Reference standard**: They explicitly did not take human-only extraction as a gold standard. They compared discrepancies against original reports and used adjudicated final data as reference. Authors note both human-only and AI-assisted extraction can be wrong; 11% of human-extracted items had at least one error.
- **Adjudication of disagreements**: Yes, prospective and blinded. Adjudicators were uninvolved in review teams and extraction; two independently checked discordant elements against reports, with a third senior adjudicator resolving residual disagreements. Blinding was attempted but sometimes inferred from verbose AI outputs. They adjudicated only discordant items, so concordant errors could be missed.
- **Headline results**: Workflow concordance 77.2% (95% CI 76.3–78.0). Against adjudicated reference, AI-assisted accuracy 91.0% and human-only accuracy 89.0%; incorrect items 9.0% versus 11.0%. AI assistance reduced median extraction time 41 minutes per study (84 vs 125 minutes).
- **Repeatability, time, cost**: No repeated-run reliability; median time as above. No monetary cost reported.
- **Authors' stated limitations**: Subjectivity in adjudicating/classifying errors; blinding sometimes compromised; discordant-only adjudication misses concordant errors; model-version change; downstream effect on review conclusions not assessed.
- **Authors' conclusions**: AI-assisted data extraction may be viable and more efficient, while the study design shows how workflow performance and human errors can be evaluated together.
- **Quotable sentences**:
  - “To protect against benchmark bias, a form of classification bias that can arise when the reference standard is imperfect, we did not consider the human-only extraction as the reference standard.” (Discussion)
  - “Instead, we verified each discrepancy between human-only and AI-assisted extractions against the original study report by blinded adjudicators.” (Discussion)
  - “However, we adjudicated only discordant data extractions, [so] we have missed instances where extraction results were concordant but both extractions were incorrect.” (Limitations)
- **Bearing on G1–G5**:
  - **G1: not applicable** to risk-of-bias labels; methodological precedent for robust workflow comparison.
  - **G2: qualification by analogy.** Original reports are used to adjudicate extraction discrepancies, but not per-answer quote binding or an audit server.
  - **G3: contradicts broad methodological claim about evidence synthesis labels/references, but not the RoB-specific claim.** It explicitly treats a reference process as fallible and adjudicates against source reports instead of treating human-only labels as gold. It does not re-assess published RoB labels.
  - **G4: contradicts broad “no blinded discrepancy adjudication in evidence synthesis” claim, but not the RoB-specific claim.** Blinded adjudicators settle AI-vs-human extraction discrepancies; not RoB judgment discrepancies.
  - **G5: not directly applicable.** Human-in-the-loop LLM workflow; no tool-calling agent/server.
- **Implication for ARBITER manuscript**: Cite as a design precedent, especially for not treating one workflow's labels as infallible and for independent blinded review of disagreements against source documents. Avoid saying this precedent has already solved reference noise in RoB assessment.

## Cross-study verdict table

| Claim | Verdict | Evidence forcing qualification or falsification | Safest Introduction wording |
|---|---|---|---|
| **G1 Algorithm enforcement** | **Falsified as currently phrased; narrower production-enforcement gap holds.** | Choi et al. 2026 implemented the official mapping in code, recomputed judgments from each run's answers, and quantified how often entered judgments contradicted the mapping. ROBoto2 was designed to use algorithmic aggregation; the pilot found problems, including apparent answer–judgment decoupling. | “Prior evaluations have implemented the RoB 2 mapping for analysis and measured answer–judgment inconsistency, and purpose-built tools have incorporated flowchart aggregation. We therefore focus on a stricter operational property: a separate deterministic service computes every emitted domain/overall judgment from validated answers and rejects incomplete or inconsistent records.” Cite Choi 2026 and ROBoto2. Do not claim no prior code implementation or consistency check. |
| **G2 Evidence traceability** | **Holds with qualification.** | Liang et al. 2026 retrieve trial passages for generated RoB claims, issue support/contradiction/not-found verdicts, and retain verbatim quotations. ROBoto2 includes retrieval. Neither located study establishes the whole combination of immutable stored source, verified quote bound to each answer before acceptance, and independently checkable audit file. | “Recent RoB work has retrieved passages and evaluated whether generated claims are supported, but evidence checking has not yet been shown to enforce answer-level quotation binding against a locked source copy in the assessment path with a separately verifiable audit record.” Cite Liang et al.; describe the distinction precisely. |
| **G3 Reference noise** | **Holds for published RoB labels; qualify as a broader evidence-synthesis precedent exists.** | RoB studies found here generally use published review/human consensus labels as references. Liang et al. does this directly. Saadi et al. explicitly says human consensus is not ground truth and restricts to concordant labels, but does not correct them. Gartlehner et al. 2025 (analogical data extraction) rejects human-only extraction as a gold standard and adjudicates against source reports. | “LLM RoB evaluations have generally benchmarked against published or human-consensus judgments without estimating their error; adjacent evidence-synthesis workflow research has demonstrated that reference processes can be fallible and can instead be checked against source documents.” Cite Liang, Saadi, Gartlehner. |
| **G4 Blinded adjudication** | **Holds for RoB model-versus-reference disagreements; qualify by direct precedent in adjacent extraction work.** | Gartlehner et al. used blinded adjudicators on AI-assisted versus human-only extraction discrepancies. This is a clear workflow precedent but not RoB rating adjudication. QUADAS-2 paper has ordinary unblinded human consensus; Saadi filters to concordant cases; neither is blinded adjudication of model/reference RoB disagreement. | “We found no RoB 2/ROBINS-I/QUADAS-2 evaluation that used blinded experts to re-assess model-versus-reference rating disagreements; a prospective data-extraction SWAR provides an analogous precedent for blinded adjudication against source reports.” Cite Gartlehner and distinguish task. |
| **G5 Agentic/tool design** | **Holds with qualification.** | Saadi et al. 2026 explicitly uses “agent-based structured implementations” for ROBINS-I. ROBoto2 is a purpose-built retrieval/prompting pipeline with algorithmic aggregation. Neither accessible report describes ARBITER's separate, deterministic server enforcing answer validation and evidence binding, or MCP specifically. | “Agent-based and purpose-built retrieval/aggregation systems now exist for risk-of-bias assessment. The distinction we investigate is an agent constrained by a separate deterministic service that validates answers and their source evidence, computes ratings, and emits an independently checkable audit trail.” Cite Saadi and ROBoto2, alongside ARBITER. Do not claim agents/tool-oriented RoB assessment are unprecedented. |

## Search notes and known literature

- The requested databases/venues were searched by targeted combinations of RoB 2, ROBINS-I, QUADAS-2, risk-of-bias, LLM, algorithm conformance, agent, quotation verification, blinded adjudication, systematic review extraction, JAMIA, and Journal of Biomedical Informatics. Relevant new direct RoB items surfaced above; known items from the brief were not re-extracted.
- Additional direct paper found but not extracted in depth because it is already in the brief: ROBoto2, an EMNLP 2025 System Demonstration, describes an interactive RoB 2 QA pipeline, retrieval strategies and multiple LLMs. The Choi 2026 pilot is the new independent evaluation bearing on its algorithmic aggregation and gives a more direct G1 test.
- The QUADAS-2 study and Saadi ROBINS-I paper show that analogous tools and agent designs extend beyond RoB 2. None found in this search establishes blind panel adjudication of RoB label disagreements.
- High-level systematic review search result: Shankar et al., “Performance of large language models in data extraction for evidence synthesis: A systematic review,” J Biomed Inform 2026;181:105086, DOI [10.1016/j.jbi.2026.105086](https://doi.org/10.1016/j.jbi.2026.105086). Not extracted as a primary study because it is a review and its newly published full text was not available in the accessed source. It searched through December 2025, including medRxiv and arXiv.
- Scope caution: this search found a direct falsifier for G1 and strong qualifiers to G2/G5, but absence findings for G3/G4 are bounded to indexed/publicly accessible 2023–2026 work and require a final database-level search before absolute “none” claims in print.

## Worker summary

G1 must be rewritten: a 2026 pilot implemented the algorithm in code and measured internal consistency, while also showing why a production enforcement boundary remains consequential. G2 is no longer a broad gap because RoB 2 retrieve-then-verify with quotations has appeared; the defensible distinction is immutable source locking, answer-level binding before acceptance, and an auditable enforcement path. G3 and G4 remain supportable specifically for RoB labels and RoB disagreement adjudication, but the Introduction should acknowledge the adjacent extraction SWAR precedent for source-based, blinded adjudication and fallible references. G5 needs qualification: an agent-based ROBINS-I workflow and a retrieval-plus-algorithm RoB 2 pipeline exist; the narrower separate deterministic server architecture remains distinguishable. The surprising finding is that recent work also reports rule nonconformance in ROBoto2 and catches human reference transcription errors via the same algorithm check, directly strengthening the rationale for independent verification while removing any first-ever claim for that check.
