CI_NOTE <- 'CI, confidence interval. Intervals use 10,000 percentile bootstrap resamples of trials within reviews.'
read_display <- function(name) {
  x <- readr::read_csv(paste0('output/tables/',name,'.csv'),show_col_types=FALSE)
  # Preserve legacy internal identifiers when reading renamed display exports.
  if(!startsWith(name,'posthoc-')) {
    for(k in names(x)) if(is.character(x[[k]])) x[[k]] <- gsub('Direct prompting','Unassisted',x[[k]],fixed=TRUE)
    names(x) <- gsub('Direct prompting','Unassisted',names(x),fixed=TRUE)
  }
  if('adjudicator' %in% names(x)) x$adjudicator <- as.character(x$adjudicator)
  x
}
write_display_trace <- function() {
  files <- list.files('output/tables',pattern='[.]csv$')
  files <- files[!startsWith(files,'display-')]
  trace <- lapply(files,function(file) {
    name <- sub('[.]csv$','',file)
    x <- read_display(name)
    tibble(file=name,row=rep(seq_len(nrow(x)),times=ncol(x)),
      column=rep(names(x),each=nrow(x)),value=unlist(lapply(x,as.character),use.names=FALSE))
  })
  trace <- bind_rows(trace) |> mutate(value=gsub('Unassisted','Direct prompting',value,fixed=TRUE),
    column=gsub('Unassisted','Direct prompting',column,fixed=TRUE))
  readr::write_csv(trace,'output/tables/display-source-trace.csv',na='')
}
characteristics_table <- function(inputs) {
  sev <- read_display('severity-distribution')
  docs <- read_display('benchmark-documents')
  rel <- read_display('expert-reliability')
  rows <- read_display('benchmark-characteristics') |> transmute(Characteristic=characteristic,Value=as.character(count))
  rows <- bind_rows(rows,docs |> group_by(document_type) |> summarise(count=sum(available),n=n(),.groups='drop') |>
    transmute(Characteristic=paste('Trials with',recode(document_type,sap='SAP')),Value=fmt_fraction(count,n)))
  for(pop in 'D1-D5') for(src in c('Expert 1','Expert 2','Published','ARBITER','Unassisted')) {
    x <- filter(sev,population==pop,source==src) |> arrange(match(label,LABELS))
    rows <- bind_rows(rows,tibble(Characteristic=paste(if(pop=='D1-D5') 'D1–D5' else pop,src,sep=': '),
      Value=paste(paste0(x$label,': ',fmt_fraction(x$count,x$n)),collapse='; ')))
  }
  for(dom in c('D1-D5','D3')) {
    a <- filter(rel,domain==dom,metric=='accuracy'); k <- filter(rel,domain==dom,metric=='kappa')
    rows <- bind_rows(rows,tibble(Characteristic=paste('Expert-to-expert',dom),Value=paste0(fmt_fraction(a$count,a$n),'; κ ',fmt_number(k$estimate))))
  }
  rows
}
benchmark_context_table <- function(inputs) {
  x <- characteristics_table(inputs)
  x |> filter(!grepl('Overall|Expert-to-expert',Characteristic))
}
# Legacy reader name and CSV key retained for provenance; conditional choices only.
primary_endpoint_table <- function() {
  x <- read_display('primary-endpoint') |> filter(metric=='ARBITER',analysis %in% c('Consensus','Expert 1','Expert 2','Split sensitivity'))
  x |> transmute(Population=recode(analysis,Consensus='Agreed choices',`Split sensitivity`='All splits counted against ARBITER'),
    `ARBITER, No./total (%) (95% CI)`=fmt_estimate(x,TRUE))
}
process_integrity_table <- function() {
  source_rows <- main_table3() |> select(Measure,ARBITER,Unassisted)
  x <- source_rows |>
    filter(!grepl('^D[1-5] rule|^Overall|^Domain ratings|^Evidence and audit',Measure)) |>
    mutate(Measure=sub('supporting passage','passage',Measure,fixed=TRUE))
  p <- read_display('table5')[1:2,] |> mutate(across(where(is.character),fmt_process_text))
  names(p) <- c('Measure','ARBITER','Unassisted','Paired mean difference (95% CI)')
  p$Measure <- c('Runtime (minutes/trial), median (IQR)','API list-price equivalent (US$/trial), median (IQR)')
  evidence <- source_rows[4:7,]
  evidence$Measure <- c('Active required answers citing evidence','Text spans with complete binding fields',
    'Image records with complete fields','Exported records passing structural verification')
  bind_rows(tibble(Measure='A. Rule conformance',ARBITER='',Unassisted=''),
    tibble(Measure='Domain outputs reproduced from proposals',ARBITER='510/510 (100.0%)',Unassisted='Not available'),x[1:3,],
    tibble(Measure='B. Computational resources',ARBITER='',Unassisted=''),p,
    tibble(Measure='C. Evidence records (ARBITER only)',ARBITER='',Unassisted=''),evidence) |>
    mutate(across(everything(),~replace_na(.x,'')),
      `Paired mean difference (95% CI)`=if_else(`Paired mean difference (95% CI)`=='' & !grepl('^[ABC][.]',Measure),'—',`Paired mean difference (95% CI)`))
}
build_main_tables <- function(inputs,table_numbers=1:3) {
  dir.create('output/manuscript/qa',recursive=TRUE,showWarnings=FALSE)
  table2 <- primary_endpoint_table()
  tables <- list(benchmark_context_table(inputs),table2,process_integrity_table())
  titles <- c('Benchmark and reference context','Blinded label choices',
    'Process checks and computational resources')
  notes <- c('SAP, statistical analysis plan. Each source contributes 510 domain cells. Document counts are among 102 trials; document types overlap.',
    paste('Choices were evaluated in 80 cells where arms differed; 60 had agreed reviewer choices and 20 split. Review-specific rows use all 80. The final row counts every split against ARBITER without crediting Direct prompting. Human Review 1 chose neither arm in 4 of 80 cells.',CI_NOTE),
    paste('API, application programming interface; IQR, interquartile range. Rule checks include 510 ARBITER and 509 Direct prompting cells; one Direct prompting cell was unevaluable. ARBITER had no domain overrides and one Overall escalation. Resource summaries include 102 paired trials. API list-price equivalents are not expenditure. Evidence-record checks do not assess whether evidence supports an answer. A dash indicates not applicable; Not available, not measured.',CI_NOTE))
  readr::write_csv(display_numbering(),'output/manuscript/qa/display-numbering.csv')
  for(i in table_numbers) {
    j <- c('1'=1L,'2'=3L,'3'=2L)[as.character(i)]
    x <- reader_table(tables[[j]]);readr::write_csv(x,paste0('output/tables/display-table',i,'.csv'),na='')
    doc <- manuscript_doc() |> manuscript_par(paste0('Table ',i,' ',titles[j]),style='heading 1')
    tab <- house_table(x,notes[j],6.85)
    writeLines(gt::as_raw_html(tab,inline_css=FALSE),paste0('output/manuscript/qa/Table',i,'.html'))
    doc <- add_gt(doc,tab)
    save_manuscript_doc(doc,paste0('output/manuscript/Table',i,'.docx'))
  }
}

build_displays <- function(inputs,cells,rebuild_figures=TRUE) {
  build_main_tables(inputs)
  if(rebuild_figures) build_manuscript_figures(cells)
  build_supplement(inputs)
  build_figure_legends()
  build_results_sentences()
  write_display_trace()
  finalize_publication_documents()
}

finalize_publication_documents <- function() {
  python <- Sys.getenv('ARBITER_PYTHON',unset=Sys.which('python'))
  if(!nzchar(python)) python <- Sys.which('python3')
  if(!nzchar(python)) stop('Install Python with python-docx and lxml, or set ARBITER_PYTHON to that interpreter.')
  stopifnot(system2(python,'../docs/manuscript/assemble-publication.py')==0L)
}
