"""Read-only arithmetic/source relationships and manifest for Supplement A audit.

Writes only beside this script. Does not rebuild or recompute statistical estimates.
Run from any directory with Python 3.
"""
import csv
import hashlib
import json
from collections import defaultdict
from pathlib import Path
import subprocess

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[3]
TABLES = ROOT / 'analysis/output/tables'
PROOFS = ROOT / 'docs/rethink-2026-10-22/rendered/Supplement'

def read(name):
    with (TABLES / (name + '.csv')).open(encoding='utf-8-sig', newline='') as f:
        return list(csv.DictReader(f))

checks = []
def check(name, passed, detail):
    checks.append(dict(check=name, status='PASS' if passed else 'FAIL', evidence=detail))

confusion = read('independent-confusion')
estimates = read('independent-estimates')
binary = read('independent-binary')
grouped = defaultdict(list)
for row in confusion:
    grouped[(row['adjudicator'], row['source'], row['domain'])].append(row)
for key, rows in grouped.items():
    if key[0] not in ('1', '2') or key[2] == 'Overall':
        continue
    total = sum(int(r['n']) for r in rows)
    diagonal = sum(int(r['n']) for r in rows if r['reference'] == r['predicted'])
    matches = [r for r in estimates if (r['adjudicator'], r['source'], r['domain']) == key and r['metric'] == 'accuracy']
    check('confusion diagonal ' + str(key), len(matches) == 1 and int(matches[0]['n']) == total and int(matches[0]['count']) == diagonal,
          dict(matrix_total=total, matrix_diagonal=diagonal, source_estimate=matches))
    for metric in ('sensitivity', 'specificity'):
        selected = [r for r in rows if (r['reference'] != 'Low') == (metric == 'sensitivity')]
        denom = sum(int(r['n']) for r in selected)
        numerator = sum(int(r['n']) for r in selected if (r['predicted'] != 'Low') == (metric == 'sensitivity') and r['predicted'] != 'Missing')
        target = [r for r in binary if (r['adjudicator'], r['source'], r['domain']) == key and r['metric'] == metric]
        check('binary from confusion ' + str(key) + ' ' + metric,
              len(target) == 1 and int(target[0]['n']) == denom and int(target[0]['count']) == numerator,
              dict(matrix_numerator=numerator, matrix_denominator=denom, source_estimate=target))

for row in read('signalling-disagreement-types'):
    check('disagreement partition ' + row['adjudicator'] + ' ' + row['source'],
          int(row['five_level_disagreements']) == int(row['within_direction']) + int(row['cross_direction']), row)

primary = [r for r in read('primary-endpoint') if r['analysis'] == 'Consensus' and r['metric'] == 'ARBITER'][0]
check('primary retained 53/60', int(primary['count']) == 53 and int(primary['n']) == 60, primary)
repair = [r for r in read('rules-only-primary') if r['analysis'] == 'Split sensitivity' and r['metric'] == 'Neither'][0]
check('rules-only Neither metadata confirms assumption', int(repair['count']) == 21 and 'forced' in repair['note'], repair)

manifest = []
for page in range(1, 55):
    path = PROOFS / f'page0001-{page:03d}.png'
    manifest.append(dict(page=page, file=str(path.relative_to(ROOT)), size_bytes=path.stat().st_size,
                         sha256=hashlib.sha256(path.read_bytes()).hexdigest()))
with (HERE / 'page-manifest.csv').open('w', encoding='utf-8', newline='') as f:
    writer = csv.DictWriter(f, fieldnames=list(manifest[0]))
    writer.writeheader()
    writer.writerows(manifest)

descriptions = {
1: ('Navigation map', 'SA07: no page locations/supporting-display entries'),
2: ('Algorithms; price reconstruction; evidence binding', 'PASS: legible; structural/semantic and price/expenditure boundaries explicit'),
3: ('Inference; expert sequence; Overall populations', 'PASS: fixed-review bootstrap and 81/102 distinction explicit'),
4: ('Signalling eligibility; inputs; limits', 'PASS: readable; no target-matching differentiation; bounded interpretation'),
5: ('eTable 1 benchmark start', 'SA05: undefined SC/topic abbreviations; note on p6 inappropriate'),
6: ('eTable 1 continuation and totals', 'SA05: bootstrap note on count inventory'),
7: ('eTable 2 Expert 1 and Expert 2 pooled start', 'SA05/SA08: mixed panels and split Expert 2 pooled block'),
8: ('eTable 2 Expert 2 and means', 'SA07/SA08: unnumbered continuation; mid-block break'),
9: ('eTable 2 means; agreed reference start', 'SA07/SA08: column headers only; panel fragmentation'),
10: ('eTable 2 agreed reference; paired contrasts start', 'SA05/SA08: estimates/contrasts share headings; split panels'),
11: ('eTable 2 Expert 1/2 and mean contrasts', 'SA07/SA08: header-only continuation; fragmentary blocks'),
12: ('eTable 2 domain contrasts', 'SA07/SA08: header-only continuation; fragmentary blocks'),
13: ('eTable 2 D5 and agreed-reference contrasts', 'SA07/SA08: long unnumbered continuation; values legible'),
14: ('eTable 2 final contrasts; expert agreement; note', 'SA05: irrelevant Overall populations dominate note'),
15: ('Unweighted expert agreement start', 'SA07/SA08: supporting display absent from map; continued p16'),
16: ('Unweighted expert agreement final and note', 'SA05: agreed-reference/contrast boilerplate absent from data'),
17: ('eTable 3 category distributions', 'SA05: bootstrap and Overall note on domain-only counts'),
18: ('eTable 4 expert reliability', 'SA05: note includes absent Overall; data/intervals legible'),
19: ('eTable 5 Expert 1 ARBITER confusion', 'SA05/SA07: orientation not locally defined; numbering lost later'),
20: ('eTable 5 Expert 1 Published confusion', 'SA05/SA07: orientation not locally defined; unnumbered continuation'),
21: ('eTable 5 Expert 1 Unassisted confusion', 'SA05/SA07: orientation not locally defined; header-only continuation'),
22: ('eTable 5 Expert 2 ARBITER confusion', 'SA05/SA07: orientation not locally defined; unnumbered continuation'),
23: ('eTable 5 Expert 2 Published confusion', 'SA05/SA07: orientation not locally defined; header-only continuation'),
24: ('eTable 5 Expert 2 Unassisted confusion and note', 'SA05: percentage/contrast/CI note on count matrices'),
25: ('eTable 6 Published agreement start', 'SA03: Sensitivity superscript lacks matching note; class/coefficients undefined'),
26: ('eTable 6 All-Low and final note', 'SA03: reporting convention/dashes undefined'),
27: ('eTable 7 unweighted Published agreement', 'SA03: coefficient and Overall observed population note missing'),
28: ('eTable 8 Expert 1 pooled/D1/D2 binary', 'SA07/SA08: long table; class definition deferred to p31'),
29: ('eTable 8 Expert 1 D3/D4/D5 binary', 'SA07/SA08: unnumbered continuation; legible values'),
30: ('eTable 8 Expert 2 pooled/D1/D2 binary', 'SA07/SA08: header-only continuation; legible values'),
31: ('eTable 8 Expert 2 D3/D4/D5 and note', 'PASS local: binary class/denominators and intervals explained; SA07/SA08 navigation'),
32: ('Paired binary differences', 'PASS local: pp units and comparison named; SA07 missing map entry'),
33: ('eTable 9 primary and sensitivities', 'SA04: stricter comparator unspecified; primary and assumed split loss correct'),
34: ('eTable 10 disputed choices', 'SA05/SA06: generic CI note; nonexclusive credits unexplained'),
35: ('eTable 11 directional disagreements start', 'SA04: stricter relative to Published not stated'),
36: ('eTable 11 direction continuation and note', 'SA04: selection rule remains undefined'),
37: ('eTable 12 revised labels', 'SA05: CI note without intervals; post-exposure caveat present'),
38: ('Retained and changed answers', 'PASS local: counts/denominator and mixed components visible; SA07 map omission'),
39: ('eTable 13 Expert 1 absolute signalling start', 'SA07/SA08: readable, source-specific denominators visible; later explanation remote'),
40: ('eTable 13 Expert 1 Q2/Q3 absolute signalling', 'SA07/SA08: sparse/zero rows retained; fragmented continuation'),
41: ('eTable 13 Expert 1 Q4/Q5; Expert 2 start', 'SA07/SA08: expert block crosses page; values legible'),
42: ('eTable 13 Expert 2 domains/Q1/Q2', 'SA07/SA08: header-only continuation; values legible'),
43: ('eTable 13 Expert 2 Q2/Q3/Q4', 'SA07/SA08: zero/sparse rows retained; unnumbered continuation'),
44: ('eTable 13 Expert 2 Q4/Q5 final and note', 'PASS local: source-specific versus paired eligibility explained; SA07/SA08 fragmentation'),
45: ('Five-level disagreement types', 'PASS local: within/cross counts partition; definitions explicit; SA07 map omission'),
46: ('Paired signalling differences Expert 1 start', 'SA01: no units/subtraction direction; duplicate dashes at n=0'),
47: ('Paired signalling Expert 1 end/Expert 2 start', 'SA01: no units/subtraction direction; SA07/SA08 fragmented blocks'),
48: ('Paired signalling Expert 2 final and note', 'SA01: final note supplies bootstrap only; units/direction absent'),
49: ('Signalling eligibility Expert 1 ARBITER start', 'SA09: component units/exclusion reasons unexplained; SA08 split block'),
50: ('Signalling eligibility Expert 1 Unassisted', 'SA09: redundant TRUE/FALSE; no local denominator note'),
51: ('Signalling eligibility Expert 2 ARBITER', 'SA09: component units/reasons unexplained; SA08 split block'),
52: ('Signalling eligibility Expert 2 Unassisted final', 'SA09: no final explanatory note'),
53: ('eTable 14 rules-only primary/sensitivities', 'SA02: 21 Neither combines observed and assumed split losses'),
54: ('Rules-only independent agreement start', 'PASS local: columns/values legible; no local arithmetic anomaly; SA07 supporting-display navigation'),
}
with (HERE / 'coverage.csv').open('w', encoding='utf-8', newline='') as f:
    writer = csv.writer(f)
    writer.writerow(['physical_page', 'image', 'display', 'inspected', 'method', 'status_and_evidence'])
    for page, (display, result) in descriptions.items():
        writer.writerow([f'{page:03d}', f'page0001-{page:03d}.png', display, 'YES', 'individual view_image at reading size', result])

result = dict(actual_head=subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=ROOT, text=True).strip(),
              baseline='951dddd3e28e0d6316c641491667353e0b851a78', visual_pages=54,
              arithmetic_checks=len(checks), failures=[c for c in checks if c['status'] != 'PASS'], checks=checks,
              scope='Existing CSV count relationships only; no statistical estimation, model run, rebuild or production write.')
(HERE / 'verification.json').write_text(json.dumps(result, indent=2), encoding='utf-8')
print(json.dumps({k: result[k] for k in ('actual_head', 'visual_pages', 'arithmetic_checks', 'failures')}, indent=2))
