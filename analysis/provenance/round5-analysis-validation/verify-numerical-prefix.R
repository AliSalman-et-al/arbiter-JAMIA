# Run independent workbook/count validation from the production verifier,
# stopping before git/history and publication-artifact verification.
for (expr in parse('verify-output.R')) {
  if (grepl('^unchanged <-',paste(deparse(expr),collapse=' '))) break
  eval(expr,envir=.GlobalEnv)
}
