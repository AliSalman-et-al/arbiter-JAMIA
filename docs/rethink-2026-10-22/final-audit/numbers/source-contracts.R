source('R/load.R')
for(f in setdiff(list.files('R',pattern='[.]R$',full.names=TRUE),'R/load.R')) source(f)
out <- '../docs/rethink-2026-10-22/final-audit/numbers'
inputs <- load_inputs()
parsed <- parse_signalling_evidence(inputs$evidence)
comparisons <- match_signalling(parsed,inputs$signals)
persisted <- read_display('signalling-eligibility')
saved <- readr::read_csv('data-derived/expert-signalling-comparisons.csv',show_col_types=FALSE,col_types=readr::cols(.default='c'),na=character())
canonical <- function(x,cols) {
 x <- as.data.frame(x[,cols]); x[] <- lapply(x,function(v) ifelse(is.na(v),'',as.character(v)))
 sort(apply(x,1,paste,collapse='|'))
}
cols <- intersect(names(saved),names(comparisons))
stopifnot(identical(canonical(saved,cols),canonical(comparisons,cols)))
cat('PASS all',nrow(saved),'persisted signalling comparison rows reproduce from both workbook evidence sheets and original arm exports across',length(cols),'fields.\n')
elig <- comparisons |> count(adjudicator,source,domain,evaluable,reason,name='count')
stopifnot(identical(canonical(elig,names(elig)),canonical(persisted,names(elig))))
cat('PASS every eligibility reason and count reproduces from explicit component match, answer validity and arm-active flags.\n')
# Recount all absolute and paired question/domain values, without generating resamples.
est <- read_display('signalling-estimates'); delta <- read_display('signalling-differences')
for(i in seq_len(nrow(est))) {
 r <- est[i,]; d <- comparisons |> filter(adjudicator==r$adjudicator,source==r$source,evaluable,
   if(r$group=='Overall') TRUE else if(startsWith(r$group,'D')) domain==r$group else question==r$group)
 event <- d[[paste0(r$level,'_match')]]
 stopifnot(r$n==nrow(d),r$count==sum(event),isTRUE(all.equal(r$estimate,mean(event))))
}
for(i in seq_len(nrow(delta))) {
 r <- delta[i,]; d <- comparisons |> filter(adjudicator==r$adjudicator,
   if(r$group=='Overall') TRUE else if(startsWith(r$group,'D')) domain==r$group else question==r$group) |>
   select(slug,domain,question,component,source,evaluable,five_match,collapsed_match) |>
   pivot_wider(names_from=source,values_from=c(evaluable,five_match,collapsed_match)) |> filter(evaluable_ARBITER & evaluable_Unassisted)
 expected <- mean(as.integer(d[[paste0(r$level,'_match_ARBITER')]])-as.integer(d[[paste0(r$level,'_match_Unassisted')]]))
 stopifnot(r$n==nrow(d),(is.nan(expected)&&is.na(r$estimate)) || isTRUE(all.equal(r$estimate,expected)))
}
cat('PASS all',nrow(est),'absolute signalling rows and',nrow(delta),'paired differences, including zero-eligible rows. No bootstrap run.\n')
entries <- supplement_entries(inputs)
readr::write_csv(bind_rows(lapply(entries,function(e) tibble(number=e$number,title=e$title,source=e$source,rows=nrow(e$data),columns=paste(names(e$data),collapse=' | '),note=supplement_note(e)))),paste0(out,'/supplement-mapping.csv'))
# Check plot data selection and retained scale ranges without saving/rendering a plot.
for(spec in list(c('Figure4','independent-differences'),c('Figure5','signalling-differences'))) {
 d <- read_display(spec[2])
 if(spec[1]=='Figure4') d <- filter(d,adjudicator %in% c('1','2'),metric=='accuracy',comparison=='ARBITER minus Unassisted',domain!='Overall')
 else d <- filter(d,group %in% paste0('D',1:5))
 lim <- if(spec[1]=='Figure4') c(-.1,.3) else c(-.2,.4)
 stopifnot(all(d$lower>=lim[1]),all(d$upper<=lim[2]))
 cat('PASS',spec[1],'all',nrow(d),'paired intervals inside scale',lim,'\n')
}
cat('PASS workbook load contracts: 102 trials; 510 cells/expert; all 3060 workbook arm labels equal source exports.\n')
