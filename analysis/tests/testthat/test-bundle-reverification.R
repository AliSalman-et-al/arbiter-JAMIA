test_that('fresh verification covers each analysis trial in each ARBITER arm', {
  x <- read.csv(file.path(analysis_dir,'data-derived','bundle-reverification.csv'),
                stringsAsFactors=FALSE) |> filter(arm=='ARBITER-Sonnet')
  expect_true(all(c('slug','arm','bundle_sha256','verifier_version','verifier_commit',
    'result','detail','population','archived_result','receipt_agreement',
    'archived_receipt') %in% names(x)))
  expect_equal(nrow(x),105L)
  expect_false(anyDuplicated(paste(x$arm,x$slug)) > 0L)
  expect_equal(sort(unique(x$arm)),'ARBITER-Sonnet')
  for (arm in unique(x$arm)) {
    a <- x[x$arm == arm & x$population == 'analysis',]
    expect_equal(nrow(a),102L)
    expect_setequal(a$slug,unique(inputs$labels$slug))
    expect_false(any(a$slug %in% EXCLUDED))
  }
  expect_equal(sum(x$arm == 'ARBITER-Sonnet' & x$population == 'excluded'),3L)

})

test_that('fresh run-build results agree with every archived receipt', {
  x <- read.csv(file.path(analysis_dir,'data-derived','bundle-reverification.csv'),
                stringsAsFactors=FALSE) |> filter(arm=='ARBITER-Sonnet')
  expect_true(all(grepl('^[a-f0-9]{64}$',x$bundle_sha256)))
  expect_true(all(x$verifier_commit == '2848c7926a2acc25402345a42be39d695a99861a'))
  expect_true(all(x$verifier_version == '0.13.0'))
  expect_true(all(x$result == 'pass'))
  expect_true(all(x$archived_result == 'verified'))
  expect_true(all(tolower(x$receipt_agreement) == 'true'))
  receipts <- lapply(x$archived_receipt,jsonlite::fromJSON)
  expect_true(all(vapply(receipts,function(r) identical(r$result,'verified'),logical(1))))
  expect_true(all(vapply(receipts,function(r)
    identical(r$schema,'rob2-kit.independent-verifier-input.v0.3'),logical(1))))
})
