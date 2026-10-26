severity_distribution <- function(inputs) {
  predictions <- reference_predictions(inputs) |> select(slug,domain,source,label)
  experts <- expert_references(inputs) |> transmute(slug,domain,source=paste('Expert',adjudicator),label=reference)
  bind_rows(predictions,experts) |> filter(domain!='Overall',!is.na(label)) |>
    mutate(population='D1-D5') |>
    count(source,population,label,name='count') |>
    complete(source,population,label=LABELS,fill=list(count=0L)) |>
    group_by(source,population) |> mutate(n=sum(count),estimate=count/n) |> ungroup() |>
    arrange(match(source,c('Published','ARBITER','Unassisted','Expert 1','Expert 2')),population,match(label,LABELS))
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
benchmark_characteristics <- function(inputs) {
  meta <- readr::read_csv('data-curated/meta-analyses.csv',show_col_types=FALSE) |> filter(meta_id %in% inputs$trials$meta_id)
  tibble(characteristic=c('Trials','Meta-analyses','Specialties'),
    count=c(nrow(inputs$trials),n_distinct(inputs$trials$meta_id),n_distinct(meta$specialty)))
}
