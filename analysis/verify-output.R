# Read-only verification of final artifacts, plus verification records in provenance/.
source('R/load.R')
for(f in setdiff(list.files('R',pattern='[.]R$',full.names=TRUE),'R/load.R')) source(f)
dir.create('provenance',showWarnings=FALSE)
log <- character()
record <- function(x) {cat(x,'\n');log <<- c(log,x)}
inputs <- load_inputs()
record('PASS loader: 102 trials, 510 unique cells per expert; all 3060 workbook source labels match arm exports (including paired missing values).')
# Independent base-R recomputation from the workbook, without primary-analysis helpers.
a <- readxl::read_xlsx('../human-adjudication/adjudication-with-explanations-1.xlsx',sheet='Adjudications',col_types='text')
b <- readxl::read_xlsx('../human-adjudication/adjudication-with-explanations-2.xlsx',sheet='Adjudications',col_types='text')
i <- match(paste(a$Trial,a$Domain),paste(b$Trial,b$Domain))
stopifnot(!anyNA(i)); b <- b[i,]
disputed <- a$Kit!=a$Human | a$`No-kit`!=a$Human
differ <- a$Kit!=a$`No-kit`
agreed <- a$`Chosen label`==b$`Chosen label`
keep <- differ & agreed
provisional <- c(disputed=sum(disputed),discordant=sum(differ),agreed_choice=sum(keep),ARBITER=sum(a$Kit[keep]==a$`Chosen label`[keep]),
  Unassisted=sum(a$`No-kit`[keep]==a$`Chosen label`[keep]),agreed_reference=sum(a$Independent==b$Independent),concordant=sum(!disputed))
stopifnot(identical(as.integer(provisional),c(154L,80L,60L,53L,7L,388L,356L)))
saved_cells <- readr::read_csv('output/tables/adjudication-analysis-cells.csv',show_col_types=FALSE)
stopifnot(n_distinct(saved_cells$slug)==102L,nrow(saved_cells)==510L,
  sum(saved_cells$disputed)==154L,sum(saved_cells$discordant)==80L,
  sum(saved_cells$discordant & saved_cells$consensus)==60L)
record('PASS Figure 3 counts reproduce from adjudication-analysis-cells.csv.')
record(paste('PASS independent workbook recomputation:',paste(names(provisional),provisional,collapse='; ')))
# Compare generated values with direct base-R equality counts.
est <- readr::read_csv('output/tables/independent-estimates.csv',show_col_types=FALSE)
for(expert in c('1','2')) for(source in c('ARBITER','Unassisted','Published')) {
  ref <- if(expert=='1') a$Independent else b$Independent
  pred <- switch(source,ARBITER=a$Kit,Unassisted=a$`No-kit`,Published=a$Human)
  row <- filter(est,adjudicator==expert,.data$source==.env$source,domain=='D1-D5',metric=='accuracy')
  stopifnot(row$count==sum(pred==ref),row$n==510L)
}
overall <- filter(est,domain=='Overall',adjudicator %in% c('1','2'))
stopifnot(all(overall$n[overall$population=='All trials']==102L),
  !any(overall$source=='Published' & overall$population=='All trials'),
  all(overall$n[overall$population=='Observed Published Overall']==81L))
agreed_overall <- filter(est,domain=='Overall',adjudicator=='Agreed reference')
stopifnot(all(agreed_overall$n[agreed_overall$population=='All trials']==52L),
  all(agreed_overall$n[agreed_overall$population=='Observed Published Overall']==42L))
paired <- readr::read_csv('output/tables/independent-differences.csv',show_col_types=FALSE) |>
  filter(domain=='Overall',adjudicator %in% c('1','2'),grepl('Published',comparison))
stopifnot(all(paired$n==81L))
for(expert in c('1','2')) {
  workbook <- if(expert=='1') a else b
  derived <- tapply(match(workbook$Independent,LABELS),workbook$Trial,max)
  for(source_name in c('ARBITER','Unassisted','Published')) {
    arm <- if(source_name=='Unassisted') 'Baseline-Sonnet' else 'ARBITER-Sonnet'
    pred <- inputs$labels |> filter(domain=='Overall',.data$arm==.env$arm)
    values <- if(source_name=='Published') pred$meta else pred$label
    expected <- LABELS[derived[pred$slug]]
    observed <- inputs$labels |> filter(domain=='Overall',arm=='ARBITER-Sonnet',!is.na(meta)) |> pull(slug)
    for(population_name in unique(overall$population)) {
      row <- overall |> filter(adjudicator==expert,source==source_name,population==population_name,metric=='accuracy')
      if(!nrow(row)) next
      keep <- if(population_name=='Observed Published Overall') pred$slug %in% observed else rep(TRUE,nrow(pred))
      stopifnot(row$n==sum(keep),row$count==sum(!is.na(values[keep]) & values[keep]==expected[keep]))
    }
  }
}
record('PASS independent base-R worst-domain Overall counts for every source, expert and full/matched cohort.')
record('PASS Overall cohorts: ARBITER and Unassisted n=102 plus matched n=81; Published and paired Published contrasts n=81. Missing Published labels are excluded.')
record('PASS independent direct equality counts for all six source/expert comparisons.')
direction <- readr::read_csv('output/tables/direction-of-disagreement.csv',show_col_types=FALSE)
stopifnot(all(abs(direction$estimate-direction$count/direction$n)<1e-12))
stopifnot(all((direction |> group_by(source,direction,adjudicator) |> summarise(total=sum(count),n=dplyr::first(n),.groups='drop') |> mutate(ok=total==n))$ok))
record('PASS direction counts partition each source/direction/expert population and reproduce every point estimate.')
for(path in list.files('output/tables',pattern='[.]csv$',full.names=TRUE)) {
  x <- readr::read_csv(path,show_col_types=FALSE)
  if(all(c('count','n','estimate') %in% names(x))) {
    keep <- !is.na(x$count) & !is.na(x$n) & x$n>0 & !is.na(x$estimate)
    if('metric' %in% names(x)) keep <- keep & !x$metric %in% c('kappa','AC2')
    stopifnot(all(abs(x$estimate[keep]-x$count[keep]/x$n[keep])<1e-12))
  }
}
record('PASS every exported count/denominator proportion agrees with its estimate.')
v <- readr::read_csv('output/tables/derived-overall-validation.csv',show_col_types=FALSE)
stopifnot(nrow(v)==612L,all(v$matches[v$column %in% c('independent','chosen_label','revised','nokit')]))
stopifnot(sum(!v$matches & is.na(v$workbook))==21L)
allowed <- 0L
for(column_name in c('human','kit')) {
  rows <- filter(v,column==column_name,!matches,!is.na(workbook),workbook=='High',calculated=='Some concerns')
  d <- filter(inputs$adjud,adjudicator=='2')
  sc <- tapply(d[[column_name]]=='Some concerns',d$slug,sum)
  stopifnot(all(sc[rows$slug]>=2L))
  allowed <- allowed+nrow(rows)
}
stopifnot(allowed==7L,nrow(filter(v,!matches,workbook=='Low',calculated=='Some concerns',slug=='gupta-2024'))==1L)
record('PASS Overall differences classified: 21 absent Published labels, seven permitted multi-domain High escalations, one Published Low versus derived Some concerns.')
record(paste('Derived Overall validation:',sum(!v$matches),'differences across',nrow(v),'columns/trial checks; all expert independent, chosen and revised ratings match.'))
# Exact CSV diffs to the parent; git diff content is retained, not inferred from rounded numbers.
unchanged <- c('agreement-meta','agreement-meta-differences','table1','table1-differences','table3','table3-supplement',
  'audit-summary','bundle-domain-checks','api-cost-summary','api-token-reconciliation','process-summary','process-differences',
  'table5','evidence-bases-distribution','overall-consistency-cells','domain-consistency-cells','invalid-path-sensitivity')
paths <- paste0('analysis/output/tables/',unchanged,'.csv')
diffs <- system2('git',c('-C','..','diff','fee1225','--',paths),stdout=TRUE)
writeLines(diffs,'provenance/unchanged-analysis.diff')
stopifnot(!length(diffs))
prior <- readr::read_csv('data-curated/prior-work-comparison.csv',show_col_types=FALSE)
parent <- system2('git',c('show','HEAD:analysis/data-curated/prior-work-comparison.csv'),stdout=TRUE)
parent <- readr::read_csv(I(paste(parent,collapse='\n')),show_col_types=FALSE)
stopifnot(identical(prior[setdiff(names(prior),'reference_standard')],parent[setdiff(names(parent),'reference_standard')]))
writeLines(system2('git',c('-C','..','diff','HEAD','--','analysis/data-curated/prior-work-comparison.csv'),stdout=TRUE),'provenance/prior-work-data.diff')
record('PASS 17 unchanged CSVs: empty git diff against fee1225; prior-work data identical except the authorised reference description.')
figures <- list.files('output/manuscript',pattern='^Figure[12][.](pdf|png|tiff|svg)$',full.names=TRUE)
stopifnot(length(figures)==8L)
artwork <- list()
for(p in figures) {
  actual <- system2('git',c('hash-object',p),stdout=TRUE)
  expected <- system2('git',c('rev-parse',paste0('fee1225:analysis/',p)),stdout=TRUE)
  stopifnot(identical(actual,expected))
  artwork[[p]] <- tibble(file=p,actual_git_blob=actual,parent_git_blob=expected)
}
readr::write_csv(bind_rows(artwork),'provenance/protected-artwork.csv')
record('PASS Figures 1 and 2: all eight PNG/PDF/SVG/TIFF files byte-identical to fee1225.')
trace <- readr::read_csv('output/tables/display-source-trace.csv',show_col_types=FALSE,col_types=readr::cols(.default='c'))
for(file in unique(trace$file)) {
  x <- readr::read_csv(paste0('output/tables/',file,'.csv'),show_col_types=FALSE)
  rows <- trace[trace$file==file,]
  for(column in unique(rows$column)) {
    z <- rows[rows$column==column,]
    actual <- as.character(x[[column]][as.integer(z$row)])
    same <- (is.na(actual)&is.na(z$value))|(!is.na(actual)&!is.na(z$value)&actual==z$value)
    stopifnot(all(same))
  }
}
record(paste('PASS',nrow(trace),'source-cell trace records resolve to final CSV values.'))
expected <- paste(results_sentences(),collapse='\n\n')
actual <- paste(readLines('output/manuscript/results-sentences.md',encoding='UTF-8'),collapse='\n')
stopifnot(identical(enc2utf8(expected),enc2utf8(actual)))
stopifnot(identical(paste(figure_legend_sections(),collapse='\n\n'),paste(readLines('output/manuscript/figure-legends.md',encoding='UTF-8'),collapse='\n')))
record('PASS results sentences and figure legends exactly regenerate from final CSVs and the protected supplied legends.')
compact <- compact_expert_table(
  readr::read_csv('output/tables/independent-estimates.csv',show_col_types=FALSE),
  readr::read_csv('output/tables/independent-differences.csv',show_col_types=FALSE),
  readr::read_csv('output/tables/expert-reliability.csv',show_col_types=FALSE))
stopifnot(identical(as.matrix(compact),as.matrix(readr::read_csv('output/tables/display-table2.csv',show_col_types=FALSE,na=character()))),nrow(compact)==10L)
record('PASS compact Table 2: source rows against three references, paired differences, matched Overall and expert-to-expert foot rows.')
questions <- question_difference_plot()$data
all_questions <- question_difference_plot(TRUE)$data
stopifnot(all(questions$n>=20L),all(as.character(questions$level)=='Collapsed'),
  is.null(question_difference_plot()$labels$title),any(all_questions$n==0L),nrow(all_questions)>nrow(questions))
comparison <- readr::read_csv('data-derived/expert-signalling-comparisons.csv',show_col_types=FALSE)
counts <- read_display('signalling-disagreement-types')
five <- readr::read_csv('output/tables/signalling-estimates.csv',show_col_types=FALSE) |> filter(group=='Overall',level=='five')
for(i in seq_len(nrow(counts))) {
  row <- counts[i,]
  prior <- filter(five,adjudicator==row$adjudicator,source==row$source)
  stopifnot(row$n==prior$n,row$five_level_disagreements==prior$n-prior$count)
  d <- comparison[comparison$adjudicator==row$adjudicator & comparison$source==row$source & comparison$evaluable,]
  within <- (d$answer=='Y' & d$arm_answer=='PY') | (d$answer=='PY' & d$arm_answer=='Y') |
    (d$answer=='N' & d$arm_answer=='PN') | (d$answer=='PN' & d$arm_answer=='N')
  disagree <- d$answer!=d$arm_answer
  stopifnot(row$n==nrow(d),row$five_level_disagreements==sum(disagree),
    row$within_direction==sum(within),row$cross_direction==sum(disagree & !within),
    row$within_direction+row$cross_direction==row$five_level_disagreements)
}
record('PASS independent answer-code recomputation of every within/cross-direction count; within/cross-direction counts reproduce directly from answer codes.')
record('PASS eFigure 2 retains only question/expert rows with at least 20 paired answers; eFigure 5 retains every sparse and zero-answer row.')
# Word tables must contain every displayed value in the CSV in reading order.
docx_text <- function(path) {
  con <- unz(path,'word/document.xml')
  xml <- xml2::read_xml(con)
  paste(xml2::xml_text(xml2::xml_find_all(xml,'//w:t',xml2::xml_ns(xml))),collapse=' ')
}
for(i in 1:4) {
  x <- readr::read_csv(paste0('output/tables/display-table',i,'.csv'),show_col_types=FALSE)
  text <- docx_text(paste0('output/manuscript/Table',i,'.docx'))
  values <- unique(na.omit(as.character(unlist(x))))
  text <- gsub('[[:space:]]+',' ',text)
  values <- gsub('[[:space:]]+',' ',values)
  stopifnot(all(vapply(values,function(v) grepl(v,text,fixed=TRUE),logical(1))))
}
supplement_text <- gsub('\\s+',' ',docx_text('output/manuscript/Supplement.docx'),perl=TRUE)
for(path in list.files('output/tables',pattern='^display-supplement-.*[.]csv$',full.names=TRUE)) {
  x <- readr::read_csv(path,show_col_types=FALSE,col_types=readr::cols(.default='c'))
  target <- if(grepl('reporting-map[.]csv$',path)) gsub('\\s+',' ',docx_text('output/manuscript/TRIPOD-LLM.docx'),perl=TRUE) else supplement_text
  expected_rows <- apply(as.data.frame(x),1,function(v) gsub('\\s+',' ',trimws(paste(v[!is.na(v)],collapse=' ')),perl=TRUE))
  if(!all(vapply(expected_rows,function(v) grepl(v,target,fixed=TRUE),logical(1)))) stop('Supplement row trace failed: ',basename(path))
}
entries <- supplement_entries(inputs)
for(e in entries) {
  slug <- tolower(gsub('[^A-Za-z0-9]+','-',e$title))
  saved <- readr::read_csv(paste0('output/tables/display-supplement-',slug,'.csv'),
    show_col_types=FALSE,col_types=readr::cols(.default='c'),na=character())
  if(!identical(names(saved),names(e$data)) || !identical(as.matrix(saved),as.matrix(e$data)))
    stop('Current display-builder trace failed: ',e$title,' :: ',paste(all.equal(as.matrix(saved),as.matrix(e$data)),collapse='; '))
  expected_note <- gsub('\\s+',' ',supplement_note(e),perl=TRUE)
  stopifnot(grepl(expected_note,supplement_text,fixed=TRUE))
}
record('PASS current display builders reproduce every supplemental display CSV and its Word footnote exactly.')
entry <- function(title) entries[[match(title,vapply(entries,`[[`,character(1),'title'))]]$data
stopifnot('Source' %in% names(entry('Published label agreement')),
  'Source' %in% names(entry('Evidence binding')),
  'Unweighted κ' %in% names(entry('Unweighted agreement with published labels')),
  !any(unlist(entry('Derived Overall validation differences')) %in% c('kit','nokit','human')))
matrices <- entry('Confusion matrices against each independent expert')
counts <- rowSums(sapply(matrices[c('Low','Some Concerns','High','Missing')],as.numeric))
raw <- readr::read_csv('output/tables/independent-confusion.csv',show_col_types=FALSE)
stopifnot(sum(counts)==sum(raw$n[raw$adjudicator %in% c('1','2')]))
record('PASS supplementary source labels, unweighted κ labels, public validation labels and complete confusion-matrix totals.')
for(path in c('output/tables/avatar-trace-answers.csv','output/tables/avatar-trace-evidence.csv')) {
  x <- readr::read_csv(path,show_col_types=FALSE,col_types=readr::cols(.default='c'))
  values <- unique(na.omit(as.character(unlist(x))))
  values <- gsub('\\s+',' ',values,perl=TRUE)
  stopifnot(all(vapply(values,function(v) grepl(v,supplement_text,fixed=TRUE),logical(1))))
}
record('PASS every AVATAR answer, rationale and full evidence-record field occurs in the supplement.')
record('PASS all supplementary and reporting-map display rows occur in their Word documents in CSV column order.')
record('PASS all four Word tables contain every corresponding display-CSV cell.')
html_text <- function(path) {
  xml <- xml2::read_html(path)
  xml2::xml_remove(xml2::xml_find_all(xml,'//script|//style'))
  gsub('\\s+',' ',paste(xml2::xml_text(xml2::xml_find_all(xml,'//body//text()')),collapse=' '),perl=TRUE)
}
normalise_html_typography <- function(x) {
  # Pandoc may append a text/emoji presentation selector to the bidirectional arrow.
  x <- gsub('[\uFE0E\uFE0F]','',x,perl=TRUE)
  x <- chartr('‘’“”',paste0("''",'\"\"'),x)
  x <- gsub('`','',x,fixed=TRUE)
  gsub('[[:space:]\u00a0]+',' ',x,perl=TRUE)
}
result_html <- normalise_html_typography(html_text('results.html'))
supplement_html <- normalise_html_typography(html_text('supplement.html'))
stopifnot(all(vapply(results_sentences(),function(v) grepl(normalise_html_typography(v),result_html,fixed=TRUE),logical(1))))
for(path in list.files('output/tables',pattern='^display-.*[.]csv$',full.names=TRUE)) {
  if(grepl('source-trace|reporting-map',path)) next
  x <- readr::read_csv(path,show_col_types=FALSE,col_types=readr::cols(.default='c'),na=character())
  target <- if(grepl('display-table[1-4][.]csv$',path)) result_html else supplement_html
  values <- unique(na.omit(as.character(unlist(x))))
  values <- normalise_html_typography(gsub('\\s+',' ',values,perl=TRUE))
  ok <- vapply(values,function(v) grepl(v,target,fixed=TRUE),logical(1))
  if(!all(ok)) stop('HTML cell trace failed: ',basename(path),' :: ',paste(head(values[!ok],3),collapse=' | '))
}
stopifnot(!grepl('Composite-reference|decisive|eTable 32',supplement_html))
record('PASS final HTML: every Results sentence and main/supplementary display-CSV cell appears; no retired supplement sections remain.')

for(f in c(paste0('output/manuscript/Table',1:4,'.docx'),'output/manuscript/Supplement.docx','output/manuscript/TRIPOD-LLM.docx','results.html','supplement.html')) stopifnot(file.exists(f),file.info(f)$size>0)
for(i in 3:6) for(ext in c('pdf','png','tiff')) stopifnot(file.exists(paste0('output/manuscript/Figure',i,'.',ext)))
# Strict model leak check covers every textual output, plus text inside all Word files.
texts <- list.files('output',pattern='[.](csv|md|txt|svg)$',recursive=TRUE,full.names=TRUE)
for(f in texts) stopifnot(!any(grepl('haiku',readLines(f,warn=FALSE),ignore.case=TRUE)))
word <- list.files('output/manuscript',pattern='[.]docx$',full.names=TRUE)
for(f in word) stopifnot(!grepl('haiku',docx_text(f),ignore.case=TRUE))
for(f in c('results.html','supplement.html')) stopifnot(!any(grepl('haiku',readLines(f,warn=FALSE),ignore.case=TRUE)))
record('PASS unreported-model leak scan over all textual outputs, all Word documents and both HTML views.')
# Scan rendered prose, never link targets or the technical provenance CSVs.
filename_pattern <- '(?i)\\b[[:alnum:]_][[:alnum:]_.-]*[.](csv|md|txt|lock|json|pdf|docx|xlsx|R)\\b'
reader_text <- c(docx_text('output/manuscript/Supplement.docx'),result_html,supplement_html,
  paste(readLines('output/manuscript/figure-legends.md'),collapse=' '),
  paste(readLines('output/manuscript/results-sentences.md'),collapse=' '))
stopifnot(!any(grepl(filename_pattern,reader_text,perl=TRUE)),
  !any(grepl('mainly reflected',reader_text,fixed=TRUE)))
record('PASS reader-facing text contains no filenames or overstated five-level disagreement wording; technical link targets are excluded.')

reader <- c(list.files('output/manuscript',pattern='results-sentences[.]md$|figure-legends[.]md$',full.names=TRUE),
  list.files('output/tables',pattern='^display-table.*[.]csv$',full.names=TRUE))
for(f in reader) {
  txt <- paste(readLines(f,warn=FALSE),collapse='\n')
  stopifnot(!grepl('(?i)\\b(?:no-kit|meta label|vindicated|decisive|over-flagging)\\b|A/Z',txt,perl=TRUE))
}
record('PASS generated Results, legends and main-table reader text has no retired-design labels. Source quotations and immutable artwork receive contextual review in round16-report.md.')
writeLines(log,'provenance/output-verification.txt')

severity <- readr::read_csv('output/tables/severity-distribution.csv',show_col_types=FALSE)
stopifnot(identical(severity |> filter(population=='D1-D5',label=='Low') |> pull(count),c(427,375,407,277,346)))
binary <- readr::read_csv('output/tables/independent-binary.csv',show_col_types=FALSE)
for(expert in c('1','2')) for(src in c('ARBITER','Unassisted','Published')) for(dom in c('D1-D5',paste0('D',1:5))) {
  wb <- if(expert=='1') a else b
  if(dom!='D1-D5') wb <- wb[wb$Domain==dom,]
  truth <- wb$Independent!='Low'
  prediction <- wb[[switch(src,ARBITER='Kit',Unassisted='No-kit',Published='Human')]]!='Low'
  rows <- filter(binary,adjudicator==expert,source==src,domain==dom)
  stopifnot(rows$n[rows$metric=='sensitivity']==sum(truth),rows$count[rows$metric=='sensitivity']==sum(truth&prediction),
    rows$n[rows$metric=='specificity']==sum(!truth),rows$count[rows$metric=='specificity']==sum(!truth&!prediction))
}
record('PASS independent workbook severity counts and every expert binary pooled/domain numerator and denominator.')
# Preserve all prior statistical estimates, including supplementary analyses.
stat_files <- list.files('output/tables',pattern='[.]csv$',full.names=TRUE)
compared <- character()
for(path in stat_files) {
  before <- suppressWarnings(system2('git',c('show',paste0('fee1225:analysis/',path)),stdout=TRUE,stderr=FALSE))
  if(!is.null(attr(before,'status'))) next
  old <- readr::read_csv(I(paste(before,collapse='\n')),show_col_types=FALSE)
  current <- readr::read_csv(path,show_col_types=FALSE)
  fields <- intersect(c('estimate','lower','upper','count','n','valid_replicates'),names(old))
  if(!length(fields)) next
  stopifnot(identical(old[fields],current[fields]))
  compared <- c(compared,basename(path))
}
writeLines(compared,'provenance/round16-estimate-invariance.txt')
record(paste('PASS every numeric estimate/count/denominator/CI unchanged in',length(compared),'Round 15 analysis CSVs against fee1225.'))
writeLines(log,'provenance/output-verification.txt')
# Complete reader-language scan. Clinical quotations keep their source wording.
reader_documents <- list.files('output/manuscript',pattern='[.]docx$',full.names=TRUE)
reader_strings <- c(setNames(lapply(reader_documents,docx_text),reader_documents),
  list(results_html=result_html,supplement_html=supplement_html,
    results_sentences=paste(readLines('output/manuscript/results-sentences.md'),collapse=' '),
    figure_legends=paste(readLines('output/manuscript/figure-legends.md'),collapse=' ')))
hard_ban <- '(?i)haiku|A/Z|adjudicator[[:space:]]+[12AZ]\\b|composite reference|vindicated|decisive question|over-flagging|expert-level|matched experts|ground truth|supported by evidence'
stopifnot(!any(vapply(reader_strings,function(s) grepl(hard_ban,s,perl=TRUE),logical(1))))
contexts <- bind_rows(lapply(names(reader_strings),function(name) {
  s <- reader_strings[[name]]
  pos <- gregexpr('(?i)\\b(first|composite|accuracy)\\b',s,perl=TRUE)[[1]]
  if(identical(as.integer(pos),-1L)) return(tibble())
  tibble(document=name,context=vapply(pos,function(p) substr(s,max(1,p-80),p+120),character(1)))
}))
readr::write_csv(contexts,'provenance/round16-leak-contexts.csv')
stopifnot(!grepl('(?i)\\b(first|composite|accuracy)\\b',reader_strings$results_sentences,perl=TRUE))
record('PASS complete reader-language scan; remaining first/composite/accuracy contexts are recorded for review of unchanged clinical quotations and rationale.')
writeLines(log,'provenance/output-verification.txt')
expected_binary_display <- clean_display(binary_difference_display(read_display('independent-binary-differences')))
saved_binary_display <- readr::read_csv('output/tables/display-supplement-paired-binary-differences.csv',show_col_types=FALSE,col_types=readr::cols(.default='c'),na=character())
stopifnot(identical(as.matrix(expected_binary_display),as.matrix(saved_binary_display)))
record('PASS new binary-difference display regenerates in percentage points, with identical numerators, denominators and intervals.')
writeLines(log,'provenance/output-verification.txt')
