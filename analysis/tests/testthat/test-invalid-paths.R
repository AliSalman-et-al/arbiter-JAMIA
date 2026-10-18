test_that('required NA and missing answers invalidate paths, inactive NA does not', {
  a <- c('4.1'='no','4.2'='no','4.3'='not_applicable','4.4'='no')
  expect_equal(invalid_required_questions('D4',a),'4.3')
  expect_true(is.na(domain_algorithm('D4',a)))
  expect_equal(resolve_invalid_path('D4',a,'no'),'Low')
  expect_equal(resolve_invalid_path('D4',a,'no_information'),'Low')
  expect_equal(domain_algorithm('D4',c('4.1'='no','4.2'='no','4.3'='no','4.4'='not_applicable')),'Low')
  b <- c('3.1'='no','3.2'='not_applicable','3.3'='no')
  expect_equal(invalid_required_questions('D3',b),'3.2')
  expect_true(is.na(domain_algorithm('D3',b)))
  c <- c('2.1'='yes','2.2'='no','2.3'='yes','2.4'='yes','2.6'='yes')
  expect_equal(invalid_required_questions('D2',c),'2.5')
  expect_true(is.na(domain_algorithm('D2',c)))
  expect_equal(domain_algorithm('D3',c('3.1'='yes','3.2'='not_applicable')),'Low')
  d <- c('4.1'='no','4.2'='no','4.3'='not_applicable')
  expect_equal(resolve_invalid_path('D4',d,'no'),'Low')
  expect_equal(resolve_invalid_path('D4',d,'no_information'),'High')
})

test_that('empty domains remain not evaluable; partial domains are invalid', {
  x <- list(labels=tibble(arm='Baseline-Sonnet',slug=c('empty','partial','unlabelled'),
    domain='D4',label=c('Low','Low',NA_character_)),
    signals=tibble(arm='Baseline-Sonnet',slug=c('empty','partial','unlabelled'),domain='D4',
      question='4.1',answer=c(NA_character_,'no','no'),active=TRUE))
  d <- domain_checks(x)
  expect_equal(d$status,c('Not evaluable','Invalid answer path','Not evaluable'))
})

test_that('sensitivity changes only invalid paths and retains complete violations', {
  x <- list(labels=tibble(arm='Baseline-Sonnet',slug=c('invalid','violation'),
    domain='D4',label=c('Low','High')),
    signals=tibble(arm='Baseline-Sonnet',slug=rep(c('invalid','violation'),each=3),
      domain='D4',question=rep(c('4.1','4.2','4.3'),2),
      answer=c('no','no','not_applicable','no','no','no'),active=TRUE))
  d <- domain_checks(x)
  s <- invalid_path_sensitivity(x,d) |> filter(domain=='D1-D5')
  expect_equal(s$original_violations,c(1L,1L))
  expect_equal(s$invalid_paths,c(1L,1L))
  expect_equal(s$violations,c(1L,2L))
  expect_equal(s$n,c(2L,2L))
})
