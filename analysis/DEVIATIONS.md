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

12. **Binding cost amendment 69c73c6 incorporated.** API list-price equivalents
    replace harness cost in Table 5; harness figures are supplementary only and
    unusable (unrecognized_model; unknown cost basis). Request events are deduplicated
    by message ID within turn; synthetic zero-usage messages are not requests.
    Input-side result-minus-request residuals can be negative after retries.
    We retain signed residuals, applying the plan's low-tier, request-share and
    high-tier pricing allocations without silently dropping request tokens.
    Side calls are modelUsage minus result.usage; compaction events are counted
    separately. Turns with side tokens but no compaction boundary are flagged,
    using low/high bounds and request-share point allocation. One-hour side-call
    writes are primary; five-minute writes are a separate sensitivity. All trial
    bounds are ordered; Sonnet bounds coincide. Thinking tokens are not added
    to output again. The rate card is frozen to the binding plan, not inferred
    from the unusable harness price. No geography multiplier applies.

13. **Round 4 P1 trace presentation.** Default award-10-2018 D2 illustrates a more-severe ARBITER judgement preferred by consensus while Baseline matches meta. Four such candidates and levin-2016 D2 are listed. The selected 25-word contiguous excerpt omits the leading fragment "study.". Workflow rows now align. Bundles record verification.json result="verified" and named checks including content_hashes, but no individual passage-match status. Figure 1 quotes the actual bundle-level status and explicitly states that scope; no passage-specific verification claim is inferred.

14. **Round 4 P2 flow presentation.** Removed the repeated discordant-cell count from the consensus parent box; the child retains 62 differing cells and the unchanged 54/7/1 breakdown.

15. **Round 4 P3 adjudication presentation.** Figure 3 has A/B tags, parallel departure-row labels, and nearly white zero-count tiles with grey zero labels. Nonzero counts retain the original outcome colours; counts and intervals are unchanged.

16. **Round 4 P4 token display units.** Supersedes entry 11 token units: Table 5 and its Haiku counterpart show input counts with thousands separators and zero decimals, cache creation/read in millions (two decimals), and output/thinking in thousands (one decimal). Identical formatting applies to medians, IQRs, paired means and CI bounds. Raw process CSV values and estimands remain unchanged; rounding is display-only.

17. **Round 5 F1 source binding.** Supersedes entry 13. Row 4 derives source label, page, lines and source_version hash prefix from the selected evidence record, and verifier status/checks from verification.json. The source_version matches the canonical source projection_hash, rather than the PDF byte hash. The caption explains server-extracted spans cited by handle. No passage-support judgement is claimed.

18. **Round 5 F2 structural evidence binding.** Count distinct evidence identities per bundle cited in bases or counterevidence by active answers of current domain_records, not superseded histories; repeat citations count once within a bundle. The denominator includes missing cited records as failures. Match source_id against canonical batch trial sources. Require a nonblank quote and source_version, finite page/start/end, and start < end. The 102-trial analysis set is used for both ARBITER arms; empty bundles contribute no cited records. Reports read committed per-trial counts. This is structural binding only: no PDF re-extraction and no test of whether a passage supports an answer. Baseline arms receive no binding rate. Intervals use the existing stratified trial-cluster bootstrap.

19. **Round 6 evidence-kind binding (replaces round 5 visual failures).** Supersedes the pooled text-span definition in entry 18. Visual records (kind figure or any render field) take precedence over text-span records (kind narrative or any quote/start/end field). Text-span criteria are unchanged. Visual binding requires a render source matching the record source and a captured bundle source, a positive integer render page, nonblank PNG hash, four finite region coordinates in [0,1] with x0 < x1 and y0 < y1, and nonblank transcription. Text-span quotes are server-extracted; visual regions are server-rendered and hash-bound, but transcriptions are model-written and not machine-checked against the image. Report each kind and overall binding, plus trials citing visual evidence. Unknown or missing cited records are other, counted explicitly and unbound in the overall denominator. Distinct current-active cited identities and bootstrap rules are unchanged. No provenance, recipe, receipt or image-content checks are added beyond the requested definition. See round6-report.md for observed counts and validation.

20. **Round 5 F3 validation.** Clean Quarto render, testthat suite, artifact checks, Figure 1 PNG inspection and prohibited-name scan completed. verify-round5.R compares every tracked CSV to pre-round HEAD 499ef07, permits only audit/trace changes and the new per-trial binding counts, and checks that all earlier audit rows are preserved. Generated PDF text is unchanged from the committed figures; timestamp-only changes are discarded. The pre-existing Windows conversion in the generated coding README is discarded. See round5-report.md for results and denominator limitations.

21. **Round 7 replaces human coding with plan 5.6 localisation.** The six classes
    follow plan order and the existing validated algorithms/required-path checks.
    Eligibility uses independent-judgement equality with consensus preferred;
    parsing quality does not remove eligible cells. Primary needs both adjudicators,
    sensitivity at least one. Meta losses are counted only; Haiku is excluded.
    Workbook row orders were checked identical. Labels, never letters, are scored.

22. **Round 7 parsing and counterfactual choices.** Numbered assignments delimit
    answers; whitespace/trailing separators are allowed. Duplicate, missing,
    out-of-domain, unrecognised or qualified answers are reported per cell/question.
    Exact Y/PY and N/PN collapse; NI and NA stay separate. The sole observed issue
    is chiba-2021 D3, A, question 3.4: NI at 6 months; PY at 12 months. Neither
    independent judgement equals preferred, so this cell is outside both populations.
    Comparison requires parsed answers from every usable adjudicator; disagreements
    are separately recorded, never errors. Unresolved questions cannot be discordant
    or decisive. The no-discordance class requires complete reference and losing
    comparisons, avoiding false agreement after parse failure; adjudicator-differ
    questions still meet the plan's no-discordant criterion and remain flagged.
    Reference-judgement departures include invalid paths, flagged by adjudicator.
    All stored answers, including inactive NA, stay fixed during substitution;
    newly required questions are not filled. Invalid substituted paths have no
    judgement and are not decisive. Any valid changed judgement counts, even if
    not preferred. Joint substitutions must reach preferred. Frequencies include
    every individually decisive question regardless of first cell class; joint sets
    contribute no individual counts. No imputation or time-point choice is made.

23. **Round 7 presentation and quotation selection.** Primary counts fit as six
    additional rows in Table 4. Both populations, all 22 question frequencies
    including zeros, a title-free horizontal-bar figure and parse issues are in
    the supplement. The primary-count figure omits questions zero in both sources;
    ARBITER is teal and Baseline orange. Optional short text in the existing question
    map abbreviates official 2019 questions (Sterne et al., BMJ 2019;366:l4898,
    Table 1; D2 effect of assignment). The default map and existing CSV stay unchanged.
    Five Discussion candidates per source are selected by primary eligibility first,
    single-decisive class first within eligibility, then other class order, then
    slug/domain ascending. Explanation content never determines selection. Both
    full adjudication explanations are retained verbatim, including repeated text.
    Removed the obsolete codebook, blank/working sheets including embedded second-
    coder sample, instructions, coding functions/tests and QMD placeholders. The
    historical coding_sample_seed field in reproducibility.csv is retained solely
    to preserve that CSV; it is unused. Historical round reports remain provenance.

24. **Round 8a presentation layer.** Section 7 supersedes earlier placement and
    display choices. Statistical CSVs remain unchanged from 44a29a8. New Word
    and HTML tables are display objects built from those CSVs and curated metadata.
    Fira Sans regular/bold and Condensed regular are vendored with OFL licensing,
    registered with systemfonts/ragg, and reproducibly installed per-user for Cairo
    PDF via install-fonts.ps1. No Arial figure fallback is needed. Arial 9 pt is
    used in editable Word tables. JAMA roles are fixed to the plan's hex values.
    R string escapes preserve Unicode punctuation under this Windows locale.

25. **Round 8a main tables.** Main Table 1 pools D1-D5 counts from the frozen
    label export, joins the curated specialty/journal/year/topic, sorts specialty
    then journal, and adds totals. Existing per-domain table1.csv is retained for
    the supplement. Table 2 has Published, composite and paired-difference blocks;
    coefficient/proportion CIs stay on their original scale. Table 3 uses proposals
    for domain consistency and separates exact Overall consistency and permitted
    escalation; Unassisted proposal/override and trace metrics are unavailable.
    Table 4 contains reliability only; localisation classes move to the supplement.
    UTF-8 LC_CTYPE is set explicitly for Word Unicode headers on Windows, without
    changing numeric or collation settings. Figure 1's report slot and code are
    preserved as assigned to the separate worktree.

26. **Round 8a figures.** Figures 2-5 and supplemental forest eFigure 1 use
    174 mm widths, text no smaller than 7.5 pt, PDF vectors and 600-dpi LZW TIFFs;
    PNGs are previews. Figure 3 panel B counts are reconstructed in memory from
    the unchanged cell export, without rewriting figure3-panelB.csv. Figure 4
    panel B is a count bar for the unchanged 78/29/22 direction totals; the zero
    line in panel A is a coefficient reference, not an All-Low kappa estimate.
    Figure 5 facets are domains with both primary loss denominators, paired
    source bars and short question text; zero-in-both-source questions are omitted
    only from the figure. Cairo initially substituted Arial until the installed
    fonts were loaded into the Windows font session. install-fonts.ps1 now calls
    AddFontResourceEx; embedded PDF fonts are checked during final verification.
    Figure 1's old builder is no longer invoked by this worktree's pipeline.

27. **Round 8a supplement production.** Supplement.docx and supplement.html use
    the same 29 ordered eTable objects and one eFigure, with captions and notes.
    The appendix describes algorithms/validation, frozen API cost reconstruction,
    localisation and structural evidence criteria. Former Table 5, localisation
    classes, both populations, all-arm non-adjudication analyses, matrices, forest,
    sensitivities, override rationale, quotation syntax, exploratory questions,
    prompt templates/example and run provenance are supplementary. Wide diagnostic
    exports are pivoted to measure/value rows, preserving text at 9 pt. Native
    process totals remain supplementary, with time converted to minutes and USD
    rounded for display. The override rationale retains the clinical phrase
    'baseline balance' verbatim; it is not an internal source label. The separate
    TRIPOD-LLM.docx remains an author-completion skeleton, with GRRAS IDs.

28. **Round 8a legends and QA scope.** Legends are written to both the plan's
    output/figure-legends.md and the requested output/manuscript/figure-legends.md.
    Figure 1's legend follows the AVATAR plan; its old report slot, code and images
    remain untouched for the other worktree. The prohibited-name scan therefore
    explicitly excludes that unchanged slot, and scans all newly produced Word,
    PDF and HTML reader-facing text plus both legend copies. Frozen statistical
    CSVs retain machine identifiers to meet exact invariance. Composite displays
    use the three section 5.2 metrics. Word table footers stay with the final row;
    wide rationale text uses Field/Value rows. All regenerated figures were viewed
    in colour, actual PDF rendition, greyscale and severity-1 protanopia,
    deuteranopia and tritanopia. Raster mapping preserves raster storage order.
    Real Word cells/fonts, PDF embedded fonts/minimum text and TIFF resolution/
    LZW compression are verified. No numerical or methodological deviation occurs.

29. **Round 9 R0–R4 display corrections.** Figure 1 TIFF extension is .tiff;
    its image content is unchanged. Table 1 separates year, uses journal
    abbreviations, puts General medicine first, and defines SC. Tables 2–4 use
    spanning group rows. All proportion intervals display percentages; paired
    proportion contrasts display percentage points. Table 3 suppresses intervals
    except Unassisted departure-type rates, in a separate percent column.
    No CSV or statistic changes. The existing flextable/officer pipeline and
    native Word PDF renderer are retained as the repository's Windows workflow.

30. **Round 9 R5–R8 figures.** Figure 2 is 174 × 95 mm, with a horizontal
    CONSORT exclusion arrow and author/year trial names. Figure 3 annotates
    both consensus estimates with their counts. Figure 4B uses 0–100% with
    n/N (%) labels. Figure 5 omits zero geometries/text and fixes source offsets
    so ARBITER is consistently above Unassisted, first in the legend. Domain
    facets and loss denominators remain. The supplementary forest joins curated
    specialty/topic names and omits undefined/degenerate coefficients.
