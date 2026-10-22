# ARBITER: consolidated manuscript blueprint

22 October 2026. Research and editorial design only. Integrates three completed GPT-6-Luna / high review slices, the author's accepted Q1–Q10 decisions, the local writing books, current numerical exports, and additional parent verification. Baseline: `951dddd3e28e0d6316c641491667353e0b851a78`. This document adjudicates the worker reports; do not transplant their wording or numbers without these corrections. No manuscript, analysis pipeline, or protected artwork has been changed.

## 1. The paper's governing idea

**ARBITER makes a RoB 2 assessment inspectable, and its complete Sonnet workflow showed closer agreement with two independent experts than the same model given a minimal prompt in this benchmark.** Those are two supported propositions. The empirical comparison does not establish that inspectability caused the gain.

The desired JAMIA reader impression is: “I understand the system, can inspect what it produced, can see the magnitude and limits of its evaluation, and can obtain the evaluated implementation.” This requires a positive account of the contribution, not a paper organized around defending every possible limitation. State each boundary where it changes interpretation, then continue the argument.

The useful conceptual distinction is between **a reviewable assessment process** and **the quality of its judgments**. A final label compresses evidence selection, answer interpretation, and rule application into one output. ARBITER exposes that pathway. The evaluation then asks a separate question: how closely do the resulting judgments agree with independent expert references? Figures 1–2 answer the process question; Figures 3–5 and Tables 1–3 establish the evaluation and its limits.

An installable tool is a concrete contribution. It does not need a global “first” claim. The public entry point is [ARBITER](https://github.com/AliSalman-et-al/ARBITER/); the paper must separately cite the evaluated version/commit and archive the inputs and reproducible analysis materials that can be shared.

## 2. What the literature changes

The surrounding work rules out several easy novelty claims. The following is a targeted comparison, not a systematic review or a priority certification.

| Primary source | Relevant overlap | Consequence for this paper |
|---|---|---|
| [RobotReviewer, JAMIA](https://academic.oup.com/jamia/article/23/1/193/2379921) | Automated judgments and supporting-text identification predate current LLM systems. | Introduce a lineage of evidence-assisted appraisal; do not imply that showing evidence is new. Worker inspected full text. |
| [ROBoto2, EMNLP 2025](https://aclanthology.org/2025.emnlp-demos.2/) | Open-source interactive RoB 2 platform, retrieved evidence, user correction, and an evaluation dataset. | This is a direct system comparator in the introduction. Explain ARBITER's particular model/software division and retained record without claiming exclusive auditability. Worker inspected paper; parent verified official record. |
| [Huang et al., JMIR 2025, corrected article](https://www.jmir.org/2025/1/e70450) | Structured prompting, fresh reviewer and Cochrane references, repeated assessments, and judgments derived from signalling answers. | Rule-derived ratings and reference-sensitive evaluation are established ideas. Explain what this complete-workflow comparison adds. Full article consulted. |
| [Xiong et al., BMJ Evidence-Based Medicine 2026](https://pubmed.ncbi.nlm.nih.gov/42144258/) | Direct-command control versus increasingly constrained prompts on 158 trials using RoB 1. | Even the same-model minimal-versus-structured comparison is not broadly new. The contribution is this implemented RoB 2 workflow and evaluation, not the first demonstration that structure helps. Parent inspected indexed primary abstract; publisher full text unavailable. |
| [Gandhi et al., PLOS One 2026](https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0353155) | Structured RoB 2 prompting on 50 trials; original review labels and fresh masked human assessments, reconciled to a panel reference. | Separate expert reporting is a design choice worth explaining, but “we compared published and fresh human labels” is not sufficient novelty. Parent inspected full methods. |
| [Li et al., BMC Medical Research Methodology 2026](https://pubmed.ncbi.nlm.nih.gov/41559613/) | Tests human–AI collaboration modes using RoB 1, including evidence and reasoning support. | Distinguish an offline system evaluation from a measured human-use intervention. Do not import their workload claims into this study. Parent inspected primary abstract. |
| [Lai et al., JMIR 2026](https://pubmed.ncbi.nlm.nih.gov/42789359/) | RoB 2 decision logic incorporated into prompts, repeated assessments, published review references. | Explain that executable rule application is an implementation property; putting rules into prompts is already studied. Parent inspected primary abstract. |
| [Liu et al., EMNLP 2023](https://aclanthology.org/2023.findings-emnlp.467/) | Distinguishes citation coverage from whether a source supports a claim. | Describe structural source verification precisely. Passage occurrence is not semantic support. This is methodological context from another task. |
| [Minozzi et al., 2020](https://pubmed.ncbi.nlm.nih.gov/32562833/) | Directly examines RoB 2 interrater reliability and application difficulties. | Use RoB 2-specific evidence when motivating reference variability. Do not present the earlier Hartling RoB 1 study as RoB 2 validation. Primary abstract consulted. |

The 2026 [Nyrhi comparative validation study](https://pmc.ncbi.nlm.nih.gov/articles/PMC13054287/) is another relevant citation: indexed primary text reports domain-specific agreement and repeated-run reliability. Full-page retrieval encountered a browser challenge in the parent pass. Retain it as a current comparison lead, but verify any detailed design claim against the full paper before drafting it. None of these studies supplies a transportable performance benchmark: different datasets, input access, references and tools prevent ranking our percentages against theirs.

**Introduction language to prefer:** “Prior systems have combined automated appraisal with supporting evidence, interactive review, and structured RoB 2 reasoning. We developed ARBITER to make the assessment pathway inspectable and evaluated its complete workflow against a same-model minimal-prompt comparator.” Then name what was measured. Avoid “existing systems lack transparency” as a universal premise.

Do not retain the legacy all-Yes/Partly/NR literature matrix. If a supplementary comparison is useful, use a short evidence ledger with columns for task/version, workflow, evidence handling, evaluation reference, and access limitations. “Not reported” must remain distinct from “absent.” Every row needs a primary citation and a defined comparison criterion; a ledger is not a league table.

## 3. OCAR and paragraph jobs

**Opening:** Evidence appraisal needs judgments whose basis can be inspected and defended. **Challenge:** A plausible label does not reveal how evidence, interpretation, and decision rules produced it; an inspectable record also does not by itself validate the judgment. **Action:** Present the available workflow, illustrate its record, and evaluate the same-model contrast using independent experts, the conditional formal primary endpoint, procedural checks, and computation. **Resolution:** This workflow provides an inspectable record and improves expert agreement in this benchmark, with domain and reference dependence still visible.

This applies Schimel's *Writing Science* distinction between data, inference and resolution; Heard's *The Scientist's Guide to Writing* advice to choose displays for the comparisons readers need and to report meaningful numerical precision; and Zinsser's *On Writing Well* principles of unity, sequence and removing clutter. The parent additionally inspected the books' passages on quantitative results, graphics, and supplements. These are editorial applications, not empirical claims from the books.

Suggested main-text allocation: approximately 550 words for Background and Significance/objective, 1,300 Methods, 850 Results, 1,000 Discussion, and 80 Conclusion, leaving some room below the 4,000-word limit. These are drafting budgets, not targets to fill. JAMIA Research and Applications currently permits 250 abstract words, six figures and four tables; our target remains five figures and three tables. Use the journal's required abstract headings and Background and Significance section. [Official instructions](https://academic.oup.com/jamia/pages/General_Instructions).

**Background and Significance, four paragraphs:** (1) Why defensible appraisal matters. (2) What existing automation and interactive systems provide. (3) Why inspectable procedure and judgment performance need separate evaluation; identify the practical comparison. (4) State the system and study objective. Do not spend the opening on generic LLM promise or a long inventory of model brands.

**Methods, six paragraph groups:** (1) Architecture and evaluated software/model configuration, with Figures 1–2 and software availability. (2) Benchmark selection, assessed result specification, supplied files and comparator instructions. (3) Independent-first expert sequence and masking, followed by the separate choice stage. (4) Endpoint populations and the distinction between five domains and derived Overall. (5) Paired estimands, fixed-reference interpretation, bootstrap and multiplicity status. (6) Rule/source/record checks, signalling eligibility and computational resources. Essential interpretation belongs here; implementation detail and complete prompts belong in the supplement.

**Results, five paragraph groups:** (1) Benchmark and complete coverage, Figure 3/Table 1. (2) Formal primary endpoint and core sensitivities, Table 2. (3) Full-cohort expert agreement, including absolute levels, paired gains, D5 and D3, Figure 4. End this group with the full-cohort Published contrast. (4) Systematic answer diagnostics and the exact-versus-collapsed distinction, Figure 5. (5) Procedural properties and computational burden as separate propositions, Table 3. A results paragraph states a pattern and its scale; it does not recite its display.

**Discussion, six paragraphs:** (1) Answer the study question. (2) Explain the contribution alongside the closest prior systems and the complete-workflow comparator. (3) Interpret domain variability and expert disagreement. (4) Interpret reference dependence and diagnostic findings without assigning error or causation. (5) Explain what the record and process checks enable, their semantic limits, and what the measured computation costs. (6) Bound generalization and identify the next evaluative step: repeated runs, component comparisons, independent evidence-support assessment, and human-use evaluation. End by returning to inspectable appraisal and the available system, rather than ending on a list of deficiencies.

## 4. Numerical spine and statistical wording

| Quantity | Verified result | Interpretation |
|---|---|---|
| Benchmark | 102 trials, 16 reviews, 510 domain cells | A cell is a trial-domain rating, not an independent trial. |
| Formal primary | 53/60 agreed choices; 88.3%, 95% CI 79.7–96.3 | Selected from 80 arm-discordant cells; 20 choices split. Conditional preference, not 510-cell accuracy. |
| Expert 1, all cells | 371/510 vs 332/510; 72.7% vs 65.1%; +7.6 points, 95% CI 5.1–10.2 | Paired agreement gain. |
| Expert 2, all cells | 433/510 vs 400/510; 84.9% vs 78.4%; +6.5 points, 95% CI 3.5–9.4 | Separate reference, not a replicate expert sample. |
| Expert pair | 388/510, 76.1%; weighted κ 0.59 | Context; not a ceiling or a truth label. |
| D5 | +19.6 points (11.8–27.5) and +11.8 (2.9–20.6) | Largest observed domain gains; not a formal comparison of domain effects. |
| D3 | ARBITER 43/102 (42.2%) and 80/102 (78.4%); experts agree on 54/102 | The absolute difficulty and reference dependence should remain visible. |
| Published reference | 386/510 vs 395/510; 75.7% vs 77.5%; −1.8 points (−5.1–1.6) | Full cohort; no matching subset or target-based differentiation. |

The exact-agreement estimand is the proportion of ratings matching a named reference. The paired difference is the mean of the within-cell match-indicator differences, with shared trial bootstrap weights. An optional supplementary partition makes the gain concrete: Expert 1 has 50 ARBITER-only matches and 11 Unassisted-only matches; Expert 2 has 55 and 22. The net improvements are therefore 39 and 33 cells. These are descriptive rearrangements of existing observations, not new tests or independent validation.

There are 10,000 bootstrap replicates. Trials are sampled with replacement **within the 16 fixed reviews**, carrying their domain ratings and paired arms together; intervals are percentile intervals. They do not quantify sampling of new reviews, new experts or new model runs. Do not describe 510 ratings as 510 independent observations. Do not infer a difference between experts, domains or references from significance in one and its absence in another. The supporting comparisons remain descriptive/secondary or exploratory as appropriate; no star annotations, new p-value hunt or post hoc multiplicity procedure is proposed.

Category prevalence matters. Published labels are Low in 427/510 cells, so an all-Low predictor matches 83.7%. Report category distributions and complementary ordinal agreement in the supplement and a compact reference-distribution summary in Table 1. Do not let raw agreement become an unqualified performance score. Conversely, do not replace understandable counts with a collection of kappa, AC2, sensitivity and specificity headlines.

**Report the evaluation as performed.** Retain the formal primary endpoint and the secondary independent expert comparisons across all 510 domain cells. Explain their populations, expert sequence, estimands and interpretation. As directed by the author, omit chronology/history declarations from the manuscript and supplement.

Derived Overall stays supplementary: 102 expert-derived Overall ratings; only 81 observed Published Overall labels. The 21 missing Published labels are not errors. Overall is derived from five domains and is not an independent sixth domain. Keep it out of Figure 4 and the formal-primary Table 2.

## 5. Displays as an argument

**Figures 1 and 2: preserve bytes.** Architecture and worked trace answer different questions. The trace is illustrative, not a representative performance case. Ensure the text connects the retained record to the concrete act of checking an answer; do not turn the caption into an implementation manual.

**Figure 3: two evaluation paths.** Show 102 trials × five domains → 510 independent-first comparisons, with both experts visible. Then show the later conditional path: 80 arm-discordant cells → 60 agreed choices + 20 splits. State counts' units and masking. Do not make the full cohort look like a downstream subset of the 60. Omit the obsolete 154-cell pathway from the current figure.

**Figure 4: absolute levels beside paired gains, separately for each expert.** The supplied prototype uses the finalized CSVs, with Expert 1 above Expert 2. Within each block, the rate plot is left and the paired difference plot right, aligned across pooled/D1–D5 rows. This is easier to scan at publication width than squeezing four narrow columns of labels into one row. Pooled rates and paired CIs are directly labeled. Rates use 0–100%; differences use −10 to +30 points, which includes every current interval. A −20 to +25 scale proposed by a worker would truncate D5's upper interval and is rejected.

Use blue circles for ARBITER and orange squares for Unassisted; use a neutral diamond for their difference. Expert identity is a facet heading, not a second color code. Keep the pooled row separated by a light rule, domains in canonical order, and zero visible on contrast axes. No significance shading, radar charts, decorative gradients or effect-ranked domain sorting. The full-cohort Published contrast fits in a clearly separated compact line; retain its absolute rates in accompanying text or supplement. Expert-to-expert agreement belongs in a short caption/context sentence, not a line that looks like a performance target. The present mockup establishes feasibility at full width; final journal export still needs caption integration and page proofing.

**Figure 5: a diagnostic overview with an honest zoom.** Use a domain-level paired signalling-answer overview for both experts, with five-level exact and collapsed agreement in adjacent panels. Then, if space permits, show the D3 and D5 questions that explain the uncertainty/gain, chosen because the domain profile directs attention there. Include all relevant questions in those selected domains, eligible n, and unfavorable results; do not select only large positive bars. The complete question display stays in the supplement. If the question detail makes Figure 5 unreadable, retain the full domain overview in main and move the zoom to a linked supplementary panel.

The key diagnostic check is D3 against Expert 1: five-level difference −10.3 points (−17.2 to −3.2), collapsed +8.5 (3.5–13.7), both on 165 paired components. Collapsing Y/PY and N/PN changes the question being asked; it cannot be sold as unqualified improvement. D5 collapsed gains are +11.3 points for Expert 1 but +3.7 (−0.3–7.4) for Expert 2. Denominators vary with eligibility and must be printed. Do not subtract source-specific absolute rates with different denominators to obtain a paired effect.

**Table 1: compact benchmark and reference context.** Rows for review/trial coverage and supplied-source availability; a small set of reference category counts if needed to make prevalence visible. Move detailed source-by-domain distributions to the supplement. No whole performance matrix here.

**Table 2: four primary/sensitivity rows.** Agreed choices: 53/60; Expert 1: 63/80; Expert 2: 61/80; all splits counted against ARBITER: 53/80. Show CIs and explain the denominator change. The sensitivity's 20 split cases are counted as losses by assumption; do not label them as observed “neither” choices. Keep the actual Expert 1 “neither” choices distinct. Do not duplicate these rows as a main forest plot.

**Table 3: three sections with three claims.** (A) Rule conformance: reproducibility of all 510 ARBITER domain outputs; 65/509 evaluable Unassisted cells with a rule break, comprising 26 contradictions and 39 required-question omissions. One baseline cell is unevaluable. (B) Record coverage: 1,538 active answers citing a passage/image; 1,407 text spans, 14 image records and 102 bundles checked. These denominators name different objects. “Not available” for the comparator is not zero supporting evidence. (C) Computation: runtime medians 7.6 versus 0.5 minutes, paired **mean** difference 11.0 minutes (8.4–14.1); API list-price-equivalent medians $3.78 versus $0.09, paired mean difference $3.68 ($3.61–$3.75). Separate median [IQR] and mean-difference [CI] columns. Human time, invoice costs and cost-effectiveness were not measured.

Rules-only label repair belongs in the supplement. It changes 26 recorded labels while retaining the answers and missingness. It is a consistency diagnostic, not an ablation of a causal component.

## 6. Typography, captions, precision and supplement

Target Figure 4 at approximately 170–180 mm width; do not shrink it into one column. The prototype is a seven-inch PDF with restrained strokes and approximately 8–10 pt text. Final production must inspect both full-width and printed-size proofs, grayscale and color, including legibility of interval ends. Use the same sans-serif family, source colors, shape convention, domain order and decimal precision in statistical figures. Preserve Figures 1–2's explicit labeling discipline rather than copying every illustrative color. Ensure plotted text remains text/vector in the final PDF where possible.

Percentages and percentage-point contrasts: one decimal; kappa: two; counts: integers; currency: two decimals; runtime: one decimal. Use one deterministic rounding policy across outputs. Exact values and denominators, not a rounded 100%, anchor procedural claims. Use an em dash for not applicable, “not available” for absent measurement, and explicit zero for an observed zero. Define them in notes. Do not use “%” as the unit for a percentage-point difference.

Caption template for Figure 4: “Exact agreement and paired differences between ARBITER and the same-model minimal-prompt comparator against each independent expert. Each domain contains 102 trial ratings; pooled estimates contain 510 domain ratings. Points and lines show estimates and 95% percentile intervals from 10,000 trial resamples within the 16 fixed reviews, preserving paired arms and within-trial domains. The lower line reports the separate full-cohort comparison against Published labels. Expert-to-expert agreement was 388/510 (76.1%); it is reference context, not a performance ceiling. Overall ratings are derived and reported separately.” Add full domain names in the final caption.

Supplement begins with a one-page claim-to-section map. Order: reproducibility/methods; full expert agreement and distributions; complete primary sensitivities; signalling diagnostics and eligibility; derived Overall/missingness; process/resources; prior work and reporting. Each section starts with a sentence explaining its purpose. Consolidate the duplicated independent/agreed-reference contrast tables. Keep all 16 reviews visible in any review-level display: undefined kappa should be marked undefined rather than silently dropping a review. No target-matching subgroups. No additional-model experiment in manuscript or supplement. Generic bootstrap footnotes must not be pasted onto qualitative literature tables.

## 7. Working abstract to test the hierarchy

**Objective:** To describe ARBITER, an inspectable workflow for AI-assisted risk-of-bias assessment, and evaluate its agreement with independent experts.

**Materials and Methods:** We compared the complete Sonnet workflow with the same model given a minimal prompt and identical files for 102 trials from 16 reviews. Two experts independently assessed 510 domain cells before viewing blinded labels. The formal primary endpoint measured agreement with their agreed choices among arm-discordant cells. Secondary comparisons used each expert separately. Confidence intervals resampled trials within reviews.

**Results:** Of 80 arm-discordant cells, experts agreed on 60 choices; ARBITER matched 53/60 (88.3%; 95% CI, 79.7–96.3). Across all cells, exact agreement was 72.7% versus 65.1% against Expert 1 and 84.9% versus 78.4% against Expert 2. Paired gains were 7.6 percentage points (95% CI, 5.1–10.2) and 6.5 (3.5–9.4). Gains were largest for selection of the reported result; agreement on missing outcome data varied substantially by expert. Comparisons with published labels did not show the same advantage. Procedural checks confirmed rule conformance and structural evidence linkage.

**Discussion:** The complete-workflow comparison does not isolate component effects. Structural checks do not establish whether evidence supports a judgment, and human workload was not measured.

**Conclusion:** ARBITER provides an inspectable assessment record and improved expert agreement in this benchmark. The available system supports further evaluation of judgment quality and human use.

This is a drafting test, not a finalized manuscript abstract. Verify the exact preferred-choice terminology and model identifier during implementation. Its job is to expose the numerical budget and preserve both the formal endpoint and the broader expert evidence.

## 8. Adjudication of the swarm and remaining limits

| Slice | Result accepted | Corrections or limits |
|---|---|---|
| Literature | Closest-system overlap, bounded contribution, source-presence/support distinction | Parent added material 2026 comparisons omitted from the worker's narrative; corrected RoB 1 versus RoB 2 reliability attribution. Do not claim global uniqueness or that these designs were previously absent. |
| Statistics | Headline counts, paired effects, eligibility, fixed-review inference, process/resource units | Retain the endpoint hierarchy and describe the actual evaluation. The worker's proposed chronology declarations are excluded by the author's direction. |
| Presentation | Absolute-plus-paired figure, separate expert references, one job per display | Worker transcribed Expert 2 D3/D5 rates incorrectly. Correct D3: 80/102 vs 70/102 (78.4% vs 68.6%); correct D5: 84/102 vs 72/102 (82.4% vs 70.6%). Correct plot range to include +27.5. Do not move Overall into the primary table. |

Directional severity strata are not the same as target-matching strata. The worker conflated them in one rationale. Removing their main-panel prominence is justified by narrative focus and post hoc selection, not by claiming they violate the author's prohibition on target matching. They can remain clearly labeled supporting analyses.

All three workers recorded the requested baseline and review method and completed their assigned slices. The parent checked key sources, current estimate exports, bootstrap code and dated plan excerpts, and rendered a prototype. No full pipeline rerun, fresh model experiment, formal new statistical test, exhaustive systematic literature search, or final DOCX pagination was performed. These are explicit limits of this design review.

Supporting files: [literature review](literature/report.md), [statistics review](statistics/report.md), [number ledger](statistics/number-ledger.csv), [presentation review](presentation/report.md), [Figure 4 PDF prototype](figure4-prototype.pdf), [prototype source](figure4-prototype.R). The consolidated corrections here take precedence over raw worker reports. The accepted rebuild brief remains the scope authority.
