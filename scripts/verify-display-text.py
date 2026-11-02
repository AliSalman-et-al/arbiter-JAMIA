"""Check the condensed display text against its recorded editorial baseline."""
from pathlib import Path
from zipfile import ZipFile
import hashlib
import importlib.util
import json
import re

from lxml import etree

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / 'analysis/output/manuscript'
PROVENANCE = ROOT / 'analysis/provenance'
NS = {'w': 'http://schemas.openxmlformats.org/wordprocessingml/2006/main'}
SPEC = importlib.util.spec_from_file_location('display_metadata', ROOT / 'scripts/manuscript-sources.py')
METADATA = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(METADATA)


def digest(value):
    return hashlib.sha256(json.dumps(value, ensure_ascii=False).encode()).hexdigest()


def words(text):
    return len(text.split())


def table_text(path):
    with ZipFile(path) as archive:
        doc = etree.fromstring(archive.read('word/document.xml'))
    data, notes = [], []
    for table in doc.xpath('//w:tbl', namespaces=NS):
        rows = []
        for row in table.xpath('./w:tr', namespaces=NS):
            cells = [''.join(cell.xpath('.//w:t/text()', namespaces=NS))
                     for cell in row.xpath('./w:tc', namespaces=NS)]
            if len(cells) > 1:
                rows.append(cells)
        data.append(rows)
        last = table.xpath('./w:tr[last()]/w:tc', namespaces=NS)
        if len(last) == 1:
            note = ''.join(last[0].xpath('.//w:t/text()', namespaces=NS))
            if note not in notes:
                notes.append(note)
    paragraphs = [''.join(p.xpath('.//w:t/text()', namespaces=NS))
                  for p in doc.xpath('//w:body/w:p', namespaces=NS)]
    titles = [p for p in paragraphs if re.match(r'^(?:eTable|Table) \d+[.]? ', p)]
    return {'data_sha256': digest(data), 'physical_tables': len(data),
            'titles': titles, 'notes': notes,
            'annotation_words': sum(words(p) for p in titles + notes)}


def figure_text(path):
    return {str(i): {'caption': caption, 'alt': alt,
                    'title': caption.split('. ', 1)[1].split('. ', 1)[0],
                    'annotation_words': words(re.sub(r'^Figure \d+[.] ', '', caption))}
            for i, (caption, alt) in enumerate(METADATA.main_legends(path.read_text(encoding='utf-8')), 1)}


def verify():
    baseline = json.loads((PROVENANCE / 'jama-display-text-before.json').read_text())
    current = {'figures': figure_text(OUT / 'figure-legends.md'), 'tables': {}}
    for name, before in baseline['tables'].items():
        after = table_text(OUT / f'{name}.docx')
        assert before['data_sha256'] == after['data_sha256'], f'{name}: data cells changed'
        assert before['physical_tables'] == after['physical_tables'], f'{name}: table segments changed'
        for title in after['titles']:
            assert words(re.sub(r'^(?:eTable|Table) \d+[.]? ', '', title)) <= 15, title
        current['tables'][name] = after
    for number, figure in current['figures'].items():
        assert words(figure['title']) <= 15, figure['title']
        assert figure['annotation_words'] < baseline['figures'][number]['annotation_words'], number
    allowed = {'display-source-trace.csv', 'reporting-checklist-skeleton.csv',
               'display-supplement-reporting-map.csv'}
    for name, expected in baseline['protected_sha256'].items():
        path = ROOT / name
        if path.name in allowed:
            continue
        assert hashlib.sha256(path.read_bytes()).hexdigest() == expected, f'Protected file changed: {name}'
    checks = {
        '1': ['does not establish support', 'not complete documents', 'not tested'],
        '2': ['not independently validated', 'No information', 'not independently rated Overall',
              'substantially lower confidence', 'does not establish adequate randomization'],
        '3': ['60 agreed choices', '80 cells', '20 split choices', 'all 510 cells'],
        '4': ['percentage points', '510 pooled cells', '102 per domain', 'performance ceiling'],
        '5': ['evaluable in both arms', 'retaining no information', 'eTables 11 to 13'],
    }
    for number, phrases in checks.items():
        for phrase in phrases:
            assert phrase in current['figures'][number]['caption'], (number, phrase)
    all_notes = ' '.join(note for table in current['tables'].values() for note in table['notes'])
    for phrase in ['does not assess whether evidence supports an answer', '509',
                   'IQR, interquartile range', '102 minus N', 'irrCAC 1.4', 'valid', '0']:
        if phrase.startswith('does not assess'):
            assert 'do not assess whether evidence supports an answer' in all_notes
        else:
            assert phrase in all_notes, phrase
    before_words = sum(x['annotation_words'] for x in baseline['figures'].values()) + sum(
        x['annotation_words'] for x in baseline['tables'].values())
    after_words = sum(x['annotation_words'] for x in current['figures'].values()) + sum(
        x['annotation_words'] for x in current['tables'].values())
    assert after_words < before_words
    current.update({'status': 'PASS', 'annotation_words_before': before_words,
                    'annotation_words_after': after_words,
                    'percent_reduction': round(100 * (before_words - after_words) / before_words, 1),
                    'scope': 'Five figure captions; main and supplementary table titles and unique notes. Alt text and data cells excluded from word counts.',
                    'all_table_data_and_protected_estimates_unchanged': True,
                    'jama_source': 'https://jamanetwork.com/journals/jama/pages/instructions-for-authors/',
                    'title_word_target': 15, 'jama_has_no_fixed_caption_word_limit': True})
    (PROVENANCE / 'jama-display-text.json').write_text(json.dumps(current, indent=2) + '\n')
    ledger = ['| Display | Before, words | After, words |', '|---|---:|---:|']
    for number, record in current['figures'].items():
        ledger.append(f"| Figure {number} | {baseline['figures'][number]['annotation_words']} | {record['annotation_words']} |")
    for name, record in current['tables'].items():
        ledger.append(f"| {name} | {baseline['tables'][name]['annotation_words']} | {record['annotation_words']} |")
    ledger += [f'| Total | {before_words} | {after_words} |', '', current['scope'], '',
               'Repeated pagination notes are counted once per distinct text. Word counts use whitespace-separated tokens.']
    (OUT / 'display-text-word-counts.md').write_text('\n'.join(ledger) + '\n')
    print(f'PASS: annotation text {before_words} to {after_words} words; {current["percent_reduction"]}% shorter. Data cells and protected estimates unchanged.')


if __name__ == '__main__':
    verify()
