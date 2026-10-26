# Reduction verification and review

Status update, 26 October 2026. The author subsequently removed the active IMRaD draft to write a fresh manuscript. The previous manuscript source, bibliography, Word and HTML outputs and their dedicated builder/audit tests were deleted. The checks below record the earlier reduction release, not a current article draft. Main analysis materials and the supplement remain. See README.md for the current entry points.

26 October 2026. The reduction is complete for review as a public manuscript draft. Author affiliations, complete assessor information, declarations and an archival DOI remain pending. This is not a submission-readiness certification.

## Final artifacts

The main manuscript retains five figures and three tables and renders as 23 pages. The scientific supplement contains six numbered families, 24 physical tables and 26 pages, compared with 98 tables and 142 pages before reduction. Three standalone main tables occupy one page each. The separate reporting map occupies eight pages.

Human Review 1 and Human Review 2 identify the independent human assessments. Their original workbook and numerical keys remain stable. Figure 2's footer now explicitly identifies subsequent blinded D5 choices. Figure 3 describes the same reported model identifier, without claiming immutable snapshot identity.

## Checks run

- The final analysis suite passed 215 assertions, with no failures, warnings or skips.
- Direct output verification reconciled source-workbook agreement, conditional choices, derived Overall, rules-only repair, signalling numerators, exclusions and paired intersections.
- scripts/verify-reduction.py verified 464 unchanged study inputs and exact retained-row identity across 41 analytical CSVs and 3755 rows. It compares scientific identifiers as well as values and intervals. Changed-value, swapped-identity and duplicate-row controls passed.
- Figure 1 retains its earlier bytes. Figure 2's SVG labels match the earlier figure except the authorized footer clarification. Captured-source and geometry assertions passed during its regeneration.
- The manuscript number audit passed with zero untraced numeric tokens. Six unchanged external-literature spans retain their prior source/access records; this revision did not repeat that literature review.
- Ten publication-package tests passed. All 25 manuscript tests passed, including the built-artifact integration checks.
- Presentation checks confirmed editable native Word tables, exact embedded/standalone cell equality, Word-to-HTML table equality, main display inventory, supplementary inventory and local download links.
- All 60 final pages were rendered with installed Microsoft Word and inspected individually. Two independent visual workers covered 23 manuscript pages, three standalone tables and 26 supplementary pages. The parent inspected all eight reporting-map pages and all five figure images, including revised labels.
- Page geometry found no text outside page bounds and no empty pages. Two preliminary gutter concerns were retracted after original-size image inspection and direct PDF measurements. No material layout defect remains.
- A fresh independent scientific/source/release review found no unresolved scientific or pipeline blocker. It did not claim visual or deployment certification.

The bundled LibreOffice renderer was unavailable on this Windows host. Rendering used installed Word, followed by PNG production and geometric checks. Generated Word files are staged before atomic replacement to avoid Windows overwrite failures.

## Findings fixed

The reduction initially removed three distinct qualifications. Independent defense reviews restored compact derived Overall results, complete paired question contrasts and pooled rules-only findings. Repeated displays and metric/reference expansions were removed instead.

Publication fixes preserved string identifiers after numerical-reference pruning, replaced an obsolete category-matrix width assumption, restored a directly linked changed-cell audit, separated revised reporting metadata from immutable numerical rows, and removed stale supplementary-figure links. Neutral wording uses whole-word matching so the reporting term expertise is preserved.

The complete display-by-display defense and omission account are in ../analysis-simplification.md. The source and claim record is evidence.md. The full earlier release remains recoverable at 54645d75e7a8b32bbf09968893e7be45faa4cab4.

## Release

The author authorized commit, push and GitHub Pages publication. The staged package must pass its local-link check. Live publication is complete only after scripts/verify-pages.py confirms every deployed file against the committed-source manifest.

## Attention

Reviewed by GPT-6-Astra for scientific/source/release issues and GPT-6.1-Sol for rendered visual proof. No unresolved material review flags remain. Known author-completion fields remain visible. Numerical and artifact checks do not establish semantic evidence support, reviewer benefit or causal component effects.
