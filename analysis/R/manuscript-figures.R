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
study_flow_nodes <- function() {
  tibble(x=c(-1.1,-1.1,3.45,-1.1,-1.1,-1.1,-3.25,1.05,-3.25,1.05),
    y=c(8.8,7.6,8.2,6.2,4.8,3.6,2.4,2.4,1,1),
    w=c(5.1,5.1,3.7,5.1,5.1,5.1,4,4,4,4),h=c(.7,.7,1.1,1.1,.85,.85,.8,.8,1.2,1.2),
    label=c('16 meta-analyses; 105 benchmark trials','102 trials included',
      '3 excluded: unsupported design\nAtwine 2020; Haney 2004;\nHerrmann 2016',
      '2 arms each assessed 102 trials:\nARBITER and Unassisted (Sonnet 5.5)',
      '510 domain ratings per arm (D1–D5)\n81 published Overall ratings','154 domain ratings\nreviewed by adjudicators',
      '129 both adjudicators agreed','25 adjudicators split',
      '62 where the two\narms disagreed',
      '18 where the two\narms disagreed'))
}
study_flow_plot <- function() {
  nodes <- study_flow_nodes()
  edges <- tibble(x=c(rep(-1.1,6),-3.25,1.05,-1.1),
    xend=c(rep(-1.1,4),-3.25,1.05,-3.25,1.05,1.53),
    y=c(8.45,7.25,5.65,4.375,3.15,3.15,1.95,1.95,8.2),
    yend=c(8.02,6.82,5.295,4.095,2.89,2.89,1.67,1.67,8.2))
  ggplot2::ggplot(nodes,ggplot2::aes(x,y))+
    ggplot2::geom_segment(data=edges,ggplot2::aes(x=x,xend=xend,y=y,yend=yend),
      arrow=grid::arrow(length=grid::unit(1.5,'mm'),type='closed'),linewidth=.42,color='black')+
    lapply(seq_len(nrow(nodes)),function(i) {
      n <- nodes[i,]
      ggplot2::annotation_custom(grid::roundrectGrob(r=grid::unit(1.5,'mm'),
        gp=grid::gpar(fill='#F5F5F3',col='black',lwd=1.6,lty=if(i==3) 'dashed' else 'solid')),
        xmin=n$x-n$w/2,xmax=n$x+n$w/2,ymin=n$y-n$h/2,ymax=n$y+n$h/2)
    })+
    ggplot2::geom_text(ggplot2::aes(label=label),family='Fira Sans Condensed',fontface='bold',size=2.8,lineheight=1.05)+
    ggplot2::coord_cartesian(xlim=c(-5.6,5.6),ylim=c(.25,9.25),expand=FALSE,clip='off')+
    ggplot2::theme_void(base_family='Fira Sans Condensed')+
    ggplot2::theme(plot.margin=ggplot2::margin(3,3,3,3,unit='mm'))
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
    domain %in% paste0('D',1:5),metric=='kappa') |> mutate(arm=reader_label(arm),
      domain=factor(domain,levels=c(paste0('D',1:5),'D1-D5'),labels=c(paste0('D',1:5),'Pooled\nD1\u2013D5')))
  pA <- ggplot2::ggplot(x,ggplot2::aes(domain,estimate,color=arm,shape=arm))+
    ggplot2::geom_hline(yintercept=0,linetype='dashed',color='grey70')+
    ggplot2::geom_errorbar(ggplot2::aes(ymin=lower,ymax=upper),position=ggplot2::position_dodge(width=.45),width=.13)+
    ggplot2::geom_point(position=ggplot2::position_dodge(width=.45),size=2)+
    ggplot2::scale_color_manual(values=JAMA_ROLES)+ggplot2::scale_shape_manual(values=c(16,17))+
    ggplot2::labs(x=NULL,y='Weighted \u03ba with published label (95% CI)',color=NULL,shape=NULL)+theme_manuscript()
  pB <- direction_disagreement_plot()
  patchwork::wrap_plots(pA,pB,ncol=1,heights=c(1.1,1))+patchwork::plot_annotation(tag_levels='A')
}
direction_disagreement_plot <- function() {
  x <- manuscript_data('direction-of-disagreement') |> mutate(source=reader_label(source),
    row=paste(source,tolower(direction),sep=': '),row=factor(row,levels=rev(row)),
    text=paste0(count,'/',n,'; split: ',split))
  ggplot2::ggplot(x,ggplot2::aes(estimate,row,color=source))+
    ggplot2::geom_errorbar(ggplot2::aes(xmin=lower,xmax=upper),width=.16)+
    ggplot2::geom_point(size=2)+
    ggplot2::geom_text(ggplot2::aes(x=1.04,label=text),hjust=0,size=2.7,family='Fira Sans',color='black')+
    ggplot2::scale_color_manual(values=JAMA_ROLES,guide='none')+
    ggplot2::scale_x_continuous(breaks=seq(0,1,.25),labels=scales::label_percent())+
    ggplot2::coord_cartesian(xlim=c(0,1.48),clip='off')+
    ggplot2::labs(x='Post hoc: adjudicators agreed with the model (95% CI)',y=NULL)+theme_manuscript()+
    ggplot2::theme(axis.text.y=ggplot2::element_text(size=8))
}

decisive_question_plot <- function() {
  x <- manuscript_data('error-localisation-frequency') |> filter(population=='Primary') |> mutate(question=as.character(question))
  shown <- x |> group_by(question) |> summarise(n=sum(n),.groups='drop') |> filter(n>0)
  remainder <- manuscript_data('no-decisive-counts')
  losses <- remainder |> select(domain,source,eligible,n) |>
    pivot_wider(names_from=source,values_from=c(eligible,n)) |>
    mutate(facet=paste0(domain,' · Eligible: ARBITER ',`eligible_ARBITER-Sonnet`,' / Unassisted ',`eligible_Baseline-Sonnet`,
      '\nNo single deciding question: ARBITER ',`n_ARBITER-Sonnet`,' / Unassisted ',`n_Baseline-Sonnet`))

  x <- x |> filter(question %in% shown$question) |>
    left_join(losses |> select(domain,facet),by='domain') |>
    mutate(source=factor(reader_label(source),levels=c('ARBITER','Unassisted')),
      label=stringr::str_wrap(paste(question,short_text),width=50),bar_fill=as.character(source),
      label=factor(label,levels=rev(unique(label[order(question)]))))
  dodge <- ggplot2::position_dodge(width=.7,reverse=TRUE)
  ggplot2::ggplot(x,ggplot2::aes(n,label,fill=bar_fill,group=source))+
    ggplot2::geom_col(width=.6,position=dodge,orientation='y')+
    ggplot2::geom_text(ggplot2::aes(label=if_else(n>0,as.character(n),'')),position=dodge,
      hjust=-.25,family='Fira Sans',size=2.8)+
    ggplot2::facet_wrap(~facet,ncol=1,scales='free_y',space='free_y')+
    ggplot2::scale_fill_manual(values=JAMA_ROLES[c('ARBITER','Unassisted')])+
    ggplot2::guides(fill=ggplot2::guide_legend(nrow=1,byrow=TRUE))+
    ggplot2::scale_x_continuous(limits=c(0,20),breaks=c(0,5,10,15,20),expand=ggplot2::expansion(mult=c(0,.02)))+
    ggplot2::labs(x='Ratings the adjudicators did not choose',y=NULL,fill=NULL)+theme_manuscript()+
    ggplot2::theme(legend.justification='left',legend.key.width=grid::unit(3,'mm'),
      legend.key.height=grid::unit(3,'mm'),legend.key.spacing.x=grid::unit(2,'mm'),
      plot.caption=ggplot2::element_text(size=8,hjust=0),strip.text=ggplot2::element_text(size=8,face='plain'),axis.text.y=ggplot2::element_text(size=8),panel.spacing=grid::unit(1.5,'mm'))
}
forest_plot <- function() {
  metadata <- readr::read_csv('data-curated/meta-analyses.csv',show_col_types=FALSE)
  x <- manuscript_data('forest-meta') |> filter(is.finite(estimate),lower!=upper) |>
    left_join(metadata |> transmute(meta_id,display=paste(specialty,topic,sep=': ')),by='meta_id') |>
    mutate(arm=reader_label(arm,TRUE))
  colors <- setNames(JAMA_ROLES[c('ARBITER','Unassisted')],reader_label(names(ARMS),TRUE))
  ggplot2::ggplot(x,ggplot2::aes(estimate,stringr::str_wrap(display,48),color=arm,shape=arm))+
    ggplot2::geom_vline(xintercept=0,color='grey70')+
    ggplot2::geom_errorbar(ggplot2::aes(xmin=lower,xmax=upper),width=.2,position=ggplot2::position_dodge(width=.65))+
    ggplot2::geom_point(size=1.5,position=ggplot2::position_dodge(width=.65))+
    ggplot2::scale_color_manual(values=colors)+ggplot2::scale_shape_manual(values=c(16,17))+
    ggplot2::guides(color=ggplot2::guide_legend(nrow=2,byrow=TRUE),shape=ggplot2::guide_legend(nrow=2,byrow=TRUE))+
    ggplot2::labs(x='Weighted \u03ba vs Published (95% CI)',y=NULL,color=NULL,shape=NULL)+theme_manuscript()
}
build_manuscript_figures <- function(cells) {
  register_figure_fonts()
  stopifnot(all(substr(ggsci::pal_jama()(3),1,7)==unname(JAMA_ROLES[c('Published','Unassisted','ARBITER')])))
  export_manuscript_figure(study_flow_plot(),'Figure3',120)
  export_manuscript_figure(adjudication_plot(cells),'Figure5',115)
  export_manuscript_figure(published_reference_plot(),'Figure4',160)
  export_manuscript_figure(decisive_question_plot(),'Figure6',210)
  export_manuscript_figure(forest_plot(),'eFigure1',200)
}
adjudication_plot <- function(cells) {
  raw <- manuscript_data('primary-endpoint')
  rows <- c('Both adjudicators agreed','Adjudicator 1','Adjudicator 2','Counting split decisions against ARBITER')
  primary <- raw |> filter(metric=='ARBITER') |> mutate(y=c(7,6,5,4),label=rows)
  counts <- raw |> select(analysis,metric,count,n) |> pivot_wider(names_from=metric,values_from=count) |>
    mutate(text=paste0(ARBITER,' / ',Baseline,' / ',Neither,'; N = ',n))
  primary <- left_join(primary,counts |> select(analysis,text),by='analysis')
  severity <- manuscript_data('severity-win-share') |> filter(metric=='ARBITER') |>
    mutate(y=c(2,1),label=c('ARBITER stricter than Unassisted','ARBITER more lenient'),text=paste0(count,'/',n))
  x <- bind_rows(primary,severity)
  ggplot2::ggplot(x,ggplot2::aes(estimate,y))+
    ggplot2::geom_vline(xintercept=.5,linetype='dashed',color='grey60')+
    ggplot2::geom_hline(yintercept=3.25,color='grey80')+
    ggplot2::geom_errorbar(ggplot2::aes(xmin=lower,xmax=upper),width=.14,color=JAMA_ROLES[['ARBITER']])+
    ggplot2::geom_point(size=2.2,color=JAMA_ROLES[['ARBITER']])+
    ggplot2::geom_text(ggplot2::aes(x=1.04,label=text),hjust=0,size=2.7,family='Fira Sans')+
    ggplot2::annotate('text',x=0,y=2.85,hjust=0,label='Post hoc: by which arm was stricter',fontface='bold',size=2.7,family='Fira Sans')+
    ggplot2::annotate('text',x=1.04,y=7.7,hjust=0,label='ARBITER / Unassisted / neither',size=2.5,family='Fira Sans')+
    ggplot2::scale_y_continuous(breaks=x$y,labels=x$label)+
    ggplot2::scale_x_continuous(breaks=seq(0,1,.25),labels=scales::label_percent())+
    ggplot2::coord_cartesian(xlim=c(0,1.65),ylim=c(.5,8),clip='off')+
    ggplot2::labs(x='Adjudicators chose ARBITER (95% CI)',y=NULL)+theme_manuscript()+
    ggplot2::theme(axis.text.y=ggplot2::element_text(size=7.5),panel.grid.major.x=ggplot2::element_blank())
}
