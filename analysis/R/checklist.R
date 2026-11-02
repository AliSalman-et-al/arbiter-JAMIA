reporting_checklist <- function() {
  readr::read_csv('data-curated/reporting-checklist.csv',show_col_types=FALSE,
    col_types=readr::cols(.default=readr::col_character()))
}
