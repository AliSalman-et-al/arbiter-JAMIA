# Run from analysis/ after a clean quarto render and verify-output.R.
# The default is the immutable pre-round-6 HEAD; an optional argument overrides it.
args <- commandArgs(trailingOnly=TRUE)
baseline <- if(length(args)) args[1] else '657b949f3f367ea6c1c35ed2027e1ba5561e42e0'
source('R/load.R')
source('R/materials.R')
root <- normalizePath('..',winslash='/')
git <- function(args) {
  out <- system2('git',args,stdout=TRUE,stderr=FALSE)
  stopifnot(is.null(attr(out,'status')))
  out
}
files <- git(c('-C',shQuote(root),'ls-files','--','*.csv'))
allowed <- c('analysis/data-derived/bundle-binding-counts.csv',
  paste0('analysis/output/tables/',c('audit-summary','table3','table3-supplement'),'.csv'))

tree <- git(c('-C',shQuote(root),'ls-tree','-r',baseline))
tree <- tree[endsWith(tree,'.csv')]
parts <- strsplit(tree,intToUtf8(9),fixed=TRUE)
old_paths <- vapply(parts,function(x) x[2],character(1))
old_hashes <- vapply(parts,function(x) strsplit(x[1],' ',fixed=TRUE)[[1]][3],character(1))
now <- system2('git',c('-C',shQuote(root),'hash-object','--stdin-paths'),
  input=file.path(root,files),stdout=TRUE,stderr=FALSE)
stopifnot(is.null(attr(now,'status')),length(now)==length(files))
old <- old_hashes[match(files,old_paths)]
changed <- files[is.na(old) | old!=now]
stopifnot(all(changed %in% allowed))
old_csv <- function(path) {
  lines <- git(c('-C',shQuote(root),'show',shQuote(paste0(baseline,':',path))))
  readr::read_csv(I(paste(lines,collapse='\n')),show_col_types=FALSE)
}
for(name in c('audit-summary','table3','table3-supplement')) {
  path <- paste0('analysis/output/tables/',name,'.csv')
  current <- readr::read_csv(file.path(root,path),show_col_types=FALSE)
  column <- if(name=='audit-summary') 'metric' else 'status'
  prior <- old_csv(path)
  kept <- current[!current[[column]] %in% c('Structural evidence binding (overall)',
    'Text-span evidence binding','Visual evidence binding','Other evidence records',
    'Trials using visual evidence'),]
  prior <- prior[prior[[column]]!='Structural evidence binding',]
  stopifnot(isTRUE(all.equal(as.data.frame(kept),as.data.frame(prior),check.attributes=FALSE)))
}
audit <- readr::read_csv('output/tables/audit-summary.csv',show_col_types=FALSE) |>
  filter(metric=='Structural evidence binding (overall)') |> arrange(arm)
stopifnot(identical(audit$arm,c('ARBITER-Haiku','ARBITER-Sonnet')),
  all(audit$n==c(1260,1421)),all(audit$count==c(1260,1421)),
  isTRUE(all.equal(audit$estimate,audit$count/audit$n,tolerance=1e-14)))
counts <- readr::read_csv('data-derived/bundle-binding-counts.csv',show_col_types=FALSE)
stopifnot(all(counts$cited_records==counts$text_records+counts$visual_records+counts$other_records),
  all(counts$bound_records==counts$text_bound+counts$visual_bound),all(counts$other_records==0))
for(arm in c('ARBITER-Sonnet','ARBITER-Haiku')) {
  x <- filter(counts,.data$arm==.env$arm)
  expected <- if(arm=='ARBITER-Sonnet') c(1407,14,8) else c(1255,5,4)
  stopifnot(all(c(sum(x$text_bound),sum(x$visual_bound),sum(x$visual_trial))==expected))
}
prohibited <- '(?<![A-Za-z0-9_])(rob2kit|rob2-kit|rob2-assess|no-kit|nokit|kit)(?![A-Za-z0-9_])'
stopifnot(grepl(prohibited,'rob2-kit',perl=TRUE))
paths <- c('results.html','supplement.html',list.files('output',pattern='[.](csv|md)$',
  recursive=TRUE,full.names=TRUE))
for(path in paths) stopifnot(!any(grepl(prohibited,readLines(path,warn=FALSE,encoding='UTF-8'),
  ignore.case=TRUE,perl=TRUE)))
for(path in list.files('output/figures',pattern='[.]pdf$',full.names=TRUE))
  stopifnot(!any(grepl(prohibited,pdftools::pdf_text(path),ignore.case=TRUE,perl=TRUE)))
cat('Compared',length(files),'tracked CSVs to',baseline,'; allowed changed/new CSVs:\n')
cat(paste(changed,collapse='\n'),'\n')
cat('Non-binding audit rows preserve every prior value. Kind-specific counts and totals verified.\n')
cat('Prohibited-name scan passed for both HTML reports, output CSV/Markdown and all figure PDF text.\n')
