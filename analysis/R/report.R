table_data <- function(name) readr::read_csv(paste0('output/tables/',name,'.csv'),show_col_types=FALSE)
number <- function(x) ifelse(is.finite(x),sprintf('%.3f',x),'—')
percent <- function(x) sprintf('%.1f%%',100*x)
estimate_ci <- function(x) {
  if(!nrow(x)) return('—')
  paste0(number(x$estimate),' (',number(x$lower),' to ',number(x$upper),')')
}
metric_table <- function(x,ids=c('arm','domain')) {
  x |> mutate(value=if_else(is.na(estimate),'—',paste0(number(estimate),
    ' (',number(lower),' to ',number(upper),')'))) |>
    select(all_of(ids),metric,value) |> pivot_wider(names_from=metric,values_from=value)
}
show_table <- function(x,caption=NULL) knitr::kable(x,caption=caption,row.names=FALSE)
show_metrics <- function(name,ids=c('arm','domain')) show_table(metric_table(table_data(name),ids))
headline <- function(name,metric_name,arm_name=NULL,domain_name=NULL) {
  d <- table_data(name) |> filter(metric==metric_name)
  if(!is.null(arm_name)) d <- filter(d,arm==arm_name)
  if(!is.null(domain_name)) d <- filter(d,domain==domain_name)
  estimate_ci(slice_head(d,n=1))
}
