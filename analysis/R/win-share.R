win_share <- function(cells,weights,analysis='Consensus') {
  cells <- cells[cells$discordant,]
  if(analysis=='Consensus') cells <- cells[cells$consensus,]
  preferred <- switch(analysis,Consensus=cells$preferred,A=cells$chosen_label_A,
    Z=cells$chosen_label_Z,`Split sensitivity`=cells$preferred)
  arbiter <- !is.na(preferred) & preferred==cells$kit
  baseline <- !is.na(preferred) & preferred==cells$nokit
  # Split cells are forced losses for ARBITER, without inventing a baseline win.
  other <- !arbiter & !baseline
  w <- bootstrap_rows(cells,weights)
  values <- rbind(ARBITER=colSums(w*arbiter)/colSums(w),
    Baseline=colSums(w*baseline)/colSums(w),Neither=colSums(w*other)/colSums(w))
  interval_table(values) |> mutate(analysis=analysis,n=nrow(cells),
    count=c(sum(arbiter),sum(baseline),sum(other)),
    note=if(.env$analysis=='Split sensitivity') 'Neither includes split cells forced as ARBITER losses' else '')
}

