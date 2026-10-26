# Glossary

Terms for the ARBITER JAMIA benchmark analysis.

## Arms and sources

**ARBITER**: Agentic Risk of Bias Inference Tool for Evidence Reviews, an installable tool for use in evidence-review workflows. An AI model reads and answers; rule-based software (the ARBITER server, no AI) stores the sources, checks every quotation, applies the RoB 2 rules and writes the audit file.

**ARBITER arm**: A model run that uses the ARBITER MCP server and the arbiter-assess skill. The data files call it "kit". The manuscript reports one ARBITER arm, ARBITER-Sonnet. The Haiku arms exist in the data but are not reported anywhere.

**Baseline arm**: A model run with the same trial files but without ARBITER, given a minimal prompt (the task sentence and one output-format sentence, no RoB 2 guidance). The data files call it "no-kit".

**Meta label**: The published RoB 2 judgement for a trial, taken from the source meta-analysis. The data files call it "human". Do not call it "the human label" or "ground truth".

**Human Review 1 / Human Review 2**: The two independent human assessments of every D1-D5 cell, recorded without AI before offered labels. These labels match assessment files `-1` and `-2`; subsequent blinded choices and revised ratings are separate stages.
_Avoid_: Expert 1, Expert 2, adjudicator for independent ratings

**Adjudication**: The forced-choice step only: a human reviewer choosing among three blinded labels. The independent ratings are human assessment, not adjudication.

**Independent rating**: A human reviewer's own signalling answers and domain rating for a cell, frozen before they saw any label. The data files call it `Independent`.
_Avoid_: own judgement, independent judgement

**Forced choice**: The label a human reviewer picked as most defensible among three blinded labels (meta, baseline arm, ARBITER arm, in random order, without rationales). It is scored by label: every source whose label equals the chosen label is preferred. The data files call it `Chosen label`; `Chosen reviewer` is not used.
_Avoid_: preferred judgement

**Revised rating**: A human reviewer's own final rating after seeing the three labels. It may differ from all three. Descriptive only, because seeing the labels may anchor it. The data files call it `Revised`.

**Derived Overall**: The worst of a human reviewer's five independent domain ratings. Optional escalation for multiple Some concerns domains is not imposed; this is a derived summary rather than a directly rated human Overall judgement.

## Units

**Cell**: One trial × one domain (D1 to D5, or Overall).

**Disputed cell**: A D1-D5 cell where ARBITER-Sonnet or baseline-Sonnet differs from the meta label. It names a subset only; both human reviewers rated every cell.

**Discordant cell**: A D1-D5 cell where the ARBITER and baseline arm labels differ. Conditional blinded-label choice estimates use discordant cells; the agreed-choice estimate further requires equal human reviewer choices.

**Concordant cell**: A D1-D5 cell where the meta, ARBITER and baseline labels are all equal. The forced choice carries no information there.

**Analysis set**: The 102 trials that both reported arms assessed. Three trials remain excluded as unsupported designs: atwine-2020, haney-2004 and herrmann-2016. The author confirms Atwine is unsupported despite an incorrect stored model classification; no specific alternative design subtype is established.

## Judgements

**Not Low**: A judgement of Some concerns or High, counted as one class.

**Proposed judgement**: The domain judgement ARBITER's server computes from the signalling answers using the official RoB 2 algorithm.

**Override**: A recorded departure by the assessing model from the proposed judgement, stored in the run bundle with a rationale and evidence. The bundle calls it a "reasoned adjudication". Do not confuse it with the human reviewers' adjudication.

**Algorithm violation**: A domain or Overall judgement that differs from what the official algorithm gives from the source's own answers or domain labels, with no override recorded. Only baseline arms and meta labels can have one.

**Departure**: A domain judgement that breaks the RoB 2 algorithm: an algorithm violation or an invalid answer path. Use "departure" only in this sense.

**Disagreement with Published**: A cell where a source's label differs from the meta label. Do not call it a "departure".

**Direction of disagreement**: Whether a source's label is stricter (more severe) or more lenient (less severe) than the published label for the same cell, on Low < Some concerns < High. The literature calls a model's stricter labels "over-flagging". Use "stricter" and "more lenient" in outputs, never "over-flagging" or "under-flagging", because those words assume the published label is right.

**Rules-only recomputation**: The unassisted arm's labels with every algorithm violation replaced by the label the official algorithm gives from that arm's own signalling answers. It tests whether correcting inconsistent final labels closes the observed agreement gap; it does not isolate the causal contribution of ARBITER's rule engine. Invalid answer paths and missing ratings remain unchanged. Do not call it "Unassisted with ARBITER".

**Quotation found**: A quotation whose text exists in ARBITER's stored copy of the cited source. It does not mean the quotation supports the answer. Use "found in the stored source", never "supported by evidence".

**Input parity**: Both arms received the same available trial files. The author confirms the human reviewers received the same trial materials, supplements and ClinicalTrials.gov records and the same task targets (outcomes, contrast and numerical anchor), with access to Cochrane RoB 2 guidance. This does not imply that every document type existed for every trial or establish undocumented training or multi-outcome conventions.

**All-Low rule**: A reference rule that predicts Low for every cell. Do not call it a "baseline", which means the baseline arm. It shows how much of exact agreement comes from Low being the most common label.

## Reader-facing labels

These are the labels used in manuscript text, figures and tables. The internal terms above stay in the code and the plan.

| Internal term | Main text | Supplement |
|---|---|---|
| ARBITER-Sonnet | ARBITER | ARBITER |
| Baseline-Sonnet | Unassisted | Unassisted |
| Meta label | Published label | Published label |
| All-Low rule | All-Low rule | All-Low rule |
| Human assessment (file -1 / -2) | Human Review 1 / 2 | Human Review 1 / 2 |
| Meta label (first use) | published review label | published review label |
| Not Low | Some concerns or High | Some concerns or High |
| Discordant cell | cell where the two arms disagreed | cell where the two arms disagreed |
| Agreed forced choice | the human reviewers' agreed choice | the human reviewers' agreed choice |
| Independent rating | the human reviewer's independent rating | the human reviewer's independent rating |
| LLM agent | AI model (Figure 1: AI model (LLM agent)) | AI model |
| ARBITER server | ARBITER (rule-based software, no AI) (Figure 1: ARBITER server) | ARBITER server |
| Algorithm violation | Rating contradicts its own answers | Rating contradicts its own answers |
| Invalid answer path | Required question skipped | Required question skipped |
| Departure | Any rule break | Any rule break |
| Overall consistent or permitted escalation | Overall rating follows the RoB 2 rules (incl. permitted escalation) | Overall follows the RoB 2 rules; escalation reported separately |
| Split cells | Human reviewers split | Human reviewers split |
| Direction of disagreement | stricter / more lenient than the published label | stricter / more lenient than the published label |
| Rules-only recomputation | Unassisted ratings recomputed from its own answers | Unassisted ratings recomputed from its own answers |
| Quotation found | quotation found in the stored source | quotation found in the stored source |

## Outcome status and legacy identifiers

**Evaluation outcomes**: Published-label agreement, agreement with independent human reviews, conditional blinded-label choices and supporting diagnostics, rule/source and computation checks. The reporting order was adopted after analysis on 23 October 2026 and the supplementary scope reduced on 26 October; neither establishes a formal primary/secondary or confirmatory hierarchy or prospective prespecification.

**Conditional blinded-label choice**: The label-match share among arm-discordant cells, restricted to equal human reviewer choices for the agreed-choice estimate. Review-specific and split-loss sensitivities retain their original eligibility and scoring. It is preference among offered labels, not accuracy.

**Legacy analysis keys**: `primary-endpoint.csv` and module `secondary.R` are retained identifiers. Their names confer no scientific status. The RoB 2 question identifier `selection:prespecified-analysis` concerns the assessed trial's analysis plan and is unrelated to this evaluation's planning chronology.
