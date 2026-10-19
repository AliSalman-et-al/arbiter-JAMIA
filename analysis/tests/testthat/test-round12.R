source(file.path(analysis_dir,'R','manuscript-supplement.R'))
source(file.path(analysis_dir,'R','manuscript-legends.R'))
source(file.path(analysis_dir,'R','results-sentences.R'))

testthat::test_that('round 12 titles state findings and legends stay concise', {
  old <- getwd(); setwd(analysis_dir); on.exit(setwd(old))
  sections <- figure_legend_sections()[3:6]
  testthat::expect_true(all(grepl('trials|agreed|chose|traced',names(sections))))
  testthat::expect_true(all(grepl('supplied|detected|broke|agreed',MAIN_TABLE_TITLES)))
  for(section in sections) {
    legend <- sub('\\n\\nAlt text:.*','',section)
    alt <- sub('.*Alt text: ','',section)
    testthat::expect_lte(length(strsplit(legend,'\\s+')[[1]]),140)
    testthat::expect_lte(length(strsplit(alt,'\\s+')[[1]]),80)
  }
  all_sections <- figure_legend_sections()
  testthat::expect_false(any(grepl('{{eTable:',unlist(all_sections),fixed=TRUE)))
})

testthat::test_that('round 12 figures use one home and one unit', {
  old <- getwd(); setwd(analysis_dir); on.exit(setwd(old))
  source('R/manuscript-figures.R')
  flow <- paste(study_flow_nodes()$label,figure_legend_sections()[[3]],collapse=' ')
  testthat::expect_false(grepl('\\b54\\b|7 Unassisted|1 neither',flow))
  testthat::expect_setequal(as.character(published_reference_plot()[[1]]$data$domain),paste0('D',1:5))
  q <- decisive_question_plot()
  testthat::expect_false(any(q$data$question=='remainder'))
  testthat::expect_true(all(grepl('No single deciding question',q$data$facet,fixed=TRUE)))
  testthat::expect_setequal(q$data$bar_fill,c('ARBITER','Unassisted'))
})

testthat::test_that('main tables move AC2 and composite results to supplement', {
  old <- getwd(); setwd(analysis_dir); on.exit(setwd(old))
  testthat::expect_false('AC2' %in% names(main_table2()))
  testthat::expect_false('AC2' %in% names(main_table4()))
  testthat::expect_false(any(grepl('Composite',main_table2()$Source)))
  testthat::expect_equal(sum(main_table3()$ARBITER=='0 by design'),8)
  registry <- supplement_registry(inputs)
  captions <- vapply(registry,`[[`,character(1),'caption')
  testthat::expect_equal(sum(grepl('Composite-reference.*by adjudicator',captions)),2)
  testthat::expect_equal(captions[1],'AVATAR complete trace')
  testthat::expect_equal(supplement_number('AVATAR complete trace'),1)
})

testthat::test_that('generated results sentences match CSV estimates and counts', {
  old <- getwd(); setwd(analysis_dir); on.exit(setwd(old))
  sentences <- results_sentences()
  saved <- paste(readLines('output/manuscript/results-sentences.md',encoding='UTF-8'),collapse='\n')
  testthat::expect_identical(saved,paste(sentences,collapse='\n\n'))
  p <- manuscript_data('primary-endpoint') |> filter(analysis=='Consensus',metric=='ARBITER')
  testthat::expect_true(grepl(sprintf('%s of %s',p$count,p$n),sentences[3],fixed=TRUE))
  testthat::expect_true(grepl(sprintf('%.1f–%.1f',100*p$lower,100*p$upper),sentences[3],fixed=TRUE))
  f <- manuscript_data('error-localisation-frequency') |> filter(population=='Primary',source=='Baseline-Sonnet',question==5.1)
  r <- manuscript_data('no-decisive-counts') |> filter(source=='Baseline-Sonnet')
  testthat::expect_true(grepl(sprintf('Among the %s eligible unassisted ratings',sum(r$eligible)),sentences[4],fixed=TRUE))
  d <- manuscript_data('table3') |> filter(arm=='Baseline-Sonnet',domain=='D1-D5',status=='Departure')
  testthat::expect_true(grepl(sprintf('%s of %s',d$count,d$n),sentences[7],fixed=TRUE))
  testthat::expect_true(all(grepl('Figure [3-6]|Table [1-4]',sentences[1:8])))
})
testthat::test_that('handoff placeholders and benchmark title follow the shared data', {
  old <- getwd(); setwd(analysis_dir); on.exit(setwd(old))
  path <- tempfile(fileext='.md')
  writeLines(c('**Figure 1. Workflow.** Caption.','Alt text: Workflow.',
    '**Figure 2. Example.** Full trace: {{eTable:avatar-trace}}.','Alt text: Trace.'),path)
  sections <- supplied_figure_legends(path)
  testthat::expect_true(grepl(paste('eTable',supplement_number('AVATAR complete trace')),sections[[2]],fixed=TRUE))
  testthat::expect_false(grepl('{{eTable:',sections[[2]],fixed=TRUE))
  meta <- readr::read_csv('data-curated/meta-analyses.csv',show_col_types=FALSE)
  testthat::expect_true(grepl(paste(length(unique(meta$specialty)),'specialties'),MAIN_TABLE_TITLES[1],fixed=TRUE))
  s <- results_sentences()
  sensitivity <- manuscript_data('table2') |> filter(domain=='D1-D5',metric=='sensitivity',arm %in% c('ARBITER-Sonnet','Baseline-Sonnet'))
  for(v in sensitivity$estimate) testthat::expect_true(grepl(sprintf('%.1f%%',100*v),s[6],fixed=TRUE))
  rel <- manuscript_data('table4-reliability') |> filter(metric=='accuracy',grepl('independent vs ARBITER',comparison))
  for(v in rel$count) testthat::expect_true(grepl(as.character(v),s[8],fixed=TRUE))
  process <- manuscript_data('table5')
  for(j in 2:4) for(i in 1:2) testthat::expect_true(grepl(fmt_process_text(process[[j]][i]),s[9],fixed=TRUE))
})
testthat::test_that('finding titles are present in generated Word, legend and HTML outputs', {
  old <- getwd(); setwd(analysis_dir); on.exit(setwd(old))
  html <- reader_html_text('results.html')
  for(i in 1:4) {
    text <- officer::docx_summary(officer::read_docx(paste0('output/manuscript/Table',i,'.docx')))$text
    testthat::expect_true(any(grepl(MAIN_TABLE_TITLES[i],text,fixed=TRUE)))
    testthat::expect_true(any(grepl(MAIN_TABLE_TITLES[i],html,fixed=TRUE)))
  }
  saved <- readLines('output/manuscript/figure-legends.md',encoding='UTF-8',warn=FALSE)
  for(title in names(figure_legend_sections())[3:6]) testthat::expect_true(any(grepl(title,saved,fixed=TRUE)))
})
testthat::test_that('merged composite sensitivity tables retain an Adjudicator column', {
  old <- getwd(); setwd(analysis_dir); on.exit(setwd(old))
  entries <- supplement_registry(inputs)
  for(e in entries[grepl('^Composite-reference',vapply(entries,`[[`,character(1),'caption'))])
    testthat::expect_true('Adjudicator' %in% supplement_table(e)$col_keys)
})
testthat::test_that('every supplementary note stays within the legend ceiling', {
  old <- getwd(); setwd(analysis_dir); on.exit(setwd(old))
  for(e in supplement_registry(inputs))
    testthat::expect_true(length(strsplit(e$note,'\\s+')[[1]])<=140,info=e$caption)
})
