figure_legend_sections <- function() list(
  'Figure 1. ARBITER workflow'='Legend supplied in legends-fig1-2.md',
  'Figure 2. One trial, end to end'='Legend supplied in legends-fig1-2.md',
  'Figure 3. Benchmark inclusion and adjudication flow'=paste(
    'Sixteen meta-analyses supplied 105 trials. Three unsupported-design trials were excluded from every arm and analysis. Four arms each assessed the 102 included trials: ARBITER and Unassisted with Sonnet 5.5 (main analysis), and with Haiku 5.5 (supplement). There are 510 D1–D5 cells per arm and 81 Published Overall labels. Of 154 disputed cells, 129 had consensus and 25 were split. The Sonnet arms differed on 62 consensus cells (54 ARBITER wins, 7 Unassisted, 1 neither) and 18 split cells.',
    '\n\nAlt text: A centred flow diagram follows 105 trials through three exclusions to four arms of 102 trials, then 154 disputed cells and the consensus and split branches.'),
  'Figure 4. Published labels are a weak reference'=paste(
    'A, Linearly weighted Cohen’s κ against Published, by domain and pooled D1–D5, for both Sonnet arms with 95% stratified trial-cluster bootstrap CIs (10,000 replicates; seed 20261018). The dashed zero line marks agreement expected by chance. B, Each 100% bar shows Published less severe, equal or more severe than the consensus preferred judgement. Segment counts are D1 9/2/7, D2 11/11/10, D3 19/5/0, D4 9/3/2, D5 30/8/3 and All 78/29/22. This selected disputed set cannot estimate published-label accuracy in the full benchmark. The composite reference is reported in Table 2.',
    '\n\nAlt text: Domain-level κ intervals overlap between sources. Grey stacked bars show that Published is less severe than preferred in 78 of 129 consensus disputed cells, including 30 of 41 D5 cells and 19 of 24 D3 cells.'),
  'Figure 5. Blinded adjudicators prefer ARBITER on discordant judgements'=paste(
    'A, ARBITER win share with 95% percentile CIs from 10,000 trial-cluster bootstrap resamples stratified by meta-analysis (seed 20261018). The dashed 50% line denotes no preference. Counts at right are ARBITER / Unassisted / neither and N: consensus 54/7/1 of 62; Adjudicator 1, 60/16/4 of 80; Adjudicator 2, 64/15/1 of 80; split sensitivity, 54/7/19 of 80. Neither in the sensitivity includes 18 split cells forced against ARBITER without inventing Unassisted wins. B, Consensus disagreements with Published by source and direction, partitioned into vindicated (preferred equals source), Published upheld and other label. Splits are excluded from bar denominators and given separately at right. Right-hand values are vindicated/consensus N (Published upheld, other label); split count. Segment labels below 3 are omitted for readability. Vindicated counts are ARBITER more severe 73/77 and less severe 22/28 (95/105 overall); Unassisted 48/59 and 19/38 (67/97). The full counts, including splits, the former disagreement-pattern matrix and a post hoc severity-stratified win-share analysis are in the supplement. All scoring uses label equality, not blinded reviewer letters.',
    '\n\nAlt text: Four blue point estimates show ARBITER win shares with uncertainty. Below, blue or orange vindicated segments dominate the consensus disagreements, especially when ARBITER is more severe than Published; split counts accompany each row.'),
  'Figure 6. Individually decisive signalling questions behind consensus losses'=paste(
    'Paired bars show individually decisive questions among consensus losses where both independent judgements equal the consensus preferred judgement (10 ARBITER and 47 Unassisted losses). ARBITER appears above Unassisted. Facet labels give eligible losses. A question is decisive if substituting the unanimously agreed independent answer alone changes the official algorithm output. The grey row counts cells without any individually decisive question, including jointly decisive cells. A cell can contribute several question bars: reconciliation is the number of distinct cells contributing at least one question plus cells in the grey row, not the sum of question frequencies. Zero-count labels are omitted. D2 uses effect of assignment.',
    '\n\nAlt text: Domain facets compare sources on decisive questions and add a grey remainder row for cells with no individually decisive question. Question 5.1 is the most frequent Unassisted decisive question.')
)
build_figure_legends <- function() {
  sections <- figure_legend_sections()
  text <- c('# Figure legends','',unlist(lapply(seq_along(sections),function(i) c(paste('##',names(sections)[i]),'',sections[[i]],''))))
  text <- gsub('[ \t]+\n','\n',text)
  text <- sub('\n+$','',text)
  text <- text[seq_len(max(which(nzchar(text))))]
  writeLines(enc2utf8(text),'output/manuscript/figure-legends.md',useBytes=TRUE)
}
