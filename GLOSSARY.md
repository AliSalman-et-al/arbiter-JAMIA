# Glossary

Terms for the ARBITER JAMIA benchmark analysis.

## Arms and sources

**ARBITER**: Agentic Risk of Bias Inference Tool for Evidence Reviews. An AI model reads and answers; rule-based software (the ARBITER server, no AI) stores the sources, checks every quotation, applies the RoB 2 rules and writes the audit file.

**ARBITER arm**: A model run that uses the ARBITER MCP server and the arbiter-assess skill. The data files call it "kit". The manuscript reports one ARBITER arm, ARBITER-Sonnet. The Haiku arms exist in the data but are not reported anywhere.

**Baseline arm**: A model run with the same trial files and the same prompt, but without ARBITER. The data files call it "no-kit".

**Meta label**: The published RoB 2 judgement for a trial, taken from the source meta-analysis. The data files call it "human". Do not call it "the human label" or "ground truth".

**Adjudicator**: One of two blinded human experts who assessed every D1-D5 cell of the analysis set, without AI, using a structured form. Outputs call them Adjudicator 1 and Adjudicator 2, matching data files `-1` and `-2`. An earlier disagreement-only adjudication was discarded and is not part of the analysis.

**Independent rating**: An adjudicator's own signalling answers and domain rating for a cell, frozen before they saw any label. The data files call it `Independent`.
_Avoid_: own judgement, independent judgement

**Forced choice**: The label an adjudicator picked as most defensible among three blinded labels (meta, baseline arm, ARBITER arm, in random order, without rationales). It is scored by label: every source whose label equals the chosen label is preferred. The data files call it `Chosen label`; `Chosen reviewer` is not used.
_Avoid_: preferred judgement

**Revised rating**: An adjudicator's own final rating after seeing the three labels. It may differ from all three. Descriptive only, because seeing the labels may anchor it. The data files call it `Revised`.

**Derived Overall**: The Overall judgement the official RoB 2 rule gives from an adjudicator's independent domain ratings.

## Units

**Cell**: One trial × one domain (D1 to D5, or Overall).

**Disputed cell**: A D1-D5 cell where ARBITER-Sonnet or baseline-Sonnet differs from the meta label. It names a subset only; every cell was adjudicated.

**Discordant cell**: A D1-D5 cell where the ARBITER and baseline arm labels differ. The forced-choice primary endpoint is computed on discordant cells.

**Concordant cell**: A D1-D5 cell where the meta, ARBITER and baseline labels are all equal. The forced choice carries no information there.

**Agreed reference**: The cells where both adjudicators' independent ratings are equal, with that rating as the reference.

**Analysis set**: The 102 trials that both reported arms assessed. Three trials are excluded because ARBITER does not support their design: atwine-2020, haney-2004 and herrmann-2016.

## Judgements

**Not Low**: A judgement of Some concerns or High, counted as one class.

**Proposed judgement**: The domain judgement ARBITER's server computes from the signalling answers using the official RoB 2 algorithm.

**Override**: A recorded departure by the assessing model from the proposed judgement, stored in the run bundle with a rationale and evidence. The bundle calls it a "reasoned adjudication". Do not confuse it with the human adjudication.

**Algorithm violation**: A domain or Overall judgement that differs from what the official algorithm gives from the source's own answers or domain labels, with no override recorded. Only baseline arms and meta labels can have one.

**Departure**: A domain judgement that breaks the RoB 2 algorithm: an algorithm violation or an invalid answer path. Use "departure" only in this sense.

**Disagreement with Published**: A cell where a source's label differs from the meta label. Do not call it a "departure".

**Direction of disagreement**: Whether a source's label is stricter (more severe) or more lenient (less severe) than the published label for the same cell, on Low < Some concerns < High. The literature calls a model's stricter labels "over-flagging". Use "stricter" and "more lenient" in outputs, never "over-flagging" or "under-flagging", because those words assume the published label is right.

**Rules-only recomputation**: The unassisted arm's labels with every algorithm violation replaced by the label the official algorithm gives from that arm's own signalling answers. It asks how much of ARBITER's advantage the rule engine alone would supply. Do not call it "Unassisted with ARBITER".

**Quotation found**: A quotation whose text exists in ARBITER's stored copy of the cited source. It does not mean the quotation supports the answer. Use "found in the stored source", never "supported by evidence".

**Input parity**: Both arms received the same files for each trial: articles, supplements, registry records, protocols and SAPs.

**Decisive question**: A signalling question where a losing source's answer contradicts an adjudicator's independent answer, and where substituting the adjudicators' answer alone changes the algorithm's judgement.

**All-Low rule**: A reference rule that predicts Low for every cell. Do not call it a "baseline", which means the baseline arm. It shows how much of an accuracy figure comes from Low being the most common label.

## Reader-facing labels

These are the labels used in manuscript text, figures and tables. The internal terms above stay in the code and the plan.

| Internal term | Main text | Supplement |
|---|---|---|
| ARBITER-Sonnet | ARBITER | ARBITER |
| Baseline-Sonnet | Unassisted | Unassisted |
| Meta label | Published label | Published label |
| All-Low rule | All-Low rule | All-Low rule |
| Adjudicator (file -1 / -2) | Adjudicator 1 / 2 | Adjudicator 1 / 2 |
| Meta label (first use) | published review label | published review label |
| Not Low | Some concerns or High | Some concerns or High |
| Discordant cell | cell where the two arms disagreed | cell where the two arms disagreed |
| Agreed forced choice | the adjudicators' agreed choice | the adjudicators' agreed choice |
| Independent rating | the adjudicator's independent rating | the adjudicator's independent rating |
| Agreed reference | cells where both adjudicators' independent ratings agreed | cells where both adjudicators' independent ratings agreed |
| Decisive question | question that alone changed the rating | question that alone changed the rating |
| LLM agent | AI model (Figure 1: AI model (LLM agent)) | AI model |
| ARBITER server | ARBITER (rule-based software, no AI) (Figure 1: ARBITER server) | ARBITER server |
| Algorithm violation | Rating contradicts its own answers | Rating contradicts its own answers |
| Invalid answer path | Required question skipped | Required question skipped |
| Departure | Any rule break | Any rule break |
| Overall consistent or permitted escalation | Overall rating follows the RoB 2 rules (incl. permitted escalation) | Overall follows the RoB 2 rules; escalation reported separately |
| Split cells | Adjudicators split | Adjudicators split |
| Direction of disagreement | stricter / more lenient than the published label | stricter / more lenient than the published label |
| Rules-only recomputation | Unassisted ratings recomputed from its own answers | Unassisted ratings recomputed from its own answers |
| Quotation found | quotation found in the stored source | quotation found in the stored source |
