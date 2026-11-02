figure_legend_sections <- function() {
  supplied <- readLines('output/manuscript/legends-fig1-2.md',warn=FALSE)
  supplied <- gsub('grey text','gray text',supplied,fixed=TRUE)
  supplied <- supplied[!startsWith(supplied,'# ') & !startsWith(supplied,'The independent verifier checks archive structure') & !startsWith(supplied,'For the version without')]
  supplied <- gsub('{{eTable:avatar-trace}}','the linked repository AVATAR answer and evidence records',supplied,fixed=TRUE)
  domains <- 'D1, randomisation process; D2, deviations from intended interventions; D3, missing outcome data; D4, outcome measurement; D5, selection of the reported result.'
  sections <- c(paste(supplied,collapse='\n'),
    'Figure 3 Paired evaluation and blinded label choices. Both model arms used the same reported model identifier and documents for 102 trials. Human reviews covered all 510 domain cells before reviewers saw labels. Choices were among three anonymized labels in random order without rationales. The conditional comparison uses 60 agreed choices from 80 cells where arms differed; 20 split choices enter sensitivities. Agreement analyses use all 510 cells.',
    paste('Figure 4 Domain agreement with human reviews and published labels. Blue circles show ARBITER; orange squares, Direct prompting. Bars show 95% CIs. Diamonds show paired ARBITER minus Direct prompting differences in percentage points; zero lines indicate no difference. Each human review includes 510 pooled cells, 102 per domain. Human agreement provides context, not a performance ceiling.',domains,CI_NOTE),
    paste('Figure 5 Paired differences in signalling-answer agreement. Diamonds and bars show paired ARBITER minus Direct prompting differences and 95% CIs. The sample size is the number of answer components evaluable in both arms. Five-level coding keeps yes, probably yes, no, probably no and no information separate. Collapsed coding merges definite and probable answers, retaining no information. Eligibility and question-level results are in eTables 11 to 13.',domains,CI_NOTE))
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
