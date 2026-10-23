# Publishing implementation handoff

Status: PASS for manuscript-only generation and focused checks. ISSUES remain for the existing complete Pages package. Nothing was committed, pushed, or deployed.

## Files

The two-option comparison and source ownership decision are in `publishing-design.md`.

New files are `scripts/build-manuscript.py`, `scripts/manuscript-sources.py`, `scripts/manuscript.css`, `scripts/publication-nav.html`, `scripts/test-manuscript.py`, `analysis/manuscript.qmd`, and `analysis/build-manuscript.R`.

Updated files are `scripts/stage-pages.py`, `scripts/verify-pages.py`, `scripts/test-pages.py`, `scripts/pages-index.html`, `scripts/publish-pages.sh`, `analysis/_quarto.yml`, `analysis/build-publication.R`, and `docs/manuscript/assemble-publication.py`.

The full builder adds the manuscript HTML after its established publication build. The manuscript-only builder uses Pandoc and the existing Python assembler with `--main-only`. It never loads analysis functions or rewrites the standalone tables, figures, supplement, or reporting map. Shared figure metadata removes the assembler's private alt-text copy. Table HTML is converted from final gt-produced Word tables, with semantic cells and readable CSS. The cell comparison handles physical merged cells rather than counting Word's repeated grid aliases as duplicate notes.

The manuscript page includes the canonical full text and references, three native tables at their first citations, and five embedded figures with full legends and alt text. Word retains the existing JAMIA assembly, editable gt tables, double-spaced prose, structured abstract, page fields, and separate figure legends. The generated `analysis/.quarto/manuscript-page.md` is disposable and ignored. `analysis/manuscript.html` follows the existing ignored-HTML convention.

## Commands and evidence

The system Python lacks `python-docx`. The existing managed runtime has `python-docx`, `lxml`, and `pdf2image`. Its interpreter was used; the document marker and renderer were available and ran. This was the authorized repository assembly workflow, rather than a new document-authoring runtime.

```bash
/home/ali/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/bin/python scripts/build-manuscript.py
python3 scripts/test-pages.py
ARBITER_CHECK_BUILT=1 /home/ali/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/bin/python scripts/test-manuscript.py
```

PASS: initial complete manuscript-only build reported 2932 main words and 229 abstract words. Subsequent HTML-only builds passed. The R wrapper also passed with `ARBITER_PYTHON` set to that interpreter and `Rscript build-manuscript.R --html-only` from `analysis/`, despite the incomplete R package library. No R analysis or resampling ran.

PASS: nine Pages tests cover required manuscript staging, its Word link, containment, exact staged hashes, navigation insertion, binary preservation, old-manifest rejection, and detection of changed deployed manuscript bytes. Five manuscript tests cover complete prose/reference preservation, citation placement, five legends, native table equality, embedded images with alt text, and unique HTML anchors. The built HTML has 23 reference entries, three tables containing 23, 11, and 48 physical cells, and five embedded figures. Every table cell and note matches its final standalone Word source. All 19 manuscript local links resolve against the staged package.

PASS: `git diff --check`, Python compilation, and `sh -n scripts/publish-pages.sh`.

PASS with scope limit: local HTTP verification checked all 50 staged file hashes and sizes, including `manuscript.html` and `Manuscript.docx`. Evidence is `/tmp/arbiter-manuscript-manifest-verification.json`. This verifies transfer integrity only; it does not override the broken-link failure below or claim a live deployment.

The Word renderer produced 24 LibreOffice pages under `/tmp/arbiter-manuscript-proof/`, including `Manuscript.pdf`. The title, abstract, all three table pages, and first legend page received a contact-sheet check. Table 3 received reading-size inspection. These checks found no clipping in the inspected pages. This is not a replacement for the parent's final all-page audit after prose changes. The accepted historical proof used a different renderer and had 23 pages.

T3 preview opened the page, but two snapshot calls returned `Preview automation snapshot timed out after 15000ms.` A local Chrome fallback rendered the article title, abstract, contents, and navigation for inspection. A later table-fragment screenshot was blank, so no successful browser table-layout inspection is claimed for that attempt. Native-table DOM and equality checks passed.

## Remaining issues

`python3 scripts/stage-pages.py /tmp/arbiter-manuscript-pages` correctly exits nonzero with `results.html: output/manuscript/Table4.docx`. The local results and supplement HTML predate final acceptance; the accepted source has three main tables. The missing link was not hidden and no obsolete fourth table was added. Refresh the existing results and supplement HTML using the final accepted pipeline before release. This environment has Quarto and R but lacks `dplyr` and `gt`, so the full existing R report refresh was not attempted. The manuscript-only path works without those packages.

The writer changed the canonical manuscript and references during this task, after the initial build and proof. Rerun the manuscript-only build and final prose/number/visual checks after the writer finishes. The recorded word counts describe the tested initial draft. The publisher did not edit either canonical file, author details, statistical sources, outputs, or figures. Among final publication artifacts, only `Manuscript.docx` was regenerated.

After final audit, stage again and use the existing publisher and deployment verifier. Do not report publication complete until the live verifier passes. No publication command was run here.
