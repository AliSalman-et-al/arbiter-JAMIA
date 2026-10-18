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
    c(cited_records=4,bound_records=2,text_records=3,text_bound=2,
      visual_records=0,visual_bound=0,other_records=1,visual_trial=0))
  canonical$domain_records <- list()
  expect_equal(bundle_binding_counts(canonical,list()),c(cited_records=0,bound_records=0,text_records=0,text_bound=0,
      visual_records=0,visual_bound=0,other_records=0,visual_trial=0))
})


test_that('visual binding checks the rendered source, page, hash, region and transcription', {
  e <- list(kind='figure',source_id='s1',render=list(source_id='s1',page=2,png_sha256='hash'),
    region=list(0,0.1,1,0.9),transcription='Model description')
  expect_equal(evidence_kind(e),'visual')
  expect_true(evidence_is_bound(e,'s1'))
  for(field in c('source_id','render','region','transcription')) {
    bad <- e; bad[[field]] <- NULL
    expect_false(evidence_is_bound(bad,'s1'),info=field)
  }
  for(field in names(e$render)) {
    bad <- e; bad$render[[field]] <- NULL
    expect_false(evidence_is_bound(bad,'s1'),info=field)
  }
  for(page in list(0,-1,1.5,Inf,NA_real_,'2',c(1,2))) {
    bad <- e; bad$render$page <- page
    expect_false(evidence_is_bound(bad,'s1'))
  }
  for(region in list(c(0,0,0,1),c(0,1,1,0),c(-0.1,0,1,1),c(0,0,1,1.1),
    c(0,0,1),c(0,0,1,NA),list(0,0,'1',1),list(c(0,0),0,1,1))) {
    bad <- e; bad$region <- region
    expect_false(evidence_is_bound(bad,'s1'))
  }
  bad <- e; bad$render$source_id <- 'foreign'
  expect_false(evidence_is_bound(bad,'s1'))
  expect_false(evidence_is_bound(e,'foreign'))
  bad <- e; bad$transcription <- ' '
  expect_false(evidence_is_bound(bad,'s1'))
  bad <- e; bad$render$png_sha256 <- ''
  expect_false(evidence_is_bound(bad,'s1'))
  e$kind <- 'custom'; e$quote <- 'hybrid'
  expect_equal(evidence_kind(e),'visual')
  expect_true(evidence_is_bound(e,'s1'))
  expect_equal(evidence_kind(list(kind='narrative')),'text')
  expect_equal(evidence_kind(list(start=0)),'text')
  expect_equal(evidence_kind(list(kind='unknown')),'other')
})

test_that('mixed citations partition into text, visual and other without dropping records', {
  text <- list(quote='text',source_id='s1',source_version='hash',page=1,start=0,end=4)
  visual <- list(kind='figure',source_id='s1',render=list(source_id='s1',page=1,png_sha256='hash'),
    region=c(0,0,1,1),transcription='Description')
  malformed <- visual; malformed$region <- c(1,0,0,1)
  ids <- c('text','visual','visual','malformed','other','missing')
  canonical <- list(batch=list(trials=list(list(sources=list(list(id='s1'))))),
    domain_records=list(list(active_questions=list('q'),answers=list(list(question_id='q',
      bases=lapply(ids,function(id) list(evidence=id)))))))
  expect_equal(bundle_binding_counts(canonical,list(text=text,visual=visual,malformed=malformed,
    other=list(kind='unknown'))),c(cited_records=5,bound_records=2,text_records=1,text_bound=1,
      visual_records=2,visual_bound=1,other_records=2,visual_trial=1))
})
