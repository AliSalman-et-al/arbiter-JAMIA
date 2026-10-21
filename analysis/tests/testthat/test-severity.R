source(file.path(analysis_dir,'R/severity.R'))
test_that('severity counts and observed Overall denominators reproduce', {
  x <- severity_distribution(inputs)
  low <- x |> filter(population=='D1-D5',label=='Low')
  expect_equal(low$count,c(427L,375L,407L,277L,346L))
  expect_true(all(low$n==510L))
  expect_equal((x |> filter(population=='Overall',label=='Low'))$n,c(81L,102L,102L,102L,102L))
  expect_true(all(abs((x |> group_by(source,population) |> summarise(p=sum(estimate),.groups='drop'))$p-1)<1e-12))
  fixture <- list(labels=tibble(slug=rep(c('a','b'),2),domain='D1',arm=rep(c('ARBITER-Sonnet','Baseline-Sonnet'),each=2),
    label=c('Low','High','Some concerns','Some concerns'),meta=rep(c('Low','Some concerns'),2)),
    adjud=tibble(slug=rep(c('a','b'),2),domain='D1',adjudicator=rep(c('1','2'),each=2),independent=c('Low','Low','High','Some concerns')))
  z <- severity_distribution(fixture) |> filter(population=='D1-D5')
  expect_equal(filter(z,source=='Expert 1')$count,c(2L,0L,0L))
  expect_equal(filter(z,source=='ARBITER')$count,c(1L,0L,1L))
})
test_that('binary expert classes and shared paired resamples match a hand fixture', {
  # Expert L,L,SC,H: ARBITER L,H,SC,L; Unassisted L,L,L,H.
  fixture <- list(labels=tibble(slug=rep(letters[1:4],2),domain='D1',arm=rep(c('ARBITER-Sonnet','Baseline-Sonnet'),each=4),
    label=c('Low','High','Some concerns','Low','Low','Low','Low','High'),meta='Low'),
    adjud=tibble(slug=rep(letters[1:4],2),domain='D1',adjudicator=rep(c('1','2'),each=4),independent=rep(c('Low','Low','Some concerns','High'),2)))
  weights <- stratified_cluster_weights(tibble(slug=letters[1:4],meta_id='m'),100,9)
  x <- independent_binary(fixture,weights)
  z <- filter(x$estimates,adjudicator=='1',domain=='D1-D5')
  expect_equal(z$count,c(1L,1L,1L,2L,0L,2L)); expect_equal(z$n,rep(2L,6))
  expect_equal(z$estimate,c(.5,.5,.5,1,0,1))
  d <- filter(x$differences,adjudicator=='1',domain=='D1-D5')
  expect_equal(d$estimate,c(0,-.5))
  da <- fixture$labels[1:4,] |> mutate(meta=c('Low','Low','Some concerns','High'))
  db <- fixture$labels[5:8,] |> mutate(meta=c('Low','Low','Some concerns','High'))
  expected <- interval_table((agreement_replicates(da,weights)-agreement_replicates(db,weights))[c('sensitivity','specificity'),])
  expect_equal(d$lower,expected$lower); expect_equal(d$upper,expected$upper)
})
