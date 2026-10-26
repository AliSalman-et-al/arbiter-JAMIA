display_numbering <- function() {
  bind_rows(tibble(kind=c(rep('Figure',5),rep('Table',3)),new_number=c(as.character(1:5),as.character(1:3)),
    content=c('Architecture (protected)','AVATAR trace (protected)','Paired evaluation and conditional choice','Absolute and paired domain agreement','Paired signalling diagnostics','Benchmark and reference context','Conditional blinded-label choices','Process and resources')),
    tibble(kind='eTable',new_number=as.character(seq_along(SUPPLEMENT_SPECS)),content=reader_label(vapply(SUPPLEMENT_SPECS,`[`,character(1),1))))
}
