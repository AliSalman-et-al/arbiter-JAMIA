# Prior-work comparison: evidence and coding notes

Curated 19 October 2026 for Round 14 WP-T. The ten requested rows and their order are unchanged. Read BRIEF, WP-T, SYNTHESIS and w1–w8; the extraction files are leads, not sources of proof. Downloaded full texts and working extracts are under `/tmp/wp-t/` only. This file and the accompanying CSV are the only repository files written for WP-T. No commit was made.

## How to read the cells

- `Yes`: the specified feature is documented; it does not certify correctness or superiority.
- `Partly`: a narrower feature is documented. Its scope is given below.
- `No`: the described procedure shows absence, rather than merely omitting a feature.
- `Not reported`: the full text does not establish the feature. This is not evidence of absence.
- Rules in a prompt do not establish rules applied in code or enforced by software. Spreadsheet derivation is partial code evidence. Post hoc checks are distinct from enforcement during assessment.
- Rule-break measurement includes partial checks: overall-only checking or qualitative comparisons without a violation denominator are `Partly`.
- Quotation verification concerns checking text against the source. Retrieval alone does not qualify. An LLM support judge with source quotations is partial evidence, not proof of exact quotation occurrence or a locked source.
- An audit file means a reviewable assessment record. Retained edits or JSON verification records qualify partly; they do not establish independent source-integrity verification.
- `agent_with_tools=Partly` includes documented retrieval pipelines, custom structured agents, or enabled browsing without demonstrated autonomous tool use. It must not be rendered as an unqualified agent-with-tools claim.
- Independent reference/adjudication: `Yes` includes newly produced human ratings independent of model output, even a single expert. `Partly` covers limited author re-examination or historical concordant-team selection. Neither implies blinded disagreement adjudication.
- Input parity concerns matched information, including available registry/protocol material. Main-text-only matching or partially supplied protocols qualify partly, not as full parity. Silence about matched ancillary sources is `Not reported`.

Quotations below are short verbatim excerpts; surrounding prose states the scope. Section names locate HTML/XML passages without unstable browser line numbers. All nine external main full texts were obtained; supplements were not exhaustively inspected. Unsupported cells remain explicitly unverified.

## 1. Eisele-Metzger 2025 — a

**Citation:** Eisele-Metzger A, Lieberum J-L, Toews M, Siemens W, Heilmeyer F, Haverkamp C, Boehringer D, Meerpohl JJ. Exploring the potential of Claude 2 for risk of bias assessment: Using a large language model to assess randomized controlled trials with RoB 2. *Research Synthesis Methods*. 2025;16(3):491–508. doi:10.1017/rsm.2025.12.

**Full text:** [Europe PMC XML, PMC12527486](https://www.ebi.ac.uk/europepmc/webservices/rest/PMC12527486/fullTextXML).

| Positive cell | Verbatim excerpt | Location and scope |
|---|---|---|
| rule_breaks_measured — Partly | “checked the 100 overall judgements” | Methods, Data analysis: overall-rule check only; 2/100 violations; not signalling-answer/domain conformance. |
| independent_reference_or_adjudication — Partly | “We reviewed all ‘two-level discrepancies’” | Methods, Data analysis: unblinded author review against sources, not an independent panel or replacement reference. |

**Other decisions:** The model supplied domain and overall ratings; prompt assembly and protocol compression used Patchbay. Hence no software enforcement or tool-using assessment agent is demonstrated by that described procedure. Code application in a separate analysis is not established. Input parity is `No`: Strengths and limitations explicitly contrasts compressed protocols and absent supplements/additional reports with the Cochrane reviewers' broader information.

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
| input_parity_registry_protocol — Partly | “excluding Multimedia Appendices and protocols” | Discussion, Principal Findings: reviewers restricted to the model's main-text information; ancillary-source parity was not tested. |

**Other decisions:** Ratings were first generated by the LLM; later spreadsheet derivation does not enforce the assessment path. The 46 trials include six used for prompt development; performance validation uses 40.

**Lead corrections:** None to w2's substantive row extraction. The `Partly` spreadsheet cell must not be shortened to automated code enforcement. Rule-break checking was qualitative/comparative, not a reported contradiction rate.

**Unverified:** quotations_verified_against_stored_source; audit_file; agent_with_tools. Automated Excel implementation is also unverified beyond the partial cell.

## 3. Lai 2026 — c

**Citation:** Lai Y-J, Lin S-H, Liu J-W. Evaluating the Accuracy of Large Language Models in Risk-of-Bias Assessment Using Version 2 of the Cochrane Risk-of-Bias Tool for Randomized Trials: Exploratory Feasibility Study. *Journal of Medical Internet Research*. 2026;28:e84915. doi:10.2196/84915.

**Full text:** [Europe PMC XML, PMC13614218](https://www.ebi.ac.uk/europepmc/webservices/rest/PMC13614218/fullTextXML).

| Positive cell | Verbatim excerpt | Location and scope |
|---|---|---|
| independent_reference_or_adjudication — Partly | “manually corrected based on research team consensus” | Methods, Establishment of the Reference Standard; Results sensitivity analysis: corrections to Toouli assessments, not a new blinded reference. |

**Other decisions:** Decision-tree rules were placed in the prompt and the LLM emitted judgments; this establishes no software enforcement. Full trial text was uploaded; matching registry/protocol information is not established.

**Lead corrections:** w2 describes one apparent typo without its domain scope: the full text identifies errors in Toouli domains 2, 3 and 4. The primary analysis retained published ratings; correction was a sensitivity analysis. Bibliographic disambiguation: this is Yu-Ju Lai, not Huang coauthor Honghao Lai; the synthesis's “Lai H” citation needs correction.

**Unverified:** rules_applied_in_code; rule_breaks_measured; quotations_verified_against_stored_source; audit_file; agent_with_tools; input_parity_registry_protocol.

## 4. Nyrhi 2026 — d

**Citation:** Nyrhi L, Ponkilainen V, Laaksonen J, Kuikka L, Paljakka L, Karjalainen T, Mattila VM, Kuitunen I. Large language models for risk-of-bias assessment in randomised clinical trials—a comparative validation study. *EBioMedicine*. 2026;126:106238. doi:10.1016/j.ebiom.2026.106238.

**Full text:** [Europe PMC XML, PMC13054287](https://www.ebi.ac.uk/europepmc/webservices/rest/PMC13054287/fullTextXML).

| Positive cell | Verbatim excerpt | Location and scope |
|---|---|---|
| input_parity_registry_protocol — Partly | “PDF-versions of their protocols when available” | Methods, Prompt development and standardisation: protocol uploads reported, with a DeepSeek exception; complete human/model parity not established. |

**Other decisions:** This row is the 100-trial RoB 2 cohort, not the additional 100 RoB 1 trials. Methods specifies base web-chat modes without added features and explicitly says review procedures were not audited. Published ratings remain the reference. Prompt-generated ratings were not software-enforced.

**Lead corrections:** None to w3's principal findings. Its mention of protocols must retain the DeepSeek exception and must not imply full input parity.

**Unverified:** rules_applied_in_code; rule_breaks_measured; quotations_verified_against_stored_source; audit_file. The exact completeness of ancillary inputs is unverified beyond `Partly`.

## 5. Gandhi 2026 — e

**Citation:** Gandhi S, Shokravi A, Chelliahpillai Y, Balas M. Evaluating large language model performance in Risk of Bias assessments: A cross-sectional validation study. *PLOS One*. 2026;21(7):e0353155. doi:10.1371/journal.pone.0353155.

**Full text:** [Europe PMC XML, PMC13349098](https://www.ebi.ac.uk/europepmc/webservices/rest/PMC13349098/fullTextXML).

| Positive cell | Verbatim excerpt | Location and scope |
|---|---|---|
| agent_with_tools — Partly | “web-browsing capabilities enabled” | Methods, Data collection and RoB assessment: capability enabled; actual external searches not logged/quantified. |
| independent_reference_or_adjudication — Yes | “masked to the OSRA’s assessments” | Same section: three reviewers independently re-rated all 50 trials; consensus/fourth reviewer resolved their differences. |

**Other decisions:** The model produced ratings from a PDF and branching-logic prompt. Input parity is `No`: the panel retrieved registries, whereas the model's registry access was theoretical and not demonstrated; it was not given the panel's retrieved registry set.

**Lead corrections:** w4's categorical G5 statement that no tool-using workflow was reported is too strong: browsing was enabled, so the table records partial tool capability. Add a detail omitted from w4: Results, Interrater agreement reports panel percent agreement 60–90%, weighted κ 0.21–0.74, and overall agreement 70%, κ 0.56. This is not blinded adjudication limited to model/published disagreements.

**Unverified:** rules_applied_in_code; rule_breaks_measured; quotations_verified_against_stored_source; audit_file. Actual browsing use remains unverified beyond `Partly`.

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

**Unverified:** quotations_verified_against_stored_source; audit_file; input_parity_registry_protocol. The cause of ROBoto2 inconsistency is unverified.

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

**Unverified:** rule_breaks_measured; quotations_verified_against_stored_source; input_parity_registry_protocol. Independent source-integrity verification and autonomous tool use remain unverified beyond partial cells.

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

**Unverified:** rules_applied_in_code; rule_breaks_measured; input_parity_registry_protocol. Locked-source quotation occurrence and independent bundle verification remain unverified beyond partial cells.

## 9. Saadi 2026 / ROBINS-I — i

**Citation:** Saadi S, Fleti F, Rajjoub OH, Shamsi Basha A, Firwana M, Abideen Z, Rajjo T, Wang Z, Murad MH. Comparison of three large language models' ability to assess the risk of bias using ROBINS-I tool. *BMJ Digital Health & AI*. 2026;2(1):e000034. doi:10.1136/bmjdh-2026-000034.

**Full text:** [Europe PMC XML, PMC13528376](https://www.ebi.ac.uk/europepmc/webservices/rest/PMC13528376/fullTextXML). Publisher routes returned 403; the lead DOI returned 404.

| Positive cell | Verbatim excerpt | Location and scope |
|---|---|---|
| agent_with_tools — Partly | “customised agent-based implementations” | Methods, LLM assessment workflow: custom platform workflows and uploads; external tool calling unestablished. |
| independent_reference_or_adjudication — Partly | “two separate teams of human reviewers” | Methods, Study design and data source: concordant historical review ratings selected, not new adjudication. |

**Other decisions:** 171 nonrandomised studies, not trials; domain denominators vary. Models emitted categorical ratings. Paper-only input versus additional protocol context is explicit in Implications, so full ancillary-source parity is `No`.

**Lead corrections:** w8's DOI `bmjdth` is wrong; use `bmjdh`. Full text is now available. It specifies GPT-5.2 Instant, Gemini 3 Fast, Claude Opus-4-6, with February 2026 assessment. Accuracy includes only internally consistent model ratings as well as concordant human ratings; this extra selection was omitted from w8. Full-text tables provide results, superseding its unavailable-results caveat.

**Unverified:** rules_applied_in_code; rule_breaks_measured; quotations_verified_against_stored_source; audit_file. Agent tool calling remains unverified beyond `Partly`.

## 10. This study / ARBITER — j

**Citation:** This study (ARBITER), 102-trial Sonnet analysis set; unpublished repository study, no DOI assigned here.

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
| input_parity_registry_protocol — Yes | “nothing re-fetched” | no-kit-sonnet-5.5/README.md, Inputs: same registry projections and 60 acquired protocol/SAP PDFs copied into Unassisted inputs; section 7 confirms identical inputs. |

**Qualification:** No Sonnet domain overrides were recorded in 510 domains. The plan explicitly permits reasoned, recorded overrides; do not describe the architecture as forbidding every departure from an algorithm proposal. Quotation occurrence and structural/visual binding do not establish that evidence supports an answer. Adjudication covers disputed D1–D5 cells, not all cells or Overall. `n_trials=102` is the analysis set, although run READMEs describe 105 original cases.

**Lead correction affecting comparison:** w8's proposed novelty wording that software exclusively emits algorithm-derived ratings and the synthesis's absolute algorithm-only claim require the recorded-override qualification from the repository.

**Unverified cells:** None in the requested schema. Semantic support for every quotation, universal absence of overrides, and adjudication of agreed/Overall cells are not claimed.

## Verification limits and complete unverified-cell list

The per-row **Unverified** lists enumerate every `Not reported` cell. The narrower unsupported components of `Partly` are also stated there or directly beside the evidence. No entire external main text was unavailable, and no positive cell relies on an abstract or an extraction-file quotation alone. Supplements and underlying implementations were not exhaustively audited; `Not reported` is bounded to inspected full texts, not a claim about all possible author artifacts.

Corrections are recorded here without modifying w1–w8. w6 and w7 contain no additional selected Table 4 rows; they do not supply proof for positive cells. Corrections reported here concern the requested comparison and errors encountered while verifying it, not a fresh audit of every off-table study in those files.

## Footnote texts for the table

a. Only overall-rule breaks were counted; discrepancy review was unblinded and limited.
b. Excel derivation was post hoc; 46 trials include six prompt-development trials.
c. Rules were in the prompt; published-label corrections were sensitivity analyses.
d. RoB 2 cohort only; protocols were supplied when available, with a model exception.
e. A masked panel re-rated all trials; browsing was enabled but actual registry retrieval was unverified.
f. One trial, 38 runs; coded checks found tool inconsistencies and three expert transcription errors.
g. Dataset: 521 reports; manual evaluation subset: 245. Retrieved passages and edits are not source verification.
h. Post hoc LLM support judgments and JSON records do not establish locked-source quote checking.
i. ROBINS-I: 171 nonrandomised studies; only concordant human and repeat-consistent model ratings enter accuracy.
j. ARBITER permits recorded overrides; none occurred in the 510 Sonnet domains. Adjudication covers disputed cells.
