test_that('coding sheet contains precisely losing consensus sources and blank codes', {
  cells <- adjudication_cells(inputs)
  x <- coding_template(inputs,cells)
  expected <- cells |> filter(consensus) |> summarise(n=sum(kit!=preferred)+sum(nokit!=preferred)+sum(meta!=preferred))
  expect_equal(nrow(x),expected$n)
  expect_true(all(x$losing_label!=x$preferred))
  expect_true(all(x$code_author1=='' & x$code_author2=='' & x$final_code==''))
  expect_equal(sum(x$second_author_sample),ceiling(.2*nrow(x)))
  expect_identical(x,coding_template(inputs,cells))
  expect_null(summarise_coding(x,x,tibble(domain='All',code='unused')))
  changed <- x; changed$preferred[1] <- 'changed'
  expect_error(summarise_coding(changed,x,tibble(domain='All',code='unused')))
})

test_that('coding reliability uses unweighted Cohen kappa on synthetic categories', {
  # Po=3/4; the balanced reference margin gives Pe=1/2.
  expect_equal(coding_kappa(c('a','a','b','b'),c('a','a','b','a')), .5)
})

test_that('reporting checklist has all official IDs and empty author columns', {
  x <- reporting_checklist()
  expect_equal(nrow(filter(x,guideline=='GRRAS')),15L)
  expect_setequal(filter(x,guideline=='TRIPOD-LLM',startsWith(item,'19'))$item,paste0('19',letters[1:7]))
  expect_true(all(x$page=='' & x$section=='' & x$applicability_and_notes==''))
})
