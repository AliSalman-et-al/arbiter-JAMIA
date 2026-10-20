# Post hoc estimands. Inputs and the original discordant population stay fixed.
rules_only_labels <- function(labels,checks) {
  replacements <- checks |> filter(arm=='Baseline-Sonnet',status=='Violation') |>
    select(arm,slug,domain,replacement=algorithm)
  labels |> left_join(replacements,by=c('arm','slug','domain')) |>
    mutate(label=coalesce(replacement,label)) |> select(-replacement)
}
unweighted_kappa <- function(counts) {
  p <- counts/rowSums(counts)
  rows <- matrix(sapply(1:3,function(i) rowSums(p[,i+3*(0:2),drop=FALSE])),ncol=3)
  cols <- matrix(sapply(1:3,function(i) rowSums(p[,(1:3)+3*(i-1),drop=FALSE])),ncol=3)
  expected <- rowSums(rows*cols)
  out <- (exact_accuracy(counts)-expected)/(1-expected)
  out[!is.finite(out)] <- NA_real_
  out
}
unweighted_agreement <- function(labels,weights) {
  bind_rows(lapply(names(ARMS),function(a) bind_rows(lapply(c(paste0('D',1:5),'Overall'),function(g) {
    z <- labels |> filter(arm==a,domain==g,!is.na(meta))
    code <- match(z$meta,LABELS)+3*(match(z$label,LABELS)-1)
    w <- bootstrap_rows(z,weights)
    counts <- sapply(1:9,function(k) as.numeric(crossprod(as.numeric(code==k),w)))
    interval_table(rbind(kappa=unweighted_kappa(counts),accuracy=exact_accuracy(counts))) |>
      mutate(arm=a,domain=g,n=nrow(z),count=if_else(metric=='accuracy',sum(z$label==z$meta),NA_integer_),analysis='Post hoc')
  }))))
}
