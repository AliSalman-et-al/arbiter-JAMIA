# Submission-manuscript revision report

23 October 2026. Scope: substantive editorial revision of `docs/manuscript/manuscript.md`, citation-order maintenance in `docs/manuscript/references.md`, and this report. No publishing code, generated artifacts, analyses, raw/derived data or git state was changed; no commit was made. The draft is ready for parent editorial review, with author-completion fields still pending.

## Argument and substantive changes

The manuscript now follows the chosen system-and-evaluation argument: reviewers need the basis of an appraisal; ARBITER preserves that pathway; its complete workflow had greater agreement with each independent expert in this benchmark; procedural checks and judgment agreement establish different properties. The 22 October rebuild brief/final acceptance and current story contract govern the revision. The older Round 16 title/abstract restoration recommendations in `research/journal.md` were not followed.

- Retained the accepted title, every existing heading and Methods subheading, five figures/three tables, and their initial-citation order. Named the supplied author as Ali Salman, MBBS, with affiliations/contact details and complete-author-list confirmation visibly pending.
- Rewrote Background as a synthesis of evidence display, structured assessment and human-reference evaluation rather than an author-by-author catalogue. The Objective now poses the inspectability and same-model comparison questions directly.
- Reorganized System design around the division between model interpretation and software checks, the retained record, and the illustrative AVATAR trace. Distinguished proposed ratings, recorded overrides and adopted outputs without claiming semantic correctness.
- Added verified ordered/availability-dependent sampling and the source-set flow: up to seven available in-set trials per review in review-table order; next-in-order replacements for unavailable reports; 105 trials from 16 reviews minus three unsupported designs leaves 102. This describes the selection rule without claiming random or representative sampling.
- Added verified run dates: ARBITER on 12 October 2026 and Unassisted on 14 October 2026. Kept the evaluated public software commit distinct from the live installable repository.
- Recast Methods into reader-facing paragraphs explaining input parity, different instructions/tools, the independent-rating → blinded label choice → revised-rating sequence, the formal conditional primary endpoint, all-cell secondary agreement, process/resource outcomes and conditional bootstrap uncertainty. Retained important missingness, paired-eligibility, Overall-denominator and exploratory-analysis distinctions; technical detail remains referenced to eMethods.
- Split the formerly crowded all-cell Results paragraph into pooled expert agreement and domain/reference findings. Preserved 53/60 with 80 disagreements, 60 agreed choices and 20 splits; 7/60 and the sensitivity counts; both experts' all-cell counts/gains; D5 gains; D3 expert dependence and the unfavorable five-level coding result; the Published-reference difference; process denominators; and computation estimates. Removed interpretation and the long supplement inventory from Results.
- Rebuilt Discussion around the combined contribution, a concrete inspection action, prior-system context, domain/coding dependence, reference dependence and one consolidated design/generalization paragraph. The D3 negative five-level versus positive collapsed contrast is explained rather than buried. The AVATAR example is explicitly illustrative. The conclusion ends on the supported available workflow and measured agreement, without claims of component causation or human benefit.
- Replaced causal-sounding “improved agreement” conclusions with “had greater agreement.” Kept the distinction between source occurrence/binding and semantic support, and between computational cost and unmeasured human workload.
- Updated the AI disclosure to OpenAI GPT-6-Astra, GPT-6.1-Sol and GPT-6-Luna via T3 Code for research/drafting/editorial checks in this revision. It explicitly leaves final author review/approval/accountability and previous assistance unconfirmed; no version dates were invented.

## Counts and verification

Command: `python3 docs/manuscript/verify-numbers.py` — **PASS** after citation renumbering.

The script reports 284 numerical tokens: 176 output-traced, 108 classified as non-result/editorial, zero untraced. Headline checks, prohibited-word checks, reference membership/first-use checks and display-order checks pass. Initial main-display citations remain Figure 1, Figure 2, Figure 3, Table 1, Table 2, Figure 4, Figure 5, Table 3. No checker or scientific check was changed. The initial check identified only the reordered first occurrence of references 22 and 23; the bibliography and callouts were renumbered consistently and the rerun passed.

Final whitespace-word counts, excluding headings/numeric citation callouts under the existing script convention:

- Abstract: **218/250**.
- Background and significance: 277.
- Objective: 48.
- Materials and methods: 1275.
- Results: 490.
- Discussion: 672, including the 58-word Conclusion.
- Main text: **2762**, below the preferred 3500 and JAMIA 4000 limits.
- Back matter: 208, excluded from main text.

The numerical checker establishes traceability and protected headline consistency, not complete semantic validity. Sampling facts and run dates were checked directly against provenance sources rather than inferred from a numerical token match. Publication assembly and rendered Word/PDF/HTML verification remain the parent's work; generated artifacts were deliberately not rebuilt.

## Citation ledger

No references were added or deleted; all 23 existing references remain cited. New bibliography entries: **none**. The substantive literature claims remain within the inspected local literature ledgers and existing manuscript claims.

Because the concrete inspection paragraph now precedes the human–AI collaboration paragraph, Liu et al. (generative-search citation verification) moves from reference 23 to **22**, and Li et al. (human–AI collaboration) moves from reference 22 to **23**. Their entries and manuscript callouts were changed together; all other numbers are unchanged. No citation was added merely to increase coverage or count.

The Joseph *RoB2-Evaluator* preprint was **not added**. `docs/manuscript-development/research/fulltext.md` was absent when checked, and I did not independently inspect the full source. The local `literature.md` synopsis alone was not used to meet the task's stricter full-text gate. The parent can add and explicitly label the preprint after the required verification, then renumber subsequent references. No novel-system or first-system claim depends on its omission.

## Provenance and source ambiguities

- Sampling: `rob2-meta-benchmark-set/README-FOR-ALI.md`, opening selection statement and coverage table, directly establish the ordered/availability-dependent rule and 105-trial/16-review source set. The manuscript does not invent a probabilistic sampling rationale, a power calculation or a general definition of “in-set” beyond the source record.
- Run dates: `kit-sonnet-5.5/README.md` and `no-kit-sonnet-5.5/README.md` establish the two dates. Their historical headline summaries include the 105-trial population, so those summaries were not substituted for finalized 102-trial estimates.
- Software identity: the raw ARBITER run README names the earlier internal commit `2848c79`; `analysis/DEVIATIONS.md` item 2 and `ANALYSIS-PLAN.md` identify ARBITER 1.0.0/public commit `2f549ae30f056ff441ea61a04b719968716f2219` as the evaluated public version. The manuscript retains that accepted public identity and adds only the reliably sourced run date, without asserting byte identity between the historical and public commits or adding a chronology-reconciliation narrative.
- The source set's registry/acquisition counts differ between run documentation contexts. No new acquisition counts were introduced. The already acknowledged unrelated De Waal registry record remains explicit, and input parity does not imply relevant or complete inputs.
- Published-label target uncertainty remains qualitative; there is no target-matching subgroup/filter or claim that disagreement proves Published labels wrong.
- The source research journal review contains superseded title/abstract advice. Its author-completion and submission-format concerns remain pertinent; its restoration advice does not override the accepted story contract.

## Author-dependent completion

Still pending: department/institution/city/country, corresponding-author postal address/email/telephone, complete author list/order, expert qualifications/experience/training, acknowledgments, funding/funder role, conflicts including relationships to ARBITER, CRediT roles, final author approval/accountability, ethics/consent determination for the expert component, registration status, patient/public involvement, complete AI-use confirmation and matching cover-letter disclosure, archival DOI and dataset citation. The existing prospective PDF/data-availability language also needs author confirmation before submission. No missing declaration has been converted into an assertion of no funding, no conflict, exemption or approval.
