# Reconstruct every retained display from parent CSV values using the current
# presentation code; compare each numeric body token before checking Word output.
dir.create('round14-verification',recursive=TRUE,showWarnings=FALSE)
source('R/load.R')
for(f in c('publication-io','presentation','manuscript-tables','avatar-trace','manuscript-supplement')) source(paste0('R/',f,'.R'))
inputs <- load_inputs()
current_reader <- manuscript_data
current <- supplement_registry(inputs)
parent_reader <- function(name) {
  raw <- suppressWarnings(system2('git',c('show',paste0('bfe7111:analysis/output/tables/',name,'.csv')),stdout=TRUE,stderr=FALSE))
  if(!is.null(attr(raw,'status'))) return(current_reader(name)) # New post hoc exports only.
  x <- readr::read_csv(I(paste(raw,collapse='\n')),show_col_types=FALSE)
  keep <- rep(TRUE,nrow(x))
  for(k in names(x)) if(is.character(x[[k]])) keep <- keep & !grepl('Haiku',coalesce(x[[k]],''),ignore.case=TRUE)
  x[keep,!grepl('Haiku',names(x)),drop=FALSE]
}
# The input tables and archived AVATAR trace are independently immutable.
manuscript_data <- parent_reader
parent <- supplement_registry(inputs)
manuscript_data <- current_reader
numeric_tokens <- function(x) {
  text <- as.character(unlist(x,use.names=FALSE))
  unlist(regmatches(text,gregexpr('[-−]?[0-9]+(?:[.,][0-9]+)*',text,perl=TRUE)),use.names=FALSE)
}
body_tokens <- function(entry) {
  if(is.null(entry$blocks)) numeric_tokens(display_frame(entry$data)) else
    unlist(lapply(entry$blocks,function(b) numeric_tokens(display_frame(b$data))),use.names=FALSE)
}
rows <- lapply(seq_along(current),function(i) {
  e <- current[[i]]
  added <- grepl('unweighted agreement|recomputing Unassisted',e$caption)
  a <- body_tokens(parent[[i]]); b <- body_tokens(e)
  data.frame(eTable=i,caption=e$caption,retained=!added,numeric_tokens=length(b),identical=if(added) NA else identical(a,b))
}) |> bind_rows()
readr::write_csv(rows,'round14-verification/retained-supplement-tables.csv')
print(tibble::as_tibble(rows),n=Inf)
stopifnot(all(rows$identical[rows$retained]))
cat('Every numeric body token in all retained supplementary table constructions matches the parent CSV values.\n')
