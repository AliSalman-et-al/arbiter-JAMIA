# Figure legends

## Figure 1. ARBITER splits the work: an AI model reads and answers; rule-based software checks quotes, applies RoB 2 rules and records everything

**Figure 1. ARBITER splits the work: an AI model reads and answers; rule-based software checks quotes, applies RoB 2 rules and records everything.** Lanes show the reviewer, AI model, ARBITER server and audit file across capture, approval, domain assessment and export. Plain labels show actions; grey text names the underlying tool calls. The reviewer receives the HTML report and audit file, both checkable by an independent verifier. Across the 102 trials, the server rejected 53 of 637 save attempts with incomplete or unbound answers, and every affected domain was saved after resubmission. RoB 2 is the Cochrane risk-of-bias tool for randomised trials.

Alt text: The reviewer chooses a trial and outcome and approves the result to assess. The AI model reads reports, selects evidence and answers questions. ARBITER stores source records, checks quotes and applies the RoB 2 rules. The reviewer receives an HTML assessment report and an audit file containing sources, quotes, answers and decisions; both can be checked by an independent verifier.

## Figure 2. Each answer is tied to stored sources, and RoB 2 rules compute the rating across every domain

**Figure 2. Each answer is tied to stored sources, and RoB 2 rules compute the rating across every domain.** AVATAR compares early surgery with watchful waiting in asymptomatic severe aortic stenosis; the outcome is all-cause death. This trial was chosen to illustrate the process, not as representative. Rows link paraphrased questions, source excerpts, AI answers, software checks and domain ratings. Letter/page tabs identify sources; “Weighed against” and “Open point” give counter-evidence and unknowns. A missing dated analysis plan leads to Some concerns overall. Full answers and official question wording appear in eTable 1. Y, yes; PY, probably yes; PN, probably no; N, no; NI, no information.

Alt text: AVATAR's five risk-of-bias domains connect source excerpts to the AI model's answers and the ratings computed by ARBITER. Four domains are Low. For selection of the reported result, the stored sources do not establish a dated plan for this analysis. The model answers No information, and the RoB 2 rules yield Some concerns for that domain and overall. Counter-evidence and unresolved questions remain visible alongside the answers.

## Figure 3. 102 trials, four assessment arms and 154 adjudicated disagreements

Four assessment arms supplied the benchmark. The flow follows trial inclusion, domain and Overall ratings, and selection for blinded adjudication. A cell is one trial × domain. Ratings were reviewed when at least one Sonnet arm differed from the published review label. The branches show whether both adjudicators agreed or their choices differed, then identify cells where the two arms disagreed. Haiku analyses are supplementary.

Alt text: Trial inclusion flows into four assessment arms and adjudication. Separate branches show both adjudicators agreeing or choosing different labels, then identify cells where the Sonnet arms disagreed.

## Figure 4. Published review labels were a weak reference: both systems agreed poorly with them, and most disputed-label errors were too lenient

Published review labels were often less severe than the adjudicators’ agreed choice. A, Domain-specific linearly weighted Cohen’s κ for the Sonnet arms against published labels; the dashed line marks zero. Intervals are 95% percentile intervals from 10,000 trial-cluster bootstrap resamples stratified by meta-analysis (seed 20261018). B, Bars compare published labels with the adjudicators’ agreed choice where both adjudicators agreed; segment labels give counts, with directions named on the All bar. This selected population cannot estimate published-label accuracy across the benchmark. Pooled agreement is in Table 2.

Alt text: Domain-specific agreement intervals overlap between systems. Published labels are usually less severe than the adjudicators’ agreed choice, especially for missing outcome data and selection of the reported result.

## Figure 5. When the two arms disagreed, the adjudicators chose ARBITER’s rating far more often

Adjudicators favoured ARBITER when the two arms disagreed. A, Percentages choosing ARBITER and 95% percentile intervals from 10,000 trial-cluster bootstrap resamples stratified by meta-analysis (seed 20261018); the dashed line marks equal choice. Scoring compares labels. The sensitivity counts every divided decision against ARBITER, without assigning it to Unassisted. B, Disagreements with the published review label by source and direction, excluding divided decisions. Right labels give agreed-with-source counts, denominators and divided decisions. Other label means neither the source nor published label was chosen. Full outcomes, post hoc severity strata and sensitivities are in eTables 2–4.

Alt text: Adjudicators chose ARBITER more often than Unassisted in all four analyses. They usually agreed with ARBITER when it rated risk more strictly than the published review.

## Figure 6. Most of the unassisted model’s localised losses traced to whether the analysis plan was fixed in advance

The analysis-plan question explained the largest share of localised Unassisted losses. Bars count ratings the adjudicators did not choose, by the question that alone changed the rating: replacing only that answer with the agreed independent answer changes the official algorithm output. Eligible ratings require both adjudicators’ independent ratings to equal their agreed choice. A rating may contribute to several bars. Facet labels give eligible totals and ratings without a single deciding question; those ratings are not plotted. Frequencies, eligibility and explanations are in eTables 5–7. Zero-count labels are omitted. D2 uses the effect-of-assignment algorithm.

Alt text: Paired bars compare ratings the adjudicators did not choose by question within each domain. The analysis-plan question dominates Unassisted losses. Facet labels account for ratings without a single deciding question.
