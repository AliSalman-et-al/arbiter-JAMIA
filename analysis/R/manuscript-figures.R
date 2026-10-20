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
forest_plot <- function() {
  metadata <- readr::read_csv('data-curated/meta-analyses.csv',show_col_types=FALSE)
  x <- manuscript_data('forest-meta') |> filter(is.finite(estimate),lower!=upper) |>
    left_join(metadata |> transmute(meta_id,display=paste(specialty,topic,sep=': ')),by='meta_id') |>
    mutate(arm=reader_label(arm,TRUE))
  colors <- setNames(JAMA_ROLES[c('ARBITER','Unassisted')],reader_label(names(ARMS),TRUE))
  ggplot2::ggplot(x,ggplot2::aes(estimate,stringr::str_wrap(display,48),color=arm,shape=arm))+
    ggplot2::geom_vline(xintercept=0,color='grey70')+
    ggplot2::geom_errorbar(ggplot2::aes(xmin=lower,xmax=upper),width=.2,position=ggplot2::position_dodge(width=.65,reverse=TRUE))+
    ggplot2::geom_point(size=1.5,position=ggplot2::position_dodge(width=.65,reverse=TRUE))+
    ggplot2::scale_color_manual(values=colors)+ggplot2::scale_shape_manual(values=c(16,15))+
    ggplot2::guides(color=ggplot2::guide_legend(nrow=2,byrow=TRUE),shape=ggplot2::guide_legend(nrow=2,byrow=TRUE))+
    ggplot2::labs(x='Weighted \u03ba vs Published (95% CI)',y=NULL,color=NULL,shape=NULL)+theme_manuscript()
}
study_flow_plot <- function(cells) {
  counts <- c(nrow(unique(cells['slug'])),nrow(cells),sum(cells$disputed),sum(cells$discordant),sum(cells$discordant&cells$consensus))
  labels <- c(sprintf('%s trials included\n3 unsupported designs excluded',counts[1]),
    sprintf('%s domain cells (D1–D5)\nEach rated independently by two blinded experts',counts[2]),
    sprintf('%s disputed cells\nAt least one arm differs from Published',counts[3]),
    sprintf('%s cells where the arms disagreed',counts[4]),sprintf('%s with an agreed forced choice',counts[5]))
  nodes <- tibble(x=0,y=5:1,label=labels)
  concordant <- sum(!cells$disputed)
  ggplot2::ggplot(nodes,ggplot2::aes(x,y))+
    ggplot2::geom_segment(data=nodes[1:4,],ggplot2::aes(xend=x,y=y-.29,yend=y-.71),arrow=grid::arrow(type='closed',length=grid::unit(2,'mm')),linewidth=.5)+
    ggplot2::geom_rect(ggplot2::aes(xmin=-.65,xmax=.65,ymin=y-.29,ymax=y+.29),fill='#F5F5F3',color='grey30',linewidth=.65)+
    ggplot2::geom_text(ggplot2::aes(label=label),family='Fira Sans Condensed',fontface='bold',size=3.1)+
    ggplot2::annotate('text',x=.78,y=5,label=paste0('Overall derived for ',counts[1],' trials\nfrom each expert’s domain ratings'),hjust=0,size=3,family='Fira Sans Condensed')+
    ggplot2::annotate('text',x=.78,y=4,label=paste0(concordant,' cells where all three labels\nagreed (no forced-choice information)'),hjust=0,size=3,family='Fira Sans Condensed')+
    ggplot2::coord_cartesian(xlim=c(-.75,1.8),ylim=c(.5,5.5),clip='off')+ggplot2::theme_void()
}
expert_reference_plot <- function() {
  x <- read_display('independent-estimates') |> filter(adjudicator %in% c('1','2'),metric=='accuracy',domain!='D1-D5',domain!='Overall' |
      (source=='Published' & population=='Observed Published Overall') |
      (source!='Published' & population=='All trials'))
  x$source <- factor(x$source,levels=c('ARBITER','Unassisted','Published'))
  r <- read_display('expert-reliability') |> filter(metric=='accuracy',domain!='D1-D5')
  pA <- ggplot2::ggplot(x,ggplot2::aes(domain,estimate,color=source,shape=source))+
    ggplot2::geom_line(data=r,ggplot2::aes(domain,estimate,group=1),inherit.aes=FALSE,linetype='dashed',color='grey35')+
    ggplot2::geom_errorbar(ggplot2::aes(ymin=lower,ymax=upper),position=ggplot2::position_dodge(.55),width=.1)+
    ggplot2::geom_point(position=ggplot2::position_dodge(.55),size=1.7)+
    ggplot2::facet_wrap(~adjudicator,ncol=1,labeller=ggplot2::as_labeller(c('1'='Adjudicator 1','2'='Adjudicator 2')))+
    ggplot2::scale_color_manual(values=JAMA_ROLES)+ggplot2::scale_shape_manual(values=c(ARBITER=16,Unassisted=15,Published=17))+ggplot2::scale_y_continuous(labels=scales::label_percent(),limits=c(0,1))+
    ggplot2::labs(x=NULL,y='Exact agreement (95% CI)',color=NULL,shape=NULL,caption='Dashed line: expert-to-expert agreement')+theme_manuscript()
  d <- read_display('direction-of-disagreement') |>
    mutate(source=factor(source,levels=c('ARBITER','Unassisted')),
      direction=factor(direction,levels=c('Stricter','More lenient')),
      outcome=factor(outcome,levels=c('Expert matches model','Expert matches Published','Expert matches neither'))) |>
    arrange(source,direction,adjudicator) |>
    mutate(row=paste0(source,': ',tolower(direction),' · Adjudicator ',adjudicator,' (n = ',n,')'),
      row=factor(row,levels=rev(unique(row))))
  pB <- ggplot2::ggplot(d,ggplot2::aes(estimate,row,fill=outcome))+
    ggplot2::geom_col(width=.72,position=ggplot2::position_stack(reverse=TRUE))+
    ggplot2::geom_text(ggplot2::aes(label=paste0(count,'/',n)),position=ggplot2::position_stack(vjust=.5,reverse=TRUE),size=2.5)+
    ggplot2::scale_fill_manual(values=c('Expert matches model'='#B8B8B8','Expert matches Published'='#E1E1E1','Expert matches neither'='#F5F5F5'),
      labels=c('Matches arm','Matches Published','Matches neither'))+
    ggplot2::scale_x_continuous(labels=scales::label_percent(),limits=c(0,1),expand=c(0,0))+
    ggplot2::labs(x='Independent expert rating in directional disagreements',y=NULL,fill=NULL)+theme_manuscript()+
    ggplot2::theme(legend.text=ggplot2::element_text(size=7))
  patchwork::wrap_plots(patchwork::free(pA),pB,ncol=1,heights=c(1.5,1))+patchwork::plot_annotation(tag_levels='A')
}

primary_forest_plot <- function() {
  all <- read_display('primary-endpoint')
  x <- all |> filter(metric=='ARBITER') |>
    mutate(row=c('Agreed choice','Adjudicator 1','Adjudicator 2','Split cells counted as losses','ARBITER stricter','ARBITER more lenient'),
      y=c(8,6,5,4,2,1),text=paste0(count,'/',n,' (Unassisted ',all$count[all$metric=='Unassisted'],')'))
  headers <- tibble(y=c(9,7,3),label=c('Primary (agreed choice)',
    'Sensitivity (each adjudicator; split cells counted as losses)','Post hoc strata'))
  ggplot2::ggplot(x,ggplot2::aes(estimate,y))+
    ggplot2::geom_vline(xintercept=.5,linetype='dashed',color='grey65')+
    ggplot2::geom_errorbar(ggplot2::aes(xmin=lower,xmax=upper),width=.15,color=JAMA_ROLES[['ARBITER']])+
    ggplot2::geom_point(size=2,shape=16,color=JAMA_ROLES[['ARBITER']])+
    ggplot2::geom_text(ggplot2::aes(x=1.04,label=text),hjust=0,size=2.8)+
    ggplot2::geom_text(data=headers,ggplot2::aes(x=0,y=y,label=label),inherit.aes=FALSE,hjust=0,fontface='bold',size=2.7)+
    ggplot2::scale_y_continuous(breaks=x$y,labels=x$row,limits=c(.5,9.5))+
    ggplot2::scale_x_continuous(breaks=seq(0,1,.25),labels=scales::label_percent())+
    ggplot2::coord_cartesian(xlim=c(0,1.7),clip='off')+ggplot2::labs(x='Share preferring ARBITER (95% CI)',y=NULL)+theme_manuscript()
}
signalling_plot <- function() {
  x <- read_display('signalling-estimates') |> filter(group %in% paste0('D',1:5)) |>
    mutate(source=factor(source,levels=c('ARBITER','Unassisted')),adjudicator=paste('Adjudicator',adjudicator),level=if_else(level=='five','Five-level exact','Collapsed exact'))
  ggplot2::ggplot(x,ggplot2::aes(group,estimate,color=source,shape=source))+
    ggplot2::geom_errorbar(ggplot2::aes(ymin=lower,ymax=upper),position=ggplot2::position_dodge(.45),width=.1)+
    ggplot2::geom_point(position=ggplot2::position_dodge(.45),size=2)+ggplot2::facet_grid(adjudicator~level)+
    ggplot2::scale_color_manual(values=JAMA_ROLES)+ggplot2::scale_shape_manual(values=c(ARBITER=16,Unassisted=15,Published=17))+ggplot2::scale_y_continuous(labels=scales::label_percent(),limits=c(0,1))+
    ggplot2::labs(x=NULL,y='Signalling-answer agreement (95% CI)',color=NULL,shape=NULL)+theme_manuscript()
}
question_difference_plot <- function(include_sparse=FALSE) {
  x <- read_display('signalling-differences') |> filter(grepl('^[1-5][.]',group)) |>
    mutate(domain=paste0('D',substr(group,1,1)),
      row=paste0(group,' · Adjudicator ',adjudicator,' (n = ',n,')'),
      level=factor(level,levels=c('collapsed','five'),labels=c('Collapsed','Five-level')))
  if(!include_sparse) x <- filter(x,n>=20,level=='Collapsed')
  order <- x |> arrange(as.numeric(group),adjudicator) |> pull(row) |> unique()
  x$row <- factor(x$row,levels=rev(order))
  ggplot2::ggplot(x,ggplot2::aes(estimate,row))+
    ggplot2::geom_vline(xintercept=0,color='grey60',linetype='dashed')+
    ggplot2::geom_errorbar(ggplot2::aes(xmin=lower,xmax=upper),width=.15,color=JAMA_ROLES[['ARBITER']],na.rm=TRUE)+
    ggplot2::geom_point(shape=16,color=JAMA_ROLES[['ARBITER']],size=1.5,na.rm=TRUE)+
    ggplot2::geom_text(data=filter(x,!is.finite(estimate)),ggplot2::aes(x=0,label='Not estimable'),size=2.2,color='grey40')+
    ggplot2::facet_grid(domain~level,scales='free_y',space='free_y')+
    ggplot2::scale_x_continuous(labels=function(v) fmt_number(100*v,0))+
    ggplot2::labs(x='ARBITER − Unassisted agreement (percentage points; 95% CI)',y=NULL)+theme_manuscript()+
    ggplot2::theme(axis.text.y=ggplot2::element_text(size=6.5),plot.title=ggplot2::element_text(size=10))
}
build_manuscript_figures <- function(cells) {
  register_figure_fonts()
  export_manuscript_figure(study_flow_plot(cells),'Figure3',120)
  export_manuscript_figure(expert_reference_plot(),'Figure5',215)
  export_manuscript_figure(primary_forest_plot(),'Figure4',130)
  export_manuscript_figure(question_difference_plot(),'Figure6',245)
  export_manuscript_figure(forest_plot(),'eFigure1',200)
  export_manuscript_figure(signalling_plot(),'eFigure2',140)
  export_manuscript_figure(question_difference_plot(TRUE),'eFigure3',245)
  for(i in 3:6) for(ext in c('png','pdf')) file.copy(paste0('output/manuscript/Figure',i,'.',ext),paste0('output/figures/figure',i,'.',ext),overwrite=TRUE)
  for(ext in c('png','pdf')) file.copy(paste0('output/manuscript/eFigure1.',ext),paste0('output/figures/supplement-forest.',ext),overwrite=TRUE)
}
