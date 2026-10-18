has_quotation <- function(text) {
  unname(vapply(text,function(s) {
    if(is.na(s)) return(FALSE)
    quotes <- regmatches(s,gregexpr('"[^"\\r\\n]+"|\u201c[^\u201d\\r\\n]+\u201d',s,perl=TRUE))[[1]]
    any(vapply(quotes,function(q) {
      q <- substring(q,2,nchar(q)-1)
      length(strsplit(trimws(q),'\\s+',perl=TRUE)[[1]])>=5
    },logical(1)))
  },logical(1)))
}

grounding_share <- function(signals,weights) {
  signals <- signals |> filter(active)
  interval_table(share_estimate(signals,has_quotation(signals$justification),weights)) |>
    mutate(n=nrow(signals),quoted=sum(has_quotation(signals$justification)))
}

