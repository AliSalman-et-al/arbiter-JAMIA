figure_legend_sections <- function() {
  supplied <- readLines('output/manuscript/legends-fig1-2.md',warn=FALSE)
  supplied <- gsub('grey text','gray text',supplied,fixed=TRUE)
  supplied <- supplied[!startsWith(supplied,'# ') & !startsWith(supplied,'The independent verifier checks archive structure') & !startsWith(supplied,'For the version without')]
  supplied <- gsub('{{eTable:avatar-trace}}','the linked repository AVATAR answer and evidence records',supplied,fixed=TRUE)
  supplied <- vapply(supplied,function(line) if(startsWith(line,'**Figure 2.')) paste(line,'The footer compares the Published D5 label with the subsequent blinded D5 choices from both human reviews; it does not report independently rated Overall judgments.') else line,character(1))
  domains <- 'D1, randomisation process; D2, deviations from intended interventions; D3, missing outcome data; D4, outcome measurement; D5, selection of the reported result.'
  coding <- 'Y, yes; PY, probably yes; N, no; PN, probably no; NI, no information. Five-level coding keeps all five answers; collapsed coding combines Y/PY and N/PN, with NI separate.'
  sections <- c(paste(supplied,collapse='\n'),
    'Figure 3 Paired evaluation and conditional blinded-label choices. Both arms assessed the same 102 trials using the same reported model identifier and supplied documents. Two experts independently recorded ratings and signalling answers for all 510 trial-domain cells before viewing labels. In a separate stage, each chose among three labels presented in random order without rationales. The conditional choice estimate uses 60 agreed choices from 80 arm-discordant cells; 20 split choices enter sensitivities. The all-cell expert comparisons are not restricted to that conditional population. Counts are trials or cells as indicated; no interval applies.',
    paste('Figure 4 Absolute and paired domain agreement with each independent expert. Blue circles denote ARBITER and orange squares Unassisted. Left panels show exact agreement with 95% intervals on a 0–100% scale; right panels show paired ARBITER minus Unassisted differences in percentage points, with neutral diamonds and zero lines. Each expert contributes 510 pooled cells and 102 per domain. Expert-to-expert agreement is 388/510 (76.1%; weighted κ 0.59), context rather than a performance ceiling. The compact Published comparison retains all 510 cells. D1: randomisation process; D2: deviations from intended interventions; D3: missing outcome data; D4: outcome measurement; D5: selection of the reported result. ',CI_NOTE),
    paste('Figure 5 Paired signalling-answer diagnostics. Rows cover all five domains against each expert; n is the number of question components evaluable in both arms. Diamonds and bars show ARBITER minus Unassisted exact agreement and 95% intervals. Five-level matching distinguishes yes, probably yes, no, probably no and no information. Collapsed matching combines yes/probably yes and no/probably no, leaving no information separate. These are different estimands. D1: randomisation process; D2: deviations from intended interventions; D3: missing outcome data; D4: outcome measurement; D5: selection of the reported result. D3 and D5 illustrate reference dependence and the effect of coding. eTable 6 contains source-specific domain summaries, complete paired question contrasts and eligibility accounting for both codings.',CI_NOTE))
  reader_label(sub('^(e?Figure [0-9]+) ','\\1. ',sections))
}
build_figure_legends <- function() writeLines(enc2utf8(paste(figure_legend_sections(),collapse='\n\n')),'output/manuscript/figure-legends.md',useBytes=TRUE)

main_figure_alts <- function() reader_label(c(
 'Architecture separating model interpretation from software source storage, evidence binding and executable RoB 2 decisions. The retained record supports reviewer inspection.',
 'Illustrative AVATAR assessment showing the result, domain judgments, signalling answers and linked source evidence. The example explains the workflow and is not a representative performance sample.',
 'Paired evaluation of 102 trials and 510 domain cells against two independent experts. A separate conditional branch contains 80 arm-discordant cells, 60 agreed choices and 20 splits.',
 'Exact agreement and paired gains against each expert, pooled and by domain. Both pooled gains favor ARBITER; D5 gains are largest and D3 depends strongly on the expert reference. The full-cohort Published comparison is shown separately.',
 'Paired signalling-answer differences by domain and expert, with five-level and collapsed coding separated. D3 changes direction with coding against Expert 1; D5 gains are smaller with collapsed coding against Expert 2.'))
main_figure_captions <- function() {
  sections <- figure_legend_sections()
  text <- gsub('**','',sections[1],fixed=TRUE)
  pos <- regexpr('Figure 2',text,fixed=TRUE)[1]
  supplied <- c(trimws(substr(text,1,pos-1)),trimws(substr(text,pos,nchar(text))))
  supplied <- sub('Alt text:.*','',supplied)
  c(trimws(supplied),sections[2:4])
}
