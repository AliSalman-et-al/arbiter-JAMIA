library(ggplot2)
read_table <- function(name) readr::read_csv(paste0('output/tables/',name,'.csv'),show_col_types=FALSE)
save_figure <- function(plot,name,width=9,height=6) {
  dir.create('output/figures',recursive=TRUE,showWarnings=FALSE)
  ggsave(paste0('output/figures/',name,'.pdf'),plot,width=width,height=height,device=grDevices::cairo_pdf)
  ggsave(paste0('output/figures/',name,'.png'),plot,width=width,height=height,dpi=600,bg='white')
}

draft_architecture <- function(inputs,candidates) {
  selected <- inputs$signals |> filter(arm=='ARBITER-Sonnet',active) |>
    semi_join(candidates,by=c('slug','domain')) |> filter(has_quotation(justification)) |>
    arrange(slug,domain,question) |> slice_head(n=1)
  if(!nrow(selected)) stop('No quoted candidate for worked trace')
  cell <- candidates |> filter(slug==selected$slug,domain==selected$domain)
  quotes <- regmatches(selected$justification,
    gregexpr('"[^"\r\n]+"|\u201c[^\u201d\r\n]+\u201d',selected$justification,perl=TRUE))[[1]]
  quote <- quotes[which(vapply(quotes,function(s) length(strsplit(trimws(substring(s,2,nchar(s)-1)),
    '\\s+')[[1]])>=5,logical(1)))[1]]
  trace <- c(paste0(selected$slug,' / ',selected$domain,'\n',quote),
    paste0('Signalling answer ',selected$question,' = ',selected$answer),
    cell$signalling_answers,
    paste0('Official domain algorithm → ',cell$kit,'\nMeta label: ',cell$meta,
      '; consensus preferred judgement: ',cell$preferred),
    'Verifiable bundle: answers, quoted justifications, domain judgement and source locators')
  nodes <- tibble(y=5:1,
    architecture=c('Trial reports and specified outcome','LLM + arbiter-assess skill',
      'ARBITER MCP: structured signalling questions','Deterministic RoB 2 domain algorithm','Auditable assessment bundle'),
    trace=vapply(trace,stringr::str_wrap,character(1),width=67))
  p <- ggplot(nodes,aes(y=y)) +
    geom_rect(aes(xmin=0,xmax=3,ymin=y-.38,ymax=y+.38),fill='#e5f2f5',color='#347080') +
    geom_text(aes(x=1.5,label=stringr::str_wrap(architecture,28)),size=3.7) +
    geom_rect(aes(xmin=3.4,xmax=10,ymin=y-.42,ymax=y+.42),fill='#f5f6f8',color='#9ca4ae') +
    geom_text(aes(x=6.7,label=trace),size=3.2,lineheight=.95) +
    geom_segment(data=nodes[1:4,],aes(x=1.5,xend=1.5,y=y-.4,yend=y-.59),
      arrow=grid::arrow(length=grid::unit(.12,'inches'))) +
    geom_segment(data=nodes[1:4,],aes(x=6.7,xend=6.7,y=y-.44,yend=y-.57),
      arrow=grid::arrow(length=grid::unit(.12,'inches'))) +
    coord_cartesian(xlim=c(-.1,10.1),ylim=c(.5,5.5),clip='off') + theme_void() +
    labs(title='Figure 1. ARBITER architecture and draft worked trace',
      subtitle='Draft selection for author review; five candidate cells are exported with full justifications')
  save_table(tibble(slug=selected$slug,domain=selected$domain,question=selected$question,
    answer=selected$answer,quotation=quote),'figure1-draft-selection')
  p
}

build_figures <- function() {
  theme_set(theme_minimal(base_size=11)+theme(panel.grid.minor=element_blank(),
    plot.title=element_text(face='bold'),legend.position='bottom'))
  candidates <- read_table('worked-trace-candidates')
  save_figure(draft_architecture(inputs,candidates),'figure1',11,8.5)
  nodes <- tibble(y=7:1,label=c('16 meta-analyses\n105 benchmark trials',
    '3 excluded: unsupported designs\natwine-2020; haney-2004; herrmann-2016',
    '102 analysis-set trials','510 D1–D5 cells per arm\n81 trials with meta Overall labels',
    '154 disputed D1–D5 cells','129 consensus cells\n62 discordant between Sonnet arms',
    '25 split cells\n18 discordant between Sonnet arms'))
  # Branch consensus and split from the disputed-cell node.
  nodes$x <- c(0,0,0,0,0,-1.5,1.5); nodes$y <- c(7,6,5,4,3,1.5,1.5)
  edges <- tibble(x=c(0,0,0,0,0,0),xend=c(0,0,0,0,-1.5,1.5),
    y=c(6.65,5.65,4.65,3.65,2.65,2.65),yend=c(6.35,5.35,4.35,3.35,1.9,1.9))
  p <- ggplot(nodes,aes(x,y))+geom_label(aes(label=label),size=3.8,label.padding=grid::unit(.35,'lines'),
    fill='#eef5f7')+geom_segment(data=edges,aes(x=x,xend=xend,y=y,yend=yend),
      arrow=grid::arrow(length=grid::unit(.1,'inches')))+
    coord_cartesian(xlim=c(-3.3,3.3),ylim=c(.9,7.5))+theme_void()+labs(title='Figure 2. Benchmark and adjudication flow')
  save_figure(p,'figure2',9,7)
  primary <- read_table('primary-endpoint')
  primary$analysis <- factor(primary$analysis,levels=c('Split sensitivity','Z','A','Consensus'))
  pA <- ggplot(primary,aes(estimate,analysis,color=metric))+geom_point(position=position_dodge(width=.5),size=2.5)+
    geom_errorbar(aes(xmin=lower,xmax=upper),position=position_dodge(width=.5),width=.15)+
    scale_x_continuous(limits=c(0,1),labels=scales::label_percent())+
    scale_color_manual(values=c(ARBITER='#007f86',Baseline='#c76b13',Neither='#777777'))+
    labs(title='A. Win shares on discordant cells',x='Share with 95% bootstrap CI',y=NULL,color=NULL)
  c <- cells |> mutate(departure=case_when(kit!=meta & nokit==meta~'ARBITER only',
    kit==meta & nokit!=meta~'Baseline only',kit==nokit~'Both: same label',TRUE~'Both: different labels'),
    preference=if_else(!consensus,'Split',vapply(seq_len(nrow(cells)),function(i) {
      if(!cells$consensus[i]) return('Split')
      paste(c('ARBITER','Baseline','Meta')[c(cells$kit[i],cells$nokit[i],cells$meta[i])==cells$preferred[i]],collapse=' + ')
    },character(1)))) |> count(departure,preference)
  save_table(c,'figure3-panelB')
  pB <- ggplot(c,aes(departure,n,fill=preference))+geom_col()+
    geom_text(aes(label=n),position=position_stack(vjust=.5),size=3)+
    scale_fill_brewer(palette='Set2')+coord_flip()+labs(title='B. All disputed cells, by preferred label',
      x=NULL,y='Cells',fill=NULL)
  # Compose panels with base grid, without an additional package dependency.
  combined <- grid::grobTree(
    grid::grobTree(ggplotGrob(pA),vp=grid::viewport(y=.75,height=.5)),
    grid::grobTree(ggplotGrob(pB),vp=grid::viewport(y=.25,height=.5)))
  save_figure(combined,'figure3',10,9)
  comparison <- bind_rows(read_table('agreement-meta'),read_table('agreement-composite')) |>
    filter(domain %in% paste0('D',1:5)) |>
    filter((arm!='All-Low' & metric=='kappa' & grepl('Sonnet',arm)) | (arm=='All-Low' & metric=='accuracy')) |>
    mutate(series=if_else(arm=='All-Low','All-Low accuracy',arm))
  p <- ggplot(comparison,aes(domain,estimate,color=series,shape=series))+
    geom_point(position=position_dodge(width=.45),size=2.8)+
    geom_errorbar(aes(ymin=lower,ymax=upper),position=position_dodge(width=.45),width=.12)+
    facet_wrap(~reference)+scale_color_manual(values=c('ARBITER-Sonnet'='#007f86',
      'Baseline-Sonnet'='#c76b13','All-Low accuracy'='#777777'))+
    scale_shape_manual(values=c('ARBITER-Sonnet'=16,'Baseline-Sonnet'=17,'All-Low accuracy'=4))+
    labs(title='Figure 4. Domain agreement by reference',y='Weighted kappa; All-Low exact accuracy (×)',x=NULL,
      color=NULL,shape=NULL,caption='Bars: 95% stratified trial-cluster bootstrap intervals. Composite excludes split cells.')
  save_figure(p,'figure4',10,5)
  forest <- read_table('forest-meta')
  p <- ggplot(forest,aes(estimate,meta_id,color=arm))+geom_vline(xintercept=0,color='grey70')+
    geom_point(position=position_dodge(width=.65),size=1.8)+
    geom_errorbar(aes(xmin=lower,xmax=upper),width=.2,position=position_dodge(width=.65))+
    labs(title='Supplement. Agreement by meta-analysis',x='Weighted kappa against meta labels',y=NULL,color=NULL,
      caption='Descriptive estimates and bootstrap intervals; undefined coefficients are omitted. No tests.')
  save_figure(p,'supplement-forest',10,10)
}
