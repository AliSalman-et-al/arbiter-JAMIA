# Display transformations only. Statistical objects and CSVs are never modified.
if(.Platform$OS.type=='windows') Sys.setlocale('LC_CTYPE','English_United States.utf8')
JAMA_ROLES <- c(ARBITER='#00A1D5',Unassisted='#DF8F44',Published='#374E55',
  Split='#D9D9D9',`ARBITER (Haiku 5.5)`='#80D0EA',`Unassisted (Haiku 5.5)`='#EFC7A2')

reader_label <- function(x, supplement=FALSE) {
  replacements <- c('ARBITER-Sonnet'=if(supplement) 'ARBITER (Sonnet 5.5)' else 'ARBITER',
    'Baseline-Sonnet'=if(supplement) 'Unassisted (Sonnet 5.5)' else 'Unassisted',
    'ARBITER-Haiku'='ARBITER (Haiku 5.5)','Baseline-Haiku'='Unassisted (Haiku 5.5)',
    'A vs Z'='Adjudicator 1 vs Adjudicator 2','Adjudicator A'='Adjudicator 1',
    'Adjudicator Z'='Adjudicator 2','A independent'='Adjudicator 1 independent',
    'Z independent'='Adjudicator 2 independent','Baseline imbalance'='Preintervention imbalance','meta-label'='published-label',
    'Meta label'='Published label','meta label'='published label','Baseline'='Unassisted',
    'All-Low'='All-Low rule')
  for(k in names(replacements)) x <- gsub(k,replacements[[k]],x,fixed=TRUE)
  x <- gsub('All-Low rule rule','All-Low rule',x,fixed=TRUE)
  x[x=='Meta'] <- 'Published'; x[x=='A'] <- 'Adjudicator 1'; x[x=='Z'] <- 'Adjudicator 2'
  x
}
fmt_number <- function(x,digits=2L) {
  out <- ifelse(is.finite(x),sprintf(paste0('%.',digits,'f'),x),'\u2014')
  out <- sub('^-','\u2212',out)
  out[out==paste0('\u2212',sprintf(paste0('%.',digits,'f'),0))] <- sprintf(paste0('%.',digits,'f'),0)
  out
}
fmt_ci <- function(lower,upper,digits=2L) {
  sep <- ifelse(lower<0 | upper<0,' to ','\u2013')
  out <- paste0('(',fmt_number(lower,digits),sep,fmt_number(upper,digits),')')
  out[!is.finite(lower)|!is.finite(upper)] <- '\u2014'; out
}
fmt_fraction <- function(n,N) {
  out <- paste0(n,'/',N,' (',fmt_number(100*n/N,1),'%)')
  out[!is.finite(n)|!is.finite(N)|N<=0] <- '\u2014'; out
}
fmt_estimate <- function(x,proportion=FALSE) {
  out <- fmt_number(x$estimate)
  if(proportion && all(c('count','n') %in% names(x))) out <- fmt_fraction(x$count,x$n)
  value <- paste0(out,' ',fmt_ci(x$lower,x$upper))
  value[!is.finite(x$estimate)] <- '\u2014'; value
}
display_frame <- function(x,supplement=TRUE) {
  x <- as.data.frame(x)
  for(n in names(x)) {
    if(is.character(x[[n]]) || is.factor(x[[n]])) x[[n]] <- reader_label(as.character(x[[n]]),supplement)
    else if(is.numeric(x[[n]])) x[[n]] <- vapply(x[[n]],function(v)
      if(!is.finite(v)) '\u2014' else if(v==trunc(v)) format(v,trim=TRUE,scientific=FALSE,big.mark=',') else fmt_number(v,2),character(1))
    x[[n]][is.na(x[[n]])] <- '\u2014'
  }
  names(x) <- reader_label(names(x),supplement)
  x
}
house_table <- function(x,footnote=NULL,width=6.85) {
  ft <- flextable::flextable(x) |>
    flextable::font(fontname='Arial',part='all') |>
    flextable::fontsize(size=9,part='all') |>
    flextable::border_remove() |>
    flextable::hline_top(part='header',border=officer::fp_border(width=1)) |>
    flextable::hline_bottom(part='header',border=officer::fp_border(width=.6)) |>
    flextable::hline_bottom(part='body',border=officer::fp_border(width=1)) |>
    flextable::bold(part='header') |>
    flextable::padding(padding=3,part='all') |>
    flextable::valign(valign='top',part='all') |>
    flextable::align(align='left',part='all') |>
    flextable::autofit() |>
    flextable::width(width=width/ncol(x)) |>
    flextable::fontsize(size=9,part='all') |>
    flextable::set_table_properties(layout='fixed',opts_word=list(split=FALSE,repeat_headers=TRUE))
  if(!is.null(footnote)) ft <- ft |> flextable::add_footer_lines(footnote) |>
    flextable::font(fontname='Arial',part='footer') |>
    flextable::fontsize(size=9,part='footer')
  ft
}
manuscript_doc <- function() {
  doc <- officer::read_docx() |>
    officer::docx_set_paragraph_style('ManuscriptBody','Manuscript body',fp_t=officer::fp_text(font.family='Arial',font.size=10)) |>
    officer::docx_set_paragraph_style('Titre1','heading 1',fp_p=officer::fp_par(keep_with_next=TRUE,padding.top=8,padding.bottom=6),
      fp_t=officer::fp_text(font.family='Arial',font.size=12,bold=TRUE)) |>
    officer::docx_set_paragraph_style('Titre2','heading 2',fp_p=officer::fp_par(keep_with_next=TRUE,padding.top=6,padding.bottom=4),
      fp_t=officer::fp_text(font.family='Arial',font.size=10,bold=TRUE))
  officer::body_set_default_section(doc,officer::prop_section(
    page_size=officer::page_size(width=8.27,height=11.69),
    page_margins=officer::page_mar(top=.6,bottom=.6,left=.65,right=.65)))
}
manuscript_par <- function(x,value,style='Manuscript body') officer::body_add_par(x,value,style=style)
write_word_table <- function(x,file,caption,footnote) {
  doc <- manuscript_doc() |> officer::body_add_par(caption,style='heading 1') |>
    flextable::body_add_flextable(house_table(x,footnote))
  print(doc,target=file)
}
register_figure_fonts <- function() {
  fonts <- c('Fira Sans','Fira Sans Condensed')
  paths <- c('assets/fonts/FiraSans-Regular.ttf','assets/fonts/FiraSansCondensed-Regular.ttf')
  stopifnot(all(file.exists(paths)))
  installed <- unique(systemfonts::system_fonts()$family)
  if(!fonts[1] %in% installed) systemfonts::register_font(fonts[1],plain=paths[1],bold='assets/fonts/FiraSans-Bold.ttf')
  if(!fonts[2] %in% installed) systemfonts::register_font(fonts[2],plain=paths[2])
  # Cairo PDF needs installed fonts; the installer installs these same vendored bytes.
  invisible(fonts)
}
theme_manuscript <- function() {
  ggplot2::theme_minimal(base_size=9,base_family='Fira Sans') + ggplot2::theme(
    panel.grid.minor=ggplot2::element_blank(),panel.grid.major.y=ggplot2::element_blank(),
    axis.text=ggplot2::element_text(size=8,color='black'),
    strip.text=ggplot2::element_text(size=9,face='bold'),
    legend.text=ggplot2::element_text(size=8),legend.position='bottom',
    plot.tag=ggplot2::element_text(face='bold',size=11),
    plot.margin=ggplot2::margin(8,8,8,8))
}
