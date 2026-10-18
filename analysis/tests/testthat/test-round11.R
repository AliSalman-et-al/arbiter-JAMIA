source(file.path(analysis_dir,'R','presentation.R'))
source(file.path(analysis_dir,'R','round11.R'))
source(file.path(analysis_dir,'R','avatar-trace.R'))
source(file.path(analysis_dir,'R','manuscript-tables.R'))

testthat::test_that('Published direction counts reproduce every domain and pooled total', {
  cells <- adjudication_cells(inputs)
  x <- published_direction_counts(cells)
  expected <- rbind(c(9,2,7),c(11,11,10),c(19,5,0),c(9,3,2),c(30,8,3),c(78,29,22))
  for(i in 1:6) {
    z <- x[x$domain==c(paste0('D',1:5),'All')[i],]
    testthat::expect_equal(z$n[match(c('Less severe','Equal','More severe'),z$direction)],expected[i,])
    testthat::expect_equal(unique(z$total),sum(expected[i,]))
  }
})
testthat::test_that('vindication partitions disagreements including splits', {
  cells <- adjudication_cells(inputs)
  x <- vindicated_disagreements(cells)
  for(i in 1:4) {
    source <- rep(c('ARBITER','Unassisted'),each=2)[i]
    direction <- rep(c('More severe','Less severe'),2)[i]
    z <- x[x$source==source & x$direction==direction,]
    testthat::expect_equal(z$n[z$outcome=='Vindicated'],c(73,22,48,19)[i])
    testthat::expect_equal(unique(z$consensus_n),c(77,28,59,38)[i])
    testthat::expect_equal(sum(z$n),unique(z$all_n))
    label <- cells[[if(source=='ARBITER') 'kit' else 'nokit']]
    eligible <- label!=cells$meta & if(direction=='More severe') match(label,LABELS)>match(cells$meta,LABELS) else match(label,LABELS)<match(cells$meta,LABELS)
    testthat::expect_equal(z$n[z$outcome=='Split'],sum(eligible & !cells$consensus))
    testthat::expect_equal(z$n[z$outcome=='Published upheld'],sum(eligible & cells$consensus & !is.na(cells$preferred) & cells$preferred==cells$meta))
  }
  testthat::expect_equal(x |> filter(outcome=='Vindicated') |> group_by(source) |> summarise(n=sum(n)) |> pull(n),c(95,67))
})
testthat::test_that('severity stratification retains the shared bootstrap and all outcomes', {
  weights <- stratified_cluster_weights(inputs$trials,10000,20261018)
  cells <- adjudication_cells(inputs)
  x <- severity_win_share(cells,weights)
  testthat::expect_equal(x$count,c(44,1,0,10,6,1))
  testthat::expect_equal(x$n,c(45,45,45,17,17,17))
  testthat::expect_equal(x$estimate,x$count/x$n)
  for(d in c('ARBITER more severe','ARBITER less severe')) {
    z <- cells |> filter(consensus,discordant)
    keep <- match(z$kit,LABELS)>match(z$nokit,LABELS)
    if(d=='ARBITER less severe') keep <- !keep
    w <- bootstrap_rows(z[keep,],weights)
    win <- z$preferred[keep]==z$kit[keep]
    ci <- quantile((colSums(w*win)/colSums(w))[-1],c(.025,.975),na.rm=TRUE,names=FALSE)
    testthat::expect_equal(unlist(x[x$direction==d & x$metric=='ARBITER',c('lower','upper')],use.names=FALSE),ci)
  }
  testthat::expect_true(all(x$valid_replicates==10000))
})
testthat::test_that('grey remainder reconciles distinct decisive cells with eligible losses', {
  x <- localise_errors(inputs,adjudication_cells(inputs))$cells
  r <- no_decisive_counts(x)
  testthat::expect_equal(r$eligible,r$with_decisive+r$n)
  testthat::expect_equal(r$n,c(0,0,0,2,2,7,1,5,0,4))
  testthat::expect_equal(r$with_decisive,c(1,3,4,6,0,1,0,1,2,18))
  testthat::expect_equal(sum(r$eligible[r$source=='ARBITER-Sonnet']),10)
  testthat::expect_equal(sum(r$eligible[r$source=='Baseline-Sonnet']),47)
  for(i in seq_len(nrow(r))) {
    z <- x |> filter(population=='Primary',domain==r$domain[i],source==r$source[i])
    testthat::expect_equal(r$n[i],sum(is.na(z$decisive_questions)|!nzchar(z$decisive_questions)))
  }
})
testthat::test_that('AVATAR trace includes all questions and original rationale', {
  old <- getwd(); setwd(analysis_dir); on.exit(setwd(old))
  blocks <- avatar_trace_blocks(inputs)
  answers <- blocks[[1]]$data; evidence <- blocks[[2]]$data
  testthat::expect_equal(sum(grepl('^[1-5][.]',answers$Question)),22)
  testthat::expect_equal(nrow(answers),28)
  testthat::expect_equal(nrow(evidence),16)
  testthat::expect_false(anyDuplicated(evidence$Handle)>0)
  testthat::expect_true('Overall' %in% answers$Question)
  rationale <- jsonlite::fromJSON('data-derived/avatar-unassisted-rationale.json')
  for(d in paste0('D',1:5)) {
    value <- answers$Unassisted[answers$Question==paste(d,'judgement / rationale')]
    testthat::expect_identical(sub('^[^\\n]*\\n','',value),rationale[[d]])
  }
  bundle <- jsonlite::fromJSON('data-derived/avatar-trace.json',simplifyVector=FALSE)
  testthat::expect_setequal(evidence$`Full verbatim quote`,vapply(bundle$proposal$evidence,function(e) e$quote,character(1)))
  for(rec in bundle$domain_records) for(a in rec$answers) {
    q <- question_map()$question[match(a$question_id,question_map()$question_id)]
    answer <- answers[startsWith(answers$Question,paste0(q,' ')),]
    for(basis in a$bases) {
      e <- bundle$proposal$evidence[[basis$evidence]]
      testthat::expect_true(grepl(paste0(e$handle,' (',gsub('_',' ',basis$kind,fixed=TRUE),')'),answer$`Evidence handles (type)`,fixed=TRUE))
      testthat::expect_identical(evidence$`Full verbatim quote`[evidence$Handle==e$handle],e$quote)
    }
  }
})
testthat::test_that('main tables retain requested denominators and slim audit layout', {
  old <- getwd(); setwd(analysis_dir); on.exit(setwd(old))
  t2 <- main_table2(); t3 <- main_table3()
  testthat::expect_true(any(grepl('Not Low N = 83',t2$Source,fixed=TRUE)))
  testthat::expect_false(any(grepl('[0-9]/[0-9]',unlist(t2))))
  testthat::expect_true(any(grepl('66.3 (57.3–74.7)',unlist(t2),fixed=TRUE)))
  testthat::expect_identical(names(t3),c('Measure','ARBITER','Unassisted'))
  testthat::expect_false(any(t3$Measure %in% c('All evidence bound','Proposed judgement matches algorithm')))
  testthat::expect_equal(sum(grepl('*',t3$ARBITER,fixed=TRUE)),4)
})

testthat::test_that('all primary figure rows retain label-based counts and CIs', {
  cells <- adjudication_cells(inputs)
  weights <- stratified_cluster_weights(inputs$trials,10000,20261018)
  out <- bind_rows(lapply(c('Consensus','A','Z','Split sensitivity'),function(a) win_share(cells,weights,a)))
  testthat::expect_equal(out$count,c(54,7,1,60,16,4,64,15,1,54,7,19))
  testthat::expect_equal(out$n,rep(c(62,80,80,80),each=3))
  testthat::expect_equal(out$estimate,out$count/out$n)
  testthat::expect_equal(out$lower[out$metric=='ARBITER'],c(.7903225806451613,2/3,.7233960720130934,.5866666666666667))
  testthat::expect_equal(out$upper[out$metric=='ARBITER'],c(.9433962264150944,5/6,.872093023255814,.7631578947368421))
})

testthat::test_that('supplementary disagreement matrix retains every disputed cell', {
  x <- disagreement_pattern_counts(adjudication_cells(inputs))
  expected <- list(
    'ARBITER only disagreed with Published'=c(30,2,0,0,7),
    'Unassisted only disagreed with Published'=c(21,3,0,0,6),
    'Both disagreed with Published, different labels'=c(3,2,0,1,5),
    'Both disagreed with Published, same label'=c(0,0,62,5,7))
  outcomes <- c('ARBITER only preferred','Unassisted only preferred','Both arms preferred','Published only preferred','Adjudicators split')
  for(p in names(expected)) {
    z <- x[x$disagreement==p,]
    testthat::expect_equal(z$n[match(outcomes,z$outcome)],expected[[p]])
  }
  testthat::expect_equal(sum(x$n),154)
})


testthat::test_that('revised figure layouts and supplied legends retain their contracts', {
  old <- getwd(); setwd(analysis_dir); on.exit(setwd(old))
  source('R/manuscript-figures.R'); source('R/manuscript-legends.R')
  nodes <- study_flow_nodes()
  testthat::expect_equal(nodes$x[c(1,2,4,5,6)],rep(0,5))
  testthat::expect_equal(nodes$w[c(1,2,4,5,6)],rep(5.1,5))
  testthat::expect_equal(nodes$x[7],-nodes$x[8])
  testthat::expect_equal(nodes$w[7],nodes$w[8])
  testthat::expect_gt(nodes$x[3],0)
  p <- decisive_question_plot()
  testthat::expect_false(any(p$data$domain=='D1' & p$data$question=='remainder'))
  testthat::expect_identical(p$labels$x,'Count')
  testthat::expect_equal(unname(p$scales$get_scales('fill')$palette(4)[3:4]),c('#B2E3F2','#F5DDC7'))
  direction <- published_reference_plot()[[2]]
  scale <- direction$scales$get_scales('fill')
  testthat::expect_equal(unname(scale$palette(3)),c('#374E55','#94A1A6','#DCE1E3'))
  testthat::expect_identical(levels(direction$data$direction),c('Less severe','Equal','More severe'))
  built <- ggplot2::ggplot_build(direction)$data
  testthat::expect_equal(built[[2]]$x,(built[[1]]$xmin+built[[1]]$xmax)/2)
  primary <- adjudication_plot(NULL)
  testthat::expect_gt(primary[[1]]$layers[[5]]$data$x,.5)
  testthat::expect_true(all(grepl('vindicated · ',rlang::eval_tidy(primary[[2]]$layers[[3]]$mapping$label,primary[[2]]$layers[[3]]$data),fixed=TRUE)))
  sections <- figure_legend_sections()
  supplied <- supplied_figure_legends()
  testthat::expect_identical(sections[1:2],supplied)
  testthat::expect_true(all(grepl('Alt text:',unlist(sections),fixed=TRUE)))
  testthat::expect_false(any(grepl('Legend supplied',unlist(sections),fixed=TRUE)))
})
