# Round5 release integrity integration

Reporting worker completion was established from `reporting-repair.md` before editing the documentary manifest. Reviewed that report, `checks.json`, `flow-label-repair.json`, `relabel-flow.py`, `baseline-hashes.json`, and the round4 historical inventory. This task changed only `docs/manuscript-development/verify-release.py`, `round5/documentary-updates.json`, and this report. No dedicated verifier test file exists; focused tests ran in temporary fixtures and memory. No git mutation, agent delegation, analysis execution, publication-source edit, canonical-manuscript edit or artifact write was performed.

## Exact exceptions and historical lineage

The verifier's finite documentary-path set now additionally permits `analysis/output/manuscript/Table2.docx`, `analysis/output/manuscript/figure-legends.md`, and exactly `analysis/output/manuscript/Figure3.{pdf,png,tiff}`. No glob or other artwork exception was introduced. The five earlier approved paths remain unchanged.

`historical_baseline()` retains every one of the 106 entries in `baseline-hashes.json` and supplements them with the three explicitly named Figure3 paths' original hashes from `round4/baseline.json`, yielding 109 protected files. Neither historical baseline file was edited. These artwork paths were absent from the original verifier inventory. The similarly named `analysis/output/figures/figure3.pdf` and `.png` are not listed in either historical inventory and received no manifest exception; their bytes were independently checked against the corresponding manuscript files. Supplemental eFigure3 and every other artwork path remain unauthorized exceptions.

The manifest retains the reporting worker's seven old/new hash pairs and adds three Figure3 pairs, using the recorded round4 old hashes and current repaired-file new hashes. It now has ten individually enumerated entries. Historical-hash equality, current-hash equality, required rationale, strict entry fields, duplicate-key rejection and failure for any remaining protected-file change are preserved. No statistical export was exempted or rebased.

The CSV correspondence exception applies only to Table 2, zero-based CSV row 1, column 0, with the exact raw value `Agreed choices (formal primary)`, displayed as `Agreed choices`. Other cells, labels, tables and values keep the existing exact membership checks; standalone/embedded Word cell parity, three-table structure, citation order and HTML checks remain mandatory. Numeric strings are never transformed. The frozen CSV remains byte-protected by its historical hash.

## Independent artifact checks

Actual Word and CSV inspection confirmed all ten CSV fields correspond to the first five Word rows, with exactly the one authorized population-label difference. Table 2's historical bytes were read with `git show` at the commit recorded by the flow repair; their hash matches the retained historical Table2 hash. Both versions have 11 physical cells with identical numerical tokens in corresponding cells, identical nontext document XML and identical contents for every ZIP member except `word/document.xml`.

Figure3 was independently compared with its historical PDF at `343febaecae7ba506f8f520a7a5524c5ba154555`. Exactly these strings change:

- `Same Sonnet model; one run per arm` → `Same model identifier; one run per arm`.
- `Conditional primary endpoint: 80 cells` → `Conditional label choice: 80 cells`.
- `53 favor ARBITER` → `53 match ARBITER`.

All other PDF content-stream operations compare equal. Each replacement has only the paired opposite horizontal centering offsets inserted by `relabel-flow.py`. Extracted text equals the historical text with those three substitutions, and numerical tokens retain their exact sequence. Resolved page resources and media box compare equal (PDF indirect object numbers were resolved before comparison). PNG (1096 × 944) and TIFF (4110 × 3543) pixel arrays equal fresh `pdftoppm` renders of the repaired PDF at their original dimensions. The duplicate output/figures PDF/PNG files equal the manuscript versions. No raster or PDF was written by these checks.

## Verification and integration status

Thirty focused verifier checks passed, covering valid reviewed updates; strict mode rejecting changed files; wrong historical/current hashes; no-op entries; malformed hashes/entries; blank rationales; missing files; duplicate JSON keys; empty manifests; paths absent from the baseline; refusal of Figure2, eFigure3, uninventoried figure3 copies and display-table2.csv exceptions; unapproved statistical-file changes; exact coordinate/value restriction of the label translation; and preservation of all original historical hashes with only the three explicit round4 additions.

A historical Table2 fixture fails parity against the current embedded manuscript table, demonstrating the expected prebuild mismatch remains detectable. At the time of final verification, the actual assembled table already matches the repaired standalone table and the full verifier passes. This task did not rebuild the manuscript. A stale assembly must still fail `Table 2: Word mismatch`; no prebuild exemption or partial-success mode was added.

The full verifier returned PASS: 109 historical protected files, ten approved exceptions, 99 remaining files unchanged, 23 references in first-use order, 79 display CSV values present in Word and HTML, three embedded Word tables equal to standalone tables, and five figures with alt text. This verifies the existing release-integrity gate; it does not establish completion of the separate analysis repair, a visual release review, or complete prose/caption parity beyond checks implemented by this verifier. The latest author direction removes arbitrary primary/secondary hierarchy and separately authorizes analysis repair; no statistical-code or analysis-plan conclusion is made here.

After all parent assembly/refresh work and the separate analysis handoff, rerun from the repository root:

```sh
/home/ali/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/bin/python3 docs/manuscript-development/verify-release.py --documentary-updates docs/manuscript-development/round5/documentary-updates.json
```

The verifier must pass on the final package. A future statistical-export change requires its own reviewed analysis resolution; it must not be added to this documentary manifest or accepted by replacing historical hashes.
