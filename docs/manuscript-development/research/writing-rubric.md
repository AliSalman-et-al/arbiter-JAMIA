# Manuscript writing rubric and story design

Research/design report, 23 October 2026. **Overall: ISSUES.** The evidence supports a bounded system-and-evaluation paper; the current manuscript is substantially aligned with it. Submission readiness remains **BLOCKED** by explicit author-completion fields. This report changes no manuscript, analysis, numerical export, or git state. It does not certify rendered Word or deployed Pages quality.

## Evidence contract

The intended readers are informatics researchers and evidence-synthesis practitioners deciding what an inspectable AI-assisted appraisal workflow provides and how to evaluate its judgments. The study is an offline, paired, same-model workflow benchmark, not a randomized human-use study or a test of a single software component.

The defensible core is: **ARBITER retained an inspectable RoB 2 assessment pathway and had greater agreement with each of two independent experts than a same-model minimal-prompt workflow in this benchmark; rule conformance and source binding establish separate procedural properties.** Prefer “had greater agreement” to an unqualified causal “improved judgment quality.”

Inspected numerical evidence:

- 102 trials from 16 fixed reviews; 510 D1–D5 cells, with both experts independently assessing every cell. Three unsupported designs were excluded. See [plan §§3–5](../../../ANALYSIS-PLAN.md), [glossary](../../../GLOSSARY.md), and [manuscript Results](../../manuscript/manuscript.md), lines 84–96.
- Formal primary result: 53/60 agreed forced choices favored ARBITER, 88% (95% CI, 80–96%); the selection pathway is 510 cells → 80 arm disagreements → 60 agreed choices, with 20 split choices. Split-loss sensitivity is 53/80 (66%). The primary CSV’s Consensus/ARBITER row gives count 53, n 60 and all 10,000 valid resamples: [primary-endpoint.csv](../../../analysis/output/tables/primary-endpoint.csv). This is conditional preference, not overall accuracy.
- Full-cohort expert agreement: 371/510 versus 332/510 for Expert 1; 433/510 versus 400/510 for Expert 2. Paired differences are 7.6 percentage points (95% CI, 5.1–10.2) and 6.5 (3.5–9.4). The exported contrasts are in [independent-differences.csv](../../../analysis/output/tables/independent-differences.csv); generated narrative is in [results-sentences.md](../../../analysis/output/manuscript/results-sentences.md).
- Counterweights must remain visible: Published-reference difference −1.8 points (−5.1 to 1.6); D3 ARBITER agreement 43/102 versus 80/102 across the two experts; expert D3 agreement 54/102. Five-level versus collapsed D3 signalling agreement reverses the direction of the paired contrast against Expert 1. These qualify the story rather than invalidate it.
- Process evidence: 510/510 reproducible ARBITER domain outputs; 65/509 evaluable Unassisted rule breaks; 1538 active required answers citing evidence; 1407 text spans, 14 image records, and 102 bundles meeting their respective checks. These denominators count different objects. Source occurrence/binding is not semantic support.
- Median runtime 7.6 versus 0.5 minutes and API list-price equivalents US$3.78 versus US$0.09 describe computation. Median runtime inputs are also visible in [process-summary.csv](../../../analysis/output/tables/process-summary.csv). Human checking time, adoption, harms and invoice costs were not measured.

The bootstrap implementation in [bootstrap.R](../../../analysis/R/bootstrap.R), `stratified_cluster_weights()` and `interval_table()`, retains trial clusters within reviews and uses percentile type-7 intervals; [win-share.R](../../../analysis/R/win-share.R), `win_share()`, filters discordant cells and then agreed choices and credits labels. I inspected these functions but did not rerun analyses or independently audit the raw workbooks/bundles. Confidence intervals are conditional on these reviews, experts and runs.

## Book-grounded rubric

These are editorial criteria, not a numerical scoring instrument. Book guidance is paraphrased from selected local full-text HTML passages, not abstract summaries. Chapter starting pages for Heard come from the inspected contents; no unverified page ranges are asserted.

1. **One question and one bounded answer — PASS with a focus issue.** A reader should recover the problem, question and answer from the opening, objective and conclusion alone. Schimel [chapter 4, §§4.1–4.3][S4] distinguishes story functions from IMRaD headings; [chapter 7, §§7.1–7.2][S7] makes the knowledge question primary to objectives. Heard [chapter 7, “Finding and Telling Your Story,” starting p 57][H7] prioritizes the reader’s question over reporting everything the writer did. The current Objective (line 45) enumerates the workflow and endpoints but leaves the knowledge question less explicit than the design. State the question before listing the evaluation components.

2. **A precise niche rather than a generic AI promise — PASS/ISSUES.** Schimel chapters 5–7, especially §6.3, distinguish an introduction from a literature review. Heard chapter 10, “The Introduction Section,” starting p 84, uses territory → niche → occupation. Current Background (lines 37–41) starts with an appraisal problem and distinguishes procedure from judgment. Its middle paragraph nevertheless names several studies sequentially. Synthesize them by contribution: evidence display/interaction, answer-derived rules, and independent-reference evaluation. Narrow novelty to the available implementation and this evaluation.

3. **Endpoint hierarchy and population made legible — PASS.** Heard [chapter 12, “The Results Section,” starting p 99][H12], opening and “Methods, Results, and Discussion,” calls for story-relevant selection while preserving section functions. The current Results give flow, primary endpoint, then full-cohort agreement; the 80-to-60 restriction is explicit. Keep “formal primary” adjacent to 53/60 and identify full-cohort agreement as secondary even if it carries much of the reader’s practical interpretation. Do not retrospectively relabel it primary.

4. **Magnitude, precision and contradictory evidence — PASS.** The clinical-writing reference “Statistics and Claims,” §§Effect Before Significance, Subgroups/Models/Missing Data, and Claim Calibration, supplies the statistical criteria; the books do not substitute for statistical authority. Current prose reports paired percentage-point differences and intervals without P values, retains unfavorable Published-reference evidence, and avoids inferring domain-effect differences from separate intervals (lines 90–106). Preserve both experts rather than selecting the more favorable reference. Derived Overall must retain 102 versus 81 trial denominators and exploratory status.

5. **Separate what was checked from what was inferred — PASS.** Heard [chapter 13, “The Discussion Section,” starting p 120][H13], opening discussion of inference and hedging, requires interpretation within the evidence. Current process paragraph (line 94) and Discussion (line 108) explicitly distinguish structural verification from support. Retain that distinction in abstract, captions, Word and Pages. Neither rules-only recomputation nor signalling-answer patterns identifies the causal contribution of the rule engine.

6. **Each paragraph performs one reader-facing move — ISSUES.** Schimel chapters 10–13 cover internal arcs, paragraphs and topic-to-stress flow; Zinsser [chapter 8, “Unity”][Z8] asks the writer to choose a coherent point and scope. The independent-agreement paragraph (line 90) combines pooled agreement, κ, D5, D3, expert reliability context and Published comparison. Organize around one pooled finding, then one domain/reference qualification; let displays carry repeated exact values. The runtime paragraph’s supplement inventory and Overall denominator explanation (line 96) interrupt its computation story.

7. **Plain wording with technical precision — PASS/ISSUES.** Zinsser [chapter 2, “Simplicity”][Z2], [chapter 3, “Clutter”][Z3], and [chapter 15, “Science and Technology”][Z15] support removing inflated wording and explaining technical sequences from the reader’s starting knowledge. Use glossary labels consistently. “Formal conditional forced-choice endpoint,” “source binding” and “paired components” need plain first-use explanations. These concepts are necessary; repeated compressed labels are not. Preserve distinctions among independent rating, forced choice and revised rating.

8. **Displays earn their place and agree across formats — design PASS; rendered quality NOT ASSESSED.** Heard chapter 12’s quantitative-presentation discussion supports choosing graphics/tables by communicative job. Current [legend code](../../../analysis/R/manuscript-legends.R), `figure_legend_sections()`, gives separate jobs to architecture, illustrative trace, evaluation flow, expert agreement and signalling diagnostics. Keep AVATAR explicitly illustrative. In each display define units, reference, denominator, interval and paired versus absolute quantities. A JAMA-inspired visual style is an author preference; JAMIA’s submission rules govern the manuscript.

9. **Limitations calibrate early; the ending resolves — ISSUES.** Schimel [chapter 18, §§18.1–18.3][S18] recommends exposing constraints early and bounding the conclusion; [chapter 9, §§9.1–9.3][S9] treats resolution as the return to the original question. Zinsser [chapter 9, “The Lead and the Ending”][Z9] supports an ending that completes rather than repeats. Comparator and component limits are already in Methods, a strength. The final sentence (line 114) ends on continued evaluation. Put that boundary earlier and finish on the earned contribution: inspectable assessment records with measured, reference-dependent agreement in this benchmark. This is an editorial direction, not proposed replacement prose.

10. **Revise structure before polishing — ISSUES/actionable.** Schimel [chapter 17, §§17.1–17.3][S17] gives Structure → Clarity → Flow → Language; Heard chapter 21, “Self-Revision,” starting p 193, distinguishes revision from merely having a complete draft. Lock the story choice below, streamline paragraph jobs, then apply typography and final cross-format checks. Visual polish cannot resolve missing study disclosures.

## Diagnosis of the current manuscript

**Story as written:** an available, auditable workflow separates model interpretation from software checks and performs better against two fresh expert references than a same-model minimal prompt, with remaining domain/reference uncertainty.

The highest-leverage problem is narrative competition, not overclaiming: system design, conditional preference and independent-reference agreement all seek headline space. The paper already avoids the major errors—“ground truth,” component attribution, human-efficiency claims and quotation-support conflation. Preserve those safeguards while reducing repeated caveats and methodological self-explanation in Results.

Specific issues to resolve before line editing:

- **Objective versus question:** define the uncertainty that the combined system/evaluation answers, then state the two-arm approach (lines 43–45).
- **Placement:** proposed/adopted rating checks and no recorded overrides are partly results inside System design (line 54); distinguish the checking procedure from its observed result. The Results’ statement about why All-Low agreement must be interpreted carefully (line 86) and its explanation of what collapsing “means” (line 92) could be shortened to observations, with implications reserved for Discussion.
- **Provenance completeness:** Methods names model, effort, harness and commit but omits run dates explicitly available in the inspected run READMEs: ARBITER 12 October and Unassisted 14 October 2026. The raw ARBITER README uses an earlier internal commit; the plan §8 and DEVIATIONS entry 2 explicitly identify the public evaluated version. Preserve that provenance explanation rather than silently equating the two commit strings.
- **Plan versus final package:** plan §7 retains a six-figure/four-table description, including a different Figure 5/6 allocation. Current manuscript front matter, `results.qmd` loops and current legend functions specify five figures/three tables. Reconcile this as a documented presentation change; it is not evidence of an estimand change.
- **Submission BLOCKED:** author names/affiliations, expert qualifications/training (line 66), AI-use details, funding, conflicts, contributions, ethics/consent determination, registration status and archival dataset citation remain visibly incomplete (lines 7, 120–140). Do not infer approval, exemption, no funding or no conflict from missing text.

## Two distinct story architectures

### A. System contribution with bounded empirical validation — recommended

**Question:** What assessment pathway can an available RoB 2 workflow make inspectable, and how do its judgments compare with a defined same-model alternative?

**Core claim:** The complete workflow produced inspectable, rule-conformant assessment records and greater agreement with each independent expert in this benchmark. Its safeguards make records reviewable; their effect on human review remains unmeasured.

Structure:

1. Background: judgments compress evidence interpretation and rule application; reviewers need the pathway behind the label. Existing evidence-assisted systems establish the lineage; the gap is this implementation’s inspectability and measured behavior under a defined contrast.
2. Methods: architecture and retained record → paired benchmark/input parity and comparator → frozen independent ratings and conditional forced choice → distinct agreement/process/resource estimands.
3. Results: cohort/reference context → formal primary preference with selection pathway → full-cohort agreement and domain/reference qualifications → procedural checks → computation. Architecture and illustrative trace explain the artifact, not its typical performance.
4. Discussion: jointly interpret the available record and observed agreement; compare prior systems by function; explain reference/coding dependence; delimit component, semantic-support and human-use claims; close on the bounded available contribution.

**Fit and costs:** Best matches plan §1 and JAMIA’s Research and Applications audience. Readers learn what the tool provides and how much confidence this benchmark warrants. The risk is a feature catalogue; control it with one review task and distinct display jobs. Retain the existing five-figure/three-table architecture unless legibility requires an authorized change.

### B. Evaluation and reference dependence, with the system as the test case

**Question:** How does the apparent performance of the same paired RoB 2 workflows change when judged against independent experts, offered-label preference and Published labels?

**Core claim:** ARBITER’s agreement advantage over the minimal-prompt comparator was visible against each expert, while the Published-reference contrast was small and uncertain; reference and answer coding materially affect the interpretation of these outputs. This does not show that Published labels are wrong or establish a universally better reference.

Structure:

1. Background: an agreement percentage is incomplete without its reference, assessment target and population. Introduce ARBITER as a concrete paired comparison through which to examine this problem.
2. Methods: evaluation/reference design first → target matching and full-cohort independent assessment → workflow/comparator details → endpoint hierarchy, coding and clustered uncertainty. Keep the formal primary endpoint explicit.
3. Results: reference distributions and expert reliability → formal primary preference → adjacent expert-reference and Published-reference contrasts → D3/D5 and five-level/collapsed diagnostics → procedural checks and computational burden. Move deeper architecture/trace detail to supplementary explanation if it obscures the reference argument.
4. Discussion: distinguish preference, agreement and procedural validity; explain why the reference changes the interpretation; use the system as a worked evaluation example; close on what this benchmark establishes about the two workflows.

**Fit and costs:** Stronger for readers designing evaluations; gives the quiet contradictions a clear organizing role. Weaker fit to the declared system/auditability framing and risks promoting secondary/exploratory diagnostics into the central inferential claim. It would require substantive reframing, not merely moving paragraphs. Do not claim a general validation of reference selection or a new causal explanation.

**Choice:** Use A for the submission manuscript. Use B as a pressure test: if A cannot keep its Published-reference result, D3 variability and coding reversal visible, its system-success story has become too broad. The reader payoff is a usable understanding of the record and the benchmark, not an assurance of autonomous correctness.

## Journal and literature checks: access and limits

External pages were inspected on 23 October 2026. These checks are focused, not an exhaustive verification of all 23 manuscript references.

- **Official full guidance:** [JAMIA Instructions to Authors](https://academic.oup.com/jamia/pages/General_Instructions), “Research and Applications” and “Data Archiving.” Research and Applications covers informatics formulation/implementation/evaluation; limits are 4000 words, 250-word structured abstract, 4 tables and 6 figures. Required abstract headings match the current draft. The page requests double spacing, a Data Availability Statement, repeatable archived analyses and dataset citations with identifiers. Five figures/three tables fit; final counts, declarations, archive and rendering still need verification. JAMA styling should not replace these requirements.
- **Full-text passage inspected:** Hevia et al., ROBOTO2, [DOI 10.18653/v1/2025.emnlp-demos.2](https://doi.org/10.18653/v1/2025.emnlp-demos.2), [paper PDF](https://aclanthology.org/2025.emnlp-demos.2.pdf), printed p 14, workflow paragraphs “Collecting user feedback” and “Domain-level and overall judgments.” These explicitly describe retaining original/edited responses and implementing RoB 2 flowchart logic. They preclude novelty claims for evidence-linked interaction or executable rules alone. This conclusion uses the full-text body, not only the abstract.
- **Full-text passages inspected:** Huang et al., [DOI 10.2196/70450](https://doi.org/10.2196/70450), [JMIR full text](https://www.jmir.org/2025/1/e70450/), Methods “Prompt Construction” and “Statistical Analysis,” Results Table 4, and Discussion. Structured prompting and algorithm-derived judgments are precedents. Its post hoc recalculation is not this study’s separate same-model complete-workflow arm. No cross-study performance ranking follows.
- **Access-limited check:** Marshall et al., [DOI 10.1093/jamia/ocv044](https://doi.org/10.1093/jamia/ocv044), [PMC record](https://pmc.ncbi.nlm.nih.gov/articles/PMC4713900/). Front matter was retrieved, but the body follow-up hit a recaptcha; the OUP URL failed. I do not count this as a fresh full-text review. The local [prior-work notes](../../../analysis/data-curated/prior-work-comparison-notes.md), section 0, contain a previous full-text evidence ledger, a secondary research aid rather than my independent verification.
- **Local bibliography inspected, external claims not reverified here:** [references.md](../../manuscript/references.md), entries 1–23. The local curated comparison notes and condensed CSV were inspected as research context; their stated full-text access is their authors’ provenance, not mine. This report does not convert any abstract-only or uninspected study into full-text evidence.

## Handoff acceptance criteria

PASS when the revised manuscript has one recoverable question, its chosen structure preserves primary/secondary/exploratory distinctions, every headline statistic carries its population/reference, and adverse or ambiguous evidence remains visible. Resolve the author fields and presentation-plan discrepancy before calling it submission-ready. Word and Pages should use the same bounded story and numerical sources; `analysis/results.qmd` currently assembles generated results, five figures and three editable-table downloads rather than the full manuscript. A complete manuscript on Pages would require an explicit publishing artifact, followed by rendered checks. No such artifact was created or inspected by this research task.

## Local full-text book pointers

[S4]: </home/ali/Documents/Code/skills/book-references/Schimel Joshua/Writing Science_ How to Write Papers t Cited and Proposals That Get Funded/index.html#calibre_link-11>
[S7]: </home/ali/Documents/Code/skills/book-references/Schimel Joshua/Writing Science_ How to Write Papers t Cited and Proposals That Get Funded/index.html#calibre_link-14>
[S9]: </home/ali/Documents/Code/skills/book-references/Schimel Joshua/Writing Science_ How to Write Papers t Cited and Proposals That Get Funded/index.html#calibre_link-16>
[S17]: </home/ali/Documents/Code/skills/book-references/Schimel Joshua/Writing Science_ How to Write Papers t Cited and Proposals That Get Funded/index.html#calibre_link-24>
[S18]: </home/ali/Documents/Code/skills/book-references/Schimel Joshua/Writing Science_ How to Write Papers t Cited and Proposals That Get Funded/index.html#calibre_link-25>
[H7]: </home/ali/Documents/Code/skills/book-references/Heard,hen B_/Scientist's Guide to Writing_ How to Wr Throughout Your Scientific Career, The/index.html#calibre_link-158>
[H12]: </home/ali/Documents/Code/skills/book-references/Heard,hen B_/Scientist's Guide to Writing_ How to Wr Throughout Your Scientific Career, The/index.html#calibre_link-359>
[H13]: </home/ali/Documents/Code/skills/book-references/Heard,hen B_/Scientist's Guide to Writing_ How to Wr Throughout Your Scientific Career, The/index.html#calibre_link-258>
[Z2]: </home/ali/Documents/Code/skills/book-references/ZinsserWilliam/On Writing Well, 30th Anniversary Edi Informal Guide to Writing Nonfiction/index.html#calibre_link-120>
[Z3]: </home/ali/Documents/Code/skills/book-references/ZinsserWilliam/On Writing Well, 30th Anniversary Edi Informal Guide to Writing Nonfiction/index.html#calibre_link-121>
[Z8]: </home/ali/Documents/Code/skills/book-references/ZinsserWilliam/On Writing Well, 30th Anniversary Edi Informal Guide to Writing Nonfiction/index.html#calibre_link-128>
[Z9]: </home/ali/Documents/Code/skills/book-references/ZinsserWilliam/On Writing Well, 30th Anniversary Edi Informal Guide to Writing Nonfiction/index.html#calibre_link-129>
[Z15]: </home/ali/Documents/Code/skills/book-references/ZinsserWilliam/On Writing Well, 30th Anniversary Edi Informal Guide to Writing Nonfiction/index.html#calibre_link-137>

Skill sources inspected: [SKILL.md](/home/ali/Documents/Code/skills/clinical-research-writing/SKILL.md), CONTEXT.md, and references/manuscript-workflow.md, statistics-and-claims.md, revision-and-coaching.md, plus the limitations/response/cover-letter passages of formats-and-examples.md. Their evidence-integrity and story-contract rules informed this diagnosis. No manuscript rewrite is included.
