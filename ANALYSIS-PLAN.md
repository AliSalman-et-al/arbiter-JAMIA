# ARBITER JAMIA analysis plan

Current reporting and computational contract, reduced on 26 October 2026 after analysis with author approval. The author selected a focused system-and-evaluation report and authorized removal of retired analyses, code and generated files. This is a reporting amendment, not prospective specification. There is no formal primary/secondary or confirmatory hierarchy. The complete earlier analysis is recoverable at Git revision 54645d75e7a8b32bbf09968893e7be45faa4cab4. Historical source snapshots also remain in analysis/provenance.

## Question and scope

What assessment record does ARBITER preserve, and how do its ratings compare with published review labels and two independent experts? The comparison concerns complete workflows. It cannot isolate software, prompting or computation effects. Source occurrence and structural checks do not establish semantic support, and computational runtime does not measure reviewer effort.

Report Published agreement first, then each expert separately. Exact agreement precedes weighted agreement. Keep domain variation, expert disagreement, label prevalence and unfavorable results visible. Conditional label choices and signalling comparisons provide supporting evidence.

## Inputs and population

Inputs are read-only. Both reported Sonnet arms assessed identical supplied trial evidence. Labels and signalling answers come from kit-sonnet-5.5 and no-kit-sonnet-5.5. Published labels come from the source reviews and benchmark records. Independent expert ratings and subsequent blinded choices come from human-adjudication/adjudication-with-explanations-1.xlsx and -2.xlsx.

The analysis set contains 102 trials from 16 purposively selected reviews, with five RoB 2 domains per trial and 510 cells per source. atwine-2020, haney-2004 and herrmann-2016 remain excluded as unsupported designs. The author confirms Atwine's exclusion despite its incorrect stored model classification; no alternative design subtype is established. Missing model predictions count as disagreement.

The experts assessed every cell without AI and froze their independent ratings and signalling answers before seeing the offered labels. The author confirms identical supplied trial materials, task targets and access to RoB 2 guidance. Individual experience, training/calibration and multi-outcome conventions remain incompletely documented. Later choices and revisions cannot substitute for independent ratings.

The benchmark was not used in development, according to the author. Bounded checks of the retained ten-trial development corpus do not establish an exhaustive exposure history. Sampling dates, ranking records and complete development/version-freeze documentation remain unavailable or pending. Do not infer those facts from the present reporting order.

## Retained agreement analyses

1. Published reference. Compare ARBITER and Unassisted with Published using exact agreement and linearly weighted Cohen's kappa, pooled and in each domain. Report the paired ARBITER minus Unassisted difference. The All-Low rule provides prevalence context; suppress its undefined kappa.
2. Independent references. Compare ARBITER, Unassisted and Published separately with Expert 1 and Expert 2, pooled and by domain. Retain exact agreement, weighted kappa and paired ARBITER minus Unassisted differences. No expert average or agreed-reference restriction is reported.
3. Reference context. Report expert-to-expert exact agreement and weighted kappa, pooled and by domain, and pooled Low/Some concerns/High counts for each source. Expert agreement is context, not a mathematical performance ceiling or error-free reference.

## Supporting analyses

Conditional blinded-label choices retain cells where the arms differ. The agreed-choice estimate further requires equal expert choices. Credit follows label equality, not the selected source letter. Report 53/60 alongside the 80 arm disagreements and 20 split choices. Sensitivities use each expert across all arm disagreements and count splits against ARBITER without assigning Unassisted wins. This measures conditional label matches, not accuracy or endorsement of reasoning.

Signalling analyses retain pooled and domain absolute summaries and complete paired question results against each expert. Five-level coding distinguishes yes, probably yes, probably no, no and no information. Collapsed coding combines yes/probably yes and no/probably no, retaining no information. Match trial, domain, official question and explicit component. Do not broadcast scalar answers across named outcomes. Missing, inactive, inapplicable, unmatched and unresolved answers are excluded. Report source-specific counts and paired intersections with their own denominators. Retain both codings, including unfavorable, sparse and zero-denominator question rows. The stored group key Overall means pooled signalling answers, not a sixth domain or a derived expert Overall rating.

Retain pooled category-disagreement matrices against each expert for ARBITER and Unassisted, including missing predictions. These reference disagreements do not establish clinical errors. They replace parallel binary metric grids in the report.

Two compact exploratory checks bound interpretation. Derived expert Overall is the worst of each expert's five independent domain ratings, without optional escalation. Compare both recorded arm Overall ratings with each expert separately on 102 trials, and show expert agreement. This is not an independently rated sixth domain. Do not add Published's different observed-Overall subset. Rules-only recomputation replaces the 26 contradictory Unassisted labels with the ratings implied by that arm's own answers, leaving invalid paths and missingness unchanged. Keep only pooled before/after expert agreement and the changed-cell audit list. This post hoc arithmetic check is not a causal component comparison.

## Process and resources

Apply official RoB 2 algorithms to each arm's own answers, using effect of assignment in D2. Separate contradictions, required-question omissions and unevaluable outputs. Verify ARBITER proposals, adopted ratings and recorded overrides against retained bundle projections. Stored-arm Overall rule checks may allow escalation for multiple Some concerns domains; these software checks are distinct from agreement with derived expert Overall.

Source checks concern required-answer evidence coverage, quotation/source/location records, content hashes and retained verification records. The structural audit did not independently re-extract quotations or evaluate whether evidence supported an answer. Image transcriptions remain model-written.

Report runtime and API list-price equivalents using 102 paired trials. Source summaries are medians and IQRs; resource contrasts are paired mean differences. Thinking is included in output pricing. Preserve existing deduplication, token reconciliation and reconstruction bounds. Frozen USD rates per million tokens are input 2.00, one-hour cache write 4.00, five-minute write 2.50, cache read 0.10 and output 10.00. Subscription runs did not incur these equivalents as expenditure.

## Uncertainty

Use the original 10,000 trial-cluster bootstrap replicates, seed 20261018. Sample trials within each of 16 fixed reviews, preserve review sizes, and carry both arms and all domains together. Paired contrasts share weights. Percentile intervals use quantile type 7. Report valid replicate counts. The intervals condition on these reviews, experts and observed runs. They do not sample new reviews, experts or repeated model runs. No P values or multiplicity corrections are used.

## Retired reporting and computation

The 26 October reduction removes expert averages, agreed-reference subsets, extra source-to-source contrasts, binary and extra unweighted metrics, directional/strictness strata, revised-rating and answer-change summaries, all-disputed choice summaries, review forests and question-level absolute signalling grids. Redundant supplementary figures and table expansions are removed. Complete paired question diagnostics remain. The author subsequently removed the benchmark-target and exploratory-diagnostic table families from the reading supplement; their underlying source and numerical exports remain in the repository. The complete AVATAR trace is directly linked as a current artifact rather than repeated in the reading supplement. Existing source workbooks remain intact. The earlier Git revision above retains the complete prior calculations and results.

These cuts reflect the author-approved question and duplication, not effect direction. Retained estimates keep their original populations, calculations and intervals. Do not strengthen mechanism, evidence-support or reviewer-benefit claims because a supporting analysis has been removed.

## Production and verification

The publication retains five main figures and three main tables, as the author clarified that the supplement is the priority for reduction. Figures 1 and 2 retain the architecture and worked example. Figure 3 shows the evaluation flow, Figure 4 combines absolute and paired agreement, and Figure 5 shows paired signalling diagnostics. Table 1 describes the benchmark, Table 2 reports conditional choices, and Table 3 combines process checks and resources. The supplement now contains four numbered families covering Published agreement, independent agreement/reliability, category context, and signalling/eligibility. Compact methods, prompts and a reporting-scope account accompany them. Use glossary labels and the existing readable publication styles.

From analysis/, run Rscript run.R to recompute retained estimates and rebuild artifacts. Rscript build-publication.R reuses finalized estimates. Run the testthat suite, verify-output.R, ../scripts/verify-reduction.py and the retained-materials presentation check. Verify retained numerical rows against the earlier Git revision, source-input identity, protected artwork, editable Word tables, Word-to-HTML cell equality and local links. Inspect rendered documents and figures.

Report the model identifier claude-sonnet-5-5, medium effort, Claude Code 2.1.278, one run per trial per arm, and the actual run dates. The evaluated revision is 2848c7926a2acc25402345a42be39d695a99861a. Public ARBITER 1.0.0 is revision 2f549ae30f056ff441ea61a04b719968716f2219; it is not the exact revision run. Do not infer immutable model identity across dates.

Legacy primary-endpoint.csv names conditional-choice calculations only. Internal source identifiers and the RoB 2 question selection:prespecified-analysis do not establish outcome priority or prospective evaluation planning. Trial PDFs are not redistributed. Author declarations, complete assessor details and an archival DOI remain pending.

