options(scipen=999)
cost_summary_display <- function(x,side_5m=FALSE) {
  columns <- if(side_5m) grep('^side_5m_',names(x),value=TRUE) else
    grep('^(point|lower|upper|harness)_',names(x),value=TRUE)
  x |> select(arm,all_of(columns)) |>
    rename_with(~sub('^side_5m_','',.x),-arm) |>
    pivot_longer(-arm,names_to=c('Basis','.value'),names_sep='_') |>
    mutate(across(c(total,median),~sprintf('%.2f',.x))) |>
    rename(`Total (USD)`=total,`Median per trial (USD)`=median)
}
table_data <- function(name) readr::read_csv(paste0('output/tables/',name,'.csv'),show_col_types=FALSE)
number <- function(x) ifelse(is.finite(x),sprintf('%.3f',x),'—')
percent <- function(x) ifelse(is.finite(x),sprintf('%.1f%%',100*x),'—')
estimate_ci <- function(x) {
  if(!nrow(x)) return('—')
  paste0(number(x$estimate),' (',number(x$lower),' to ',number(x$upper),')')
}
arm_order <- function(x) {
  if('arm' %in% names(x)) x <- x[order(match(x$arm,c('ARBITER-Sonnet','Baseline-Sonnet','All-Low',
    'ARBITER-Haiku','Baseline-Haiku','Meta'))),,drop=FALSE]
  x
}
format_estimates <- function(x) {
  rate <- rep(FALSE,nrow(x))
  if('metric' %in% names(x)) rate <- x$metric %in% c('accuracy','sensitivity','specificity',
    'ARBITER','Baseline','Neither','Evidence coverage','Bundle verification','share',
    'Structural evidence binding (overall)','Text-span evidence binding','Visual evidence binding',
    'Other evidence records','Trials using visual evidence')
  if(any(c('status','direction','quoted','correct') %in% names(x))) rate[] <- TRUE
  fmt <- function(v) ifelse(rate,percent(v),number(v))
  value <- fmt(x$estimate)
  count_col <- intersect(c('count','quoted','correct'),names(x))
  if(length(count_col) && 'n' %in% names(x)) {
    count <- x[[count_col[1]]]
    has <- rate & !is.na(count) & !is.na(x$n)
    value[has] <- paste0(count[has],'/',x$n[has],' (',value[has],')')
  }
  if(all(c('lower','upper') %in% names(x))) value <- paste0(value,' (',fmt(x$lower),' to ',fmt(x$upper),')')
  value[!is.finite(x$estimate)] <- if('note' %in% names(x)) ifelse(
    !is.na(x$note[!is.finite(x$estimate)]) & x$note[!is.finite(x$estimate)]=='Not available','Not available','—') else '—'
  if('status' %in% names(x)) value[is.na(x$estimate) & x$status %in% c('Evidence coverage','Bundle verification')] <- 'Not available'
  value
}
metric_table <- function(x,ids=c('arm','domain')) {
  x <- arm_order(x)
  x$value <- format_estimates(x)
  x |> select(all_of(ids),metric,value) |> pivot_wider(names_from=metric,values_from=value)
}
show_table <- function(x,caption=NULL) {
  x <- arm_order(x)
  if('estimate' %in% names(x)) {
    value <- format_estimates(x)
    x <- x |> select(-any_of(c('estimate','lower','upper')))
    x[['Estimate (95% CI)']] <- value
  }
  if('share' %in% names(x)) {
    x$share <- if('answers' %in% names(x) && 'arm' %in% names(x)) {
      totals <- ave(x$answers,x$arm,FUN=sum)
      paste0(x$answers,'/',totals,' (',percent(x$share),')')
    } else percent(x$share)
  }
  # Process totals remain available in their native units, displayed without exponents.
  for(n in names(x)) if(is.numeric(x[[n]])) {
    v <- x[[n]]
    x[[n]] <- ifelse(is.na(v),'—',format(v,scientific=FALSE,trim=TRUE,digits=10))
  }
  knitr::kable(x,caption=caption,row.names=FALSE)
}
show_metrics <- function(name,ids=c('arm','domain')) show_table(metric_table(table_data(name),ids))
headline <- function(name,metric_name,arm_name=NULL,domain_name=NULL) {
  d <- table_data(name) |> filter(metric==metric_name)
  if(!is.null(arm_name)) d <- filter(d,arm==arm_name)
  if(!is.null(domain_name)) d <- filter(d,domain==domain_name)
  value <- slice_head(d,n=1)
  if(metric_name %in% c('accuracy','sensitivity','specificity')) format_estimates(value) else estimate_ci(value)
}
