"""Check retained analytical rows and study inputs against the full earlier release."""
import argparse
from collections import Counter
import csv
import hashlib
from decimal import Decimal, InvalidOperation
import io
import json
from pathlib import Path
import re
import subprocess
import xml.etree.ElementTree as ET

ROOT = Path(__file__).resolve().parents[1]
BASELINE = '54645d75e7a8b32bbf09968893e7be45faa4cab4'
SOURCE_DIRS = ['human-adjudication', 'kit-haiku-5.5', 'kit-sonnet-5.5',
               'no-kit-haiku-5.5', 'no-kit-sonnet-5.5', 'rob2-meta-benchmark-set',
               'analysis/data-curated', 'analysis/data-derived']
REGENERATED = {'analysis/data-derived/expert-signalling-components.csv',
               'analysis/data-derived/expert-signalling-comparisons.csv'}


def git(*args, input=None):
    return subprocess.check_output(['git', *args], cwd=ROOT, input=input)


def normalized(value):
    value = value.replace('\r\n', '\n')
    try:
        return str(Decimal(value).normalize())
    except InvalidOperation:
        return value


def blob_hash(content):
    return hashlib.sha1(b'blob ' + str(len(content)).encode() + b'\0' + content).hexdigest().encode()


def csv_records(content):
    reader = csv.DictReader(io.StringIO(content.decode('utf-8-sig')))
    return reader.fieldnames, list(reader)


def retained_rows(old, new, fields):
    def keys(rows):
        return Counter(tuple(normalized(row[field]) for field in fields) for row in rows)
    return keys(new) - keys(old)


def controls():
    old = [{'expert': '1', 'count': '10'}, {'expert': '2', 'count': '20'}]
    fields = ['expert', 'count']
    assert not retained_rows(old, old, fields)
    assert retained_rows(old, [{'expert': '1', 'count': '11'}], fields)
    assert retained_rows(old, [{'expert': '1', 'count': '20'},
                               {'expert': '2', 'count': '10'}], fields)
    assert retained_rows(old, old + [old[0]], fields)


def verify(baseline):
    controls()
    source_tree = git('ls-tree', '-r', '-z', baseline, '--', *SOURCE_DIRS).split(b'\0')
    checked_inputs = 0
    for entry in filter(None, source_tree):
        metadata, name = entry.split(b'\t', 1)
        relative = name.decode()
        if relative in REGENERATED:
            continue
        path = ROOT / relative
        assert path.is_file(), f'Study input removed: {relative}'
        expected = metadata.split()[2]
        content = path.read_bytes()
        assert expected in (blob_hash(content), blob_hash(content.replace(b'\r\n', b'\n'))), \
            f'Study input changed: {relative}'
        checked_inputs += 1
    checked_tables = checked_rows = 0
    failures = []
    for path in sorted((ROOT / 'analysis/output/tables').glob('*.csv')):
        if path.name.startswith('display-'):
            continue
        relative = path.relative_to(ROOT).as_posix()
        old_content = git('show', f'{baseline}:{relative}')
        old_fields, old = csv_records(old_content)
        fields, new = csv_records(path.read_bytes())
        assert fields, f'Analytical output has no schema: {relative}'
        if path.name == 'reporting-checklist-skeleton.csv':
            assert {(r['guideline'], r['item']) for r in new} == {(r['guideline'], r['item']) for r in old}
            for row in new:
                assert row['section'].strip(), f'Missing reporting locator: {row}'
                assert not re.search(r'\beFigure\b', row['section']), row
                assert all(int(n) <= 4 for n in re.findall(r'\beTable\s+(\d+)', row['section'])), row
            continue
        assert new or not old, f'Nonempty baseline output became empty: {relative}'
        assert set(fields) <= set(old_fields), f'Unexpected analytical columns: {relative}'
        differences = retained_rows(old, new, fields)
        if differences:
            failures.append({'file': relative, 'changed_rows': sum(differences.values()),
                             'example': list(next(iter(differences)))})
        checked_tables += 1
        checked_rows += len(new)
    for relative in sorted(REGENERATED):
        old_fields, old = csv_records(git('show', f'{baseline}:{relative}'))
        fields, new = csv_records((ROOT / relative).read_bytes())
        assert set(fields) <= set(old_fields), relative
        assert not retained_rows(old, new, fields), f'Retained signalling records changed: {relative}'
    for number in (1,):
        for extension in ('png', 'pdf', 'tiff'):
            relative = f'analysis/output/manuscript/Figure{number}.{extension}'
            assert (ROOT / relative).read_bytes() == git('show', f'{baseline}:{relative}'), relative
    original_svg = ET.fromstring(git('show', f'{baseline}:analysis/output/manuscript/Figure2.svg'))
    revised_svg = ET.fromstring((ROOT / 'analysis/output/manuscript/Figure2.svg').read_bytes())
    original_labels = [e.attrib['aria-label'] for e in original_svg.iter() if 'aria-label' in e.attrib]
    revised_labels = [e.attrib['aria-label'] for e in revised_svg.iter() if 'aria-label' in e.attrib]
    old_footer = [v for v in original_labels if v.startswith('Published review: Low')]
    new_footer = [v for v in revised_labels if v.startswith('Published D5: Low')]
    assert len(old_footer) == len(new_footer) == 1, 'Figure 2 footer must identify the recorded D5 choices'
    assert 'Blinded D5 choice, both human reviews: Some concerns' in new_footer[0]
    assert [v for v in original_labels if v not in old_footer] == [v for v in revised_labels if v not in new_footer], \
        'Figure 2 content changed beyond the authorized D5 footer clarification'
    assert not failures, json.dumps(failures, indent=2)
    result = {'baseline': baseline, 'unchanged_study_inputs': checked_inputs,
              'retained_analytical_files': checked_tables, 'retained_rows': checked_rows,
              'figure1_unchanged': True, 'figure2_footer_only_change': True,
              'controls': 'Detected changed values, swapped identities and duplicate rows'}
    print(json.dumps(result, indent=2))
    return result


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--baseline', default=BASELINE)
    parser.add_argument('--report', type=Path)
    args = parser.parse_args()
    report = verify(args.baseline)
    if args.report:
        args.report.parent.mkdir(parents=True, exist_ok=True)
        args.report.write_text(json.dumps(report, indent=2) + '\n', encoding='utf-8')
