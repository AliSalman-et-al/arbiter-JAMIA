# Opening evidence: human RoB 2 reliability, workload, and AI governance

This evidence supports an opening rationale in three parts: RoB 2 judgments require substantial, interpretation-heavy human work; published judgments are not a noise-free reference; and current evidence-synthesis governance expects explicit human responsibility, transparent reporting, and publicly evaluable tools. The LLM systematic-review evidence remains sparse for RoB assessment and variable in performance.

## Minozzi et al. 2020, Journal of Clinical Epidemiology: RoB 2 reliability and application challenges

- **DOI / IDs**: 10.1016/j.jclinepi.2020.06.015; PMID 32562833.
- **Full text read**: No. PubMed record/abstract and bibliographic record used; publisher full text was not accessible in this search. Therefore quotations below are from the abstract.
- **Design**: Cross-sectional inter-rater reliability and usability study.
- **Sample**: Four raters independently assessed primary outcomes from 70 individually randomized parallel-group RCTs (70 study outcomes).
- **Tool / effect**: RoB 2; primary outcome results. The abstract reports the assignment-to-intervention and adhering-to-intervention variants of Domain 2 separately.
- **Headline results**: Overall Fleiss κ 0.16 (95% CI 0.08–0.24), slight agreement. Domain κ: randomization 0.45 (0.37–0.53); deviations, assignment effect 0.04 (−0.06 to 0.14); deviations, adherence effect 0.21 (0.11–0.31); missing outcome data 0.22 (0.14–0.30); selection of reported results 0.30 (0.22–0.38); other domains were in the fair range. Average completion time was 28 minutes (SD 13.4) per outcome.
- **Reasons for difficulty**: Abstract identifies limited subject-matter knowledge of primary studies, unfamiliar terminology, changed approaches relative to the prior tool, and signaling-question formulation.
- **Quotable sentences**: “RoB 2 is a detailed and comprehensive tool but difficult and demanding, even for raters with substantial expertise in systematic reviews.” (Abstract); “Calibration exercises and intensive training are needed before its application, to improve reliability.” (Abstract).
- **Bearing on our manuscript**: Establishes material human disagreement and nontrivial time burden; supports the need for reproducible procedures and careful reference interpretation. It does not test AI or algorithmic enforcement, evidence binding, or adjudication between AI and published labels.
- **Implication for ARBITER manuscript**: Report the work as assistance for a judgment-intensive process, not as a replacement for expertise. Distinguish algorithmically valid transformation of answers from the reliability of the answers themselves.

## Minozzi et al. 2021, Journal of Clinical Epidemiology: implementation instructions and reliability

- **DOI / IDs**: 10.1016/j.jclinepi.2021.09.021; PMID 34537386.
- **Full text read**: No. Europe PMC/PubMed abstract record used; full text was not located in open repositories in this search.
- **Design**: Before/after implementation study, with a calibration exercise and review-specific implementation document (ID); not described as randomized.
- **Sample**: Four raters evaluated 80 results across seven outcomes from 16 RCTs in a Cochrane review of cannabis/cannabinoids for multiple sclerosis.
- **Tool / effect**: RoB 2; the ID gave condition- and intervention-specific instructions for answering signaling questions. Reliability was compared before and after adopting the ID.
- **Headline results**: Calibration yielded no agreement for overall judgment (κ −0.15); domain agreement ranged from none to fair. Mean assessment time was 168.5 minutes per study during calibration. After the ID, overall agreement was slight for the first five studies (κ 0.11) and moderate for the remaining 11 (κ 0.42); domain agreement ranged from none to almost perfect. Average assessment time fell to 41 minutes. Calibration and ID development took about 40 hours.
- **Quotable sentences**: “The development of an ID specific for the review may improve reliability substantially.” (Abstract conclusion); “RoB2 tool is comprehensive but complex even for high experienced raters.” (Abstract conclusion; grammatical wording as published).
- **Bearing on our manuscript**: Supports calibration and detailed operational guidance as ways to improve human consistency, while showing their substantial start-up cost. Does not address AI, code-applied algorithms, source traceability, or reference-label validity.
- **Implication for ARBITER manuscript**: Position automation as a possible way to make explicit and repeatable procedural steps; compare its total setup and review effort with human calibration instead of citing per-outcome time alone.

## Hartling et al. 2019, BMJ Open: disagreement across Cochrane reviews assessing the same RCTs

- **DOI / IDs**: 10.1136/bmjopen-2018-028382; PMID 30940766.
- **Full text read**: Abstract and indexed record read; full-text access was not verified in this extraction.
- **Design**: Cross-sectional “research on research” study of risk-of-bias assessments in Cochrane reviews.
- **Sample**: 2,796 Cochrane reviews published March 2011–September 2014 were searched; 1,604 RCTs included in more than one review were identified. Five key RoB items were compared.
- **Tool**: Original Cochrane RoB tool (RoB 1), not RoB 2.
- **Headline results**: Agreement across reviews ranged from 57% (770/1,348) for incomplete outcome data to 81% (1,193/1,466) for random sequence generation. For sampled disagreements, differences in interpretation of the same information were most common: 65% for sequence generation through 90% for blinding of participants/personnel. Unclear or incomplete reporting frequently contributed.
- **Quotable sentences**: “Risk of bias judgements of RCTs included in more than one Cochrane review differed substantially.” (Abstract conclusion); “Most disagreements were related to a difference in interpretation of an incomplete or unclear description in the study report.” (Abstract conclusion).
- **Bearing on our manuscript**: Directly demonstrates that published review labels for the same trial can disagree, although it studies RoB 1. This supports G3’s premise that a single published label should not automatically be treated as truth. It does not measure which review was correct.
- **Implication for ARBITER manuscript**: State that published-review labels are a practical comparator with known disagreement, and explain why independent adjudication provides a second, explicitly imperfect reference.

## Zhang et al. 2024, Journal of Clinical Epidemiology: disagreement in hypertension Cochrane reviews

- **DOI / IDs**: Article indexed as “Disagreements in risk of bias assessment for randomized controlled trials in hypertension-related Cochrane reviews,” PMC11191165. DOI/PMID not confirmed from the retrieved full-text record.
- **Full text read**: Yes; Europe PMC full-text XML (PMC11191165).
- **Design**: Cross-sectional study comparing assessments of the same RCT across Cochrane reviews.
- **Sample**: Hypertension-related Cochrane reviews and RCTs that appeared in multiple reviews; the paper reports agreement/disagreement by RoB domain. Exact total counts are not reproduced here because the relevant table values were not reliably extracted from the XML during this pass.
- **Tool**: The paper analyzes published Cochrane risk-of-bias judgments; conclusions discuss subjective RoB assessment and different information extracted for the same domain.
- **Headline results**: Authors report numerous disagreements for the same RCT and note that reviewers sometimes extracted different information for the same domain. They caution that repeated appearances of one RCT can also reproduce identical assessments, affecting how discrepancies are counted. Use the paper as qualitative corroboration unless exact denominators are checked against its tables.
- **Quotable sentences**: “The assessment of RoB was subjective” and reviewers might not use the same definitions or interpret evidence in the same way. (Discussion); “we found a large number of disagreements for the same RCT, and different reviewers extracted different information for the same RoB domains.” (Discussion).
- **Bearing on our manuscript**: Further supports the reference-noise argument, but its setting is Cochrane reviews in one clinical area and the retrieved data extraction did not establish exact prevalence.
- **Implication for ARBITER manuscript**: Avoid implying that published assessments are uniformly wrong; emphasize the specific limitation that a published label is not a settled gold standard.

## Pollock et al. 2024, Cochrane Evidence Synthesis: practical lessons for RoB 2

- **DOI / IDs**: “Ten tips for successful assessment of risk of bias in randomized trials using the RoB 2 tool: Early lessons from Cochrane”; PMC11795937. DOI was not confirmed from the retrieved full text.
- **Full text read**: Yes; Europe PMC full-text XML (PMC11795937).
- **Design**: Methods and implementation guidance based on Cochrane’s phased implementation experience; not a reliability trial.
- **Sample**: No independent trial sample for a performance estimate. It synthesizes operational lessons and supporting methodological literature.
- **Tool**: RoB 2.
- **Key findings relevant to opening**: The authors recommend specifying the outcome, measure, time point, and effect of interest in advance; piloting the tool; and preparing review-specific guidance so the team discusses discrepancies and applies signaling questions consistently. They also note that prior research found review authors often fail to report judgments or supporting evidence fully.
- **Quotable sentences**: “Do pilot the tool to reduce inconsistency in judgments.” (Table 2, tip 3); “many review authors do not fully report their judgments or supporting evidence for them, either within the main text of the systematic review or as supplementary information.” (Tip 10 discussion).
- **Bearing on our manuscript**: Supports transparency and reproducible supporting evidence as practical needs. It does not quantify inter-rater reliability or establish errors in any particular published RoB 2 review.
- **Implication for ARBITER manuscript**: Cite as implementation guidance showing that consistency depends on advance specification, piloting, and reporting of supporting evidence—not simply access to the generic tool.

## Flemyng et al. 2025, JBI Evidence Synthesis: cross-organization position on AI in evidence synthesis

- **DOI / IDs**: 10.11124/JBIES-25-00480; PMC12594113.
- **Full text read**: Yes; Europe PMC full-text XML (PMC12594113), including the recommendations and table.
- **Design**: Multi-organization position statement endorsed by Cochrane, Campbell Collaboration, JBI, and the Collaboration for Environmental Evidence; not an empirical study.
- **Sample**: Not applicable.
- **Governance requirements**: Authors remain accountable for the synthesis and the decision to use AI. AI use must not compromise rigor or integrity and must have human oversight. Any AI use that makes or suggests judgments must be fully and transparently reported. The statement supports RAISE and calls on developers to provide public information about how tools work, publicly available testing/training/validation evaluations with transparent scope, data sources and methods, and clear strengths, limitations, and potential biases. Reporting should identify system/tool and version/date, purpose and affected stages, justification and validation, verification steps, limitations, and—where practical—public inputs, outputs, datasets, and code.
- **Quotable sentences**: “AI and automation in evidence synthesis should be used with human oversight.” (Key messages); “Any use of AI or automation that makes or suggests judgments should be fully and transparently reported in the evidence synthesis report.” (Key messages); “AI tool developers should proactively ensure their AI systems or tools adhere to the RAISE recommendations” (Key messages).
- **Bearing on our manuscript**: Provides direct governance support for ARBITER’s human oversight, reporting, validation and inspectable evidence trail. It is normative guidance, not evidence that any particular system meets the requirements.
- **Implication for ARBITER manuscript**: Connect source retention, passage verification, rule-based scoring and audit records to the reporting and developer-evaluation expectations; describe human responsibility and adjudication plainly.

## RAISE 2025, Responsible AI in Evidence SynthEsis recommendations

- **DOI / IDs**: OSF DOI 10.17605/OSF.IO/FWAUD. The position statement references RAISE recommendations and associated guidance (practice; building/evaluating tools; selecting/using tools).
- **Full text read**: Partial. The recommendations’ content was extracted from Flemyng et al.’s full-text account and Table 1; the OSF documents themselves were not independently read in this pass.
- **Requirements relevant here**: Authors are accountable for content, methods, findings, and how AI affects the synthesis; critically assess tool evaluations and context-specific applicability; justify use by showing methodological soundness; disclose AI that makes or suggests judgments, including risk-of-bias appraisal; report system/version/date, purpose, modifications, validation, verification, limitations and interests. Tool developers should publish how a system works and its terms, transparent testing/training/validation evaluations, and known strengths, limitations and biases.
- **Quotable sentences**: “Remain ultimately responsible for the evidence synthesis” (Table 1 heading); “Report AI use in your evidence synthesis manuscript transparently” (Table 1 heading). These short headings are reproduced verbatim from the position statement’s presentation of RAISE.
- **Bearing on our manuscript**: Reinforces auditable, transparent reporting as a field-level expectation, including evaluation by developers. Because the primary OSF guidance was not read directly, cite the position statement for these descriptions unless independently checking the RAISE versions.
- **Implication for ARBITER manuscript**: Describe this study as an evaluation of a specific, versioned workflow and release enough methods/artifacts to let readers judge applicability and limitations.

## Laignelot et al. 2026, Journal of Clinical Epidemiology: systematic review of LLMs across review tasks

- **DOI / IDs**: 10.1016/j.jclinepi.2026.112221; PMID 41831731.
- **Full text read**: No. PubMed/Europe PMC abstract record read; full text not obtained.
- **Design**: Systematic review of studies evaluating LLMs for systematic-review and meta-analysis tasks. Searches of PubMed, Embase, Cochrane Library and preprint platforms through January 14, 2025; paired reviewers extracted data and assessed risk of bias.
- **Sample**: 3,889 unique references screened; 63 studies included, 52 with performance metrics, yielding 148 LLM performance assessments. 114/148 assessments (77%) evaluated GPT models.
- **Tool / outcomes**: LLMs across review tasks, including risk-of-bias assessment. The six RoB assessments were not restricted in the abstract to RoB 2.
- **Pooled findings**: RoB-assessment accuracy ranged 0.44–0.90, median 0.62 (IQR 0.53–0.76; n=6). This is a small evidence base; unlike screening tasks, the RoB evidence was summarized with accuracy rather than a pooled κ. The review found more consistent performance for screening and greater variability for complex interpretive tasks.
- **Authors’ stated gaps/conclusion**: The abstract concludes that safeguards and careful implementation are needed; it frames complex tasks such as methodological-quality assessment as more variable than screening. The small number of RoB assessments is a clear limitation of the evidence base.
- **Quotable sentences**: “For the ‘risk of bias assessment’ task, accuracy ranged from 0.44 to 0.90 (median = 0.62, IQR 0.53-0.76, n = 6).” (Abstract, Results); “their successful integration will require appropriate safeguards and careful implementation.” (Abstract, Conclusions).
- **Bearing on our manuscript**: Supports a cautious gap statement: current evidence for LLM risk-of-bias assessment is sparse and heterogeneous, rather than establishing reliable general performance. Abstract does not resolve G1–G5 individually.
- **Implication for ARBITER manuscript**: Report the six-assessment base and broad accuracy range; avoid treating this review as a pooled estimate of RoB 2 performance or a direct comparison of auditable versus unauditable architectures.

## Worker summary

Human RoB 2 assessment has documented low overall agreement (κ 0.16) and a mean 28-minute burden per outcome; review-specific calibration improved agreement in one small implementation study, but required about 40 hours to develop and pilot. Studies of the same RCT across reviews show that published judgments can vary, often because reviewers interpret incomplete reports differently. Cochrane implementation guidance calls for piloting and complete supporting-evidence reporting. The Cochrane/Campbell/JBI/CEE position statement and RAISE provide a strong governance rationale for human oversight, transparent reporting of judgment-generating AI, public validation information, and developer accountability.

For G1–G5, these opening sources do not establish whether prior LLM systems computed RoB judgments in code (G1), verified source passages or kept audit records (G2), or used blinded expert adjudication (G4); those require the LLM-specific extraction. They support the premise behind G3: review labels vary and should not be assumed error-free. They provide governance support for G2-like auditability and for open evaluation, without proving that an audit trail itself improves judgment accuracy. Surprise: implementation guidance may improve reliability substantially but can itself be costly, while the recent review found only six LLM risk-of-bias performance assessments and a wide accuracy range (0.44–0.90).
