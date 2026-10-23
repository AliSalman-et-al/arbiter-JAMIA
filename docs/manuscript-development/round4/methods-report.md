# Methods and Results revision report

Scientific baseline: `e29154fd730885de89ae52aabaa18e31044b676a`. Observed HEAD: `d8c9fe078a3bab8b0d78068338d7d3c1517968b7` (framing commit). The canonical manuscript and references at HEAD and in the working tree match their baseline blobs. The candidate extracts only the body Materials and methods and Results; the abstract's similarly named sections are excluded. Only `methods-candidate.md` and this report were written. No git mutations, delegated agents, canonical edits, new analyses or new citations were performed.

## Editorial purpose and source use

Audience: expert medical researchers familiar with RoB, systematic reviews, meta-analysis and statistics, with less AI/software expertise. The revision retains specialist vocabulary and the existing heading hierarchy, with selective explanation of software mechanics. It preserves the bounded complete-workflow comparison and does not claim component effects, semantic evidence validity, repeatability or reviewer benefit.

Read the complete canonical manuscript and references; round4 `editorial-contract.md` and `research-synthesis.md`; the local `clinical-research-writing/SKILL.md`, `CONTEXT.md`, `references/revision-and-coaching.md` and `references/statistics-and-claims.md`. Applied structure, clarity, flow and language checks, then rechecked structure. Research-synthesis exemplars informed register and paragraph function only; no additional literature claims or citations were imported into these sections.

Directly inspected the local HTML book passages: Schimel, *Writing Science*, §14.3.2 (concept names and shared schemas), §15.1 (audience-dependent distinction between technical terms and jargon), and §15.1.1 (selective grounding and sentence placement); Heard, *The Scientist's Guide to Writing*, chapter 19 passages “What the writer wants to say,” “Who the readers are,” and “Long Words, Short Words, and Jargon,” plus chapter 20's distinction between reducing content and reducing expression. Their application here is to retain precise terms familiar to this readership and remove elementary exposition, without sacrificing conditions for brevity.

Also inspected `analysis/provenance/rename-equivalence.md`, the eMethods source in `analysis/R/manuscript-supplement.R:382`, and `kit-sonnet-5.5/run_case.py:25`. The candidate explicitly distinguishes the evaluated `/rob2-assess` invocation from public `/arbiter-assess`. The evaluated revision remains referred to eMethods; that source identifies `2848c7926a2acc25402345a42be39d695a99861a`. The candidate retains public ARBITER 1.0.0 and its existing full-commit link. Command correspondence does not establish complete-release equivalence.

## Word counts

Counts use whitespace-delimited words, without Markdown heading lines for the primary body count. Inline Markdown, placeholders, citations and link targets remain in the counted text; these are reproducible editorial counts, not a claim of journal submission counting rules.

- Materials and methods: baseline 1644; candidate 1605; change -39 words.
- Results: baseline 560; candidate 551; change -9 words.
- Combined body: baseline 2204; candidate 2156; change -48 words (-2.2%).
- Including headings: Methods 1665 → 1626; Results 562 → 553; total 2227 → 2179.

## Information removed and why

Three elementary explanations were removed:

- The sentence listing the five standard RoB 2 domains. This repeats shared domain knowledge; the five-domain assessment structure, effect-of-assignment condition and D3/D5 result labels remain.
- The definitions of exact agreement and paired percentage-point differences. The named estimators, paired design, full-cell population and shared bootstrap weights remain. The sentence presenting weighted κ was consolidated into the outcome list; its ordinal weighting remains explicit.
- The sentence defining tokens as text units. Recorded token counts, fixed provider rates, cached inputs/additional-call reference, subscription use and distinction between list-price equivalents and expenditure remain.

Other edits condense expression or restore terminology without removing study information: “digital fingerprints” becomes “cryptographic hashes” with its identifying role retained; source provenance and algorithm conformance are named and operational checks remain. The assessment skill receives a brief explanation as packaged workflow instructions. No substantive numerical result, study condition, limitation, missing-method field or display/citation callout was removed. Operational definitions of the conditional primary endpoint and component matching are retained verbatim.

## Numerical and completeness comparison

Automated comparison of the extracted baseline and final candidate, followed by direct diff review, found:

- All 199 baseline digit-based numeric tokens retained in identical order and values. The candidate has 200 raw numeric tokens: the sole addition is the digit `2` in the documented command identifier `/rob2-assess`, not a new numerical observation. Removing that identifier digit yields exact sequence equality.
- Signed numeric expressions, decimal precision, fractions, ranges and percentages are identical in sequence after the same command-identifier exclusion. Thus the check preserves signs and denominators as well as isolated numbers. Spelled-out quantities were checked in the diff: up to seven, three exclusions, two experts, five domains, at most twice per phase, one unevaluable cell and the nonindependent sixth-domain qualification remain.
- All 7 heading lines retained exactly and in order: 2 H2 sections and 5 H3 subsections. Results has no added subheadings.
- All 4 complete pending-method fields retained verbatim, covering review selection/eligibility/exclusions; development, selection, benchmark overlap and version documentation; expert qualifications/training/instructions/targets; and original instructions/blank form. No missing fact was supplied by inference.
- All 4 citation groups retained exactly and in order: [7,8,11,12], [13], [1], [14,15]. The existing public-release link is unchanged.
- All 8 numbered display callouts retained exactly and in order: Figure 1, Figure 2, Figure 3, Table 1, Table 2, Figure 4, Figure 5, Table 3. Unnumbered supplement, supplementary benchmark table, eMethods, workbooks, reporting map and author-completion references also remain.

The substantive completeness review retained the following:

- Source retention, quotation extraction and image-page links; unchecked model-written image descriptions; interactive result approval versus unchanged benchmark acceptance; proposed/adopted ratings, evidence-supported override requirement and separate checks; AVATAR's illustrative status and absent dated plan.
- Ordered availability-dependent selection (105 trials, 16 reviews, up to seven, three exclusions, 102 analyzed), specified-result targeting and uncertainty relative to published labels, identical captured evidence, copied rather than freshly fetched documents, variable source availability and unrelated De Waal registry record.
- Minimal-prompt instructions and access restrictions; additional ARBITER guidance; complete-workflow attribution limit; prior structured-comparator distinction; exact model, effort and software identifiers; 12 and 14 October 2026 single runs; continuation limit; evaluated/public distinction and development placeholders.
- Both experts' frozen independent assessments before label exposure, no AI, possible access to extra sources, randomized source-blinded labels without rationales, revised ratings and possible changed answers, and separate analyses.
- Formal primary endpoint's arm-discordant population, agreed-choice denominator, label-equality credit including neither/ties, uninformative all-identical cells, individual-choice sensitivities, split losses without Unassisted wins, and explicit exclusion of reasoning/workflow preference claims.
- Secondary full-cohort expert comparisons; Published as a source rather than expert standard; supporting agreement analyses; five-level and collapsed signalling coding; trial/domain/question/component matching, named-component rule and exclusions; paired eligibility; Published metrics and All-Low κ suppression; missing predictions as disagreement.
- Algorithm-conformance checks against each arm's own answers; effect of assignment; rule-break/unevaluable definitions; recursive sensitivity; Overall escalation; coverage and provenance/file integrity checks; distinction from semantic support; computation definitions and cost qualifications.
- Derived Overall's worst-domain rule without optional escalation and lack of independence; 102-trial expert versus 81 observed/21 missing Published Overall population; directional partitions; rules-only recomputation preserving invalidity/missingness; fixed disagreement populations and tie credit; exploratory strata and offered-label anchoring.
- 10,000 trial-cluster resamples, seed 20261018, 16 fixed reviews with retained trial counts, both arms/domains together, paired weights, percentile CIs conditional on reviews/experts/runs, exclusion of new-review/expert/repeated-run variation, expert means, no P values/multiplicity adjustment, outcome status and reporting references.
- Every Results paragraph: prevalence and expert disagreement; conditional 80/60/20 and 53/60 primary result plus sensitivities; both full-cohort expert gains and κ values; D5 gains and divergent D3 expert agreement; unfavorable Published-reference contrast; adverse five-level D3 contrast and coding reversal; smaller D5 Expert 2 gain with null-spanning CI and paired denominators; source-specific denominator caveat and recomputation; all process counts and semantic limitation; longer runtime and higher list-price equivalents with IQRs and paired CIs.

The numerical check verifies textual preservation, not independent recalculation or source-data validation. No statistical analysis was rerun. Existing unresolved methodological facts remain unresolved.

Baseline extracted-section SHA-256 (UTF-8, initial H2 through final Results paragraph, one terminal newline): `416d206d4cdcf8b03c6aad1e8b38914c1d3664210a95fdb0a0b5d9069f5ba990`.
Candidate SHA-256 under the same text convention: `bb278405ed6ce206520d7345497c6a6dacfe1d74b1e03a0ead2d0a2f8654f16c`.
