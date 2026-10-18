# Run from analysis/. Writes only diagnostic outputs, then enforces the gate.
source('R/load.R')
source('R/algorithms.R')
inputs <- load_inputs()
checks <- domain_checks(inputs)
dir.create('output/tables',recursive=TRUE,showWarnings=FALSE)
readr::write_csv(checks |> filter(startsWith(arm,'ARBITER'),status!='Consistent'),
  'output/tables/algorithm-mismatches.csv')
readr::write_csv(checks |> count(arm,status),'output/tables/algorithm-validation-summary.csv')
readr::write_csv(question_map(),'output/tables/question-map.csv')
validate_gate(checks)
