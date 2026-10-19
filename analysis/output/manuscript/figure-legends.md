# Figure legends

## Figure 1. ARBITER splits the work: an AI model reads and answers; rule-based software checks quotes, applies RoB 2 rules and records everything

**Figure 1. ARBITER splits the work: an AI model reads and answers; rule-based software checks quotes, applies RoB 2 rules and records everything.** Lanes show the reviewer, AI model, ARBITER server and audit file across capture, approval, domain assessment and export. Plain labels show actions; grey text names the underlying tool calls. The reviewer receives the HTML report and audit file, both checkable by an independent verifier. Across the 102 trials, the server rejected 53 of 637 save attempts with incomplete or unbound answers, and every affected domain was saved after resubmission. RoB 2 is the Cochrane risk-of-bias tool for randomised trials.

Alt text: The reviewer chooses a trial and outcome and approves the result to assess. The AI model reads reports, selects evidence and answers questions. ARBITER stores source records, checks quotes and applies the RoB 2 rules. The reviewer receives an HTML assessment report and an audit file containing sources, quotes, answers and decisions; both can be checked by an independent verifier.

## Figure 2. Each answer is tied to stored sources, and RoB 2 rules compute the rating across every domain

**Figure 2. Each answer is tied to stored sources, and RoB 2 rules compute the rating across every domain.** AVATAR compares early surgery with watchful waiting in asymptomatic severe aortic stenosis; the outcome is all-cause death. This trial was chosen to illustrate the process, not as representative. Rows link paraphrased questions, source excerpts, AI answers, software checks and domain ratings. Letter/page tabs identify sources; “Weighed against” and “Open point” give counter-evidence and unknowns. A missing dated analysis plan leads to Some concerns overall. Full answers and official question wording appear in eTable 3. Y, yes; PY, probably yes; PN, probably no; N, no; NI, no information.

Alt text: AVATAR's five risk-of-bias domains connect source excerpts to the AI model's answers and the ratings computed by ARBITER. Four domains are Low. For selection of the reported result, the stored sources do not establish a dated plan for this analysis. The model answers No information, and the RoB 2 rules yield Some concerns for that domain and overall. Counter-evidence and unresolved questions remain visible alongside the answers.

## Figure 3. Two assessment arms supplied 102 trials and 154 adjudicated disagreements

Two assessment arms supplied the benchmark. The flow follows trial inclusion, domain and Overall ratings, and selection for blinded adjudication. A cell is one trial × domain. Ratings were reviewed when at least one arm differed from the published review label. Branches show whether both adjudicators agreed, then identify cells where the two arms disagreed.

Alt text: Trial inclusion flows into two assessment arms and blinded adjudication, with separate branches for agreement and split decisions.

## Figure 4. Both models agreed poorly with published labels; adjudicators usually upheld stricter ratings (post hoc panel B)

Both models agreed poorly with published labels, but adjudicators usually upheld stricter ratings. A, Domain-specific linearly weighted Cohen’s κ against published labels; the dashed line marks zero. B, Post hoc shares of disagreements where the adjudicators’ agreed choice equals the model rating, by direction relative to Published. Labels give n/N and split decisions excluded from denominators. Points and bars show estimates and 95% percentile intervals from 10,000 trial-cluster bootstrap resamples within meta-analysis (seed 20261018). This selected population cannot estimate full-benchmark accuracy. Pooled agreement is in Table 1.

Alt text: Domain agreement intervals overlap. Post hoc adjudicator agreement is highest for stricter ARBITER ratings, followed by stricter Unassisted ratings.

## Figure 5. Adjudicators chose ARBITER far more often when the arms disagreed, including post hoc strictness strata

Adjudicators favoured ARBITER when the arms disagreed. The first four rows show the primary estimate and sensitivities; the separate post hoc group stratifies by which arm was stricter. Points and bars show the share choosing ARBITER and 95% percentile intervals from 10,000 trial-cluster bootstrap resamples within meta-analysis (seed 20261018). The dashed line marks equal choice. Scoring compares labels. The split sensitivity counts every split against ARBITER without assigning it to Unassisted. Right labels give counts. Full outcomes and post hoc strata are in eTables 15–16.

Alt text: Adjudicators chose ARBITER in most disagreements in the primary and sensitivity analyses. The post hoc stricter ARBITER stratum has the highest win share.

## Figure 6. Most localised Unassisted losses traced to whether the analysis plan was fixed in advance

The analysis-plan question explained the largest share of localised Unassisted losses. Bars count ratings the adjudicators did not choose, by the question that alone changed the rating: replacing that answer with the agreed independent answer changes the official algorithm output. Eligibility requires both independent ratings to equal the agreed choice. A rating may contribute to several bars. Facet labels give eligible totals and ratings without a single deciding question. D2 uses the effect-of-assignment algorithm. Frequencies and eligibility are in eTables 18–20; the post hoc rules-only recomputation is in eTable 22.

Alt text: Bars compare losses by question within domains. The analysis-plan question dominates Unassisted losses. Facet totals include ratings without a single deciding question.
