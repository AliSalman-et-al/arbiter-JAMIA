# Round 12 manuscript polish

Started on main at 48c7116. Local commits only; no push. Statistical estimates and methods are unchanged. Figures 1/2 and their protected source/legend files were not edited.

## Findings checked and wording corrected

- Table 1: 16 meta-analyses cover 15 distinct specialties, not 16; corrected the title.
- Table 2: retained the sensitivity finding, but changed “at a small cost in specificity” to “with lower specificity”. The Overall specificity loss is 21.4 percentage points, so “small” was not justified.
- Figure 4: limited the leniency finding to disputed-label errors; the selected adjudicated cells do not estimate full-benchmark published-label accuracy.
- Figure 6: narrowed “most losses” to “most localised losses”: question 5.1 changes 18 of 29 Unassisted loss cells with any individually deciding question, but only 18 of all 47 eligible losses.
- Table 3: 65/509 evaluable Unassisted domain ratings departed (12.8%); one wholly missing label/answer set is excluded. ARBITER design guarantees concern Sonnet proposals; recorded adoption overrides remain supplementary.

## Implementation and merges

- Tables 2/4 drop AC2 columns; composite results remain in the supplement. Table 2 retains Published domain/Overall blocks and paired differences. Table 3 is Measure | Unassisted | ARBITER, with domain totals and evidence/audit rows.
- Merged Sonnet/Haiku process summaries with a Model column and common source columns; merged four per-adjudicator composite tables into two (estimates and differences); merged missing-Haiku tables into one with estimate/difference sections.
- AVATAR is eTable 1, first cited by Figure 2. Figure 5 cites eTables 2–4; Figure 6 cites eTables 5–7; Table 1 cites eTable 8; Table 2 cites eTables 9–10; full reliability is eTable 16; process metrics are eTable 17.
- The shared legend loader substitutes {{eTable:avatar-trace}}. For the current pre-handoff file it also updates legacy eTable 31 references and excludes its production-provenance paragraph from the combined manuscript legends. The protected handoff file itself remains exact. Figure 1/2 substantive legend length and artwork remain the parallel owner’s responsibility.
- Figure 3 no longer repeats the Figure 5 outcome counts; Figure 4A has domain points only; Figure 5B uses reader labels and counts in words; Figure 6 has one bar unit and facet-only remainders.
- Reader-label transformations apply to supplementary captions, notes, tables and methods; complete trace quotations and rationales remain verbatim. Banned-term scans were extended. CSV row ordering for the disagreement-pattern export is explicitly English-locale ordered to preserve the existing output under Windows.
- results-sentences.md is regenerated from CSVs by R at every full build.

## Main table titles

Table 1. Sixteen meta-analyses across 15 specialties supplied the benchmark
Table 2. ARBITER detected more of the risk the published reviews flagged, with lower specificity
Table 3. Without ARBITER, 1 in 8 domain ratings broke the RoB 2 rules
Table 4. Before seeing any label, both adjudicators’ own ratings agreed with ARBITER far more than with the unassisted model or the published review

## Full figure legends and alt text

### Figure 1. How ARBITER works

**Figure 1. How ARBITER works.** The reviewer chooses a trial and outcome and approves the result to assess through `arbiter review`. The AI model (LLM agent) follows the ARBITER assessment guide, uses `search_sources` and `search_sources_batch` to locate evidence, reads matching pages through `read_pages`, selects relevant quotations, and supplies answers, justifications and quotations. ARBITER is rule-based software with no AI: it stores source records, checks quotations, applies the official RoB 2 rules, packages the `.arbiter.zip` audit file, and writes the HTML report through `arbiter report`. Evenly spaced two-headed arrows represent model–server tool exchanges. Plain action labels are primary; small grey monospace labels identify representative tools. When needed, `render_page` delivers page images and `select_visual_evidence` selects evidence from them. Search and page reading recur during assessment; the phase columns group functions rather than prescribe a single tool-call sequence. Across 102 trials, 53 of 637 `save_domain_judgment` calls were rejected (32 for evidence/citation structure, 21 for other input errors); every affected domain was saved after resubmission. Audit files retain source identities and evidence quotations, rather than complete trial PDFs, with answers and decision history. The assessing model can record a reasoned override; none occurred here.

Alt text: Reviewer, lavender AI model with a robot icon and mint rule-based ARBITER server with a server-stack icon extend across Capture, Propose and approve, Assess each domain, and Review and export. Trial reports and registry enter at Capture. The reviewer chooses and approves; the model reads and answers; the server stores, checks and applies rules, with grey tool names including search_sources, search_sources_batch and read_pages, plus arbiter report. Capture prepares and locates source records; Assess each domain reads text or page images and selects evidence to answer signalling questions. The assessment tools include select_text_evidence for text, render_page for inspecting page images and select_visual_evidence for selecting image evidence when needed. Export arrows lead to a yellow audit-file card and a framed native AVATAR HTML-report detail showing the five domain-navigation results and first domain card. The reviewer receives both the HTML report and audit file. Arrows from both outputs converge on a shared shield-and-check node labelled Checkable by an independent verifier.


### Figure 2. AVATAR, assessed by ARBITER, domain by domain

**Figure 2. AVATAR, assessed by ARBITER, domain by domain.** AVATAR compares early surgery with watchful waiting in asymptomatic severe aortic stenosis; the assessed outcome is all-cause death. The trial is illustrative, not representative. Each row connects a paraphrased signalling question, every cited snippet for that question, the AI answer and verbatim excerpts of its recorded justification (ellipses mark omissions), ARBITER's quotation checks and complete answer pattern, and the computed result. Official questions and the full trace appear in **eTable 1**. Domain headings omit repeated “Bias arising/due to/in” prefixes for readability; full official domain and question wording is in eTable 1. D4 displays both 4.3 and 4.4; 4.4 uses a recorded inference without a quotation.

Seven sources are stored; four are cited: A, Circulation 2022 report (CIRCULATIONAHA.121.057639.pdf); B, European Heart Journal 2024 report (ehae585.pdf); C, ClinicalTrials.gov NCT02436655 (first submitted 2015); D, protocol amendment dated 4 January 2021 about surgical delays. Letter/page tabs link snippets to these cards. Page numbers refer to that source's stored text; D4's broad evidence range is identified by page only. Snippets preserve source words, with ellipses for omissions and normalized extraction whitespace; extraction breaks in assignment and censored are joined. The evidence key shows the recorded types as visual swatches: an outlined yellow box for direct support, a grey box for context and a dashed box for inference (reasoning without a quote). **Weighed against** gives a verbatim trimmed counter-evidence statement; **? Open point** gives the recorded unknown verbatim. Direct-support outlines preserve the evidence-type distinction in greyscale. These statements do not introduce additional quoted-source records. MACE means Major Adverse Cardiac Event, as written in the registry; AS, aortic stenosis; AVR, aortic valve replacement.

Y, yes; PY/PN, probably yes/no; N, no; NI, no information. Light hatching and grey numbers identify branches not needed. The trial-wide quotation check confirms passages in the stored source records, not clinical correctness. The full trial has 15 answered questions, 7 not needed, and 16 quote records; displayed-question counts are 2, 4, 1, 1 and 4 (plus the unquoted 4.4 inference). For 5.1, all four bases are context: registry death appears inside a combined outcome; the report says prespecified; analyses used intention to treat; the available amendment concerns surgical delays. None establishes a dated plan for this measurement and analysis. NI/PN/PN yields Some concerns. The other domains are Low, so the overall rule yields Some concerns. The RoB 2 result pills display a fixed mapping of the recorded rule IDs, with no additional clinical interpretation. Repeated per-row rule and quote-check statements are omitted; the header states the software’s role and the footer gives the trial-wide quote-check result. All domain frames have the same weight. The heavier 5.1 chip marks the recorded deciding question. Every quote is checked against its stored source; ARBITER computes ratings from the answers. In D5 the sources are silent about a dated plan for this particular analysis. These explanations replace the former italic annotations and curved arrows. The assessing model recorded no override. Both expert adjudicators preferred D5 Some concerns; the published D5 judgement was Low. Overall was not adjudicated.


Alt text: A five-row storyboard starts with AVATAR, all-cause death, answer key and visual evidence swatches and four lettered source cards. Each row shows the domain name, plain question and official number, tabbed source snippets, the model’s answer with a short, contextual verbatim justification excerpt, all recorded answer chips and the RoB 2 result. Preintervention differences yield No with diabetes counter-evidence. Protocol/pandemic changes yield Probably no with contrary evidence and an open point about declining surgery. Nearly complete data yield Yes. Unblinded assessors yield Yes, followed by Probably no based on death requiring no judgement. The analysis-plan row shows four context snippets and an open point about the missing dated protocol: No information, then Some concerns. There are no annotation arrows; the deciding 5.1 chip has a heavier outline. The footer gives 15 answered, 7 not needed and 16 quote records, the HTML report and independently verified audit file, and published/expert D5 judgements. The overall result is Some concerns. Official wording and the full trace are in eTable 1.

### Figure 3. 102 trials, four assessment arms and 154 adjudicated disagreements

Four assessment arms supplied the benchmark. The flow follows trial inclusion, domain and Overall labels, and selection for blinded adjudication. A cell is one trial × domain. Disputed cells differ from the published review label in at least one Sonnet arm. Consensus means both adjudicators selected the same label; split means their choices differed. The final branches identify cells where the two arms disagreed. Haiku analyses are supplementary.

Alt text: Trial inclusion flows into four assessment arms and adjudication, with separate consensus and split branches. Final boxes identify cells where the Sonnet arms disagreed.

### Figure 4. Published review labels were a weak reference: both systems agreed poorly with them, and most disputed-label errors were too lenient

Published review labels were often less severe than the adjudicators’ agreed choice. A, Domain-specific linearly weighted Cohen’s κ for the Sonnet arms against Published; the dashed line marks zero. Intervals are 95% percentile intervals from 10,000 trial-cluster bootstrap resamples stratified by meta-analysis (seed 20261018). B, Stacked bars compare Published with the adjudicators’ agreed choice among consensus disputed cells; segment labels are counts. This selected population cannot estimate published-label accuracy across the benchmark. Pooled agreement is in Table 2.

Alt text: Domain-specific agreement intervals overlap between systems. Published labels are usually less severe than the adjudicators’ agreed choice, especially for missing outcome data and selection of the reported result.

### Figure 5. When the two arms disagreed, the adjudicators chose ARBITER’s rating far more often

Adjudicators favoured ARBITER when the two arms disagreed. A, ARBITER win shares and 95% percentile intervals from 10,000 trial-cluster bootstrap resamples stratified by meta-analysis (seed 20261018); the dashed line marks equal preference. Scoring compares labels. The split sensitivity counts all split cells against ARBITER, without assigning them to Unassisted. B, Disagreements with the published review label, by source and direction. Bars exclude split cells; right labels give agreed-with-source counts, consensus denominators and splits. Other label means neither the source nor Published was selected. Full outcomes, post hoc severity strata and win-share sensitivities are in eTables 2–4.

Alt text: ARBITER win shares exceed the equal-preference line in all four analyses. Adjudicators usually agreed with ARBITER when it rated risk more strictly than Published.

### Figure 6. Most of the unassisted model’s localised losses traced to whether the analysis plan was fixed in advance

The analysis-plan question explained the largest share of localised Unassisted losses. Bars count loss cells by the question that alone changed the rating: replacing only that answer with the agreed independent answer changes the official algorithm output. Eligible cells are consensus losses where both adjudicators’ independent ratings equal their agreed choice. A cell may contribute to several question bars. Facet labels give eligible losses and cells without a single deciding question; those cells are not plotted. Complete frequencies, eligibility and loss classes are in eTables 5–7. Zero-count labels are omitted. D2 uses the effect-of-assignment algorithm.

Alt text: Paired bars compare loss cells by question within each domain. The analysis-plan question dominates Unassisted losses. Facet labels account for losses without a single deciding question.

### eFigure 1. Agreement with Published varied across meta-analyses

Weighted kappa and 95% CIs; source symbols distinguish model and assistance. Undefined coefficients are omitted. Specialty and topic identify each meta-analysis. Descriptive estimates only; no statistical tests. CI, confidence interval; 10,000 percentile bootstrap replicates, trials resampled within meta-analysis; seed 20261018.

Alt text: Agreement varies across meta-analyses, with overlapping uncertainty intervals for the assessment arms.

### eFigure 2. ARBITER-only choices outnumbered Unassisted-only choices

ARBITER-only choices were more frequent than Unassisted-only choices. Rows group disputed cells by disagreement with the published review label; columns show the adjudicators’ agreed choice or split. Counts use label equality; shared labels count as both arms preferred. A cell is one trial × domain.

Alt text: Disagreement patterns and the adjudicators’ agreed choices form a count matrix; split cells appear separately.

## Generated results sentences

The benchmark covered 102 trials assessed in 4 arms, with 154 domain disagreements reviewed independently (Figure 3).

Both systems agreed poorly with published review labels (weighted κ 0.34 and 0.28); Published was less severe than the adjudicators’ agreed choice in 78 of 129 consensus disputed cells (Figure 4).

When the two arms disagreed, both adjudicators chose ARBITER’s rating in 54 of 62 cells (87.1%; 95% CI 79.0–94.3; Figure 5).

The analysis-plan question alone changed the rating in 18 of 29 Unassisted losses with at least one such question; 18 further eligible losses had none (Figure 6).

16 meta-analyses across 15 specialties supplied 102 benchmark trials (Table 1).

ARBITER detected 66.3% of domain ratings the published reviews labelled Some concerns or High, compared with 50.6% for Unassisted (Table 2).

Without ARBITER, 65 of 509 evaluable domain ratings departed from the RoB 2 rules (12.8%; 95% CI 10.0–15.6; Table 3).

Before seeing any label, the adjudicators’ independent ratings agreed with ARBITER in 107 and 120 of 154 disputed cells (69.5% and 77.9%; Table 4).

ARBITER took a median [IQR] of 7.6 [6.1–10.5] minutes per trial versus 0.5 [0.4–0.5] for Unassisted; API list-price equivalents were US$3.78 [3.46–4.10] versus US$0.09 [0.07–0.13]. Paired mean differences were 11.0 (8.4–14.1) minutes and US$3.68 (3.61–3.75) (95% CIs; eTable 17).

## eTable renumbering map

| Former eTable | New eTable | Former title |
|---|---|---|
| 1 | 8 | Published label distributions by domain |
| 2 | 17 | Process metrics: Sonnet 5.5 |
| 3 | 17 | Process metrics: Haiku 5.5 |
| 4 | 9 | Agreement against Published, all sources and domains |
| 5 | 10 | Agreement against the composite reference, Sonnet only |
| 6 | 13 | RoB 2 consistency and structural audit, all sources and domains |
| 7 | 14 | Invalid answer path sensitivity |
| 8 | 18 | API cost reconstruction: estimates and bounds |
| 9 | 19 | Token reconciliation and compaction diagnostics |
| 10 | 20 | Confusion matrices against Published |
| 11 | 21 | Per-meta-analysis weighted κ |
| 12 | 3 | Post hoc severity-stratified win share |
| 13 | 2 | Vindicated disagreements with Published, including split cells |
| 14 | 4 | Per-adjudicator and split-cell win-share sensitivity |
| 15 | 11 | Paired differences against Published |
| 16 | 12 | Paired differences against the composite reference |
| 17 | 22 | Composite sensitivity using Adjudicator 1 |
| 18 | 23 | Composite paired differences using Adjudicator 1 |
| 19 | 22 | Composite sensitivity using Adjudicator 2 |
| 20 | 23 | Composite paired differences using Adjudicator 2 |
| 21 | 24 | Missing-judgement sensitivity: paired observed Haiku cells |
| 22 | 24 | Missing-judgement sensitivity: paired Haiku differences |
| 23 | 6 | Localisation population eligibility |
| 24 | 7 | Error-localisation classes, both populations |
| 25 | 5 | Decisive-question frequencies, both populations |
| 26 | 25 | Unresolved independent answer |
| 27 | 15 | Recorded model override |
| 28 | 26 | Quotation syntax in active justifications |
| 29 | 27 | Unassisted justification content |
| 30 | 28 | Exploratory signalling-answer agreement |
| 31 | 1 | AVATAR complete trace |

New: eTable 16 contains full reliability estimates including AC2 moved from main Table 4.

## Final supplementary titles

eTable 1. AVATAR complete trace
eTable 2. Adjudicators usually agreed with ARBITER when it disagreed with Published
eTable 3. Post hoc severity-stratified win share
eTable 4. Per-adjudicator and split-cell win-share sensitivity
eTable 5. Questions that alone changed the rating: frequencies, both populations
eTable 6. Localisation population eligibility
eTable 7. Error-localisation classes, both populations
eTable 8. Published label distributions by domain
eTable 9. Agreement against Published, all sources and domains
eTable 10. Agreement against the composite reference, Sonnet only
eTable 11. Paired differences against Published
eTable 12. Paired differences against the composite reference
eTable 13. RoB 2 consistency and structural audit, all sources and domains
eTable 14. Invalid answer path sensitivity
eTable 15. Recorded model override
eTable 16. Independent and selected ratings: full agreement including AC2
eTable 17. Time, cost and token use per trial by model
eTable 18. API cost reconstruction: estimates and bounds
eTable 19. Token reconciliation and compaction diagnostics
eTable 20. Confusion matrices against Published
eTable 21. Per-meta-analysis weighted κ
eTable 22. Composite-reference sensitivity estimates by adjudicator
eTable 23. Composite-reference paired differences by adjudicator
eTable 24. Haiku agreement after excluding missing judgements
eTable 25. Unresolved independent answer
eTable 26. Quotation syntax in active justifications
eTable 27. Unassisted justification content
eTable 28. Exploratory signalling-answer agreement

## Validation

- Full suite: 611 passing assertions in 67 test blocks; 0 failures, 0 errors, 0 test warnings and 0 skips.
- All 28 supplementary notes meet the 140-word ceiling (maximum 136 words); main Figure 3–6 legends are at most 140 words and alt text at most 80 words, enforced by tests.
- Full default Quarto render rebuilt statistical outputs; a final presentation-only render applied the last wording and cross-reference edits from the same CSVs. Both reports rendered successfully. ARBITER_PRESENTATION_ONLY=1 is an optional display iteration shortcut; the default still runs the full numerical pipeline.
- Native Microsoft Word export and all page PNGs were regenerated after the final document build. Four main tables remain one portrait page each; the checklist has two pages. Final supplement pagination and trace quote fidelity are recorded in qa/verification-round12.txt and qa/round12-pagination.json.
- Inspected every final supplement page, every main table/checklist page, all six changed figure PDFs and their greyscale/protanopia/deuteranopia/tritanopia previews at final physical dimensions. No clipping, overlap or wrapped main-table labels/values.
- Automated native Word PDF checks confirm every non-free-text main-table label/value occupies one baseline. Fonts are Arial 9 pt; AVATAR alone retains the existing landscape/8 pt exception.
- All six figure PDFs are 174 mm wide with embedded Fira Sans, minimum sizes 7.97, 7.97, 7.11, 7.97, 8.00 and 7.50 pt for Figures 3–6/eFigures 1–2; TIFFs are 600 dpi, LZW. All generated alt text and embedded current PNG bytes are checked.
- Extended banned-term/raw-code scans cover Word, figure PDFs, HTML and merged legends. All CSVs and protected files are unchanged from 48c7116. Complete verbatim evidence quotes remain present in the Word-rendered supplement.
- R startup locale warnings are environmental; testthat reports zero test warnings. No push was performed.

## Full supplementary footnotes

### eTable 1. AVATAR complete trace

Illustrative all-cause-death assessment (Banovic 2024). Part A gives all questions, answers, evidence types, justifications, unknowns, counterevidence and Unassisted rationales. — means none recorded in those fields; inactive questions follow branching. Part B preserves 16 archived records (15 cited by current answers). Quotes and rationales are verbatim; quote line breaks display as spaces. Source locations and hashes identify captured versions. References within quotations concern original documents. Full trace: analysis/data-derived/avatar-trace.json. CI, confidence interval; IQR, interquartile range; USD, US dollars; AC2, Gwet’s linearly weighted agreement coefficient; κ, linearly weighted Cohen’s kappa; RoB 2, risk of bias tool for randomised trials; D1–D5, its five domains; Y/PY, yes/probably yes; N/PN, no/probably no; NI, no information; NA, not applicable. All counts are numbers of the units named in the headers; — means undefined or not applicable.

### eTable 2. Adjudicators usually agreed with ARBITER when it disagreed with Published

Both sources use Sonnet 5.5. Figure 5B uses consensus disagreements as the denominator; split cells are displayed separately. Adjudicators agreed with it means their agreed choice equals the source label; Published upheld means their agreed choice equals the published review label; Other label means neither. Count is the outcome count; consensus n excludes split cells and All n includes them. CI, confidence interval; IQR, interquartile range; USD, US dollars; AC2, Gwet’s linearly weighted agreement coefficient; κ, linearly weighted Cohen’s kappa; RoB 2, risk of bias tool for randomised trials; D1–D5, its five domains; Y/PY, yes/probably yes; N/PN, no/probably no; NI, no information; NA, not applicable. All counts are numbers of the units named in the headers; — means undefined or not applicable.

### eTable 3. Post hoc severity-stratified win share

Post hoc Sonnet 5.5 analysis of consensus cells where the two arms disagreed, stratified by ARBITER severity relative to Unassisted. Fractions are label-based wins / cells in that severity stratum. CI, confidence interval; 10,000 percentile bootstrap replicates, trials resampled within meta-analysis; seed 20261018. CI, confidence interval; IQR, interquartile range; USD, US dollars; AC2, Gwet’s linearly weighted agreement coefficient; κ, linearly weighted Cohen’s kappa; RoB 2, risk of bias tool for randomised trials; D1–D5, its five domains; Y/PY, yes/probably yes; N/PN, no/probably no; NI, no information; NA, not applicable. All counts are numbers of the units named in the headers; — means undefined or not applicable.

### eTable 4. Per-adjudicator and split-cell win-share sensitivity

Fractions are label-based wins / cells where the two arms disagreed. Consensus is primary and includes only cells with the same choice from both adjudicators; each single-adjudicator analysis includes split cells. Split cells are forced ARBITER losses in the split sensitivity; Neither includes these forced losses. CI, confidence interval; 10,000 percentile bootstrap replicates, trials resampled within meta-analysis; seed 20261018. CI, confidence interval; IQR, interquartile range; USD, US dollars; AC2, Gwet’s linearly weighted agreement coefficient; κ, linearly weighted Cohen’s kappa; RoB 2, risk of bias tool for randomised trials; D1–D5, its five domains; Y/PY, yes/probably yes; N/PN, no/probably no; NI, no information; NA, not applicable. All counts are numbers of the units named in the headers; — means undefined or not applicable.

### eTable 5. Questions that alone changed the rating: frequencies, both populations

Counts of questions that alone changed the rating; all 22 questions are retained. A cell may contribute several. Jointly decisive sets contribute none. Short question texts follow the 2019 guidance; D2 uses effect of assignment. CI, confidence interval; IQR, interquartile range; USD, US dollars; AC2, Gwet’s linearly weighted agreement coefficient; κ, linearly weighted Cohen’s kappa; RoB 2, risk of bias tool for randomised trials; D1–D5, its five domains; Y/PY, yes/probably yes; N/PN, no/probably no; NI, no information; NA, not applicable. All counts are numbers of the units named in the headers; — means undefined or not applicable.

### eTable 6. Localisation population eligibility

Primary requires both independent judgements equal to the adjudicators’ agreed choice; sensitivity requires at least one. Published losses lack signalling answers. Haiku was not adjudicated. CI, confidence interval; IQR, interquartile range; USD, US dollars; AC2, Gwet’s linearly weighted agreement coefficient; κ, linearly weighted Cohen’s kappa; RoB 2, risk of bias tool for randomised trials; D1–D5, its five domains; Y/PY, yes/probably yes; N/PN, no/probably no; NI, no information; NA, not applicable. All counts are numbers of the units named in the headers; — means undefined or not applicable.

### eTable 7. Error-localisation classes, both populations

Counts of losing cells. First applicable class is assigned; classes sum to eligible losses. No-discordance can include adjudicator disagreements, flagged separately. CI, confidence interval; IQR, interquartile range; USD, US dollars; AC2, Gwet’s linearly weighted agreement coefficient; κ, linearly weighted Cohen’s kappa; RoB 2, risk of bias tool for randomised trials; D1–D5, its five domains; Y/PY, yes/probably yes; N/PN, no/probably no; NI, no information; NA, not applicable. All counts are numbers of the units named in the headers; — means undefined or not applicable.

### eTable 8. Published label distributions by domain

Each D1–D5 cell gives Low / Some concerns / High counts; 102 trials. Source journals and years are in main Table 1. ACL, anterior cruciate ligament; CDK4/6, cyclin-dependent kinases 4 and 6; eGFR, estimated glomerular filtration rate; GLP-1, glucagon-like peptide-1; HER2, human epidermal growth factor receptor 2; HR, hormone receptor; IgA, immunoglobulin A; SGLT2, sodium-glucose cotransporter 2. CI, confidence interval; IQR, interquartile range; USD, US dollars; AC2, Gwet’s linearly weighted agreement coefficient; κ, linearly weighted Cohen’s kappa; RoB 2, risk of bias tool for randomised trials; D1–D5, its five domains; Y/PY, yes/probably yes; N/PN, no/probably no; NI, no information; NA, not applicable. All counts are numbers of the units named in the headers; — means undefined or not applicable.

### eTable 9. Agreement against Published, all sources and domains

Linearly weighted Cohen’s κ and Gwet’s AC2. Exact agreement, sensitivity and specificity are n/N (%); their CI bounds are percentages. Some concerns or High is the positive class. All-Low rule has no variance; only accuracy and specificity are reported. Paired differences are on the coefficient scale or in percentage points; — indicates undefined or not applicable. CI, confidence interval; 10,000 percentile bootstrap replicates, trials resampled within meta-analysis; seed 20261018. CI, confidence interval; IQR, interquartile range; USD, US dollars; AC2, Gwet’s linearly weighted agreement coefficient; κ, linearly weighted Cohen’s kappa; RoB 2, risk of bias tool for randomised trials; D1–D5, its five domains; Y/PY, yes/probably yes; N/PN, no/probably no; NI, no information; NA, not applicable. All counts are numbers of the units named in the headers; — means undefined or not applicable.

### eTable 10. Agreement against the composite reference, Sonnet only

Linearly weighted κ and AC2; exact agreement is n/N (%), with CI bounds in percent. The composite uses the adjudicators’ agreed choice on consensus disputed cells and Published elsewhere; split cells are excluded. Adjudicators chose among three offered labels. Cells where both arms matched Published were never adjudicated and are assumed correct. Both features inflate absolute composite values. CI, confidence interval; 10,000 percentile bootstrap replicates, trials resampled within meta-analysis; seed 20261018. CI, confidence interval; IQR, interquartile range; USD, US dollars; AC2, Gwet’s linearly weighted agreement coefficient; κ, linearly weighted Cohen’s kappa; RoB 2, risk of bias tool for randomised trials; D1–D5, its five domains; Y/PY, yes/probably yes; N/PN, no/probably no; NI, no information; NA, not applicable. All counts are numbers of the units named in the headers; — means undefined or not applicable.

### eTable 11. Paired differences against Published

ARBITER minus Unassisted; coefficients in original units, proportions in percentage points.  CI, confidence interval; 10,000 percentile bootstrap replicates, trials resampled within meta-analysis; seed 20261018. CI, confidence interval; IQR, interquartile range; USD, US dollars; AC2, Gwet’s linearly weighted agreement coefficient; κ, linearly weighted Cohen’s kappa; RoB 2, risk of bias tool for randomised trials; D1–D5, its five domains; Y/PY, yes/probably yes; N/PN, no/probably no; NI, no information; NA, not applicable. All counts are numbers of the units named in the headers; — means undefined or not applicable.

### eTable 12. Paired differences against the composite reference

ARBITER minus Unassisted; coefficients in original units, proportions in percentage points. Composite reference: the adjudicators’ agreed choice on consensus cells, Published on other cells; 25 split cells excluded (485 cells per arm). Adjudicators could only choose among the three labels offered. Cells where both Sonnet arms matched Published were never adjudicated and are assumed correct. Both features inflate absolute composite values. CI, confidence interval; 10,000 percentile bootstrap replicates, trials resampled within meta-analysis; seed 20261018. CI, confidence interval; IQR, interquartile range; USD, US dollars; AC2, Gwet’s linearly weighted agreement coefficient; κ, linearly weighted Cohen’s kappa; RoB 2, risk of bias tool for randomised trials; D1–D5, its five domains; Y/PY, yes/probably yes; N/PN, no/probably no; NI, no information; NA, not applicable. All counts are numbers of the units named in the headers; — means undefined or not applicable.

### eTable 13. RoB 2 consistency and structural audit, all sources and domains

Values are n/N (%). Proposed judgements determine ARBITER domain consistency; adopted overrides are separate. Overall exact worst-domain agreement and permitted escalation are separate. Evidence coverage uses active signalling answers as the denominator and answers citing at least one evidence record as the numerator. Unassisted and Published evidence traces are unavailable. Binding and independent verification are structural checks, not clinical correctness. Visual transcriptions are model-written and not checked against images. CI, confidence interval; IQR, interquartile range; USD, US dollars; AC2, Gwet’s linearly weighted agreement coefficient; κ, linearly weighted Cohen’s kappa; RoB 2, risk of bias tool for randomised trials; D1–D5, its five domains; Y/PY, yes/probably yes; N/PN, no/probably no; NI, no information; NA, not applicable. All counts are numbers of the units named in the headers; — means undefined or not applicable.

### eTable 14. Invalid answer path sensitivity

Required invalid answers recursively resolve as N/PN then NI, including newly required questions. No off-path imputation; these are counts, not new assessments. CI, confidence interval; IQR, interquartile range; USD, US dollars; AC2, Gwet’s linearly weighted agreement coefficient; κ, linearly weighted Cohen’s kappa; RoB 2, risk of bias tool for randomised trials; D1–D5, its five domains; Y/PY, yes/probably yes; N/PN, no/probably no; NI, no information; NA, not applicable. All counts are numbers of the units named in the headers; — means undefined or not applicable.

### eTable 15. Recorded model override

Hill 2017 D1: 1.1 = NI, 1.2 = PY, 1.3 = N. Proposed Low; adopted Some concerns. Answer codes and clinical balance terminology are expanded for readability; the original rationale remains in the accompanying CSV. The rationale is model text, not endorsed guidance. Evidence identities remain in the accompanying CSV. CI, confidence interval; IQR, interquartile range; USD, US dollars; AC2, Gwet’s linearly weighted agreement coefficient; κ, linearly weighted Cohen’s kappa; RoB 2, risk of bias tool for randomised trials; D1–D5, its five domains; Y/PY, yes/probably yes; N/PN, no/probably no; NI, no information; NA, not applicable. All counts are numbers of the units named in the headers; — means undefined or not applicable.

### eTable 16. Independent and selected ratings: full agreement including AC2

154 disputed cells per comparison, selected because at least one Sonnet arm differed from the published review label. Independent ratings preceded label presentation; selected ratings chose among three offered labels. κ and AC2 are linearly weighted; raw agreement is n/N (%), with CI bounds in percent. This selected population cannot estimate full-benchmark agreement. CI, confidence interval; 10,000 percentile bootstrap replicates, trials resampled within meta-analysis; seed 20261018. CI, confidence interval; IQR, interquartile range; USD, US dollars; AC2, Gwet’s linearly weighted agreement coefficient; κ, linearly weighted Cohen’s kappa; RoB 2, risk of bias tool for randomised trials; D1–D5, its five domains; Y/PY, yes/probably yes; N/PN, no/probably no; NI, no information; NA, not applicable. All counts are numbers of the units named in the headers; — means undefined or not applicable.

### eTable 17. Time, cost and token use per trial by model

102 trials per arm; per-trial median [IQR] and paired mean ARBITER minus Unassisted difference (95% CI). USD denotes API list-price equivalent, not expenditure; thinking is included in output. CI, confidence interval; 10,000 percentile bootstrap replicates, trials resampled within meta-analysis; seed 20261018. CI, confidence interval; IQR, interquartile range; USD, US dollars; AC2, Gwet’s linearly weighted agreement coefficient; κ, linearly weighted Cohen’s kappa; RoB 2, risk of bias tool for randomised trials; D1–D5, its five domains; Y/PY, yes/probably yes; N/PN, no/probably no; NI, no information; NA, not applicable. All counts are numbers of the units named in the headers; — means undefined or not applicable.

### eTable 18. API cost reconstruction: estimates and bounds

USD. Reconstruction bounds are not sampling CIs. Five-minute side-call cache writes are a sensitivity. Harness figures are unusable: unrecognised model and unknown cost basis. CI, confidence interval; IQR, interquartile range; USD, US dollars; AC2, Gwet’s linearly weighted agreement coefficient; κ, linearly weighted Cohen’s kappa; RoB 2, risk of bias tool for randomised trials; D1–D5, its five domains; Y/PY, yes/probably yes; N/PN, no/probably no; NI, no information; NA, not applicable. All counts are numbers of the units named in the headers; — means undefined or not applicable.

### eTable 19. Token reconciliation and compaction diagnostics

Token totals across trials. Terminal minus request is signed, including retry residuals. Side calls are total model usage minus terminal usage; output already includes thinking. CI, confidence interval; IQR, interquartile range; USD, US dollars; AC2, Gwet’s linearly weighted agreement coefficient; κ, linearly weighted Cohen’s kappa; RoB 2, risk of bias tool for randomised trials; D1–D5, its five domains; Y/PY, yes/probably yes; N/PN, no/probably no; NI, no information; NA, not applicable. All counts are numbers of the units named in the headers; — means undefined or not applicable.

### eTable 20. Confusion matrices against Published

Each grid contains counts of cells: Published rows × predicted columns, ordered Low / Some concerns / High. Missing predictions appear only when nonzero. Overall uses the 81 labelled trials. CI, confidence interval; IQR, interquartile range; USD, US dollars; AC2, Gwet’s linearly weighted agreement coefficient; κ, linearly weighted Cohen’s kappa; RoB 2, risk of bias tool for randomised trials; D1–D5, its five domains; Y/PY, yes/probably yes; N/PN, no/probably no; NI, no information; NA, not applicable. All counts are numbers of the units named in the headers; — means undefined or not applicable.

### eTable 21. Per-meta-analysis weighted κ

ACL, anterior cruciate ligament; CDK4/6, cyclin-dependent kinases 4 and 6; eGFR, estimated glomerular filtration rate; GLP-1, glucagon-like peptide-1; HER2, human epidermal growth factor receptor 2; HR, hormone receptor; IgA, immunoglobulin A; SGLT2, sodium-glucose cotransporter 2. Weighted κ (95% CI). eFigure 1 displays the defined nondegenerate estimates. A coefficient with no variance, or a degenerate bootstrap interval, is shown as —. CI, confidence interval; 10,000 percentile bootstrap replicates, trials resampled within meta-analysis; seed 20261018. CI, confidence interval; IQR, interquartile range; USD, US dollars; AC2, Gwet’s linearly weighted agreement coefficient; κ, linearly weighted Cohen’s kappa; RoB 2, risk of bias tool for randomised trials; D1–D5, its five domains; Y/PY, yes/probably yes; N/PN, no/probably no; NI, no information; NA, not applicable. All counts are numbers of the units named in the headers; — means undefined or not applicable.

### eTable 22. Composite-reference sensitivity estimates by adjudicator

510 cells per Sonnet arm. Each adjudicator’s selected label replaces Published on disputed cells. Only three labels were offered; unadjudicated cells are assumed correct. CI, confidence interval; 10,000 percentile bootstrap replicates, trials resampled within meta-analysis; seed 20261018. CI, confidence interval; IQR, interquartile range; USD, US dollars; AC2, Gwet’s linearly weighted agreement coefficient; κ, linearly weighted Cohen’s kappa; RoB 2, risk of bias tool for randomised trials; D1–D5, its five domains; Y/PY, yes/probably yes; N/PN, no/probably no; NI, no information; NA, not applicable. All counts are numbers of the units named in the headers; — means undefined or not applicable.

### eTable 23. Composite-reference paired differences by adjudicator

ARBITER minus Unassisted, coefficient units or percentage points; 510 paired cells per arm. Only offered labels could be chosen; unadjudicated cells are assumed correct. CI, confidence interval; 10,000 percentile bootstrap replicates, trials resampled within meta-analysis; seed 20261018. CI, confidence interval; IQR, interquartile range; USD, US dollars; AC2, Gwet’s linearly weighted agreement coefficient; κ, linearly weighted Cohen’s kappa; RoB 2, risk of bias tool for randomised trials; D1–D5, its five domains; Y/PY, yes/probably yes; N/PN, no/probably no; NI, no information; NA, not applicable. All counts are numbers of the units named in the headers; — means undefined or not applicable.

### eTable 24. Haiku agreement after excluding missing judgements

Both Haiku arms exclude the same missing domain and Overall cells. Fractions give eligible-cell denominators. Sensitivity uses Some concerns or High as positive; specificity uses Low. κ and AC2 are linearly weighted. Paired differences use coefficient units or percentage points. CI, confidence interval; 10,000 percentile bootstrap replicates, trials resampled within meta-analysis; seed 20261018. CI, confidence interval; IQR, interquartile range; USD, US dollars; AC2, Gwet’s linearly weighted agreement coefficient; κ, linearly weighted Cohen’s kappa; RoB 2, risk of bias tool for randomised trials; D1–D5, its five domains; Y/PY, yes/probably yes; N/PN, no/probably no; NI, no information; NA, not applicable. All counts are numbers of the units named in the headers; — means undefined or not applicable.

### eTable 25. Unresolved independent answer

The qualified answer is preserved without selecting a time point. This cell is outside both localisation populations because neither independent judgement equals the adjudicators’ agreed choice. CI, confidence interval; IQR, interquartile range; USD, US dollars; AC2, Gwet’s linearly weighted agreement coefficient; κ, linearly weighted Cohen’s kappa; RoB 2, risk of bias tool for randomised trials; D1–D5, its five domains; Y/PY, yes/probably yes; N/PN, no/probably no; NI, no information; NA, not applicable. All counts are numbers of the units named in the headers; — means undefined or not applicable.

### eTable 26. Quotation syntax in active justifications

Quoted active answers / all active answers. Paired double quotes enclose at least five words. Syntax is not verification and understates ARBITER bundle-based grounding. CI, confidence interval; 10,000 percentile bootstrap replicates, trials resampled within meta-analysis; seed 20261018. CI, confidence interval; IQR, interquartile range; USD, US dollars; AC2, Gwet’s linearly weighted agreement coefficient; κ, linearly weighted Cohen’s kappa; RoB 2, risk of bias tool for randomised trials; D1–D5, its five domains; Y/PY, yes/probably yes; N/PN, no/probably no; NI, no information; NA, not applicable. All counts are numbers of the units named in the headers; — means undefined or not applicable.

### eTable 27. Unassisted justification content

Codes are Y, PY, PN, N, NI or NA. This describes exported fields without inferring absent reasoning. CI, confidence interval; IQR, interquartile range; USD, US dollars; AC2, Gwet’s linearly weighted agreement coefficient; κ, linearly weighted Cohen’s kappa; RoB 2, risk of bias tool for randomised trials; D1–D5, its five domains; Y/PY, yes/probably yes; N/PN, no/probably no; NI, no information; NA, not applicable. All counts are numbers of the units named in the headers; — means undefined or not applicable.

### eTable 28. Exploratory signalling-answer agreement

Correct collapsed answers / eligible questions (95% CI) on disputed domains. Independent answers define reference; Y/PY, N/PN, NI/NA collapse. Missing predictions are wrong. Includes Haiku without a preferred-judgement endpoint. CI, confidence interval; 10,000 percentile bootstrap replicates, trials resampled within meta-analysis; seed 20261018. CI, confidence interval; IQR, interquartile range; USD, US dollars; AC2, Gwet’s linearly weighted agreement coefficient; κ, linearly weighted Cohen’s kappa; RoB 2, risk of bias tool for randomised trials; D1–D5, its five domains; Y/PY, yes/probably yes; N/PN, no/probably no; NI, no information; NA, not applicable. All counts are numbers of the units named in the headers; — means undefined or not applicable.
