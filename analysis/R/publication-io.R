# CSV publication labels are reversible so readers and builders use the same files.
PUBLICATION_LABELS <- c('ARBITER-Sonnet'='ARBITER (Sonnet 5.5)',
 'Baseline-Sonnet'='Unassisted (Sonnet 5.5)',
 'Baseline_label'='Unassisted_label',
 'Baseline template'='Unassisted template','Baseline output-format instruction'='Unassisted output-format instruction',
 'A vs Z'='Adjudicator 1 vs Adjudicator 2','A independent'='Adjudicator 1 independent','Z independent'='Adjudicator 2 independent',
 'meta label'='published label',
 'Baseline'='Unassisted', 'Meta'='Published', 'All-Low'='All-Low rule',
 'Violation'='Rating contradicts its own answers','Invalid answer path'='Required question skipped',
 'Departure'='Any rule break','Vindicated'='Adjudicators agreed with it',
 'A'='Adjudicator 1','Z'='Adjudicator 2')
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
 if('reference' %in% names(x)) {
   if(decode) x$reference <- ifelse(x$reference %in% c('A','Z'),paste('Adjudicator',x$reference),x$reference)
   else x$reference <- gsub('Adjudicator Z','Adjudicator 2',gsub('Adjudicator A','Adjudicator 1',x$reference,fixed=TRUE),fixed=TRUE)
 }
 if(decode && 'source' %in% names(x)) x$source[x$source=='Baseline'] <- 'Unassisted'
 names(x) <- convert(names(x))
 x
}
publication_filename <- function(name) {
 map <- c(table1='benchmark-set',table2='table1',`table2-differences`='table1-differences',`table4-reliability`='table2-reliability')
 if(name %in% names(map)) unname(map[name]) else name
}
read_manuscript_data <- function(name) {
 name <- publication_filename(name)
 publication_labels(readr::read_csv(paste0('output/tables/',name,'.csv'),show_col_types=FALSE),TRUE)
}

finish_publication_outputs <- function() {
# Remove superseded public exports; raw inputs and protected artwork stay intact.
unlink(file.path('output/tables',c('table2.csv','table2-differences.csv','table4-reliability.csv','table5-haiku.csv','missing-sensitivity.csv','missing-sensitivity-differences.csv','recorded-overrides.csv','efigure2-disagreement-patterns.csv')))
unlink(file.path('output/manuscript',paste0('eFigure2.',c('png','pdf','tiff'))))
for(i in 3:6) for(ext in c('png','pdf')) file.copy(paste0('output/manuscript/Figure',i,'.',ext),paste0('output/figures/figure',i,'.',ext),overwrite=TRUE)
for(ext in c('png','pdf')) file.copy(paste0('output/manuscript/eFigure1.',ext),paste0('output/figures/supplement-forest.',ext),overwrite=TRUE)

for(ext in c('png','pdf')) file.copy(paste0('output/manuscript/Figure6.',ext),paste0('output/figures/supplement-decisive-questions.',ext),overwrite=TRUE)
 invisible(TRUE)
}
