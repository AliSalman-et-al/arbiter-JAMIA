# Synthesis: the literature around AI risk-of-bias assessment (2026-10-19)

Sources: slice files s1–s8 in this folder. Each slice ran on GPT-6-Luna (Medium) and verified its own identifiers. Statuses:

| Slice | Topic | Status |
|---|---|---|
| s1 | Pre-LLM automation | PASS |
| s2 | Other appraisal tools | ISSUES |
| s3 | Imperfect reference methods | PASS |
| s4 | Published RoB quality | PASS |
| s5 | Verifiable LLM systems | PASS |
| s6 | Human–AI collaboration | PASS |
| s7 | Standards and threats | ISSUES |
| s8 | Cost and time | PASS |

The two ISSUES verdicts are scope limits, not failures: s2's search was targeted, and s7 found no JAMIA-specific number of runs.

## 1. What changes in the story

1. **Lineage.** Open the related work with RobotReviewer (Marshall 2016, *JAMIA*), which already paired RoB ratings with extracted sentences and human correction. ARBITER is the RoB 2-era successor. What it adds is a constrained route from evidence to a rating: the RoB 2 rules run as software, quotations are checked against content-hashed stored sources, an audit bundle can be independently verified, and disagreements were adjudicated blind. Cite CPGPrompt (*JAMIA* 2026) and OpenMedCalc as the informatics pattern of deterministic execution beside an LLM, and SourceCheckup and Liang 2026 for "quotation found ≠ supported". (s1, s5)
2. **Strictness is specific to RoB 2.** On ROBIS/AMSTAR 2 and CASP/JBI, LLMs were *more lenient* or affirmative. Write "studies of LLMs on RoB 2 report…", never a general law. Generalise the architecture, not the rule engine; ROBINS-I is the natural next tool, framed as a hypothesis. (s2)
3. **Estimand discipline (most important).** Adjudicating only the disagreement cells invites the discrepant-analysis critique (Hadgu, Lipman, Miller). The bias in 54/62 cannot be quantified and its direction is indeterminate. The composite reference is optimistic in absolute terms, with no guaranteed direction for the paired difference. Call the primary endpoint "the share of adjudicated disagreement cells where adjudicators preferred ARBITER", never accuracy. The adjudicators' independent ratings, made before they saw any label, are a parallel reference that avoids the forced choice. (s3)
4. **Published-label claims, narrowed.** The literature supports published labels being incomplete and inconsistent (Babic 2019, 2023; Hartling; Zhang). It also supports concern about D5 when plans are not checked, which matches our question 5.1 finding. It does not establish systematic D3 leniency or a cause in reviewers' conflicts of interest. Say "in this benchmark, on disputed cells". (s4)
5. **Deployment claim.** ARBITER is an auditable *assistant*, not a second or replacement reviewer. An auditable-looking output can invite rubber-stamping (automation bias). (s6, s1)
6. **Cost framing.** 7.6 and 0.5 minutes are *system runtime*, not staff time. The dollar figures are API list-price equivalents and the runs used a subscription. Do not compare with Minozzi's 28 minutes, which is per outcome, or Crocker's 358 staff minutes per study, which includes consensus, as if the denominators matched. There is no cost-saving claim without measured human checking time. (s8)
7. **Reporting.** Complete the TRIPOD-LLM checklist item by item. Disclose the full skill and prompt, model snapshot, harness settings and a run manifest. Say plainly where the vendor gives no training cut-off. (s7)

## 2. Facts checked by the orchestrator against the repository

- **Adjudication process** (adjudication sheets): each adjudicator wrote a full independent assessment with signalling answers (`own`, `signalling_answers_independent`; "Initial independent assessment (answer1.md)"). They then chose among reviewer letters A/B/C with an explanation, and could record a revised judgement. The sheets do not show whether the arms' rationales were visible. The independent assessments are long, structured markdown with guidance-section citations. **Whether the adjudicators used AI assistance must be confirmed with the authors**, because it determines whether "human adjudication" is accurate and how it is disclosed.
- **Audit integrity:** bundles store content-addressed evidence files (SHA-256 file names). `verification.json` lists checks including `content_hashes`, `canonical_identity` and `proposal_gate`, and records `result: verified`. "Content-hashed" and "independently verified" are supportable. "Unchangeable" should become "content-hashed". A tamper test, in which a modified bundle must fail verification, would make the claim testable.
- **Dates for a contamination check:** the 16 source meta-analyses were published in 2025–2026 (`analysis/data-curated/meta-analyses.csv`), so many published RoB tables may post-date the model's training data. The trial reports are older.
- **Runtime:** the per-trial time is the sum of turn `seconds`, which is wall-clock system time.

## 3. Candidate analysis directions (for author decision)

| # | Direction | Data | Source |
|---|---|---|---|
| A1 | Estimand wording; composite split into adjudicated cells vs cells that kept the published label; independent-rating parallel reference with paired CI | existing | s3 MUST |
| A2 | Random audit of 60–100 cells where both arms agreed with the published label, stratified, two blinded experts seeing no labels, design-weighted estimates and bias bounds | **new human ratings** | s3 MUST |
| A3 | Blinded rating of whether quotations are relevant to and support their answers, on a sample of ARBITER answers | **new human ratings** | s1 MUST, s5 SHOULD |
| A4 | Mechanism behind the D5 / question 5.1 errors: plan unavailable, not retrieved, misread or ignored, using the registry, protocol and SAP files in each arm's inputs | existing | s4 MUST |
| A5 | Check that each published label refers to the same outcome, time point and analysis as our assessment | existing metadata | s4 MUST |
| A6 | Date-split contamination check: review and trial publication dates against the model's documented cut-off, if one exists | existing plus lookup | s7 SHOULD |
| A7 | Repeat runs on a stratified subset (e.g. 20 trials × 3 runs × 2 arms): rating flip rates | **new model runs** | s7 SHOULD |
| A8 | Rule-break breakdown by domain and failure class, and which rule breaks change the rating | existing | s5 SHOULD |
| A9 | Tamper and replay test of bundle verification | new engineering test | s5 COULD |
| A10 | Cost reporting: runtime label, token components, formula, subscription statement | existing | s8 MUST |
| A11 | TRIPOD-LLM item map; disclosure of the full skill and prompt | existing | s7 MUST |
| A12 | Future paper: a prospective study within a review (SWAR) of human + ARBITER, with independent first judgements, time and anchoring measures, and a factorial on evidence display | future | s6 |

## 4. Text changes to carry into the manuscript brief

- Strictness sentence restricted to RoB 2; Table 4 footnote separating structured prompting from enforced rules (s2).
- RobotReviewer lineage in the Introduction; no "Cochrane rejected automation" (s1).
- "Assistant", never "second reviewer" (s6).
- "Content-hashed", never "unchangeable" or "tamper-proof" unless A9 is done (s5).
- Primary endpoint wording per s3; composite results never in the abstract.
- Cost: "system runtime" and "API list-price equivalent", with denominators shown (s8).
- Limitations add discrepant-analysis selection, forced choice, possible recognition of an arm's style by adjudicators, single runs, possible memorisation, and quotation support not assessed.
