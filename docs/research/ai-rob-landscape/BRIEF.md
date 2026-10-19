# Landscape brief: the literature around AI risk-of-bias assessment

## Purpose

`docs/research/llm-rob2/` already covers direct studies of LLMs on RoB 2. This swarm covers the **surrounding** literature that a JAMIA reviewer will bring to the paper. Use it to sharpen the story and to set analysis directions for future rounds.

Read first:

- `docs/research/llm-rob2/SYNTHESIS.md`: what is already known and cited. Do not re-extract those papers.
- `ANALYSIS-PLAN.md` section 7, "Story (Round 14)": the current argument.

The current argument in brief: ARBITER is an LLM agent plus rule-based software that stores sources, checks quotations, applies the RoB 2 algorithms and writes an audit file. It was tested on 102 trials against an unassisted model given identical inputs.

- Both arms agreed poorly with published labels (weighted κ 0.34 and 0.28), mainly because they rated more strictly. Blinded adjudicators usually agreed with the stricter ratings: ARBITER 73/77, Unassisted 48/59.
- Only cells where an arm disagreed with the published label were adjudicated. Each adjudicator gave an independent rating first, then chose among three blinded labels.
- When the arms disagreed, the adjudicators chose ARBITER in 54/62 cells.
- Recomputing the unassisted model's ratings from its own answers changed almost nothing.
- The unassisted model broke RoB 2 rules in 12.8% of domain ratings.

## Rules

- **Search systematically.** PubMed tools are available to you; prefer them for biomedical literature. Also use Europe PMC, arXiv and the web for computing and preprint literature.
- **Read the full text** for the items you rely on most. For each item, say whether you read the full text or only the abstract.
- **Never invent citations or numbers.** Every item needs a DOI or PMID that you have confirmed resolves to that title. Quote verbatim, giving the section, when a sentence matters.
- **Write only your assigned file** in `docs/research/ai-rob-landscape/`. Save raw downloads only under `/tmp/`. Do not edit anything else, and do not commit.

## Output file structure

```markdown
# <Slice title>

## Search log
Databases, queries, dates, counts screened / included.

## Key sources (8–20)
For each: citation, DOI/PMID (verified), full text yes/no, 2–4 line summary of what matters for us, verbatim quote if useful.

## What this literature says about our story
Supports / complicates / threatens, each with citations.

## Reviewer objections we should pre-empt
Numbered; each with the citation a reviewer would use and our best available answer.

## Recommended analysis directions for future rounds
Numbered, concrete, feasible with our existing data where possible (state whether it needs new data). Mark each: MUST (a reviewer will demand it), SHOULD, or COULD.

## Recommended text changes
Introduction / Methods / Discussion / Limitations sentences or citations to add.

## Report
PASS | ISSUES | BLOCKED, with one paragraph of evidence: what you covered, what you could not reach, and how confident you are.
```
