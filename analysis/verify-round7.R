# Run after render and verify-output.R. Compare every repository CSV to starting HEAD.
baseline <- '194101f448bfa73f5625338917626ed718080a89'
root <- normalizePath('..',winslash='/')
git <- function(args) {
  x <- system2('git',c('-C',shQuote(root),args),stdout=TRUE,stderr=FALSE)
  stopifnot(is.null(attr(x,'status'))); x
}
old <- git(c('ls-tree','-r',baseline))
old <- strsplit(old[endsWith(old,'.csv')],intToUtf8(9),fixed=TRUE)
paths <- vapply(old,function(x) x[2],character(1))
hashes <- vapply(old,function(x) strsplit(x[1],' ',fixed=TRUE)[[1]][3],character(1))
removed <- paste0('analysis/output/coding/',c('codebook-draft','coding-sheet-empty','coding-sheet'),'.csv')
new <- paste0('analysis/output/tables/',c(paste0('error-localisation-',
  c('cells','counts','frequency','issues','eligibility')),'discussion-quote-candidates'),'.csv')
stopifnot(all(!file.exists(file.path(root,removed))))
kept <- paths[!paths %in% removed]
stopifnot(all(file.exists(file.path(root,kept))))
current_hash <- system2('git',c('-C',shQuote(root),'hash-object','--stdin-paths'),
  input=file.path(root,kept),stdout=TRUE,stderr=FALSE)
stopifnot(length(current_hash)==length(kept),all(current_hash==hashes[match(kept,paths)]))
now <- git(c('ls-files','--cached','--others','--exclude-standard','--','*.csv'))
extra <- setdiff(now,paths)
stopifnot(setequal(extra,new))
prohibited <- '(?<![A-Za-z0-9_])(rob2kit|rob2-kit|rob2-assess|no-kit|nokit|kit)(?![A-Za-z0-9_])'
for(path in c('results.html','supplement.html',list.files('output',pattern='[.](csv|md)$',
  recursive=TRUE,full.names=TRUE)))
  stopifnot(!any(grepl(prohibited,readLines(path,warn=FALSE,encoding='UTF-8'),ignore.case=TRUE,perl=TRUE)))
for(path in list.files('output/figures',pattern='[.]pdf$',full.names=TRUE))
  stopifnot(!any(grepl(prohibited,pdftools::pdf_text(path),ignore.case=TRUE,perl=TRUE)))
cat('Every',length(kept),'retained CSV is byte-identical to starting HEAD.\n')
cat('Only six new and three removed CSVs; prohibited-name scan passed.\n')
