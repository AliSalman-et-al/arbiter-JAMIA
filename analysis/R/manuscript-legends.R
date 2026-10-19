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
 'Figure 3. Two assessment arms supplied 102 trials and 154 adjudicated disagreements'=paste(
 'Two assessment arms supplied the benchmark. The flow follows trial inclusion, domain and Overall ratings, and selection for blinded adjudication. A cell is one trial × domain. Ratings were reviewed when at least one arm differed from the published review label. Branches show whether both adjudicators agreed, then identify cells where the two arms disagreed.',
 '\n\nAlt text: Trial inclusion flows into two assessment arms and blinded adjudication, with separate branches for agreement and split decisions.'),
 'Figure 4. Both models agreed poorly with published labels; adjudicators usually upheld stricter ratings (post hoc panel B)'=paste(
 'Both models agreed poorly with published labels, but adjudicators usually upheld stricter ratings. A, Domain-specific linearly weighted Cohen’s κ against published labels; the dashed line marks zero. B, Post hoc shares of disagreements where the adjudicators’ agreed choice equals the model rating, by direction relative to Published. Labels give n/N and split decisions excluded from denominators. Points and bars show estimates and 95% percentile intervals from 10,000 trial-cluster bootstrap resamples within meta-analysis (seed 20261018). This selected population cannot estimate full-benchmark accuracy. Pooled agreement is in Table 1.',
 '\n\nAlt text: Domain agreement intervals overlap. Post hoc adjudicator agreement is highest for stricter ARBITER ratings, followed by stricter Unassisted ratings.'),
 'Figure 5. Adjudicators chose ARBITER far more often when the arms disagreed, including post hoc strictness strata'=paste(
 'Adjudicators favoured ARBITER when the arms disagreed. The first four rows show the primary estimate and sensitivities; the separate post hoc group stratifies by which arm was stricter. Points and bars show the share choosing ARBITER and 95% percentile intervals from 10,000 trial-cluster bootstrap resamples within meta-analysis (seed 20261018). The dashed line marks equal choice. Scoring compares labels. The split sensitivity counts every split against ARBITER without assigning it to Unassisted. Right labels give counts. Full outcomes and post hoc strata are in eTables SHARE_TABLES.',
 '\n\nAlt text: Adjudicators chose ARBITER in most disagreements in the primary and sensitivity analyses. The post hoc stricter ARBITER stratum has the highest win share.'),
 'Figure 6. Most localised Unassisted losses traced to whether the analysis plan was fixed in advance'=paste(
 'The analysis-plan question explained the largest share of localised Unassisted losses. Bars count ratings the adjudicators did not choose, by the question that alone changed the rating: replacing that answer with the agreed independent answer changes the official algorithm output. Eligibility requires both independent ratings to equal the agreed choice. A rating may contribute to several bars. Facet labels give eligible totals and ratings without a single deciding question. D2 uses the effect-of-assignment algorithm. Frequencies and eligibility are in eTables LOCAL_TABLES; the post hoc rules-only recomputation is in eTable RULES_TABLE.',
 '\n\nAlt text: Bars compare losses by question within domains. The analysis-plan question dominates Unassisted losses. Facet totals include ratings without a single deciding question.')
)) |> lapply(function(x) {
 x <- gsub('SHARE_TABLES',paste(supplement_number('Per-adjudicator and split-cell win-share sensitivity'),supplement_number('Post hoc severity-stratified win share'),sep='–'),x,fixed=TRUE)
 x <- gsub('LOCAL_TABLES',paste(supplement_number('Localisation population eligibility'),supplement_number('Decisive-question frequencies, both populations'),sep='–'),x,fixed=TRUE)
 gsub('RULES_TABLE',supplement_number('Post hoc: recomputing Unassisted ratings changes few arm disagreements'),x,fixed=TRUE)
})
build_figure_legends <- function() {
  sections <- figure_legend_sections()
  text <- c('# Figure legends','',unlist(lapply(seq_along(sections),function(i) c(paste('##',names(sections)[i]),'',sections[[i]],''))))
  text <- gsub('[ \t]+\n','\n',text)
  text <- sub('\n+$','',text)
  text <- text[seq_len(max(which(nzchar(text))))]
  writeLines(enc2utf8(text),'output/manuscript/figure-legends.md',useBytes=TRUE)
}
