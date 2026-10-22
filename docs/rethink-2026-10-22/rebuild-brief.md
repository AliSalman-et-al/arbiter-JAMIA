# ARBITER manuscript rebuild brief

22 October 2026. Consolidates the author's decisions Q1–Q10 and subsequent direction to omit chronology/history declarations. The author confirmed shared understanding at Q11 and authorized implementation by GPT-6.1 Sol, using relevant Pstack skills efficiently. This is the approved editorial and analytical specification. Implementation status is tracked separately.

The subsequent three-worker literature/statistics/presentation review is consolidated in [the detailed manuscript blueprint](second-review/blueprint.md), with a data-backed [Figure 4 prototype](second-review/figure4-prototype.pdf). It retains Q1–Q10 while sharpening the literature position, paragraph jobs, numerical contracts, diagnostic display, and production design. Its parent corrections take precedence over the raw worker reports. In particular, same-model prompt comparisons and published-versus-fresh-human references have precedents; the novelty claim must concern this available workflow and its evaluation rather than exclusive features. Interpret the current bootstrap as trial resampling within fixed reviews.

## Purpose and intended reader impression

A JAMIA system-and-evaluation paper presenting an installable tool for evidence-review workflows, linked to https://github.com/AliSalman-et-al/ARBITER/. Readers should understand what ARBITER adds, how to inspect an assessment, the observed improvement over a same-model minimal-prompt comparator, and the judgments that remain difficult. Availability is part of the contribution; actual effects on reviewer workload, decisions and deployment are unmeasured.

The empirical claim concerns the complete Sonnet workflow in this benchmark. It includes its instructions, tool use and additional computation. The paper does not isolate a causal component effect, establish expert equivalence or generalize performance across models. Manuscript and supplement mention only the Sonnet workflow.

## OCAR and the writing books

**Opening:** Risk-of-bias judgments influence how evidence is interpreted. AI-assisted appraisal needs a basis that people can inspect and defend.

**Challenge:** A plausible final label does not reveal whether the relevant evidence was found, interpreted appropriately or translated consistently through RoB 2. Software can preserve sources and execute rules, but judgment quality still requires empirical evaluation. Published review labels offer a reference whose relationship to independent expert assessment must be understood.

**Action:** Present ARBITER's architecture and an end-to-end worked trace. Compare the complete Sonnet workflow with the same model given a minimal prompt and the same supplied files across 102 trials and 510 domain cells. Use two independent-first expert assessments, the formally designated primary forced-choice endpoint, process checks and computational-resource measurements.

**Resolution:** ARBITER makes the basis of an assessment inspectable and, in this benchmark, improves agreement with independent experts. The improvement varies by domain, and difficult judgments remain. Published-label comparisons give a different picture of performance. Procedural safeguards and empirical judgment quality are distinct parts of evaluating such a tool.

Schimel's role is to connect the resolution back to the opening problem. Heard's role is to require a scientific purpose for each result and display. Zinsser's role is to maintain one coherent paper and remove repetition. Apply these principles to the organization before polishing individual sentences. Do not end with a catalogue of favorable statistics or let limitations displace the actual contribution.

## Evidence hierarchy and claims

- Independent expert comparisons across all 510 domain cells carry the principal explanatory weight. Show both experts separately. Lead with absolute exact agreement and paired percentage-point differences; use linearly weighted kappa as complementary ordinal context. Keep category distributions and expert-to-expert agreement visible enough to interpret the estimates. Expert agreement is context, not a performance ceiling or an error-free standard.
- Forced choice retains its documented formal primary designation. Report the 53/60 result with its confidence interval and selection pathway: 80 arm-discordant cells, 60 with agreed choices, 20 with split choices. Core sensitivities include each expert separately and counting splits against ARBITER. Do not describe the primary share as population accuracy.
- Domain profiles explain the pooled improvement. D5 contains the largest observed gains; D3 shows substantial dependence on the expert reference. Both are central to interpretation.
- Preserve five-level and collapsed signalling-answer distinctions. Use paired eligible components for differences and print denominators. Source-specific absolute rates can use different eligible populations; their arithmetic difference is not automatically the paired effect.
- Derived Overall is secondary and exploratory. Preserve the distinction between all 102 trials and the 81 with observed Published Overall. Missing Published Overall labels remain excluded from those comparisons. Expert means, agreed-reference subsets, additional coefficients and binary analyses are supporting evidence.
- Process conformance, source occurrence and structural binding have their own denominators. They establish procedural properties, not semantic support or clinically correct judgments. Runtime and API list-price equivalents describe computational burden; do not infer human-time savings.
- Use the full domain cohort for Published-reference comparisons. Do not subset, stratify, filter or differentiate cases by published-label target matching. Acknowledge uncertainty about assessment targets qualitatively. Do not assert that disagreement proves Published labels wrong or that statistical significance against one reference and its absence against another proves a between-reference difference.

## Main displays

Target five figures and three tables. Retain a sixth figure only if needed to keep the central performance display legible. Each display must answer a distinct question; supplementary precision is preferable to an unreadable main display.

| Display | Reader's question | Required content |
|---|---|---|
| Figure 1, protected | How does the tool work? | Existing architecture artwork unchanged. Preserve the model/software distinction and the inspectable record. |
| Figure 2, protected | What does an assessment look like? | Existing AVATAR artwork unchanged. Present as an illustration; it is not a representative performance sample. |
| Figure 3, rebuilt | What did the evaluation compare? | Same-model paired design, independent-first expert sequence, 102 trials/510 cells, and separate conditional forced-choice branch. |
| Figure 4, rebuilt | How much did agreement improve, and what remains difficult? | Absolute domain agreement and paired improvements against both experts, pooled summary, uncertainty and expert agreement context. Include a compact full-cohort Published-reference comparison; move that comparison to a sixth figure if necessary for readability. |
| Figure 5, rebuilt | Which answers help explain the domain pattern? | A systematic diagnostic overview with both experts and five-level/collapsed matching distinguished. Focus explanatory detail on D5 and D3, while retaining the complete question-level results in the supplement. Avoid causal component language. |
| Table 1, rebuilt | What evidence was assessed? | Concise benchmark characteristics and supplied-source availability. Reference label distributions should be compact and complementary to Figure 4, with detailed breakdowns in the supplement. |
| Table 2, rebuilt | What was the formal primary result? | Agreed forced-choice endpoint and core sensitivities; explicit numerators, denominators, intervals and the role of split choices. Remove the duplicate standalone main forest plot. |
| Table 3, rebuilt | What procedural properties were observed, and what computation did they require? | Distinct sections for rule conformance, structural evidence/record verification, and resources. Keep units explicit; identify medians [IQR] versus paired mean differences. State what verification does not establish. |

Final figure numbers and first citations must agree. Main text states the pattern and its implication; avoid reciting every displayed estimate. Figure captions name the population, reference, metric and uncertainty. No unqualified accuracy labels. Tables must be understandable without navigating several other displays.

## Diagnostic discretion

The author delegated detailed diagnostic choices. Use the finalized full eligible independent-reference comparisons as the starting point. Present a broad overview before selecting explanatory questions. D5 and D3 are chosen because the domain results identify a major gain and a major uncertainty, respectively. Include unfavorable results and differences between exact and collapsed coding.

If a concrete disagreement example materially helps, choose it under a recorded rule and verify it against the stored answers and evidence. A favorable example cannot substitute for the systematic comparison. Figure 2 already illustrates an assessment, so additional case material should earn its space.

Rules-only recomputation belongs in supporting analyses. It corrects inconsistent final labels while leaving the recorded answers, invalid paths and missingness unchanged; it cannot isolate the rules engine's causal effect. Do not reuse the older HTML's selected-population loss-localization counts. Any additional diagnostic transformation must use the finalized data, retain provenance and be identified as exploratory.

## Supplement organization

Organize the supplement by the questions it supports, with concise introductions and a navigation map:

1. Reproducibility and methods: evaluated software/model version, prompts, inputs, algorithms, expert sequence, eligibility, inference and source/record checks.
2. Full agreement evidence: per-expert/domain results, paired contrasts, category distributions, reliability, confusion matrices and secondary metrics.
3. Primary endpoint and supporting analyses: complete sensitivities, severity/direction, agreed-reference results and descriptive post-exposure ratings, clearly separated by population.
4. Diagnostics: all signalling questions, five-level/collapsed comparisons, eligibility and parsing, rules-only recomputation and changed cells.
5. Derived Overall and missingness: all-trial and observed-label populations, validation differences and permitted escalation.
6. Process and resources: evidence binding, conformance, runtime, cost reconstruction and token reconciliation.
7. Prior work and reporting: qualified literature comparison with supporting sources; completed reporting map.

Consolidate duplicated rows and tables, especially the overlapping independent/agreed-reference contrast collections. Rewrite generic footnotes for the table they actually describe. The literature matrix is supplementary and must use clear feature definitions and resolved citations. No target-matching subgroup analyses or stratified displays are added. No mention of an alternative-model experiment appears in manuscript or supplement.

## Implementation and verification boundaries

Preserve raw inputs. Preserve Figure 1 and Figure 2 source artwork and output bytes. Necessary caption cross-references can be reconciled without redesigning them. Maintain the evaluated-version citation separately from the live repository link.

Use the finalized expert workbooks and current verified numerical exports; older `results.html` and `supplement.html` contain obsolete expert counts and populations. Rebuild both HTML and publication exports together so their figures, tables, captions and result sentences agree. This is presentation restructuring, with only explicitly justified diagnostic transformations, not a change to the endpoint definitions or bootstrap.

The author directed that chronology/history declarations be omitted from the manuscript and supplement. Explain the evaluation as performed: populations, expert sequence, endpoint definitions, statistical methods and interpretive limits. No chronology-reconciliation declaration is required for the rebuild.

Validation should verify protected artwork, unchanged retained numerical estimates, denominator handling, absence of target-matching differentiation, Sonnet-only reporting, consistent numbering and citations, and readable rendered displays. Run the existing appropriate pipeline checks after implementation. No new experimental runs are part of this brief.

Working title direction: **ARBITER: an auditable workflow for AI-assisted risk-of-bias assessment**. Exact title and abstract wording should follow the finished evidence hierarchy. The abstract should identify the tool, same-model comparator and independent experts, report both the formal primary endpoint and the all-cell agreement gains, and end with the bounded contribution.
