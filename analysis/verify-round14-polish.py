#!/usr/bin/env python3
"""Verify citation identity, coverage/order and numerical invariance vs 85a4c6f.

--write-map regenerates the map from the reviewed paragraph/caption contract.
Run with the round-14 QA Python environment (lxml and PyMuPDF).
The contract names intended items independently of their display numbers.
"""
import argparse
from collections import Counter
import csv
import io
import json
from pathlib import Path
import re
import subprocess
from xml.etree import ElementTree as ET
from zipfile import ZipFile

ROOT = Path(__file__).resolve().parents[1]
BASE = '85a4c6f'
QA = ROOT / 'analysis/output/manuscript/qa'
AUDIT = ROOT / 'analysis/round14-verification'
MAP = QA / 'round14-polish-numbering.csv'
REF = re.compile(r'\b(eTables?|eFigures?)\s+(\d+(?:(?:\s*[–-]\s*|\s+and\s+|\s*,\s*)\d+)*)')
NUM = re.compile(r'[−-]?\d+(?:[.,]\d+)*')
W = {'w': 'http://schemas.openxmlformats.org/wordprocessingml/2006/main'}


def baseline(path):
    return subprocess.check_output(['git', 'show', f'{BASE}:{path}'], cwd=ROOT)


def inventory():
    text = baseline('analysis/output/manuscript/qa/round14-supplement-inventory.txt').decode()
    rows = [('eTable', int(n), caption) for n, caption in
            re.findall(r'^eTable (\d+)\. (.*)$', text, re.M)]
    return rows + [('eFigure', 1, 'Agreement with Published varied across meta-analyses')]


def refs(text):
    for match in REF.finditer(text):
        kind = 'eTable' if match[1].startswith('eTable') else 'eFigure'
        for part in re.split(r'\s+and\s+|\s*,\s*', match[2]):
            ends = re.split(r'\s*[–-]\s*', part)
            for n in range(int(ends[0]), int(ends[-1]) + 1):
                yield kind, n


def normal(text):
    return ' '.join(text.split())


def docx_blocks(data):
    with ZipFile(io.BytesIO(data)) as z:
        tree = ET.fromstring(z.read('word/document.xml'))
    return [normal(''.join(t.text or '' for t in p.findall('.//w:t', W)))
            for p in tree.findall('.//w:p', W)]


def html_blocks(data):
    from lxml import html
    tree = html.fromstring(data)
    # These contain code, embedded fonts/images and TOC duplicates, not displayed claims.
    for node in tree.xpath('//script|//style|//nav'):
        node.drop_tree()
    return [normal(n.text_content()) for n in tree.xpath('//p|//h1|//h2|//h3|//h4|//h5|//h6')]


def blocks(path, data):
    if path.endswith('.docx'):
        return docx_blocks(data)
    if path.endswith('.html'):
        return html_blocks(data)
    return [normal(p) for p in data.decode().split('\n\n')]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--write-map', action='store_true')
    args = parser.parse_args()
    intended = json.loads((AUDIT / 'polish-citation-intent.json').read_text())
    old = {(kind, n): caption for kind, n, caption in inventory()}
    if args.write_map:
        order = []
        for paragraph in intended:
            for caption in paragraph['intended_captions']:
                if caption not in order:
                    order.append(caption)
        counts = Counter()
        rows = []
        for caption in order:
            kind, n = next(key for key, value in old.items() if value == caption)
            counts[kind] += 1
            rows.append(dict(kind=kind, old_number=n, new_number=counts[kind], caption=caption))
        with MAP.open('w') as f:
            writer = csv.DictWriter(f, fieldnames=['kind', 'old_number', 'new_number', 'caption'])
            writer.writeheader()
            writer.writerows(rows)
    rows = list(csv.DictReader(MAP.open()))
    new = {(r['kind'], int(r['new_number'])): r['caption'] for r in rows}
    assert {(r['kind'], int(r['old_number'])): r['caption'] for r in rows} == old
    assert len(new) == len(old) == 33
    manuscript = (ROOT / 'docs/manuscript/manuscript.md').read_text()
    current = [p for p in manuscript.split('\n\n') if REF.search(p)]
    assert len(current) == len(intended)
    for paragraph, contract in zip(current, intended):
        assert REF.sub('<supplement>', paragraph) == contract['context'], paragraph
        assert [new[key] for key in refs(paragraph)] == contract['intended_captions'], paragraph
    for kind in ('eTable', 'eFigure'):
        cited = list(dict.fromkeys(n for k, n in refs(manuscript) if k == kind))
        assert cited == list(range(1, 1 + sum(k == kind for k, _ in new))), cited
    # Every pre-existing reference-bearing block retains its intended identity.
    # A number's existence alone cannot pass this test: context + target must match.
    def identities(text, lookup):
        def replace(match):
            return '<' + '|'.join(lookup[k] for k in refs(match[0])) + '>'
        return REF.sub(replace, text)

    checked = []
    paths = subprocess.check_output(['git', 'ls-tree', '-r', '--name-only', BASE], cwd=ROOT, text=True).splitlines()
    publication = [p for p in paths if
                   (p.startswith('analysis/output/manuscript/') and '/qa/' not in p
                    and p.endswith(('.md', '.docx')))
                   or p in ('analysis/results.html', 'analysis/supplement.html')]
    for path in publication:
        a = blocks(path, baseline(path))
        b = blocks(path, (ROOT / path).read_bytes())
        lookup = dict(old)
        if path.endswith('figure1-notes.md'):
            # Frozen notes used the pre-round-14 AVATAR number, already resolved
            # by the legend builder at baseline. WP-P updates the notes themselves.
            lookup['eTable', 31] = 'AVATAR complete trace'
        before = Counter(identities(p, lookup) for p in a if REF.search(p))
        after = Counter(identities(p, new) for p in b if REF.search(p))
        assert before == after, (path, before - after, after - before)
        # Paragraph-level numerical streams retain sign, precision, multiplicity
        # and local association even when whole tables move in the supplement.
        before_n = Counter(tuple(NUM.findall(REF.sub('<ref>', p))) for p in a if NUM.search(REF.sub('<ref>', p)))
        after_n = Counter(tuple(NUM.findall(REF.sub('<ref>', p))) for p in b if NUM.search(REF.sub('<ref>', p)))
        assert before_n == after_n, (path, 'numeric paragraph mismatch', before_n - after_n, after_n - before_n)
        checked.append(dict(path=path, reference_blocks=sum(after.values()), numeric_blocks=sum(after_n.values())))
    # HTML reports are intentionally gitignored, so their baseline is the
    # committed Word/legend/results content, whose invariance is checked above.
    def context(text):
        return re.sub(r'[^\w]', '', identities(text, new)).lower()

    sources = {}
    for path in publication:
        sources[path] = blocks(path, (ROOT / path).read_bytes())
    for name in ('results', 'supplement'):
        path = f'analysis/{name}.html'
        actual = html_blocks((ROOT / path).read_bytes())
        if name == 'supplement':
            expected = sources['analysis/output/manuscript/Supplement.docx']
        else:
            expected = sum((value for key, value in sources.items()
                            if re.search(r'/Table[1-4][.]docx$|/figure-legends[.]md$|/results-sentences[.]md$', key)), [])
        intended_contexts = {context(p) for p in expected if REF.search(p)}
        cited = [p for p in actual if REF.search(p)]
        for paragraph in cited:
            assert context(paragraph) in intended_contexts, (path, 'HTML target/context differs from verified source', paragraph)
        assert cited, path
        if name == 'supplement':
            from lxml import html
            headings = html.fromstring((ROOT / path).read_bytes()).xpath('//h3')
            table_headings = [normal(p.text_content()).rstrip('¶').strip() for p in headings
                              if normal(p.text_content()).startswith('eTable ')]
            assert len(table_headings) == 32
            for heading in table_headings:
                key = next(refs(heading))
                assert new[key] in heading, heading
        checked.append(dict(path=path, reference_blocks=len(cited), baseline='verified committed Word/Markdown sources'))
    # All CSV cells, including strings and numbers, are unchanged, except the
    # reporting-map location references. No numeric estimate is exempted.
    csvs = []
    for path in paths:
        if path.startswith('analysis/output/tables/') and path.endswith('.csv'):
            before = list(csv.reader(io.StringIO(baseline(path).decode('utf-8-sig'))))
            after = list(csv.reader((ROOT / path).open(encoding='utf-8-sig')))
            if path.endswith('reporting-checklist.csv'):
                before = [[identities(v, old) for v in row] for row in before]
                after = [[identities(v, new) for v in row] for row in after]
            assert before == after, path
            csvs.append(path)
    # Empirical manuscript numbers stay in order; added tokens are display refs.
    def empirical(text):
        text = re.split(r'^## Draft completion notes', text, flags=re.M)[0]
        return NUM.findall(REF.sub('<ref>', text))
    assert empirical(baseline('docs/manuscript/manuscript.md').decode()) == empirical(manuscript)
    # Frozen inputs, lockfiles and all figure artwork remain byte-identical.
    immutable = [p for p in paths if p.startswith(('kit-', 'no-kit-', 'human-adjudication/',
                 'rob2-meta-benchmark-set/', 'analysis/data-derived/', 'analysis/figure1/'))
                 or re.fullmatch(r'analysis/output/manuscript/(?:e?Figure\d+)\.(?:png|pdf|svg|tiff)', p)
                 or p == 'analysis/renv.lock']
    for path in immutable:
        assert baseline(path) == (ROOT / path).read_bytes(), path
    # Check every rendered caption and reference too, including PDF outputs.
    import pymupdf
    for name in ('Supplement', 'TRIPOD-LLM', 'Table1', 'Table2', 'Table3', 'Table4'):
        pdf = next((QA / f'round14-{name}').glob('*.pdf'))
        text = '\n'.join(page.get_text() for page in pymupdf.open(pdf))
        for key in refs(text):
            assert key in new, (pdf, key)
        # Compare identity multiplicities with the Word document it renders.
        word = '\n'.join(docx_blocks((ROOT / f'analysis/output/manuscript/{name}.docx').read_bytes()))
        assert Counter(refs(text)) == Counter(refs(word)), (pdf, 'PDF references differ from Word')
    report = dict(baseline=BASE, eTables=32, eFigures=1, all_cited_in_order=True,
                  identity_checks=checked, invariant_csvs=len(csvs),
                  invariant_input_and_artwork_files=len(immutable), manuscript_empirical_numbers_unchanged=True,
                  rendered_pdf_references_match_Word=True)
    (AUDIT / 'polish-verification.json').write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n')
    print(json.dumps(report, ensure_ascii=False, indent=2))
    print('PASS: complete citation identity/order/coverage and baseline numerical invariance.')


if __name__ == '__main__':
    main()
