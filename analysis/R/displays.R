CI_NOTE <- '95% percentile intervals; 10,000 trial-cluster bootstrap replicates stratified by meta-analysis; seed 20261018.'
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
    'Twenty-one (21) published reviews gave no Overall label; these missing labels are excluded, never counted as disagreements. Agreed-reference Overall uses n = 52 among all trials and n = 42 among the observed-label subset, restricting each population to equal expert ratings. Expert-to-expert Overall: n = 102. Exact agreement is a percentage; paired differences are percentage points or coefficients.')
}
expert_display <- function(x,pooled=FALSE) {
  if(pooled) x <- filter(x,domain %in% c('D1-D5','Overall'))
  if('population' %in% names(x)) x <- x |> mutate(domain=if_else(domain=='Overall',
    if_else(population=='Observed Published Overall','Overall (observed)','Overall (all)'),domain))
  x |> mutate(value=if_else(metric=='accuracy',paste0(if_else(!is.na(count),paste0(count,'/',n,' ('),''),fmt_number(100*estimate,1),'%',if_else(!is.na(count),') ', ' '),fmt_ci(100*lower,100*upper,1)),paste0(fmt_number(estimate),' ',fmt_ci(lower,upper)))) |>
    select(adjudicator,domain,source,n,metric,value) |> pivot_wider(names_from=metric,values_from=value) |>
    rename(Reference=adjudicator,Domain=domain,Source=source,N=n,`Exact agreement (95% CI)`=accuracy,`Weighted κ (95% CI)`=kappa) |>
    mutate(Reference=if_else(Reference %in% c('1','2'),paste('Expert',Reference),Reference))
}
estimate_display <- function(x) {
  ids <- intersect(c('adjudicator','arm','source','comparison','population','domain','group','level','analysis','metric','direction','outcome'),names(x))
  x$value <- vapply(seq_len(nrow(x)),function(i) {
    if(!is.finite(x$estimate[i])) return('—')
    prop <- !('metric' %in% names(x)) || !x$metric[i] %in% c('kappa','AC2')
    mult <- if(prop) 100 else 1
    paste0(fmt_number(x$estimate[i]*mult,if(prop) 1 else 2),if(prop) '%' else '', ' ',fmt_ci(x$lower[i]*mult,x$upper[i]*mult,if(prop) 1 else 2))
  },character(1))
  x |> select(all_of(ids),any_of(c('count','n')),value)
}
binary_difference_display <- function(x) {
  estimate_display(x) |> mutate(value=gsub('%',' pp',value,fixed=TRUE))
}
table2_note <- function() paste(
  'Cells show exact agreement n/N (%) and linearly weighted κ. Differences are ARBITER − Unassisted exact agreement in percentage points (95% CI).',
  'D1–D5 uses all 510 cells. Overall uses the same 81 trials with an observed Published Overall for every source and expert-to-expert comparison; 21 missing published labels are excluded.',
  'Independent domain comparisons are prespecified; expert-derived Overall comparisons are exploratory. Full estimates, mean-of-experts and agreed-reference analyses are in the supplement. Binary sensitivity and specificity are exploratory and reported separately.',CI_NOTE)
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
process_integrity_table <- function() {
  x <- main_table3() |> select(Measure,ARBITER,Unassisted)
  p <- read_display('table5')[1:2,] |> mutate(across(where(is.character),fmt_process_text))
  for(j in 2:4) p[[j]] <- sub(' ', '\n',p[[j]],fixed=TRUE)
  names(p) <- c('Measure','ARBITER','Unassisted','Paired mean difference (95% CI)')
  bind_rows(x,p) |> mutate(across(everything(),~replace_na(.x,'')))
}
build_displays <- function(inputs,cells) {
  dir.create('output/manuscript/qa',recursive=TRUE,showWarnings=FALSE)
  independent <- read_display('independent-estimates'); paired <- read_display('independent-differences'); reliability <- read_display('expert-reliability')
  table2 <- compact_expert_table(independent,paired,reliability)
  read_display('table1');read_display('table1-differences');read_display('table3')
  table4 <- prior_work_table()
  table4$`Independent reference or adjudication`[grepl('This study',table4$Study)] <- 'Blinded dual expert rating of all domains'
  tables <- list(characteristics_table(inputs),table2,process_integrity_table(),table4)
  titles <- c('Benchmark and reference characteristics','Agreement with each reference',
    'Rule conformance, evidence checks, time and cost','ARBITER combines rule enforcement and an independent expert reference')
  notes <- c('Severity categories are Low, Some concerns and High. D1–D5: 510 cells per source; Overall: 81 trials for Published and 102 for other sources. Document counts are trials with each role recorded in the ARBITER source inventory, among 102 included trials; roles can overlap. SAP, statistical analysis plan. Expert-to-expert D3 is the lowest domain; pooled reliability covers D1–D5.',
    table2_note(),
    paste('Domain rules use evaluable ratings (ARBITER 510; Unassisted 509); Overall uses 102 trials. Evidence denominators count active answers or distinct evidence records as indicated; verifier denominator is 102 bundles. ARBITER has no recorded domain overrides; one Overall escalation is permitted. Evidence checks establish quotation occurrence and structural binding, without assessing answer support. Runtime and API list-price equivalents use 102 paired trials; source summaries are median [IQR], contrasts are paired mean differences. Cost is a frozen-rate equivalent, not expenditure.',CI_NOTE),
    prior_work_note())
  readr::write_csv(display_numbering(),'output/manuscript/qa/round16-display-numbering.csv')
  for(i in 1:4) {
    x <- tables[[i]];readr::write_csv(x,paste0('output/tables/display-table',i,'.csv'),na='')
    doc <- manuscript_doc() |> manuscript_par(paste0('Table ',i,' ',titles[i]),style='heading 1')
    if(i==4) doc <- officer::body_set_default_section(doc,officer::prop_section(page_size=officer::page_size(orient='landscape'),page_margins=officer::page_mar(top=.6,bottom=.6,left=.65,right=.65)))
    ft <- house_table(x,notes[i],if(i==4) 10.3 else 6.85)
    if(i<4) ft <- style_group_rows(ft,x)
    if(i==1) ft <- flextable::width(ft,j=1:2,width=c(1.7,5.15))
    if(i==2) ft <- flextable::width(ft,j=1:5,width=c(.8,1.25,1.6,1.6,1.6))
    doc <- flextable::body_add_flextable(doc,ft)
    print(doc,target=paste0('output/manuscript/Table',i,'.docx'))
  }
  build_manuscript_figures(cells)
  build_supplement(inputs)
  build_figure_legends()
  build_results_sentences()
  write_display_trace()
}
