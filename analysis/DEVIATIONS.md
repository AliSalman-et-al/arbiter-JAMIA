# Analysis deviations and unresolved inputs

No Python is used. This file records conservative resolutions as they arise.

1. **Amended section 5.4 gate passes; consistency exception.** ARBITER-Sonnet reproduces
   510/510 domain labels. ARBITER-Haiku reproduces 504/505 observed labels:
   hill-2017 D1 reports Some concerns, but 1.1=NI, 1.2=PY, 1.3=N gives Low
   under official Table 4 (printed p. 20) and the retrieved ARBITER source.
   Five additional Haiku cells (award-1-2014 D1-D5) have no labels or answers.
   The amended gate permits this single independently established exception.
   It is listed in the supplement and footnoted on the Haiku consistency rate;
   the authors must check the run bundle. The five missing cells belong to an
   unfinished run (continues=1), count as wrong, and have an exclusion sensitivity.
   No algorithm or input label was changed. This entry folds in the retired
   VALIDATION-HALT.md. Guidance: https://www.cochrane.de/sites/cochrane.de/files/uploads/RoB_2.0_guidance_2019.pdf
   (Tables 3–4, printed pp. 19–20); source cross-check:
   https://github.com/AliSalman-et-al/ARBITER/blob/2f549ae30f056ff441ea61a04b719968716f2219/src/arbiter/logic/evaluator.py
   (randomization branch); question locators: src/arbiter/packs/scientific.py.
   These sources both give Low for NI/PY/N. The available CSVs do not establish
   whether the exception is an intended override, an export issue, or another cause.
2. **Unverifiable run provenance.** The retrieved ARBITER commit is
   2f549ae30f056ff441ea61a04b719968716f2219. It is recorded as the source
   cross-check commit only; the benchmark-run commit, exact model IDs and run
   dates have not been established from the available CSVs. They are not
   inferred from directory names or filesystem modification dates.
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
   valid count exported; an entirely undefined interval is blank. Predictions
   with no variance have undefined kappa as directed by the plan; All-Low reports
   only accuracy and specificity, with other metrics blank.
5. **Split sensitivity.** Split discordant cells are forced ARBITER losses, without
   fabricating a baseline win. They join the residual Neither/forced-loss category.
6. **Grounding and exploratory answers.** Quotation words are whitespace-separated
   tokens inside paired straight or curly double quotes. This detects quotation
   syntax, not verification. Independent signalling answers define exploratory
   question eligibility, including explicit NA; missing arm answers count as wrong.
   Haiku is included in this non-adjudication-derived-arm comparison to independent
   signalling answers, but never in preferred-judgement endpoints or composites.
