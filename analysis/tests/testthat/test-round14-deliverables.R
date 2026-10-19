for(f in c('publication-io','presentation','manuscript-tables','avatar-trace','manuscript-supplement','manuscript-legends','results-sentences'))
 source(file.path(analysis_dir,'R',paste0(f,'.R')))
test_that('Round 14 published files use current numbering, reader labels and inventories', {
 old <- getwd(); setwd(analysis_dir); on.exit(setwd(old))
 entries <- supplement_registry(inputs)
 captions <- vapply(entries,`[[`,character(1),'caption')
 expect_equal(length(entries),30L)
 expect_equal(supplement_number('AVATAR complete trace'),3L)
 expect_false(any(grepl('Haiku|Recorded model override|disagreement-pattern',captions)))
 expect_equal(sum(grepl('Post hoc|post hoc',captions)),4L)
 expect_true(all(c('Benchmark trials span sixteen meta-analyses','Published labels were usually less severe than the agreed choice') %in% captions))
 for(i in 1:4) {
   text <- officer::docx_summary(officer::read_docx(paste0('output/manuscript/Table',i,'.docx')))$text
   expect_true(any(grepl(MAIN_TABLE_TITLES[i],text,fixed=TRUE)))
   expect_false(any(grepl('Haiku|ARBITER-Sonnet|Baseline-Sonnet',text)))
 }
 expect_true(all(file.exists(paste0('output/manuscript/Figure',1:6,'.png'))))
 expect_false(file.exists('output/manuscript/eFigure2.png'))
 for(s in results_sentences()) expect_false(grepl('^[0-9]|over-flagging|supported by evidence',s))
 expected <- list(main_table2(),reliability_table(),main_table3(),prior_work_table())
 for(i in 1:4) expect_equal(ncol(expected[[i]]),length(main_table_widths(i)))
 expect_lte(sum(main_table_widths(4)),6.97)
})
test_that('CSV reader-label translation is lossless for statistical builders', {
 d <- tibble(arm=c('ARBITER-Sonnet','Baseline-Sonnet','Meta'),
  comparison=c('ARBITER-Sonnet minus Baseline-Sonnet','A independent vs meta label','A vs Z independent'),
  metric=c('Baseline','Violation','Invalid answer path'),estimate=c(.1,.2,.3))
 expect_identical(publication_labels(publication_labels(d),TRUE),d)
})
test_that('direction display keeps reader source names and both arm colours', {
 old <- getwd(); setwd(analysis_dir); on.exit(setwd(old))
 source('R/manuscript-figures.R')
 d <- tibble(source=c('ARBITER','Unassisted'),metric=c('ARBITER','Baseline'))
 expect_identical(publication_labels(publication_labels(d),TRUE),d)
 p <- direction_disagreement_plot()
 expect_setequal(p$data$source,c('ARBITER','Unassisted'))
 expect_identical(unname(p$scales$get_scales('colour')$palette(2)[c('ARBITER','Unassisted')]),unname(JAMA_ROLES[c('ARBITER','Unassisted')]))
})
test_that('supplement keeps each full-agreement source together and Table 4 header words fit', {
 old <- getwd(); setwd(analysis_dir); on.exit(setwd(old))
 entries <- supplement_registry(inputs)
 e <- entries[[supplement_number('Agreement against Published, all sources and domains')]]
 expect_equal(length(e$blocks),3L)
 expect_equal(vapply(e$blocks,function(b) nrow(b$data),integer(1)),rep(7L,3))
 x <- prior_work_table()
 for(j in seq_along(x)) {
   words <- strsplit(names(x)[j],' ')[[1]]
   need <- systemfonts::string_width(words,family='Arial',weight='bold',size=9,res=720)/720+2*main_table_padding(4)/72
   expect_true(all(need<=main_table_widths(4)[j]),info=names(x)[j])
 }
})
