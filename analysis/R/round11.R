# Round-11 estimands use label equality and the shared trial bootstrap.
published_direction_counts <- function(cells) {
  x <- cells |> filter(consensus) |> mutate(direction=factor(case_when(
    match(meta,LABELS)<match(preferred,LABELS)~'Less severe',
    meta==preferred~'Equal',TRUE~'More severe'),levels=c('Less severe','Equal','More severe')))
  bind_rows(x |> count(domain,direction,.drop=FALSE),x |> count(direction,.drop=FALSE) |> mutate(domain='All')) |>
    group_by(domain) |> mutate(total=sum(n)) |> ungroup()
}
vindicated_disagreements <- function(cells) {
  bind_rows(lapply(c('kit','nokit'),function(source) {
    cells |> filter(.data[[source]]!=meta) |> mutate(source=if(source=='kit') 'ARBITER' else 'Unassisted',
      direction=if_else(match(.data[[source]],LABELS)>match(meta,LABELS),'More severe','Less severe'),
      outcome=case_when(!consensus~'Split',preferred==.data[[source]]~'Vindicated',
        preferred==meta~'Published upheld',TRUE~'Other label')) |>
      count(source,direction,outcome) |> complete(source,direction,outcome=c('Vindicated','Published upheld','Other label','Split'),fill=list(n=0))
  })) |> group_by(source,direction) |> mutate(consensus_n=sum(n[outcome!='Split']),all_n=sum(n)) |> ungroup()
}
severity_win_share <- function(cells,weights) {
  x <- cells |> filter(consensus,discordant) |> mutate(direction=if_else(
    match(kit,LABELS)>match(nokit,LABELS),'ARBITER more severe','ARBITER less severe'))
  bind_rows(lapply(c('ARBITER more severe','ARBITER less severe'),function(d) {
    z <- filter(x,direction==d)
    win_share(z,weights) |> mutate(direction=d,analysis='Post hoc severity stratification')
  }))
}
no_decisive_counts <- function(x) {
  x |> filter(population=='Primary') |> group_by(domain,source) |> summarise(
    eligible=n(),with_decisive=sum(!is.na(decisive_questions)&nzchar(decisive_questions)),
    n=sum(is.na(decisive_questions)|!nzchar(decisive_questions)),.groups='drop') |>
    complete(domain=paste0('D',1:5),source=c('ARBITER-Sonnet','Baseline-Sonnet'),fill=list(eligible=0L,with_decisive=0L,n=0L))
}
disagreement_pattern_counts <- function(cells) {
  patterns <- c('ARBITER only disagreed with Published','Unassisted only disagreed with Published',
    'Both disagreed with Published, different labels','Both disagreed with Published, same label')
  outcomes <- c('ARBITER only preferred','Unassisted only preferred','Both arms preferred','Published only preferred','Adjudicators split')
  cells |> mutate(disagreement=case_when(kit!=meta & nokit==meta~patterns[1],
    kit==meta & nokit!=meta~patterns[2],kit!=nokit~patterns[3],TRUE~patterns[4]),
    outcome=case_when(!consensus~outcomes[5],preferred==kit & preferred==nokit~outcomes[3],
      preferred==kit~outcomes[1],preferred==nokit~outcomes[2],TRUE~outcomes[4])) |>
    count(disagreement,outcome) |> complete(disagreement=patterns,outcome=outcomes,fill=list(n=0))
}
