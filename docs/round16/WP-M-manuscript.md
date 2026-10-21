# WP-M (Round 16): rewrite the manuscript to the Round 16 story

Baseline: commit `bafc84d`. Revise `docs/manuscript/manuscript.md`, `references.md` and `verify-numbers.py` only. Do not commit.

## Read first

1. `docs/round16/BRIEF.md`. This is the specification for the message, Introduction, Objective, terms, outcome labels, Methods structure, Results order, displays, abstract, title and Discussion.
2. `GLOSSARY.md`. Reader-facing labels: Expert 1 / Expert 2; "adjudication" only for the forced-choice step.
3. `analysis/output/manuscript/results-sentences.md`, `figure-legends.md`, Tables 1–4, `analysis/output/tables/*.csv`, `analysis/round16-report.md` and `analysis/output/manuscript/qa/round16-display-numbering.csv`. Every number comes from these.
4. The current `docs/manuscript/manuscript.md`. Keep what the BRIEF does not change:
   - the Background lineage and citations;
   - System design and Figures 1–2 text;
   - benchmark and arms, including the binding-audit sentence, unchanged per BRIEF §5;
   - input parity and the De Waal disclosure;
   - the cost and deployment paragraph;
   - the Table 4 discussion;
   - reporting standards and back-matter placeholders.
5. `docs/round15/WP-M-manuscript.md`. Its hard rules still apply.

## What to write

- **Title, abstract, Introduction, Objective, Methods, Results, Discussion and Conclusion.** Follow BRIEF §1–§11 exactly.
- **Results paragraph 1.** Open with the flow sentence: 105 benchmark trials, 3 excluded, 102 trials from 16 meta-analyses, 510 cells (Figure 3). Then the pattern that both experts rated Low less often than any source (Table 1), then expert-to-expert reliability.
- **Results prose.** `results-sentences.md` is the source. Improve its prose where it reads as a list; for example, lead each paragraph with the pattern rather than "The prespecified … showed". Do not change any number or claim.
- **Paragraph 4 (strictness).** The "without lower specificity" finding leads the paragraph. In the Discussion it is the core answer to the "stricter means wrong" reading: against the experts, ARBITER gained sensitivity without losing specificity, whereas against published labels the same ratings looked like lost specificity.
- **Methods.** Use the five subsections, with an explicit outcome hierarchy: primary, then prespecified secondary, then exploratory. Add one sentence saying the prespecified comparisons were applied to all cells because the experts assessed every cell. Methods cite eMethods only. Never mention an earlier adjudication.
- **Comparator.** Address its limits where it is introduced, in benchmark and arms: a minimal prompt without RoB 2 guidance, and a system-level claim.
- **Limitations, paragraph 2.** Open with reference reliability: two experts; κ 0.59; D3 lowest; Overall agreement between experts 42/81; access to extra sources.
- **Conclusion, second sentence.** Use BRIEF §11 item 7.
- **Displays.** Cite them in ascending first-citation order, using the Round 16 numbering. Supplement callouts follow the numbering map.
- **Limits.** Main text 4,000 words or fewer; abstract 250 or fewer.

## Hard rules

- Never invent a number, a citation or an author detail.
- `verify-numbers.py` must trace every number token and assert ascending first-citation order for Figures, Tables, eTables and eFigures. Update its expected display sets to the Round 16 numbering.
- Banned words: "first", "over-flagging", "supported by evidence", "accuracy" (against the experts), "second reviewer", "unchangeable", "tamper-proof", "ground truth", "correct" (for a rating), "hid", "reversed", "masked" (for the benchmark finding), "expert-level", "matched experts".
- Use "to our knowledge" once, for the gap. Use "found in the stored source"; "content-hashed"; "assistant".
- Never mention Haiku or any earlier adjudication. Never say "post hoc" or "defined after data collection" for a prespecified item.
- Paraphrase the message in each place it appears; never paste it.

## Final message

Report:

- the new title and full abstract;
- section word counts;
- the verify-numbers result, including citation order;
- every placeholder;
- any place where the BRIEF and the data seemed to conflict.
