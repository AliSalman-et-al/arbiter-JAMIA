# Round 10 implementation report

Presentation-only changes from 8e0215bb35f681cfe24879a5ab8757e9e6e5475c.

The coverage denominator is active signalling answers, not evidence records.
R/extract-run-metrics.R selects answers on each current domain record's active
question path and counts their evidence bases. R/process.R divides the sum of
answers with at least one basis by the sum of active answers. Table 3's
1538/1538 therefore represents answers. The row now reads "Signalling answers
citing ≥1 evidence record" in Table 3 and eTable 6, with explicit numerator and
denominator notes in both tables.

The proportion formatter omits intervals whose bounds are equal at the displayed
precision, retaining the estimate and n/N (%). Nondegenerate intervals, undefined
values and coefficient formatting are preserved. The All-Low no-variance note
is retained. The following 12 numeric cells lose only their CI:

- Table 2: All-Low rule specificity, D1–D5 (427/427) and Overall (42/42).
- eTable 4: All-Low rule specificity, D1–D5 (427/427), D1 (84/84), D2
  (86/86), D3 (83/83), D4 (93/93), D5 (81/81), Overall (42/42);
  ARBITER with Haiku 5.5 Overall sensitivity (39/39).
- eTable 19: ARBITER with Haiku 5.5 Overall sensitivity (39/39).
- eTable 26: Unassisted with Sonnet 5.5 quotation-syntax proportion (0/1459).

The two coverage measure cells and their notes are the only other table changes.
All numeric displays were compared programmatically with the HEAD builders.

Validation and rendered-page inspection are recorded below after completion.

## Completed validation

- Clean uncached `quarto render` succeeded after deleting both generated HTML
  files and all six generated manuscript Word documents; the pipeline regenerated
  all manuscript outputs.
- Full testthat suite passed, including the new formatter checks for exact and
  rounded collapsed intervals, 0%/100%, nondegenerate intervals, undefined
  estimates and unchanged coefficient intervals. Only the four pre-existing
  Windows C.UTF-8 startup messages occurred.
- `Rscript verify-round10.R` passed: all 88 repository CSVs match the starting
  HEAD under Git newline normalisation, with no added/removed CSV. Word,
  publication PDF/SVG, HTML and canonical-legend prohibited-name scans are clean.
  Additional Word scans reject raw field names, trial slugs and meta-analysis IDs.
- Native Word PDFs and all page PNGs/contact sheets were regenerated using
  render-word-qa.ps1 and render-qa-pages.R. Inspected Table 2 and Table 3, and
  supplement pages 7–8 (eTable 4), 10–11 (eTable 6), 28 (eTable 19), and 36
  (eTable 26). No clipping or overlap; all text remains within page bounds.
  Main tables remain one page each; Supplement.docx remains 40 portrait pages.
- Unrelated regenerated Word summaries and figure PDF text matched HEAD;
  their timestamp-only artifacts were restored to avoid unrelated binary diffs.
  Figure 1 publication bytes remain identical. Protected files and data folders
  were not edited. `git diff --check` passes.

One commit; no push.
