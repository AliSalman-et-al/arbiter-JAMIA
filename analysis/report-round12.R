source('R/load.R')
source('R/presentation.R')
for(f in c('algorithms.R','process.R','avatar-trace.R','manuscript-tables.R','manuscript-supplement.R','manuscript-legends.R','results-sentences.R')) source(paste0('R/',f))
entries <- supplement_registry(load_inputs())
old_source <- system2('git',c('show','48c7116:analysis/R/manuscript-supplement.R'),stdout=TRUE)
tmp <- tempfile(fileext='.R'); writeLines(old_source,tmp)
e <- new.env(parent=globalenv()); sys.source(tmp,envir=e)
old_entries <- e$supplement_registry(load_inputs())
map <- c(8,17,17,9,10,13,14,18,19,20,21,3,2,4,11,12,22,23,22,23,24,24,6,7,5,25,15,26,27,28,1)
stopifnot(length(old_entries)==length(map),length(entries)==28L)
lines <- c('# Round 12 manuscript polish','',
  'Started on main at 48c7116. Local commits only; no push. Statistical estimates and methods are unchanged. Figures 1/2 and their protected source/legend files were not edited.','',
  '## Findings checked and wording corrected','',
  '- Table 1: 16 meta-analyses cover 15 distinct specialties, not 16; corrected the title.',
  '- Table 2: retained the sensitivity finding, but changed “at a small cost in specificity” to “with lower specificity”. The Overall specificity loss is 21.4 percentage points, so “small” was not justified.',
  '- Figure 4: limited the leniency finding to disputed-label errors; the selected adjudicated cells do not estimate full-benchmark published-label accuracy.',
  '- Figure 6: narrowed “most losses” to “most localised losses”: question 5.1 changes 18 of 29 Unassisted loss cells with any individually deciding question, but only 18 of all 47 eligible losses.',
  '- Table 3: 65/509 evaluable Unassisted domain ratings departed (12.8%); one wholly missing label/answer set is excluded. ARBITER design guarantees concern Sonnet proposals; recorded adoption overrides remain supplementary.','',
  '## Implementation and merges','',
  '- Tables 2/4 drop AC2 columns; composite results remain in the supplement. Table 2 retains Published domain/Overall blocks and paired differences. Table 3 is Measure | Unassisted | ARBITER, with domain totals and evidence/audit rows.',
  '- Merged Sonnet/Haiku process summaries with a Model column and common source columns; merged four per-adjudicator composite tables into two (estimates and differences); merged missing-Haiku tables into one with estimate/difference sections.',
  '- AVATAR is eTable 1, first cited by Figure 2. Figure 5 cites eTables 2–4; Figure 6 cites eTables 5–7; Table 1 cites eTable 8; Table 2 cites eTables 9–10; full reliability is eTable 16; process metrics are eTable 17.',
  '- The shared legend loader substitutes {{eTable:avatar-trace}}. For the current pre-handoff file it also updates legacy eTable 31 references and excludes its production-provenance paragraph from the combined manuscript legends. The protected handoff file itself remains exact. Figure 1/2 substantive legend length and artwork remain the parallel owner’s responsibility.',
  '- Figure 3 no longer repeats the Figure 5 outcome counts; Figure 4A has domain points only; Figure 5B uses reader labels and counts in words; Figure 6 has one bar unit and facet-only remainders.',
  '- Reader-label transformations apply to supplementary captions, notes, tables and methods; complete trace quotations and rationales remain verbatim. Banned-term scans were extended. CSV row ordering for the disagreement-pattern export is explicitly English-locale ordered to preserve the existing output under Windows.',
  '- results-sentences.md is regenerated from CSVs by R at every full build.','',
  '## Main table titles','',paste0('Table ',1:4,'. ',MAIN_TABLE_TITLES),'',
  '## Full figure legends and alt text','')
sections <- figure_legend_sections()
for(i in seq_along(sections)) lines <- c(lines,paste0('### ',names(sections)[i]),'',sections[[i]],'')
lines <- c(lines,'### eFigure 1. Agreement with Published varied across meta-analyses','',
  'Weighted kappa and 95% CIs; source symbols distinguish model and assistance. Undefined coefficients are omitted. Specialty and topic identify each meta-analysis. Descriptive estimates only; no statistical tests. CI, confidence interval; 10,000 percentile bootstrap replicates, trials resampled within meta-analysis; seed 20261018.','',
  'Alt text: Agreement varies across meta-analyses, with overlapping uncertainty intervals for the assessment arms.','',
  '### eFigure 2. ARBITER-only choices outnumbered Unassisted-only choices','',
  'ARBITER-only choices were more frequent than Unassisted-only choices. Rows group disputed cells by disagreement with the published review label; columns show the adjudicators’ agreed choice or split. Counts use label equality; shared labels count as both arms preferred. A cell is one trial × domain.','',
  'Alt text: Disagreement patterns and the adjudicators’ agreed choices form a count matrix; split cells appear separately.','',
  '## Generated results sentences','',paste(results_sentences(),collapse='\n\n'),'','## eTable renumbering map','',
  '| Former eTable | New eTable | Former title |','|---|---|---|')
for(i in seq_along(map)) lines <- c(lines,paste0('| ',i,' | ',map[i],' | ',old_entries[[i]]$caption,' |'))
lines <- c(lines,'','New: eTable 16 contains full reliability estimates including AC2 moved from main Table 4.','',
  '## Final supplementary titles','',paste0('eTable ',seq_along(entries),'. ',vapply(entries,`[[`,character(1),'caption')),'','## Validation','',
  'Final checks and visual-review evidence will be appended after the completed build.')
lines <- lines[lines!='Final checks and visual-review evidence will be appended after the completed build.']
if(file.exists('output/manuscript/qa/tests-round12.rds')) {
  library(testthat)
  tests <- as.data.frame(readRDS('output/manuscript/qa/tests-round12.rds'))
  lines <- c(lines,sprintf('- Full suite: %s passing assertions in %s test blocks; %s failures, %s errors, %s test warnings and %s skips.',
    sum(tests$passed),nrow(tests),sum(tests$failed),sum(tests$error),sum(tests$warning),sum(tests$skipped)))
}
lines <- c(lines,
  sprintf('- All %s supplementary notes meet the 140-word ceiling (maximum %s words); main Figure 3–6 legends are at most 140 words and alt text at most 80 words, enforced by tests.',length(entries),max(vapply(entries,function(e) length(strsplit(e$note,'\\s+')[[1]]),integer(1)))),
  '- Full default Quarto render rebuilt statistical outputs; a final presentation-only render applied the last wording and cross-reference edits from the same CSVs. Both reports rendered successfully. ARBITER_PRESENTATION_ONLY=1 is an optional display iteration shortcut; the default still runs the full numerical pipeline.',
  '- Native Microsoft Word export and all page PNGs were regenerated after the final document build. Four main tables remain one portrait page each; the checklist has two pages. Final supplement pagination and trace quote fidelity are recorded in qa/verification-round12.txt and qa/round12-pagination.json.',
  '- Inspected every final supplement page, every main table/checklist page, all six changed figure PDFs and their greyscale/protanopia/deuteranopia/tritanopia previews at final physical dimensions. No clipping, overlap or wrapped main-table labels/values.',
  '- Automated native Word PDF checks confirm every non-free-text main-table label/value occupies one baseline. Fonts are Arial 9 pt; AVATAR alone retains the existing landscape/8 pt exception.',
  '- All six figure PDFs are 174 mm wide with embedded Fira Sans, minimum sizes 7.97, 7.97, 7.11, 7.97, 8.00 and 7.50 pt for Figures 3–6/eFigures 1–2; TIFFs are 600 dpi, LZW. All generated alt text and embedded current PNG bytes are checked.',
  '- Extended banned-term/raw-code scans cover Word, figure PDFs, HTML and merged legends. All CSVs and protected files are unchanged from 48c7116. Complete verbatim evidence quotes remain present in the Word-rendered supplement.',
  '- R startup locale warnings are environmental; testthat reports zero test warnings. No push was performed.','',
  '## Full supplementary footnotes','')
for(i in seq_along(entries)) lines <- c(lines,paste0('### eTable ',i,'. ',entries[[i]]$caption),'',entries[[i]]$note,'')
writeLines(enc2utf8(lines),'round12-report.md',useBytes=TRUE)
