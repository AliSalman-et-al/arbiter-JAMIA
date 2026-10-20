# Round 15: full-coverage expert adjudication (brief)

Agreed with the authors on 2026-10-21 (grilling questions Q1–Q15). This brief supersedes the Round 14 adjudication design and every analysis built on it.

## What changed

The earlier adjudication, in which two adjudicators rated only the disputed cells, has been **discarded**. The old files `human-adjudication/adjudication-cells-with-explanations-A.xlsx` and `-Z.xlsx` were deleted in commit c2980a7. The manuscript, supplement and outputs do not mention them (author decision Q3).

The new reference standard is in `human-adjudication/adjudication-with-explanations-1.xlsx` (Adjudicator 1) and `-2.xlsx` (Adjudicator 2).

- Two blinded human experts assessed **all 102 trials × D1–D5 (510 cells)**. Each used a structured form, and **no AI was used for any judgement** (author confirmation Q1). The templated text (`algorithm=…; route=…`) comes from that form.
- For each cell, each expert:
  1. answered every signalling question and gave a domain rating from the trial documents, then froze both. This is the **independent rating**;
  2. was shown three blinded labels (published, Unassisted, ARBITER) in an order randomised per cell, without rationales, and chose the most defensible one. This is the **forced choice**;
  3. gave their own final view, the **revised rating**, which may differ from all three labels;
  4. recorded whether each signalling answer was retained or changed.
- The experts could consult sources beyond the arms' inputs, such as registry records. Keep their ratings as they are. Do not add a sensitivity analysis by source, but state the fact in one limitation sentence (Q2, Q14).

Terms are defined in `GLOSSARY.md`: Adjudicator, Independent rating, Forced choice, Revised rating, Derived Overall, Discordant cell, Concordant cell, Agreed reference.

## Workbook structure (both files)

- `Adjudications` (510 rows), with columns: Trial, Domain, Human (published), Kit (ARBITER), No-kit (Unassisted), Independent, Chosen reviewer, Chosen label, Revised, Reviewer comparison and reasoning, Independent reasoning.
- `Signalling evidence` (4,488 rows), with columns: Trial, Phase (Independent | Reviewer comparison), Domain, Question, Answer, Retained or changed (free text, which needs normalising), Evidence and locators, RoB 2 guidance.
  - Some questions hold several answers, one per outcome or component. Examples: "Changed for P: PY→NA; retained for W/BP"; "Retained: clinical Y; laboratory PN".
- `Trial sources` (204 rows): the free-text source note for each trial and phase.
- `Overall (derived)` (file 2 only): Overall for published, Kit, No-kit, Independent, Chosen label and Revised.
- `Chosen reviewer` is ignored. Preference is scored by label (Q6).

## Decisions (Q4–Q14)

### Primary endpoint (Q4)

The prespecified estimand is kept like-for-like, on the new data.

- **Population:** discordant cells (ARBITER ≠ Unassisted label; 80 cells) where both experts' forced choices are the same label.
- **Estimate:** the share where that label equals ARBITER's. Provisional count: 53 of 60, with Unassisted 7.
- **Sensitivities:**
  - per adjudicator, on all 80 discordant cells;
  - split cells counted as ARBITER losses.
- **Post hoc strata:** ARBITER stricter than Unassisted, and ARBITER more lenient than Unassisted.
- **Wording:** "the share of discordant cells where the adjudicators preferred ARBITER's rating". Never "accuracy" or "correct".

### Headline secondary: independent-rating agreement (Q4, Q5, Q13)

- Covers all 510 cells, for each expert separately and as the mean of the two.
- Three sources are compared: ARBITER, Unassisted and published labels (Q7).
- Metrics:
  - exact agreement is the headline metric;
  - linearly weighted κ sits beside it.
- Reported by domain and for derived Overall.
- The paired difference ARBITER − Unassisted gets a CI, and so do ARBITER − published and Unassisted − published.
- Expert-to-expert agreement is reported as the reference line ("ceiling").
- Sensitivity: the agreed reference (cells where both experts' independent ratings are equal; provisionally 388).

### Other analyses

- **Revised ratings (Q5):** descriptive only, in the supplement.
- **Tie rule (Q6):**
  - Score preference by label: every source whose label equals the chosen label counts as preferred.
  - Concordant cells (all three labels equal; 356) are excluded from the preference analyses.
- **Retired:**
  - the composite reference;
  - "vindicated disagreement";
  - the decisive-question / error-localisation figure;
  - the question 5.1 descriptive. It is folded into the signalling-question analysis.
- **New analyses (Q8):**
  - (a) Derived Overall agreement. Compute it from each expert's independent domain ratings with the official RoB 2 Overall rule, for both experts. Validate against file 2's `Overall (derived)` sheet and report any mismatch.
  - (b) Signalling-question agreement. Compare each arm's answers with each expert's independent answers, question by question. Restrict it to questions both the arm and the expert answered for the same cell. Also report a five-level exact match and a collapsed match (Y/PY vs N/PN vs NI).
  - (c) Expert-to-expert agreement and κ, overall and by domain.
- **Re-derived on the new data (Q9):**
  - **Direction of disagreement.** Take the cells where an arm is stricter, or more lenient, than the published label. For each, report how often the expert's independent rating equals the arm's label, how often it equals the published label, and how often it equals neither, with CIs.
  - **Rules-only recomputation.** As in Round 14: the Unassisted labels with algorithm violations replaced by the algorithm's output from Unassisted's own answers. Report how many discordant cells change, and the primary and independent-rating agreement after recomputation.
- **Kept unchanged:**
  - agreement with published labels (Table 1: weighted κ, exact agreement, sensitivity and specificity for Some concerns or High, paired differences, All-Low rule; unweighted κ in the supplement);
  - rule-consistency audit (Table 3);
  - quotation and bundle audit;
  - runtime and cost;
  - Table 4, prior work.

## Story (Q10, Q11)

**Challenge.** To our knowledge, no prior LLM RoB 2 study compares against a blinded expert reference across all domains. Prior studies read the models' stricter ratings as errors.

**Resolution (message).**

> Every ARBITER rating follows the RoB 2 rules and every quotation is found in a stored source. Two blinded experts, rating all 510 trial-domains independently, agreed with ARBITER more often than with the unassisted model or the published labels. When the arms disagreed, they chose ARBITER in 53 of 60 cells. Applying the rules to the unassisted model's own answers changed few of those cells, so the gain came from the answers, not the arithmetic.

All numbers are provisional until the pipeline recomputes them.

**Abstract Results order.**

1. The primary endpoint.
2. Independent-rating agreement across 510 cells, ARBITER vs Unassisted vs published labels, for each expert.
3. Stricter ratings usually matched the experts.
4. Rule breaks without ARBITER, and every ARBITER quotation found in its source.
5. Poor, similar κ against published labels.
6. Time and cost.

## Displays (Q12)

Fig 1 and Fig 2 are protected and unchanged.

| Item | Job |
|---|---|
| Fig 3 | Flow: 102 trials → 510 cells, every cell rated by two experts. Nested subsets: 154 disputed → 80 discordant → 60 with an agreed choice. |
| Fig 4 | **A:** agreement with each expert's independent rating by domain and derived Overall, for ARBITER, Unassisted and published labels, with expert-to-expert agreement drawn as the reference line. **B:** direction of disagreement against the experts. |
| Fig 5 | Primary forest: agreed choice, Adjudicator 1, Adjudicator 2, split cells counted as losses, post hoc strictness strata. |
| Fig 6 | Signalling-question agreement with the experts' answers, ARBITER vs Unassisted. The rules-only recomputation is reported in the text. |
| Table 1 | Agreement with published labels (unchanged design). |
| Table 2 | Agreement with the independent ratings: exact agreement and weighted κ for each expert, the agreed reference, derived Overall, paired differences with CIs, and an expert-to-expert row. |
| Table 3 | Rule breaks and audit (unchanged). |
| Table 4 | Prior work. Our row's reference column becomes "blinded dual expert rating of all domains". |

The supplement, numbered in citation order, contains:

- confusion matrices against each expert;
- per-domain κ, including unweighted κ;
- the forced choice on all 154 disputed cells;
- descriptive revised ratings, including how often answers were retained or changed;
- the full signalling-question table;
- the rules-only recomputation;
- the agreed-reference sensitivity;
- expert reliability details;
- the existing eMethods, benchmark, AVATAR, audit, cost and time items.

## Limitations (Q14)

**Drop:**

- selection on disagreement;
- unaudited agreed cells;
- Overall not adjudicated.

**Add:**

- Only two experts, with modest agreement between them, especially in D3.
- The experts could consult sources beyond the arms' inputs.
- The forced choice offered only the three labels and may have been anchored by them.
- Overall is derived from domain ratings, not rated directly.

**Keep:**

- system-level attribution;
- no structured-prompt comparator;
- a single run per arm;
- possible training exposure;
- quotation support not assessed;
- outcome mismatch with the published labels;
- the De Waal input error.

## Unchanged rules

- Bootstrap: stratified trial-cluster, B = 10,000, seed 20261018, percentile intervals. No p-values.
- Sonnet arms only. Haiku appears nowhere.
- Wording rules from `ANALYSIS-PLAN.md` §7: "found in stored source"; "content-hashed"; "assistant"; never "first"; never "over-flagging"; strictness claims for RoB 2 only.

## Work packages

- **WP-A** (`WP-A-analysis.md`): a clean rebuild of the analysis and every output.
- **WP-M**: the manuscript rewrite, written after the WP-A review.
- Claude (the orchestrator) reviews each stage and commits. Pages are republished after WP-M.
