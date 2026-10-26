rules_only_labels <- function(labels,checks) {
  replacements <- checks |> filter(arm=='Baseline-Sonnet',status=='Violation') |>
    select(arm,slug,domain,replacement=algorithm)
  labels |> left_join(replacements,by=c('arm','slug','domain')) |>
    mutate(label=coalesce(replacement,label)) |> select(-replacement)
}
