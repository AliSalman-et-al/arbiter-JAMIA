# Supporting publication documentary repair

The author-directed reporting repair is complete in the supporting R presentation sources, existing Word artifacts, results prose, reporting checklist CSVs and local results/supplement HTML. Evaluation outcomes have no primary/secondary or confirmatory hierarchy. Results prose presents Published exact agreement, independent-expert agreement, conditional blinded-label choices, then diagnostic and procedural checks. This is organization for this report after analysis, not retrospective prespecification. Historical analysis keys, filenames and statistical exports are retained.

The canonical manuscript, references and assembled Manuscript.docx were not edited or assembled by this task. No statistical analysis, resampling, full R publication build, plot generation, commit, push, deployment or nested-agent work was performed. Concurrent changes elsewhere in this shared checkout are not attributed to this repair.

## Evidence and scope

Read the latest section of `author-interview.md`, `interview-refinement/benchmark-provenance.md`, round3 `reporting-repair.md`, `workflow.md` and approved `documentary-updates.json`, `report-refresh.md`, the release verifier and relevant presentation builders. The documents skill was read at `/home/ali/.codex/plugins/cache/openai-primary-runtime/documents/26.1011.51657/skills/documents/SKILL.md`. The installed managed runtime manifest supplied the runtime paths; no workspace dependency-loader tool was exposed.

Actual published occurrences were identified by extracting all Word paragraphs and searching the R presentation sources. Changed designations included the Table 2 title, agreed-choice population label and note; supplement introductory/contents/group/eTable 9 headings and notes; Figure 3 caption prose; results sentences; and TRIPOD-LLM 14c. References to biological primary outcomes, secondary prevention, primary ACL reconstruction, source publications, original AVATAR quotations and primary cache-write assumptions remain intact. Historical `primary-endpoint`, `rules-only-primary` and related analysis keys/filenames are unchanged. Supplemental table order, table numbering, populations and conditional denominators are unchanged.

Experts are described, on author confirmation, as published researchers from BEACON Lab who received the same trial materials, supplements, ClinicalTrials.gov records and assessment task as the model arms, with access to Cochrane RoB 2 guidance. The task specified outcome(s), contrast and numerical anchor. The unsupported extra-source assertion was replaced. Individual qualifications, prior RoB 2 experience, training/calibration, the original blank form/instructions and conventions for combining multi-outcome targets remain unprovided. Credentials rows remain Partial.

Sampling prose now identifies author-supplied purposive cross-specialty review selection, Europe PMC, prioritization by citations/journal standing, within-review table-order sampling and availability-dependent replacement. It does not certify rankings, systematic selection or representativeness. Unrecovered search dates/ranking records and the additional General Medicine review rationale remain explicit. Target prose distinguishes original trial-primary candidates from revised published-review targets and the final `assess_outcome`/`assess_values_as_printed` fields. No target-match analysis or new exclusion was introduced.

Development on ARBITER `eval/` and nonuse of the benchmark in development are explicitly attributed to the author. A bounded local provenance search found references to `eval/` qualification records, not a complete independently audited development/benchmark overlap inventory. The supplement and TRIPOD-LLM 9b therefore retain pending verification; prompt design/selection and freeze history remain incomplete. No independent non-overlap finding is claimed.

## Owned write set and source correspondence

- `analysis/R/checklist.R`: current reporting locations and Partial notes, including clarified selection, matched task and development attestation.
- `analysis/R/manuscript-supplement.R`: matching methods/provenance prose, reporting-organization note, group/contents/eTable headings and conditional-choice notes.
- `analysis/R/displays.R`: Table 2 title, population label and note only; no data transformation or calculation changed.
- `analysis/R/display-numbering.R`: descriptive Table 2 content label only.
- `analysis/R/results-sentences.R`: output prose label and narrative ordering only; calculations unchanged.
- `analysis/R/manuscript-legends.R`: Figure 3 caption designation only.
- `analysis/output/manuscript/{Supplement.docx,TRIPOD-LLM.docx,Table2.docx}`: deterministic OOXML text repairs matching those sources. Tables 1 and 3 needed no label changes and remain byte-identical. No existing Results.docx is present; the existing results artifact is `results-sentences.md`.
- `analysis/output/manuscript/{results-sentences.md,figure-legends.md}`: matching prose. Published agreement now names both comparators explicitly after extraction into its own paragraph.
- `analysis/output/tables/{display-supplement-reporting-map.csv,reporting-checklist-skeleton.csv}`: matching six documentary rows (TRIPOD-LLM 5a, 8a, 9b, 14c; GRRAS 7, 8). Earlier unresolved 9a and individual-expertise rows remain Partial.
- `analysis/.quarto/{results-page.md,supplement-page.md}` and `analysis/{results.html,supplement.html}`: generated with the existing HTML-only refresh helper, including corrected contents/anchor labels. These generated surfaces follow the repository's ignore rules.
- This round5 report, `documentary-updates.json`, `changed-files.json`, `checks.json` and `render-checks.json` retain the handoff evidence.

## Invariance and manifest chain

The round5 documentary manifest carries forward every round3 approved entry and its original historical `old_sha256`; it updates current `new_sha256` values and adds explicitly authorized Table 2 and caption-prose exceptions. `baseline-hashes.json` and the round3 manifest were not edited. This preserves the historical baseline rather than accepting new artifacts as an unexplained baseline.

Table 2's historical and task-entry SHA-256 is `c09d2e4846c858164ced0b2f18805b12994cdc35011ee2f0dc29751c728e4d7a`; its repaired SHA-256 is `427182dd9c164f9e2c555653d7ce8d2c1f2a05e928bc7074a8194dadca70a165`. Exactly three paragraphs change: title, agreed-choice label and note. The single table retains all 11 physical cells, cell order, numerical tokens and nontext XML. Two cells change text (population label and note). No cell value, estimate, interval, denominator or sensitivity assumption changes.

The supplement retains 98 tables and 7,675 physical cells. Only two table-note cells change from “formal primary row” to “agreed-choice row”; all numerical tokens in every cell remain identical. The reporting map retains eight tables and 368 physical cells; eleven documentary cells change. Its new RoB 2 guidance reference adds a documentary numeral, so a blanket numerical-token identity claim for the reporting map would be false. Its study values are unaffected. Every DOCX ZIP member except `word/document.xml` remains identical, and stripping text from both versions yields identical XML, proving unchanged structure, formatting, relationships and order.

All 96 inventoried CSVs outside the two reporting-checklist CSVs remain byte-identical, including `display-table2.csv`. The numerical-token multiset of results prose is identical despite paragraph reordering. All nine evaluated eMethods source paragraphs exactly match Word and both supplementary HTML surfaces. All 64 display reporting-map CSV rows match their Word rows.

`changed-files.json` is an observed before/after inventory, not a claim of exclusive authorship: 17 inventoried files were written by this task. Seven other observed changes are outside its write set: `analysis/R/manuscript-figures.R`, `analysis/R/expert-agreement.R`, three manuscript Figure3 formats and two `output/figures/figure3` formats. They arose concurrently and were neither written nor reverted here; their hashes are recorded separately in `checks.json`. The HTML refresh embeds the figure bytes present when it runs. Each final refresh independently passed its own protected-source before/after checks.

## Verification and build limits

All six edited R sources pass base-R parsing. Only the first four top-level constant/prose expressions in the supplement source were evaluated to compare nine methods paragraphs; no inputs, estimates or analysis functions were loaded. `dplyr`, `tidyr`, `readr`, `readxl`, `officer`, `flextable` and `gt` remain unavailable. No package installation or full R build was attempted.

The supported Python/Quarto HTML-only refresh passes: three main tables, five final main images, 98 supplement tables, 13 supplementary images, 62 resolving contents links, 233 AVATAR trace paragraphs and all 288 retained supplement paragraphs. Word/HTML origin cells, results prose, complete captions, image bytes and local anchors match. The helper reports 155 protected publication/statistical artifacts unchanged across its own refresh. This is not a full R build, canonical-manuscript proof or browser-layout audit.

The document operation marker ran successfully once immediately before authoring (edit, three DOCX outputs). Managed Python and bundled LibreOffice `/home/ali/.cache/codex-runtimes/codex-primary-runtime/dependencies/bin/override/soffice` were used. Final Word renders are Supplement 141 pages, reporting map eight pages and Table 2 one page. Table 2 and every reporting-map page were inspected individually. The seven supplement pages with documentary text changes were inspected individually, including the contents, eMethods, eTable 9 and final provenance page. The contents repair preserves title text before the tab and page-number text after it; its page field remains 51. Differential evidence against the retained round3 render and PDF text/boundary checks are recorded in `render-checks.json`. The final render differs from the immediately preceding inspected render only on the repaired contents page, which was re-inspected; its boundary check also passes. The final comparison finds 25 pages pixel-identical to the historical round3 render; seven pages differ in extracted text. Pixel differences on other pages are not represented as individually re-reviewed. No new full 141-page individual-at-100-percent review is claimed; unchanged-page evidence inherits the historical proof rather than claiming a new complete visual release audit.

## Exact remaining parent integration

1. Extend `verify-release.py::DOCUMENTARY_PATHS` for the reviewed `Table2.docx` and `figure-legends.md` exceptions. The unchanged verifier currently stops with `Integrity check failed: Unauthorized documentary path: analysis/output/manuscript/Table2.docx`. With just those two explicit whitelist additions in memory, its historical protected-output function accepts all seven round5 manifest entries. No repository verifier change was made here.
2. Preserve the frozen CSV and teach the verifier its explicit documentary label correspondence: `display-table2.csv` retains `Agreed choices (formal primary)` while Word/HTML now use `Agreed choices`. Its current exact CSV-value assertion will otherwise fail after canonical reassembly. All numeric CSV fields match the repaired table. Do not broadly relax numerical or structural parity.
3. Once the other writer is finished, the parent should run the canonical manuscript assembler and final citation/table/Word/web checks. This task intentionally did not run it. Its current assembled manuscript may still contain the historical Table 2 and caption; that is not repaired merely by refreshing results/supplement HTML.
4. Reconcile the separately observed concurrent Figure 3 changes within the parent's artwork audit, then refresh/stage the final package as appropriate. No artwork exception was silently added to this task's documentary manifest.
5. Complete the parent release visual gate and outstanding author declarations, individual assessor details, prompt-development/freeze records and overlap audit. Search/ranking records and the additional-review rationale remain unrecovered.

## Exact commands

Commands ran from `/home/ali/Documents/Code/arbiter-JAMIA`. Temporary repair scripts include before copies and checks; they are an execution record, not a safe rerun recipe after new concurrent edits. The final scripts and all before copies remain under `/tmp/arbiter-round5/` for this session.

```sh
# Marker, once before first authoring command
/home/ali/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/bin/node /home/ali/.cache/codex-runtimes/codex-primary-runtime/plugins/openai-primary-runtime/plugins/documents/skills/documents/container_tools/mark_artifact_operation_started.mjs --operation-kind edit --expected-output-count 3 --output-format docx

# Deterministic documentary edits, in the order actually used
/home/ali/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/bin/python3 /tmp/arbiter-round5/repair.py
/home/ali/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/bin/python3 /tmp/arbiter-round5/tidy.py
/home/ali/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/bin/python3 /tmp/arbiter-round5/shorten-headings.py
/home/ali/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/bin/python3 /tmp/arbiter-round5/fix-toc-fields.py

# Final presentation refresh only; run again after parent changes final sources
/home/ali/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/bin/python3 scripts/report-refresh.py

# Syntax and constant/prose checks, no analysis execution
Rscript -e 'for (f in c("checklist", "manuscript-supplement", "displays", "display-numbering", "results-sentences", "manuscript-legends")) {parse(file=paste0("analysis/R/", f, ".R")); cat(f, "parse PASS\n")}'
Rscript -e 'x <- parse("analysis/R/manuscript-supplement.R"); for(i in 1:4) eval(x[[i]]); writeLines(unname(METHODS_APPENDIX), "/tmp/arbiter-round5/r-methods.txt")'

# Final artifacts and evidence; packaged renderer chooses bundled soffice
/home/ali/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/bin/python3 /home/ali/.codex/plugins/cache/openai-primary-runtime/documents/26.1011.51657/skills/documents/render_docx.py analysis/output/manuscript/Table2.docx --output_dir /tmp/arbiter-round5/render/Table2 --emit_pdf
/home/ali/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/bin/python3 /home/ali/.codex/plugins/cache/openai-primary-runtime/documents/26.1011.51657/skills/documents/render_docx.py analysis/output/manuscript/TRIPOD-LLM.docx --output_dir /tmp/arbiter-round5/render/TRIPOD-LLM --emit_pdf
/home/ali/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/bin/python3 /home/ali/.codex/plugins/cache/openai-primary-runtime/documents/26.1011.51657/skills/documents/render_docx.py analysis/output/manuscript/Supplement.docx --output_dir /tmp/arbiter-round5/render-delivery/Supplement --emit_pdf
/home/ali/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/bin/python3 /tmp/arbiter-round5/verify.py

# Expected integration failure until parent applies the two explicit exceptions
/home/ali/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/bin/python3 docs/manuscript-development/verify-release.py --documentary-updates docs/manuscript-development/round5/documentary-updates.json

git diff --check
```

The full verifier remains pending parent integration and canonical assembly; neither the in-memory protected-output probe nor the HTML refresh is represented as a full release PASS.
