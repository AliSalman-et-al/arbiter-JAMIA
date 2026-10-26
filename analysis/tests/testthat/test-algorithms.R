test_that('Overall rule distinguishes permitted escalation and missing data', {
  expect_equal(overall_consistency(rep('Low',5),'Low'),'Consistent')
  expect_equal(overall_consistency(c('High',rep('Low',4)),'Low'),'Violation')
  expect_equal(overall_consistency(c('Some concerns',rep('Low',4)),'High'),'Violation')
  expect_equal(overall_consistency(c(rep('Some concerns',2),rep('Low',3)),'High'),
    'Permitted escalation')
  expect_equal(overall_consistency(c(NA,rep('Low',4)),'Low'),'Not evaluable')
})
test_that('D1 reproduces official Table 4, including NI sequence with concealment', {
  f <- function(s,c,b) domain_algorithm('D1',setNames(c(s,c,b),c('1.1','1.2','1.3')))
  expect_equal(f('no_information','probably_yes','no'),'Low')
  expect_equal(f('yes','no','no'),'High')
  expect_equal(f('no','yes','no'),'Some concerns')
  expect_equal(f('yes','no_information','yes'),'High')
  expect_equal(f('yes','no_information','no'),'Some concerns')
  expect_equal(f('yes','yes','yes'),'Some concerns')
})
test_that('D2 follows assignment version, both parts', {
  a <- setNames(c('no','no','yes'),c('2.1','2.2','2.6'))
  expect_equal(domain_algorithm('D2',a),'Low')
  a['2.6'] <- 'no'; a['2.7'] <- 'probably_no'
  expect_equal(domain_algorithm('D2',a),'Some concerns')
  a['2.7'] <- 'no_information'
  expect_equal(domain_algorithm('D2',a),'High')
  b <- setNames(c('yes','yes','yes','no_information','no','yes'),
    c('2.1','2.2','2.3','2.4','2.5','2.6'))
  expect_equal(domain_algorithm('D2',b),'High')
  b['2.5'] <- 'yes'
  expect_equal(domain_algorithm('D2',b),'Some concerns')
})
test_that('D3-D5 reproduce official default paths', {
  expect_equal(domain_algorithm('D3',c('3.1'='yes')),'Low')
  a <- c('3.1'='no','3.2'='no','3.3'='yes','3.4'='no')
  expect_equal(domain_algorithm('D3',a),'Some concerns')
  a['3.4'] <- 'yes'; expect_equal(domain_algorithm('D3',a),'High')
  a <- c('4.1'='no','4.2'='no','4.3'='no')
  expect_equal(domain_algorithm('D4',a),'Low')
  a['4.2'] <- 'no_information'; expect_equal(domain_algorithm('D4',a),'Some concerns')
  a['4.1'] <- 'yes'; expect_equal(domain_algorithm('D4',a),'High')
  a <- c('5.1'='yes','5.2'='no','5.3'='no')
  expect_equal(domain_algorithm('D5',a),'Low')
  a['5.1'] <- 'no_information'; expect_equal(domain_algorithm('D5',a),'Some concerns')
  a['5.3'] <- 'yes'; expect_equal(domain_algorithm('D5',a),'High')
})
test_that('gate rejects a mismatch rather than tuning it away', {
  checks <- domain_checks(inputs)
  expect_true(all(checks$status[checks$arm=='ARBITER-Sonnet']=='Consistent'))
  expect_no_error(validate_gate(checks))
  checks$status[checks$arm=='ARBITER-Sonnet'][1] <- 'Violation'
  expect_error(validate_gate(checks),'validation gate failed')
})
test_that('section 5.4 mandatory ARBITER validation gate passes', {
  expect_no_error(validate_gate(domain_checks(inputs)))
})

test_that('derived Overall uses five complete domains without optional escalation', {
  expect_equal(derived_overall(rep('Low',5)),'Low')
  expect_equal(derived_overall(c('Some concerns','Some concerns',rep('Low',3))),'Some concerns')
  expect_equal(derived_overall(c(rep('Low',4),'High')),'High')
  expect_true(is.na(derived_overall(rep('Low',4))))
  expect_true(is.na(derived_overall(c(rep('Low',4),NA))))
})
