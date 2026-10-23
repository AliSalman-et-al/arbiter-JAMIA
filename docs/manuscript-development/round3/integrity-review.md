# Round 3 documentary integrity review

Reviewed on 2026-10-23 against actual Git HEAD `ffa8ab21b835d1b9284b2221f3a47f7826b4ddad` and the current working files. This review owns only `docs/manuscript-development/verify-release.py`, `round3/documentary-updates.json` and this report. Git was used read-only for HEAD resolution, status and before-content/diffs. No manuscript, reference, Word, supplement, R source, historical baseline or Git state was edited by this review.

## Authorized documentary changes

The five entries in [documentary-updates.json](documentary-updates.json) record exact historical `old_sha256`, reviewed current `new_sha256`, and rationale. They are the only exceptions authorized by this review. I read [reporting-repair.md](reporting-repair.md), the actual three R source diffs and three CSV diffs, and independently compared the two DOCX ZIP/XML contents with `git show HEAD:<path>`.

- `Supplement.docx`: exactly six paragraph text changes: original expert-material gaps; signalling component definition and direct expert-domain input; initial review-selection gaps; two evaluated `/rob2-assess` prompt prefixes; scoped evaluated/public release provenance and prompt-development gaps. The 98 tables and all 7,675 physical table cells retain identical complete text.
- `TRIPOD-LLM.docx`: eight tables and 368 physical cells remain. Exactly twelve section/note cells change across TRIPOD-LLM 5a, 8a, 9a, 9b and GRRAS 7, 8, making missing selection, original guidance and prompt-development provenance explicitly Partial. Numerical tokens in all table cells remain identical.
- `prompt-template-example.csv`: four data rows remain; exactly two prompt cells change, solely replacing `/arbiter-assess` with `/rob2-assess`. An independent whole-CSV comparison after this exact substitution passes. All example study values and all other fields remain identical.
- `display-supplement-reporting-map.csv`: 64 data rows remain; twelve cells change in the same six reporting rows, limited to section and note text. Numerical tokens remain identical.
- `reporting-checklist-skeleton.csv`: 64 data rows remain; twelve section/note cells change in the same six rows. Three section cells acquire the documentary locator `eTable 1` (TRIPOD-LLM 5a/9b and GRRAS 7); these are cross-reference identifiers, not study values. Other numeric tokens remain identical.

Both DOCX files retain identical ZIP member names and identical bytes in every member except `word/document.xml`. This independent check supports the documentary scope; it is not a fresh rendering or layout review. The actual R diffs change checklist text, methods prose and the evaluated command prefix; they do not change statistical computations. Their source files remain outside this review's write set and outside the five protected-output exceptions.

## Statistical and artifact parity

The historical baseline file remains byte-identical to Git HEAD, SHA-256 `346c3be6806ff39e12cf9eaf0ebfb92afdc28e423390c27042610a7d40262dfe`. All 106 historical protected-file hashes independently match HEAD bytes. Exactly the five documentary artifacts differ in the current working tree. The remaining 101 protected artifacts match both historical baseline and HEAD byte-for-byte, including `display-table1.csv` through `display-table3.csv`, standalone `Table1.docx` through `Table3.docx`, statistical estimates/contrasts and protected figures.

A broader independent HEAD comparison found 98 tracked table CSVs, with only the three documentary CSVs changed, and 60 tracked PDF/PNG/SVG/TIFF figure artifacts across `analysis/output/manuscript` and `analysis/output/figures`, all byte-identical. Thus the retained statistical outputs, main Tables 1–3 and figure artifacts are unchanged at this snapshot. This is artifact parity, not a rerun of the analysis or validation of the estimates from raw inputs.

The reporting worker's [numeric parity evidence](reporting-repair.md#verification), also inspected in `/tmp/arbiter-reporting-repair/checks.json`, reports unchanged supplement table cells, Word table numeric tokens, purely numerical CSV cells, reader table/image content and 177 unchanged artifacts in its 187-file inventory. My HEAD comparisons independently corroborate the table/figure and five-artifact scope. A qualification to the worker's broad phrase “no numerical-token differences” in the prompt CSV: a naive digit regex sees the `2` in the new command name `rob2`. It is a command identifier, not a changed study number. The three new skeleton eTable locators likewise are documentary identifiers. No claim is made that all prose digit sequences are identical; the evaluated release hash also adds provenance text.

## Verifier contract and tests

Without `--documentary-updates`, verification remains strict against the unchanged historical baseline. With the option, the manifest must be a nonempty JSON object keyed by exact repository-relative path. Only the five fixed documentary paths are eligible, and every entry must have exactly `old_sha256`, `new_sha256`, and a nonblank `rationale`. Hashes must be lowercase full-length SHA-256. Old hashes must equal the historical baseline; new hashes must equal existing current file bytes and describe a real change. Every entry is validated, including otherwise unused extras. Duplicate JSON keys, unknown paths (existing or nonexistent), missing files, malformed entries and mismatched hashes fail. All baseline files not covered by a valid entry retain historical protection. Partial manifests are permitted only if every omitted file still matches its historical hash.

The manifest is an explicit reviewed exception record, not a semantic proof or cryptographic authorization system: editing it can change the accepted new hash for one of the five eligible paths. Any future replacement needs documentary review. It cannot authorize another path, and this review's manifest pins exactly the bytes reviewed here.

Executed 19 passing cases using the managed Python runtime and `/tmp/arbiter-integrity-tests.py`, without modifying real protected files:

1. The actual five-file manifest passes the complete protected-output guard (five exceptions, 101 unchanged outputs).
2. The strict default rejects the actual five changed artifacts.
3. Wrong old hash is rejected against historical baseline.
4. Wrong new hash is rejected against current bytes.
5. An extra nonexistent arbitrary path is rejected.
6. An existing statistical file supplied as an exception is rejected.
7. Omitting a changed artifact is rejected.
8. Blank rationale is rejected.
9. Malformed SHA-256 is rejected.
10. A no-op old/new pair is rejected.
11. An unknown entry field is rejected.
12. Duplicate JSON path keys are rejected.
13. A top-level array is rejected.
14. An empty object is rejected.
15. Malformed JSON is rejected.
16. A physically missing approved file is rejected (temporary fixture).
17. Statistical-file tampering remains rejected alongside the valid documentary manifest (temporary fixture).
18. Strict CLI exits 1 before manuscript checks.
19. Invalid-manifest CLI exits 1 before manuscript checks.

The valid test calls the actual protected-output function, not a mocked hash checker. Importing the verifier no longer runs manuscript checks, allowing independent guard tests while the main Word build is concurrent. Existing citation, embedded Word/standalone/HTML table, title and figure-alt checks remain in the command's main path.

## Concurrent build and final verification

The main manuscript Word/layout is being rebuilt by another worker, as specified in the assignment. The final full release command, including embedded main Word/HTML table checks, is **deferred until that worker declares the outputs stable**. No full release PASS or main-document layout approval is claimed here. At the artifact-comparison snapshot, `Manuscript.docx` had SHA-256 `288e4f40f7525156d5ab617f0c9b30ea93cdfa7b08957562cebbf4259902a7a9`; it is not a baseline exception and may change during the concurrent build. Standalone main tables and retained figures were independently checked as described above.

Run the exact final command from `/home/ali/Documents/Code/arbiter-JAMIA` once the concurrent build is stable:

```sh
/home/ali/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/bin/python3 docs/manuscript-development/verify-release.py --documentary-updates docs/manuscript-development/round3/documentary-updates.json
```

The managed Python is specified because `/usr/bin/python3` lacks `python-docx`. Full R builds and statistical verification scripts remain **unrun**: the reporting worker documented missing dplyr, tidyr, readr, readxl, officer, flextable and gt dependencies. This review did not install dependencies, run broad builders or rerun analyses. The worker's rendering/visual QA remains attributed to that worker; this review adds independent byte/XML/CSV comparisons and verifier tests.
