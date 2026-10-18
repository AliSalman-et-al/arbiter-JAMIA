export_manuscript_figure <- function(plot,name,height_mm,width_mm=174) {
  dir.create('output/manuscript/qa',recursive=TRUE,showWarnings=FALSE)
  args <- list(plot=plot,width=width_mm,height=height_mm,units='mm',bg='white',limitsize=FALSE)
  do.call(ggplot2::ggsave,c(list(filename=paste0('output/manuscript/',name,'.pdf'),
    device=grDevices::cairo_pdf),args))
  do.call(ggplot2::ggsave,c(list(filename=paste0('output/manuscript/',name,'.tiff'),
    device=ragg::agg_tiff,dpi=600,compression='lzw'),args))
  do.call(ggplot2::ggsave,c(list(filename=paste0('output/manuscript/',name,'.png'),
    device=ragg::agg_png,dpi=160),args))
  invisible(plot)
}
study_flow_plot <- function() {
  nodes <- tibble(x=c(0,0,3.15,0,0,0,-1.7,1.7,-1.7),y=c(9,7.6,8.3,6.1,4.7,3.5,2.3,2.3,.8),
    label=c('16 meta-analyses; 105 benchmark trials','102 analysis-set trials',
      '3 excluded: unsupported design\nAtwine 2020; Haney 2004;\nHerrmann 2016',
      '4 arms each assessed 102 trials:\nARBITER and Unassisted with Sonnet 5.5 (main analysis);\nwith Haiku 5.5 (supplement)',
      '510 D1–D5 cells per arm\n81 Published Overall labels','154 disputed cells',
      '129 consensus cells','25 split cells\n18 cells where arms differ',
      '62 differing consensus cells\n54 ARBITER; 7 Unassisted; 1 neither'))
  edges <- tibble(x=c(0,0,0,0,0,0,-1.7),xend=c(0,0,0,0,-1.7,1.7,-1.7),
    y=c(8.7,7.3,5.6,4.3,3.2,3.2,1.95),yend=c(7.9,6.65,5.1,3.8,2.7,2.7,1.2))
  ggplot2::ggplot(nodes,ggplot2::aes(x,y))+
    ggplot2::geom_segment(data=edges,ggplot2::aes(x=x,xend=xend,y=y,yend=yend),
      arrow=grid::arrow(length=grid::unit(1.5,'mm')),linewidth=.55)+
    ggplot2::annotate('segment',x=0,xend=1.9,y=8.3,yend=8.3,linewidth=.55,
      arrow=grid::arrow(length=grid::unit(1.5,'mm')))+
    ggplot2::geom_label(ggplot2::aes(label=label),family='Fira Sans Condensed',size=3.05,
      label.padding=grid::unit(.6,'lines'),fill='#F3F6F7',linewidth=.55,lineheight=1.1)+
    ggplot2::coord_cartesian(xlim=c(-3.2,4.6),ylim=c(.2,9.4),clip='off')+
    ggplot2::theme_void(base_family='Fira Sans Condensed')+
    ggplot2::theme(plot.margin=ggplot2::margin(2,2,2,2))
}
disagreement_matrix_plot <- function(cells) {
  departures <- c('ARBITER only\ndisagreed with Published','Unassisted only\ndisagreed with Published',
    'Both disagreed,\ndifferent labels','Both disagreed,\nsame label')
  categories <- c('ARBITER only\npreferred','Unassisted only\npreferred','Both arms\npreferred',
    'Published only\npreferred','Adjudicators\nsplit')
  counts <- cells |> mutate(departure=case_when(kit!=meta & nokit==meta~departures[1],
    kit==meta & nokit!=meta~departures[2],kit!=nokit~departures[3],TRUE~departures[4]),
    outcome=case_when(!consensus~categories[5],preferred==kit & preferred==nokit~categories[3],
      preferred==kit~categories[1],preferred==nokit~categories[2],TRUE~categories[4])) |>
    count(departure,outcome) |> complete(departure=departures,outcome=categories,fill=list(n=0)) |>
    mutate(departure=factor(departure,levels=rev(departures)),outcome=factor(outcome,levels=categories))
  colors <- setNames(c(JAMA_ROLES[c('ARBITER','Unassisted')],'#79AF97',JAMA_ROLES[c('Published','Split')]),categories)
  pB <- ggplot2::ggplot(counts,ggplot2::aes(outcome,departure))+
    ggplot2::geom_tile(ggplot2::aes(fill=if_else(n>0,as.character(outcome),NA_character_)),color='white',linewidth=.7)+
    ggplot2::geom_text(ggplot2::aes(label=n,color=n>0 & outcome==categories[4]),size=3,family='Fira Sans')+
    ggplot2::scale_color_manual(values=c('TRUE'='white','FALSE'='black'),guide='none')+
    ggplot2::scale_fill_manual(values=colors,na.value='#FAFAFA',guide='none')+
    ggplot2::labs(x=NULL,y=NULL)+theme_manuscript()+
    ggplot2::theme(panel.grid=ggplot2::element_blank(),axis.text.x=ggplot2::element_text(size=7.5))
  pB
}

published_reference_plot <- function() {
  x <- manuscript_data('agreement-meta') |> filter(arm %in% c('ARBITER-Sonnet','Baseline-Sonnet'),
    domain!='Overall',metric=='kappa') |> mutate(arm=reader_label(arm),
      domain=factor(domain,levels=c(paste0('D',1:5),'D1-D5'),labels=c(paste0('D',1:5),'Pooled\nD1\u2013D5')))
  pA <- ggplot2::ggplot(x,ggplot2::aes(domain,estimate,color=arm,shape=arm))+
    ggplot2::geom_hline(yintercept=0,linetype='dashed',color='grey70')+
    ggplot2::geom_errorbar(ggplot2::aes(ymin=lower,ymax=upper),position=ggplot2::position_dodge(width=.45),width=.13)+
    ggplot2::geom_point(position=ggplot2::position_dodge(width=.45),size=2)+
    ggplot2::scale_color_manual(values=JAMA_ROLES)+ggplot2::scale_shape_manual(values=c(16,17))+
    ggplot2::labs(x=NULL,y='Weighted \u03ba vs Published (95% CI)',color=NULL,shape=NULL)+theme_manuscript()
  direction <- manuscript_data('published-direction-domain') |> mutate(
    domain=factor(domain,levels=rev(c(paste0('D',1:5),'All'))),
    direction=factor(direction,levels=c('Less severe','Equal','More severe')))
  pB <- ggplot2::ggplot(direction,ggplot2::aes(n/total,domain,fill=direction))+
    ggplot2::geom_col(position=ggplot2::position_stack(reverse=TRUE),width=.65)+
    ggplot2::geom_text(ggplot2::aes(label=if_else(n>0,as.character(n),''),color=direction=='More severe'),
      position=ggplot2::position_stack(vjust=.5,reverse=TRUE),size=2.8,family='Fira Sans',show.legend=FALSE)+
    ggplot2::scale_color_manual(values=c('TRUE'='white','FALSE'='black'),guide='none')+
    ggplot2::scale_fill_manual(values=c('Less severe'='#DCE1E3','Equal'='#94A1A6','More severe'='#374E55'))+
    ggplot2::scale_x_continuous(breaks=seq(0,1,.25),labels=scales::label_percent())+
    ggplot2::labs(x="Published relative to consensus preferred judgement",y=NULL,fill=NULL)+theme_manuscript()
  patchwork::wrap_plots(pA,pB,ncol=1,heights=c(1.15,1))+
    patchwork::plot_annotation(tag_levels='A')
}
decisive_question_plot <- function() {
  x <- manuscript_data('error-localisation-frequency') |> filter(population=='Primary') |> mutate(question=as.character(question))
  shown <- x |> group_by(question) |> summarise(n=sum(n),.groups='drop') |> filter(n>0)
  remainder <- manuscript_data('no-decisive-counts')
  losses <- remainder |> select(domain,source,eligible) |> pivot_wider(names_from=source,values_from=eligible) |>
    mutate(facet=paste0(domain,' losses: ARBITER n = ',`ARBITER-Sonnet`,'; Unassisted n = ',`Baseline-Sonnet`))
  remainder <- remainder |> transmute(domain,source,n,question='remainder',short_text='No single decisive question')
  x <- bind_rows(x |> filter(question %in% shown$question),remainder) |>
    left_join(losses |> select(domain,facet),by='domain') |>
    mutate(source=factor(reader_label(source),levels=c('ARBITER','Unassisted')),
      label=stringr::str_wrap(if_else(question=='remainder',short_text,paste(question,short_text)),width=50),
      bar_fill=if_else(question=='remainder',paste0(source,' remainder'),as.character(source)),
      label=factor(label,levels=rev(unique(label[order(question)]))))
  dodge <- ggplot2::position_dodge(width=.7,reverse=TRUE)
  ggplot2::ggplot(x,ggplot2::aes(n,label,fill=bar_fill,group=source))+
    ggplot2::geom_col(width=.6,position=dodge,orientation='y')+
    ggplot2::geom_text(ggplot2::aes(label=if_else(n>0,as.character(n),'')),position=dodge,
      hjust=-.25,family='Fira Sans',size=2.8)+
    ggplot2::facet_wrap(~facet,ncol=1,scales='free_y',space='free_y')+
    ggplot2::scale_fill_manual(values=c(JAMA_ROLES,'ARBITER remainder'='#969696','Unassisted remainder'='#D9D9D9'),breaks=c('ARBITER','Unassisted'))+
    ggplot2::scale_x_continuous(limits=c(0,20),breaks=c(0,5,10,15,20),expand=ggplot2::expansion(mult=c(0,.02)))+
    ggplot2::labs(x='Individually decisive questions / cells without one (count)',y=NULL,fill=NULL)+theme_manuscript()+
    ggplot2::theme(strip.text=ggplot2::element_text(size=8),axis.text.y=ggplot2::element_text(size=8),panel.spacing=grid::unit(1.5,'mm'))
}
forest_plot <- function() {
  metadata <- readr::read_csv('data-curated/meta-analyses.csv',show_col_types=FALSE)
  x <- manuscript_data('forest-meta') |> filter(is.finite(estimate),lower!=upper) |>
    left_join(metadata |> transmute(meta_id,display=paste(specialty,topic,sep=': ')),by='meta_id') |>
    mutate(arm=reader_label(arm,TRUE))
  colors <- setNames(c(JAMA_ROLES[c('ARBITER','Unassisted')],JAMA_ROLES[5:6]),
    reader_label(c('ARBITER-Sonnet','Baseline-Sonnet','ARBITER-Haiku','Baseline-Haiku'),TRUE))
  ggplot2::ggplot(x,ggplot2::aes(estimate,stringr::str_wrap(display,48),color=arm,shape=arm))+
    ggplot2::geom_vline(xintercept=0,color='grey70')+
    ggplot2::geom_errorbar(ggplot2::aes(xmin=lower,xmax=upper),width=.2,position=ggplot2::position_dodge(width=.65))+
    ggplot2::geom_point(size=1.5,position=ggplot2::position_dodge(width=.65))+
    ggplot2::scale_color_manual(values=colors)+ggplot2::scale_shape_manual(values=c(1,16,2,17))+
    ggplot2::guides(color=ggplot2::guide_legend(nrow=2,byrow=TRUE),shape=ggplot2::guide_legend(nrow=2,byrow=TRUE))+
    ggplot2::labs(x='Weighted \u03ba vs Published (95% CI)',y=NULL,color=NULL,shape=NULL)+theme_manuscript()
}
build_manuscript_figures <- function(cells) {
  register_figure_fonts()
  stopifnot(all(substr(ggsci::pal_jama()(3),1,7)==unname(JAMA_ROLES[c('Published','Unassisted','ARBITER')])))
  export_manuscript_figure(study_flow_plot(),'Figure3',145)
  export_manuscript_figure(adjudication_plot(cells),'Figure5',175)
  export_manuscript_figure(published_reference_plot(),'Figure4',160)
  export_manuscript_figure(decisive_question_plot(),'Figure6',210)
  export_manuscript_figure(forest_plot(),'eFigure1',200)
  export_manuscript_figure(disagreement_matrix_plot(cells),'eFigure2',95)
}
adjudication_plot <- function(cells) {
  rows <- c('Both adjudicators (consensus)','Adjudicator 1','Adjudicator 2','Split cells counted against ARBITER')
  raw <- manuscript_data('primary-endpoint')
  primary <- raw |> filter(metric=='ARBITER') |> mutate(
    row=factor(analysis,levels=c('Consensus','A','Z','Split sensitivity'),labels=rows),
    row=factor(row,levels=rev(rows)))
  counts <- raw |> select(analysis,metric,count,n) |> pivot_wider(names_from=metric,values_from=count) |>
    mutate(text=paste0(ARBITER,' / ',Baseline,' / ',Neither,'; N = ',n))
  primary <- left_join(primary,counts |> select(analysis,text),by='analysis')
  pA <- ggplot2::ggplot(primary,ggplot2::aes(estimate,row))+
    ggplot2::geom_vline(xintercept=.5,linetype='dashed',color='grey50')+
    ggplot2::geom_errorbar(ggplot2::aes(xmin=lower,xmax=upper),width=.14,color=JAMA_ROLES[['ARBITER']])+
    ggplot2::geom_point(size=2.2,color=JAMA_ROLES[['ARBITER']])+
    ggplot2::geom_text(ggplot2::aes(x=1.04,label=text),hjust=0,size=2.6,family='Fira Sans')+
    ggplot2::annotate('text',x=.5,y=4.65,label='no preference',size=2.6,family='Fira Sans')+
    ggplot2::annotate('text',x=1.04,y=4.65,label='ARBITER / Unassisted / neither',hjust=0,size=2.5,family='Fira Sans')+
    ggplot2::scale_x_continuous(breaks=seq(0,1,.25),labels=scales::label_percent())+
    ggplot2::coord_cartesian(xlim=c(0,1.7),ylim=c(.6,4.8),clip='off')+
    ggplot2::labs(x='ARBITER win share (95% CI)',y=NULL)+theme_manuscript()+
    ggplot2::theme(axis.text.y=ggplot2::element_text(size=7.5),panel.grid.major.x=ggplot2::element_blank())
  v <- manuscript_data('vindicated-disagreements')
  splits <- filter(v,outcome=='Split')
  d <- v |> filter(outcome!='Split') |> mutate(
    row=paste(source,tolower(direction),sep=': '),
    row=factor(row,levels=rev(c('ARBITER: more severe','ARBITER: less severe','Unassisted: more severe','Unassisted: less severe'))),
    fill=if_else(outcome=='Vindicated',source,outcome),
    outcome=factor(outcome,levels=c('Vindicated','Published upheld','Other label')))
  outcomes <- v |> filter(outcome %in% c('Published upheld','Other label')) |> select(source,direction,outcome,n) |> pivot_wider(names_from=outcome,values_from=n)
  totals <- d |> filter(outcome=='Vindicated') |> left_join(outcomes,by=c('source','direction')) |> left_join(splits |> select(source,direction,split=n),by=c('source','direction'))
  pB <- ggplot2::ggplot(d,ggplot2::aes(n/consensus_n,row,fill=fill,group=outcome))+
    ggplot2::geom_col(position=ggplot2::position_stack(reverse=TRUE),width=.6)+
    ggplot2::geom_text(ggplot2::aes(label=if_else(n>=3,as.character(n),''),color=outcome=='Published upheld'),
      position=ggplot2::position_stack(vjust=.5,reverse=TRUE),size=2.7,family='Fira Sans',show.legend=FALSE)+
    ggplot2::geom_text(data=totals,ggplot2::aes(x=1.04,label=paste0(n,'/',consensus_n,' (',`Published upheld`,', ',`Other label`,'); split ',split)),
      hjust=0,color='black',size=2.6,family='Fira Sans',inherit.aes=TRUE,show.legend=FALSE)+
    ggplot2::scale_color_manual(values=c('TRUE'='white','FALSE'='black'),guide='none')+
    ggplot2::scale_fill_manual(values=c(ARBITER=JAMA_ROLES[['ARBITER']],Unassisted=JAMA_ROLES[['Unassisted']],
      'Published upheld'=JAMA_ROLES[['Published']],'Other label'='#D9D9D9'),
      breaks=c('ARBITER','Unassisted','Published upheld','Other label'),
      labels=c('Vindicated: ARBITER','Vindicated: Unassisted','Published upheld','Other label'))+
    ggplot2::scale_x_continuous(breaks=seq(0,1,.25),labels=scales::label_percent())+
    ggplot2::coord_cartesian(xlim=c(0,1.7),clip='off')+
    ggplot2::labs(x='Consensus disagreements with Published (split cells excluded)',y=NULL,fill=NULL)+theme_manuscript()+
    ggplot2::theme(legend.text=ggplot2::element_text(size=7.5),legend.position='bottom',panel.grid.major.x=ggplot2::element_blank())+
    ggplot2::guides(fill=ggplot2::guide_legend(nrow=2,byrow=TRUE))
  patchwork::wrap_plots(pA,pB,ncol=1,heights=c(1,1.1))+patchwork::plot_annotation(tag_levels='A')
}
