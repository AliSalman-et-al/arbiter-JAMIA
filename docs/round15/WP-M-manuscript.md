# WP-M (Round 15): rewrite the manuscript on the full-coverage expert reference

Revise `docs/manuscript/manuscript.md`, `references.md` and `verify-numbers.py` only. Do not commit.

## Read first

1. `docs/round15/BRIEF.md`. This is the specification: the story, the message, the abstract order, the displays and the limitations.
2. `GLOSSARY.md`, the reader-facing label table. Retired terms must not appear: composite reference, vindicated disagreement, decisive question.
3. `analysis/output/manuscript/results-sentences.md`, `figure-legends.md`, Tables 1–4, and `analysis/output/tables/*.csv`. Every number comes from these.
4. `analysis/round15-report.md` and `ANALYSIS-PLAN.md` §4–§7, which say what is prespecified and what is post hoc.
5. The current manuscript, draft 2 after the Round 14 polish. Keep everything that does not depend on the adjudication design: the Background lineage and citations, Fig 1–2 Methods, the benchmark, the arms, input parity, the De Waal disclosure, the rule audit, cost, Table 4 discussion, reporting standards and back-matter placeholders.
6. `docs/round14/WP-M-manuscript.md` and `WP-M2-revision.md`. Their writing standard and hard rules still apply.

## What changes

**Background, last paragraph.** End on the new Challenge question, with one "to our knowledge" sentence. The question: whether an LLM workflow in which the rules and evidence checks are the only route to a rating gives answers closer to blinded expert judgement than an unassisted model, or than the published labels the field benchmarks against, has not been tested against a blinded expert reference that covers every domain.

**Objective.** Give the question and the prespecified hypothesis only: adjudicators prefer ARBITER when the arms disagree. Say that the independent-rating comparison across all cells was defined after data collection.

**Methods, reference standard.** Describe the process exactly as the BRIEF does:

- two blinded human experts and no AI for any judgement, using a structured form;
- all 102 trials × D1–D5;
- an independent rating made first and frozen (signalling answers and domain rating);
- then three blinded labels in an order randomised for each cell, with no rationales, and a forced choice;
- then a revised rating.

Experts could consult sources beyond those supplied to the arms. Derived Overall comes from domain ratings by the official rule. Cite Gartlehner 2025 as the design precedent. Adjudicator qualifications stay an [author placeholder]. Do not mention any earlier adjudication.

**Endpoints.**

- **Primary:** the share of discordant cells with an agreed forced choice where the adjudicators preferred ARBITER's rating.
- **Key secondary:** agreement with each expert's independent rating across all 510 cells, and derived Overall on the 81 trials with a published Overall label; the published labels are scored as a third source.
- **Others:**
  - direction of disagreement against the experts;
  - signalling-answer agreement (collapsed scale);
  - expert-to-expert agreement;
  - rules-only recomputation (post hoc);
  - published-label agreement (Table 1);
  - the rule audit, cost and time.
- Label post hoc items as post hoc.

**Results.** Follow the BRIEF abstract order, one paragraph per step, built from `results-sentences.md`. Cite figures as supporting actors and never narrate them. Cite every eTable and eFigure where a reader needs it.

**Discussion order.**

1. The principal finding, stated as the paraphrased message.
2. Strictness reinterpreted: against blinded experts, the stricter ratings usually matched. Contrast prior studies that read strictness as error. Gandhi's masked panel points the same way.
3. Published labels as a benchmark: they agreed with the experts less often than either model. Say this is why agreement with published labels misleads as a benchmark. Hedge: two experts; the experts may have had more sources.
4. Answers, not arithmetic: the rules-only recomputation lowered agreement, and the collapsed signalling answers matched the experts more often. Set this against Huang and Choi.
5. Comparison with prior systems (Table 4).
6. Reliability: expert-to-expert agreement is modest, lowest in D3, which bounds every agreement figure.
7. Cost and deployment, as before.
8. Limitations, in two paragraphs as before, with the BRIEF's drop, add and keep lists.
9. A two-sentence conclusion.

**Abstract.** 250 words or fewer, in the BRIEF results order. The Conclusion is 1–2 sentences paraphrasing the message.

**Title.** Unchanged.

## Hard rules (unchanged)

- Never invent a number, a citation or an author detail.
- `verify-numbers.py` must trace every number token. Run it and report anything it cannot trace.
- The main text is 4,000 words or fewer.
- Banned words: "first", "over-flagging", "supported by evidence", "accuracy" (for any endpoint against the experts), "second reviewer", "unchangeable", "tamper-proof", "ground truth", "correct" (for a rating). Use "to our knowledge" where novelty is implied.
- Paraphrase the message in each place it appears; never paste it.
- Never mention Haiku or the discarded adjudication.

## Final message

Report:

- the new abstract, in full;
- section word counts;
- the verify-numbers result;
- the first-citation order of supplementary items, which must match the supplement numbering; list any mismatch;
- every placeholder;
- any place where the BRIEF and the data seemed to conflict.
