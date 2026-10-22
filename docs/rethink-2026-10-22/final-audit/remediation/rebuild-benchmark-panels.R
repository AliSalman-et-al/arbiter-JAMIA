# Focused regeneration of the first native gt table after a Word boundary check.
source('R/load.R')
for(f in setdiff(list.files('R',pattern='[.]R$',full.names=TRUE),'R/load.R')) source(f)
x <- readr::read_csv('output/tables/display-supplement-benchmark-trials.csv',col_types=readr::cols(.default='c'),na=character())
note <- supplement_note(list(source='benchmark-set',number=1,group='1. Reproducibility and methods'))
doc <- manuscript_doc(); html <- character()
for(i in 1:2) {
  rows <- if(i==1) 1:9 else 10:nrow(x)
  if(i==2) doc <- officer::body_add_break(doc) |> manuscript_par('eTable 1. Benchmark trials (continued 2)',style='heading 2')
  tab <- house_table(x[rows,,drop=FALSE],note)
  doc <- add_gt(doc,tab);html[i]<-gt::as_raw_html(tab,inline_css=FALSE)
}
print(doc,target='output/manuscript/qa/benchmark-panels.docx')
old <- strsplit(paste(readLines('output/manuscript/qa/supplement-gt.html',encoding='UTF-8'),collapse='\n'),'\n<!--GT_TABLE_BOUNDARY-->\n',fixed=TRUE)[[1]]
writeLines(paste(c(html,old[-1]),collapse='\n<!--GT_TABLE_BOUNDARY-->\n'),'output/manuscript/qa/supplement-gt.html')
