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
  adjud <- lapply(c('A','Z'),function(who) {
    readxl::read_xlsx(file.path(root,'human-adjudication',paste0('adjudication-cells-with-explanations-',who,'.xlsx'))) |>
      mutate(adjudicator=who) |> filter(!slug %in% EXCLUDED)
  })
  list(labels=bind_rows(labels), signals=bind_rows(signals), adjud=bind_rows(adjud),
    trials=read_input(file.path(root,'rob2-meta-benchmark-set/TRIAL-SUMMARY.csv')) |> filter(!slug %in% EXCLUDED),
    targets=read_input(file.path(root,'rob2-meta-benchmark-set/LABEL-TARGETS.csv')) |> filter(!slug %in% EXCLUDED))
}
disputed_cells <- function(labels) {
  labels |> filter(arm %in% c('ARBITER-Sonnet','Baseline-Sonnet'),domain!='Overall') |>
    select(slug,meta_id,domain,meta,arm,label) |> pivot_wider(names_from=arm,values_from=label) |>
    rename(kit=`ARBITER-Sonnet`,nokit=`Baseline-Sonnet`) |>
    mutate(disputed=is.na(kit)|is.na(nokit)|kit!=meta|nokit!=meta) |> filter(disputed)
}
adjudication_cells <- function(inputs) {
  a <- inputs$adjud |> select(slug,domain,adjudicator,own,chosen_label) |>
    pivot_wider(names_from=adjudicator,values_from=c(own,chosen_label))
  disputed_cells(inputs$labels) |> left_join(a,by=c('slug','domain')) |>
    mutate(consensus=chosen_label_A==chosen_label_Z,discordant=kit!=nokit,
      preferred=if_else(consensus,chosen_label_A,NA_character_))
}
