# Round-six supplementary relocation map

These are concrete proposed insertions/replacements, not edits to the supplement. Only the five authorized output files were written. Existing supplementary source is `analysis/R/manuscript-supplement.R`, rendered through `analysis/supplement.qmd`; no generated artifact or analysis source was changed. Before publication, the parent must reconcile these blocks with that source and regenerate artifacts under separate authorization. Main-text references to existing eMethods content do not assert that the proposed blocks have already been installed.

## 1. Software revision and command correspondence

Destination: **Prompt templates and run provenance**, replace the software/command portion of the paragraph currently emitted near line 387 of `analysis/R/manuscript-supplement.R`. Preserve its existing R/package-version cross-reference and computational-cost statement.

> The evaluated rob2-kit revision was commit `2848c7926a2acc25402345a42be39d695a99861a`. The installable public release is ARBITER 1.0.0, commit `2f549ae30f056ff441ea61a04b719968716f2219` (https://github.com/AliSalman-et-al/ARBITER/tree/2f549ae30f056ff441ea61a04b719968716f2219). The evaluated runner invoked `/rob2-assess`; `/arbiter-assess` is the public command name. The retained release audit documents correspondence between the evaluated and public assessment commands, without establishing equivalence of the complete releases. Findings concern the evaluated software revision.

Main retention: common reported identifier/configuration, dates, unknown immutable snapshot identity, one run per trial per arm, and evaluated-revision scope. No whole-release equivalence claim is made.

## 2. Development and execution provenance

Destination: **Prompt templates and run provenance**, replace the development-attestation tail of the same paragraph and append the execution details below. Retain the actual template/example rows already emitted from `prompt-template-example`.

> Development included ten prostate-cancer trials and synthetic diagnostic cases retained in ARBITER `eval/` records. The benchmark was not used to develop the workflow. Benchmark non-use is an author-attested study fact; the retained development records do not establish an exhaustive exposure history or an independent complete overlap audit. Complete development-exposure history, prompt and assessment-skill selection history, and version-freeze documentation remain pending. The retained prompt materials include both prompt templates, the command invoking the ARBITER assessment skill, the fixed Unassisted output-format instruction and a filled example. The protocol allowed “Continue.” at most twice per phase without coaching. Unassisted received copies of registry records and documents acquired during the ARBITER run; these were not fetched anew.

Main retention: development cases/non-use, pending histories, isolated settings/connectors/memory, model/runtime configuration, run dates, continuation allowance, copied inputs and comparator restrictions. The existing supplement's wording “pending verification ... independent overlap audit” must not be treated as a completed audit; this replacement states the evidence basis explicitly.

## 3. Document identity, extraction and verification

Destination: eMethods **Evidence binding and verification** in `METHODS_APPENDIX`. Append this explanatory block; retain existing counting rules, source-field checks, visual precedence, bounds, excluded histories, unavailable Unassisted traces and audit results.

> Source documents are retained with cryptographic hashes identifying their contents. Extracted page text has a separate version identifier linking passages to the captured document and extraction. The model may select a returned passage reference, page and line ranges, or copied text as a locator. Copied text must match the captured source; unmatched or ambiguous selections are rejected. Software stores the actual captured source slice with source identity, page and character offsets. Runtime source-text matching, assessment-file verification and the structural source-provenance audit are distinct checks. The structural audit checks retained source and location records; it did not independently re-extract quotations from original documents. Visual records link a rendered page and selected region to a model-written transcription. Source matching cannot correct extraction errors, establish completeness or relevance, or validate the transcription or interpretation. Neither location checks nor file-integrity checks determine whether evidence justifies a signalling answer.

Main retention: locator matching and captured-slice mechanism, image limitation, uncertainty/counterevidence, proposed/adopted ratings, evidence-backed overrides, exports and the distinction between runtime/structural/semantic checks. No claim that the model never types a locator, or that matching semantically validates it.

## 4. Unsupported-design exclusions and Atwine discrepancy

Destination: append **Benchmark construction and exclusions** adjacent to eMethods **Input parity and label targets** and the benchmark table. Cross-reference `docs/manuscript-development/interview-refinement/benchmark-provenance.md` as editorial provenance when reconciling the source, rather than publishing a recovery log in the main manuscript.

> The source set contained 105 trials; Atwine, Haney and Herrmann were excluded as outside the supported design scope, leaving 102 trials. The author-supplied execution instruction designated these designs as unsupported. The author disputes Atwine's stored design classification and confirms its exclusion, but has not supplied a verified alternative subtype or supporting classification rationale. No specific Atwine subtype is asserted here. Search dates and ranking records were unavailable; the selection account does not establish that the reviews were the highest-ranked or most-cited eligible reviews. The reason for the additional General Medicine review remains undocumented.

Main retention: purposive Europe PMC selection, prioritization rather than certified rankings, unavailable dates/ranking records, table-order availability replacements, deduplication, three unsupported-design exclusions and resulting cohort. The detailed Atwine dispute remains unresolved; no alternative design is invented. The additional-review uncertainty is preserved here from the supplied selection provenance, without adding a scientific claim to the main text.

## 5. Incorrect source record and target alignment

Destination: eMethods **Input parity and label targets**; retain the existing explicit De Waal statement and expand with the source-availability context. Consolidate duplicate De Waal wording in **Interpretive limits** only during separately authorized supplementary integration.

> Both arms received the same captured input set, with trial-dependent availability of articles, supplements, registry records, protocols and statistical analysis plans. The supplied De Waal registry record concerned a different trial and did not establish information about the assessed result. Unassisted received the captured registry copies from the ARBITER run, rather than newly fetched records. Equal inputs do not establish source completeness or correctness. Initial targets followed trial-primary outcomes; 43 of 105 were revised before the reported runs toward results underlying published labels. Final prompts specified outcome, comparison, time point and numerical result. Published target correspondence remained partial, inferred, different or indeterminate in some cases, including labels covering several outcomes. All domain cells were retained; target uncertainty was considered qualitatively.

Main retention: variable source availability, incorrect-source possibility, identical supplied inputs, target revisions/specification, alignment uncertainty, all-cell retention and qualitative treatment. No assertion that target differences caused the reference-dependent results.

## 6. Completion fields retained in place

Expert credentials/RoB 2 experience, training/calibration, multi-outcome conventions and original blank assessment form remain pending in main Methods and the existing **Blinded expert assessment** eMethods block. Back matter remains verbatim, including authorship, affiliations/correspondence, accountability, AI disclosures, funding, conflicts, CRediT, ethics/consent, registration, public involvement, archive DOI/dataset citation and other author declarations. Development/prompt/version histories remain explicitly pending in main Methods and proposed block 2. No unresolved item was promoted to a completed attestation.

## Scientific retention coverage

No study Results or numerical findings were relocated. The original five canonical Methods headings are restored exactly. Main Outcomes retains Published-first/exact-before-kappa reporting, postanalysis order/no hierarchy, conditional-choice denominators and credit rules, component matching/eligibility, both coding schemes, rule-break and sensitivity definitions, Overall escalation distinctions, runtime/cost definitions, exploratory populations/recomputations and anchoring limits. Statistical analysis retains all bootstrap settings, fixed-review conditioning, paired weights/expert means, no P values/multiplicity adjustment and reporting-guideline map.
