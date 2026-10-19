supplied_figure_legends <- function(path='output/manuscript/legends-fig1-2.md') {
  lines <- readLines(path,warn=FALSE,encoding='UTF-8')
  lines <- gsub('{{eTable:avatar-trace}}',paste('eTable',supplement_number('AVATAR complete trace')),lines,fixed=TRUE)
  # Compatibility for the pre-handoff file: keep provenance in its notes, not the manuscript.
  lines <- lines[!startsWith(lines,'The independent verifier checks archive structure')]
  lines <- gsub('eTable 31',paste('eTable',supplement_number('AVATAR complete trace')),lines,fixed=TRUE)
  lines <- gsub('Baseline differences','Preintervention differences',lines,fixed=TRUE)
  starts <- grep('^\\*\\*Figure [12][.]',lines)
  stopifnot(length(starts)==2L)
  ends <- c(starts[2]-1L,length(lines))
  setNames(lapply(seq_along(starts),function(i) {
    part <- lines[starts[i]:ends[i]]
    part <- part[!startsWith(part,'For the version without')]
    paste(part,collapse='\n')
  }),sub('^\\*\\*(Figure [12][.] .*?)\\.\\*\\*.*$','\\1',lines[starts]))
}
figure_legend_sections <- function() c(supplied_figure_legends(),list(
  'Figure 3. 102 trials, four assessment arms and 154 adjudicated disagreements'=paste(
    'Four assessment arms supplied the benchmark. The flow follows trial inclusion, domain and Overall ratings, and selection for blinded adjudication. A cell is one trial × domain. Ratings were reviewed when at least one Sonnet arm differed from the published review label. The branches show whether both adjudicators agreed or their choices differed, then identify cells where the two arms disagreed. Haiku analyses are supplementary.',
    '\n\nAlt text: Trial inclusion flows into four assessment arms and adjudication. Separate branches show both adjudicators agreeing or choosing different labels, then identify cells where the Sonnet arms disagreed.'),
  'Figure 4. Published review labels were a weak reference: both systems agreed poorly with them, and most disputed-label errors were too lenient'=paste(
    'Published review labels were often less severe than the adjudicators’ agreed choice. A, Domain-specific linearly weighted Cohen’s κ for the Sonnet arms against published labels; the dashed line marks zero. Intervals are 95% percentile intervals from 10,000 trial-cluster bootstrap resamples stratified by meta-analysis (seed 20261018). B, Bars compare published labels with the adjudicators’ agreed choice where both adjudicators agreed; segment labels give counts, with directions named on the All bar. This selected population cannot estimate published-label accuracy across the benchmark. Pooled agreement is in Table 2.',
    '\n\nAlt text: Domain-specific agreement intervals overlap between systems. Published labels are usually less severe than the adjudicators’ agreed choice, especially for missing outcome data and selection of the reported result.'),
  'Figure 5. When the two arms disagreed, the adjudicators chose ARBITER’s rating far more often'=paste(
    'Adjudicators favoured ARBITER when the two arms disagreed. A, Percentages choosing ARBITER and 95% percentile intervals from 10,000 trial-cluster bootstrap resamples stratified by meta-analysis (seed 20261018); the dashed line marks equal choice. Scoring compares labels. The sensitivity counts every divided decision against ARBITER, without assigning it to Unassisted. B, Disagreements with the published review label by source and direction, excluding divided decisions. Right labels give agreed-with-source counts, denominators and divided decisions. Other label means neither the source nor published label was chosen. Full outcomes, post hoc severity strata and sensitivities are in eTables 2–4.',
    '\n\nAlt text: Adjudicators chose ARBITER more often than Unassisted in all four analyses. They usually agreed with ARBITER when it rated risk more strictly than the published review.'),
  'Figure 6. Most of the unassisted model’s localised losses traced to whether the analysis plan was fixed in advance'=paste(
    'The analysis-plan question explained the largest share of localised Unassisted losses. Bars count ratings the adjudicators did not choose, by the question that alone changed the rating: replacing only that answer with the agreed independent answer changes the official algorithm output. Eligible ratings require both adjudicators’ independent ratings to equal their agreed choice. A rating may contribute to several bars. Facet labels give eligible totals and ratings without a single deciding question; those ratings are not plotted. Frequencies, eligibility and explanations are in eTables 5–7. Zero-count labels are omitted. D2 uses the effect-of-assignment algorithm.',
    '\n\nAlt text: Paired bars compare ratings the adjudicators did not choose by question within each domain. The analysis-plan question dominates Unassisted losses. Facet labels account for ratings without a single deciding question.')
))
build_figure_legends <- function() {
  sections <- figure_legend_sections()
  text <- c('# Figure legends','',unlist(lapply(seq_along(sections),function(i) c(paste('##',names(sections)[i]),'',sections[[i]],''))))
  text <- gsub('[ \t]+\n','\n',text)
  text <- sub('\n+$','',text)
  text <- text[seq_len(max(which(nzchar(text))))]
  writeLines(enc2utf8(text),'output/manuscript/figure-legends.md',useBytes=TRUE)
}
