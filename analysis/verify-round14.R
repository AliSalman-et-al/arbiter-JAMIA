source('R/load.R')
for(f in c('bootstrap.R','agreement.R','algorithms.R','win-share.R','posthoc.R','publication-io.R','presentation.R','manuscript-tables.R','avatar-trace.R','manuscript-supplement.R')) source(paste0('R/',f))
x <- load_inputs(); w <- stratified_cluster_weights(x$trials,10000,20261018)
r <- rules_only_recomputation(x$labels,domain_checks(x),adjudication_cells(x),w)
observed <- c(changed_disagreements=sum(r$changed$consensus & r$changed$discordant,na.rm=TRUE),
  wins=r$win_share$count[r$win_share$metric=='Baseline'],
  published=r$agreement$count[r$agreement$domain=='D1-D5' & r$agreement$metric=='accuracy'],
  agreed=r$agreed_choice$count)
expected <- c(3,7,10,395,385,69,64)
comparison <- data.frame(quantity=c('Changed original disagreements','Reported Unassisted wins','Recomputed Unassisted wins','Reported Published agreement','Recomputed Published agreement','Reported agreed-choice agreement','Recomputed agreed-choice agreement'),preliminary=expected,reproduced=unname(observed))
readr::write_csv(comparison,'output/manuscript/qa/round14-preliminary-reproduction.csv')
print(comparison)
# Report differences rather than changing estimates to match the preliminary script.
if(any(observed!=expected)) warning('Preliminary numbers differ; inspect reproduction CSV')
d <- direction_of_disagreement(adjudication_cells(x),w)
stopifnot(identical(d$count,c(73L,22L,48L,19L)),identical(d$n,c(77L,28L,59L,38L)))
stopifnot(all(d$valid_replicates==10000))
files <- c(list.files('output/manuscript',pattern='[.]docx$',full.names=TRUE), 'results.html','supplement.html')
for(p in files) {
 text <- if(endsWith(p,'.docx')) officer::docx_summary(officer::read_docx(p))$text else reader_html_text(p)
 stopifnot(!any(grepl('Haiku|ARBITER-Sonnet|Baseline-Sonnet|Meta label|Adjudicator [AZ]\\b|over-flagging|supported by evidence',text,ignore.case=TRUE)))
 stopifnot(length(raw_reader_codes(text))==0)
}
for(p in list.files('output/tables',pattern='[.]csv$',full.names=TRUE)) {
 text <- readLines(p,warn=FALSE)
 stopifnot(!any(grepl('Haiku|ARBITER-Sonnet|Baseline-Sonnet',text,ignore.case=TRUE)))
}
entries <- supplement_registry(x)
writeLines(paste0('eTable ',seq_along(entries),'. ',vapply(entries,`[[`,character(1),'caption')),'output/manuscript/qa/round14-supplement-inventory.txt')
cat('Round 14 output and estimand checks passed.\n')
