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
forest_plot <- function() {
  metadata <- readr::read_csv('data-curated/meta-analyses.csv',show_col_types=FALSE)
  x <- manuscript_data('forest-meta') |>
    left_join(metadata |> transmute(meta_id,display=paste(specialty,topic,sep=': ')),by='meta_id') |>
    mutate(arm=reader_label(arm,TRUE))
  undefined <- x |> filter(!is.finite(estimate)) |> group_by(display) |> summarise(label=paste(paste0(arm,' κ undefined'),collapse='\n'),.groups='drop')
  colors <- setNames(JAMA_ROLES[c('ARBITER','Unassisted')],reader_label(names(ARMS),TRUE))
  ggplot2::ggplot(x,ggplot2::aes(estimate,stringr::str_wrap(display,48),color=arm,shape=arm))+
    ggplot2::geom_vline(xintercept=0,color='grey70')+
    ggplot2::geom_errorbar(ggplot2::aes(xmin=lower,xmax=upper),width=.2,position=ggplot2::position_dodge(width=.65,reverse=TRUE))+
    ggplot2::geom_point(size=1.5,position=ggplot2::position_dodge(width=.65,reverse=TRUE),na.rm=TRUE)+
    ggplot2::geom_text(data=undefined,ggplot2::aes(x=0,y=stringr::str_wrap(display,48),label=label),inherit.aes=FALSE,hjust=0,size=8.5/ggplot2::.pt)+
    ggplot2::scale_color_manual(values=colors)+ggplot2::scale_shape_manual(values=c(16,15))+
    ggplot2::guides(color=ggplot2::guide_legend(nrow=2,byrow=TRUE),shape=ggplot2::guide_legend(nrow=2,byrow=TRUE))+
    ggplot2::labs(x='Weighted \u03ba vs Published (95% CI)',y=NULL,color=NULL,shape=NULL)+theme_manuscript()
}
study_flow_plot <- function(cells) {
  nodes <- tibble(x=c(5,5,2.5,7.5,5,2.5,7.5,6.2,8.8),y=c(12,10.5,8.7,8.7,6.9,4.6,4.6,2.2,2.2),
    w=c(7.8,8.6,4.5,4.5,7.3,4.5,4.5,2.3,2.3),h=c(.8,1,1.2,1.2,.9,1.8,1.8,1,1),
    label=c('105 benchmark trials; 3 unsupported designs excluded',
      '102 trials from 16 reviews; identical supplied trial files\nSame model identifier; one run per arm',
      'ARBITER complete workflow\nGuidance, tools and rule application',
      'Unassisted comparator\nMinimal task and format prompt',
      'Paired arm outputs: 102 trials × five domains = 510 cells',
      'Full-cohort comparison: all 510 cells\nEach expert independently records ratings\nand answers before viewing labels; no AI',
      'Conditional label choice: 80 cells\nwhere arm labels differ; experts then\nchoose among randomly ordered labels',
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
    ggplot2::annotate('text',x=2.5,y=2.4,label='Separate expert references\nFull cohort retained',size=2.9)+
    ggplot2::coord_cartesian(xlim=c(0,10.2),ylim=c(1.4,12.5),expand=FALSE,clip='off')+ggplot2::theme_void()
}
benchmark_difference_plot <- function() {
  e <- read_display('independent-differences') |> filter(adjudicator %in% c('1','2'),metric=='accuracy',
    comparison=='ARBITER minus Unassisted',domain!='Overall' | population=='Observed Published Overall') |>
    mutate(reference=paste('Expert',adjudicator))
  p <- read_display('agreement-meta-differences') |> filter(metric=='accuracy',
    comparison=='ARBITER (Sonnet 5.5) minus Unassisted (Sonnet 5.5)') |> mutate(reference='Published')
  x <- bind_rows(p,e) |> mutate(reference=factor(reference,levels=c('Published','Expert 1','Expert 2')),
    domain=factor(domain,levels=rev(c('D1-D5',paste0('D',1:5),'Overall'))))
  ggplot2::ggplot(x,ggplot2::aes(estimate,domain))+
    ggplot2::geom_vline(xintercept=0,color='grey65')+
    ggplot2::geom_hline(yintercept=c(1.5,6.5),color='grey85')+
    ggplot2::geom_errorbar(ggplot2::aes(xmin=lower,xmax=upper),width=.15,color='#333333')+
    ggplot2::geom_point(size=1.8,color='#333333')+
    ggplot2::facet_wrap(~reference,nrow=1)+
    ggplot2::scale_x_continuous(labels=function(v) fmt_number(100*v,0))+
    ggplot2::scale_y_discrete(labels=c('D1-D5'='D1–D5 pooled','Overall'='Overall (81 trials)'),expand=ggplot2::expansion(add=c(1.2,.6)))+
    ggplot2::labs(x='ARBITER − Unassisted exact agreement (percentage points; 95% CI)',y=NULL)+theme_manuscript()
}
answers_arithmetic_plot <- function() {
  d <- read_display('independent-estimates') |> filter(adjudicator %in% c('1','2'),domain=='D1-D5',metric=='accuracy',source!='Published') |>
    mutate(row='Domain ratings (510 cells)')
  r <- read_display('rules-only-agreement') |> filter(adjudicator %in% c('1','2'),domain=='D1-D5',metric=='accuracy',source=='Unassisted') |>
    mutate(source='Rules-only',row='Domain ratings (510 cells)')
  a <- read_display('signalling-paired-estimates') |> mutate(adjudicator=as.character(adjudicator),row='Signalling answers, collapsed (paired)')
  x <- bind_rows(d,r,a) |> mutate(source=factor(source,levels=c('ARBITER','Unassisted','Rules-only')),
    row=factor(row,levels=c('Signalling answers, collapsed (paired)','Domain ratings (510 cells)')),
    adjudicator=paste('Expert',adjudicator))
  ggplot2::ggplot(x,ggplot2::aes(estimate,row,color=source,shape=source))+
    ggplot2::geom_errorbar(ggplot2::aes(xmin=lower,xmax=upper),width=.12,position=ggplot2::position_dodge(.55,reverse=TRUE))+
    ggplot2::geom_point(size=2,stroke=.8,position=ggplot2::position_dodge(.55,reverse=TRUE))+
    ggplot2::facet_wrap(~adjudicator,nrow=1)+
    ggplot2::scale_shape_manual(values=c(ARBITER=16,Unassisted=15,'Rules-only'=0),
      labels=c('ARBITER','Unassisted','Unassisted after rules-only recomputation'))+
    ggplot2::scale_color_manual(values=c(ARBITER=JAMA_ROLES[['ARBITER']],Unassisted=JAMA_ROLES[['Unassisted']],'Rules-only'=JAMA_ROLES[['Unassisted']]),
      labels=c('ARBITER','Unassisted','Unassisted after rules-only recomputation'))+
    ggplot2::scale_x_continuous(labels=scales::label_percent(),limits=c(.55,.95),breaks=seq(.6,.9,.1))+
    ggplot2::labs(x='Agreement with independent expert rating or answer (95% CI)',y=NULL,color=NULL,shape=NULL)+theme_manuscript()+
    ggplot2::theme(legend.position='bottom',legend.direction='vertical',panel.spacing.x=grid::unit(6,'mm'))
}
expert_reference_plot <- function() {
  x <- read_display('independent-estimates') |> filter(adjudicator %in% c('1','2'),metric=='accuracy',domain!='D1-D5',domain!='Overall' |
      (source=='Published' & population=='Observed Published Overall') |
      (source!='Published' & population=='All trials'))
  x$source <- factor(x$source,levels=c('ARBITER','Unassisted','Published'))
  r <- read_display('expert-reliability') |> filter(metric=='accuracy',domain!='D1-D5')
  pA <- ggplot2::ggplot(x,ggplot2::aes(domain,estimate,color=source,shape=source))+
    ggplot2::geom_point(data=r,ggplot2::aes(domain,estimate),inherit.aes=FALSE,shape=95,size=5,color='grey35')+
    ggplot2::geom_errorbar(ggplot2::aes(ymin=lower,ymax=upper),position=ggplot2::position_dodge(.55),width=.1)+
    ggplot2::geom_point(position=ggplot2::position_dodge(.55),size=1.7)+
    ggplot2::facet_wrap(~adjudicator,ncol=1,labeller=ggplot2::as_labeller(c('1'='Expert 1','2'='Expert 2')))+
    ggplot2::scale_color_manual(values=JAMA_ROLES)+ggplot2::scale_shape_manual(values=c(ARBITER=16,Unassisted=15,Published=17))+ggplot2::scale_y_continuous(labels=scales::label_percent(),limits=c(0,1))+
    ggplot2::labs(x=NULL,y='Exact agreement (95% CI)',color=NULL,shape=NULL,caption='Short horizontal ticks: expert-to-expert agreement')+theme_manuscript()
  d <- read_display('direction-of-disagreement') |>
    mutate(source=factor(source,levels=c('ARBITER','Unassisted')),
      direction=factor(direction,levels=c('Stricter','More lenient')),
      outcome=factor(outcome,levels=c('Expert matches model','Expert matches Published','Expert matches neither'))) |>
    arrange(source,direction,adjudicator) |>
    mutate(row=paste0(source,': ',tolower(direction),' · Expert ',adjudicator,' (n = ',n,')'),
      row=factor(row,levels=rev(unique(row))))
  pB <- ggplot2::ggplot(d,ggplot2::aes(estimate,row,fill=outcome))+
    ggplot2::geom_col(width=.72,position=ggplot2::position_stack(reverse=TRUE))+
    ggplot2::geom_text(ggplot2::aes(label=paste0(count,'/',n)),position=ggplot2::position_stack(vjust=.5,reverse=TRUE),size=2.5)+
    ggplot2::scale_fill_manual(values=c('Expert matches model'='#B8B8B8','Expert matches Published'='#E1E1E1','Expert matches neither'='#F5F5F5'),
      labels=c('Matches arm','Matches Published','Matches neither'))+
    ggplot2::scale_x_continuous(labels=scales::label_percent(),limits=c(0,1),expand=c(0,0))+
    ggplot2::labs(x='Independent expert rating in directional disagreements',y=NULL,fill=NULL)+theme_manuscript()+
    ggplot2::theme(legend.text=ggplot2::element_text(size=7))
  list(absolute=pA,direction=pB)
}

primary_forest_plot <- function() {
  all <- read_display('primary-endpoint')
  x <- all |> filter(metric=='ARBITER') |>
    mutate(row=c('Agreed choice','Expert 1','Expert 2','Split cells counted as losses','ARBITER stricter','ARBITER more lenient'),
      y=c(8,6,5,4,2,1),text=paste0(count,'/',n,' (Unassisted ',all$count[all$metric=='Unassisted'],')'))
  headers <- tibble(y=c(9,7,3),label=c('Agreed label choices',
    'Sensitivity (each expert; split cells counted as losses)','Exploratory strata'))
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
    mutate(source=factor(source,levels=c('ARBITER','Unassisted')),adjudicator=paste('Expert',adjudicator),level=if_else(level=='five','Five-level exact','Collapsed exact'))
  ggplot2::ggplot(x,ggplot2::aes(group,estimate,color=source,shape=source))+
    ggplot2::geom_errorbar(ggplot2::aes(ymin=lower,ymax=upper),position=ggplot2::position_dodge(.45),width=.1)+
    ggplot2::geom_point(position=ggplot2::position_dodge(.45),size=2)+ggplot2::facet_grid(adjudicator~level)+
    ggplot2::scale_color_manual(values=JAMA_ROLES)+ggplot2::scale_shape_manual(values=c(ARBITER=16,Unassisted=15,Published=17))+ggplot2::scale_y_continuous(labels=scales::label_percent(),limits=c(0,1))+
    ggplot2::labs(x=NULL,y='Signalling-answer agreement (95% CI)',color=NULL,shape=NULL)+theme_manuscript()
}
question_difference_plot <- function(include_sparse=FALSE,domain_filter=NULL) {
  x <- read_display('signalling-differences') |> filter(grepl('^[1-5][.]',group)) |>
    mutate(domain=paste0('D',substr(group,1,1)),
      row=paste0(group,' · Expert ',adjudicator,' (n = ',n,')'),
      level=factor(level,levels=c('collapsed','five'),labels=c('Collapsed','Five-level')))
  if(!include_sparse) x <- filter(x,n>=20,level=='Collapsed')
  if(!is.null(domain_filter)) x <- filter(x,domain==domain_filter)
  order <- x |> arrange(as.numeric(group),adjudicator) |> pull(row) |> unique()
  x$row <- factor(x$row,levels=rev(order))
  ggplot2::ggplot(x,ggplot2::aes(estimate,row))+
    ggplot2::geom_vline(xintercept=0,color='grey60',linetype='dashed')+
    ggplot2::geom_errorbar(ggplot2::aes(xmin=lower,xmax=upper),width=.15,color='#333333',na.rm=TRUE)+
    ggplot2::geom_point(shape=16,color='#333333',size=1.5,na.rm=TRUE)+
    ggplot2::geom_text(data=filter(x,!is.finite(estimate)),ggplot2::aes(x=0,label='Not estimable'),size=8.5/ggplot2::.pt,color='grey40')+
    ggplot2::facet_grid(domain~level,scales='free_y',space='free_y')+
    ggplot2::scale_x_continuous(labels=function(v) fmt_number(100*v,0))+
    ggplot2::labs(x='ARBITER − Unassisted agreement (percentage points; 95% CI)',y=NULL)+theme_manuscript()+
    ggplot2::theme(axis.text.y=ggplot2::element_text(size=9),plot.title=ggplot2::element_text(size=10))
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
      ggplot2::labs(title=paste('Expert',expert),subtitle=paste0('Pooled: ',paste0(fmt_number(100*pooled$estimate,1),'%',collapse=' vs ')),x='Exact agreement (%)',y=NULL,color=NULL,shape=NULL)+theme_manuscript()+
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
      adjudicator=paste('Expert',adjudicator),level=factor(level,levels=c('five','collapsed'),labels=c('Five-level exact','Collapsed exact')))
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
  old <- expert_reference_plot()
  export_manuscript_figure(old$absolute,'eFigure1',150)
  export_question_panels(FALSE,'eFigure2')
  export_manuscript_figure(forest_plot(),'eFigure3',200)
  export_manuscript_figure(signalling_plot(),'eFigure4',140)
  export_question_panels(TRUE,'eFigure5')
  for(i in 3:5) for(ext in c('png','pdf')) file.copy(paste0('output/manuscript/Figure',i,'.',ext),paste0('output/figures/figure',i,'.',ext),overwrite=TRUE)
  for(ext in c('png','pdf')) file.copy(paste0('output/manuscript/eFigure3.',ext),paste0('output/figures/supplement-forest.',ext),overwrite=TRUE)
}

# Domain panels preserve all eligible rows while keeping labels at reading size.
export_question_panels <- function(sparse,name) {
  panels <- lapply(paste0('D',1:5),function(d) question_difference_plot(sparse,d)+
    ggplot2::labs(title=paste(name,d,if(sparse) 'All question components' else 'Collapsed, paired n ≥ 20'))+
    ggplot2::theme(axis.text=ggplot2::element_text(size=9)))
  grDevices::cairo_pdf(paste0('output/manuscript/',name,'.pdf'),width=174/25.4,height=175/25.4,onefile=TRUE)
  for(p in panels) print(p)
  grDevices::dev.off()
  for(i in seq_along(panels)) {
    for(ext in 'png') ggplot2::ggsave(paste0('output/manuscript/',name,'-D',i,'.',ext),panels[[i]],
      width=174,height=175,units='mm',dpi=if(ext=='png') 160 else 600,bg='white',limitsize=FALSE)
    ggplot2::ggsave(paste0('output/manuscript/',name,'-D',i,'.pdf'),panels[[i]],width=174,height=175,units='mm',device=grDevices::cairo_pdf)
  }
  file.copy(paste0('output/manuscript/',name,'-D1.png'),paste0('output/manuscript/',name,'.png'),overwrite=TRUE)
  ggplot2::ggsave(paste0('output/manuscript/',name,'.tiff'),panels[[1]],width=174,height=175,units='mm',device=ragg::agg_tiff,dpi=600,compression='lzw',bg='white')
  invisible(panels)
}
