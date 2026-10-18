# Glossary

Terms for the ARBITER JAMIA benchmark analysis.

## Arms and sources

**ARBITER arm**: A model run that uses the ARBITER MCP server and the arbiter-assess skill. The data files call it "kit". There is one ARBITER arm per model: ARBITER-Sonnet and ARBITER-Haiku.

**Baseline arm**: A model run with the same trial files and the same prompt, but without ARBITER. The data files call it "no-kit".

**Meta label**: The published RoB 2 judgement for a trial, taken from the source meta-analysis. The data files call it "human". Do not call it "the human label" or "ground truth".

**Adjudicator**: One of two blinded human reviewers who re-assessed the disputed cells. Outputs call them Adjudicator 1 and Adjudicator 2. The data files call them A and Z: A is Adjudicator 1 and Z is Adjudicator 2.

**Independent judgement**: An adjudicator's own domain judgement, made before they saw any other source. The data files call it `own`.

**Preferred judgement**: The label an adjudicator picked as most defensible among three blinded reviewers. Each blinded reviewer was a meta label, a baseline-arm label or an ARBITER-arm label, in random order. The data files call it `chosen_label`.

## Units

**Cell**: One trial × one domain (D1 to D5, or Overall).

**Disputed cell**: A D1-D5 cell where ARBITER-Sonnet or baseline-Sonnet differs from the meta label. Only disputed cells were adjudicated.

**Analysis set**: The 102 trials that all four arms assessed. Three trials are excluded because ARBITER does not support their design: atwine-2020, haney-2004 and herrmann-2016.

**Composite reference**: A reference label for every D1-D5 cell. On disputed cells where both adjudicators gave the same preferred judgement, it is that judgement. On every other cell, it is the meta label.

## Judgements

**Not Low**: A judgement of Some concerns or High, counted as one class.

**Proposed judgement**: The domain judgement ARBITER's server computes from the signalling answers using the official RoB 2 algorithm.

**Override**: A recorded departure by the assessing model from the proposed judgement, stored in the run bundle with a rationale and evidence. The bundle calls it a "reasoned adjudication". Do not confuse it with the human adjudication.

**Algorithm violation**: A domain or Overall judgement that differs from what the official algorithm gives from the source's own answers or domain labels, with no override recorded. Only baseline arms and meta labels can have one.

**Departure**: A domain judgement that breaks the RoB 2 algorithm: an algorithm violation or an invalid answer path. Use "departure" only in this sense.

**Disagreement with Published**: A cell where a source's label differs from the meta label. Do not call it a "departure".

**Vindicated disagreement**: A disagreement with Published where the consensus preferred judgement equals the disagreeing source's label.

**Decisive question**: A signalling question where a losing source's answer contradicts the adjudicators' independent answer, and where substituting the adjudicators' answer alone changes the algorithm's judgement.

**All-Low rule**: A reference rule that predicts Low for every cell. Do not call it a "baseline", which means the baseline arm. It shows how much of an accuracy figure comes from Low being the most common label.

## Reader-facing labels

These are the labels used in manuscript text, figures and tables. The internal terms above stay in the code and the plan.

| Internal term | Main text | Supplement |
|---|---|---|
| ARBITER-Sonnet | ARBITER | ARBITER (Sonnet 5.5) |
| Baseline-Sonnet | Unassisted | Unassisted (Sonnet 5.5) |
| ARBITER-Haiku | — | ARBITER (Haiku 5.5) |
| Baseline-Haiku | — | Unassisted (Haiku 5.5) |
| Meta label | Published label | Published label |
| All-Low rule | All-Low rule | All-Low rule |
| Adjudicator A / Z | Adjudicator 1 / 2 | Adjudicator 1 / 2 |
| Meta label (first use) | published review label | published review label |
| Not Low | Some concerns or High | Some concerns or High |
| Discordant cell | cell where the two arms disagreed | cell where the two arms disagreed |
| Consensus preferred judgement | the adjudicators' agreed choice | the adjudicators' agreed choice |
| Decisive question | question that alone changed the rating | question that alone changed the rating |
| LLM agent | AI model (Figure 1: AI model (LLM agent)) | AI model |
| ARBITER server | ARBITER (rule-based software, no AI) (Figure 1: ARBITER server) | ARBITER server |
