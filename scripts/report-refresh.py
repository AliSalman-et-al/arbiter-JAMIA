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
    for heading in root.xpath('.//p[contains(@class,"heading")]'):
        heading.tag = 'h2'
    nav = dom.Element('details')
    etree.SubElement(nav, 'summary').text = 'Contents and stable display locators'
    listing = etree.SubElement(nav, 'ul')
    contents.getparent().replace(contents, nav)
    seen = {}
    for heading in root.xpath('.//h1|.//h2|.//h3'):
        title = normalized(heading.text_content())
        slug = 'supp-' + re.sub(r'[^a-z0-9]+', '-', title.lower()).strip('-')
        seen[slug] = seen.get(slug, 0) + 1
        heading.set('id', slug + (f'-{seen[slug]}' if seen[slug] > 1 else ''))
        heading.tag = 'h2' if title.startswith('eTable ') or title == 'Prompt templates and run provenance' else 'h3'
        if '(continued ' not in title:
            etree.SubElement(etree.SubElement(listing, 'li'), 'a', href='#' + heading.get('id')).text = title
    target = next(h for h in root.xpath('.//h3') if normalized(h.text_content()) == 'Algorithms and validation')
    heading = dom.Element('h2')
    heading.text = 'Supplementary methods'
    target.addprevious(heading)


def protected_hashes():
    paths = list((ANALYSIS / 'output/tables').rglob('*.csv'))
    paths += [p for p in OUT.rglob('*') if p.is_file() and p.parent.name != 'qa'
              and p.suffix.lower() in {'.docx', '.png', '.pdf', '.svg', '.tiff'}]
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
    assert root.xpath('//*[@id="publication-navigation"]//a[@href="results.html"]')
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
            if i == 2:
                blocks.append(metadata.worked_example_markdown())
        blocks.append('## Tables')
        for i in range(1, metadata.MAIN_TABLE_COUNT + 1):
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
        for page in ('results', 'supplement'):
            run('quarto', 'render', f'{page}.qmd')
        results = verify_page(ANALYSIS / 'results.html', [OUT / f'Table{i}.docx' for i in range(1, metadata.MAIN_TABLE_COUNT + 1)], metadata.MAIN_TABLE_COUNT, [(OUT / f'Figure{i}.png').read_bytes() for i in range(1, metadata.MAIN_FIGURE_COUNT + 1)])
        supplement = verify_page(ANALYSIS / 'supplement.html', [OUT / 'Supplement.docx'], len(word_cells(OUT / 'Supplement.docx')), image_bytes)
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
        navigation_links = supplement.xpath('//details/ul/li/a')
        assert navigation_links, 'Supplement contents missing'
        assert not image_bytes, 'Retired supplementary figures remain embedded'
        for number in range(1, 7):
            assert any(normalized(a.text_content()).startswith(f'eTable {number}.') for a in navigation_links), f'Missing eTable {number}'
        assert before == protected_hashes(), 'Protected publication/statistical sources changed'
        evidence = {'protected_sha256': before, 'main_tables': metadata.MAIN_TABLE_COUNT, 'main_images': metadata.MAIN_FIGURE_COUNT,
                    'supplement_tables': len(word_cells(OUT / 'Supplement.docx')), 'supplement_images': image_count,
                    'supplement_contents_links': len(navigation_links),
                    'supplement_paragraphs': len(source_paragraphs),
                    'html_sha256': {name: hashlib.sha256((ANALYSIS / name).read_bytes()).hexdigest()
                                    for name in ('results.html', 'supplement.html')}}
        (GENERATED / 'report-refresh-verification.json').write_text(json.dumps(evidence, indent=2) + '\n', encoding='utf-8')
        print(f'PASS: {metadata.MAIN_TABLE_COUNT} main tables, {metadata.MAIN_FIGURE_COUNT} figures; '
              f"{evidence['supplement_tables']} supplementary tables, {image_count} images; "
              f'{len(source_paragraphs)} supplement paragraphs and all physical cells preserved; '
              f'{len(before)} protected artifacts unchanged.')


if __name__ == '__main__':
    build()
