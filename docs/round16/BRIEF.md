# Round 16 brief: story, Methods and Results architecture, displays

Agreed with the authors on 2026-10-21 in a grilling session (Q1–Q17). This brief supersedes `docs/round15/BRIEF.md` on story, outcome labels, Results order, tables, figures and abstract. Round 15's data, estimates, wording rules and the Haiku and earlier-adjudication exclusions all still apply. Never mention the earlier adjudication, and never mention Haiku.

## 1. Message (Q1, Q8)

One message with two layers:

> When rules and evidence checks are the only route to a rating, an LLM's RoB 2 assessments agree more closely with blinded experts than the same model without the workflow. Agreement with published labels, the usual benchmark, shows no clear difference between the two.

- Scored against published labels, exact agreement favoured neither arm: ARBITER − Unassisted −1.8 points (95% CI −5.1 to 1.6); weighted κ +0.06 (−0.03 to 0.14). ARBITER's sensitivity for Some concerns or High was higher (+15.7 points) and its specificity lower (−4.4). Against published labels, ARBITER therefore looks like the over-strict model that prior studies describe.
- Scored against the blinded experts, ARBITER agreed more often: +7.6 points (5.1 to 10.2) and +6.5 (3.5 to 9.4).
- Say "showed no clear difference" or "did not distinguish the arms". Never say "hid", "reversed" or "masked".
- Auditability is part of the system's design. Report it in the Methods and in one Results paragraph; it is not a third arm of the message.
- The claim stays at the level of the whole system. Address the minimal-prompt comparator in the Methods where it is introduced, and again in the limitations.

## 2. Introduction and Objective (Q2, Q3)

- **Background paragraph 1** names two requirements for an AI risk-of-bias tool to be usable: judgements a reviewer can check, and judgements close to careful expert assessment. It then turns quickly to the problem: the second requirement has been measured against published labels, which disagree among themselves (Minozzi, Bertizzolo, Yao).
- **Paragraph 2:** stricter model ratings have been read as error.
- **Paragraph 3:** existing systems, as before.
- **Paragraph 4:** the Challenge, with one "to our knowledge".
- **The Objective asks two questions:**
  1. Are ARBITER's ratings closer to blinded experts than Unassisted's? State the prespecified forced-choice hypothesis.
  2. Does agreement with published labels give the same comparison?

## 3. Terminology (Q6)

- Reader-facing text says **Expert 1 and Expert 2**. "Adjudication" means only the forced-choice step. `GLOSSARY.md` is updated.
- Propagate the new labels to every table, figure, legend, the supplement, results.html and supplement.html. Figures 1 and 2 are byte-protected and keep their current wording.

## 4. Outcome labels (Q10′)

The version-controlled plan of 18 October 2026 (commit `e1c0ccf`) was written before the expert ratings existed. It specified the analyses listed below.

**Prespecified:**
- the primary endpoint (forced choice);
- each expert's independent-rating agreement with ARBITER, Unassisted and published labels (weighted κ as the main measure, plus exact agreement and paired differences);
- expert-to-expert agreement;
- signalling-answer agreement with the experts' independent answers;
- published-label agreement;
- the rule audit;
- time and cost.

One Methods sentence says these comparisons were applied to all cells because the experts assessed every cell. That plan specified them for disputed cells. Do not mention the earlier adjudication.

**Exploratory, labelled as such:**
- derived Overall against the experts;
- direction of disagreement;
- rules-only recomputation;
- strictness strata;
- the new severity analyses (§6).

Amend `ANALYSIS-PLAN.md` and the deviations record to match, with a dated note. Remove every "defined after data collection" statement for the prespecified items.

## 5. Methods structure (Q10)

Use five subsections:

1. **System design.**
2. **Benchmark and assessment arms.** State the comparator's limits here.
3. **Expert reference standard.**
4. **Outcomes,** as an explicit hierarchy: primary → prespecified secondary → exploratory.
5. **Statistical analysis.**

Write each paragraph lead first, then the detail. The Methods cite only eMethods; all eTable and eFigure callouts move to the Results. Renumber the supplement in Results citation order.

**Keep the label-to-result binding disclosure as it stands (Q9).** That is the one Methods sentence with the audit counts and the one limitation clause. Do not add emphasis, do not add a sensitivity analysis, and do not add a new statement of how many labels were inferred or mismatched (Q7).

## 6. New exploratory analyses (Q4, Q5)

- **Severity distribution.** The share of cells rated Low, Some concerns and High (D1–D5, 510 cells) for each source: published labels, ARBITER, Unassisted, Expert 1 and Expert 2. Expected counts of Low ratings: 427, 375, 407, 277 and 346. Recompute them; do not copy.
- **Binary Some concerns or High against each expert.** Sensitivity and specificity for ARBITER, Unassisted and published labels against each expert's independent rating, with paired ARBITER − Unassisted differences and the Round 15 bootstrap.
- **Expert-to-expert agreement as the yardstick.** Report κ 0.59 (76.1%) next to each source's κ against each expert. ARBITER's 0.51 and 0.69 fall either side of it. Unassisted (0.35, 0.53) and published labels (0.21, 0.29) fall below. Say "within the range of agreement between the two experts"; never say "expert-level" or "matched experts".

## 7. Results order (Q11)

One paragraph per step:

1. **Benchmark and reference.** Flow (Figure 3), benchmark characteristics, severity distributions and expert-to-expert reliability (Table 1).
2. **Primary endpoint:** 53/60 (Figure 4).
3. **Independent-rating agreement.** Paired differences, κ relative to expert-to-expert agreement, and derived Overall on 81 trials (Table 2, Figure 5A).
4. **Is it just strictness?** Direction of disagreement (Figure 5B) and binary sensitivity and specificity against the experts.
5. **The published-label benchmark,** set against step 3: no clear difference (Table 2, Figure 5A).
6. **Answers or arithmetic.** Signalling answers and rules-only recomputation (Figure 6).
7. **Process integrity.** Rule breaks and evidence checks (Table 3).
8. **Time and cost** (Table 3).

## 8. Tables (Q12)

| Table | Content |
|---|---|
| 1 | Benchmark and reference characteristics: trials, meta-analyses, specialties, documents available, the five sources' severity distributions, and expert-to-expert agreement (overall, plus D3 as the lowest domain) |
| 2 | Agreement with each reference. Columns: Expert 1, Expert 2 and Published. Rows: ARBITER, Unassisted and Published (Published is blank against itself), plus an expert-to-expert row. Each row gives exact agreement n/N (%) and weighted κ; sensitivity and specificity for Some concerns or High go here or in eTable. The paired ARBITER − Unassisted difference (95% CI) is shown under each reference. There are two blocks: D1–D5 (510 cells) and Overall (81 trials with a published Overall). This merges the old Tables 1 and 3. |
| 3 | Rule conformance, evidence checks, time and cost |
| 4 | Prior work, unchanged |

Old content that leaves the main tables goes to eTables: the mean of experts, the agreed reference, All-Low and AC2.

## 9. Figures (Q13′)

| Figure | Content |
|---|---|
| 1, 2 | Byte-identical |
| 3 | Two-branch flow. A side box shows 3 trials excluded for unsupported designs. Left branch: 102 trials × D1–D5 = 510 cells go to the independent-rating comparison, with Overall derived for 102 trials and compared on 81. Right branch: 154 disputed → 80 where the arms disagreed → 60 with an agreed choice, plus 20 split. Note the 356 concordant cells. |
| 4 | Primary forest, unchanged except for relabelling "Adjudicator" to "Expert" |
| 5A | Two benchmarks. The paired ARBITER − Unassisted difference in exact agreement (95% CI) for D1–D5 pooled, D1 to D5, and Overall. Three facets, scored against Published, Expert 1 and Expert 2, with a zero line. Use the Round 15 encoding. |
| 5B | Stacked direction bars, unchanged except for labels |
| 6 | Answers or arithmetic. For each expert, a dot plot of agreement (95% CI) for Unassisted, Unassisted after rules-only recomputation, and ARBITER. Rows: domain ratings (510 cells) and collapsed signalling answers (paired). Recomputation does not change answers, so the signalling row has only two dots; say so in the legend. |

The current Figure 5A (per-domain absolute agreement, with the expert-to-expert reference drawn as a per-domain tick, not a joined line) and the current Figure 6 (per-question signalling forest) become eFigures. No figure has an in-image title.

## 10. Abstract (Q14) and title (Q15)

**Title:**

> ARBITER, an auditable large language model workflow for RoB 2 risk-of-bias assessment: comparison with blinded expert assessment and published review labels

**Abstract Results order:**

1. Primary endpoint.
2. Paired differences against each expert, with κ either side of expert-to-expert agreement.
3. Published labels: no clear difference.
4. Stricter ARBITER ratings matched the experts.
5. Rules-only recomputation did not close the gap.
6. One clause on evidence and rules.
7. Cost and time.

Drop the per-source percentages and Overall from the abstract. Keep it to 250 words or fewer.

## 11. Discussion and conclusion (Q16)

1. **Principal finding,** answering both Objective questions.
2. **Why published labels showed no difference.** Stricter ratings count as errors against them, yet the experts shared them. Gandhi's masked panel points the same way. Bound this to the present benchmark.
3. **Answers or arithmetic,** with Huang and Choi.
4. **Prior systems** (Table 4).
5. **Deployment and cost.**
6. **Limitations,** in two paragraphs. The second opens with reference reliability: two experts, κ 0.59, D3 lowest, extra sources.
7. **Two-sentence conclusion.** The second sentence is the implication we have earned: *evaluations of AI risk-of-bias tools need a blinded expert reference alongside published labels, because the two can rank systems differently.*

## 12. Release archive (Q17)

- Data availability will point to a release built from a clean snapshot of the final state, not the working repository's history.
- The archive includes the dated 18 October plan with its wording unedited, as the evidence for prespecification.
- Building and publishing the release, making the repository private and depositing on Zenodo are author actions, not work-package tasks.
- Workers prepare a release manifest that lists what goes in.

## Hard rules

- Round 15's rules apply: the banned words, "to our knowledge", "found in stored source", no invented numbers, and every number traced by `verify-numbers.py`.
- Displays are numbered in first-citation order.
- The main text is 4,000 words or fewer, and the abstract 250 or fewer.
- Figures 1 and 2 stay byte-identical.
- Existing estimates do not change. New estimates come only from §6.
