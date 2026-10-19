# Retain the complete Round 13 publication checks, then enforce the reviewer fixes.
source('verify-round13.R')
d <- pdftools::pdf_data('output/manuscript/qa/Table1-word.pdf')[[1]]
d$text <- gsub('\u2060','',d$text,fixed=TRUE)
d$text <- gsub('\u00a0',' ',d$text,fixed=TRUE)
left <- (.65+sum(main_table_widths(1)[1:4]))*72
right <- left+main_table_widths(1)[5]*72
start <- d$y[which(d$text=='Published')[1]]
header <- d[nzchar(d$text) & d$x>=left-.5 & d$x<right-.5 & d$y>=start & d$y<=start+20,]
lines <- split(header$text,header$y)
lines <- vapply(lines,paste,collapse=' ',FUN.VALUE=character(1))
lines <- gsub('D1 *– *D5','D1–D5',lines)
stopifnot(length(lines)==2L,identical(unname(lines),c('Published D1–D5 labels','(Low/SC/High)')))
cat('Table 1: exact two-line header verified in native Word PDF\n')
for(i in 3:5) {
  p <- paste0('output/manuscript/Figure',i,'.pdf')
  d <- pdftools::pdf_data(p)[[1]]; size <- pdftools::pdf_pagesize(p)
  stopifnot(all(d$x>=0),all(d$x+d$width<=size$width+.1),all(d$y>=0),all(d$y+d$height<=size$height+.1))
  if(i==5) stopifnot(sum(grepl('split',d$text,fixed=TRUE))>=5L)
  cat('Figure',i,': all PDF text within page bounds\n')
}
