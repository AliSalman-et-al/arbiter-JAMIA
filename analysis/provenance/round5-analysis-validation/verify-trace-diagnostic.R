library(dplyr)
docx_text <- function(path) {
  con <- unz(path,'word/document.xml')
  xml <- xml2::read_xml(con)
  paste(xml2::xml_text(xml2::xml_find_all(xml,'//w:p',xml2::xml_ns(xml))),collapse=' ')
}
s <- gsub('\\s+',' ',docx_text('output/manuscript/Supplement.docx'),perl=TRUE)
for(p in c('output/tables/avatar-trace-answers.csv','output/tables/avatar-trace-evidence.csv')) {
  x <- readr::read_csv(p,show_col_types=FALSE,col_types=readr::cols(.default='c'))
  for(k in names(x)) {
    v <- unique(na.omit(x[[k]]));v <- gsub('\\s+',' ',v,perl=TRUE)
    missing <- v[!vapply(v,function(z) grepl(z,s,fixed=TRUE),logical(1))]
    if(length(missing)) {cat(basename(p),k,length(missing),'missing\n');cat(head(missing,2),sep='\n')}
  }
}
