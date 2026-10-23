# Independent literature challenge: nearest systems and claim boundaries

**Disposition: PASS with ISSUES.** Scientific baseline verified with `git show`: `e29154fd730885de89ae52aabaa18e31044b676a` (“Record verified round-three manuscript deployment”). Current checkout is `1830021de6e77cb0b4da32a7f8efa0017cbda2c6`. The committed baseline-to-HEAD changes touch only round-4 framing/provenance files (`decisions.tsv`, `baseline.json`, `editorial-contract.md`, `workflow.md`); the baseline manuscript and references were read directly from the specified commit. Existing uncommitted research materials were treated as leads, not independent corroboration. I wrote only this directory's `report.md` and `source-ledger.tsv`; no canonical manuscript edits or git mutations.

## Search and approach

Fresh searches on 23 October 2026 used exact-title and topic trails across ACL Anthology, PubMed/PMC, publisher pages, arXiv, JMIR and BMJ. Queries included `RoBGuard RoB 2 risk of bias evidence model evaluation`, `RoB 2 LLM algorithm conformance same model expert reference`, `risk of bias LLM evidence support signalling answers trial`, `RoB 2 prompt comparison independent reviewer reference`, and exact-title searches for Choi, LogiMed-RoB, Liang, Huang, Gandhi and Nyrhi. I followed the reference/citation links from the COLING RoBGuard proceedings record, the 2026 Choi pilot, the LogiMed-RoB preprint, and the RoB2 evidence-support paper. This is targeted independent citation searching, not a systematic or exhaustive search.

Primary full texts decisive to the interpretation were inspected: RoBGuard's COLING proceedings PDF; Choi et al.'s final journal HTML; LogiMed-RoB arXiv v1; and the full JMIR article on LLM-assisted RoB 2 assessment. The browser exposed the final Choi article text; a local full-text copy is already present at `/tmp/arbiter-r3-fulltexts/systems/choi.html` and `.txt`. RoBGuard and LogiMed-RoB copies are under `/tmp/arbiter-r4-fulltexts/systems/`; the JMIR article copy is under `/tmp/arbiter-r3-fulltexts/systems/huang.html` and `.txt`. Exact titles, identifiers, URLs, versions and access qualifications are in `source-ledger.tsv`. The DOI often attributed to RoBGuard in one round-4 note is constructed/unverified and returns 404: ACL Anthology lists no DOI, so this report uses its ACL record and does not invent a DOI.

## Ranked decisions for the manuscript

### 1. INCLUDE — Choi et al., 2026, narrowly in Introduction or Discussion

**Exact baseline claim affected:** Introduction, “Structured RoB 2 prompting has also been evaluated against human assessments, including checks of whether domain ratings follow from signalling answers” and “Their existence shifts the evaluation question toward the properties and performance of a specified implementation.” Discussion, “Choi and colleagues separately examined repeated outputs and algorithm conformance in a single-trial pilot. Their design and this multi-trial, single-run benchmark address complementary questions; ARBITER's results do not establish repeatability.”

The first claim needs a precise citation to this pilot, with its scale visible: one RCT, workshop entry by participants, 13/15/10 repeated tool runs, and one experienced reviewer reference. More importantly, the manuscript's “complementary questions” sentence should acknowledge the close overlap: the pilot tests run-to-run variation, expert agreement and conformance of judgments to each run's own answers, including two Gemini configurations using the same base model, same prompt and manual but different manual delivery. This is strong counterevidence to any suggestion that algorithm conformance or same-base-model workflow contrasts are new. The precise distinction is that ARBITER audits every retained domain output for executable rule conformance in a 102-trial paired benchmark, while Choi samples repeated configurations on one trial and compares them to one expert. Neither design establishes superiority across systems; do not rank their percentages.

The article itself avoids a cross-configuration leaderboard and explicitly says it characterizes variability and error patterns. Its limitations make the one-trial/workshop/one-reference context material. Keep the citations close to the distinction so readers do not mistake complementarity for non-overlap.

### 2. INCLUDE — RoBGuard, COLING 2025, as a nearest system/resource

**Exact baseline claim affected:** Introduction, “Earlier systems establish that evidence display and structured assessment are practical approaches…” and the transition “These approaches make different parts of an assessment available for examination.”

Add one short clause identifying RoBGuard as another RoB 2 system/resource using clinically informed question reformulation, multimodal document parsing and a multi-expert model framework, with RoB-Item and RoB-Domain datasets. It is peer-reviewed proceedings work, so omitting it leaves a material gap in the nearby-system account and makes any broad novelty language untenable. The source labels/rationales originate in existing review assessments; the paper did not assemble a new independent expert panel. Its item/domain accuracy results do not establish semantic support of every answer by its linked passage. Therefore it does not collapse ARBITER's narrower questions about a retained evidence-answer-rating record, the specified paired comparator and distinct structural checks.

Do not add its performance estimate beside ARBITER's as if benchmark populations, annotation provenance, target units and comparators matched. The relevant contribution here is existence and design, not a numeric comparison.

### 3. INCLUDE — LogiMed-RoB, arXiv 2026 v1, in Discussion only if space permits

**Exact baseline claim affected:** Discussion, “All 510 ARBITER domain outputs followed the executable rules, but the quoted evidence still requires interpretation”; also the sentence locating evidence-support evaluation as a next step.

This preprint is direct counterevidence to broad statements that RoB 2 hierarchical consistency is unexamined. Its RoB 2 track tests atomic answers, domain derivation and overall aggregation against existing review-derived assessment data. Its separate evidence-faithfulness track is RoB 1 and uses model/text overlap metrics; that is not human semantic adjudication of ARBITER's RoB 2 answer-evidence relations. A concise Discussion acknowledgment should distinguish the constructs: LogiMed-RoB evaluates model-level consistency across an RoB hierarchy; ARBITER's structural check verifies that its persisted output follows executable answer-to-rating rules. Neither semantic support nor the other system's accuracy is established by ARBITER's 510/510 conformance result.

Retain preprint status and v1 identity. The preprint's RoB 2 labels derive from existing assessments, and its reported experiment is a single run; it does not provide repeat-run variance. Do not echo the abstract's dramatic cross-model numerical claims in this manuscript.

### 4. INCLUDE ONLY IF THE INTRODUCTION NEEDS AN EXPLICIT SAME-MODEL COMPARATOR TRAIL — Xiong et al., 2026

**Exact baseline claim affected:** Introduction, “Same-model comparisons of direct and constrained prompts have also been studied with the earlier instrument.”

The existing sentence is useful to prevent readers from reading ARBITER's shared-model arms as a first design of its kind. Xiong is a peer-reviewed RoB 1 prompt comparison and supports only that narrow historical proposition. It should not be presented as a RoB 2 precedent or a comparator of complete evidence-processing workflows. The baseline already cites Xiong, so this is a wording/claim-boundary confirmation rather than a new citation recommendation.

### 5. EXCLUDE from the core narrative — Huang et al. 2025 JMIR and Nyrhi et al. 2026

**Exact baseline claim affected:** Discussion's distinction between fresh independent ratings and Published labels; general statements about what LLM agreement studies validate.

Both are useful counterevidence against treating review labels as a universal gold standard, but neither changes the exact nearest-system account enough to warrant additional citations in a compressed Introduction. Huang's study has model judgments compared to both review labels and reviewer assessments, with prompt construction and repeat evaluations; its source/reference construction and study population differ. Nyrhi is a multi-model validation against existing expert-generated assessments from RoB 1 reviews and published meta-analyses. The Nyrhi full-text capture was available through the other round-4 systems research; in this independent slice I verified its journal identity and citation trail, but do not treat the prior report as my own full-text inspection. Keep them as synthesis checks unless the final prose makes a general claim about the breadth of reference designs.

### 6. EXCLUDE — ROBUST-RCT and unrelated appraisal instruments

**Exact baseline claim affected:** None directly; only broadening beyond RoB 2.

The ROBUST-RCT feasibility study evaluates a distinct instrument. It should not be listed as a nearest RoB 2 system or used to strengthen a RoB 2-specific novelty/gap statement. Other broad AI appraisal or evidence-synthesis datasets also have different assessment constructs and should not be added solely to lengthen the prior-work paragraph.

## Priority claim repairs

1. **Introduction / system lineage:** cite RoBGuard after RobotReviewer/ROBOTO2, while preserving the difference between RoB 1 evidence extraction, interactive RoB 2 review and RoBGuard's review-derived item/domain resource. Avoid “first,” “novel,” or “unprecedented” claims about item-level assessment, evidence linking or human/model collaboration.
2. **Introduction / existing evaluation question:** keep the bounded question about this specified complete workflow and benchmark. Choi is a direct precedent for conformance and repeatability; Xiong supports prompt comparisons only for RoB 1. State the specific design difference rather than implying those constructs have not been studied.
3. **Discussion / executable rules:** state that 510/510 ARBITER outputs matched the executable rules, and that this verifies only the deterministic mapping of stored answers to ratings. Choi and LogiMed-RoB are strongest counterevidence to broad novelty around hierarchy/conformance; their constructs and validation designs differ.
4. **Discussion / evidence support:** retain the present caution that source-location/record-integrity checks do not show semantic support. Liang et al. is directly relevant but uses a second LLM to judge support; it is not independent human validation. RoBGuard's linked evidence and LogiMed-RoB's RoB 1 text-overlap track likewise do not supply independent human semantic validation for ARBITER's RoB 2 answer-evidence pairs.
5. **Discussion / references:** preserve separate independent expert ratings, forced-choice labels and Published labels. Review-derived labels and RoBGuard/LogiMed-RoB source assessments have different provenance from ARBITER's two blinded fresh expert ratings; none should be called a gold standard without qualification.

## Strongest counterevidence to the current framing

The strongest challenge is Choi et al.: a peer-reviewed, one-trial RoB 2 pilot explicitly measures run variability, conformance and expert agreement, and contains a same-base-model comparison that differs only in how guidance is delivered (context versus retrieval knowledge), under an identical prompt/manual. The current manuscript already cites it, but the “complementary” characterization should describe overlap as well as scale/design differences. The claim that ARBITER's results do not establish repeatability remains sound.

RoBGuard is the strongest omission in the short Introduction lineage: it is a peer-reviewed RoB 2 system plus item/domain resources, not a speculative preprint. Its review-derived labels and absence of independent semantic-support validation are equally important to state if using it to narrow the gap.

LogiMed-RoB most strongly challenges any expansive claim that rule hierarchy or evidence-related evaluation is untouched. Its status and construct differences prevent it from displacing the narrower ARBITER results: its evidence-faithfulness set concerns RoB 1 and overlap, and the RoB 2 hierarchy task uses previously recorded assessments. All papers use different samples, reference processes, targets and outputs; no cross-study performance ordering is warranted.

## Writing exemplars (paraphrased; do not copy)

1. **Choi et al., final journal HTML, Methods “Study Design and Data,” paragraphs on the three configurations and reference; Discussion, opening synthesis.** The authors identify the single trial and one expert before defining the three repeated configurations. They explicitly state that their aim is to characterize variability/error patterns rather than rank configurations, then keep configuration-specific behavior attached to its measurement. This is an especially relevant model for describing overlapping systems without turning unlike estimates into a league table. Locator: HTML sections “Study Design and Data” and “Discussion”; DOI 10.63528/jebp.2026.00011.
2. **Ji et al., RoBGuard, COLING 2025, §3 dataset construction and §4 experiments/conclusion, pp. 1261–1267, 1275–1277.** The paper's account separates the provenance and units of RoB-Item and RoB-Domain before reporting task-specific results. That is a useful example of making annotation provenance visible before readers interpret “accuracy.” For ARBITER, transfer the provenance-first structure, not its claims of effectiveness or system-ranking language. Locator: ACL Anthology PDF pages 1261–1267 and conclusion.
3. **Huang et al., LogiMed-RoB, arXiv v1, §3.3 and Table 2; Limitations, PDF pp. 4–5 and 9.** The paper separates the RoB 2 hierarchy track from the RoB 1 evidence-faithfulness track, naming each data source and unit, then limits interpretation of its single temperature-zero run. This is a strong technical-writing model for keeping conformance, evidence overlap and repeatability distinct. Locator: arXiv:2609.11185v1.

These exemplars use established methods terms without teaching RoB 2 to the reader. Their useful practices are operational specificity, visible provenance and explicit limits—not sentence templates.

## Remaining limitations

The search was targeted and its 2026 coverage depends on indexed records. No exhaustive database search was performed. The full text of Nyrhi was not independently reopened in this slice; statements about it are limited to verified metadata and its cited record here. Xiong was checked at publisher/PubMed record and abstract level, not full text. No new claim about any paper's numerical performance is used to compare studies. Primary access and limits are fully recorded in the source ledger.
