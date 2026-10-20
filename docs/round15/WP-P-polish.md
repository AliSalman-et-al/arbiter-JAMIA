# WP-P (Round 15): display renumbering and manuscript polish

Baseline: commit `0cbdfc3`, plus the uncommitted WP-M edits in `docs/manuscript/`. A single worker owns `analysis/` and `docs/manuscript/` for this round, because the items below couple the two. Do not commit.

Read first:

- `docs/round15/BRIEF.md`
- `docs/round15/WP-M-manuscript.md`; its hard rules apply
- the current `docs/manuscript/manuscript.md`

## 1. Renumber main displays in first-citation order (JAMIA requirement)

The current Results cite Figure 5 before Figures 3 and 4, and Table 2 before Tables 3 and 1. Keep the story order and renumber the displays to match it.

**Figures.** Figures 1–3 are unchanged.

| New | Old | Content |
|---|---|---|
| Figure 4 | Figure 5 | primary forest |
| Figure 5 | Figure 4 | A: independent agreement; B: direction |
| Figure 6 | Figure 6 | unchanged |

The Fig 1 and Fig 2 files stay byte-identical.

**Tables.**

| New | Old | Content |
|---|---|---|
| Table 1 | Table 2 | agreement with the independent expert ratings |
| Table 2 | Table 3 | rule breaks and audit |
| Table 3 | Table 1 | agreement with published labels |
| Table 4 | Table 4 | prior work; unchanged |

**Propagate the new numbers everywhere:**

- file names
- legends and table notes
- results sentences
- Supplement cross-references
- results.html and supplement.html, which follow manuscript order
- TRIPOD-LLM map
- round15-report.md
- the manuscript

Generate the mapping from code and save it as `analysis/output/manuscript/qa/round15-display-numbering.csv`. After renumbering, check that the first-citation order of every Figure, Table, eTable and eFigure in the manuscript is ascending. Extend `verify-numbers.py`, or the existing reference-check script, to assert this.

## 2. Manuscript edits

**Abstract, Materials and Methods.** Replace "The prespecified hypothesis favoured ARBITER in arm disagreements; independent-agreement analyses were defined after data collection." with wording to this effect:

> The prespecified primary endpoint was the share of arm-discordant cells in which both experts chose ARBITER's label; agreement with the experts' independent ratings was defined after data collection.

**Abstract, Results.**

- Replace "all 1407 ARBITER text records linked quotations found in stored sources" with "every ARBITER quotation (1407/1407) was found in its content-hashed source".
- Add the paired ARBITER − Unassisted difference with its CI after the per-expert percentages, if the word limit allows.

**Abstract, Discussion.** Rewrite it in plain language, to this effect:

> Agreement with published labels, the usual benchmark, hid ARBITER's closer agreement with blinded experts, whose independent ratings usually matched its stricter ratings. Applying the rules to the unassisted model's own answers did not close the gap. Two experts, and their access to extra sources, limit interpretation.

**Background, last paragraph.** The Challenge sentence is 55 words and hard to parse. Split it into two sentences, keeping one "to our knowledge". The first states what an enforced workflow might change. The second states that this has not been tested against a blinded expert reference covering every domain, as distinct from published labels.

**Results, paragraph 1.** Start with the flow sentence (102 trials, 16 meta-analyses, 510 cells, Figure 3), then the primary endpoint (new Figure 4).

**Leave everything else alone.** Recheck the word counts (≤4,000 main text; ≤250 abstract), and re-run `verify-numbers.py`.

## 3. Verify

Run:

- the full test suite;
- the number trace;
- the invariance check (no estimate changes; unchanged-analysis CSVs against `0cbdfc3`);
- the Fig 1 and Fig 2 byte check;
- visual QA of every renamed or changed page and figure;
- the leak scan;
- `verify-numbers.py`;
- the new citation-order assertion.

## Final message

Report:

- the numbering map;
- the new abstract in full;
- the word counts;
- every verification result.
