# Evaluate the production entry point through all numerical exports; stop at
# reporting_checklist(), before any display/Word/HTML production.
e <- parse('run.R')
for (expr in e) {
  if (grepl('^save_table\\(reporting_checklist',paste(deparse(expr),collapse=' '))) break
  eval(expr,envir=.GlobalEnv)
}
writeLines(capture.output(sessionInfo()),'../numerical-session-info.txt')
