# A column is one replicate; rows are trials. Multiplicity retains whole clusters.
stratified_cluster_weights <- function(trials, replicates=10000L, seed=20261018L) {
  stopifnot(!anyDuplicated(trials$slug), !anyNA(trials$meta_id))
  withr::with_seed(seed, {
    weights <- matrix(0L,nrow(trials),replicates,dimnames=list(trials$slug,NULL))
    for(i in split(seq_len(nrow(trials)),trials$meta_id)) {
      draws <- replicate(replicates,tabulate(i[ sample.int(length(i),length(i),replace=TRUE) ],
        nbins=nrow(trials)))
      weights <- weights + draws
    }
    weights
  })
}

bootstrap_rows <- function(data,weights) {
  # Include the original data as column 1, then all bootstrap replicates.
  cbind(1,weights[match(data$slug,rownames(weights)),,drop=FALSE])
}

interval_table <- function(values) {
  values <- as.matrix(values)
  bind_rows(lapply(seq_len(nrow(values)),function(i) {
    x <- values[i,-1]; ok <- is.finite(x)
    ci <- if(any(ok)) quantile(x[ok],c(.025,.975),names=FALSE,type=7) else c(NA,NA)
    tibble(metric=rownames(values)[i],estimate=unname(values[i,1]),lower=ci[1],upper=ci[2],
      valid_replicates=sum(ok))
  }))
}

share_estimate <- function(data,event,weights,eligible=rep(TRUE,nrow(data))) {
  w <- bootstrap_rows(data,weights)
  rbind(share=as.numeric(crossprod(as.numeric(event & eligible),w)) /
    as.numeric(crossprod(as.numeric(eligible),w)))
}
