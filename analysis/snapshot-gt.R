tmp <- tempfile(fileext='.lock')
renv::snapshot(packages='gt',lockfile=tmp,prompt=FALSE)
old <- jsonlite::read_json('renv.lock',simplifyVector=FALSE)
new <- jsonlite::read_json(tmp,simplifyVector=FALSE)
needed <- union('gt',setdiff(names(new$Packages),names(old$Packages)))
for(p in needed) old$Packages[[p]] <- new$Packages[[p]]
writeLines(paste('Added only:',paste(needed,collapse=', ')),'../docs/rethink-2026-10-22/final-audit/remediation/renv-update.txt')
jsonlite::write_json(old,'renv.lock',auto_unbox=TRUE,pretty=TRUE)
