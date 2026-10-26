export_manuscript_figure <- function(plot,name,height_mm,width_mm=174) {
  dir.create('output/manuscript/qa',recursive=TRUE,showWarnings=FALSE)
  args <- list(plot=plot,width=width_mm,height=height_mm,units='mm',bg='white',limitsize=FALSE)
  do.call(ggplot2::ggsave,c(list(filename=paste0('output/manuscript/',name,'.pdf'),
    device=grDevices::cairo_pdf),args))
  do.call(ggplot2::ggsave,c(list(filename=paste0('output/manuscript/',name,'.tiff'),
    device=ragg::agg_tiff,dpi=600,compression='lzw'),args))
  # Render to a fresh file before replacement (an open browser can retain a
  # Windows handle to the previous PNG while ragg is writing).
  png_path <- paste0('output/manuscript/',name,'.png')
  png_temp <- tempfile(fileext='.png')
  do.call(ggplot2::ggsave,c(list(filename=png_temp,
    device=ragg::agg_png,dpi=160),args))
  stopifnot(file.exists(png_temp),file.info(png_temp)$size>0,
    file.copy(png_temp,png_path,overwrite=TRUE))
  unlink(png_temp)
  invisible(plot)
}
study_flow_plot <- function(cells) {
  nodes <- tibble(x=c(5,5,2.5,7.5,5,2.5,7.5,6.2,8.8),y=c(12,10.5,8.7,8.7,6.9,4.6,4.6,2.2,2.2),
    w=c(7.8,8.6,4.5,4.5,7.3,4.5,4.5,2.3,2.3),h=c(.8,1,1.2,1.2,.9,1.8,1.8,1,1),
    label=c('105 benchmark trials; 3 unsupported designs excluded',
      '102 trials from 16 reviews; identical supplied trial files\nSame model identifier; one run per arm',
      'ARBITER complete workflow\nGuidance, tools and rule application',
      'Unassisted comparator\nMinimal task and format prompt',
      'Paired arm outputs: 102 trials × five domains = 510 cells',
      'Full-cohort comparison: all 510 cells\nEach human reviewer independently records ratings\nand answers before viewing labels; no AI',
      'Conditional label choice: 80 cells\nwhere arm labels differ; human reviewers then\nchoose among randomly ordered labels',
      '60 agreed choices\n53 match ARBITER',
      '20 split choices\nSensitivity analyses'))
  edges <- tibble(x=c(5,2.5,7.5,2.5,7.5,5,2.5,7.5,6.2,8.8),y=c(11.6,9.65,9.65,8.1,8.1,7.65,6,6,3.2,3.2),
    xend=c(5,2.5,7.5,2.5,7.5,5,2.5,7.5,6.2,8.8),yend=c(11,9.3,9.3,7.65,7.65,7.35,5.5,5.5,2.7,2.7))
  joins <- tibble(x=c(2.5,2.5,2.5,6.2),xend=c(7.5,7.5,7.5,8.8),y=c(9.65,7.65,6,3.2))
  ggplot2::ggplot(nodes,ggplot2::aes(x,y))+
    ggplot2::geom_segment(data=joins,ggplot2::aes(x=x,xend=xend,y=y,yend=y),inherit.aes=FALSE,linewidth=.5)+
    ggplot2::geom_segment(data=edges,ggplot2::aes(x=x,y=y,xend=xend,yend=yend),inherit.aes=FALSE,
      arrow=grid::arrow(type='closed',length=grid::unit(1.8,'mm')),linewidth=.5)+
    ggplot2::geom_segment(data=tibble(x=c(5,5,7.5),y=c(10,6.45,3.7),yend=c(9.65,6,3.2)),ggplot2::aes(x=x,xend=x,y=y,yend=yend),inherit.aes=FALSE,linewidth=.5)+
    ggplot2::geom_rect(ggplot2::aes(xmin=x-w/2,xmax=x+w/2,ymin=y-h/2,ymax=y+h/2),fill='#F5F5F3',color='grey30')+
    ggplot2::geom_text(ggplot2::aes(label=label),family='Fira Sans Condensed',size=3)+
    ggplot2::annotate('text',x=2.5,y=2.4,label='Separate human reviews\nFull cohort retained',size=2.9)+
    ggplot2::coord_cartesian(xlim=c(0,10.2),ylim=c(1.4,12.5),expand=FALSE,clip='off')+ggplot2::theme_void()
}
domain_agreement_plot <- function() {
  domains <- c('D1-D5',paste0('D',1:5))
  labels <- c('Pooled (510 cells)','D1 Randomisation','D2 Deviations','D3 Missing data','D4 Measurement','D5 Reported result')
  panels <- list()
  for(expert in c('1','2')) {
    x <- read_display('independent-estimates') |> filter(adjudicator==expert,metric=='accuracy',domain %in% domains,source %in% c('ARBITER','Unassisted')) |>
      mutate(domain=factor(domain,levels=rev(domains)))
    d <- read_display('independent-differences') |> filter(adjudicator==expert,metric=='accuracy',domain %in% domains,comparison=='ARBITER minus Unassisted') |>
      mutate(domain=factor(domain,levels=rev(domains)))
    pooled <- filter(x,domain=='D1-D5'); dp <- filter(d,domain=='D1-D5')
    rate <- ggplot2::ggplot(x,ggplot2::aes(100*estimate,domain,color=source,shape=source))+
      ggplot2::geom_hline(yintercept=5.5,color='grey80')+
      ggplot2::geom_errorbar(ggplot2::aes(xmin=100*lower,xmax=100*upper),width=.12,position=ggplot2::position_dodge(.45,reverse=TRUE))+
      ggplot2::geom_point(size=1.9,position=ggplot2::position_dodge(.45,reverse=TRUE))+
      ggplot2::scale_color_manual(values=JAMA_ROLES)+ggplot2::scale_shape_manual(values=c(ARBITER=16,Unassisted=15))+
      ggplot2::scale_y_discrete(labels=setNames(labels,domains))+
      ggplot2::scale_x_continuous(limits=c(0,100),breaks=seq(0,100,25))+
      ggplot2::labs(title=paste('Human Review',expert),subtitle=paste0('Pooled: ',paste0(fmt_number(100*pooled$estimate,1),'%',collapse=' vs ')),x='Exact agreement (%)',y=NULL,color=NULL,shape=NULL)+theme_manuscript()+
      ggplot2::theme(legend.position='bottom',plot.subtitle=ggplot2::element_text(size=8))
    diff <- ggplot2::ggplot(d,ggplot2::aes(100*estimate,domain))+
      ggplot2::geom_hline(yintercept=5.5,color='grey80')+ggplot2::geom_vline(xintercept=0,color='grey55',linetype=2)+
      ggplot2::geom_errorbar(ggplot2::aes(xmin=100*lower,xmax=100*upper),width=.12)+ggplot2::geom_point(shape=18,size=2)+
      ggplot2::scale_x_continuous(limits=c(-10,30),breaks=seq(-10,30,10))+
      ggplot2::labs(title='ARBITER minus Unassisted',subtitle=paste0('Pooled: +',fmt_number(100*dp$estimate,1),' ',fmt_ci(100*dp$lower,100*dp$upper,1)),x='Paired difference (percentage points)',y=NULL)+theme_manuscript()+
      ggplot2::theme(axis.text.y=ggplot2::element_blank(),axis.ticks.y=ggplot2::element_blank(),plot.subtitle=ggplot2::element_text(size=8),plot.title=ggplot2::element_text(size=9))
    panels[[length(panels)+1L]] <- rate; panels[[length(panels)+1L]] <- diff
  }
  patchwork::wrap_plots(panels,ncol=2,widths=c(1.5,1),guides='collect')+
    patchwork::plot_annotation(caption='Published reference, all 510 cells: 75.7% vs 77.5%; paired difference −1.8 points (95% CI −5.1 to 1.6).') &
    ggplot2::theme(legend.position='bottom',plot.caption=ggplot2::element_text(size=8,hjust=0))
}
signalling_difference_plot <- function() {
  x <- read_display('signalling-differences') |> filter(group %in% paste0('D',1:5)) |>
    mutate(row=paste0(group,' (n = ',n,')'),row=factor(row,levels=rev(unique(row))),
      adjudicator=paste('Human Review',adjudicator),level=factor(level,levels=c('five','collapsed'),labels=c('Five-level exact','Collapsed exact')))
  ggplot2::ggplot(x,ggplot2::aes(100*estimate,row))+
    ggplot2::geom_vline(xintercept=0,color='grey55',linetype=2)+
    ggplot2::geom_errorbar(ggplot2::aes(xmin=100*lower,xmax=100*upper),width=.13)+ggplot2::geom_point(shape=18,size=2)+
    ggplot2::facet_grid(adjudicator~level,scales='free_y')+
    ggplot2::scale_x_continuous(limits=c(-20,40),breaks=seq(-20,40,10))+
    ggplot2::labs(x='ARBITER − Unassisted agreement (percentage points; 95% CI)',y=NULL)+theme_manuscript()
}
build_manuscript_figures <- function(cells) {
  register_figure_fonts()
  export_manuscript_figure(study_flow_plot(cells),'Figure3',150)
  export_manuscript_figure(domain_agreement_plot(),'Figure4',190)
  export_manuscript_figure(signalling_difference_plot(),'Figure5',145)
  dir.create('output/figures',recursive=TRUE,showWarnings=FALSE)
  for(i in 3:5) for(ext in c('png','pdf')) file.copy(paste0('output/manuscript/Figure',i,'.',ext),
    paste0('output/figures/figure',i,'.',ext),overwrite=TRUE)
}
