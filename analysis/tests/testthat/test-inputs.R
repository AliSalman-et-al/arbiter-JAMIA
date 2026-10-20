test_that('analysis population and meta-label denominators are correct', {
  expect_equal(nrow(inputs$trials),102L)
  expect_false(any(inputs$labels$slug %in% EXCLUDED))
  expect_true(all(count(inputs$labels,arm,domain)$n==102L))
  expect_true(all((inputs$labels |> filter(domain=='Overall') |>
    group_by(arm) |> summarise(n=sum(!is.na(meta))))$n==81L))
  expect_setequal(unique(inputs$labels$arm),c('ARBITER-Sonnet','Baseline-Sonnet'))
})
test_that('baseline-Sonnet reproduces 395 of 510 exact matches', {
  x <- inputs$labels |> filter(arm=='Baseline-Sonnet',domain!='Overall')
  expect_equal(nrow(x),510L)
  expect_equal(sum(x$label==x$meta),395L)
})
