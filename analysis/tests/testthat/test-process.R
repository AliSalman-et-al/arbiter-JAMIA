test_that('streamed extraction stops on absent inputs and never writes empty CSVs', {
  absent <- file.path(tempdir(),'absent-arbiter-raw-inputs')
  output <- file.path(tempdir(),'absent-arbiter-derived-output')
  expect_error(extract_run_metrics(absent,output))
  expect_false(dir.exists(output))
})

test_that('committed derived files cover exactly the analysis set and preserve continue counts', {
  m <- load_run_metrics(file.path(analysis_dir,'data-derived'))
  expect_equal(nrow(m),408L)
  expect_false(any(m$slug %in% EXCLUDED))
  expect_equal(m$continues,m$continues_csv)
  expect_true(all(is.na(m$approved[grepl('Baseline',m$arm)])))
  expect_true(all(m$approved[startsWith(m$arm,'ARBITER')]))
})

test_that('proposals follow official algorithms and the single departure is recorded', {
  m <- load_run_metrics(file.path(analysis_dir,'data-derived'))
  d <- bundle_decision_cells(m)
  expect_no_error(validate_proposed_gate(d,inputs$labels))
  expect_equal(sum(d$override),1L)
  expect_equal(d$slug[d$override],'hill-2017')
  expect_true(nzchar(d$rationale[d$override]))
  expect_true(nzchar(d$evidence[d$override]))
  d$proposed[1] <- 'incorrect'
  expect_error(validate_proposed_gate(d,inputs$labels),'bundle validation gate failed')
})

test_that('process differences are paired by trial, not row order', {
  a <- tibble(arm='ARBITER-Sonnet',slug=c('a','b'))
  b <- tibble(arm='Baseline-Sonnet',slug=c('b','a'))
  fields <- c('wall_seconds','input_tokens','cache_creation_tokens','cache_read_tokens',
    'output_tokens','thinking_tokens','cost_usd','turns','agent_steps','continues')
  for(f in fields) { a[[f]]<-c(5,10); b[[f]]<-c(4,3) }
  w <- stratified_cluster_weights(tibble(slug=c('a','b'),meta_id='m'),100,4)
  d <- paired_process_difference(bind_rows(a,b),w)
  expect_true(all(d$estimate[d$estimand=='Mean paired trial difference']==4))
  expect_true(all(d$estimate[d$estimand=='Total paired difference']==8))
})
