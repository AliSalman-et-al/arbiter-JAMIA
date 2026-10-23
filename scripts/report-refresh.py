#!/usr/bin/env python3
"""Refresh reader HTML from finalized artifacts; never run statistical analysis."""
from __future__ import annotations

import base64
import hashlib
import json
import html
import importlib.util
from pathlib import Path
import re
import subprocess
import sys
import tempfile

from docx import Document
from lxml import etree, html as dom

ROOT = Path(__file__).resolve().parents[1]
ANALYSIS = ROOT / 'analysis'
OUT = ANALYSIS / 'output/manuscript'
GENERATED = ANALYSIS / '.quarto'
spec = importlib.util.spec_from_file_location('manuscript_sources', ROOT / 'scripts/manuscript-sources.py')
metadata = importlib.util.module_from_spec(spec)
spec.loader.exec_module(metadata)


def run(*args):
    subprocess.run([str(arg) for arg in args], cwd=ANALYSIS, check=True)


def normalized(text):
    return ' '.join(text.replace('\ufe0e', '').split())


def word_cells(path):
    # Origin cells, excluding empty vertical-merge continuations (HTML rowspan).
    return [
        [normalized(' '.join(''.join(p.xpath('.//w:t/text()')) for p in cell.xpath('./w:p')))
         for cell in table._tbl.xpath('./w:tr/w:tc')
         if not cell.xpath('./w:tcPr/w:vMerge[not(@w:val) or @w:val="continue"]')]
        for table in Document(path).tables]


def html_cells(root):
    return [[normalized(cell.text_content()) for cell in table.xpath('./thead/tr/th|./thead/tr/td|./tbody/tr/th|./tbody/tr/td|./tr/th|./tr/td|./tfoot/tr/th|./tfoot/tr/td')]
            for table in root.xpath('.//table')]


def assert_cells(path, root):
    expected, actual = word_cells(path), html_cells(root)
    if expected != actual:
        raise ValueError(f'HTML table cells differ from final Word source: {path.name}')


def fragment(text):
    return dom.fragment_fromstring(text, create_parent='div')


def serialize(root):
    return dom.tostring(root, encoding='unicode')


def raw_html(text):
    return '\n```{=html}\n' + text + '\n```\n'


def supplement_navigation(root):
    # Retain the established native-table-html.py contents/heading policy.
    for heading in root.xpath('.//h1|.//p[contains(@class,"heading")]'):
        if normalized(heading.text_content()) == 'ARBITER supplementary methods and results':
            heading.getparent().remove(heading)
    contents = next(p for p in root.xpath('.//p|.//h2')
                    if normalized(p.text_content()) == 'Contents and stable display locators')
    node = contents.getnext()
    while node is not None and normalized(node.text_content()) != 'Algorithms and validation':
        following = node.getnext()
        node.getparent().remove(node)
        node = following
    if node is None:
        raise ValueError('Supplement methods boundary missing')
    for p in root.xpath('.//p[contains(@class,"heading")]'):
        title = normalized(p.text_content())
        p.tag = 'h1' if re.match(r'^[1-7]\. |^AVATAR complete trace$|^Prompt templates and run provenance$', title) else 'h2'
    nav = dom.Element('details')
    etree.SubElement(nav, 'summary').text = 'Contents and stable display locators'
    listing = etree.SubElement(nav, 'ul')
    seen = {}
    before_results = True
    for heading in root.xpath('.//h1|.//h2|.//h3'):
        title = normalized(heading.text_content())
        if heading is contents:
            heading.getparent().replace(heading, nav)
            continue
        slug = 'supp-' + re.sub(r'[^a-z0-9]+', '-', title.lower()).strip('-')
        seen[slug] = seen.get(slug, 0) + 1
        heading.set('id', slug + (f'-{seen[slug]}' if seen[slug] > 1 else ''))
        heading.tag = 'h' + str(min(6, int(heading.tag[1]) + 1))
        if re.match(r'^1\. ', title):
            before_results = False
        if title == 'Prompt templates and run provenance':
            heading.tag = 'h2'
        selected = before_results or bool(re.match(r'^(eTable \d|eFigure [1-5]|[1-7]\. |AVATAR complete trace$|Prompt templates and run provenance$)', title))
        if selected and '(continued ' not in title:
            etree.SubElement(etree.SubElement(listing, 'li'), 'a', href='#' + heading.get('id')).text = title
    for prefix, label in [('Algorithms and validation', 'Supplementary methods'), ('eFigure 1.', 'Supplementary figures')]:
        target = next(h for h in root.xpath('.//h2|.//h3|.//h4') if normalized(h.text_content()).startswith(prefix))
        heading = dom.Element('h2')
        heading.text = label
        target.addprevious(heading)


def protected_hashes():
    # Manuscript.docx belongs to the parent writer; it may change concurrently.
    paths = list((ANALYSIS / 'output/tables').rglob('*.csv'))
    paths += [p for p in OUT.rglob('*') if p.is_file() and p.parent.name != 'qa'
              and p.suffix.lower() in {'.docx', '.png', '.pdf', '.svg', '.tiff'}
              and p.name != 'Manuscript.docx']
    return {str(p.relative_to(ROOT)): hashlib.sha256(p.read_bytes()).hexdigest() for p in paths}


def verify_page(path, sources, expected_tables, expected_images):
    root = dom.parse(str(path)).getroot()
    expected = [cells for source in sources for cells in word_cells(source)]
    assert html_cells(root) == expected, f'{path.name}: native table mismatch'
    assert len(expected) == expected_tables
    images = root.xpath('//main//img')
    assert len(images) == len(expected_images), (path.name, len(images), len(expected_images))
    assert all(img.get('src', '').startswith('data:image/') for img in images)
    assert [base64.b64decode(img.get('src').split(',', 1)[1]) for img in images] == expected_images, f'{path.name}: embedded image bytes differ'
    ids = root.xpath('//@id')
    assert len(ids) == len(set(ids)), f'{path.name}: duplicate anchors'
    for href in root.xpath('//@href'):
        if href.startswith('#') and len(href) > 1:
            assert href[1:] in ids, f'{path.name}: missing anchor {href}'
    assert root.xpath('//*[@id="publication-navigation"]//a[@href="manuscript.html"]')
    return root


def build():
    before = protected_hashes()
    GENERATED.mkdir(exist_ok=True)
    with tempfile.TemporaryDirectory(prefix='arbiter-report-refresh-') as folder:
        folder = Path(folder)
        blocks = ['## Results\n\n' + (OUT / 'results-sentences.md').read_text(encoding='utf-8'), '## Figures']
        legends = metadata.main_legends((OUT / 'figure-legends.md').read_text(encoding='utf-8'))
        for i, (caption, alt) in enumerate(legends, 1):
            blocks.append(f'### Figure {i}\n\n' + raw_html(
                f'<figure class="manuscript-figure"><img src="output/manuscript/Figure{i}.png" alt="{html.escape(alt, quote=True)}">'
                f'<figcaption>{html.escape(caption)}</figcaption></figure>') +
                f'\n[Download figure PDF](output/manuscript/Figure{i}.pdf) · [PNG](output/manuscript/Figure{i}.png)')
        blocks.append('## Tables')
        for i in range(1, 4):
            target = folder / f'Table{i}.html'
            source = OUT / f'Table{i}.docx'
            run('quarto', 'pandoc', source, '--to=html', f'--output={target}')
            root = fragment(target.read_text(encoding='utf-8'))
            assert_cells(source, root)
            for heading in root.xpath('.//h1'):
                heading.tag = 'p'
                heading.set('class', 'table-title')
            for table in root.xpath('.//table'):
                table.set('data-quarto-disable-processing', 'true')
            blocks.append(f'### Table {i}\n\n' + raw_html(
                f'<section class="manuscript-table" aria-label="Table {i}">{serialize(root)}</section>') +
                f'\n[Download editable Word table](output/manuscript/Table{i}.docx)')
        (GENERATED / 'results-page.md').write_text('\n\n'.join(blocks) + '\n', encoding='utf-8')
        body = folder / 'supplement.html'
        # Disposable media are embedded by Quarto; no final figure is rewritten.
        media = GENERATED / 'report-refresh-media'
        run('quarto', 'pandoc', OUT / 'Supplement.docx', '--to=html',
            f'--extract-media={media}', f'--output={body}')
        root = fragment(body.read_text(encoding='utf-8'))
        assert_cells(OUT / 'Supplement.docx', root)
        image_bytes = [Path(img.get('src')).read_bytes() for img in root.xpath('.//img')]
        image_count = len(image_bytes)
        supplement_navigation(root)
        for table in root.xpath('.//table'):
            table.set('data-quarto-disable-processing', 'true')
            wrapper = dom.Element('div', {'class': 'manuscript-table supplement-table'})
            table.addprevious(wrapper)
            wrapper.append(table)
        styles = '<style>.supplement-table table {min-width:36rem; width:100%} .supplement-table td, .supplement-table th {padding:.45rem .65rem} .supplement-table img {max-width:100%; height:auto} main img {max-width:100%; height:auto}</style>'
        (GENERATED / 'supplement-page.md').write_text(raw_html(styles + serialize(root)), encoding='utf-8')
        # Quarto parses every project include even when rendering a single page.
        # On a clean checkout, create the manuscript include only after the two
        # report includes exist; the HTML-only helper does not rewrite Word.
        if not (GENERATED / 'manuscript-page.md').is_file():
            run(sys.executable, ROOT / 'scripts/build-manuscript.py', '--html-only')
        for page in ('results', 'supplement'):
            run('quarto', 'render', f'{page}.qmd')
        results = verify_page(ANALYSIS / 'results.html', [OUT / f'Table{i}.docx' for i in range(1, 4)], 3, [(OUT / f'Figure{i}.png').read_bytes() for i in range(1, 6)])
        supplement = verify_page(ANALYSIS / 'supplement.html', [OUT / 'Supplement.docx'], 98, image_bytes)
        rendered = normalized(results.text_content())
        for paragraph in (OUT / 'results-sentences.md').read_text(encoding='utf-8').split('\n\n'):
            assert normalized(paragraph) in rendered
        for caption, alt in legends:
            assert normalized(caption) in rendered
            assert results.xpath('//img[@alt=$alt]', alt=alt)
        assert 'Table4.docx' not in (ANALYSIS / 'results.html').read_text(encoding='utf-8')
        # Exact converted paragraph text outside the superseded Word contents is retained.
        source_paragraphs = root.xpath('.//p')
        supplement_text = normalized(supplement.text_content())
        for paragraph in source_paragraphs:
            assert normalized(paragraph.text_content()) in supplement_text
        # Round six adds the Benchmark construction and exclusions eMethods heading.
        assert len(supplement.xpath('//details/ul/li/a')) == 63
        trace = root.xpath('//*[@id="supp-avatar-complete-trace"]')[0]
        trace_paragraphs = []
        for node in trace.itersiblings():
            if node.tag == 'h2' and normalized(node.text_content()) == 'Prompt templates and run provenance':
                break
            if node.tag == 'p':
                trace_paragraphs.append(normalized(node.text_content()))
        assert len(trace_paragraphs) == 233, 'Unexpected finalized trace inventory'
        assert before == protected_hashes(), 'Protected publication/statistical sources changed'
        evidence = {'protected_sha256': before, 'main_tables': 3, 'main_images': 5,
                    'supplement_tables': 98, 'supplement_images': image_count,
                    'supplement_contents_links': 63, 'trace_paragraphs': len(trace_paragraphs),
                    'supplement_paragraphs': len(source_paragraphs),
                    'html_sha256': {name: hashlib.sha256((ANALYSIS / name).read_bytes()).hexdigest()
                                    for name in ('results.html', 'supplement.html')}}
        (GENERATED / 'report-refresh-verification.json').write_text(json.dumps(evidence, indent=2) + '\n', encoding='utf-8')
        print(f'PASS: 3 main tables, 5 figures; 98 supplementary tables, {image_count} images; '
              f'{len(source_paragraphs)} supplement paragraphs and all physical cells preserved; '
              f'{len(before)} protected artifacts unchanged.')


if __name__ == '__main__':
    build()
