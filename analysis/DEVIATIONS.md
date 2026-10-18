# Analysis deviations and unresolved inputs

No Python is used. This file records conservative resolutions as they arise.

1. **Amended section 5.4 gate passes; consistency exception.** ARBITER-Sonnet reproduces
   510/510 domain labels. ARBITER-Haiku reproduces 504/505 observed labels:
   hill-2017 D1 reports Some concerns, but 1.1=NI, 1.2=PY, 1.3=N gives Low
   under official Table 4 (printed p. 20) and the retrieved ARBITER source.
   Five additional Haiku cells (award-1-2014 D1-D5) have no labels or answers.
   The amended gate permits this single independently established exception.
   It is listed in the supplement and footnoted on the Haiku consistency rate;
   the bundle now confirms a recorded model override (see resolution below). The five missing cells belong to an
   unfinished run (continues=1), count as wrong, and have an exclusion sensitivity.
   No algorithm or input label was changed. This entry folds in the retired
   VALIDATION-HALT.md. Guidance: https://www.cochrane.de/sites/cochrane.de/files/uploads/RoB_2.0_guidance_2019.pdf
   (Tables 3–4, printed pp. 19–20); source cross-check:
   https://github.com/AliSalman-et-al/ARBITER/blob/2f549ae30f056ff441ea61a04b719968716f2219/src/arbiter/logic/evaluator.py
   (randomization branch); question locators: src/arbiter/packs/scientific.py.
   These sources both give Low for NI/PY/N. The later author amendment and supplied
   bundles resolve this as a recorded model override, with proposed=Low,
   adopted=Some concerns, rationale and evidence. It is not an algorithm violation.
   Table 3 distinguishes proposed-algorithm agreement from recorded overrides.
2. **Run provenance resolved after the initial CSV-only stage.** Author commits
   supplied run READMEs, metadata and bundles during this implementation. Models
   are claude-sonnet-5-5 and claude-haiku-5-5, effort medium; Claude Code 2.1.278
   used isolated homes. ARBITER-Sonnet ran 12 October 2026 (12:12–19:17 EDT),
   the other arms 14 October 2026, per READMEs. The author amendment identifies
   ARBITER 1.0.0, public commit 2f549ae30f056ff441ea61a04b719968716f2219,
   as the run version. Earlier internal names/commit IDs are not published in
   report outputs. Round 3 removes the provenance placeholder; no date is
   inferred from file timestamps.
3. **Missing ordinal judgements.** The plan requires missing arm labels to count
   as wrong but does not define ordinal coefficients for missing predictions.
   For Haiku only, missing predictions are assigned the opposite extreme of the
   reference (High for Low; Low otherwise) for coefficient calculations. This
   imposes maximal linear disagreement and also fails exact and Not Low scoring.
   It is a penalty convention, not a recovered judgement. Confusion matrices retain
   Missing explicitly. The sensitivity excludes the same cells from both Haiku
   arms so their differences remain paired. Overall missing cells are handled too.
4. **Bootstrap and degenerate estimates.** Seed 20261018, 10,000 replicates,
   percentile type-7 intervals. The full 102-trial cohort is resampled within each
   meta; endpoint subsets are then selected. Every paired contrast uses identical
   replicate weights. Undefined replicates are omitted metric by metric, with the
   valid count exported; an entirely undefined interval is blank. The All-Low
   kappa is suppressed as explicitly directed by the plan; All-Low reports only
   accuracy and specificity. Other coefficients follow their usual formulas,
   including zero kappa for constant predictions when its denominator is nonzero.
5. **Split sensitivity.** Split discordant cells are forced ARBITER losses, without
   fabricating a baseline win. They join the residual Neither/forced-loss category.
6. **Grounding and exploratory answers.** Quotation words are whitespace-separated
   tokens inside paired straight or curly double quotes. This detects quotation
   syntax, not verification. Independent signalling answers define exploratory
   question eligibility, including explicit NA; missing arm answers count as wrong.
   Haiku is included in this non-adjudication-derived-arm comparison to independent
   signalling answers, but never in preferred-judgement endpoints or composites.
7. **Worked-trace candidates from bundle evidence (round 3).** This supersedes
   the initial justification-based draft. Candidate passages are contiguous
   excerpts of at most 30 words from evidence records linked to active answers,
   with captured source labels, PDF page locators and evidence identities. Five
   consensus cells where ARBITER was preferred over meta are exported. The first
   is a provisional selection for author review. No trial PDF is redistributed.
8. **Consistency denominators and codebook (round 3 amendment).** A nonempty
   answer set with a required NA or missing answer is an Invalid answer path;
   this includes an earlier required answer even if later answers could shortcut
   to a label. Only absent labels or entirely absent answers are Not evaluable.
   Consistent, Violation, Invalid and Departure rates share the denominator of
   all other cells (509 Baseline-Sonnet; 510 Baseline-Haiku). Departure is
   Violation + Invalid. ARBITER consistency uses proposals; recorded overrides
   are separate. Sensitivities replace required invalid answers recursively as
   N/PN (implemented as N, algorithmically equivalent to PN), then as NI,
   including newly required questions. Answers off the resolved path are not imputed. The
   codebook and empty human coding fields are unchanged.
9. **Concurrent binding amendments incorporated.** Author commits added section
   5.8, resolved the recorded override, supplied provenance, and specified distinct
   baseline prompts during milestones 3–5. The last milestone incorporates these
   amendments. R streams JSONL in bounded chunks and cross-checks terminal usage
   against metadata. Four per-arm derived CSVs are committed; reports do not read
   raw logs/bundles. Extraction fails on absent logs and writes only after all
   inputs validate. No Python is needed. UTF-8 JSON is explicitly tagged when
   parsing strings on Windows; bytes and numeric fields are not altered.
10. **Process estimands and bundle denominators.** Section 5.8 does not specify
   the statistic for paired process differences. We report the mean paired
   per-trial difference and total difference, with the shared bootstrap; per-arm
   medians, quartiles and totals are also shown. Thinking tokens are a subset of
   output tokens and are not added again. Cost is harness-reported with unknown
   basis. Baseline approval/evidence/verification are not available, not zero.
   All 102 ARBITER-Haiku bundles exist, but award-1-2014 has no assessed domains;
   its empty bundle can verify structurally without supplying any judgement.
   Domain scoring remains missing/wrong; proposal and override denominators are
   505 observed Haiku domains. Bundle verification uses all available bundles,
   while evidence coverage uses their active answers. A pass is structural
   verification, not proof of assessment correctness or completion.

11. **Round 3 presentation and interpretation.** Main grounding evidence is
    evidence coverage and structural bundle verification in Table 3; quotation
    syntax is supplementary and understates bundle-based grounding. Baseline
    justification fields are checked for code-only content, without inferring
    absent reasoning. Table 5 uses minutes, USD (two decimals) and thousands of
    tokens per trial, median [IQR] and paired mean differences. Haiku paired
    process contrasts are exploratory, using the same weights. Figure 4 marks
    zero as the requested all-Low reference; tables retain the plan's suppressed
    constant-rule kappa convention. Independent-judgement/source reliability is
    explicitly restricted to the disputed set and cannot estimate overall
    meta-label accuracy. Provenance placeholders are removed except the ARBITER
    1.0.0 Zenodo DOI; human coding and checklist fields remain empty.
