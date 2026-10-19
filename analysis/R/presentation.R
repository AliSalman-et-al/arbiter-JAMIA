# Display transformations only. Statistical objects and CSVs are never modified.
if(.Platform$OS.type=='windows') Sys.setlocale('LC_CTYPE','English_United States.utf8')
JAMA_ROLES <- c(ARBITER='#00A1D5',Unassisted='#DF8F44',Published='#374E55',
  Split='#D9D9D9')

reader_answer <- function(x) {
  labels <- c(yes='Yes',no='No',probably_yes='Probably yes',probably_no='Probably no',
    no_information='No information',not_applicable='Not applicable',not_asked='Not asked')
  result <- unname(labels[x])
  if(anyNA(result)) stop('Unknown signalling-answer code: ',paste(x[is.na(result)],collapse=', '))
  result
}

# Only literal filenames, tool names and evidence handles may retain underscores.
raw_reader_codes <- function(text) {
  text <- gsub('\\b[A-Za-z0-9_.-]+[.](pdf|csv|json|jsonl|md|txt|R|py|docx|png|tiff)\\b','',text,perl=TRUE)
  tokens <- unique(unlist(regmatches(text,gregexpr('\\b[A-Za-z][A-Za-z0-9]*_[A-Za-z0-9_]+\\b',text,perl=TRUE))))
  tokens <- setdiff(tokens,c('test_dir','save_domain_judgment','capture_source','create_evidence',
    'propose_result','approve_result','save_signalling_answer','verify_bundle',
    # ARBITER MCP tool names cited in the Figure 1 legend
    'prepare_batch','list_sources','search_sources','search_sources_batch','validate_proposal',
    'save_proposal','get_domain_context','read_pages','render_page','select_text_evidence',
    'select_visual_evidence','review_trial','finalize_batch'))
  tokens[!grepl('^eh_[a-f0-9]+$',tokens)]
}

reader_html_text <- function(path) {
  html <- xml2::read_html(path)
  xml2::xml_remove(xml2::xml_find_all(html,'//script|//style'))
  # Preserve boundaries between table cells and paragraphs. Body text alone
  # joins neighbouring cells, manufacturing tokens such as "Yeseh_…".
  xml2::xml_text(xml2::xml_find_all(html,'//body//p|//body//td|//body//th|//body//h1|//body//h2|//body//h3|//body//h4|//body//pre|//body//li'))
}

reader_label <- function(x, supplement=FALSE) {
  replacements <- c('ARBITER more severe'='ARBITER stricter than Unassisted',
    'ARBITER less severe'='ARBITER more lenient than Unassisted',
    'More severe'='Stricter','Less severe'='More lenient',
    'Split sensitivity'='Counting split decisions against ARBITER','Algorithm violation'='Rating contradicts its own answers',
    'Invalid answer path'='Required question skipped','Any departure'='Any rule break',
    'consensus cells'='cells where both adjudicators agreed','split cells'='cells where adjudicators split',
    'Consensus losses'='Ratings not chosen by either adjudicator','Not Low'='Some concerns or High','not low'='Some concerns or High',
    'consensus preferred judgement'='the adjudicators’ agreed choice',
    'consensus preferred'='the adjudicators’ agreed choice',
    'preferred judgement'='the adjudicators’ agreed choice',
    'discordant cells'='cells where the two arms disagreed','discordant'='differing',
    'Vindicated'='Adjudicators agreed with it','vindicated'='adjudicators agreed with it',
    'Decisive-question'='Questions that alone changed the rating:',
    'individually decisive questions'='questions that alone changed the rating',
    'single decisive question'='one question alone changed the rating',
    'several decisive questions'='several questions each changed the rating alone',
    'decisive questions'='questions that alone changed the rating',
    'decisive question'='question that alone changed the rating','ARBITER-Sonnet'=if(supplement) 'ARBITER (Sonnet 5.5)' else 'ARBITER',
    'Baseline-Sonnet'=if(supplement) 'Unassisted (Sonnet 5.5)' else 'Unassisted',
    'A vs Z'='Adjudicator 1 vs Adjudicator 2','Adjudicator A'='Adjudicator 1',
    'Adjudicator Z'='Adjudicator 2','A independent'='Adjudicator 1 independent',
    'Z independent'='Adjudicator 2 independent','Baseline imbalance'='Preintervention imbalance','meta-label'='published-label',
    'meta_ids'='meta-analysis identifiers','no_information'='No information',
    'probably_yes'='Probably yes','probably_no'='Probably no','not_applicable'='Not applicable',
    'some_concerns'='Some concerns','direct_support'='direct support',
    'Meta label'='Published label','meta label'='published label','Baseline'='Unassisted',
    'All-Low'='All-Low rule')
  for(k in names(replacements)) x <- gsub(k,replacements[[k]],x,fixed=TRUE)
  x <- gsub('All-Low rule rule','All-Low rule',x,fixed=TRUE)
  x <- gsub('D1-D5','D1\u2013D5',x,fixed=TRUE)
  x[x=='kappa'] <- 'Weighted κ'; x[x=='accuracy'] <- 'Exact agreement'
  x[x=='sensitivity'] <- 'Sensitivity'; x[x=='specificity'] <- 'Specificity'; x[x=='share'] <- 'Share'
  x[x=='Consensus'] <- 'Both adjudicators agreed'
  x[x=='Meta'] <- 'Published'; x[x=='A'] <- 'Adjudicator 1'; x[x=='Z'] <- 'Adjudicator 2'
  x
}
fmt_number <- function(x,digits=2L) {
  out <- ifelse(is.finite(x),sprintf(paste0('%.',digits,'f'),x),'\u2014')
  out <- sub('^-','\u2212',out)
  out[out==paste0('\u2212',sprintf(paste0('%.',digits,'f'),0))] <- sprintf(paste0('%.',digits,'f'),0)
  out
}
fmt_ci <- function(lower,upper,digits=2L,suppress_degenerate=FALSE) {
  sep <- ifelse(lower<0 | upper<0,' to ','\u2013')
  out <- paste0('(',fmt_number(lower,digits),sep,fmt_number(upper,digits),')')
  if(suppress_degenerate) out[is.finite(lower) & is.finite(upper) &
    fmt_number(lower,digits)==fmt_number(upper,digits)] <- ''
  out[!is.finite(lower)|!is.finite(upper)] <- '\u2014'; out
}
fmt_fraction <- function(n,N) {
  out <- paste0(n,'/',N,' (',fmt_number(100*n/N,1),'%)')
  out[!is.finite(n)|!is.finite(N)|N<=0] <- '\u2014'; out
}
fmt_process_text <- function(x) {
  x <- gsub('\\(([0-9.,]+) to ([0-9.,]+)\\)','(\\1\u2013\\2)',x)
  x <- gsub('\\[([0-9.,]+) to ([0-9.,]+)\\]','[\\1\u2013\\2]',x)
  x <- sub('^-([0-9])','\u2212\\1',x)
  gsub('([ (])-([0-9])','\\1\u2212\\2',x)
}
fmt_estimate <- function(x,proportion=FALSE) {
  out <- fmt_number(x$estimate)
  if(proportion) {
    out <- if(all(c('count','n') %in% names(x))) fmt_fraction(x$count,x$n) else paste0(fmt_number(100*x$estimate,1),'%')
  }
  value <- trimws(paste0(out,' ',fmt_ci(x$lower*if(proportion) 100 else 1,x$upper*if(proportion) 100 else 1,if(proportion) 1L else 2L,
    suppress_degenerate=proportion)))
  if(proportion) value <- gsub('%) (', '%; ',value,fixed=TRUE)
  value[!is.finite(x$estimate)] <- '\u2014'; value
}
display_frame <- function(x,supplement=TRUE) {
  x <- as.data.frame(x)
  for(n in names(x)) {
    if(is.character(x[[n]]) || is.factor(x[[n]])) x[[n]] <- fmt_process_text(reader_label(as.character(x[[n]]),supplement))
    else if(is.numeric(x[[n]])) x[[n]] <- vapply(x[[n]],function(v)
      if(!is.finite(v)) '\u2014' else if(n=='question') sprintf('%.1f',v)
      else if(v==trunc(v)) fmt_process_text(format(v,trim=TRUE,scientific=FALSE,big.mark=',')) else fmt_number(v,2),character(1))
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
  flextable::paginate(ft,init=FALSE,hdr_ftr=TRUE)
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
  if(!fonts[2] %in% installed) systemfonts::register_font(fonts[2],plain=paths[2],bold='assets/fonts/FiraSansCondensed-Bold.ttf')
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

# A block row is a display object, with no estimand attached.
group_row <- function(x,label) {
  header <- x[1,,drop=FALSE]; header[] <- ''; header[[1]] <- label
  dplyr::bind_rows(header,x)
}
style_group_rows <- function(ft,x) {
  rows <- which(apply(as.data.frame(x)[,-1,drop=FALSE],1,function(v) all(is.na(v)|v=='')))
  for(r in rows) ft <- flextable::merge_at(ft,i=r,j=seq_len(ncol(x)),part='body')
  if(length(rows)) ft <- flextable::bold(ft,i=rows,part='body')
  ft
}
