# WP-M round 2 (Round 16): abstract and two Methods sentences

WP-M is accepted apart from the items below. Edit only `docs/manuscript/manuscript.md` and, if needed, `verify-numbers.py`. Do not commit.

## 1. Abstract (now 189/250; use the room)

- **Objective.** Restore the two questions from BRIEF §2:
  - whether ARBITER's ratings are closer to blinded experts than the same model unassisted;
  - whether agreement with published labels gives the same comparison.
- **Materials and Methods.** A reader must learn what the arms and the benchmark are. Add:
  - 102 randomised trials from 16 meta-analyses;
  - both arms used the same model and identical trial documents;
  - Unassisted received a minimal prompt without RoB 2 guidance;
  - ARBITER enforced the official rules and checked quotations against stored sources.

  Keep the expert design and the prespecified primary endpoint.
- **Results.**
  - **Add** the sensitivity and specificity contrast against the experts. Use the Expert 1 and Expert 2 sensitivity gains with CIs, and say that specificity was not lower.
  - **Add** Unassisted's rule breaks (65/509).
  - **Replace** "ARBITER enforced domain rules" with a concrete statement: zero rule breaks by design, plus the quotation count.
  - Keep the BRIEF §10 order.
- **Discussion.** Add one clause on the answers: the rules-only recomputation did not close the gap, so the workflow changed the answers, not just the arithmetic. Keep the two limitations.
- **Conclusion.** Replace "improved agreement" with "agreed more often with blinded experts than the unassisted model". This is a paired comparison, so avoid causal verbs. Keep the second sentence.
- **Limit.** 250 words or fewer.

## 2. Methods, Outcomes paragraph 2

Replace "The version-controlled plan of 18 October 2026 preceded the expert ratings. Its prespecified comparisons were applied to all cells because the experts assessed every cell, extending the planned disputed-cell population." with words to this effect:

> These outcomes were specified in the version-controlled analysis plan of 18 October 2026, before the expert ratings reported here were analysed; because the experts assessed every cell, the planned comparisons were applied to all 510 cells.

The record supports "before … analysed". It does not show when the experts made their ratings.

## 3. Results paragraph 3

Delete "placing its agreement within the range of agreement between the two experts". The bracketing sentence already says it.

## Verify

Run `verify-numbers.py`: zero untraced numbers, and citation order ascending. Recheck the word counts.

## Final message

Report the full new abstract, the two changed Methods and Results sentences, the word counts and the verify result.
