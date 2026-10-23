# Report-only parity: read retained inputs/exports; no estimates or publication outputs written.
source('R/load.R')
for(f in setdiff(list.files('R',pattern='[.]R$',full.names=TRUE),'R/load.R')) source(f)
inputs <- load_inputs()
trace <- readr::read_csv('output/tables/display-source-trace.csv',show_col_types=FALSE,col_types=readr::cols(.default='c'))
for(file in unique(trace$file)) {
 x <- readr::read_csv(paste0('output/tables/',file,'.csv'),show_col_types=FALSE)
 rows <- trace[trace$file==file,]
 for(column in unique(rows$column)) {
  z <- rows[rows$column==column,]; actual <- as.character(x[[column]][as.integer(z$row)])
  same <- (is.na(actual)&is.na(z$value))|(!is.na(actual)&!is.na(z$value)&actual==z$value)
  stopifnot(all(same))
 }
}
cat('PASS',nrow(trace),'exact source-cell trace records\n')
docx_text <- function(path) {
 con <- unz(path,'word/document.xml'); xml <- xml2::read_xml(con)
 paste(xml2::xml_text(xml2::xml_find_all(xml,'//w:p',xml2::xml_ns(xml))),collapse=' ')
}
norm <- function(x) gsub('\\s+',' ',x,perl=TRUE)
supplement_text <- norm(docx_text('output/manuscript/Supplement.docx'))
for(value in c(unname(METHODS_APPENDIX),RUN_PROVENANCE)) stopifnot(grepl(norm(value),supplement_text,fixed=TRUE))
cat('PASS',length(METHODS_APPENDIX),'eMethods and',length(RUN_PROVENANCE),'provenance paragraphs exactly match R source\n')
entries <- supplement_entries(inputs)
for(e in entries) {
 saved <- readr::read_csv(paste0('output/tables/display-supplement-',supplement_display_slug(e$title),'.csv'),show_col_types=FALSE,col_types=readr::cols(.default='c'),na=character())
 stopifnot(identical(names(saved),names(e$data)),identical(as.matrix(saved),as.matrix(e$data)),grepl(norm(supplement_note(e)),supplement_text,fixed=TRUE))
}
cat('PASS',length(entries),'current supplementary display builders and complete Word notes\n')
checklist <- reporting_checklist() |> select(guideline,item,topic,section,applicability_and_notes) |> clean_display()
saved <- readr::read_csv('output/tables/display-supplement-reporting-map.csv',show_col_types=FALSE,col_types=readr::cols(.default='c'))
stopifnot(identical(as.matrix(checklist),as.matrix(saved)))
for(path in list.files('output/tables',pattern='^display-supplement-.*[.]csv$',full.names=TRUE)) {
 x <- readr::read_csv(path,show_col_types=FALSE,col_types=readr::cols(.default='c'))
 target <- if(grepl('reporting-map[.]csv$',path)) norm(docx_text('output/manuscript/TRIPOD-LLM.docx')) else supplement_text
 expected <- apply(as.data.frame(x),1,function(v) norm(trimws(paste(v[!is.na(v)],collapse=' '))))
 stopifnot(all(vapply(expected,function(v) grepl(v,target,fixed=TRUE),logical(1))))
}
cat('PASS all supplementary/reporting-map CSV rows in Word in exact column order\n')
jsonlite::write_json(list(methods=as.list(METHODS_APPENDIX),provenance=as.list(RUN_PROVENANCE),checklist=reporting_checklist()),'/tmp/arbiter-round6-supplement/source.json',auto_unbox=TRUE,pretty=TRUE)
