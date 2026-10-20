CI_NOTE <- '95% percentile intervals; 10,000 trial-cluster bootstrap replicates stratified by meta-analysis; seed 20261018.'
DISPLAY_TRACE <- list()
read_display <- function(name) {
  x <- readr::read_csv(paste0('output/tables/',name,'.csv'),show_col_types=FALSE)
  DISPLAY_TRACE[[length(DISPLAY_TRACE)+1L]] <<- tibble(file=name,
    row=rep(seq_len(nrow(x)),times=ncol(x)),column=rep(names(x),each=nrow(x)),
    value=unlist(lapply(x,as.character),use.names=FALSE))
  x
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
    mutate(Reference=if_else(Reference %in% c('1','2'),paste('Adjudicator',Reference),Reference))
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
table2_note <- function() paste(
  'Each source cell reports exact agreement n/N (%) and linearly weighted κ. Differences are ARBITER − Unassisted exact agreement in percentage points (95% CI).',
  'Overall uses the same 81 trials with observed Published Overall for every source; 21 published labels are missing and excluded. Agreed-reference Overall retains 42 of these trials.',
  'Mean of experts is the arithmetic mean of the two expert-specific estimates, not pooled independent observations; only percentages and κ are displayed for this row. Its difference is the mean of the two expert-specific paired differences; the CI is the percentile interval of their mean within each shared bootstrap replicate.',
  'The agreed reference retains cells with equal independent expert ratings (388 domain cells; 42 matched Overall trials). The expert-to-expert foot row compares the two independent ratings.',
  'Full estimates, all-trial Overall (102 trials; agreed reference 52) and all paired contrasts appear in eTable 2.',CI_NOTE)
compact_expert_table <- function(independent,paired,reliability) {
  rows <- list()
  for(ref in c('1','2','Mean of experts','Agreed reference')) for(dom in c('D1-D5','Overall')) {
    x <- independent |> filter(adjudicator==ref,domain==dom,
      dom!='Overall' | population=='Observed Published Overall')
    values <- vapply(c('ARBITER','Unassisted','Published'),function(src) {
      a <- filter(x,source==src,metric=='accuracy'); k <- filter(x,source==src,metric=='kappa')
      count <- if(is.na(a$count)) a$estimate*a$n else a$count
      paste0(if(ref=='Mean of experts') paste0(fmt_number(100*a$estimate,1),'%') else
        paste0(format(round(count,1),trim=TRUE),'/',a$n,' (',fmt_number(100*a$estimate,1),'%)'),
        '\nκ ',fmt_number(k$estimate))
    },character(1))
    d <- paired |> filter(adjudicator==ref,domain==dom,metric=='accuracy',comparison=='ARBITER minus Unassisted',
      dom!='Overall' | population=='Observed Published Overall')
    rows[[length(rows)+1L]] <- tibble(Reference=if(ref %in% c('1','2')) paste('Adjudicator',ref) else ref,
      Domain=if(dom=='D1-D5') 'D1–D5' else dom,ARBITER=values[1],Unassisted=values[2],Published=values[3],
      `ARBITER − Unassisted`=paste0(fmt_number(100*d$estimate,1),' ',fmt_ci(100*d$lower,100*d$upper,1)))
  }
  a <- filter(reliability,domain=='D1-D5',metric=='accuracy'); k <- filter(reliability,domain=='D1-D5',metric=='kappa')
  bind_rows(bind_rows(rows),tibble(Reference='Expert-to-expert',Domain='D1–D5',
    ARBITER=paste0(a$count,'/',a$n,' (',fmt_number(100*a$estimate,1),'%)\nκ ',fmt_number(k$estimate)),
    Unassisted='',Published='',`ARBITER − Unassisted`=''))
}
build_displays <- function(inputs,cells) {
  dir.create('output/manuscript',recursive=TRUE,showWarnings=FALSE)
  independent <- read_display('independent-estimates'); paired <- read_display('independent-differences'); reliability <- read_display('expert-reliability')
  table2 <- compact_expert_table(independent,paired,reliability)
  read_display('table1');read_display('table1-differences');read_display('table3')
  table4 <- prior_work_table()
  table4$`Independent reference or adjudication`[grepl('This study',table4$Study)] <- 'Blinded dual expert rating of all domains'
  tables <- list(main_table2(),table2,main_table3(),table4)
  titles <- c('Models agreed poorly with published review labels','Independent experts agreed more often with ARBITER',
    'Unassisted domain ratings sometimes broke the RoB 2 rules','ARBITER combines rule enforcement and an independent expert reference')
  notes <- c(paste('Published review labels are the reference. Exact agreement, sensitivity for Some concerns or High and specificity are percentages. Paired differences are percentage points or coefficients. All-Low predicts Low throughout. Undefined values are shown as —.',CI_NOTE),
    table2_note(),
    paste('A rule break is a rating contradicting its own answers or a required question skipped. ARBITER has no recorded domain overrides. One ARBITER Overall escalation is permitted. Evidence checks establish quotation occurrence and structural binding, without assessing whether quotations support an answer.',CI_NOTE),
    prior_work_note())
  for(i in 1:4) {
    x <- tables[[i]];readr::write_csv(x,paste0('output/tables/display-table',i,'.csv'),na='')
    doc <- manuscript_doc() |> manuscript_par(paste0('Table ',i,' ',titles[i]),style='heading 1')
    if(i==4) doc <- officer::body_set_default_section(doc,officer::prop_section(page_size=officer::page_size(orient='landscape'),page_margins=officer::page_mar(top=.6,bottom=.6,left=.65,right=.65)))
    ft <- house_table(x,notes[i],if(i==4) 10.3 else 6.85)
    if(i<4) ft <- style_group_rows(ft,x)
    if(i==2) ft <- flextable::width(ft,j=1:6,width=c(1.05,.55,1.25,1.25,1.25,1.5)) |> flextable::merge_at(i=9,j=3:5,part='body')
    doc <- flextable::body_add_flextable(doc,ft)
    print(doc,target=paste0('output/manuscript/Table',i,'.docx'))
  }
  build_manuscript_figures(cells)
  build_supplement(inputs)
  build_figure_legends()
  build_results_sentences()
  readr::write_csv(bind_rows(DISPLAY_TRACE),'output/tables/display-source-trace.csv',na='')
}

signalling_disagreement_sentence <- function() {
  x <- read_display('signalling-disagreement-types')
  parts <- vapply(c('1','2'),function(a) {
    d <- filter(x,adjudicator==a)
    arms <- vapply(c('ARBITER','Unassisted'),function(src) {
      row <- filter(d,source==src)
      sprintf('%s %s/%s, %s%%',src,row$within_direction,row$five_level_disagreements,
        fmt_number(100*row$within_direction/row$five_level_disagreements,1))
    },character(1))
    paste0(if(a=='1') 'about half' else 'about three-quarters',
      ' of five-level disagreements against Adjudicator ',a,' (',paste(arms,collapse='; '),')')
  },character(1))
  paste0('Within-direction choices (Y↔PY or N↔PN) accounted for ',paste(parts,collapse=' and '),
    ' (eTable 5); cross-direction counts include NI versus either direction.')
}
