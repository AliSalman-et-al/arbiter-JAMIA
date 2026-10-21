# Mapping from the final Round 15 displays; source-analysis filenames are stable.
display_numbering <- function() {
  main <- tibble::tibble(kind=c('Table','Table','Table','Table','Figure','Figure','Figure','Figure','Figure panel','Figure panel','Figure','Figure panel','eFigure','eFigure','eFigure'),
    old_number=c('New','1 + 3','2','4','1','2','3','4','New','5B','6','5A','1','2','3'),
    new_number=c('1','2','3','4','1','2','3','4','5A','5B','eFigure 2','eFigure 1','3','4','5'),
    content=c('Benchmark and reference characteristics','Agreement with each reference','Integrity and process','Prior work',
      'Architecture','AVATAR workflow','Two-branch flow','Primary forest','Paired agreement differences','Direction of disagreement',
      'Collapsed question differences','Absolute agreement','Published-label forest','Domain signalling','All question differences'))
  main <- bind_rows(main,tibble::tibble(kind='Figure',old_number='New',new_number='6',content='Answers or arithmetic'))
  old <- vapply(ROUND15_SUPPLEMENT_SPECS,`[`,character(1),1)
  new <- vapply(SUPPLEMENT_SPECS,`[`,character(1),1)
  bind_rows(main,tibble::tibble(kind='eTable',old_number=if_else(is.na(match(new,old)),'New',as.character(match(new,old))),new_number=as.character(seq_along(new)),content=new))
}
