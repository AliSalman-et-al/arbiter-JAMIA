# Prior-work comparison: evidence and coding notes

Curated 19 October 2026 for Round 14 WP-T. Revised for WP-T round 2. RobotReviewer (Marshall 2016) is added first at the user’s request to show the RoB 1 lineage; the ten existing rows retain their relative order and footnote letters. Read BRIEF, WP-T, SYNTHESIS and w1–w8; the extraction files are leads, not sources of proof. Downloaded full texts and working extracts are under `/tmp/wp-t/` only. This file and the accompanying CSV are the only repository files written for WP-T. No commit was made.

## Column definitions

`Yes` means the feature is documented, not that it is correct or superior. `No` requires affirmative evidence of absence in the described procedure. `Not reported` means the inspected full text cannot establish presence or absence; never display it as `No`. `Partly` has the feature-specific meaning below. Silence is never `Partly`.

| Feature column | Yes | Partly | No | Not reported |
|---|---|---|---|---|
| `rules_applied_in_code` | Official instrument decision/aggregation rules implemented in executable code. | Rules derived in a spreadsheet, or only part of the rules implemented; automation not fully established. | Described rating computation uses learned prediction or model judgment instead of instrument-rule code. | No adequate implementation evidence. |
| `rules_enforced_during_assessment` | Software controls the answer-to-rating path during assessment, including any explicit, recorded override route. | Integrated rule calculation in only some configurations, or aggregation without complete answer/skip-logic enforcement. | Ratings generated directly by the model/classifier; any rule recalculation occurs only afterward. | Assessment-time enforcement cannot be established. |
| `rule_breaks_measured` | Quantified conformance/violations against rules using the system’s own answers. | Overall-only checks or qualitative direct-versus-derived comparisons without a domain-level violation denominator. | Authors explicitly state rule conformance was not examined. | No conformance measurement described; predictive accuracy alone does not count. |
| `quotations_verified_against_stored_source` | Assessment quotations checked for occurrence in an identified, retained source, with verifiable source binding. | Source-based semantic support judging with quoted evidence, without deterministic occurrence/source-integrity checks. | Authors explicitly report no checking of assessment quotations against sources. | Retrieval/extraction alone, or silence about output verification. Training-label matching does not count. |
| `audit_file` | Retained assessment/source/verification bundle independently checkable by another reader. | Retained original/edited responses or structured evidence-verdict records, without a complete verifiable source bundle. | Authors explicitly report no retained reviewable assessment record. | Retention/export of a reviewable assessment record is not established; a displayed interface alone is insufficient. |
| `agent_with_tools` | Assessing agent invokes external tools/services during the assessment. | Web browsing enabled in chat, or an LLM coupled to a retrieval pipeline for assessment or post hoc verification, without demonstrated agent tool calling. | Explicitly tool-free assessment, or a non-agent supervised classifier; ordinary text preprocessing/prompt assembly is insufficient. | Tool use or retrieval not established; calling a structured prompt an agent is insufficient. |
| `independent_reference_or_adjudication` | Newly produced human RoB ratings independent of model output, or blinded adjudication of disputed RoB ratings. | Limited author re-examination, independent historical-team reference selection, or new human evaluation limited to supporting-text relevance. | Published reference labels reused without new reference review/adjudication or independently selected duplicate-team reference. | Independence/reference review cannot be established. |
| `registry_or_protocol_given` | Available trial registry records or protocols/SAPs supplied to or demonstrably retrieved by the model as part of the assessment inputs. Does not require both types or a record for every trial. | Compressed/summary material, delivery only to some model arms, or restricted delivery of otherwise available ancillary records. | Described inputs/workflow exclude trial registry/protocol material; a registration number or protocol-availability flag alone does not count as the record. | Availability to the model cannot be established, including enabled browsing without demonstrated retrieval. |

The two design columns use restricted vocabularies rather than forcing `Partly` or `Not reported` into a `No` cell:

| Design column | Yes | No | Not applicable | Partly / Not reported |
|---|---|---|---|---|
| `identical_inputs_across_compared_arms` | Compared model/workflow arms receive the same underlying trial source material in a specified matched comparison. | A documented difference in trial source material or its availability across those arms. | One assessed model/workflow arm, with repeat runs not counted as separate arms. | Not used here: each multi-arm decision has evidence below. Unresolved input identity would require `Not reported`, not `No`. |
| `same_model_with_and_without_system` | A matched comparison holds base model and trial source material fixed while adding/removing an assessment system/workflow. | Multi-arm study varies models, context amount, or reasoning settings, or only recalculates/verifies an existing output afterward; no qualifying with/without assessment comparison. | Single assessed model/workflow arm. | Not used (requested vocabulary: Yes / No / Not applicable). Huang’s post hoc rule derivation is recorded as a partial precursor in prose, not as a second assessment arm. |

“Inputs” in the design columns means underlying trial source material made available to the workflow. Prompt guidance, rules and internal retrieval/delivery are system interventions, not additional trial sources. Human reference assessors are excluded. A `Yes` can identify a matched subcomparison without claiming every exploratory configuration had identical context: ROBoto2’s matched model comparisons and Choi’s Gemini/Gem pair are explicitly scoped below. Same source documents do not prove identical token streams or document parsing.

`study_id` is a stable identifier; `citation_short` is a display label; `reference_key` is a short manuscript-reference callout, not a unique bibliographic identifier; `doi` is the verified DOI (blank for this study); `tool` is the RoB instrument; `n_trials` is the reported study corpus unless the row explicitly identifies an evaluation cohort (Saadi includes nonrandomised studies); `reference_standard` describes the comparator; `note_marks` links table footnotes. These are descriptive fields, so Yes/Partly/No/Not reported do not apply.

All ten external main full texts were inspected (including PMC full text for RobotReviewer); supplements and underlying implementations were not exhaustively audited. Quotations below locate the source passages; a quotation beside `Not reported` describes the reported inputs and does not prove absence. The study’s own preregistration is not a trial protocol supplied to its model.

## 0. Marshall 2016 / RobotReviewer — k

**Citation:** Marshall IJ, Kuiper J, Wallace BC. RobotReviewer: evaluation of a system for automatically assessing bias in clinical trials. *Journal of the American Medical Informatics Association*. 2016;23(1):193–201. doi:10.1093/jamia/ocv044. Authors, DOI and issue verified against [PMC full text](https://pmc.ncbi.nlm.nih.gov/articles/PMC4713900/) and its front matter. Online publication was 22 June 2015; 2016 is the issue year and requested reference key.

| Cells | Full-text anchor quotation | Location and coding reason |
|---|---|---|
| citation_short; reference_key; doi; study_id; note_marks | “RobotReviewer” | Front matter: author initials, DOI and issue above; identifier and footnote are curator-assigned. |
| tool — RoB 1; n_trials — 12808 | “Cochrane Risk of Bias”; “12,808” | Abstract/Methods: original six-domain instrument, not RoB 2; PDF corpus for training/evaluation. This is NOT the unique held-out evaluation count: Table 1 sums 6,610 domain instances, and reports domain-specific denominators. Supporting-text evaluation Methods reports 371 trials (Table 2 sums 378 domain instances). |
| rules_applied_in_code — No; rules_enforced_during_assessment — No; agent_with_tools — No | “Support Vector Machine” | Methods, Machine-Learning Approach: learned document/sentence classifiers, not official decision-rule execution or a tool-calling agent. Three classifiers use held-out trial reports; model internals differ. |
| registry_or_protocol_given — No | “Linking with this dataset may yield better performance.” | Discussion, selective reporting limitation: protocol/registry linkage is future work; current models use trial-publication text. |
| identical_inputs_across_compared_arms — Yes; same_model_with_and_without_system — No | “test data” | Evaluation, Task 1: the held-out duplicate-assessment trial set is used across three classifier variants. This compares different classifiers, not the same model with/without an assessment workflow. |
| reference_standard; independent_reference_or_adjudication — Partly | “blinded expert panel” | Introduction and Evaluation: historical independent Cochrane assessments supply RoB labels; newly recruited blinded experts assess supporting-text relevance only. No newly adjudicated RoB reference is implied. |
| rule_breaks_measured; quotations_verified_against_stored_source; audit_file — all Not reported | Same classifier/evaluation passages above | The paper measures prediction accuracy and sentence relevance, not rule breaks, output-quotation occurrence in retained sources, or a retained independently checkable assessment file. Exact matching used to construct sentence-training labels is not output verification. The prototype interface does not establish an audit file. |

**Reason for addition:** Requested historical lineage: supervised RoB 1 automation predates the LLM studies. Retain corpus/evaluation and text-relevance/RoB-reference distinctions in any display. No off-table extraction lead is used as proof.

## 1. Eisele-Metzger 2025 — a

**Citation:** Eisele-Metzger A, Lieberum J-L, Toews M, Siemens W, Heilmeyer F, Haverkamp C, Boehringer D, Meerpohl JJ. Exploring the potential of Claude 2 for risk of bias assessment: Using a large language model to assess randomized controlled trials with RoB 2. *Research Synthesis Methods*. 2025;16(3):491–508. doi:10.1017/rsm.2025.12.

**Full text:** [Europe PMC XML, PMC12527486](https://www.ebi.ac.uk/europepmc/webservices/rest/PMC12527486/fullTextXML).

| Positive cell | Verbatim excerpt | Location and scope |
|---|---|---|
| rule_breaks_measured — Partly | “checked the 100 overall judgements” | Methods, Data analysis: overall-rule check only; 2/100 violations; not signalling-answer/domain conformance. |
| independent_reference_or_adjudication — Partly | “We reviewed all ‘two-level discrepancies’” | Methods, Data analysis: unblinded author review against sources, not an independent panel or replacement reference. |

**Other decisions:** The model supplied domain and overall ratings; prompt assembly and protocol compression used Patchbay. Hence no software enforcement or tool-using assessment agent is demonstrated by that described procedure. Code application in a separate analysis is not established. `registry_or_protocol_given=Partly`: compressed ancillary records were supplied when available (evidence below); human/model source differences no longer determine this column.

**Lead corrections:** None to the row's substantive w1 findings. Do not convert its overall-only check into domain-level enforcement or its discrepancy review into blinded adjudication.

**Unverified:** rules_applied_in_code; quotations_verified_against_stored_source; audit_file.

## 2. Huang 2025 — b

**Citation:** Huang J, Lai H, Zhao W, Xia D, Bai C, Sun M, Liu J, Liu J, Pan B, Tian J, Ge L. Large Language Model–Assisted Risk-of-Bias Assessment in Randomized Controlled Trials Using the Revised Risk-of-Bias Tool: Evaluation Study. *Journal of Medical Internet Research*. 2025;27:e70450. doi:10.2196/70450.

**Full text:** [Europe PMC XML, PMC12238788](https://www.ebi.ac.uk/europepmc/webservices/rest/PMC12238788/fullTextXML).

| Positive cell | Verbatim excerpt | Location and scope |
|---|---|---|
| rules_applied_in_code — Partly | “using Excel based on the RoB2 decision algorithm” | Discussion, Principal Findings: secondary spreadsheet derivation; executable formulas/automation are not established. |
| rule_breaks_measured — Partly | “investigated the discrepancies” | Methods, Statistical Analysis: direct versus algorithm-derived judgments compared; no violation count/rate. |
| independent_reference_or_adjudication — Yes | “initially conducted independent judgments” | Methods, Establishment of the Criterion Standard: three trained reviewers, then consensus. |
| registry_or_protocol_given — No | “excluding Multimedia Appendices and protocols” | Discussion, Principal Findings; Limitations additionally excludes registration documents. Protocol availability is metadata, not delivery of a protocol. |

**Other decisions:** Ratings were first generated by the LLM; later spreadsheet derivation does not enforce the assessment path. The 46 trials include six used for prompt development; performance validation uses 40.

**Lead corrections:** None to w2's substantive row extraction. The `Partly` spreadsheet cell must not be shortened to automated code enforcement. Rule-break checking was qualitative/comparative, not a reported contradiction rate.

**Unverified:** quotations_verified_against_stored_source; audit_file; agent_with_tools. Automated Excel implementation is also unverified beyond the partial cell.

## 3. Lai 2026 — c

**Citation:** Lai Y-J, Lin S-H, Liu J-W. Evaluating the Accuracy of Large Language Models in Risk-of-Bias Assessment Using Version 2 of the Cochrane Risk-of-Bias Tool for Randomized Trials: Exploratory Feasibility Study. *Journal of Medical Internet Research*. 2026;28:e84915. doi:10.2196/84915.

**Full text:** [Europe PMC XML, PMC13614218](https://www.ebi.ac.uk/europepmc/webservices/rest/PMC13614218/fullTextXML).

| Positive cell | Verbatim excerpt | Location and scope |
|---|---|---|
| independent_reference_or_adjudication — Partly | “manually corrected based on research team consensus” | Methods, Establishment of the Reference Standard; Results sensitivity analysis: corrections to Toouli assessments, not a new blinded reference. |

**Other decisions:** Decision-tree rules were placed in the prompt and the LLM emitted judgments; this establishes no software enforcement. Full trial text was uploaded; delivery or retrieval of a trial registry/protocol is not established.

**Lead corrections:** w2 describes one apparent typo without its domain scope: the full text identifies errors in Toouli domains 2, 3 and 4. The primary analysis retained published ratings; correction was a sensitivity analysis. Bibliographic disambiguation: this is Yu-Ju Lai, not Huang coauthor Honghao Lai; the synthesis's “Lai H” citation needs correction.

**Unverified:** rules_applied_in_code; rule_breaks_measured; quotations_verified_against_stored_source; audit_file; agent_with_tools; registry_or_protocol_given.

## 4. Nyrhi 2026 — d

**Citation:** Nyrhi L, Ponkilainen V, Laaksonen J, Kuikka L, Paljakka L, Karjalainen T, Mattila VM, Kuitunen I. Large language models for risk-of-bias assessment in randomised clinical trials—a comparative validation study. *EBioMedicine*. 2026;126:106238. doi:10.1016/j.ebiom.2026.106238.

**Full text:** [Europe PMC XML, PMC13054287](https://www.ebi.ac.uk/europepmc/webservices/rest/PMC13054287/fullTextXML); eAppendix 1, Deviations From the Preregistered Protocol, in the [supplementary-files archive](https://www.ebi.ac.uk/europepmc/webservices/rest/PMC13054287/supplementaryFiles). The latter was downloaded and read for round 2.

| Positive cell | Verbatim excerpt | Location and scope |
|---|---|---|
| registry_or_protocol_given — Yes | “PDF-versions of their protocols when available” | Methods, Prompt development and standardisation: available protocols supplied; DeepSeek received copied protocol text (eAppendix 1). Missing protocols for some trials do not turn documented delivery into Partly; the new feature does not require a protocol for every trial. |

**Other decisions:** This row is the 100-trial RoB 2 cohort, not the additional 100 RoB 1 trials. Methods specifies base web-chat modes without added features and explicitly says review procedures were not audited. Published ratings remain the reference. Prompt-generated ratings were not software-enforced.

**Lead corrections:** None to w3's principal findings. Its mention of protocols must retain the DeepSeek delivery-format exception. The supplement clarifies manual copying of protocol text; the exception does not establish absent protocol sources.

**Unverified:** rules_applied_in_code; rule_breaks_measured; quotations_verified_against_stored_source; audit_file. The exact completeness of ancillary inputs is unverified beyond `Partly`.

## 5. Gandhi 2026 — e

**Citation:** Gandhi S, Shokravi A, Chelliahpillai Y, Balas M. Evaluating large language model performance in Risk of Bias assessments: A cross-sectional validation study. *PLOS One*. 2026;21(7):e0353155. doi:10.1371/journal.pone.0353155.

**Full text:** [Europe PMC XML, PMC13349098](https://www.ebi.ac.uk/europepmc/webservices/rest/PMC13349098/fullTextXML).

| Positive cell | Verbatim excerpt | Location and scope |
|---|---|---|
| agent_with_tools — Partly | “web-browsing capabilities enabled” | Methods, Data collection and RoB assessment: capability enabled; actual external searches not logged/quantified. |
| independent_reference_or_adjudication — Yes | “masked to the OSRA’s assessments” | Same section: three reviewers independently re-rated all 50 trials; consensus/fourth reviewer resolved their differences. |

**Other decisions:** The model produced ratings from a PDF and branching-logic prompt. `registry_or_protocol_given=Not reported`: the panel retrieved registries, but enabled model browsing does not establish either successful retrieval or its absence.

**Lead corrections:** w4's categorical G5 statement that no tool-using workflow was reported is too strong: browsing was enabled, so the table records partial tool capability. Add a detail omitted from w4: Results, Interrater agreement reports panel percent agreement 60–90%, weighted κ 0.21–0.74, and overall agreement 70%, κ 0.56. This is not blinded adjudication limited to model/published disagreements.

**Unverified:** rules_applied_in_code; rule_breaks_measured; quotations_verified_against_stored_source; audit_file; registry_or_protocol_given. Actual browsing use remains unverified beyond `Partly`.

## 6. Choi 2026 — f

**Citation:** Choi J, Swan H, Kim MJ, Kim HJ. Variability, algorithm conformance, and accuracy of large language model–based tools for risk-of-bias (RoB 2.0) assessment of randomized trials: a pilot study. *Journal of Evidence-Based Practice*. 2026;2(2):91–97. doi:10.63528/jebp.2026.00011.

**Full text:** [Publisher full article and tables](https://www.e-jebp.org/journal/view.php?number=21).

| Positive cell | Verbatim excerpt | Location and scope |
|---|---|---|
| rules_applied_in_code — Yes | “implemented in code” | Methods, RoB 2.0 Algorithm Implementation: authors recomputed domain judgments. |
| rules_enforced_during_assessment — Partly | “official flowchart aggregation logic” | Methods, Study Design and Data: ROBoto2 component only; general Gemini/Gems emit ratings. |
| rule_breaks_measured — Yes | “conformance was 43%” | Results, Algorithm Conformance and Internal Consistency: 43%, 51%, 60% across configurations; skip logic also checked. |
| agent_with_tools — Partly | “reference knowledge” | Methods, Study Design and Data: Gems retrieval and ROBoto2 pipeline, not demonstrated autonomous tool calls. |
| independent_reference_or_adjudication — Yes | “One experienced reviewer’s assessment served as the reference.” | Methods, Study Design and Data: a single expert, not a blinded panel. |

**Other decisions:** One trial, 38 runs: 13 Gemini, 15 Gems, 10 ROBoto2. Integrated flowchart calculation did not guarantee displayed answer/rating consistency; the authors leave the cause unresolved.

**Lead corrections:** w8's G3 claim of no attempt to correct reference-label error is overbroad: three expert transcription errors were detected and corrected. This does not establish a new independent reference-error study. Keep the already corrected first author Choi, not Kim.

**Unverified:** quotations_verified_against_stored_source; audit_file; registry_or_protocol_given. The cause of ROBoto2 inconsistency is unverified.

## 7. Hevia 2025 / ROBoto2 — g

**Citation:** Hevia A, Chintalapati S, Lai VKW, Tam NT, Wong W-T, Klassen TP, Wang LL. ROBOTO2: An Interactive System and Dataset for LLM-assisted Clinical Trial Risk of Bias Assessment. In: *Proceedings of EMNLP 2025: System Demonstrations*. 2025:12–25. doi:10.18653/v1/2025.emnlp-demos.2. Author manuscript: arXiv:2511.03048.

**Full text:** [arXiv HTML v1](https://arxiv.org/html/2511.03048v1); [ACL bibliographic record](https://aclanthology.org/2025.emnlp-demos.2/).

| Positive cell | Verbatim excerpt | Location and scope |
|---|---|---|
| rules_applied_in_code — Yes; rules_enforced_during_assessment — Partly | “implement the logic provided by the ROB2 flowcharts” | Section 4, Domain-level and overall judgments: integrated software aggregation; not proven rejection of invalid/incomplete answers, and Choi found displayed inconsistencies. |
| audit_file — Partly | “retains the original LLM responses and rationales” | Section 4, Collecting user feedback: original and human-edited records retained; no independently verified source-integrity bundle. |
| agent_with_tools — Partly | “retrieved evidence paragraphs as context” | Section 4, Answering signaling questions: retrieval pipeline, not autonomous agent tool selection. |
| independent_reference_or_adjudication — Yes | “245 reports” | Section 5, Annotation procedure: manually assessed expert subset used for every LLM evaluation. |

**Other decisions:** `n_trials=521` is the full dataset; 245 manual reports underpin evaluation, and 276 assisted reports were withheld. Retrieved passages alone do not establish quotation verification. The 2025 paper reports no rule-break rate; Choi's later measurements belong to its own row.

**Lead corrections:** Add the verified proceedings DOI. w5's quoted flowchart sentence is a paraphrase, not the wording in the full text; the table above uses the actual wording. Its 521/245 distinction is correct and must survive display shortening. Retained original/edited records support partial auditability, rather than an unqualified absence of an audit record.

**Unverified:** rule_breaks_measured; quotations_verified_against_stored_source. Independent source-integrity verification and autonomous tool use remain unverified beyond partial cells.

## 8. Liang 2026 — h

**Citation:** Liang Z, Sheffield C, Butera G, Antani S. Retrieve-Then-Verify for Evaluating Evidence Support and Hallucination in Large Language Model–Generated Medical Information: Empirical Study. *JMIR AI*. 2026;5:e93761. doi:10.2196/93761.

**Full text:** [Europe PMC XML, PMC13628037](https://www.ebi.ac.uk/europepmc/webservices/rest/PMC13628037/fullTextXML).

| Positive cell | Verbatim excerpt | Location and scope |
|---|---|---|
| quotations_verified_against_stored_source — Partly | “a verbatim quotation drawn from the retrieved trial text” | Methods, Retrieval-Based Evidence Support and Hallucination Assessment: GPT-5 judge supplies quoted support verdicts; no deterministic occurrence/hash check established. |
| audit_file — Partly | “returned structured JSON” | Same section: verdict, quote and rationale are reviewable; no complete independently verifiable source bundle established. |
| agent_with_tools — Partly | “post hoc claim verification” | Discussion, Limitations: BM25 plus judge pipeline evaluates generated claims; no autonomous assessment agent established. |

**Other decisions:** Schema-constrained model ratings followed by source-support evaluation do not establish software-enforced RoB algorithm judgments. The reference is the existing Cochrane review, not new independent adjudication.

**Lead corrections:** w8 incorrectly says time was not reported: Discussion, Interpretation, Implications, and Comparison With Prior Work reports 50–158 seconds per study. Specify the verifier is GPT-5, not independent human or deterministic quote checking. JSON verdict/quotation/rationale records justify partial auditability. Code is available on request, not publicly released (Data Availability).

**Unverified:** rules_applied_in_code; rule_breaks_measured. Locked-source quotation occurrence and independent bundle verification remain unverified beyond partial cells.

## 9. Saadi 2026 / ROBINS-I — i

**Citation:** Saadi S, Fleti F, Rajjoub OH, Shamsi Basha A, Firwana M, Abideen Z, Rajjo T, Wang Z, Murad MH. Comparison of three large language models' ability to assess the risk of bias using ROBINS-I tool. *BMJ Digital Health & AI*. 2026;2(1):e000034. doi:10.1136/bmjdh-2026-000034.

**Full text:** [Europe PMC XML, PMC13528376](https://www.ebi.ac.uk/europepmc/webservices/rest/PMC13528376/fullTextXML). Publisher routes returned 403; the lead DOI returned 404.

| Positive cell | Verbatim excerpt | Location and scope |
|---|---|---|
| agent_with_tools — Not reported | “customised agent-based implementations” | Methods, LLM assessment workflow: structured prompting is established, but neither retrieval nor external tool calling is demonstrated. Prior Partly changed to Not reported. |
| independent_reference_or_adjudication — Partly | “two separate teams of human reviewers” | Methods, Study design and data source: concordant historical review ratings selected, not new adjudication. |

**Other decisions:** 171 nonrandomised studies, not trials; domain denominators vary. Models emitted categorical ratings. Paper-only input versus additional protocol context is explicit in Implications, so `registry_or_protocol_given=No`.

**Lead corrections:** w8's DOI `bmjdth` is wrong; use `bmjdh`. Full text is now available. It specifies GPT-5.2 Instant, Gemini 3 Fast, Claude Opus-4-6, with February 2026 assessment. Accuracy includes only internally consistent model ratings as well as concordant human ratings; this extra selection was omitted from w8. Full-text tables provide results, superseding its unavailable-results caveat.

**Unverified:** rules_applied_in_code; rule_breaks_measured; quotations_verified_against_stored_source; audit_file; agent_with_tools. Agent tool calling or retrieval remains unverified; `agent_with_tools` is `Not reported`.

## 10. This study / ARBITER — j

**Citation:** This study (ARBITER), 102-trial analysis set; unpublished repository study, no DOI assigned here.

**Repository sources only:** `ANALYSIS-PLAN.md` (sections 5.4, 5.8 and 7), `kit-sonnet-5.5/README.md`, `no-kit-sonnet-5.5/README.md`, `analysis/output/tables/table3.csv`, `analysis/output/tables/audit-summary.csv`. These were read from the shared checkout; other workers may regenerate outputs. No source was edited.

| Positive cell | Verbatim excerpt | Location and scope |
|---|---|---|
| rules_applied_in_code — Yes | “ARBITER's server proposes the algorithm judgement.” | ANALYSIS-PLAN, section 5.4, resolution dated 18 October 2026. |
| rules_enforced_during_assessment — Yes | “The assessing model may adopt a different judgement only through a reasoned override” | Same resolution: enforced proposal/recording path, not a claim that overrides are impossible. |
| rule_breaks_measured — Yes | “share,0,0,0,10000,ARBITER-Sonnet,Violation,510,0,0,D1-D5,” | table3.csv, ARBITER D1–D5 violation row; Unassisted departure row records 65/509, with one missing answer. |
| quotations_verified_against_stored_source — Yes | “every quotation is found in a stored source” | ANALYSIS-PLAN, section 7, Resolution; audit-summary.csv reports 1407/1407 text-span and 14/14 visual evidence bindings. |
| audit_file — Yes | “containing `canonical.json` and `verification.json`” | ANALYSIS-PLAN, section 5.8, bundle definition; audit-summary.csv reports 102/102 bundle verification. |
| agent_with_tools — Yes | “The session loaded only the rob2-kit plugin and its MCP server.” | kit-sonnet-5.5/README.md, Setup. |
| independent_reference_or_adjudication — Yes | “Blinded dual adjudication of the disagreement cells” | ANALYSIS-PLAN, section 7, Action: adjudicators first rated independently, then chose among blinded labels. |
| registry_or_protocol_given — Yes | “the 60 protocol and SAP PDFs rob2-kit acquired from ClinicalTrials.gov” | no-kit-sonnet-5.5/README.md, Inputs; kit-sonnet-5.5/README.md, opening paragraph: registry document acquisition enabled. Availability varies by trial; Yes records delivery of the complete acquired ancillary set to both arms, not that every trial had a protocol. |

**Qualification:** No domain overrides were recorded in 510 domains. The plan explicitly permits reasoned, recorded overrides; do not describe the architecture as forbidding every departure from an algorithm proposal. Quotation occurrence and structural/visual binding do not establish that evidence supports an answer. Adjudication covers disputed D1–D5 cells, not all cells or Overall. `n_trials=102` is the analysis set, although run READMEs describe 105 original cases.

**Lead correction affecting comparison:** w8's proposed novelty wording that software exclusively emits algorithm-derived ratings and the synthesis's absolute algorithm-only claim require the recorded-override qualification from the repository.

**Unverified cells:** None in the requested schema. Semantic support for every quotation, universal absence of overrides, and adjudication of agreed/Overall cells are not claimed.

## Verification limits and complete unverified-cell list

The per-row **Unverified** lists, as updated by the input/design recheck below, enumerate the `Not reported` cells. The narrower unsupported components of `Partly` are also stated there or directly beside the evidence. No entire external main text was unavailable, and no positive cell relies on an abstract or an extraction-file quotation alone. Supplements and underlying implementations were not exhaustively audited; `Not reported` is bounded to inspected full texts, not a claim about all possible author artifacts.

Corrections are recorded here without modifying w1–w8. w6 and w7 contain no additional selected Table 4 rows; they do not supply proof for positive cells. Corrections reported here concern the requested comparison and errors encountered while verifying it, not a fresh audit of every off-table study in those files.

## Round-2 input and design recheck (all rows)

The user clarified that compared arms exclude human references and that input identity must follow evidence even when prior work also qualifies. Repeated runs alone do not create arms. The selected Eisele-Metzger row is the Claude 2 main analysis, not the exploratory Claude 3 sensitivity analysis. Huang’s direct/derived output comparison counts for source identity but is not an independent with/without-system assessment. For `same_model_with_and_without_system`, Choi qualifies for Gemini general versus Gem; it does not establish the ROBoto2 backend is the same model.

| Reference key | registry_or_protocol_given: evidence and location | identical_inputs_across_compared_arms: evidence and scope | same_model_with_and_without_system: evidence and scope |
|---|---|---|---|
| Marshall 2016 | No: future linkage quotation in section 0; current publication-text classifier. | Yes: held-out test data across three classifier variants (section 0). | No: different classifiers, not a fixed base model with/without workflow (section 0). |
| Eisele-Metzger 2025 | Partly: “compressed study protocol/analysis plan, if available”; Methods, Claude RoB 2 assessment. Some trials had neither protocol nor register entry; compressed material is partial source delivery. | Not applicable: “evaluate the performance of Claude 2 compared to humans”; Methods, Study design. Three iterations and exploratory prompts do not constitute the main row’s separate model/workflow arms. | Not applicable: single Claude 2 assessment workflow in the selected main analysis. |
| Huang 2025 | No: exclusion quotation in section 2; Limitations also excludes supplementary registration documents. Knowing whether a protocol exists does not deliver the record. | Yes: “derived from LLM-generated signaling question responses”; Results, Internal Validation. The direct and Excel-derived judgments use the very same original responses and trial information. | No: derivation reuses the existing response; it does not re-assess trials using the model inside a system. This is a partial precursor to the requested design, not a qualifying separate system-on arm. |
| Lai 2026 | Not reported: “uploaded the full trial text”; Methods, Application of ChatGPT. No explicit delivery/retrieval or exclusion of ancillary trial records. | Not applicable: “a single LLM under fixed prompting conditions”; Discussion, Limitations. Repeated assessments are reliability runs. | Not applicable: same single workflow, no system-off arm. |
| Nyrhi 2026 | Yes: “PDF-versions of their protocols when available”; Methods, Prompt development and standardisation. Same paragraph excepts DeepSeek PDF upload; eAppendix 1 documents copied protocol text. | Yes: eAppendix 1, Deviations From the Preregistered Protocol: “manual copying of textual content for assessments.” DeepSeek received protocol text instead of protocol PDFs; the underlying trial/protocol source set was maintained, with different delivery format. Exact completeness of copying is not audited. | No: four different models in the same prompted assessment design, not a fixed model crossed with workflow presence (Methods, Large language models evaluated). |
| Gandhi 2026 | Not reported: “theoretically search”; Methods, Data collection and RoB assessment. Limitations: “we did not quantify how frequently”; enabling browsing does not show successful protocol/registry retrieval, or no retrieval. | Not applicable: “ChatGPT-o3”; same Methods section specifies one assessed model and independent new sessions. Human panel and published ratings are references, not model arms. | Not applicable: no model/workflow comparator arm. |
| Choi 2026 | Not reported: “one RCT article”; Methods, Study Design and Data. No affirmative statement about delivery or exclusion of trial registry/protocol material. The RoB manual is instrument guidance, not a trial protocol. | Yes: same article and identical prompt; Methods, Study Design and Data. Differences in manual delivery and architecture are the workflow interventions, not different trial source documents. | Yes: “used the same base model, the same manual, and the same prompt”; same Methods section, Gemini general versus custom Gem. General chat has the manual in context; the Gem delivers it as retrieved reference knowledge. This is a manual-delivery workflow comparison, not ARBITER-style rule/evidence enforcement. |
| Hevia 2025 | No: “within-document evidence retrieval”; Introduction; section 4 describes only the uploaded trial report, parsed paragraphs and selected paper context as the full input pipeline. No protocol/registry source is part of that pipeline. | Yes: “All models receive the same prompt and inputs”; section 6, LLM evaluation. Applies to matched model comparisons within each context setting. Deliberate oracle/top-k/full-paper context experiments differ; GPT-3.5 cannot run full-paper context. | No: all compared LLMs use the pipeline; context/retrieval ablations vary supplied context, and do not test a fixed model with/without the system on identical context (sections 4 and 6). |
| Liang 2026 | No: “Text and tables extracted from each trial report were provided as model input”; Methods, LLM-Based RoB Assessment. The described generation/verification pipeline uses trial-report text, not ancillary trial records. | Yes: shared report context/schema across the three generators; Methods, LLM-Based RoB Assessment and Prompt Engineering and Output Standardization. Same underlying trial sources; model parameters and verifier settings vary. | No: models and reasoning depths vary; retrieve-then-verify judges existing outputs post hoc rather than providing a system-on assessment arm (Discussion, Limitations). |
| Saadi 2026 | No: “paper only vs paper plus protocol-level context”; Implications explicitly proposes that information contrast for future work. Methods describes current full-study-text uploads only. | Yes: “Models were provided with the full text of each study”; Methods, LLM assessment workflow. Shared study documents and standardized domain instructions across three models; no claim of identical vendor parsing. | No: three different model implementations, each assessed twice with its agent workflow; no workflow-off assessment arm (Methods, LLM assessment workflow and Reliability analysis). |
| This study | Yes: protocol/SAP quotation in section 10; kit README opening specifies acquisition enabled; no-kit README Inputs lists registry projections and all acquired protocol/SAP files. | Yes: “the exact Markdown projection”; “nothing re-fetched”; no-kit README, Inputs. It explicitly describes copied kit-run registry records and acquired PDFs alongside the same trial folders. | Yes: “claude-sonnet-5-5”; both READMEs identify the same model/effort. No-kit README: “no rob2-kit”; kit README Setup: plugin and MCP server loaded. Underlying trial inputs match as documented in the preceding cell. |

The registry `Not reported` cells are now Lai, Gandhi and Choi only. All other existing `Not reported` feature cells retain their prior status, except Saadi `agent_with_tools` (added to `Not reported`). Source availability is not inferred from a trial’s registration number, from model browsing capability, or from the evaluation study’s own preregistration.

## Recheck of every original Partly cell

- Eisele-Metzger: overall-only rule checks and limited unblinded author discrepancy review fit their respective partial definitions (unchanged). Compressed ancillary records newly yield `registry_or_protocol_given=Partly`.
- Huang: spreadsheet derivation without established executable automation and qualitative direct/derived comparisons fit partial rule implementation and measurement (unchanged). Old input-parity `Partly` becomes registry delivery `No` under the new construct.
- Lai: limited research-team reference correction fits partial independence/re-examination (unchanged).
- Nyrhi: the old input-parity Partly becomes registry/protocol delivery Yes: available protocols were supplied, including copied text for DeepSeek. The definition does not require a protocol to exist for every trial.
- Gandhi: browsing capability without demonstrated retrieval/tool calls fits partial agent/tool capability (unchanged). Registry receipt remains unestablished.
- Choi: enforcement only in the ROBoto2 configuration, with demonstrated inconsistencies, fits partial enforcement. Gem/ROBoto2 retrieval fits partial tool capability (both unchanged).
- Hevia: integrated aggregation without demonstrated complete answer/skip-logic enforcement, retained original/edited responses, and retrieval-augmented prompting fit partial enforcement, audit file, and tool capability (all unchanged).
- Liang: LLM source-support judgments with quoted evidence, retained structured verification records, and a post hoc retrieval/LLM pipeline fit partial quotation checks, audit file, and tool capability (all unchanged).
- Saadi: historical concordant independent-team selection fits partial reference independence (unchanged). **agent_with_tools: Partly → Not reported**: a custom structured agent prompt is not evidence of browsing, retrieval or tool calling. This is the one original Partly feature cell outside the redefined input column that fails its definition.

## Cell-change ledger

- Schema: rename `input_parity_registry_protocol` to `registry_or_protocol_given`; add `reference_key`, `identical_inputs_across_compared_arms`, and `same_model_with_and_without_system`.
- Registry values versus old input-parity values: Eisele-Metzger No → Partly (compressed ancillary records supplied); Huang Partly → No (ancillary documents excluded); Nyrhi Partly → Yes (available full protocols supplied, including copied text for DeepSeek); Gandhi No → Not reported (actual browsing/retrieval unknown); Hevia Not reported → No (within-report-only pipeline); Liang Not reported → No (explicit report-text-only inputs). Lai Not reported, Choi Not reported, Saadi No and ARBITER Yes retain their strings but were reverified under the new meaning.
- Saadi `agent_with_tools`: Partly → Not reported (structured prompting alone fails the partial-tool definition).
- Every new reference/design cell is shown with its reason in the preceding table; reference keys identify the existing first-author/year citation, with `This study` for the unpublished study.
- Marshall row: all cells newly added; section 0 documents their basis. `note_marks=k` preserves existing footnote letters a–j and avoids relabelling existing rows.
- No other existing CSV value changed. Nyrhi’s new input-identity cell is Yes after reading eAppendix 1: its PDF-upload exception is manual copying of protocol text, not proof of missing protocol sources. The notes replace the old input-parity definition, document all new decisions, add the RobotReviewer citation, and retain the recorded-override qualification.

## Footnote texts for the table

a. Compressed ancillary records were supplied when available; rule checks were overall-only.
b. Excel derivation was post hoc; 46 trials include six prompt-development trials.
c. Rules were in the prompt; published-label corrections were sensitivity analyses.
d. RoB 2 cohort only; protocols were supplied when available; DeepSeek received copied protocol text.
e. A masked panel re-rated all trials; enabled browsing does not establish registry retrieval.
f. One trial, 38 runs; the matched Gemini/Gem comparison changes manual delivery.
g. Dataset: 521 reports; manual evaluation subset: 245. Retrieved passages and edits are not source verification.
h. Post hoc LLM support judgments and JSON records do not establish locked-source quote checking.
i. ROBINS-I: 171 nonrandomised studies; only concordant human and repeat-consistent model ratings enter accuracy.
j. ARBITER permits recorded overrides; none occurred in 510 domains. Adjudication covers disputed cells.

k. RobotReviewer: 12,808-PDF corpus, not the held-out evaluation size; blinded panel judged text relevance only.

Design notes: Input identity concerns model/workflow arms and underlying trial sources, not human references or identical token streams. Choi’s Gemini/Gem pair and this study hold the base model fixed while changing a workflow. Huang recalculates existing responses post hoc. Not applicable denotes a single assessed workflow; Not reported remains distinct from No.
