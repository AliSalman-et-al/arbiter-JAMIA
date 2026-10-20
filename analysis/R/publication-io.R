# CSV publication labels are reversible so readers and builders use the same files.
PUBLICATION_LABELS <- c('ARBITER-Sonnet'='ARBITER (Sonnet 5.5)',
 'Baseline-Sonnet'='Unassisted (Sonnet 5.5)',
 'Baseline_label'='Unassisted_label',
 'Baseline template'='Unassisted template','Baseline output-format instruction'='Unassisted output-format instruction',
 'meta label'='published label',
 'Baseline'='Unassisted', 'Meta'='Published', 'All-Low'='All-Low rule',
 'Violation'='Rating contradicts its own answers','Invalid answer path'='Required question skipped',
 'Departure'='Any rule break')
publication_labels <- function(x,decode=FALSE) {
 map <- PUBLICATION_LABELS
 if(decode) map <- setNames(names(map),unname(map))
 convert <- function(v) {
   v <- gsub('\r\n','\n',v,fixed=TRUE)
   # Embedded source identifiers occur in paired-comparison columns.
   for(k in names(map)[grepl('Sonnet| vs |independent| label',names(map))]) v <- gsub(k,map[[k]],v,fixed=TRUE)
   i <- match(v,names(map)); v[!is.na(i)] <- unname(map[i[!is.na(i)]])
   v
 }
 for(k in names(x)) if(is.character(x[[k]])) x[[k]] <- convert(x[[k]])
 if(decode && 'source' %in% names(x)) x$source[x$source=='Baseline'] <- 'Unassisted'
 names(x) <- convert(names(x))
 x
}
publication_filename <- function(name) {
 map <- c(table1='benchmark-set',table2='table1',`table2-differences`='table1-differences')
 if(name %in% names(map)) unname(map[name]) else name
}
read_manuscript_data <- function(name) {
 name <- publication_filename(name)
 publication_labels(readr::read_csv(paste0('output/tables/',name,'.csv'),show_col_types=FALSE),TRUE)
}
