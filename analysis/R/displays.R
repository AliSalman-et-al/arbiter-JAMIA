CI_NOTE <- 'CI, 95% confidence interval; 10,000 percentile bootstrap replicates, trials resampled within meta-analysis; seed 20261018.'
read_display <- function(name) {
  x <- readr::read_csv(paste0('output/tables/',name,'.csv'),show_col_types=FALSE)
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
  readr::write_csv(bind_rows(trace),'output/tables/display-source-trace.csv',na='')
}
characteristics_table <- function(inputs) {
  sev <- read_display('severity-distribution')
  docs <- read_display('benchmark-documents')
  rel <- read_display('expert-reliability')
  rows <- read_display('benchmark-characteristics') |> transmute(Characteristic=characteristic,Value=as.character(count))
  rows <- bind_rows(rows,docs |> group_by(document_type) |> summarise(count=sum(available),n=n(),.groups='drop') |>
    transmute(Characteristic=paste('Trials with',recode(document_type,sap='SAP')),Value=fmt_fraction(count,n)))
  for(pop in 'D1-D5') for(src in c('Published','ARBITER','Unassisted','Expert 1','Expert 2')) {
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
  x |> filter(!grepl('Overall|Expert-to-expert|D1–D5: (ARBITER|Unassisted)',Characteristic))
}
# Legacy reader name and CSV key retained for provenance; conditional choices only.
primary_endpoint_table <- function() {
  x <- read_display('primary-endpoint') |> filter(metric=='ARBITER',analysis %in% c('Consensus','Expert 1','Expert 2','Split sensitivity'))
  x |> transmute(Population=recode(analysis,Consensus='Agreed choices',`Split sensitivity`='All splits counted against ARBITER'),
    `ARBITER, No./total (%) (95% CI)`=fmt_estimate(x,TRUE))
}
process_integrity_table <- function() {
  x <- main_table3() |> select(Measure,ARBITER,Unassisted) |>
    filter(!grepl('^D[1-5] rule|^Overall|^Domain ratings|^Evidence and audit',Measure)) |>
    mutate(Measure=sub('supporting passage','passage',Measure,fixed=TRUE))
  p <- read_display('table5')[1:2,] |> mutate(across(where(is.character),fmt_process_text))
  names(p) <- c('Measure','ARBITER','Unassisted','Paired mean difference (95% CI)')
  p$Measure <- c('Runtime (minutes/trial), median (IQR)','API list-price equivalent (US$/trial), median (IQR)')
  bind_rows(tibble(Measure='A. Rule conformance',ARBITER='',Unassisted=''),
    tibble(Measure='Domain outputs reproduced from proposals',ARBITER='510/510 (100.0%)',Unassisted='Not available'),x[1:3,],
    tibble(Measure='B. Structural record checks',ARBITER='',Unassisted=''),x[4:nrow(x),],
    tibble(Measure='C. Computational resources',ARBITER='',Unassisted=''),p) |>
    mutate(across(everything(),~replace_na(.x,'')),
      `Paired mean difference (95% CI)`=if_else(`Paired mean difference (95% CI)`=='' & !grepl('^[ABC][.]',Measure),'—',`Paired mean difference (95% CI)`))
}
build_main_tables <- function(inputs) {
  dir.create('output/manuscript/qa',recursive=TRUE,showWarnings=FALSE)
  table2 <- primary_endpoint_table()
  tables <- list(benchmark_context_table(inputs),table2,process_integrity_table())
  titles <- c('Benchmark and reference context','Conditional blinded-label choices and sensitivities',
    'Process checks and computational resources')
  notes <- c('Reference categories are Low, Some concerns and High; each reference contributes 510 domain cells. Document counts are trials with each role recorded in the source inventory among 102 trials; roles can overlap. SAP, statistical analysis plan. Reference distributions and separate expert agreement appear in the compact supplement.',
    paste('Conditional blinded-label choice evaluation includes 80 arm-discordant cells and the 60 for which the experts made an agreed choice; 20 choices split. Expert-specific sensitivities use all 80. The final row counts all 20 splits against ARBITER by assumption, without assigning Unassisted wins. Expert 1 chose neither arm in 4/80 cells; this is distinct from the split-loss assumption.',CI_NOTE),
    paste('Unassisted rule-break cells show No./total (%; 95% CI); CI bounds are percentages. Domain rules use evaluable ratings (ARBITER 510; Unassisted 509); one Unassisted cell is unevaluable. Evidence denominators count active answers or distinct evidence records as indicated; verifier denominator is 102 bundles. ARBITER has no recorded domain overrides; one Overall escalation is permitted. Evidence checks establish quotation occurrence and structural binding, without assessing answer support. Runtime and API list-price equivalents use 102 paired trials; source summaries are median (IQR), contrasts are paired mean differences. Cost is a frozen-rate equivalent, not expenditure. — means not applicable; Not available means not measured.',CI_NOTE))
  readr::write_csv(display_numbering(),'output/manuscript/qa/display-numbering.csv')
  for(i in 1:3) {
    x <- reader_table(tables[[i]]);readr::write_csv(x,paste0('output/tables/display-table',i,'.csv'),na='')
    doc <- manuscript_doc() |> manuscript_par(paste0('Table ',i,' ',titles[i]),style='heading 1')
    tab <- house_table(x,notes[i],6.85)
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
