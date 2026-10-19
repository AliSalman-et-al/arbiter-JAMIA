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

31. **Round 9 R9 supplement redesign.** Twenty-eight eTables follow the plan's
    supplement sequence, with a contents list and methods appendix first.
    The redundant long process-summary table is dropped as permitted by R9;
    per-trial process metrics remain in eTables 2–3, with cost totals/bounds and
    token reconciliation in dedicated wide source-comparison tables. Confusion
    matrices are 24 ordered grids (Published rows × predicted columns), with
    Missing only where nonzero. Meta-analysis rows use curated specialty/topic;
    trial identifiers use author/year. Repeated sources/comparisons become group
    rows. Undefined or degenerate κ is —, with an explicit note. All tables have
    captions, units and abbreviation notes. Clinical “baseline balance” wording
    in the override is expanded to “preintervention balance”, explicitly noted;
    the original model rationale remains unchanged in the CSV. Methods cite the
    2019 RoB 2 guidance, frozen pricing documentation and ARBITER 1.0.0 commit.
    The supplement remains portrait with editable Arial 9 pt tables.

32. **Round 9 R10 and final QA.** The canonical combined legend file is
    output/manuscript/figure-legends.md, per the lead's explicit R10 request;
    the former output/figure-legends.md duplicate is removed despite the older
    section 7 path. The builder extracts Figure 1's legend/alt text from its
    untouched notes, and the working HTML now displays the merged Figure 1.
    Figure 1 was rebuilt and its PDF/PNG/SVG and renamed TIFF are byte-identical
    to the starting files. Its technical notes retain original input-file paths
    as provenance, under the instruction not to change its content; these paths
    are not copied into the combined legends or publication figures/documents.
    Every figure has colour, PDF, greyscale and three severity-1 CVD previews.
    Every Word page was inspected. Final Supplement.docx has 40 portrait pages,
    28 eTables (52 editable grids) and one eFigure; main tables are one page each.
    SQ is defined in eTable 28 to avoid splitting “Question” in its narrow header.
    Answer-code “no_information” expands to “No information” in reader text;
    machine exports remain exact. Topic abbreviations are defined in table notes.
    Tests, clean Quarto rendering, publication-name scans and all 88 CSV hashes
    pass. No statistical or methodological change was made.

33. **Round 10 presentation corrections.** Evidence coverage is the fraction of
    active signalling answers with at least one evidence basis, as implemented
    by the extractor and audit summary; Table 3 and eTable 6 now name answers
    and explicitly define this denominator. Proportion intervals with identical
    displayed bounds are omitted while retaining estimates and counts, including
    supplementary tables. The All-Low no-variance note remains. No statistical
    object, CSV, input, analysis plan or glossary changes.

34. **Round 11 post hoc severity stratification.** Added the requested post hoc
    stratification of the 62 consensus discordant Sonnet cells by ARBITER severity
    relative to Unassisted. This was not a prespecified estimand. It uses the
    unchanged label-equality scoring and the existing 10,000 trial-cluster bootstrap
    weights stratified by meta-analysis, seed 20261018. The more-severe stratum has
    44 ARBITER / 1 Unassisted / 0 neither wins among 45 cells; the less-severe stratum
    has 10 / 6 / 1 among 17. It is labelled post hoc throughout. The binding round-11
    section 7 explicitly requests this addition; no analysis-plan edit is needed.

35. **Round 11 presentation and trace choices.** Figure 5B bars use consensus-only
    denominators; split counts are printed separately and retained in the complete
    supplementary table. Small segments below three are counted in the right-hand
    summary rather than labelled inside narrow segments. Figure 6 remainders count
    cells without any individually decisive question; unique cells with at least
    one decisive question plus the remainder equal the eligible loss denominator.
    They must not be reconciled by summing question frequencies. Complete AVATAR
    evidence quotes are divided into contiguous character- and line-limited chunks
    for editable portrait Word tables, with no omission; tests check exact
    concatenation. Verbatim clinical uses of “baseline” in quotes and the Unassisted
    rationale are retained under the explicit full-quote/verbatim instruction and
    do not name an analysis arm. The requested Unassisted results-102 signalling
    CSV is byte-identical to the versioned root export: the trace reads the
    requested path when present, checks byte equality, and falls back to the
    versioned copy in a fresh checkout. Source filenames, page/line ranges and source and
    evidence hash prefixes are provenance. The existing native Word PDF renderer
    is retained as explicitly requested. Figures 1/2, their builder and their
    separate legend file remain owned by the parallel task and untouched here.


36. **Round 11B-2 presentation update (supersedes entry 35 layout details).**
    Figure 5B reports vindicated/consensus N and splits at right; complete
    Published-upheld and other-label counts remain in eTable 13. Figure 6 uses
    lighter arm colours for cell remainders, with a shared paired-colour key;
    its all-zero D1 remainder row is omitted. The AVATAR eTable separates answers
    from unique evidence records on landscape pages, using Arial 8 pt only for
    that eTable. Displayed quote line breaks collapse to spaces, preserving all
    words; exact original strings remain in the common trace objects and committed
    JSON and are tested against every basis. The archive contains 16 evidence
    records, of which 15 are cited by current answers; the additional captured
    record is retained and that distinction is stated in the footnote. No
    statistical methods, source data or estimates change.

37. **Round 12 manuscript polish.** Presentation-only: shortened Figures 3–6 legends,
    removed flow outcome duplication and the pooled Figure 4A point, made Figure 6
    bars uniformly count loss cells, and moved AC2/composite details out of main
    Tables 2/4. Table 3 foregrounds Unassisted departures and retains Sonnet proposal
    design guarantees separately from recorded adoption overrides. Supplement merges
    reduce 31 eTables to 28, numbered in main-text citation order. Data-driven checks
    corrected 16 specialties to 15, replaced “small cost in specificity” with “lower
    specificity”, restricted the Figure 4 leniency claim to disputed-label errors,
    and restricted the Figure 6 majority claim to localised losses (18/29, rather
    than all 47 eligible losses). Generated results prose reads analysis CSVs.
    Figure 1/2 protected files remain owned by the parallel task; the legend loader
    resolves the AVATAR eTable placeholder and legacy number without editing them.
    No statistical estimate or method changes. See round12-report.md for the full
    legends, numbering map, checks and visual QA.

38. **Round 14 story revision; Haiku arms removed from reporting.** After a
    full-text literature review (`docs/research/llm-rob2/SYNTHESIS.md`), the
    authors revised the manuscript story and displays (ANALYSIS-PLAN section 7,
    Round 14). The pre-specified Haiku supplement analyses are dropped from
    every output, including the manuscript, supplement, results.html and the
    public release, by author decision. The Haiku data and code remain in the
    working repository. Display changes:
    - The benchmark set moves to the supplement.
    - Old Table 2 becomes Table 1, and old Table 4 becomes Table 2.
    - A new Table 4 compares the study with prior work.
    - Old Fig 5B, with bootstrap CIs, becomes Fig 4B. Old Fig 4B moves to the supplement.
    - Fig 5 gains the post hoc strictness rows.
    - The disagreement-pattern tile matrix and the recorded-override eTable are
      dropped. Sonnet has no overrides; Table 3 reports 0/510.
    The composite reference stays in the supplement and is cited only in the
    Discussion. No confirmatory method changes.

39. **Round 14 post hoc analyses.** Added after the literature review and
    labelled post hoc in every output (ANALYSIS-PLAN section 6):
    - Rules-only recomputation of the unassisted arm. Violations are replaced by
      the algorithm's output from the arm's own answers; invalid paths are left
      as reported.
    - Direction-of-disagreement shares with stratified cluster bootstrap CIs.
    - Per-domain unweighted Cohen's kappa against published labels.
    Motivation: prior studies report that recomputing ratings from model answers
    improves agreement (Huang 2025; Choi 2026), and that LLMs rate more strictly
    than published labels (Nyrhi 2026; Gandhi 2026; ROBoto2). A preliminary
    script outside the pipeline gave 3 of 62 consensus discordant cells changed;
    Unassisted wins 7 to 10; agreement with published labels 395 to 385 of 510;
    agreement with the agreed choice 69 to 64 of 129. The pipeline must
    reproduce these numbers before they are reported.

40. **Round 14 round 2: Figure 4B label correction.** The direction-of-disagreement
    counts were already specified as old Figure 5B in the 18 October plan. Only
    the bootstrap intervals were added post hoc. Figure 4B therefore drops the
    blanket post hoc axis label; its legend labels the intervals post hoc. This
    refines entry 39's wording without changing any count, denominator or interval.

41. **Round 14 round 2 author-requested post hoc additions.** Two paired differences
    in agreement with the adjudicators' frozen independent ratings use all 154
    disputed cells and the existing stratified trial-cluster bootstrap (10,000,
    seed 20261018). The composite-reference eTable adds a descriptive partition
    into 129 agreed-choice and 356 retained-published cells, without new intervals.
    The 18 primary Unassisted question 5.1 losses receive a descriptive source-input,
    justification-mention and answer comparison. No inferential mechanism analysis
    or additional endpoint is introduced. Counts do not establish that supplied
    registry material was relevant: De Waal's supplied record belongs to another
    trial. Full arm justifications and source inventories remain exported. Rules-only
    shares retain the original disagreements, and three corrections become ties
    with ARBITER rather than new exclusive Unassisted wins. No retained estimate changes.
