"""Check fixed study outputs and manuscript table/citation lineage."""
from pathlib import Path
import argparse
import csv
import hashlib
import json
import re
from docx import Document
from lxml import html

ROOT = Path(__file__).resolve().parents[2]
HERE = Path(__file__).resolve().parent
# Only these individually reviewed reporting and Figure 3 artifacts can receive exceptions.
DOCUMENTARY_PATHS = frozenset({
    'analysis/output/manuscript/Supplement.docx',
    'analysis/output/manuscript/TRIPOD-LLM.docx',
    'analysis/output/manuscript/Table2.docx',
    'analysis/output/manuscript/figure-legends.md',
    'analysis/output/manuscript/Figure3.pdf',
    'analysis/output/manuscript/Figure3.png',
    'analysis/output/manuscript/Figure3.tiff',
    'analysis/output/tables/prompt-template-example.csv',
    'analysis/output/tables/display-supplement-reporting-map.csv',
    'analysis/output/tables/reporting-checklist-skeleton.csv',
    'analysis/output/tables/display-table2.csv',
    'analysis/output/tables/display-source-trace.csv',
})


# These paths are already inventoried in round4, but absent from baseline-hashes.json.
# Carry their historical hashes forward; never derive a baseline from current files.
FIGURE3_PATHS = (
    'analysis/output/manuscript/Figure3.pdf',
    'analysis/output/manuscript/Figure3.png',
    'analysis/output/manuscript/Figure3.tiff',
)


def historical_baseline():
    baseline = json.loads((HERE / 'baseline-hashes.json').read_text(), object_pairs_hook=unique_object)
    round4 = json.loads((HERE / 'round4/baseline.json').read_text(), object_pairs_hook=unique_object)['hashes']
    for name in FIGURE3_PATHS:
        if name in baseline and baseline[name] != round4[name]:
            raise ValueError(f'Conflicting historical hashes: {name}')
        baseline[name] = round4[name]
    return baseline


def unique_object(pairs):
    result = {}
    for key, value in pairs:
        if key in result:
            raise ValueError(f'Duplicate JSON key: {key}')
        result[key] = value
    return result


def verify_protected_outputs(baseline, manifest_path=None):
    """Validate every exception before checking the remaining historical hashes."""
    updates = {}
    if manifest_path is not None:
        updates = json.loads(Path(manifest_path).read_text(), object_pairs_hook=unique_object)
        if not isinstance(updates, dict) or not updates:
            raise ValueError('Documentary manifest must be a nonempty object keyed by repository path')
        for name, entry in updates.items():
            if name not in DOCUMENTARY_PATHS or name not in baseline:
                raise ValueError(f'Unauthorized documentary path: {name}')
            if not isinstance(entry, dict) or set(entry) != {'old_sha256', 'new_sha256', 'rationale'}:
                raise ValueError(f'Invalid documentary entry: {name}')
            for field in ('old_sha256', 'new_sha256'):
                if not isinstance(entry[field], str) or not re.fullmatch(r'[0-9a-f]{64}', entry[field]):
                    raise ValueError(f'Invalid {field}: {name}')
            if not isinstance(entry['rationale'], str) or not entry['rationale'].strip():
                raise ValueError(f'Missing documentary rationale: {name}')
            if entry['old_sha256'] != baseline[name]:
                raise ValueError(f'Documentary old hash differs from historical baseline: {name}')
            if entry['old_sha256'] == entry['new_sha256']:
                raise ValueError(f'Documentary entry does not describe a change: {name}')
            path = ROOT / name
            if not path.is_file():
                raise ValueError(f'Documentary file does not exist: {name}')
            if hashlib.sha256(path.read_bytes()).hexdigest() != entry['new_sha256']:
                raise ValueError(f'Documentary new hash differs from current file: {name}')
    changed = []
    for name, digest in baseline.items():
        expected = updates[name]['new_sha256'] if name in updates else digest
        path = ROOT / name
        if not path.is_file() or hashlib.sha256(path.read_bytes()).hexdigest() != expected:
            changed.append(name)
    if changed:
        raise ValueError(f'Protected outputs changed: {changed}')
    return len(updates)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--documentary-updates', type=Path,
                        help='Reviewed JSON old/new SHA-256 hashes and rationales; default is strict historical baseline')
    args = parser.parse_args()
    try:
        baseline = historical_baseline()
        documentary_count = verify_protected_outputs(baseline, args.documentary_updates)
    except (ValueError, OSError) as exc:
        parser.exit(1, f'Integrity check failed: {exc}\n')
    text = (ROOT / 'docs/manuscript/manuscript.md').read_text()
    references = (ROOT / 'docs/manuscript/references.md').read_text()
    order = []
    for callout in re.findall(r'\[([\d,–-]+)\]', text):
        for group in callout.split(','):
            ends = re.split('[–-]', group)
            for number in range(int(ends[0]), int(ends[-1]) + 1):
                if number not in order:
                    order.append(number)
    listed = [int(n) for n in re.findall(r'^(\d+)\.', references, re.M)]
    assert order == listed == list(range(1, len(listed) + 1)), (order, listed)
    normalize = lambda s: ' '.join(s.split())
    main = Document(ROOT / 'analysis/output/manuscript/Manuscript.docx')
    page = html.fromstring((ROOT / 'analysis/manuscript.html').read_bytes())
    web_tables = page.xpath('//section[contains(@class,"manuscript-table")]//table')
    assert len(main.tables) == len(web_tables) == 3
    cells_checked = 0
    for i in range(1, 4):
        standalone = Document(ROOT / f'analysis/output/manuscript/Table{i}.docx').tables[0]
        source_cells = [normalize(c.text) for r in standalone.rows for c in r.cells]
        embedded_cells = [normalize(c.text) for r in main.tables[i-1].rows for c in r.cells]
        assert source_cells == embedded_cells, f'Table {i}: Word mismatch'
        web_text = normalize(web_tables[i-1].text_content())
        with (ROOT / f'analysis/output/tables/display-table{i}.csv').open(newline='', encoding='utf-8-sig') as stream:
            for row in csv.reader(stream):
                for value in row:
                    if not value:
                        continue
                    value = normalize(value)
                    assert value in source_cells, (i, 'CSV value missing in Word', value)
                    assert value in web_text, (i, 'CSV value missing in HTML', value)
                    cells_checked += 1
    assert len(page.xpath('//h1')) == 1, 'Manuscript must have one document title'
    assert len(page.xpath('//figure[contains(@class,"manuscript-figure")]/img')) == 5
    for img in page.xpath('//figure[contains(@class,"manuscript-figure")]/img'):
        assert len(img.get('alt', '')) > 50
    print(json.dumps({'status': 'PASS', 'unchanged_sources': len(baseline) - documentary_count,
                      'approved_documentary_updates': documentary_count,
                      'references_in_first_use_order': len(listed),
                      'display_csv_cells_in_both_formats': cells_checked,
                      'embedded_word_tables_equal_standalone': 3,
                      'figures_with_alt_text': 5}, indent=2))


if __name__ == '__main__':
    main()
