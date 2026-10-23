# Manuscript-only build. Reuse final tables/figures; do not load analyses.
python <- Sys.getenv('ARBITER_PYTHON', unset=Sys.which('python3'))
if(!nzchar(python)) python <- Sys.which('python')
if(!nzchar(python)) stop('Install Python with python-docx and lxml, or set ARBITER_PYTHON.')
stopifnot(system2(python, c('../scripts/build-manuscript.py', commandArgs(TRUE))) == 0L)
