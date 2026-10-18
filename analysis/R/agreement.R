linear_weights <- function() 1-abs(outer(1:3,1:3,'-'))/2

weighted_kappa <- function(counts) {
  n <- rowSums(counts)
  p <- counts/n
  rows <- matrix(sapply(1:3,function(i) rowSums(p[,i+3*(0:2),drop=FALSE])),ncol=3)
  cols <- matrix(sapply(1:3,function(i) rowSums(p[,(1:3)+3*(i-1),drop=FALSE])),ncol=3)
  observed <- as.numeric(p %*% as.vector(linear_weights()))
  expected <- rowSums((rows %*% linear_weights())*cols)
  out <- (observed-expected)/(1-expected)
  # Plan requires a dash for a prediction with no variance.
  out[rowSums(cols>0)<2 | !is.finite(out)] <- NA_real_
  out
}

gwet_ac2 <- function(counts) {
  p <- counts/rowSums(counts)
  rows <- matrix(sapply(1:3,function(i) rowSums(p[,i+3*(0:2),drop=FALSE])),ncol=3)
  cols <- matrix(sapply(1:3,function(i) rowSums(p[,(1:3)+3*(i-1),drop=FALSE])),ncol=3)
  marginal <- (rows+cols)/2
  expected <- sum(linear_weights())*rowSums(marginal*(1-marginal))/6
  (as.numeric(p %*% as.vector(linear_weights()))-expected)/(1-expected)
}

exact_accuracy <- function(counts) rowSums(counts[,c(1,5,9),drop=FALSE])/rowSums(counts)
not_low_sensitivity <- function(counts) rowSums(counts[,c(5,6,8,9),drop=FALSE]) /
  rowSums(counts[,c(2,3,5,6,8,9),drop=FALSE])
not_low_specificity <- function(counts) counts[,1]/rowSums(counts[,c(1,4,7),drop=FALSE])

agreement_replicates <- function(data,weights,exclude_missing=FALSE) {
  data <- data[!is.na(data$meta),]
  if(exclude_missing) data <- data[!is.na(data$label),]
  # A missing judgement must fail exact and Not Low classification. For ordinal
  # coefficients use maximal ordinal disagreement (recorded in DEVIATIONS.md).
  label <- data$label
  missing <- is.na(label)
  label[missing] <- ifelse(data$meta[missing]=='Low','High','Low')
  code <- match(data$meta,LABELS)+3*(match(label,LABELS)-1)
  w <- bootstrap_rows(data,weights)
  counts <- t(vapply(1:9,function(k) as.numeric(crossprod(as.numeric(code==k),w)),
    numeric(ncol(w))))
  counts <- t(counts)
  rbind(kappa=weighted_kappa(counts),AC2=gwet_ac2(counts),accuracy=exact_accuracy(counts),
    sensitivity=not_low_sensitivity(counts),specificity=not_low_specificity(counts))
}

composite_reference <- function(inputs,adjudicator=NULL) {
  cells <- adjudication_cells(inputs)
  x <- inputs$labels |> filter(arm %in% c('ARBITER-Sonnet','Baseline-Sonnet'),domain!='Overall') |>
    left_join(cells |> select(slug,domain,consensus,preferred,chosen_label_A,chosen_label_Z),by=c('slug','domain'))
  if(is.null(adjudicator)) x |> filter(is.na(consensus)|consensus) |>
    mutate(meta=coalesce(preferred,meta)) else
      x |> mutate(meta=coalesce(.data[[paste0('chosen_label_',adjudicator)]],meta))
}

