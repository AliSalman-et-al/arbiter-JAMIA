source(file.path(analysis_dir,'R/severity.R'))
test_that('domain category counts reproduce', {
  x <- severity_distribution(inputs)
  low <- x |> filter(population=='D1-D5',label=='Low')
  expect_equal(low$count,c(427L,375L,407L,277L,346L))
  expect_true(all(low$n==510L))
  expect_true(all(abs((x |> group_by(source,population) |> summarise(p=sum(estimate),.groups='drop'))$p-1)<1e-12))
  fixture <- list(labels=tibble(slug=rep(c('a','b'),2),domain='D1',arm=rep(c('ARBITER-Sonnet','Baseline-Sonnet'),each=2),
    label=c('Low','High','Some concerns','Some concerns'),meta=rep(c('Low','Some concerns'),2)),
    adjud=tibble(slug=rep(c('a','b'),2),domain='D1',adjudicator=rep(c('1','2'),each=2),independent=c('Low','Low','High','Some concerns')))
  z <- severity_distribution(fixture) |> filter(population=='D1-D5')
  expect_equal(filter(z,source=='Expert 1')$count,c(2L,0L,0L))
  expect_equal(filter(z,source=='ARBITER')$count,c(1L,0L,1L))
})
