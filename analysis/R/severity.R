# Exploratory severity and binary comparisons, added 2026-10-21.
severity_distribution <- function(inputs) {
  predictions <- reference_predictions(inputs) |> select(slug,domain,source,label)
  experts <- expert_references(inputs) |> transmute(slug,domain,source=paste('Expert',adjudicator),label=reference)
  bind_rows(predictions,experts) |> filter(!is.na(label)) |>
    mutate(population=if_else(domain=='Overall','Overall','D1-D5')) |>
    count(source,population,label,name='count') |>
    complete(source,population,label=LABELS,fill=list(count=0L)) |>
    group_by(source,population) |> mutate(n=sum(count),estimate=count/n) |> ungroup() |>
    arrange(match(source,c('Published','ARBITER','Unassisted','Expert 1','Expert 2')),population,match(label,LABELS))
}
independent_binary <- function(inputs,weights) {
  predictions <- reference_predictions(inputs)
  refs <- expert_references(inputs) |> filter(domain!='Overall')
  estimates <- differences <- list()
  for(a in c('1','2')) for(g in c('D1-D5',paste0('D',1:5))) {
    r <- refs |> filter(adjudicator==a,if(g=='D1-D5') TRUE else domain==g)
    reps <- list()
    for(s in c('ARBITER','Unassisted','Published')) {
      d <- r |> inner_join(filter(predictions,source==s),by=c('slug','domain'))
      reps[[s]] <- agreement_replicates(mutate(d,meta=reference),weights)[c('sensitivity','specificity'),,drop=FALSE]
      estimates[[length(estimates)+1L]] <- interval_table(reps[[s]]) |>
        mutate(adjudicator=a,source=s,domain=g,
          n=if_else(metric=='sensitivity',sum(d$reference!='Low'),sum(d$reference=='Low')),
          count=if_else(metric=='sensitivity',sum(!is.na(d$label)&d$label!='Low'&d$reference!='Low'),
            sum(!is.na(d$label)&d$label=='Low'&d$reference=='Low')))
    }
    differences[[length(differences)+1L]] <- interval_table(reps$ARBITER-reps$Unassisted) |>
      mutate(adjudicator=a,comparison='ARBITER minus Unassisted',domain=g,
        n=if_else(metric=='sensitivity',sum(r$reference!='Low'),sum(r$reference=='Low')))
  }
  list(estimates=bind_rows(estimates),differences=bind_rows(differences))
}
benchmark_documents <- function(inputs) {
  bind_rows(lapply(inputs$trials$slug,function(slug) {
    path <- paste0('../kit-sonnet-5.5/bundles/',slug,'.rob2.zip')
    con <- unz(path,'canonical.json',open='rb'); on.exit(close(con))
    size <- unzip(path,list=TRUE)$Length[unzip(path,list=TRUE)$Name=='canonical.json']
    trial <- jsonlite::fromJSON(rawToChar(readBin(con,'raw',n=size)),simplifyVector=FALSE)$batch$trials[[1]]
    roles <- vapply(trial$sources,`[[`,character(1),'role')
    tibble(slug=slug,document_type=c('protocol','sap','registry','supplement'),
      available=c('protocol','sap','registry','supplement') %in% roles)
  }))
}
# Figure 6 uses an identical paired signalling population for both source dots.
paired_signalling_estimates <- function(comparisons,weights) {
  p <- comparisons |> select(slug,adjudicator,domain,question,component,source,evaluable,collapsed_match) |>
    pivot_wider(names_from=source,values_from=c(evaluable,collapsed_match)) |>
    filter(evaluable_ARBITER & evaluable_Unassisted)
  bind_rows(lapply(c('1','2'),function(a) bind_rows(lapply(c('ARBITER','Unassisted'),function(s) {
    d <- filter(p,adjudicator==a); event <- d[[paste0('collapsed_match_',s)]]
    interval_table(share_estimate(d,event,weights)) |> mutate(adjudicator=a,source=s,n=nrow(d),count=sum(event))
  }))))
}

matched_expert_reliability <- function(inputs,weights) {
  observed <- reference_predictions(inputs) |> filter(source=='Published',domain=='Overall',!is.na(label)) |> pull(slug)
  d <- expert_references(inputs) |> filter(domain=='Overall',slug %in% observed) |>
    pivot_wider(names_from=adjudicator,values_from=reference) |> transmute(slug,meta=`1`,label=`2`)
  interval_table(agreement_replicates(d,weights)[c('accuracy','kappa'),,drop=FALSE]) |>
    mutate(domain='Overall',n=nrow(d),count=if_else(metric=='accuracy',sum(d$meta==d$label),NA_integer_))
}

benchmark_characteristics <- function(inputs) {
  meta <- readr::read_csv('data-curated/meta-analyses.csv',show_col_types=FALSE) |> filter(meta_id %in% inputs$trials$meta_id)
  tibble(characteristic=c('Trials','Meta-analyses','Specialties'),
    count=c(nrow(inputs$trials),n_distinct(inputs$trials$meta_id),n_distinct(meta$specialty)))
}
