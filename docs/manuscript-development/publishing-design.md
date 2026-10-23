# Manuscript publishing design

The canonical prose is `docs/manuscript/manuscript.md` and `references.md`. The writer owns both files. Publishing code reads them without editing or maintaining another copy. The 22 October final acceptance and JAMA style contract govern presentation; JAMIA retains its required abstract and document organization.

## Shared Markdown through Quarto

A manuscript-only builder combines the canonical files into a generated intermediate. Quarto renders that text with existing final native tables, figures, and legends. The existing Word assembler inserts the same final Word tables. This adds one page to the established Quarto project, keeps heading navigation and embedded resources, and avoids a second Markdown renderer. Final standalone Word tables are the reusable table source because the ignored gt HTML intermediates may be absent in a clean checkout.

## Generate HTML directly

A Python builder could call Pandoc for the canonical Markdown and then write its own HTML shell, contents list, resource embedding, and table styling. This avoids a Quarto page but duplicates services already supplied by Quarto and creates another rendering contract to maintain.

## Decision and ownership

Use shared Markdown through Quarto. This is the smallest robust extension of the existing pipeline. Generated intermediates are disposable. Tables come from the finalized `Table1.docx` through `Table3.docx`, preserving editable cell text and notes. Figures and captions come from existing publication artifacts. Shared figure metadata supplies the same alt text to HTML and Word. The manuscript-only build never calls `build_displays()`, statistical analyses, figure generation, or supplement assembly.

Run `python3 scripts/build-manuscript.py` from the repository root with Python packages `python-docx` and `lxml`, plus Quarto on PATH. Set `ARBITER_PYTHON` when using another Python interpreter. The builder produces `analysis/manuscript.html` and replaces only `analysis/output/manuscript/Manuscript.docx` among final artifacts. Run `python3 scripts/test-pages.py` and `python3 scripts/test-manuscript.py` for focused checks. Stage with `python3 scripts/stage-pages.py /tmp/arbiter-pages`; staging requires the existing results and supplement artifacts. Publishing remains a separate release action subject to the final audit.
