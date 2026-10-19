# Post hoc estimands. Inputs and the original discordant population stay fixed.
rules_only_labels <- function(labels,checks) {
  replacements <- checks |> filter(arm=='Baseline-Sonnet',status=='Violation') |>
    select(arm,slug,domain,replacement=algorithm)
  labels |> left_join(replacements,by=c('arm','slug','domain')) |>
    mutate(label=coalesce(replacement,label)) |> select(-replacement)
}
rules_only_recomputation <- function(labels,checks,cells,weights) {
  corrected <- rules_only_labels(labels,checks)
  changed <- labels |> filter(arm=='Baseline-Sonnet',domain!='Overall') |>
    select(slug,domain,original=label) |>
    inner_join(corrected |> filter(arm=='Baseline-Sonnet') |> select(slug,domain,recomputed=label),by=c('slug','domain')) |>
    filter(original!=recomputed) |> left_join(cells |> select(slug,domain,consensus,discordant,preferred),by=c('slug','domain'))
  recells <- cells |> left_join(corrected |> filter(arm=='Baseline-Sonnet') |>
    select(slug,domain,recomputed=label),by=c('slug','domain')) |> mutate(nokit=recomputed)
  # discordant is deliberately NOT recalculated: this is the original 62-cell comparison.
  wins <- bind_rows(win_share(cells,weights) |> mutate(version='Reported'),
    win_share(recells,weights) |> mutate(version='Recomputed'))
  agreement <- bind_rows(lapply(c('Reported','Recomputed'),function(v) {
    d <- if(v=='Reported') labels else corrected
    d <- filter(d,arm=='Baseline-Sonnet',domain!='Overall')
    bind_rows(lapply(c('D1-D5',paste0('D',1:5)),function(g) {
      z <- if(g=='D1-D5') d else filter(d,domain==g)
      if(!nrow(z)) return(NULL)
      interval_table(agreement_replicates(z,weights)) |> filter(metric %in% c('kappa','accuracy')) |>
        mutate(version=v,domain=g,n=nrow(z),count=if_else(metric=='accuracy',sum(z$label==z$meta),NA_integer_))
    }))
  }))
  agreed <- bind_rows(lapply(c('Reported','Recomputed'),function(v) {
    z <- if(v=='Reported') cells else recells
    z <- filter(z,consensus)
    interval_table(share_estimate(z,z$nokit==z$preferred,weights)) |>
      mutate(version=v,n=nrow(z),count=sum(z$nokit==z$preferred))
  }))
  lapply(list(changed=changed,win_share=wins,agreement=agreement,agreed_choice=agreed),function(z) mutate(z,analysis='Post hoc'))
}
direction_of_disagreement <- function(cells,weights) {
  bind_rows(lapply(c('kit','nokit'),function(s) bind_rows(lapply(c('Stricter','More lenient'),function(direction) {
    z <- cells |> filter(.data[[s]]!=meta,
      (match(.data[[s]],LABELS)>match(meta,LABELS))==(direction=='Stricter'))
    d <- filter(z,consensus)
    estimate <- if(nrow(d)) interval_table(share_estimate(d,d$preferred==d[[s]],weights)) else
      tibble(metric='share',estimate=NA_real_,lower=NA_real_,upper=NA_real_,valid_replicates=0L)
    estimate |> mutate(source=if(s=='kit') 'ARBITER' else 'Unassisted',direction=direction,
        n=nrow(d),count=sum(d$preferred==d[[s]]),split=sum(!z$consensus),
        published_upheld=sum(d$preferred==d$meta),other_label=sum(d$preferred!=d[[s]] & d$preferred!=d$meta),
        analysis='Post hoc')
  }))))
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
