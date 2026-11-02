"""Verify the reporting checklist against its manuscript and official item list."""
from collections import Counter
import csv
import hashlib
import json
from pathlib import Path
import re
from zipfile import ZipFile

from lxml import etree

ROOT = Path(__file__).resolve().parents[1]
RECORD = ROOT / 'analysis/provenance/tripod-submission-20261103.json'
OUT = ROOT / 'analysis/output/manuscript'
NS = {'w': 'http://schemas.openxmlformats.org/wordprocessingml/2006/main'}


def verify():
    record = json.loads(RECORD.read_text())
    manuscript = Path(record['manuscript'])
    assert hashlib.sha256(manuscript.read_bytes()).hexdigest() == record['manuscript_sha256'], 'Manuscript version changed'
    text = manuscript.read_text(encoding='utf-8-sig')
    headings = re.findall(r'^#{1,2} (.+)$', text, re.M)
    with (ROOT / 'analysis/data-curated/reporting-checklist.csv').open(encoding='utf-8', newline='') as stream:
        rows = list(csv.DictReader(stream))
    tripod = [row for row in rows if row['guideline'] == 'TRIPOD-LLM']
    grras = [row for row in rows if row['guideline'] == 'GRRAS']
    assert [row['item'] for row in tripod] == record['official_source']['extracted_labels']
    assert [row['item'] for row in grras] == list(map(str, range(1, 16)))
    for row in rows:
        assert row['status'] in {'Reported', 'Partial', 'Not reported', 'Not applicable'}, row
        assert all(value.strip() for value in row.values()), row
        assert not re.search(r'pending|requires author information|eMethods|Repository methods record', ' '.join(row.values()), re.I), row
        for _, section in re.findall(r'\b(Methods|Results), ([^;]+)', row['section']):
            if section != 'opening paragraph':
                assert section in headings, (row['item'], section)
        for span in re.findall(r'\beTables? ([0-9]+(?:-[0-9]+)?(?: and [0-9]+(?:-[0-9]+)?)?)', row['section']):
            assert all(1 <= int(number) <= 13 for number in re.findall(r'\d+', span)), row
        for span in re.findall(r'\bTables? ([0-9]+(?:-[0-9]+)?)', row['section']):
            assert all(1 <= int(number) <= 3 for number in re.findall(r'\d+', span)), row
        for span in re.findall(r'\bFigures? ([0-9]+(?:-[0-9]+)?)', row['section']):
            assert all(1 <= int(number) <= 5 for number in re.findall(r'\d+', span)), row
    indexed = {row['item']: row for row in tripod}
    assert 'authors deemed ethics approval unnecessary' in indexed['13']['applicability_and_notes']
    assert 'publicly available data' in indexed['13']['applicability_and_notes']
    assert 'no funding' in indexed['14a']['applicability_and_notes']
    assert 'no conflicts of interest' in indexed['14b']['applicability_and_notes']
    for item in ['13', '14a', '14b']:
        assert indexed[item]['section'] == 'This checklist, author declaration'
    assert indexed['7a']['status'] == 'Partial'
    for item in ['14c', '14d', '15', '16a', '16b', '16c', '16d']:
        assert indexed[item]['status'] == 'Not applicable', item
    with ZipFile(OUT / 'TRIPOD-LLM.docx') as archive:
        doc = etree.fromstring(archive.read('word/document.xml'))
    visible = ' '.join(doc.xpath('//w:t/text()', namespaces=NS))
    assert 'TRIPOD-LLM reporting checklist' in visible and 'GRRAS reporting checklist' in visible
    assert not re.search(r'pending|previous IMRaD|METHODS_APPENDIX|RUN_PROVENANCE|signalling|/rob2-assess', visible, re.I)
    items = []
    for table in doc.xpath('//w:tbl', namespaces=NS):
        assert table.xpath('./w:tblPr/w:tblLayout[@w:type="fixed"]', namespaces=NS)
        assert table.xpath('./w:tr/w:trPr/w:tblHeader', namespaces=NS)
        for row in table.xpath('./w:tr', namespaces=NS):
            cells = [''.join(cell.xpath('.//w:t/text()', namespaces=NS)) for cell in row.xpath('./w:tc', namespaces=NS)]
            if len(cells) == 4 and re.fullmatch(r'\d+[a-g]?', cells[0]):
                items.append(cells)
    assert len(items) == len(rows)
    for row, cells in zip(rows, items):
        assert cells == [row['item'], row['topic'], row['section'], row['status'] + '. ' + row['applicability_and_notes']], row['item']
    metadata = {'reporting-checklist-skeleton.csv', 'display-supplement-reporting-map.csv'}
    for name, expected in record['protected_sha256'].items():
        path = ROOT / name
        if path.name not in metadata:
            assert hashlib.sha256(path.read_bytes()).hexdigest() == expected, name
    issues = [row for row in tripod if row['status'] in {'Partial', 'Not reported'}]
    summary = {'status': 'PASS', 'official_item_order_complete': True,
               'manuscript_unchanged': True, 'all_numerical_exports_and_figures_unchanged': True,
               'author_declarations_preserved': True,
               'tripod_status_counts': dict(Counter(row['status'] for row in tripod)),
               'grras_status_counts': dict(Counter(row['status'] for row in grras)),
               'manuscript_reporting_gaps': issues}
    (ROOT / 'analysis/provenance/tripod-submission-verification.json').write_text(json.dumps(summary, indent=2) + '\n')
    notes = ['# Manuscript reporting checks', '',
             'The checklist includes the author-supplied ethics, funding and conflict declarations. These declarations have not been inserted into the manuscript.', '',
             'The following items remain partial or unreported in the current manuscript. They are described explicitly in the completed checklist.', '',
             '| Item | Topic | Specific reporting gap |', '|---|---|---|']
    notes += [f"| {row['item']} | {row['topic']} | {row['applicability_and_notes']} |" for row in issues]
    notes += ['', 'The official downloadable 2025 form enumerates the item identifiers used here. Healthcare-setting and individual-patient items are marked not applicable with reasons; this does not assert protocol, registration or public-involvement facts that the authors have not supplied.']
    (OUT / 'TRIPOD-LLM-author-checks.md').write_text('\n'.join(notes) + '\n')
    print('PASS: official item coverage, exact Word rows, current locations, author declarations and unchanged numerical outputs.')


if __name__ == '__main__':
    verify()
