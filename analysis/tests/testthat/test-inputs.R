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
test_that('adjudication rows are exactly the disputed set in both files', {
  cells <- disputed_cells(inputs$labels)
  key <- function(x) paste(x$slug,x$domain,sep=':')
  expect_equal(nrow(cells),154L)
  a <- inputs$adjud |> filter(adjudicator=='A')
  z <- inputs$adjud |> filter(adjudicator=='Z')
  expect_identical(key(a),key(z))
  for(x in list(a,z)) {
    expect_equal(nrow(x),154L)
    expect_equal(anyDuplicated(key(x)),0L)
    expect_setequal(key(x),key(cells))
    joined <- left_join(x,cells,by=c('slug','domain'),suffix=c('_sheet','_arm'))
    expect_identical(joined$human,joined$meta)
    expect_identical(joined$kit_sheet,joined$kit_arm)
    expect_identical(joined$nokit_sheet,joined$nokit_arm)
  }
  c <- adjudication_cells(inputs)
  expect_equal(sum(c$consensus),129L)
  expect_equal(sum(!c$consensus),25L)
})
