# Save an auditable assertion count and fail the command on any test failure.
x <- testthat::test_dir('tests/testthat',stop_on_failure=FALSE)
saveRDS(x,'output/manuscript/qa/tests-round13b.rds')
d <- as.data.frame(x)
summary <- sprintf('Assertions: %s; failed: %s; errors: %s; warnings: %s; skipped: %s',sum(d$nb),sum(d$failed),sum(d$error),sum(d$warning),sum(d$skipped))
writeLines(c(summary,capture.output(print(d))),'output/manuscript/qa/tests-round13b.txt')
cat(summary,'\n')
stopifnot(sum(d$failed)==0,sum(d$error)==0,sum(d$warning)==0,sum(d$skipped)==0)
