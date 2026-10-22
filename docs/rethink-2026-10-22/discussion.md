# ARBITER manuscript rethink: discussion brief

Status: substantive direction settled through Q10; consolidated rebuild brief ready for shared-understanding confirmation. 22 October 2026. Existing manuscript, analysis plan, numerical outputs and Figures 1–2 remain unchanged. The concrete specification is [rebuild-brief.md](rebuild-brief.md).

## Working diagnosis

The complete display review is recorded in [legacy-display-review.md](legacy-display-review.md): six main and five supplementary current figures, four main tables, all 22 current supplementary table groups and the reporting map, plus the distinct older HTML figures and all 28 older supplementary table groups. The HTML reports are stale: their primary count is 54/62, versus 53/60 in the current publication exports. Main HTML table bodies are absent. Keep these versions separate throughout the rebuild.

The existing analysis has a useful evidence base. Its presentation gives too many questions similar prominence: conditional preference, independent agreement, published agreement, strictness, signalling answers, rules-only recomputation, structural checks, and resources. More statistics alone will not resolve this. Decide which change in understanding the manuscript should deliver, then assign each analysis a role.

Figures 1 and 2 already communicate a coherent system contribution: interpretation belongs to the model; source-occurrence checks, rule execution, and preservation of the record belong to software. Preserve their artwork. The empirical evaluation should test the quality of judgments separately from those procedural properties.

## Agreed direction (Q1–Q10)

The following decisions were settled across the first four interview rounds:

1. **Manuscript identity:** a system-and-evaluation paper, with the reference-standard finding as its principal interpretive lesson. ARBITER is an installable tool that readers can use in their own evidence-review workflows. The paper will link to [the public ARBITER repository](https://github.com/AliSalman-et-al/ARBITER/). Availability is part of the contribution; observed effects on human workflow use were not measured in this benchmark.
2. **Explanatory hierarchy:** independent expert assessments across all 510 cells carry the main explanatory weight. The forced-choice endpoint retains its documented formal primary status, its conditional interpretation and complete reporting. Narrative emphasis does not retroactively change prespecification.
3. **Opening challenge:** AI-assisted evidence appraisal needs judgments that readers can inspect and defend. Figures 1–2 explain inspectability; the benchmark evaluates judgment quality through agreement with independent expert assessments. Reference choice enters as an evaluation problem.
4. **Evaluation organization:** center the main empirical story on the five domains, presenting absolute agreement, paired improvement and expert variability together. Derived Overall is secondary. This editorial hierarchy leaves forced choice as the formally designated primary endpoint.
5. **Central claim:** ARBITER preserves a checkable assessment record and executes RoB 2 rules. In this benchmark, the complete workflow improved agreement with two independent experts compared with the same model given a minimal prompt, with substantial variation across domains. Attribution is to the complete evaluated workflow. Practical value relative to additional time and cost was not measured.
6. **Metric hierarchy:** lead with exact agreement and paired percentage-point differences. Show the two experts separately; weighted kappa provides complementary ordinal context. Category distributions and expert-to-expert agreement remain visible. Expert averages and agreed-reference subsets are supporting analyses.
7. **Reporting scope:** the paper and its supplement describe only the Sonnet workflow. The author clarified that the separate one-off experiment is outside this focused paper and should not be mentioned. Earlier audit documents retain their historical coverage; they do not define manuscript scope. No generalization across models is claimed.
8. **Diagnostics:** explain where agreement improves and where judgment remains difficult using full eligible independent-reference comparisons. The author delegated detailed choices to the assistant's judgment. Start with systematic question-level results; choose examples under an explicit rule; distinguish five-level and collapsed answers; retain rules-only recomputation as supporting evidence without causal component claims.
9. **Display architecture:** target five figures and three tables. Preserve Figures 1–2; use Figure 3 for design, Figure 4 for performance and reference context, Figure 5 for diagnostics; use Table 1 for the benchmark, Table 2 for the formal primary endpoint and core sensitivities, Table 3 for process verification and resources. Move the literature matrix and exhaustive comparisons to the supplement. A sixth figure is available if required for readability.
10. **No target-matching differentiation:** the author rejected the proposed matched-target sensitivity. Do not subset, stratify or otherwise differentiate cases by whether the published label clearly addresses the same assessed result. Use the full domain cohort for reference comparisons. Describe uncertainty about assessment targets as a limitation, without creating matching groups or treating disagreement as proof of published-label error. Ordinary missing-data handling for derived Overall remains unchanged.

The public tool and the evaluated version should be distinguished in software availability and reproducibility statements. The live repository is the reader's entry point; the exact evaluated version identifies the object of the reported comparison.

## Working story wording implementing the agreed direction

**Central question:** Can an auditable RoB 2 workflow produce judgments closer to independent experts than the same model given a minimal prompt?

**Answer:** In this benchmark it did, while preserving checkable evidence and rule execution; comparison with published review labels alone did not show the same clear advantage.

**Opening:** Evidence appraisal needs judgments that people can inspect and defend.

**Challenge:** Software can enforce rules and preserve evidence, but these properties do not establish that the model interpreted the evidence appropriately. Published review labels are also an imperfect evaluation reference.

**Action:** Present ARBITER's architecture and worked trace, then evaluate the complete workflow against the same model with a minimal prompt and the same supplied files, using independent-first ratings from two blinded experts across all domains and the prespecified forced-choice task.

**Resolution:** The workflow showed improved expert agreement in this dataset. Its procedural guarantees and interpretive performance are distinct contributions; the reference used to judge performance affects the apparent comparison. Human review remains necessary, and workflow benefit in actual use is unmeasured.

The agreed identity is a system-and-evaluation paper. The reference-methodology finding supports this identity. A deployment or efficiency claim is not supported by the available human-use measurements.

## Evidence roles, before choosing displays

| Reader question | Existing evidence | Interpretation limit |
|---|---|---|
| What is the intervention? | Figures 1–2; rule checks, stored evidence and audit records | Checks do not establish semantic support |
| Are judgments closer to independent experts? | 510 cells per expert; exact-agreement differences +7.6 and +6.5 percentage points; weighted kappa and domain details | Two imperfect experts; same-model complete-workflow contrast |
| Do experts prefer ARBITER when arms disagree? | 53/60 agreed choices; 80 discordant cells with 20 split choices; per-expert and split-loss sensitivities | Conditional preference, not 88.3% population accuracy |
| Does reference choice matter? | Published exact-agreement contrast −1.8 points (95% CI −5.1 to 1.6), versus gains against both experts | Some published targets broad or inferred; do not infer published error from disagreement alone |
| Is improvement simply stricter labeling? | Expert-specific binary and direction analyses | Exploratory; experts also differ in severity |
| What might contribute? | Signalling agreement and rules-only recomputation | Recalculation is a diagnostic check, not a factorial ablation or mediation analysis |
| What does the workflow cost? | Recorded system runtime and API list-price equivalents | No measured staff-time savings or prospective review benefit |

Sources: `analysis/output/tables/primary-endpoint.csv`, `independent-differences.csv`, `display-table2.csv`, `signalling-paired-estimates.csv`, `rules-only-agreement.csv`, and `analysis/round16-report.md`.

## Proposed analysis architecture

1. Define the target assessment, paired population, comparator and independent expert procedure once.
2. Retain the prespecified primary endpoint and all its denominators. Give the all-cell independent comparisons enough prominence to carry the broader interpretive claim. Editorial prominence does not change statistical status.
3. Use a compact comparison across references for the main empirical result. Keep absolute agreement, category distributions and expert reliability visible enough to prevent a difference-only display from overstating performance.
4. Keep process verification distinct from agreement. Pair rule-conformance findings with signalling-answer findings only when the caption makes their different denominators and purposes explicit.
5. Use the supplement for exhaustive question/domain breakdowns, secondary metrics, matched Overall populations, revised ratings, and most literature feature comparisons. Do not omit discordant or unfavorable findings.
6. Reuse the finalized estimates and perform only transformations needed for agreed diagnostics and presentation. Do not add target-matching subgroups or sensitivities. Present the different reference-specific results descriptively; a significant-versus-nonsignificant contrast does not itself establish a statistical difference between references. No new cross-reference hypothesis test or additional experiment is required by the agreed plan.

## Issues to settle before rewriting

- **Reporting scope (settled):** The author directed that chronology/history declarations be omitted. Describe the evaluation as performed, including populations, expert sequence, endpoint definitions and statistical methods. No chronology declaration or reconciliation is an implementation prerequisite.
- **Reference matching (settled):** no matching-based case differentiation or sensitivity. Acknowledge target uncertainty qualitatively and avoid inferring published-label error from disagreement.
- **Rules-only check:** Correcting 26 inconsistent final labels does not repair invalid answer paths, retrieval, or evidence interpretation. Its failure to close the gap cannot establish the effect of any individual component.
- **Scope (settled):** report only the Sonnet workflow in the manuscript and supplement, with no mention of the separate one-off experiment. Prior audit coverage does not expand reporting scope.
- **Claim boundaries:** No expert equivalence, replacement-reviewer, human-time saving, semantic evidence-validation, or causal component claim is established.

## Decision tree

Settled by the current request: rebuild the intellectual structure; use the writing books; discuss before implementation; preserve Figures 1 and 2; inspect the finalized data.

Settled in rounds 1–2: system-and-evaluation identity, public installable-tool contribution, link to the ARBITER repository, explanatory prominence of all-cell independent expert comparisons with formal primary status preserved for forced choice, the inspectability/defensibility opening challenge, and domain-centered evaluation with absolute performance and expert variability visible and derived Overall secondary.

Settled in round 3: central claim bounded to the complete evaluated workflow; exact-agreement-led metric hierarchy with separate experts; Sonnet-only reporting with no mention of the separate experiment; diagnostic purpose accepted and detailed choices delegated to assistant judgment.

Settled in round 4: five-figure/three-table target accepted; proposed target-matching sensitivity rejected. The full cohort remains the basis of the reference comparison, without matching-based differentiation.

Q11 settled: the author confirmed shared understanding and authorized GPT-6.1 Sol to implement the [rebuild brief](rebuild-brief.md), applying relevant Pstack skills in a usage-efficient manner. The design frontier is closed. Routine editorial and visual choices within the brief use assistant judgment. Implementation and verification now follow.

The full display review sharpens Q4: absolute performance and expert variability must sit beside paired gains. D5 has the largest exact-agreement gains (+19.6 and +11.8 points), whereas ARBITER's D3 agreement differs markedly between the experts (42.2% and 78.4%). Five-level and collapsed signalling comparisons can reverse the direction of a result. These qualifications should shape the main explanation, not be left solely to exhaustive supplementary tables. The older loss-localization analysis offers a possible diagnostic idea, but its selected population and obsolete expert counts cannot be reused as finalized results.

Implementation details: final visual spacing, captions, exact prose, supplement numbering and title wording can follow the consolidated brief and the [second-review blueprint](second-review/blueprint.md). Diagnostic details are delegated. The finalized data are the current evidence envelope; no new experiment is assumed. Chronology/history declarations are excluded from the manuscript and supplement by the author's direction.

JAMIA's Research and Applications guidance currently allows 4,000 words, a 250-word structured abstract, up to six figures and four tables. It also cautions against duplicating table data in figures or text. These are ceilings, not display targets. Source checked 22 October 2026: https://academic.oup.com/jamia/pages/General_Instructions (official indexed text; direct fetch timed out).

## First-principles constraints on the next decisions

The author explicitly requested deep first-principles thinking throughout this session. Start with the intended task: a person must judge bias in a specified trial result and be able to inspect the basis for that judgment. A retained quote establishes where text came from; it does not establish relevance, completeness or a sound interpretation. Rule execution establishes what follows from recorded answers; it does not establish that those answers are right. Agreement with independent experts provides empirical evidence about judgments, with uncertainty from the experts themselves. The same-model comparison estimates the effect of the complete evaluated package relative to the minimal-prompt comparator, including differences in instructions, process and computation. It cannot isolate the rules engine. An installable tool is an available artifact; reductions in reviewer workload or improved decisions in actual use require human-use evidence not collected here.

These distinctions should determine claim strength before display selection. The desired reader impression is a useful, inspectable tool with a credible, bounded evaluation and intelligible remaining weaknesses. Stronger rhetoric cannot substitute for the missing link between a process property and practical effectiveness.

The glossary now explicitly identifies ARBITER as an installable tool. Decisions are recorded here while the design remains fluid; no separate ADR is needed yet.

## Swarm synthesis and review coverage

Three complementary slices ran on `gpt-6-luna` with `reasoningEffort: high`; this was coverage, not a model race. All three completed, with no dropouts.

| Slice | Verdict | Consequence |
|---|---|---|
| Closest literature | ISSUES | Claim a specific combination and evaluation; retrieval, algorithmic aggregation, conformance auditing and blinded expert references have precedents |
| Reference validity and JAMIA fit | ISSUES | Use named imperfect references; separate conditional preference from full-cohort agreement; attend to result matching |
| Data and output audit | ISSUES | Main forced-choice counts reproduced; single-run/minimal-prompt limits persist; additional-model exports contain a missing included trial |

The parent reviewer checked the current main and supplementary figure PNGs, key numerical CSVs, four-arm label distributions, expert-workbook sheet extents, rule-status counts, all 16 binding notes for target concerns, the dated plan, and relevant writing-book sections. Several errors in initial worker prose were corrected against primary files: figure roles, file inventory, rule denominator, OCAR expansion, and unsupported assertions about plan timing. The corrected reports are the review artifacts.

Coverage is an audit of all data/output families with focused numerical verification, not an assertion that every raw transcript, trial PDF, or exported document page was revalidated. The full pipeline was not rerun. The Zotero manuscript collection contained 94 top-level records; its metadata and abstracts are saved in `zotero-collection.json`. This is not a claim that all 94 papers were read in full. Literature access limitations are recorded in the slice reports; the RoB2-Evaluator preprint remains abstract-only and some other descriptions rely on earlier local full-text extractions. The search is targeted, not systematic.

After the author's request for complete figure/table coverage, the parent read all current display tables and footnotes, inspected every current figure visually, and separately read/viewed the older HTML display families. This completes display-content review; it is not Word pagination QA or a fresh numerical reproduction. See the full display review for each figure/table's contribution and limitations.

Primary sources independently checked by the parent include [ROBoto2](https://aclanthology.org/2025.emnlp-demos.2/), [Huang](https://www.jmir.org/2025/1/e70450/), [Choi](https://www.e-jebp.org/journal/view.php?number=21), [Gandhi](https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0353155), and [Liang](https://ai.jmir.org/2026/1/e93761/). Their roles are precedents and limits on novelty; no cross-study performance ranking is justified by their different designs.
