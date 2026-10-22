# JAMA presentation, JAMIA submission

User instruction, 22 October 2026: adopt JAMA style for statistics, figures, tables, and all other content despite submission to JAMIA. This extends the ongoing gt rebuild and final publication audit.

## Sources and precedence

- Current [JAMA instructions](https://jamanetwork.com/journals/jama/pages/instructions-for-authors/), checked 22 October 2026.
- Official [JAMA table construction guide](https://jamanetwork.com/DocumentLibrary/InstructionsForAuthors/InstructionsForTableCreation.pdf).
- [JAMIA submission instructions](https://academic.oup.com/jamia/pages/General_Instructions).

Use JAMA presentation conventions throughout. Keep JAMIA's mandatory abstract structure, submission limits, document organization, and file requirements where they differ. Do not transplant JAMA's article categories or abstract headings. Preserve the approved scientific scope, OCAR narrative, analytical values, and protected Figures 1 and 2. Flag any protected-figure style exceptions instead of modifying them silently.

## Statistical reporting (JAMA)

- Report counts with percentages; make denominators explicit, especially below 100. Round percentages to integers when their denominator is below 100. Retain full analytical precision in source data.
- Report estimates with uncertainty; do not substitute hypothesis tests for effect sizes. Clearly distinguish percentage-point differences from relative percentage changes.
- Use mean (SD) and median (IQR) as appropriate. Identify interval type and direction.
- Use italic uppercase P, without a leading zero: P < .001 below .001; three decimals from .001 to below .01; two decimals from .01 through .99; P > .99 above .99. Do not introduce tests absent from the analysis.
- Match numerical presentation across abstract, prose, tables, figures, and supplement.
- Use point markers with uncertainty for summary estimates; bars for frequencies. Label axes and units, define keys, and use distinguishable colors.

## Tables (JAMA construction guide)

- Produce actual editable cells through gt for Word and native HTML. Never substitute table screenshots.
- Present comparisons across columns. Keep counts and percentages together, and estimates and their variability together when appropriate.
- Use readable 10- or 12-point text; reflow or paginate instead of shrinking to fit. The guide permits single-spaced tables; document any spacing adjustment needed for JAMIA submission.
- Use superscript lowercase letters for specific footnotes. Ensure markers and notes correspond in both directions.
- Explain abbreviations, missing cells, and totals that differ because of rounding or exclusions.
- Avoid tabs, hard returns, or vertical cell merges as alignment mechanisms. Keep rows and values in real cells.

## Project implementation choices

Use restrained horizontal rules, minimal shading, aligned numerical columns, sentence-case labels, concise standalone captions, and consistent typography. These are our design choices for readable JAMA-like displays, not claims that every detail is mandated by the sources. Preserve a logical reading order and clear panel identifiers. Explain denominators, comparison direction, uncertainty, and analytical population at the display where needed.

Use consistent biomedical editorial style in prose, abbreviations, punctuation, units, and references while retaining JAMIA's required citation format. Do not add unsupported facts, author declarations, analyses, or claims. Do not rewrite verbatim evidence excerpts for house style.

## Acceptance checks

Verify actual rendered Word pages and browser output, including every table and figure; check clipping, font size, pagination, and footnote association. Verify rounded displays against unrounded CSVs and compare all repeated headline values. Record any mandatory JAMIA or protected-artifact exception. Commit and publish only after the final audit passes.
