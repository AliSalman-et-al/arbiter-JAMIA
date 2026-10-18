library(ggplot2)
ARM_COLORS <- c('ARBITER-Sonnet'='#007f86','Baseline-Sonnet'='#c76b13',
  'ARBITER-Haiku'='#007f86','Baseline-Haiku'='#c76b13')
read_table <- function(name) readr::read_csv(paste0('output/tables/',name,'.csv'),show_col_types=FALSE)
save_figure <- function(plot,name,width=9,height=6) {
  dir.create('output/figures',recursive=TRUE,showWarnings=FALSE)
  ggsave(paste0('output/figures/',name,'.pdf'),plot,width=width,height=height,device=grDevices::cairo_pdf)
  ggsave(paste0('output/figures/',name,'.png'),plot,width=width,height=height,dpi=600,bg='white')
}
combine_panels <- function(top,bottom) {
  grDevices::pdf(NULL); on.exit(grDevices::dev.off())
  grid::grobTree(
    grid::grobTree(ggplotGrob(top),vp=grid::viewport(y=.76,height=.48)),
    grid::grobTree(ggplotGrob(bottom),vp=grid::viewport(y=.26,height=.52)),
    grid::textGrob('A',x=.012,y=.985,just=c('left','top'),gp=grid::gpar(fontface='bold',fontsize=14)),
    grid::textGrob('B',x=.012,y=.505,just=c('left','top'),gp=grid::gpar(fontface='bold',fontsize=14)))
}

draft_architecture <- function(inputs,candidates) {
  cell <- slice_head(candidates,n=1)
  left <- c('Sources captured','Result proposed\nUser approves result',
    'Model answers each signalling\nquestion citing passages',
    'Server verifies each cited passage\nagainst captured sources',
    'Server applies RoB 2 algorithm:\nproposed judgement; any override\nrecorded with rationale',
    'Verifiable bundle exported')
  right <- c(paste0(cell$slug,' / ',cell$domain,'\nSource: ',cell$source,'; page ',cell$page),
    'Specified result proposed and approved unchanged',
    paste0('"',cell$passage,'"\nPage ',cell$page,'; ',cell$question,' = ',cell$answer),
    trace_binding_text(cell),
    paste0('Active domain answer set: ',cell$signalling_answers,
      '\nProposed judgement: ',cell$proposed),
    paste0('Meta label: ',cell$meta,'; consensus preferred: ',cell$preferred,
      '\nBundle retains answers, evidence, source locators,\ndecisions and verification record'))
  wrap_lines <- function(x) paste(vapply(strsplit(x,'\n',fixed=TRUE)[[1]],
    stringr::str_wrap,character(1),width=63),collapse='\n')
  nodes <- tibble(y=6:1,left=left,right=vapply(right,wrap_lines,character(1)))
  save_table(cell,'figure1-draft-selection')
  ggplot(nodes,aes(y=y))+
    geom_rect(aes(xmin=0,xmax=3.1,ymin=y-.40,ymax=y+.40),fill='#e3f2f2',color='#007f86')+
    geom_text(aes(x=1.55,label=left),size=3.7,lineheight=1.05)+
    geom_rect(aes(xmin=3.5,xmax=10.4,ymin=y-.42,ymax=y+.42),fill='#f5f6f8',color='#9ca4ae')+
    geom_text(aes(x=6.95,label=right),size=3.3,lineheight=1.02)+
    geom_segment(data=nodes[1:5,],aes(x=1.55,xend=1.55,y=y-.41,yend=y-.58),
      arrow=grid::arrow(length=grid::unit(.09,'inches')))+
    coord_cartesian(xlim=c(-.1,10.5),ylim=c(.5,6.5),clip='off')+theme_void()
}

build_figures <- function() {
  theme_set(theme_minimal(base_size=11)+theme(panel.grid.minor=element_blank(),
    legend.position='bottom',plot.margin=margin(10,16,10,10)))
  save_figure(draft_architecture(inputs,read_table('worked-trace-candidates')),'figure1',11,9)
  nodes <- tibble(x=c(0,0,3.5,0,0,0,-1.6,1.6,-1.6),y=c(8,7,6,5.5,4.3,3.1,1.9,1.9,.55),
    label=c('16 meta-analyses','105 benchmark trials',
      '3 excluded: unsupported design\natwine-2020\nhaney-2004\nherrmann-2016',
      '102 analysis-set trials','510 D1-D5 cells per arm\n81 meta Overall labels',
      '154 disputed cells','129 consensus cells',
      '25 split cells\n18 cells where Sonnet arms differ',
      '62 differing consensus cells:\n54 ARBITER; 7 Baseline; 1 neither'))
  edges <- tibble(x=c(0,0,0,0,0,0,0,-1.6),xend=c(0,0,2.1,0,0,-1.6,1.6,-1.6),
    y=c(7.7,6.7,6.3,5.16,3.95,2.78,2.78,1.5),yend=c(7.3,5.87,6.3,4.68,3.48,2.28,2.28,.94))
  p <- ggplot(nodes,aes(x,y))+geom_label(aes(label=label),size=3.6,
    label.padding=grid::unit(.45,'lines'),fill='#eef5f7')+
    geom_segment(data=edges,aes(x=x,xend=xend,y=y,yend=yend),
      arrow=grid::arrow(length=grid::unit(.09,'inches')))+
    coord_cartesian(xlim=c(-3.7,5.25),ylim=c(0,8.5),clip='off')+theme_void()
  save_figure(p,'figure2',10,8.5)
  primary <- read_table('primary-endpoint') |> filter(metric!='Neither') |>
    mutate(analysis=recode(analysis,A='Adjudicator A',Z='Adjudicator Z',
      `Split sensitivity`='Split cells counted as ARBITER losses'),
      analysis=factor(analysis,levels=rev(c('Consensus','Adjudicator A','Adjudicator Z',
        'Split cells counted as ARBITER losses'))),metric=factor(metric,levels=c('ARBITER','Baseline')))
  pA <- ggplot(primary,aes(estimate,analysis,color=metric))+
    geom_point(position=position_dodge(width=.5),size=2.5)+
    geom_errorbar(aes(xmin=lower,xmax=upper),position=position_dodge(width=.5),width=.15)+
    scale_x_continuous(limits=c(0,1),labels=scales::label_percent(accuracy=1))+
    scale_color_manual(values=c(ARBITER='#007f86',Baseline='#c76b13'))+
    labs(x='Share of cells where the Sonnet arms differ (95% CI)',y=NULL,color=NULL)
  categories <- c("ARBITER's label preferred (and not the baseline's)",
    "Baseline's label preferred (and not ARBITER's)","Both arms' label preferred",
    'Meta label only preferred','Adjudicators split')
  departure_order <- c('ARBITER only departed from meta','Baseline only departed from meta',
    'Both departed, different labels','Both departed, same label')
  counts <- cells |> mutate(departure=case_when(kit!=meta & nokit==meta~departure_order[1],
    kit==meta & nokit!=meta~departure_order[2],kit!=nokit~departure_order[3],TRUE~departure_order[4]),
    outcome=case_when(!consensus~categories[5],preferred==kit & preferred==nokit~categories[3],
      preferred==kit~categories[1],preferred==nokit~categories[2],TRUE~categories[4])) |>
    count(departure,outcome) |> complete(departure=departure_order,outcome=categories,fill=list(n=0)) |>
    mutate(departure=factor(departure,levels=rev(departure_order)),outcome=factor(outcome,levels=categories))
  save_table(counts,'figure3-panelB')
  colors <- setNames(c('#007f86','#c76b13','#6c8d68','#d7ad32','#dedede'),categories)
  pB <- ggplot(counts,aes(outcome,departure))+
    geom_tile(aes(fill=if_else(n>0,as.character(outcome),NA_character_)),color='white',linewidth=1)+
    geom_text(aes(label=n,color=n==0),size=4)+
    scale_color_manual(values=c('FALSE'='black','TRUE'='grey55'),guide='none')+
    scale_fill_manual(values=colors,na.value='#fafafa',guide='none')+
    scale_x_discrete(labels=c('ARBITER only\npreferred','Baseline only\npreferred',
      'Both arms\npreferred','Meta only\npreferred','Adjudicators\nsplit'))+
    labs(x=NULL,y=NULL)+theme(panel.grid=element_blank(),axis.text.x=element_text(size=10))
  save_figure(combine_panels(pA,pB),'figure3',12,9)
  comparison <- bind_rows(read_table('agreement-meta'),read_table('agreement-composite')) |>
    filter(domain %in% paste0('D',1:5),metric=='kappa',grepl('Sonnet',arm)) |>
    mutate(reference=factor(reference,levels=c('Meta','Composite'),labels=c('vs meta label','vs composite reference')),
      arm=factor(arm,levels=names(ARM_COLORS)[1:2]))
  p <- ggplot(comparison,aes(domain,estimate,color=arm,shape=arm))+
    geom_hline(yintercept=0,linetype='dashed',color='grey45')+
    geom_point(position=position_dodge(width=.45),size=2.8)+
    geom_errorbar(aes(ymin=lower,ymax=upper),position=position_dodge(width=.45),width=.12)+
    facet_wrap(~reference)+scale_color_manual(values=ARM_COLORS)+scale_shape_manual(values=c(16,17))+
    labs(y='Linearly weighted kappa',x=NULL,color=NULL,shape=NULL)
  save_figure(p,'figure4',10,5)
  forest <- read_table('forest-meta') |> mutate(arm=factor(arm,levels=names(ARM_COLORS)))
  p <- ggplot(filter(forest,is.finite(estimate)),aes(estimate,meta_id,color=arm,shape=arm))+
    geom_vline(xintercept=0,color='grey70')+
    geom_point(position=position_dodge(width=.65),size=1.8)+
    geom_errorbar(aes(xmin=lower,xmax=upper),width=.2,position=position_dodge(width=.65))+
    scale_color_manual(values=ARM_COLORS)+scale_shape_manual(values=c(16,17,1,2))+
    labs(x='Weighted kappa against meta labels',y=NULL,color=NULL,shape=NULL)
  save_figure(p,'supplement-forest',10,10)
  frequency <- read_table('error-localisation-frequency') |> filter(population=='Primary')
  shown <- frequency |> group_by(question) |> summarise(n=sum(n),.groups='drop') |>
    filter(n>0) |> arrange(n,question)
  frequency <- frequency |> filter(question %in% shown$question) |>
    mutate(question_label=paste(question,short_text),
      question_label=factor(question_label,levels=paste(shown$question,
        frequency$short_text[match(shown$question,frequency$question)])),
      source=factor(source,levels=c('ARBITER-Sonnet','Baseline-Sonnet')))
  p <- ggplot(frequency,aes(n,question_label,fill=source))+
    geom_col(width=.65)+geom_text(aes(label=n),hjust=-.3,size=3.2)+
    facet_wrap(~source,nrow=1)+scale_fill_manual(values=ARM_COLORS)+
    scale_x_continuous(breaks=c(0,5,10,15,20),limits=c(0,20),expand=expansion(mult=c(0,.02)))+
    labs(x='Decisive-question count (primary population)',y=NULL)+
    theme(legend.position='none',axis.text.y=element_text(size=9))
  save_figure(p,'supplement-decisive-questions',10,5.5)
}
