# WP-P: final polish (manuscript and supplement alignment)

Baseline: `85a4c6f`. One worker owns both `analysis/` and `docs/manuscript/` for this round, because the items below couple them.

Read first:

- `docs/round14/BRIEF.md`
- `docs/round14/WP-M-manuscript.md` (its hard rules apply)
- the "WP-M draft 2 review" and "WP-A3 review" sections of `docs/round14/REVIEW.md`
- `ANALYSIS-PLAN.md` section 7

## Tasks

1. **Hypothesis wording.** The Objective currently says "We hypothesised… that differences in elicited answers would contribute beyond rule arithmetic". The rules-only analysis was post hoc, so reword it as a post hoc question. Keep the prespecified hypothesis: adjudicators prefer ARBITER when the arms disagree.
2. **Cite every supplementary item.**
   - Each eTable and eFigure must be cited at least once in the manuscript, in the place where a reader would want it.
   - Grouped pointers are fine, for example "full agreement metrics, confusion matrices and per-meta-analysis estimates are in eTables X–Y" in Results R2.
   - Do not add new claims, and do not move numbers out of the supplement into the text.
   - Keep the main text at 4,000 words or fewer.
3. **Renumber the supplement in manuscript citation order.** Once item 2 is done, renumber every eTable and eFigure by first citation in the manuscript. That includes AVATAR (currently eTable 3), which is cited first, in Methods.
   - Update every cross-reference: figure legends, table notes, results sentences, the supplement's own internal references, results.html and supplement.html, the TRIPOD-LLM map, `round14-report.md`, and the manuscript.
   - Generate the mapping from code, and save it as `output/manuscript/qa/round14-polish-numbering.csv`.
4. **Verify.**
   - Invariance of every number against `85a4c6f`. Only eTable numbers may change.
   - Full test suite.
   - `docs/manuscript/verify-numbers.py`.
   - A new script that checks every "eTable N" and "eFigure N" in the manuscript and all outputs resolves to the item intended.
   - Visual QA of the supplement.
   - Append "Polish round" to `analysis/round14-report.md`.
5. Do not commit or push.

## Final message

Report:

- the numbering map;
- the citation sentences you added, quoted;
- word counts;
- every verification result;
- open issues.
