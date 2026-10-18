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
  # Main spine plus a horizontal CONSORT exclusion branch.
  nodes <- tibble(x=c(0,0,3.5,0,0,-1.6,1.6,-1.6),y=c(8,6.6,7.3,5.3,4.1,2.7,2.7,1.1),
    label=c('16 meta-analyses; 105 benchmark trials','102 analysis-set trials',
      '3 excluded: unsupported design\nAtwine 2020; Haney 2004; Herrmann 2016',
      '510 D1\u2013D5 cells per arm\n81 Published Overall labels','154 disputed cells',
      '129 consensus cells','25 split cells\n18 cells where arms differ',
      '62 differing consensus cells\n54 ARBITER; 7 Unassisted; 1 neither'))
  edges <- tibble(x=c(0,0,0,0,0,-1.6),xend=c(0,0,0,-1.6,1.6,-1.6),
    y=c(7.72,6.3,4.9,3.83,3.83,2.4),yend=c(6.9,5.7,4.4,3.05,3.05,1.5))
  ggplot2::ggplot(nodes,ggplot2::aes(x,y))+
    ggplot2::geom_segment(data=edges,ggplot2::aes(x=x,xend=xend,y=y,yend=yend),
      arrow=grid::arrow(length=grid::unit(1.5,'mm')),linewidth=.55)+
    ggplot2::annotate('segment',x=0,xend=2.0,y=7.3,yend=7.3,linewidth=.55,
      arrow=grid::arrow(length=grid::unit(1.5,'mm')))+
    ggplot2::geom_label(ggplot2::aes(label=label),family='Fira Sans Condensed',size=2.8,
      label.padding=grid::unit(.35,'lines'),fill='#F3F6F7',linewidth=.55,lineheight=1.05)+
    ggplot2::coord_cartesian(xlim=c(-3.5,5.5),ylim=c(.6,8.45),clip='off')+
    ggplot2::theme_void(base_family='Fira Sans Condensed')+
    ggplot2::theme(plot.margin=ggplot2::margin(3,5,3,5))
}
adjudication_plot <- function(cells) {
  rows <- c('Both adjudicators\n(consensus)','Adjudicator 1','Adjudicator 2',
    'Split cells counted\nagainst ARBITER')
  primary <- manuscript_data('primary-endpoint') |> filter(metric!='Neither') |>
    mutate(analysis=factor(analysis,levels=c('Consensus','A','Z','Split sensitivity'),labels=rows),
      analysis=factor(analysis,levels=rev(rows)),metric=reader_label(metric))
  pA <- ggplot2::ggplot(primary,ggplot2::aes(estimate,analysis,color=metric,shape=metric))+
    ggplot2::geom_errorbar(ggplot2::aes(xmin=lower,xmax=upper),position=ggplot2::position_dodge(width=.5),width=.12)+
    ggplot2::geom_point(position=ggplot2::position_dodge(width=.5),size=2)+
    ggplot2::geom_text(data=filter(primary,analysis==rows[1]),ggplot2::aes(label=paste0(count,'/',n)),
      position=ggplot2::position_dodge(width=.5),vjust=-1.1,family='Fira Sans',size=2.7,show.legend=FALSE)+
    ggplot2::scale_x_continuous(limits=c(0,1),labels=scales::label_percent(accuracy=1))+
    ggplot2::scale_color_manual(values=JAMA_ROLES)+ggplot2::scale_shape_manual(values=c(16,17))+
    ggplot2::labs(x='Win share on cells where the arms differ (95% CI)',y=NULL,color=NULL,shape=NULL)+theme_manuscript()
  departures <- c('ARBITER only\ndeparted from Published','Unassisted only\ndeparted from Published',
    'Both departed,\ndifferent labels','Both departed,\nsame label')
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
  patchwork::wrap_plots(pA,pB,ncol=1,heights=c(1,1))+
    patchwork::plot_annotation(tag_levels='A')
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
  direction <- manuscript_data('meta-leniency') |> mutate(direction=factor(direction,levels=rev(c('Less severe','Equal','More severe'))))
  pB <- ggplot2::ggplot(direction,ggplot2::aes(count/129,direction))+
    ggplot2::geom_col(fill=JAMA_ROLES[['Published']],width=.58)+
    ggplot2::geom_text(ggplot2::aes(label=fmt_fraction(count,129)),hjust=-.15,family='Fira Sans',size=3)+
    ggplot2::scale_x_continuous(limits=c(0,1),breaks=seq(0,1,.25),labels=scales::label_percent(accuracy=1),expand=ggplot2::expansion(mult=c(0,.02)))+
    ggplot2::labs(x="Published label relative to adjudicators' preferred judgement\n(consensus cells, n = 129)",y=NULL)+theme_manuscript()
  patchwork::wrap_plots(pA,pB,ncol=1,heights=c(1.15,1))+
    patchwork::plot_annotation(tag_levels='A')
}
decisive_question_plot <- function() {
  x <- manuscript_data('error-localisation-frequency') |> filter(population=='Primary')
  shown <- x |> group_by(question) |> summarise(n=sum(n),.groups='drop') |> filter(n>0)
  losses <- manuscript_data('error-localisation-cells') |> filter(population=='Primary') |>
    count(domain,source) |> complete(domain=paste0('D',1:5),source=c('ARBITER-Sonnet','Baseline-Sonnet'),fill=list(n=0)) |>
    pivot_wider(names_from=source,values_from=n) |>
    mutate(facet=paste0(domain,' losses: ARBITER n = ',`ARBITER-Sonnet`,
      '; Unassisted n = ',`Baseline-Sonnet`))
  x <- x |> filter(question %in% shown$question) |> left_join(losses |> select(domain,facet),by='domain') |>
    mutate(source=factor(reader_label(source),levels=c('ARBITER','Unassisted')),
      label=stringr::str_wrap(paste(question,short_text),width=50),
      label=factor(label,levels=rev(unique(label[order(question)]))))
  ggplot2::ggplot(x,ggplot2::aes(n,as.numeric(label)+if_else(source=='ARBITER',.18,-.18),fill=source))+
    ggplot2::geom_blank(ggplot2::aes(y=as.numeric(label)+.55))+
    ggplot2::geom_blank(ggplot2::aes(y=as.numeric(label)-.55))+
    ggplot2::geom_col(data=filter(x,n>0),width=.3,orientation='y')+
    ggplot2::geom_text(data=filter(x,n>0),ggplot2::aes(label=n),
      hjust=-.25,family='Fira Sans',size=2.8)+
    ggplot2::scale_y_continuous(breaks=seq_along(levels(x$label)),labels=levels(x$label))+
    ggplot2::facet_wrap(~facet,ncol=1,scales='free_y',space='free_y')+
    ggplot2::scale_fill_manual(values=JAMA_ROLES)+
    ggplot2::scale_x_continuous(limits=c(0,20),breaks=c(0,5,10,15,20),expand=ggplot2::expansion(mult=c(0,.02)))+
    ggplot2::labs(x='Individually decisive questions (count)',y=NULL,fill=NULL)+theme_manuscript()+
    ggplot2::theme(strip.text=ggplot2::element_text(size=8),
      axis.text.y=ggplot2::element_text(size=8),panel.spacing=grid::unit(3,'mm'))
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
  export_manuscript_figure(study_flow_plot(),'Figure2',95)
  export_manuscript_figure(adjudication_plot(cells),'Figure3',180)
  export_manuscript_figure(published_reference_plot(),'Figure4',160)
  export_manuscript_figure(decisive_question_plot(),'Figure5',215)
  export_manuscript_figure(forest_plot(),'eFigure1',200)
}
