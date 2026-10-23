# Final shared source/output parity repair

Completed in the shared checkout without running statistics, models, resampling or figure generation. No Word file was written. The task-entry main manuscript, supporting Word documents, all figures and all 58 numerical exports remain byte-identical. The 25-page main Word proof remains applicable to these unchanged bytes; no new visual proof is claimed. Historical baseline files remain unchanged.

## Concrete repair

1. Updated only the first population label in `analysis/output/tables/display-table2.csv`: `Agreed choices (formal primary)` → `Agreed choices`. All other cells, headers, order and numeric strings are identical. This matches `primary_endpoint_table()` and the already proofed standalone/embedded Word and HTML tables.
2. Updated exactly 15 `value` cells in the 49,892-row `display-source-trace.csv`. Two restore the already approved evaluated `/rob2-assess` prompt prefix; thirteen synchronize the already approved reporting-checklist section/note text. All row/file/column keys and all other values are identical. These are documentary strings; statistical trace values were not changed. The full exact source-cell equality check remains intact.
3. Added `supplement_display_slug()` in `analysis/R/manuscript-supplement.R`, mapping precisely the current reader title `Blinded-label choices and post hoc strata` to the frozen historical `primary-endpoint-sensitivities-and-post-hoc-strata` export path. The production CSV writer and `analysis/verify-output.R` use this shared helper. Other titles use their existing slug rule. This preserves the historical export and avoids duplicate title-derived CSVs on later builds. The verifier still requires exact current-builder column names, all cell values and full footnotes.
4. Added precisely those two documentary CSV paths to the release verifier allowlist and manifest. Each entry retains its original historical old hash, exact final new hash and specific rationale. Removed the earlier coordinate-specific Table 2 label translation: CSV/Word/HTML equality now operates directly on the repaired label. No wildcard, statistical-export exception or numerical tolerance was added.
5. Trimmed only surrounding whitespace from verifier-generated review-context snippets, so rerunning the verifier does not introduce trailing-whitespace failures. This changes diagnostic excerpts only, with no change to the reader-language scan or source text.

`table2_note()` is an unused legacy compact-table helper: neither the production main Table 2 builder nor supplement generation calls it. Its neutral wording therefore does not require rewriting historical supplement notes. Every active `supplement_note(e)` was checked against the unchanged Word text and passed. Derived Overall and binary exploratory qualifications remain in the supplement. No prospective specification claim was introduced.

## Verification on the shared artifacts

- Full `R_LIBS=/tmp/arbiter-analysis-r5-y3nrs5du/library Rscript --vanilla verify-output.R`, from `analysis/`: exit 0. Includes all 49,892 exact trace records, exact regenerated results/legends/main Table 2, every supplementary display CSV and full Word footnote, full AVATAR quotations across labelled continuations, Word/HTML trace checks, independent workbook counts, severity/binary checks, protected Figure 1/2 bytes and exact 38-statistical-CSV invariance against `951dddd`.
- Compared the shared 58 numerical CSV hashes against the retained analysis-validation old hashes: 58/58 byte-identical. No numerical export was rewritten here.
- Release verifier with the round5 manifest: PASS, 109 historical files, 12 reviewed exceptions, 97 unchanged protected files, 23 references, 79 display fields, all three embedded tables equal standalone tables, five figures with alt text. Focused negative fixtures still reject statistical `primary-endpoint.csv` and protected `Figure2.pdf` exceptions; the historical-label translation function is absent.
- `docs/manuscript/verify-numbers.py`: PASS, 335 numeric tokens, zero untraced; 3704/4000 main words, 214/250 abstract words.
- `scripts/test-manuscript.py`: nine tests, one skipped, no failures.
- `git diff --check`: PASS after trimming generated diagnostic-context boundaries.

Managed Python: `/home/ali/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/bin/python3`. R uses the previously restored isolated library; no package installation or project-library change occurred. The analysis report's R-version/lockfile limitations still apply. This is a successful full shared verifier run, not a claim that the previously interrupted single-call publication build completed.

## Exact changed set and evidence

Existing implementation/presentation files written by this repair: `analysis/R/manuscript-supplement.R`, `analysis/verify-output.R`, the two named display CSVs, `docs/manuscript-development/verify-release.py`, and `round5/documentary-updates.json`. The verifier also refreshed its six normal provenance records: `unchanged-analysis.diff`, `prior-work-data.diff`, `protected-artwork.csv`, `rebuild-estimate-invariance.txt`, `rebuild-leak-contexts.csv`, and `output-verification.txt`. Of those, only the last two have tracked content differences from HEAD, reflecting current reader text and validation results.

New evidence: this report, `final-parity-checks.json`, and four `final-parity-*.log` files. The JSON records exact historical/final hashes and every old/new changed CSV cell, task-entry/final hashes for the six existing owned files, unchanged main Word hash and baseline-file hash. The manifest carries the same two baseline-protected hash pairs and rationales. All other output artifact hashes were compared with the task-entry inventory; precisely the two documentary CSVs differ. This supersedes earlier advice to retain the stale Table 2 CSV and translate its label during validation.

Parent-owned `scripts/report-refresh.py` and publication work were not edited, reverted or run here. No git mutation, agent delegation or publication occurred. Parent may run its final refresh/clean-build checks and publish; these repaired documentary CSVs now match the already proofed Word/HTML content.
