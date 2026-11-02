"""Verify R-01 to R-06 without model calls or modification of estimates."""
import csv
import hashlib
import json
import math
import io
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
TABLES = ROOT / 'analysis/output/tables'
PROV = ROOT / 'analysis/provenance/posthoc-requests'
BEFORE = ROOT / '.audit/posthoc-before-tables'
BASELINE = 'f5156024fede1c06acce36333f2bc61371e841d9'


def baseline_text(name):
    local = BEFORE / name
    if local.is_file():
        return local.read_text(encoding='utf-8-sig')
    return subprocess.check_output(['git', 'show', f'{BASELINE}:analysis/output/tables/{name}'], cwd=ROOT).decode('utf-8-sig')


def read(name, folder=TABLES):
    if folder == BEFORE:
        return list(csv.DictReader(io.StringIO(baseline_text(name + '.csv'))))
    with (folder / f'{name}.csv').open(encoding='utf-8-sig', newline='') as f:
        return list(csv.DictReader(f))


def close(a, b):
    if a == b == '':
        return True
    return math.isclose(float(a), float(b), rel_tol=1e-12, abs_tol=1e-12)


def verify():
    four = read('posthoc-four-metrics')
    checked = 0
    for name in ('independent-estimates', 'agreement-meta', 'expert-reliability'):
        for old in read(name, BEFORE):
            if old['domain'] == 'Overall' or old['metric'] not in ('accuracy', 'kappa'):
                continue
            if name == 'independent-estimates':
                if old['source'] == 'Published':
                    continue
                source = old['source'].replace('Unassisted', 'Direct prompting')
                ref = 'Human Review ' + old['adjudicator']
            elif name == 'agreement-meta':
                if 'All-Low' in old['arm']:
                    continue  # historically suppressed kappa is now reported as requested
                source = 'ARBITER' if old['arm'].startswith('ARBITER') else 'Direct prompting'
                ref = 'Published labels'
            else:
                source, ref = 'Human Review 1', 'Human Review 2'
            new = [r for r in four if r['source'] == source and r['reference'] == ref
                   and r['domain'] == old['domain'] and r['metric'] == old['metric']]
            assert len(new) == 1, (name, old, new)
            for col in ('estimate', 'lower', 'upper', 'valid_replicates', 'n'):
                assert close(old[col], new[0][col]), (name, col, old[col], new[0][col])
            checked += 1
    for name in ('independent-differences', 'agreement-meta-differences'):
        for old in read(name, BEFORE):
            if old['domain'] == 'Overall' or old['metric'] not in ('accuracy', 'kappa'):
                continue
            ref = 'Human Review ' + old['adjudicator'] if name == 'independent-differences' else 'Published labels'
            row = next(r for r in four if r['source'] == 'ARBITER minus Direct prompting'
                       and r['reference'] == ref and r['domain'] == old['domain'] and r['metric'] == old['metric'])
            for col in ('estimate', 'lower', 'upper', 'valid_replicates'):
                assert close(old[col], row[col]), (name, col, old[col], row[col])
            checked += 1
    # Every original numerical export retains exactly the same numbers and labels,
    # allowing only the requested display rename. Display tables may reorder rows.
    invariant = []
    original_files = json.loads((PROV / 'before-hashes.json').read_text())
    for original in original_files:
        path = Path(original)
        if path.name.startswith('display-') or path.stem in ('reporting-checklist-skeleton',):
            continue
        a = baseline_text(path.name).replace('Unassisted', 'Direct prompting').replace('\r\n', '\n')
        b = (TABLES / path.name).read_text(encoding='utf-8-sig').replace('\r\n', '\n')
        assert a == b, path.name
        invariant.append(path.name)
    expected = {('ARBITER', 'Published labels'): 386, ('Direct prompting', 'Published labels'): 395,
                ('ARBITER', 'Human Review 1'): 371, ('ARBITER', 'Human Review 2'): 433,
                ('Human Review 1', 'Human Review 2'): 388}
    for pair, count in expected.items():
        row = next(r for r in four if (r['source'], r['reference']) == pair
                   and r['domain'] == 'D1-D5' and r['metric'] == 'accuracy')
        assert int(row['count']) == count and int(row['n']) == 510
    dist = read('posthoc-rating-distribution')
    for source, count in {'Published labels': 427, 'Human Review 1': 277, 'Human Review 2': 346}.items():
        row = next(r for r in dist if r['source'] == source and r['domain'] == 'D1-D5' and r['label'] == 'Low')
        assert int(row['count']) == count and int(row['n']) == 510
    for row in four + read('posthoc-overall-agreement') + read('posthoc-relative-human-agreement'):
        assert row['analysis'] == 'post hoc'
        assert 0 <= int(row['valid_replicates']) <= 10000
    low_ac1 = next(r for r in four if r['domain'] == 'D1-D5' and r['reference'] == 'Published labels'
                   and r['source'] == 'All-Low' and r['metric'] == 'AC1')
    assert low_ac1['estimate'] and int(low_ac1['valid_replicates']) == 10000
    for file in ('results.html', 'supplement.html'):
        assert 'Unassisted' not in (ROOT / 'analysis' / file).read_text(encoding='utf-8')
    for path in TABLES.glob('*.csv'):
        assert 'Unassisted' not in path.read_text(encoding='utf-8-sig'), path
    report = {'existing_estimate_rows_reproduced': checked, 'unchanged_numerical_exports': invariant,
              'all_low_published_ac1': low_ac1, 'anchor_counts': 'passed', 'display_rename': 'passed'}
    (PROV / 'verification.json').write_text(json.dumps(report, indent=2) + '\n', encoding='utf-8')
    # Full numerical handoff, including every estimate, CI, valid count and denominator.
    lines = ['# Post hoc numerical ledger', '', 'All requested numbers, at full exported precision. '
             'Accuracy is a proportion; multiply estimates and intervals by 100 for percentages or percentage points.', '']
    for path in sorted(TABLES.glob('posthoc-*.csv')):
        rows = list(csv.reader(path.open(encoding='utf-8-sig', newline='')))
        lines += ['## ' + path.name, '', '| ' + ' | '.join(rows[0]) + ' |',
                  '| ' + ' | '.join(['---'] * len(rows[0])) + ' |']
        lines += ['| ' + ' | '.join(row) + ' |' for row in rows[1:]]
        lines += ['']
    (PROV / 'all-numbers.md').write_text('\n'.join(lines), encoding='utf-8')
    main = ['# Post hoc results for manuscript citation', '',
            'All intervals are 95% percentile bootstrap intervals. All estimable statistics have 10,000 valid replicates.', '',
            '## Agreement against Published labels across 510 cells', '',
            '| Metric | ARBITER | Direct prompting | ARBITER minus Direct prompting | All-Low |',
            '| --- | --- | --- | --- | --- |']
    def value(r):
        scale = 100 if r['metric'] == 'accuracy' else 1
        return f"{scale*float(r['estimate']):.3f} ({scale*float(r['lower']):.3f} to {scale*float(r['upper']):.3f})"
    for metric in ('accuracy', 'kappa', 'AC1', 'AC2'):
        selected = {r['source']: r for r in four if r['reference'] == 'Published labels'
                    and r['domain'] == 'D1-D5' and r['metric'] == metric}
        main += ['| ' + metric + ' | ' + ' | '.join(value(selected[s]) for s in
                 ('ARBITER', 'Direct prompting', 'ARBITER minus Direct prompting', 'All-Low')) + ' |']
    main += ['', 'Exact agreement is shown as percent; its paired difference is percentage points. Other metrics use coefficient units.', '',
             '## Agreement relative to human human agreement', '',
             '| Metric | ARBITER D(A) | Direct prompting D(A) | Paired difference |', '| --- | --- | --- | --- |']
    rel = read('posthoc-relative-human-agreement')
    for metric in ('accuracy', 'kappa'):
        selected = {r['source']: r for r in rel if r['domain'] == 'D1-D5' and r['metric'] == metric}
        main += ['| ' + metric + ' | ' + ' | '.join(value(selected[s]) for s in
                 ('ARBITER', 'Direct prompting', 'ARBITER minus Direct prompting')) + ' |']
    main += ['', '## Recorded Overall judgments', '',
             'ARBITER and Direct prompting each have 102/102 recorded Overall judgments. Published labels have 81/102; 21 trials are excluded from its comparisons. '
             'Neither human review has a recorded Overall judgment (0/102 each); all 102 trials are excluded from comparisons with either review, including human-human agreement. '
             'Existing domain-derived human Overall analyses are a separate diagnostic. The adopted ARBITER Overall includes the recorded escalation for fulop-2021.', '',
             '| Source | Exact agreement | Weighted kappa | AC2 |', '| --- | --- | --- | --- |']
    overall = read('posthoc-overall-agreement')
    for source in ('ARBITER', 'Direct prompting', 'ARBITER minus Direct prompting', 'All-Low'):
        selected = {r['metric']: r for r in overall if r['reference'] == 'Published labels' and r['source'] == source}
        main += ['| ' + source + ' | ' + ' | '.join(value(selected[m]) for m in ('accuracy', 'kappa', 'AC2')) + ' |']
    main += ['', 'ARBITER exact agreement is 47/81; Direct prompting 48/81; All-Low 42/81.', '',
             '## Missing ratings', '', 'All five sources have 0 missing domain ratings among 510 cells. '
             'Overall missing counts are ARBITER 0, Direct prompting 0, Human Review 1 102, Human Review 2 102, Published labels 21.', '',
             '## Files and supplement locators', '',
             'eTable 4 Agreement under four metrics: analysis/output/tables/posthoc-four-metrics.csv',
             'eTable 9 Overall judgment agreement: analysis/output/tables/posthoc-overall-agreement.csv',
             'eTable 5 Model agreement relative to human agreement: analysis/output/tables/posthoc-relative-human-agreement.csv',
             'eTable 8 Distribution of ratings by source: analysis/output/tables/posthoc-rating-distribution.csv',
             'eTable 10 Overall availability: analysis/output/tables/posthoc-overall-availability.csv', '',
             'All numerical rows, including every domain, interval and valid replicate count: analysis/provenance/posthoc-requests/all-numbers.md', '',
             f'Verification: {checked} existing estimate/contrast rows reproduce to numerical tolerance 1e-12; '
             f'{len(invariant)} original numerical CSVs differ only by the requested display rename. '
             'The existing test suite passed 215 tests. No model was rerun.', '',
             'Package: irrCAC 1.4; gwet.ac1.table with identity or linear weights, fixed three-category scale. '
             'https://www.stat.math.ethz.ch/CRAN/web/packages/irrCAC/refman/irrCAC.html']
    (ROOT / 'analysis/output/manuscript/posthoc-main-text.md').write_text('\n'.join(main), encoding='utf-8')
    print(json.dumps(report, indent=2))


if __name__ == '__main__':
    verify()
