test_that('stratified bootstrap preserves trial counts and whole clusters', {
  trials <- tibble(slug=c('a','b','c'),meta_id=c('m1','m1','m2'))
  w <- stratified_cluster_weights(trials,100,7)
  expect_equal(colSums(w),rep(3,100))
  expect_equal(colSums(w[1:2,,drop=FALSE]),rep(2,100))
  expect_equal(unname(w[3,]),rep(1,100))
  expect_identical(w,stratified_cluster_weights(trials,100,7))
  d <- tibble(slug=c('a','a','b','c'))
  expect_equal(bootstrap_rows(d,w)[1,],bootstrap_rows(d,w)[2,])
  expect_true(any(w>1))
})

test_that('win shares score equal labels and retain neither outcomes', {
  d <- tibble(slug=letters[1:4],discordant=TRUE,consensus=c(TRUE,TRUE,TRUE,FALSE),
    kit='Low',nokit='High',preferred=c('Low','High','Some concerns',NA_character_),
    chosen_label_A=c('Low','High','Some concerns','Low'),
    chosen_label_Z=c('Low','High','Some concerns','High'))
  w <- stratified_cluster_weights(tibble(slug=letters[1:4],meta_id='m'),100,3)
  x <- win_share(d,w)
  expect_equal(x$count,c(1L,1L,1L))
  expect_equal(x$estimate,rep(1/3,3))
  s <- win_share(d,w,'Split sensitivity')
  expect_equal(s$count,c(1L,1L,2L))
  expect_equal(s$estimate,c(.25,.25,.5))
})

test_that('linear kappa and AC2 reproduce a hand-worked table', {
  # Rows reference, columns prediction: [2,1,0; 0,1,0; 0,1,1].
  # Po=5/6; Pe(kappa)=5/9, so kappa=5/8.
  # Mean margins=(5,4,3)/12, Pe(AC2)=235/432, AC2=125/197.
  c <- matrix(c(2,0,0,1,1,1,0,0,1),nrow=1)
  expect_equal(weighted_kappa(c),5/8)
  expect_equal(gwet_ac2(c),125/197)
  expect_equal(exact_accuracy(c),4/6)
  expect_equal(not_low_sensitivity(c),1)
  expect_equal(not_low_specificity(c),2/3)
  expect_equal(weighted_kappa(matrix(c(1,0,1,rep(0,6)),nrow=1)),0)
  expect_true(is.na(weighted_kappa(matrix(c(2,rep(0,8)),nrow=1))))
})

test_that('missing judgements fail exact and binary scoring', {
  d <- tibble(slug=c('a','b'),meta=c('Low','High'),label=NA_character_)
  w <- stratified_cluster_weights(tibble(slug=c('a','b'),meta_id='m'),100,2)
  x <- agreement_replicates(d,w)
  expect_equal(unname(x['accuracy',1]),0)
  expect_equal(unname(x['sensitivity',1]),0)
  expect_equal(unname(x['specificity',1]),0)
})

test_that('quotations require five words and paired double quotes', {
  expect_identical(has_quotation(c('"one two three four five"','“one two three four five”',
    '"one two three four"',"'one two three four five'",NA)),c(TRUE,TRUE,FALSE,FALSE,FALSE))
})

test_that('composite excludes all split cells', {
  x <- composite_reference(inputs)
  expect_equal(as.integer(table(x$arm)),c(485L,485L))
  expect_equal(nrow(composite_reference(inputs,'A')),1020L)
})

test_that('consensus endpoint reproduces label-based sanity counts', {
  w <- stratified_cluster_weights(inputs$trials,100,20261018)
  x <- win_share(adjudication_cells(inputs),w)
  expect_equal(x$n,rep(62L,3))
  expect_equal(x$count,c(54L,7L,1L))
})

test_that('amended gate rejects a second Haiku exception or unexpected missingness', {
  x <- domain_checks(inputs)
  i <- which(x$arm=='ARBITER-Haiku' & x$status=='Consistent')[1]
  x$status[i] <- 'Violation'
  expect_error(validate_gate(x),'validation gate failed')
  x <- domain_checks(inputs)
  x$status[i] <- 'Not evaluable'
  expect_error(validate_gate(x),'validation gate failed')
})


