# Legacy display review

22 October 2026. Read-only review of the existing analysis for the manuscript rethink. Recommendations below are proposals, not agreed changes. Figures 1 and 2 and all publication outputs remain unchanged.

## Coverage and version boundaries

Reviewed visually: all six main and five supplementary PNGs in `analysis/output/manuscript/`. Read all four main DOCX tables, all 22 numbered supplementary table groups through their full display CSVs and DOCX footnotes, and the reporting-map CSV corresponding to `TRIPOD-LLM.docx`. The supplement contains 83 physical table chunks; these are continuations and subanalyses, not 83 distinct numbered tables. There are 98 numerical CSV exports overall, including provenance and intermediate tables; not all are reader-facing displays. The large `display-source-trace.csv` is a provenance ledger, not a manuscript table.

Also inspected `analysis/results.html` and `analysis/supplement.html`, which contain a materially older analysis. Viewed their six embedded main figures and two supplementary figures, and read all 28 older supplementary table groups (54 physical HTML tables), including the AVATAR trace and evidence records. Extracted inspection copies are in `legacy-inspection/`. Main HTML table headings exist but the four table bodies are absent from its DOM; current main table content was read from DOCX and CSV. This review does not claim page-by-page Word pagination QA or revalidation of every source PDF or raw run transcript. The analysis pipeline was not rerun.

**Do not combine versions.** Current publication exports report 53/60 agreed forced choices favoring ARBITER, with 20 split choices among 80 arm-discordant cells. The old HTML reports 54/62 and 18 splits. The old flow implies independent review of only 154 disputed cells and includes four model arms; the current flow includes independent expert assessment of all 510 cells and the current displays focus on Sonnet. The old HTML supplement has 28 numbered tables, versus 22 in the current DOCX. Its Methods appendix even has literal `NA` headings. These are stale presentation artifacts, not evidence that the finalized data have those older counts.

## Main figures

| Display | What it contributes | Implication for the rebuild |
|---|---|---|
| Figure 1: architecture | Clearly separates reviewer actions, model interpretation, software checks, and the retained audit record. | Preserve artwork. Use its distinction to organize the empirical evaluation: procedural conformance and judgment quality require different evidence. The recorded rejection/resubmission behavior is a useful process example, subject to its provenance. |
| Figure 2: AVATAR | Connects sources, answers, branching and final ratings; shows counterevidence and uncertainty, especially the dated-plan problem. | Preserve artwork. Treat as an illustration, not a representative success rate. It gives the reader a concrete understanding that later aggregate results can build on. |
| Figure 3: study flow | Separates all-cell independent comparisons from selected forced-choice comparisons. | Retain the two-population logic; simplify the visual hierarchy. The reader should grasp 102 trials → 510 domain cells → all-cell ratings, then the separate 80-discordant/60-agreed branch. |
| Figure 4: forced choice | Formal primary endpoint, expert-specific analyses, split sensitivity and post hoc strictness strata. | Keep complete reporting and formal status. Its selected denominator prevents it from carrying the general performance claim. Sensitivities and post hoc strata need not all occupy equal main-figure space. |
| Figure 5: paired differences and direction | Expert 1, Expert 2 and Published contrasts show why reference choice changes the apparent comparison; lower panel describes severity direction. | Strong candidate for the central empirical display, but absolute performance and expert disagreement must accompany the differences. Domain labels and Overall currently compete for attention. |
| Figure 6: rating, signalling and rules-only comparisons | Connects output judgments with underlying answers and a limited recomputation check. | Too many inferential jobs share one figure. Separate judgment performance, answer diagnostics and procedural conformance. Rules-only is a diagnostic recalculation, not a component ablation. |

## Current supplementary figures

| Display | Reading and proposed role |
|---|---|
| eFigure 1: absolute agreement | Essential context currently buried. ARBITER agrees with Expert 1 on 43/102 D3 ratings (42.2%) and with Expert 2 on 80/102 (78.4%). Expert-to-expert ticks help reveal the reference problem, but are context rather than an attainable-performance ceiling. Bring this information into the main empirical explanation. |
| eFigure 2: collapsed question differences | Helps locate potential sources of gains, using questions with at least 20 paired observations. Keep the threshold explicit; it omits sparse downstream questions. |
| eFigure 3: per-review Published kappa | Supplementary heterogeneity check, not evidence of broad expert-validated generalizability. Only 11 of 16 reviews appear. `R/manuscript-figures.R` filters nonfinite estimates and zero-width intervals; missing reviews must be explained. |
| eFigure 4: domain signalling agreement | Five-level versus collapsed agreement changes the apparent result. It is a substantive diagnostic, not a redundant plotting choice. |
| eFigure 5: all question differences | Full disclosure of exact and collapsed results, including sparse or nonevaluable questions. Preserve in the supplement with readable denominators and explicit nonestimability. |

## Current main tables

| Display | Reading and proposed role |
|---|---|
| Table 1 | Mixes benchmark size, source availability, five-source rating distributions, Overall and expert reliability. Split the reader's tasks: describe the benchmark succinctly; place reference distributions/reliability beside the performance interpretation. |
| Table 2 | Provides primary endpoint and independent agreement evidence. Preserve exact denominators and both experts. Avoid repeating the same estimates in multiple main figures and tables without a different purpose. |
| Table 3 | Combines rule conformance, evidence binding and resources. These are separate propositions. Zero observed rule breaks and 100% structural binding do not establish correct evidence interpretation. Runtime columns are medians [IQR], while the paired difference is a mean; the footnote explains this, but the juxtaposition remains easy to misread. |
| Table 4 | Nine-column prior-work feature matrix. ARBITER's all-Yes row and heterogeneous Partly/Not reported meanings can appear promotional and obscure actual precedents. The DOCX contains literal `[ref: ...]` placeholders. Prefer a concise, qualified literature argument in the main text and a precisely defined comparison in the supplement. |

## Current supplementary tables: complete inventory

| eTable | Contents and substantive reading |
|---|---|
| 1 | Benchmark trials/reviews. Supports breadth and sampling description; breadth is not a prospective external-validation claim. |
| 2 | Expert reliability. Agreement is 388/510 across domains; D3 is especially variable. Necessary context for all performance claims. |
| 3 | Forced-choice sensitivities and post hoc severity strata. Supports conditional preference, with splits retained transparently; does not estimate full-population accuracy. |
| 4 | Full independent agreement, paired contrasts and unweighted results. The numerical backbone. Per-expert, mean-of-experts and agreed-subset estimates are different summaries; 89.9% agreed-reference agreement uses only 388 selected cells. |
| 5 | Confusion matrices against each independent expert. Preserves which categories are confused. Useful for diagnosing stricter labeling without turning severity into correctness. |
| 6 | Titled agreed-reference contrasts, but its CSV repeats the broader paired-contrast collection, including expert-specific rows. It substantially overlaps eTable 4 and should be reorganized. |
| 7 | Exploratory binary agreement and paired differences. Some concerns/High is positive. The pattern does not establish a universal gain without specificity loss: D5 Expert 2 specificity difference is −6.4 points, with CI spanning zero. |
| 8 | Direction of disagreement. Shows stricter/less-strict relationships to each expert; these are reference-relative descriptions. |
| 9 | Published-label agreement. The all-Low comparator has 83.7% exact agreement, exceeding both systems against Published; prevalence makes exact agreement alone inadequate. |
| 10 | Unweighted agreement with Published. Supporting metric sensitivity, not a separate headline. |
| 11 | Full signalling agreement, five-level disagreement types, paired differences and eligibility. Source-specific populations differ; paired comparisons use common evaluable components. D3 against Expert 1 is worse on five-level matching (−10.3 points) but better after collapse (+8.5). Q4.1 has large five-level deficits but zero collapsed difference. These are important qualifications. |
| 12 | Rules-only recomputation, full independent agreement after recomputation, and 26 changed cells. Recomputed baseline exact agreement falls from 332 to 324 cells for Expert 1 and from 400 to 391 for Expert 2. This checks a narrow repair, not the causal contribution of the rules engine. Recomputed forced-choice scores can overlap because matching labels credit both arms. |
| 13 | Rule consistency and audit. ARBITER: 510/510 domain outputs consistent; baseline: 26 contradictions plus 39 required-question omissions among 509 evaluable paths. D4 accounts for 32 of the omissions. One unevaluable path must remain separate. |
| 14 | Evidence binding. 1,538 active answers, 1,407 text-span records, 14 visual records, 102 verified bundles. These are different units. Structural binding and source occurrence are not semantic support; image transcription is model-written. Degenerate 100–100% bootstrap intervals add little useful information. |
| 15 | Runtime, API equivalents and tokens. ARBITER is computationally more costly in this benchmark. No staff-time or deployment-efficiency benefit was measured. Clarify medians versus paired means. |
| 16 | Forced choice across all 154 disputed cells. Matching labels can credit several sources, so source shares do not form an exclusive partition. Separate from the 80-arm-discordant and 60-agreed primary populations. |
| 17 | Revised ratings and retained/changed signalling answers. Descriptive post-exposure behavior; cannot replace the independent-first reference. The 2,244-question-row denominator differs from active/evaluable component counts. |
| 18 | Invalid-path sensitivity under N/PN or NI replacement. Hypothetical resolutions of omissions, not newly observed answers or completed assessments. |
| 19 | API cost reconstruction bounds. Distinguish frozen list-price equivalents, reconstruction uncertainty and unusable harness diagnostics. |
| 20 | Token reconciliation. Reproducibility details belong in the supplement or repository, with intelligible names rather than internal field labels. |
| 21 | Derived Overall validation differences. The 29 differences comprise 21 missing Published labels, seven permitted High escalations, and one Published Low versus derived Some concerns. They are not 29 algorithm errors. |
| 22 | Evidence for the literature feature matrix. Useful transparency, but current generic confidence-interval footnotes are inappropriate for a qualitative source-evidence table. Feature definitions and citations need more care than Yes/Partly scoring conveys. |

The separate TRIPOD-LLM/GRRAS reporting map marks unresolved author information (rater credentials, ethics, funding, conflicts, registration and public involvement). It is an assembly map, not proof of reporting completeness. Its references to stale HTML also need reconciliation when implementation starts.

## What the older HTML adds

Older main Figure 6 and eTables 5–7 localize losses by replacing answers through the official algorithm. The analysis-plan question dominates that selected older population (18 baseline losses), but those counts cannot be carried into the finalized all-cell analysis. The diagnostic idea may be useful if recalculated with a clearly defined population and both independent experts. It would remain exploratory and would not identify a causal system component.

Older eTables 10, 12, 22 and 23 use a composite of offered-label choices and unreviewed Published labels. Their very high absolute agreement is partly built into that construction; full independent ratings now provide a stronger basis. Do not restore the composite as a headline.

Older eTables 9, 13–15, 17–21 and 24 preserve additional-model results, missingness, an override, resources and sensitivity analyses. They are useful audit context; whether to bring Haiku into the rebuilt manuscript remains an explicit scope decision. Older eTables 25–28 expose unresolved answer parsing, quote-syntax heuristics and sparse signalling comparisons. In particular, the old signalling table collapses NI/NA together, unlike the current eligibility rules. Neither the populations nor coding conventions are interchangeable.

Older eFigure 2 is a descriptive choice-pattern heatmap. Its idea is understandable, but it belongs to the selected old adjudication population. Older eFigure 1 is the four-arm Published-label forest. The current two-arm forest is a distinct display.

## Consequences for the story

The review strengthens the already agreed system-and-evaluation identity. Figures 1–2 give the reader a concrete tool and an inspectable assessment. The evaluation should then answer whether the judgments agree more closely with independent experts, show both the gains and remaining disagreement, and distinguish those findings from conformance checks.

The largest domain gains are in D5 (+19.6 and +11.8 percentage points against the two experts). D3 demonstrates why absolute agreement and expert variability must stay visible. Collapsed signalling agreement helps explain directional concordance but can conceal disagreement about certainty. Published-label comparisons teach an evaluation lesson; they do not establish that Published labels are uniformly wrong.

Following Schimel, the resolution should explain what the evaluation changes in our understanding. Following Heard, each display needs a question it answers. Following Zinsser, removing duplicated comparisons is more useful than compressing more metrics into the same panels. The next discussion should settle the opening challenge and the domain-versus-Overall hierarchy before choosing final displays.
