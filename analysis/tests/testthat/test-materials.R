test_that('reporting checklist has all official IDs and populated reporting locations', {
  x <- reporting_checklist()
  expect_equal(nrow(filter(x,guideline=='GRRAS')),15L)
  expect_setequal(filter(x,guideline=='TRIPOD-LLM',startsWith(item,'19'))$item,paste0('19',letters[1:7]))
  expect_true(all(nzchar(x$section) & nzchar(x$applicability_and_notes)))
})
test_that('worked trace uses more-severe consensus candidates and retains the alternative', {
  evidence <- readr::read_csv(file.path(analysis_dir,'data-derived','bundle-trace-evidence.csv'),show_col_types=FALSE)
  x <- worked_trace_candidates(evidence)
  expect_equal(x$slug[1],'award-10-2018')
  expect_equal(x$slug[5],'levin-2016')
  expect_true(all(x$Baseline_label[1:4]==x$meta[1:4]))
  expect_true(all(match(x$ARBITER_label[1:4],LABELS)>match(x$meta[1:4],LABELS)))
  expect_true(all(x$preferred==x$ARBITER_label))
  expect_true(all(x$passage_words<=30))
  expect_true(all(mapply(function(p,f) grepl(p,f,fixed=TRUE),x$passage,x$full_passage)))
  expect_true(all(x$verification_status=='verified'))
  expect_equal(trace_binding_text(x[1,]),paste0(
    'Span bound to captured source: S2213-8587-18-30023-8.pdf, page 5, lines 45\u201347; source hash 6fecb407\u2026\n',
    'Independent bundle verifier: verified (content hashes, claims, lineage)'))
})
