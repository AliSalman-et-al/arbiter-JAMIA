source(file.path(analysis_dir,'R','presentation.R'))
testthat::test_that('display punctuation follows the manuscript standard', {
  testthat::expect_identical(fmt_ci(.26,.42),'(0.26\u20130.42)')
  testthat::expect_identical(fmt_ci(-.03,.14),'(\u22120.03 to 0.14)')
  testthat::expect_identical(fmt_ci(-.4,-.1),'(\u22120.40 to \u22120.10)')
  testthat::expect_identical(fmt_number(-.001),'0.00')
  testthat::expect_identical(fmt_fraction(54,62),'54/62 (87.1%)')
  testthat::expect_identical(fmt_fraction(0,0),'\u2014')
  testthat::expect_identical(fmt_ci(NA_real_,1),'\u2014')
  testthat::expect_identical(fmt_process_text('7.6 [6.1 to 10.5]'),'7.6 [6.1\u201310.5]')
  testthat::expect_identical(fmt_process_text('11.0 (8.4 to 14.1)'),'11.0 (8.4\u201314.1)')
  testthat::expect_identical(fmt_process_text('-0.1 (-0.3 to 0.2)'),'\u22120.1 (\u22120.3 to 0.2)')
})
testthat::test_that('reader labels translate sources without changing data', {
  testthat::expect_identical(reader_label(c('ARBITER-Sonnet','Baseline-Sonnet','A','Z')),
    c('ARBITER','Unassisted','Adjudicator 1','Adjudicator 2'))
  testthat::expect_identical(reader_label('no_information'),'No information')
  testthat::expect_identical(reader_label('ARBITER-Haiku',TRUE),'ARBITER (Haiku 5.5)')
  testthat::expect_identical(unname(JAMA_ROLES[1:3]),c('#00A1D5','#DF8F44','#374E55'))
  testthat::expect_identical(display_frame(data.frame(question=1.1))$question,'1.1')
  testthat::expect_identical(display_frame(data.frame(count=-3041))$count,'\u22123,041')
})

testthat::test_that('proportion intervals use the percentage scale', {
  x <- data.frame(estimate=386/510,lower=.724,upper=.790,count=386,n=510)
  testthat::expect_identical(fmt_estimate(x,TRUE),'386/510 (75.7%) (72.4\u201379.0)')
  testthat::expect_identical(reader_label('D1-D5'),'D1\u2013D5')
})
testthat::test_that('group rows have an empty measure area', {
  x <- data.frame(Source=c('ARBITER','Unassisted'),Value=c('1','2'))
  testthat::expect_identical(group_row(x,'Group')$Value,c('','1','2'))
  testthat::expect_identical(x$Value,c('1','2'))
})

source(file.path(analysis_dir,'R','manuscript-supplement.R'))
testthat::test_that('supplement labels and compact confusion grids are reader ordered', {
  testthat::expect_identical(trial_display(c('atwine-2020','hill-2017','award-1-2014')),c('Atwine 2020','Hill 2017','AWARD-1 2014'))
  testthat::expect_identical(reader_field(c('original_violations','answer_code_only')),c('Original violations (cells)','Answer-code-only fields (n)'))
  x <- tidyr::expand_grid(meta=rev(LABELS),predicted=c(rev(LABELS),'Missing')) |> dplyr::mutate(n=0L)
  y <- confusion_display(x)
  testthat::expect_identical(names(y),c('Published',LABELS))
  testthat::expect_identical(as.character(y$Published),LABELS)
  x$n[x$predicted=='Missing' & x$meta=='High'] <- 1L
  testthat::expect_identical(names(confusion_display(x)),c('Published',LABELS,'Missing'))
  testthat::expect_equal(sum(confusion_display(x)[,-1]),1)
})
testthat::test_that('diagnostic reshaping preserves every value with units', {
  x <- tibble::tibble(arm=c('a','b'),input=c(10,20),output=c(2,4))
  y <- wide_diagnostics(x,c(input='Input tokens (n)',output='Output tokens (n)'))
  testthat::expect_identical(y$a,c('10','2'))
  testthat::expect_identical(y$b,c('20','4'))
  testthat::expect_identical(y$Measure,c('Input tokens (n)','Output tokens (n)'))
})
