source('R/load.R')
for(f in setdiff(list.files('R',pattern='[.]R$',full.names=TRUE),'R/load.R')) source(f)
inputs <- load_inputs()
read_output <- function(name) readr::read_csv(paste0('output/tables/',name,'.csv'),show_col_types=FALSE)
check <- function(ok,message) {
  if(!isTRUE(ok)) stop(message,call.=FALSE)
  cat('PASS ',message,'\n',sep='')
}

workbooks <- lapply(1:2,function(i) {
  x <- readxl::read_xlsx(paste0('../human-adjudication/adjudication-with-explanations-',i,'.xlsx'),
    sheet='Adjudications',col_types='text')
  x[!x$Trial %in% EXCLUDED,]
})
a <- workbooks[[1]]
b <- workbooks[[2]][match(paste(a$Trial,a$Domain),paste(workbooks[[2]]$Trial,workbooks[[2]]$Domain)),]
check(nrow(a)==510L && nrow(b)==510L && !anyNA(b$Trial),'two independent workbooks cover the same 510 trial-domain cells')
differ <- a$Kit!=a$`No-kit`
agreed <- a$`Chosen label`==b$`Chosen label`
keep <- differ & agreed
check(sum(differ)==80L && sum(keep)==60L && sum(differ & !agreed)==20L,
  'conditional choice population is 80 disagreements, 60 agreed choices and 20 splits')
choices <- read_output('primary-endpoint')
expected_choices <- list(Consensus=c(53L,7L,0L),`Expert 1`=c(63L,13L,4L),
  `Expert 2`=c(61L,19L,0L),`Split sensitivity`=c(53L,7L,20L))
for(analysis_name in names(expected_choices)) {
  x <- choices[choices$analysis==analysis_name,]
  expected_n <- if(analysis_name=='Consensus') 60L else 80L
  check(nrow(x)==3L && all(x$count==expected_choices[[analysis_name]]) && all(x$n==expected_n),
    paste('conditional choice counts for',analysis_name))
}

ordinal_kappa <- function(reference,prediction) {
  missing <- is.na(prediction)
  prediction[missing] <- ifelse(reference[missing]=='Low','High','Low')
  p <- table(factor(reference,levels=LABELS),factor(prediction,levels=LABELS))/length(reference)
  w <- 1-abs(outer(1:3,1:3,'-'))/2
  observed <- sum(p*w)
  expected <- sum(outer(rowSums(p),colSums(p))*w)
  (observed-expected)/(1-expected)
}
est <- read_output('independent-estimates')
check(setequal(est$adjudicator,c('1','2')) && setequal(est$domain,c('D1-D5',paste0('D',1:5),'Overall')) &&
  setequal(est$metric,c('accuracy','kappa')) && nrow(est)==80L,
  'independent estimates use separate experts, domain ratings and a compact derived Overall check')
for(expert in 1:2) for(source_name in c('ARBITER','Unassisted','Published')) for(domain_name in c('D1-D5',paste0('D',1:5))) {
  reference <- workbooks[[expert]]$Independent
  prediction <- switch(source_name,ARBITER=workbooks[[expert]]$Kit,
    Unassisted=workbooks[[expert]]$`No-kit`,Published=workbooks[[expert]]$Human)
  include <- if(domain_name=='D1-D5') rep(TRUE,510L) else workbooks[[expert]]$Domain==domain_name
  x <- est[est$adjudicator==as.character(expert) & est$source==source_name & est$domain==domain_name,]
  accuracy <- x[x$metric=='accuracy',]
  kappa <- x[x$metric=='kappa',]
  count <- sum(!is.na(prediction[include]) & prediction[include]==reference[include])
  stopifnot(nrow(x)==2L,accuracy$n==sum(include),accuracy$count==count,
    abs(accuracy$estimate-count/sum(include))<1e-12,
    abs(kappa$estimate-ordinal_kappa(reference[include],prediction[include]))<1e-12)
}
cat('PASS all independent exact and weighted agreement values reproduce directly from workbook ratings.\n')
derived <- lapply(workbooks,function(book) book |>
  group_by(Trial) |> summarise(reference=LABELS[max(match(Independent,LABELS))],.groups='drop'))
for(expert in 1:2) for(source_name in c('ARBITER','Unassisted')) {
  prediction <- inputs$labels |> filter(arm==if(source_name=='ARBITER') 'ARBITER-Sonnet' else 'Baseline-Sonnet',domain=='Overall')
  d <- derived[[expert]] |> inner_join(prediction,by=c('Trial'='slug'))
  x <- est |> filter(adjudicator==as.character(expert),source==source_name,domain=='Overall')
  accuracy <- filter(x,metric=='accuracy')
  kappa <- filter(x,metric=='kappa')
  stopifnot(nrow(d)==102L,nrow(x)==2L,all(x$population=='All trials'),
    accuracy$n==102L,accuracy$count==sum(!is.na(d$label)&d$label==d$reference),
    abs(kappa$estimate-ordinal_kappa(d$reference,d$label))<1e-12)
}
check(!any(est$domain=='Overall' & est$source=='Published'),
  'derived Overall has no different-population Published comparison')
paired <- read_output('independent-differences')
check(all(paired$comparison=='ARBITER minus Unassisted') && nrow(paired)==28L,
  'paired expert comparisons contain only the retained arm contrast')
reliability <- read_output('expert-reliability')
pooled <- reliability[reliability$domain=='D1-D5' & reliability$metric=='accuracy',]
check(pooled$n==510L && pooled$count==sum(a$Independent==b$Independent) && pooled$count==388L,
  'expert agreement is 388 of 510 cells')
overall_references <- inner_join(derived[[1]],derived[[2]],by='Trial',suffix=c('_1','_2'))
overall_reliability <- reliability |> filter(domain=='Overall',metric=='accuracy')
check(overall_reliability$n==102L && overall_reliability$count==sum(overall_references$reference_1==overall_references$reference_2) &&
  overall_reliability$count==52L,'derived expert Overall agreement is 52 of 102 trials')

repairs <- read_output('rules-only-changed')
repaired_agreement <- read_output('rules-only-agreement')
checks <- domain_checks(inputs)
contradictions <- checks |> filter(arm=='Baseline-Sonnet',status=='Violation') |>
  select(slug,domain,algorithm)
stopifnot(nrow(repairs)==26L,nrow(repaired_agreement)==4L,
  nrow(inner_join(repairs,contradictions,by=c('slug','domain')))==26L)
repaired <- inputs$labels |> filter(arm=='Baseline-Sonnet',domain!='Overall') |>
  left_join(contradictions,by=c('slug','domain')) |> mutate(label=coalesce(algorithm,label))
for(expert in 1:2) {
  d <- workbooks[[expert]] |> transmute(slug=Trial,domain=Domain,reference=Independent) |>
    inner_join(repaired,by=c('slug','domain'))
  x <- repaired_agreement |> filter(adjudicator==as.character(expert))
  accuracy <- filter(x,metric=='accuracy')
  kappa <- filter(x,metric=='kappa')
  stopifnot(all(x$source=='Unassisted' & x$domain=='D1-D5'),accuracy$n==510L,
    accuracy$count==sum(!is.na(d$label)&d$label==d$reference),accuracy$count==c(324L,391L)[expert],
    abs(kappa$estimate-ordinal_kappa(d$reference,d$label))<1e-12)
}
cat('PASS pooled rules-only agreement reproduces from the 26 contradictory labels, with invalid paths retained.\n')

published <- read_output('agreement-meta')
check(!any(published$domain=='Overall') && setequal(published$metric,c('accuracy','kappa')),
  'Published agreement contains domain exact agreement and weighted kappa')
for(source_name in unique(published$arm)) for(domain_name in unique(published$domain)) {
  d <- inputs$labels |> filter(arm==if(source_name=='Unassisted (Sonnet 5.5)') 'Baseline-Sonnet' else 'ARBITER-Sonnet',
    if(domain_name=='D1-D5') domain!='Overall' else domain==domain_name)
  prediction <- if(source_name=='All-Low rule') rep('Low',nrow(d)) else d$label
  x <- published |> filter(arm==source_name,domain==domain_name,metric=='accuracy')
  stopifnot(nrow(x)==1L,x$n==nrow(d),x$count==sum(!is.na(prediction)&prediction==d$meta))
}
cat('PASS Published and All-Low exact agreement counts reproduce from source labels.\n')

signals <- read_output('signalling-estimates')
signal_delta <- read_output('signalling-differences')
check(setequal(signals$group,c('Overall',paste0('D',1:5))) && setequal(signals$level,c('five','collapsed')) &&
  nrow(signals)==48L && nrow(signal_delta)==112L &&
  setequal(signal_delta$group,c('Overall',paste0('D',1:5),question_map()$question)),
  'signalling tables retain pooled/domain summaries and complete paired question results with both codings')
comparisons <- readr::read_csv('data-derived/expert-signalling-comparisons.csv',show_col_types=FALSE)
for(i in seq_len(nrow(signals))) {
  x <- signals[i,]
  d <- comparisons |> filter(adjudicator==x$adjudicator,source==x$source,evaluable,
    if(x$group=='Overall') TRUE else domain==x$group)
  stopifnot(x$n==nrow(d),x$count==sum(d[[paste0(x$level,'_match')]]))
}
for(i in seq_len(nrow(signal_delta))) {
  x <- signal_delta[i,]
  d <- comparisons |> filter(adjudicator==x$adjudicator,
    if(x$group=='Overall') TRUE else if(startsWith(x$group,'D')) domain==x$group else question==x$group) |>
    select(slug,domain,question,component,source,evaluable,five_match,collapsed_match) |>
    pivot_wider(names_from=source,values_from=c(evaluable,five_match,collapsed_match)) |>
    filter(evaluable_ARBITER & evaluable_Unassisted)
  delta <- mean(as.integer(d[[paste0(x$level,'_match_ARBITER')]])-as.integer(d[[paste0(x$level,'_match_Unassisted')]]))
  stopifnot(x$n==nrow(d),if(nrow(d)) abs(x$estimate-delta)<1e-12 else is.na(x$estimate))
}
cat('PASS signalling numerators, denominators and paired intersections reproduce from matched components.\n')
q41 <- signal_delta |> filter(group=='4.1')
stopifnot(identical(round(100*q41$estimate[q41$level=='five'],1),c(-39.6,-28.4)),
  all(q41$estimate[q41$level=='collapsed']==0))
cat('PASS the unfavorable Q4.1 five-level contrasts remain visible alongside collapsed results.\n')
for(path in list.files('output/tables',pattern='[.]csv$',full.names=TRUE)) {
  x <- readr::read_csv(path,show_col_types=FALSE)
  if(all(c('count','n','estimate') %in% names(x))) {
    keep <- !is.na(x$count) & !is.na(x$n) & x$n>0 & !is.na(x$estimate)
    if('metric' %in% names(x)) keep <- keep & !x$metric %in% c('kappa','AC2')
    stopifnot(all(abs(x$estimate[keep]-x$count[keep]/x$n[keep])<1e-12))
  }
}
cat('PASS every exported count/denominator proportion agrees with its estimate.\n')
retired <- c('agreement-unweighted','answer-changes','derived-overall-validation','direction-of-disagreement',
  'expert-reliability-matched','expert-unweighted','forced-choice','forest-meta','independent-binary',
  'independent-binary-differences','revised-ratings',
  'rules-only-primary','signalling-paired-estimates','signalling-disagreement-types')
check(!any(file.exists(paste0('output/tables/',retired,'.csv'))),'retired analytical exports are absent')
