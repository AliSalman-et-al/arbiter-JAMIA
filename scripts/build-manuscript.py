#!/usr/bin/env python3
"""Build manuscript HTML and assembled Word using finalized displays only."""
from __future__ import annotations

import argparse
import html
import importlib.util
import os
from pathlib import Path
import re
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parents[1]
ANALYSIS = ROOT / 'analysis'
OUT = ANALYSIS / 'output/manuscript'
spec = importlib.util.spec_from_file_location('manuscript_sources', Path(__file__).with_name('manuscript-sources.py'))
metadata = importlib.util.module_from_spec(spec)
spec.loader.exec_module(metadata)


def canonical_markdown():
    main = (ROOT / 'docs/manuscript/manuscript.md').read_text(encoding='utf-8')
    main = re.sub(r'^Word counts:.*\n?', '', main, flags=re.M)
    return main.rstrip() + '\n\n' + (ROOT / 'docs/manuscript/references.md').read_text(encoding='utf-8')


def run(*args):
    subprocess.run([str(a) for a in args], cwd=ANALYSIS, check=True)


def manuscript_page(text, tables, legends):
    # Match the Word assembler's first-citation placement without editing prose.
    blocks = []
    pending = dict(enumerate(tables, 1))
    for block in re.split(r'\n\s*\n', text):
        if block.strip() == '## Front-matter notes':
            continue
        blocks.append(block)
        for i in list(pending):
            if re.search(rf'\bTable {i}\b', block):
                table = pending.pop(i)
                blocks.append(f'```{{=html}}\n<section class="manuscript-table" aria-label="Table {i}">\n{table}\n</section>\n```\n\n[Download editable Table {i} (Word)](output/manuscript/Table{i}.docx)')
    if pending:
        raise ValueError(f'Manuscript has no Table {next(iter(pending))} citation.')
    figures = ['## Figures']
    for i, (caption, alt) in enumerate(legends, 1):
        figures.append(f'''### Figure {i}

```{{=html}}
<figure class="manuscript-figure" id="artwork-{i}">
<img src="output/manuscript/Figure{i}.png" alt="{html.escape(alt, quote=True)}">
<figcaption>{html.escape(caption)}</figcaption>
</figure>
```

[Figure {i} PDF](output/manuscript/Figure{i}.pdf) · [PNG](output/manuscript/Figure{i}.png)''')
        if i == 2:
            figures.append(metadata.worked_example_markdown())
    return '\n\n'.join(blocks + figures) + '\n'


def build(html_only=False):
    required = [OUT / f'Table{i}.docx' for i in range(1, metadata.MAIN_TABLE_COUNT + 1)]
    required += [OUT / f'Figure{i}.{ext}' for i in range(1, metadata.MAIN_FIGURE_COUNT + 1) for ext in ('png', 'pdf')]
    required += [OUT / 'figure-legends.md']
    missing = [str(p) for p in required if not p.is_file()]
    if missing:
        raise SystemExit('Final publication displays are required:\n' + '\n'.join(missing))
    # Validate prose and legends before replacing the Word artifact.
    text = canonical_markdown()
    legends = metadata.main_legends((OUT / 'figure-legends.md').read_text(encoding='utf-8'))
    qa = OUT / 'qa'
    qa.mkdir(parents=True, exist_ok=True)
    tables = []
    with tempfile.TemporaryDirectory(prefix='arbiter-manuscript-') as folder:
        for i in range(1, metadata.MAIN_TABLE_COUNT + 1):
            target = Path(folder) / f'Table{i}.html'
            run('quarto', 'pandoc', OUT / f'Table{i}.docx', '--to=html', f'--output={target}')
            table = target.read_text(encoding='utf-8')
            # Word's standalone table title is an h1 in Pandoc's fragment.
            # Keep one article h1 and a local caption-sized table heading.
            table = re.sub(r'<h1([^>]*)>(.*?)</h1>', r'<p\1 class="table-title"><strong>\2</strong></p>', table, flags=re.S)
            tables.append(table)
    page = manuscript_page(text, tables, legends)
    generated = ANALYSIS / '.quarto/manuscript-page.md'
    generated.parent.mkdir(parents=True, exist_ok=True)
    generated.write_text(page, encoding='utf-8')
    (qa / 'manuscript-assembled.md').write_text(text, encoding='utf-8')
    if not html_only:
        python = os.environ.get('ARBITER_PYTHON', sys.executable)
        run(python, '-c', 'import docx, lxml')
        # Existing assembler enforces manuscript hierarchy, typography, pagination,
        # cell-for-cell table equality and five legends. --main-only protects supplement.
        with tempfile.TemporaryDirectory(prefix='arbiter-word-') as folder:
            staged = Path(folder) / 'Manuscript.docx'
            run('quarto', 'pandoc', qa / 'manuscript-assembled.md', '--from=markdown', '--to=docx', f'--output={staged}')
            os.replace(staged, OUT / 'Manuscript.docx')
        run(python, ROOT / 'docs/manuscript/assemble-publication.py', '--main-only')
    run('quarto', 'render', 'manuscript.qmd')
    print('PASS: manuscript HTML built from canonical Markdown, 3 native tables and 5 final figures.'
          + ('' if html_only else ' Manuscript Word assembled; supplement and analyses were not rebuilt.'))


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--html-only', action='store_true', help='Reuse an already assembled Manuscript.docx.')
    build(parser.parse_args().html_only)
