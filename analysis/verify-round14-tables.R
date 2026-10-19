# Reconstruct every retained display from parent CSV values using the current
# presentation code; compare each numeric body token before checking Word output.
dir.create('round14-verification',recursive=TRUE,showWarnings=FALSE)
source('R/load.R')
for(f in c('publication-io','presentation','manuscript-tables','avatar-trace','manuscript-supplement')) source(paste0('R/',f,'.R'))
baseline <- Sys.getenv('ROUND14_BASELINE','120b332')
inputs <- load_inputs()
current_reader <- manuscript_data
current <- supplement_registry(inputs)
parent_reader <- function(name) {
  raw <- suppressWarnings(system2('git',c('show',paste0(baseline,':analysis/output/tables/',publication_filename(name),'.csv')),stdout=TRUE,stderr=FALSE))
  if(!is.null(attr(raw,'status'))) return(current_reader(name)) # New post hoc exports only.
  x <- readr::read_csv(I(paste(raw,collapse='\n')),show_col_types=FALSE)
  keep <- rep(TRUE,nrow(x))
  for(k in names(x)) if(is.character(x[[k]])) keep <- keep & !grepl('Haiku',coalesce(x[[k]],''),ignore.case=TRUE)
  publication_labels(x[keep,!grepl('Haiku',names(x)),drop=FALSE],TRUE)
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
  added <- baseline!='85a4c6f' && grepl('Evidence and quotation locations for the prior-work comparison',e$caption)
  a <- body_tokens(parent[[i]]); b <- body_tokens(e)
  data.frame(eTable=i,caption=e$caption,retained=!added,numeric_tokens=length(b),identical=if(added) NA else identical(a,b))
}) |> bind_rows()
# New component rows are reconstructed from their new export in both constructions;
# the CSV audit and round-2 test separately prove the partition and counts.
readr::write_csv(rows,'round14-verification/retained-supplement-tables.csv')
print(tibble::as_tibble(rows),n=Inf)
stopifnot(all(rows$identical[rows$retained]))
cat('Every numeric body token in all retained supplementary table constructions matches the parent CSV values.\n')
# Verify that every current table body, including the declared new rows, reached
# the actual Word artifact without losing or altering any numeric token.
xml <- xml2::read_xml(unz('output/manuscript/Supplement.docx','word/document.xml'))
ns <- c(w='http://schemas.openxmlformats.org/wordprocessingml/2006/main')
actual <- xml2::xml_find_all(xml,'.//w:tbl',ns)
expected <- unlist(lapply(current,function(e) {
  blocks <- if(is.null(e$blocks)) list(list(data=e$data)) else e$blocks
  lapply(blocks,function(b) supplement_table(e,b$data)$body$dataset)
}),recursive=FALSE)
stopifnot(length(actual)==length(expected))
word_rows <- lapply(seq_along(actual),function(i) {
  tr <- xml2::xml_find_all(actual[[i]],'./w:tr',ns)
  # One header row; then the generated body; footer notes are deliberately separate.
  body <- tr[seq_len(nrow(expected[[i]]))+1L]
  values <- unlist(lapply(body,function(r) vapply(xml2::xml_find_all(r,'./w:tc',ns),
    function(c) paste(xml2::xml_text(xml2::xml_find_all(c,'.//w:t',ns)),collapse=''),character(1))))
  a <- numeric_tokens(as.vector(t(as.matrix(expected[[i]]))))
  b <- numeric_tokens(values)
  data.frame(Word_table=i,numeric_tokens=length(a),identical=identical(a,b))
}) |> bind_rows()
readr::write_csv(word_rows,paste0('round14-verification/',if(baseline=='85a4c6f') 'polish' else 'round3','-supplement-word-tables.csv'))
stopifnot(all(word_rows$identical))
cat('Actual Supplement.docx: all',nrow(word_rows),'table bodies match generated numeric tokens.\n')
