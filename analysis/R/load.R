library(dplyr)
library(tidyr)
LABELS <- c('Low', 'Some concerns', 'High')
EXCLUDED <- c('atwine-2020', 'haney-2004', 'herrmann-2016')
ARMS <- c('ARBITER-Sonnet'='kit-sonnet-5.5', 'Baseline-Sonnet'='no-kit-sonnet-5.5')
clean_label <- function(x) {
  x <- trimws(x)
  x[!x %in% LABELS] <- NA_character_
  x
}
read_input <- function(path) readr::read_csv(path, show_col_types=FALSE, progress=FALSE,
  col_types=readr::cols(.default=readr::col_character()))
question_map <- function(include_short_text=FALSE) {
  names <- c('randomization:sequence','randomization:concealment','randomization:baseline-imbalance',
    'deviations:participants-aware','deviations:personnel-aware','deviations:context-deviations',
    'deviations:affected-outcome','deviations:balanced','deviations:appropriate-analysis',
    'deviations:substantial-impact','missing:data-available','missing:evidence-unbiased',
    'missing:true-value-dependent','missing:likely-dependent','measurement:method-inappropriate',
    'measurement:differential','measurement:assessor-aware','measurement:influence-possible',
    'measurement:influence-likely','selection:prespecified-analysis','selection:multiple-measurements',
    'selection:multiple-analyses')
  map <- tibble(question_id=paste0('sq:',names), question=unlist(lapply(seq_len(5),
    function(i) paste0(i,'.',seq_len(c(3,7,4,5,3)[i])))))
  # Abbreviations of official 2019 signalling questions (effect of assignment).
  # Sterne et al., BMJ 2019;366:l4898, Table 1 (official question wording).
  if(include_short_text) map$short_text <- c(
    'Random allocation sequence','Concealment until enrolment and assignment',
    'Baseline imbalance suggesting a randomisation problem',
    'Participants aware of assignment','Carers or intervention providers aware of assignment',
    'Deviations arising from trial context','Deviations affecting the outcome',
    'Deviations balanced across groups','Appropriate analysis of assignment effect',
    'Substantial impact of analysing outside assigned groups',
    'Outcome data available for nearly everyone','Evidence against bias from missing data',
    'Missingness potentially depends on true outcome','Missingness likely depends on true outcome',
    'Inappropriate measurement method','Measurement differs across groups',
    'Assessors aware of received intervention','Assessment potentially influenced by awareness',
    'Assessment likely influenced by awareness','Analysis plan finalised before unblinding',
    'Result selected from eligible outcome measurements','Result selected from eligible analyses')
  map
}
load_inputs <- function(root='..') {
  labels <- signals <- list()
  for (arm in names(ARMS)) {
    kit <- startsWith(ARMS[[arm]],'kit-')
    prefix <- if(kit) 'rob2kit' else 'model'
    x <- read_input(file.path(root,ARMS[[arm]],paste0(prefix,'-domain-labels.csv'))) |>
      filter(!slug %in% EXCLUDED)
    labels[[arm]] <- bind_rows(lapply(c(paste0('D',1:5),'Overall'),function(d)
      x |> transmute(slug,field,meta_id,arm=arm,domain=d,
        label=clean_label(.data[[paste0(prefix,'_',d)]]),meta=clean_label(.data[[paste0('human_',d)]]))))
    s <- read_input(file.path(root,ARMS[[arm]],paste0(prefix,'-signalling-answers.csv'))) |>
      filter(!slug %in% EXCLUDED) |> mutate(arm=arm)
    if(kit) s <- left_join(s,question_map(),by='question_id') else s$question <- s$question_id
    signals[[arm]] <- s |> mutate(active=active=='yes')
  }
  labels <- bind_rows(labels)
  trials <- read_input(file.path(root,'rob2-meta-benchmark-set/TRIAL-SUMMARY.csv')) |> filter(!slug %in% EXCLUDED)
  stopifnot(nrow(trials)==102L,!anyDuplicated(trials$slug))
  adjud <- bind_rows(lapply(1:2,function(who) {
    readxl::read_xlsx(file.path(root,'human-adjudication',paste0('adjudication-with-explanations-',who,'.xlsx')),
      sheet='Adjudications',col_types='text') |>
      transmute(slug=Trial,domain=Domain,human=clean_label(Human),kit=clean_label(Kit),
        nokit=clean_label(`No-kit`),independent=clean_label(Independent),
        chosen_label=clean_label(`Chosen label`),revised=clean_label(Revised),adjudicator=as.character(who)) |>
      filter(!slug %in% EXCLUDED)
  }))
  validate_adjudication(adjud,labels,trials)
  evidence <- bind_rows(lapply(1:2,function(who) {
    readxl::read_xlsx(file.path(root,'human-adjudication',paste0('adjudication-with-explanations-',who,'.xlsx')),
      sheet='Signalling evidence',col_types='text') |>
      transmute(slug=Trial,phase=Phase,domain=Domain,question=Question,raw_answer=Answer,
        raw_change=`Retained or changed`,evidence=`Evidence and locators`,guidance=`RoB 2 guidance`,
        adjudicator=as.character(who),workbook_row=row_number()+1L) |> filter(!slug %in% EXCLUDED)
  }))
  stopifnot(all(count(evidence,adjudicator)$n==4488L),
    !anyDuplicated(paste(evidence$adjudicator,evidence$slug,evidence$phase,evidence$question)),
    all(evidence$question %in% question_map()$question),
    all(evidence$domain==paste0('D',substr(evidence$question,1,1))))
  sources <- bind_rows(lapply(1:2,function(who) {
    readxl::read_xlsx(file.path(root,'human-adjudication',paste0('adjudication-with-explanations-',who,'.xlsx')),
      sheet='Trial sources',col_types='text') |> mutate(adjudicator=as.character(who))
  }))
  overall_sheet <- readxl::read_xlsx(file.path(root,'human-adjudication/adjudication-with-explanations-2.xlsx'),
    sheet='Overall (derived)',col_types='text')
  list(labels=labels,signals=bind_rows(signals),adjud=adjud,trials=trials,evidence=evidence,
    sources=sources,overall_sheet=overall_sheet,
    targets=read_input(file.path(root,'rob2-meta-benchmark-set/LABEL-TARGETS.csv')) |> filter(!slug %in% EXCLUDED))
}
label_cells <- function(labels) {
  labels |> filter(domain!='Overall') |> select(slug,meta_id,domain,meta,arm,label) |>
    pivot_wider(names_from=arm,values_from=label) |> rename(kit=`ARBITER-Sonnet`,nokit=`Baseline-Sonnet`) |>
    mutate(disputed=is.na(kit)|is.na(nokit)|kit!=meta|nokit!=meta,discordant=is.na(kit)|is.na(nokit)|kit!=nokit)
}
disputed_cells <- function(labels) label_cells(labels) |> filter(disputed)
validate_adjudication <- function(adjud,labels,trials) {
  expected <- label_cells(labels)
  for(who in c('1','2')) {
    x <- adjud |> filter(adjudicator==who)
    stopifnot(nrow(x)==510L,!anyDuplicated(paste(x$slug,x$domain)),setequal(x$slug,trials$slug),
      setequal(paste(x$slug,x$domain),paste(expected$slug,expected$domain)),
      !anyNA(x$independent),!anyNA(x$chosen_label),!anyNA(x$revised))
    x <- left_join(x,expected,by=c('slug','domain'),suffix=c('_sheet','_arm'))
    same <- function(a,b) all((is.na(a)&is.na(b))|(!is.na(a)&!is.na(b)&a==b))
    if(!same(x$human,x$meta)||!same(x$kit_sheet,x$kit_arm)||!same(x$nokit_sheet,x$nokit_arm))
      stop('Workbook arm-label mismatch for adjudicator ',who)
  }
  invisible(TRUE)
}
adjudication_cells <- function(inputs) {
  a <- inputs$adjud |> select(slug,domain,adjudicator,independent,chosen_label,revised) |>
    pivot_wider(names_from=adjudicator,values_from=c(independent,chosen_label,revised))
  label_cells(inputs$labels) |> left_join(a,by=c('slug','domain')) |>
    mutate(consensus=chosen_label_1==chosen_label_2,
      preferred=if_else(consensus,chosen_label_1,NA_character_))
}
