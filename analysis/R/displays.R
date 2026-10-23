CI_NOTE <- 'CI, 95% confidence interval; 10,000 percentile bootstrap replicates, trials resampled within meta-analysis; seed 20261018.'
read_display <- function(name) {
  readr::read_csv(paste0('output/tables/',name,'.csv'),show_col_types=FALSE)
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
expert_population_note <- function() {
  paste('N is the denominator on each row. D1–D5: n = 510 per expert and n = 388 for the agreed reference; individual domains: n = 102 per expert, with agreed-reference n shown by row.',
    'Overall (all): n = 102 per expert for ARBITER and Unassisted. Overall (observed): n = 81 per expert for all three sources and every paired contrast involving Published; ARBITER and Unassisted are also reported on these same n = 81 trials.',
    'Twenty-one trials had no observed Published Overall label; these missing labels are excluded, never counted as disagreements. Agreed-reference Overall uses n = 52 among all trials and n = 42 among the observed-label subset, restricting each population to equal expert ratings. Expert-to-expert Overall: n = 102. Exact agreement is a percentage; paired differences are percentage points or coefficients.')
}
expert_display <- function(x,pooled=FALSE) {
  if(pooled) x <- filter(x,domain %in% c('D1-D5','Overall'))
  if('population' %in% names(x)) x <- x |> mutate(domain=if_else(domain=='Overall',
    if_else(population=='Observed Published Overall','Overall (observed)','Overall (all)'),domain))
  x$value <- vapply(seq_len(nrow(x)),function(i) {
    r <- x[i,]
    if(!is.finite(r$estimate)) return('—')
    if(r$metric=='accuracy' && grepl(' minus ',r$source)) return(paste0(fmt_number(100*r$estimate,1),' pp ',fmt_ci(100*r$lower,100*r$upper,1)))
    fmt_estimate(r,r$metric=='accuracy')
  },character(1))
  x |>
    select(adjudicator,domain,source,n,metric,value) |> pivot_wider(names_from=metric,values_from=value) |>
    rename(Reference=adjudicator,Domain=domain,Source=source,N=n,`Exact agreement (95% CI)`=accuracy,`Weighted κ (95% CI)`=kappa) |>
    mutate(Reference=if_else(Reference %in% c('1','2'),paste('Expert',Reference),Reference))
}
estimate_display <- function(x) {
  ids <- intersect(c('adjudicator','arm','source','comparison','population','domain','group','level','analysis','metric','direction','outcome'),names(x))
  x$value <- vapply(seq_len(nrow(x)),function(i) {
    r <- x[i,]
    if(!is.finite(r$estimate)) return('—')
    prop <- !('metric' %in% names(x)) || !r$metric %in% c('kappa','AC2')
    difference <- 'comparison' %in% names(x) && grepl(' minus ',r$comparison)
    if(difference && prop) return(paste0(fmt_number(100*r$estimate,1),' pp ',fmt_ci(100*r$lower,100*r$upper,1)))
    fmt_estimate(r,prop)
  },character(1))
  x |> select(all_of(ids),any_of(c('count','n')),value)
}
binary_difference_display <- function(x) {
  estimate_display(x) |> mutate(value=gsub('%',' pp',value,fixed=TRUE))
}
table2_note <- function() paste(
  'Cells show exact agreement n/N (%) and linearly weighted κ. Differences are ARBITER − Unassisted exact agreement in percentage points (95% CI).',
  'D1–D5 uses all 510 cells. Overall uses the same 81 trials with an observed Published Overall for every source and expert-to-expert comparison; 21 missing published labels are excluded.',
  'Domain and derived Overall comparisons are evaluation outcomes without a formal endpoint hierarchy. Overall is derived from independent domain ratings. Full estimates, mean-of-experts, agreed-reference and binary comparisons are in the supplement.',CI_NOTE)
compact_expert_table <- function(independent,paired,reliability) {
  published <- read_display('table1')
  pubdiff <- read_display('table1-differences')
  rows <- list()
  for(dom in c('D1-D5','Overall')) {
    for(src in c('ARBITER','Unassisted','Published')) {
      values <- vapply(c('1','2','Published'),function(ref) {
        if(ref=='Published' && src=='Published') return('')
        if(ref=='Published') {
          x <- published |> filter(domain==dom,arm==paste0(src,' (Sonnet 5.5)'))
        } else x <- independent |> filter(adjudicator==ref,source==src,domain==dom,
          dom!='Overall' | population=='Observed Published Overall')
        a <- filter(x,metric=='accuracy'); k <- filter(x,metric=='kappa')
        paste0(a$count,'/',a$n,' (',fmt_number(100*a$estimate,1),'%)\nκ ',fmt_number(k$estimate))
      },character(1))
      rows[[length(rows)+1L]] <- tibble(Population=if(dom=='D1-D5') 'D1–D5' else 'Overall',Source=src,
        `Expert 1`=values[1],`Expert 2`=values[2],Published=values[3])
    }
    values <- vapply(c('1','2','Published'),function(ref) {
      d <- if(ref=='Published') filter(pubdiff,domain==dom,metric=='accuracy') else
        filter(paired,adjudicator==ref,domain==dom,metric=='accuracy',comparison=='ARBITER minus Unassisted',
          dom!='Overall' | population=='Observed Published Overall')
      paste0(fmt_number(100*d$estimate,1),' ',fmt_ci(100*d$lower,100*d$upper,1))
    },character(1))
    rows[[length(rows)+1L]] <- tibble(Population=if(dom=='D1-D5') 'D1–D5' else 'Overall',Source='ARBITER − Unassisted',
      `Expert 1`=values[1],`Expert 2`=values[2],Published=values[3])
  }
  # Matched Overall expert-to-expert reliability is computed with the existing resamples.
  r <- read_display('expert-reliability-matched')
  for(dom in c('D1-D5','Overall')) {
    x <- if(dom=='D1-D5') filter(reliability,domain==dom) else r
    a <- filter(x,metric=='accuracy'); k <- filter(x,metric=='kappa')
    rows[[length(rows)+1L]] <- tibble(Population=if(dom=='D1-D5') 'D1–D5' else dom,Source='Expert-to-expert',
      `Expert 1`=paste0(a$count,'/',a$n,' (',fmt_number(100*a$estimate,1),'%)\nκ ',fmt_number(k$estimate)),`Expert 2`='',Published='')
  }
  bind_rows(rows)
}
characteristics_table <- function(inputs) {
  sev <- read_display('severity-distribution')
  docs <- read_display('benchmark-documents')
  rel <- read_display('expert-reliability')
  rows <- read_display('benchmark-characteristics') |> transmute(Characteristic=characteristic,Value=as.character(count))
  rows <- bind_rows(rows,docs |> group_by(document_type) |> summarise(count=sum(available),n=n(),.groups='drop') |>
    transmute(Characteristic=paste('Trials with',recode(document_type,sap='SAP')),Value=fmt_fraction(count,n)))
  for(pop in c('D1-D5','Overall')) for(src in c('Published','ARBITER','Unassisted','Expert 1','Expert 2')) {
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
  independent <- read_display('independent-estimates'); paired <- read_display('independent-differences'); reliability <- read_display('expert-reliability')
  table2 <- primary_endpoint_table()
  read_display('table1');read_display('table1-differences');read_display('table3')
  tables <- list(benchmark_context_table(inputs),table2,process_integrity_table())
  titles <- c('Benchmark and reference context','Conditional blinded-label choices and sensitivities',
    'Process checks and computational resources')
  notes <- c('Reference categories are Low, Some concerns and High; each reference contributes 510 domain cells. Document counts are trials with each role recorded in the source inventory among 102 trials; roles can overlap. SAP, statistical analysis plan. Detailed distributions for all sources and derived Overall appear in the supplement.',
    paste('Conditional blinded-label choice evaluation includes 80 arm-discordant cells and the 60 for which the experts made an agreed choice; 20 choices split. Expert-specific sensitivities use all 80. The final row counts all 20 splits against ARBITER by assumption, without assigning Unassisted wins. Expert 1 chose neither arm in 4/80 cells; this is distinct from the split-loss assumption.',CI_NOTE),
    paste('Unassisted rule-break cells show No./total (%; 95% CI); CI bounds are percentages. Domain rules use evaluable ratings (ARBITER 510; Unassisted 509); one Unassisted cell is unevaluable. Evidence denominators count active answers or distinct evidence records as indicated; verifier denominator is 102 bundles. ARBITER has no recorded domain overrides; one Overall escalation is permitted. Evidence checks establish quotation occurrence and structural binding, without assessing answer support. Runtime and API list-price equivalents use 102 paired trials; source summaries are median (IQR), contrasts are paired mean differences. Cost is a frozen-rate equivalent, not expenditure. — means not applicable; Not available means not measured.',CI_NOTE))
  readr::write_csv(display_numbering(),'output/manuscript/qa/display-numbering.csv')
  for(i in 1:3) {
    x <- tables[[i]];readr::write_csv(x,paste0('output/tables/display-table',i,'.csv'),na='')
    doc <- manuscript_doc() |> manuscript_par(paste0('Table ',i,' ',titles[i]),style='heading 1')
    tab <- house_table(x,notes[i],6.85)
    writeLines(gt::as_raw_html(tab,inline_css=FALSE),paste0('output/manuscript/qa/Table',i,'.html'))
    doc <- add_gt(doc,tab)
    print(doc,target=paste0('output/manuscript/Table',i,'.docx'))
  }
}

build_displays <- function(inputs,cells,rebuild_figures=TRUE) {
  build_main_tables(inputs)
  if(rebuild_figures) build_manuscript_figures(cells)
  build_supplement(inputs)
  build_figure_legends()
  build_results_sentences()
  write_display_trace()
  build_manuscript_document()
}

build_manuscript_document <- function() {
  main <- readLines('../docs/manuscript/manuscript.md',encoding='UTF-8')
  main <- main[!grepl('^Word counts:',main)]
  text <- c(main,'',readLines('../docs/manuscript/references.md',encoding='UTF-8'))
  path <- 'output/manuscript/qa/manuscript-assembled.md'
  writeLines(enc2utf8(text),path,useBytes=TRUE)
  stopifnot(system2('quarto',c('pandoc',path,'--from=markdown','--to=docx','--output=output/manuscript/Manuscript.docx'))==0L)
  normalize_manuscript_styles('output/manuscript/Manuscript.docx')
  python <- Sys.getenv('ARBITER_PYTHON',unset=Sys.which('python'))
  if(!nzchar(python)) python <- Sys.which('python3')
  if(!nzchar(python)) stop('Install Python with python-docx and lxml, or set ARBITER_PYTHON to that interpreter.')
  stopifnot(system2(python,'../docs/manuscript/assemble-publication.py')==0L)
}

# Keep Pandoc's unnumbered headings and use explicit black in the Word styles.
normalize_manuscript_styles <- function(file) {
  target <- normalizePath(file,winslash='/',mustWork=TRUE)
  folder <- tempfile('manuscript-style-');dir.create(folder)
  on.exit(unlink(folder,recursive=TRUE),add=TRUE)
  utils::unzip(target,exdir=folder)
  path <- file.path(folder,'word/styles.xml')
  xml <- xml2::read_xml(path)
  styles <- xml2::xml_find_all(xml,"//w:style[starts-with(@w:styleId,'Heading') or @w:styleId='Title' or @w:styleId='Subtitle']")
  for(style in styles) {
    props <- xml2::xml_find_first(style,'w:rPr')
    if(inherits(props,'xml_missing')) props <- xml2::xml_add_child(style,'w:rPr')
    xml2::xml_remove(xml2::xml_find_all(props,'w:color'))
    xml2::xml_add_child(props,'w:color',`w:val`='000000')
  }
  xml2::write_xml(xml,path)
  zip::zipr(target,files=list.files(folder,all.files=TRUE,no..=TRUE),root=folder,include_directories=FALSE)
}
