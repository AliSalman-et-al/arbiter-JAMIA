# Display transformations only. Statistical objects and CSVs are never modified.
if(.Platform$OS.type=='windows') Sys.setlocale('LC_CTYPE','English_United States.utf8')
JAMA_ROLES <- c(ARBITER='#00A1D5',Unassisted='#DF8F44',Published='#4D4D4D',
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
    'consensus cells'='cells where both experts agreed','split cells'='cells where experts split',
    'Consensus losses'='Ratings not chosen by either expert','Not Low'='Some concerns or High','not low'='Some concerns or High',
    'consensus preferred judgement'='the experts’ agreed choice',
    'consensus preferred'='the experts’ agreed choice',
    'preferred judgement'='the experts’ agreed choice',
    'discordant cells'='cells where the two arms disagreed','discordant'='differing',
    'ARBITER-Sonnet'=if(supplement) 'ARBITER (Sonnet 5.5)' else 'ARBITER',
    'Baseline-Sonnet'=if(supplement) 'Unassisted (Sonnet 5.5)' else 'Unassisted',
    'Baseline imbalance'='Preintervention imbalance','meta-label'='published-label',
    'meta_ids'='meta-analysis identifiers','no_information'='No information',
    'probably_yes'='Probably yes','probably_no'='Probably no','not_applicable'='Not applicable',
    'some_concerns'='Some concerns','direct_support'='direct support',
    'Meta label'='Published label','meta label'='published label','Baseline'='Unassisted',
    'All-Low'='All-Low rule')
  for(k in names(replacements)) x <- gsub(k,replacements[[k]],x,fixed=TRUE)
  x <- gsub('Expert-to-expert','Between human reviews',x,fixed=TRUE)
  x <- gsub('expert-to-expert','between human reviews',x,fixed=TRUE)
  x <- gsub('Expert-specific','Review-specific',x,fixed=TRUE)
  x <- gsub('expert-specific','review-specific',x,fixed=TRUE)
  x <- gsub('Expert 1','Human Review 1',x,fixed=TRUE)
  x <- gsub('Expert 2','Human Review 2',x,fixed=TRUE)
  x <- gsub('Experts 1 and 2','Human Reviews 1 and 2',x,fixed=TRUE)
  x <- gsub('\\bexperts\\b','human reviewers',x,perl=TRUE)
  x <- gsub('\\bexpert\\b','human reviewer',x,perl=TRUE)
  x <- gsub('\\bExperts\\b','Human reviewers',x,perl=TRUE)
  x <- gsub('\\bExpert\\b','Human reviewer',x,perl=TRUE)
  x <- gsub('an human reviewer','a human reviewer',x,fixed=TRUE)
  x <- gsub('All-Low rule rule','All-Low rule',x,fixed=TRUE)
  x <- gsub('D1-D5','D1\u2013D5',x,fixed=TRUE)
  x[x=='kappa'] <- 'Weighted κ'; x[x=='accuracy'] <- 'Exact agreement'
  x[x=='sensitivity'] <- 'Sensitivity'; x[x=='specificity'] <- 'Specificity'; x[x=='share'] <- 'Share'
  x[x=='Consensus'] <- 'Both human reviewers agreed'
  x[x=='Meta'] <- 'Published'
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
# JAMA frequency precision is determined by the actual denominator. Paired
# percentage-point effects and ordinal coefficients keep their own precision.
fmt_percent <- function(x,n,digits=1L) {
  m <- max(length(x),length(n));x <- rep_len(x,m);n <- rep_len(n,m)
  vapply(seq_len(m),function(i) fmt_number(100*x[i],if(is.finite(n[i]) && n[i]<100) 0L else digits),character(1))
}
fmt_percent_ci <- function(lower,upper,n) {
  m <- max(length(lower),length(upper),length(n));lower<-rep_len(lower,m);upper<-rep_len(upper,m);n<-rep_len(n,m)
  vapply(seq_len(m),function(i) fmt_ci(100*lower[i],100*upper[i],if(is.finite(n[i]) && n[i]<100) 0L else 1L),character(1))
}
fmt_fraction <- function(n,N) {
  out <- paste0(format(n,trim=TRUE,scientific=FALSE,big.mark=','),'/',format(N,trim=TRUE,scientific=FALSE,big.mark=','),' (',fmt_percent(n/N,N),'%)')
  out[!is.finite(n)|!is.finite(N)|N<=0] <- '\u2014'; out
}
fmt_process_text <- function(x) {
  x <- gsub('\\(([0-9.,]+) to ([0-9.,]+)\\)','(\\1\u2013\\2)',x)
  x <- gsub('\\[([0-9.,]+) to ([0-9.,]+)\\]','[\\1\u2013\\2]',x)
  x <- sub('^-([0-9])','\u2212\\1',x)
  x <- gsub('([ (])-([0-9])','\\1\u2212\\2',x)
  x <- gsub('[IQR]','(IQR)',x,fixed=TRUE)
  gsub('\\[([0-9.,]+)[–-]([0-9.,]+)\\]','(\\1–\\2)',x)
}
fmt_estimate <- function(x,proportion=FALSE) {
  if(proportion) {
    n <- if('n' %in% names(x)) x$n else rep(NA_real_,nrow(x))
    out <- if(all(c('count','n') %in% names(x))) ifelse(is.finite(x$count),fmt_fraction(x$count,x$n),paste0(fmt_percent(x$estimate,n),'%')) else paste0(fmt_percent(x$estimate,n),'%')
    value <- paste0(out,' ',fmt_percent_ci(x$lower,x$upper,n))
    value <- gsub('%) (','%; ',value,fixed=TRUE)
  } else value <- paste0(fmt_number(x$estimate),' ',fmt_ci(x$lower,x$upper))
  value[!is.finite(x$estimate)] <- '—';trimws(value)
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
# Shared native gt presentation. Both exports are made from these objects.
reader_table <- function(x) {
  for(k in names(x)) if(is.character(x[[k]])) x[[k]] <- reader_label(x[[k]])
  names(x) <- reader_label(names(x))
  x
}
house_table <- function(x,footnote=NULL,width=6.85) {
  x <- as.data.frame(reader_table(x),check.names=FALSE)
  if(!is.null(footnote)) footnote <- reader_label(footnote)
  for(k in names(x)) if(is.logical(x[[k]])) x[[k]] <- ifelse(x[[k]],'Yes','No')
  groups <- which(apply(x[,-1,drop=FALSE],1,function(v) all(is.na(v)|v=='')))
  if(length(groups)) {
    labels <- rep('',nrow(x)); current <- ''
    for(i in seq_len(nrow(x))) { if(i %in% groups) current <- x[[1]][i]; labels[i] <- current }
    x$.section <- labels; x <- x[-groups,,drop=FALSE]
    tab <- gt::gt(x,rowname_col=names(x)[1],groupname_col='.section')
  } else tab <- gt::gt(x,rowname_col=names(x)[1])
  cols <- setdiff(names(x),c(names(x)[1],'.section'))
  numeric <- cols[vapply(x[cols],function(v) mean(grepl('^[−+0-9—]|^Not available$|^Yes$|^No$',as.character(v)))>.75,logical(1))]
  tab <- tab |> gt::tab_options(table.font.names='Arial',table.font.size='10pt',
    table.width=gt::px(width*96),data_row.padding=gt::px(4),column_labels.padding=gt::px(5),
    data_row.padding.horizontal=gt::px(8),column_labels.padding.horizontal=gt::px(8),
    table.border.top.width=gt::px(1),table.border.bottom.width=gt::px(1),table.border.top.color='#444444',table.border.bottom.color='#444444',
    table.border.left.style='none',table.border.right.style='none',
    table_body.hlines.style='none',table_body.vlines.style='none',stub.border.style='none',
    column_labels.vlines.style='none',column_labels.border.lr.style='none',
    row_group.border.left.style='none',row_group.border.right.style='none',
    source_notes.border.lr.style='none',source_notes.border.bottom.style='none',
    column_labels.font.weight='bold',
    column_labels.border.bottom.width=gt::px(1),table_body.hlines.width=gt::px(0),
    row_group.background.color='#F4F4F4',row_group.font.weight='bold',
    source_notes.font.size='10pt',source_notes.padding=gt::px(4)) |>
    gt::cols_align('left',columns=gt::everything()) |> gt::tab_stubhead(label=names(x)[1])
  if(length(numeric)) tab <- gt::cols_align(tab,'right',columns=tidyselect::all_of(numeric))
  # Preserve native gt alignment and gutters under Quarto/Bootstrap table rules.
  tab <- gt::opt_css(tab,css=paste(
    '.gt_table .gt_row, .gt_table .gt_col_heading { padding-left: 8px !important; padding-right: 8px !important; }',
    '.gt_table .gt_right { text-align: right !important; }',
    '.gt_table .gt_left { text-align: left !important; }',
    '.gt_table .gt_center { text-align: center !important; }'))
  visible <- setdiff(names(x),'.section')
  weights <- vapply(x[visible],function(v) min(50,max(8,as.numeric(stats::quantile(nchar(as.character(v)),.8,na.rm=TRUE)))),numeric(1))
  weights <- pmax(weights,pmin(nchar(visible),25))
  if(length(visible)==2) weights <- c(34,66)
  # Column roles, rather than short cell strings, set widths in result matrices.
  if(all(c('Exact agreement (95% CI)','Weighted κ (95% CI)') %in% visible)) weights <- c(.85,.9,1.4,.4,1.75,1.55)
  else if(all(c('Sensitivity','Specificity') %in% visible)) weights <- c(1.05,.75,.9,.8,1.1,1.15,1.1)
  else if(all(c('Low','Some concerns','High','Missing') %in% visible))
    weights <- c(Reference=1,Source=1.1,`Human reviewer rating`=1.2,Low=.6,`Some concerns`=.9,High=.6,Missing=.6)[visible]
  else if('Recomputed' %in% visible) weights <- c(.95,.7,1.05,1.15,1.65,1.4)
  else if('Original violations' %in% visible) weights <- c(1.15,.4,.95,.8,.95,.75,.85,1.0)
  else if(all(c('Analysis','Metric','Count','N','Value') %in% visible)) weights <- c(2.1,2,.5,.5,1.75)
  else if(all(c('Expert','Source','Domain','Metric','Count','N','Value') %in% visible)) weights <- c(.65,1.15,.75,1.0,.6,.4,2.3)
  else if(all(c('Expert','Comparison','Domain','Metric','N','Value') %in% visible)) weights <- c(.65,1.8,.75,1.0,.4,2.25)
  else if(all(c('Expert','Source','Domain','Metric','N','Value') %in% visible)) weights <- c(.65,1.1,.8,1.0,.4,2.9)
  else if(all(c('Expert','Source','Metric','Direction','Outcome','Count','N','Value') %in% visible)) weights <- c(.65,1,.65,.8,1.3,.6,.4,1.45)
  else if('Specialty' %in% visible) weights <- c(1.25,1.25,2,.55,1.2,.6)
  else if('Guideline' %in% visible) weights <- c(.75,.45,1,3.1,1.55)
  else {
    # Reserve readable identifier gutters, then distribute the remaining width.
    minimum <- ifelse(visible %in% c('N','Item'),.45,
      ifelse(visible %in% c('Count','Trials','Expert'),.65,ifelse(visible %in% c('Domain','Group','Population'),.8,.85)))
    weights <- pmax(width*weights/sum(weights),minimum)
  }
  widths <- lapply(100*weights/sum(weights),gt::pct);names(widths)<-visible
  tab <- gt::cols_width(tab,.list=lapply(seq_along(widths),function(i) rlang::new_formula(rlang::sym(names(widths)[i]),widths[[i]])))
  if(all(c('Low','Some concerns','High','Missing') %in% names(x)))
    tab <- gt::tab_spanner(tab,label='Source prediction (cell counts)',columns=tidyselect::all_of(c('Low','Some concerns','High','Missing')))
  if(!is.null(footnote) && nzchar(footnote)) tab <- gt::tab_source_note(tab,footnote)
  attr(tab,'publication_widths') <- unname(weights/sum(weights)*width*1440)
  attr(tab,'publication_groups') <- if(length(groups)) unique(labels) else character()
  attr(tab,'publication_note') <- footnote
  tab
}
# gt 1.4.0's Word adapter omits width/padding settings and hard-codes
# single cell borders. Apply the gt design to its native OOXML at this boundary.
# No table content is rebuilt or converted from HTML.
add_gt <- function(doc,tab) {
  stopifnot(inherits(tab,'gt_tbl'))
  ns <- 'http://schemas.openxmlformats.org/wordprocessingml/2006/main'
  raw <- paste0('<root xmlns:w="',ns,'">',gt::as_word(tab,split=FALSE,keep_with_next=FALSE),'</root>')
  root <- xml2::read_xml(raw)
  table <- xml2::xml_find_first(root,'.//w:tbl')
  props <- xml2::xml_find_first(table,'w:tblPr')
  xml2::xml_remove(xml2::xml_find_all(props,'w:tblW|w:tblLayout'))
  widths <- round(attr(tab,'publication_widths'))
  xml2::xml_add_child(props,'w:tblW',`w:type`='dxa',`w:w`=as.character(sum(widths)))
  xml2::xml_add_child(props,'w:tblLayout',`w:type`='fixed')
  grid <- xml2::xml_add_child(table,'w:tblGrid',.where=1)
  for(w in widths) xml2::xml_add_child(grid,'w:gridCol',`w:w`=as.character(w))
  rows <- xml2::xml_find_all(table,'w:tr')
  for(i in seq_along(rows)) {
    row <- rows[[i]]; cells <- xml2::xml_find_all(row,'w:tc')
    txt <- paste(xml2::xml_text(xml2::xml_find_all(row,'.//w:t')),collapse='')
    note <- !is.null(attr(tab,'publication_note')) && identical(txt,attr(tab,'publication_note'))
    header <- length(xml2::xml_find_all(row,'w:trPr/w:tblHeader'))>0
    group <- txt %in% attr(tab,'publication_groups')
    column <- 1L
    for(cell in cells) {
      cp <- xml2::xml_find_first(cell,'w:tcPr')
      if(inherits(cp,'xml_missing')) cp <- xml2::xml_add_child(cell,'w:tcPr',.where=0)
      span <- as.integer(xml2::xml_attr(xml2::xml_find_first(cp,'w:gridSpan'),'val'))
      if(is.na(span)) span <- 1L
      xml2::xml_remove(xml2::xml_find_all(cp,'w:tcW|w:tcBorders|w:tcMar'))
      ix <- seq.int(column,min(length(widths),column+span-1L))
      xml2::xml_add_child(cp,'w:tcW',`w:type`='dxa',`w:w`=as.character(sum(widths[ix])))
      column <- column+span
      mar <- xml2::xml_add_child(cp,'w:tcMar')
      for(side in c('top','bottom','start','end')) xml2::xml_add_child(mar,paste0('w:',side),`w:type`='dxa',`w:w`=if(side %in% c('top','bottom')) '35' else '70')
      borders <- xml2::xml_add_child(cp,'w:tcBorders')
      for(side in c('top','bottom','start','end')) {
        rule <- !note && ((header && side %in% c('top','bottom')) || (group && side=='top'))
        xml2::xml_add_child(borders,paste0('w:',side),`w:val`=if(rule) 'single' else 'nil',`w:sz`=if(rule) '6' else '0',`w:color`='666666')
      }
      if(group) xml2::xml_add_child(cp,'w:shd',`w:fill`='F4F4F4')
      for(run in xml2::xml_find_all(cell,'.//w:r')) {
        rp <- xml2::xml_find_first(run,'w:rPr')
        if(inherits(rp,'xml_missing')) rp <- xml2::xml_add_child(run,'w:rPr',.where=0)
        xml2::xml_remove(xml2::xml_find_all(rp,'w:sz|w:rFonts'))
        xml2::xml_add_child(rp,'w:rFonts',`w:ascii`='Arial',`w:hAnsi`='Arial')
        xml2::xml_add_child(rp,'w:sz',`w:val`='20')
        if(header || group) xml2::xml_add_child(rp,'w:b')
      }
    }
  }
  officer::body_add_xml(doc,paste(vapply(xml2::xml_children(root),as.character,character(1)),collapse=''))
}
manuscript_doc <- function() {
  doc <- officer::read_docx() |>
    officer::docx_set_paragraph_style('ManuscriptBody','Manuscript body',fp_p=officer::fp_par(line_spacing=1.3,padding.bottom=5),fp_t=officer::fp_text(font.family='Arial',font.size=10)) |>
    officer::docx_set_paragraph_style('Titre1','heading 1',fp_p=officer::fp_par(keep_with_next=TRUE,padding.top=8,padding.bottom=6),fp_t=officer::fp_text(font.family='Arial',font.size=12,bold=TRUE,color='black')) |>
    officer::docx_set_paragraph_style('Titre2','heading 2',fp_p=officer::fp_par(keep_with_next=TRUE,padding.top=6,padding.bottom=4),fp_t=officer::fp_text(font.family='Arial',font.size=10,bold=TRUE,color='black'))
  officer::body_set_default_section(doc,officer::prop_section(
    page_size=officer::page_size(width=8.27,height=11.69),
    page_margins=officer::page_mar(top=.6,bottom=.6,left=.65,right=.65)))
}
manuscript_par <- function(x,value,style='Manuscript body') {
  value <- reader_label(value)
  if(grepl('heading',style)) value <- sub('^(e?Table [0-9]+[A-C]?|e?Figure [0-9]+) ','\\1. ',value)
  officer::body_add_par(x,value,style=style)
}
replace_generated_file <- function(staged,target) {
  python <- Sys.getenv('ARBITER_PYTHON',unset=Sys.which('python'))
  stopifnot(nzchar(python),system2(python,c('-c',
    shQuote('import os,sys; os.replace(sys.argv[1],sys.argv[2])'),
    shQuote(normalizePath(staged,winslash='/',mustWork=TRUE)),
    shQuote(normalizePath(target,winslash='/',mustWork=FALSE))))==0L)
}
save_manuscript_doc <- function(doc,target) {
  staged <- tempfile(tmpdir=dirname(target),fileext='.docx')
  on.exit(unlink(staged))
  print(doc,target=staged)
  replace_generated_file(staged,target)
}
write_word_table <- function(x,file,caption,footnote) {
  tab <- house_table(x,footnote)
  doc <- manuscript_doc() |> manuscript_par(caption,style='heading 1') |> add_gt(tab)
  save_manuscript_doc(doc,file)
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
