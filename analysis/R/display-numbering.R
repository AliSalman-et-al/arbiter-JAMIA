# Main display identifiers only; statistical source CSV names remain stable.
display_numbering <- function() {
  tibble::tibble(kind=c(rep('Figure',6),rep('Table',4)),
    old_number=c(1L,2L,3L,5L,4L,6L,2L,3L,1L,4L),
    new_number=c(1:6,1:4),
    content=c('Architecture','AVATAR workflow','Study flow','Primary forest',
      'Independent agreement and direction','Signalling questions',
      'Independent expert agreement','Rule breaks and audit',
      'Published-label agreement','Prior work'))
}
