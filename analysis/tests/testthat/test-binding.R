source(file.path(analysis_dir,'R','bundle-review.R'))

test_that('binding requires all structural fields without inferring support', {
  e <- list(quote='Captured text',source_id='s1',source_version='hash',page=1,start=0,end=10)
  expect_true(evidence_is_bound(e,'s1'))
  for(field in names(e)) {
    bad <- e; bad[[field]] <- NULL
    expect_false(evidence_is_bound(bad,'s1'),info=field)
  }
  for(field in c('quote','source_id','source_version')) {
    bad <- e; bad[[field]] <- '  '
    expect_false(evidence_is_bound(bad,'s1'),info=field)
  }
  expect_false(evidence_is_bound(e,'another-source'))
  bad <- e; bad$end <- bad$start
  expect_false(evidence_is_bound(bad,'s1'))
  bad$end <- -1
  expect_false(evidence_is_bound(bad,'s1'))
  expect_false(evidence_is_bound(NULL,'s1'))
})

test_that('binding counts distinct cited records from current active answers', {
  answer <- function(q,ids) list(question_id=q,bases=lapply(ids,function(id) list(evidence=id)))
  e <- list(quote='text',source_id='s1',source_version='hash',page=1,start=0,end=4)
  current <- list(active_questions=list('active'),answers=list(
    answer('active',c('good','good','bad','absent')),answer('inactive','unused')))
  current$answers[[1]]$counterevidence <- list(list(evidence='counter'))
  canonical <- list(batch=list(trials=list(list(sources=list(list(id='s1'))))),
    domain_records=list(current),domain_history_records=list(list(list(
      active_questions=list('historical'),answers=list(answer('historical','old'))))))
  bad <- e; bad$source_id <- 'foreign'
  expect_equal(bundle_binding_counts(canonical,list(good=e,bad=bad,counter=e)),
    c(cited_records=4,bound_records=2))
  canonical$domain_records <- list()
  expect_equal(bundle_binding_counts(canonical,list()),c(cited_records=0,bound_records=0))
})
