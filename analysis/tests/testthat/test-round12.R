source(file.path(analysis_dir,'R','manuscript-supplement.R'))
source(file.path(analysis_dir,'R','manuscript-legends.R'))
source(file.path(analysis_dir,'R','results-sentences.R'))
test_that('Round 14 main and supplementary legends stay concise and have alt text', {
 old <- getwd(); setwd(analysis_dir); on.exit(setwd(old))
 for(s in figure_legend_sections()[3:6]) {
   expect_lte(length(strsplit(sub('\\n\\nAlt text:.*','',s),'\\s+')[[1]]),120)
   expect_match(s,'Alt text:')
 }
 for(e in supplement_registry(inputs)) expect_true(length(strsplit(e$note,'\\s+')[[1]])<=140,info=e$caption)
 expect_false(any(grepl('^[0-9]',results_sentences())))
 expect_identical(paste(readLines('output/manuscript/results-sentences.md'),collapse='\n'),paste(results_sentences(),collapse='\n\n'))
})
