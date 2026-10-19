test_that('post hoc rules-only replacement changes violations and preserves invalid paths', {
 labels <- tibble(arm='Baseline-Sonnet',slug=c('a','b','c'),domain='D1',label=c('High','Low','Low'))
 checks <- labels |> mutate(status=c('Violation','Invalid answer path','Consistent'),algorithm=c('Low',NA,'Low'))
 out <- rules_only_labels(labels,checks)
 expect_identical(out$label,c('Low','Low','Low'))
 expect_identical(labels$label,c('High','Low','Low'))
})
test_that('post hoc direction counts split and third labels separately', {
 cells <- tibble(slug=letters[1:4],kit='High',nokit='Low',meta='Some concerns',
  consensus=c(TRUE,TRUE,TRUE,FALSE),preferred=c('High','Some concerns','Low',NA))
 w <- stratified_cluster_weights(tibble(slug=letters[1:4],meta_id='m'),100,3)
 out <- direction_of_disagreement(cells,w)
 z <- out |> filter(source=='ARBITER',direction=='Stricter')
 expect_equal(z$count,1L); expect_equal(z$n,3L); expect_equal(z$split,1L)
 expect_equal(z$published_upheld,1L); expect_equal(z$other_label,1L)
 expect_equal(z$estimate,1/3)
})
test_that('post hoc unweighted kappa agrees with a hand calculated table', {
 # Po=24/36, Pe=11/36, so kappa=13/25.
 counts <- matrix(c(2,0,0,1,1,1,0,0,1),nrow=1)
 expect_equal(unweighted_kappa(counts),13/25)
 expect_true(is.na(unweighted_kappa(matrix(c(2,rep(0,8)),nrow=1))))
})
test_that('post hoc direction estimates reproduce the stored count estimand', {
 w <- stratified_cluster_weights(inputs$trials,10000,20261018)
 x <- direction_of_disagreement(adjudication_cells(inputs),w)
 expect_equal(x$count,c(73,22,48,19)); expect_equal(x$n,c(77,28,59,38))
 expect_true(all(x$valid_replicates==10000))
})
test_that('post hoc recomputation retains original disagreement denominator even after labels tie', {
 labels <- tibble(arm='Baseline-Sonnet',slug=c('a','b'),domain='D1',label=c('High','Low'),meta=c('High','Low'))
 checks <- labels |> mutate(status=c('Violation','Invalid answer path'),algorithm=c('Low',NA))
 cells <- tibble(slug=c('a','b'),domain='D1',meta=c('High','Low'),kit=c('Low','High'),nokit=c('High','Low'),
  consensus=TRUE,discordant=TRUE,preferred=c('Low','Low'))
 w <- stratified_cluster_weights(tibble(slug=c('a','b'),meta_id='m'),100,9)
 r <- rules_only_recomputation(labels,checks,cells,w)
 z <- r$win_share |> filter(metric=='Baseline')
 expect_equal(z$n,c(2L,2L)); expect_equal(z$count,c(1L,2L))
 expect_equal(nrow(r$changed),1L)
 expect_equal(r$agreed_choice$count,c(1L,2L))
})
