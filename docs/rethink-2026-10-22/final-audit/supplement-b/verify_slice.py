"""Read-only checks of the inspected proofs; writes evidence only beside this script.

Run from repository root: C:/Python314/python.exe docs/rethink-2026-10-22/final-audit/supplement-b/verify_slice.py
No rendering, estimates, bootstrap, or model execution.
"""
import csv
import hashlib
import json
from pathlib import Path
import re
import subprocess
import pymupdf

ROOT = Path(__file__).resolve().parents[4]
OUT = Path(__file__).resolve().parent
RENDER = ROOT / 'docs/rethink-2026-10-22/rendered'
TABLES = ROOT / 'analysis/output/tables'
doc = pymupdf.open(RENDER / 'Supplement.pdf')
def normalize(s):
    return re.sub(r'\s+', '', s).replace('\u2212', '-').replace('\u2013', '-').replace('\u2014', '-')

specs = [
    ('cells-changed-by-rules-only-recomputation', 59, 60),
    ('invalid-answer-path-sensitivity', 61, 61),
    ('derived-overall-agreement-and-paired-contrasts', 62, 63),
    ('derived-overall-validation-differences', 64, 65),
    ('rule-consistency-and-audit', 66, 69),
    ('evidence-binding', 70, 70),
    ('time-cost-and-token-use', 71, 71),
    ('api-cost-estimates-and-reconstruction-bounds', 72, 73),
    ('token-reconciliation', 74, 76),
    ('prior-work-evidence-ledger', 77, 77),
]
results = []
for slug, start, end in specs:
    rows = list(csv.DictReader((TABLES / f'display-supplement-{slug}.csv').open(encoding='utf-8-sig')))
    text = normalize(''.join(doc[p-1].get_text() for p in range(start, end+1)))
    missing = [(i+1, k, v) for i, row in enumerate(rows) for k, v in row.items() if v and normalize(v) not in text]
    results.append({'display': slug, 'pages': f'{start}-{end}', 'rows': len(rows), 'cells': sum(len(r) for r in rows), 'missing_cells': missing})

for name, start, end in [('answers',83,96),('evidence',96,105)]:
    rows = list(csv.DictReader((TABLES / f'avatar-trace-{name}.csv').open(encoding='utf-8-sig')))
    text = normalize(''.join(doc[p-1].get_text() for p in range(start,end+1)))
    missing = [(i+1,k,v[:100]) for i,row in enumerate(rows) for k,v in row.items() if v and normalize(v) not in text]
    results.append({'display': f'avatar-trace-{name}', 'pages': f'{start}-{end}', 'rows': len(rows), 'cells': sum(len(r) for r in rows), 'missing_cells': missing})

changed = list(csv.DictReader((TABLES / 'display-supplement-cells-changed-by-rules-only-recomputation.csv').open(encoding='utf-8-sig')))
validation = list(csv.DictReader((TABLES / 'display-supplement-derived-overall-validation-differences.csv').open(encoding='utf-8-sig')))
invalid = list(csv.DictReader((TABLES / 'display-supplement-invalid-answer-path-sensitivity.csv').open(encoding='utf-8-sig')))
arithmetic = {
    'changed_rows_26': len(changed) == 26,
    'changed_rows_all_labels_differ': all(r['Original'] != r['Recomputed'] for r in changed),
    'validation_rows_29': len(validation) == 29,
    'validation_missing_published_21': sum(r['Column'] == 'Published' and r['Workbook'] == '\u2014' for r in validation) == 21,
    'validation_permitted_escalations_7': sum(r['Workbook'] == 'High' and r['Calculated'] == 'Some concerns' for r in validation) == 7,
    'validation_published_low_some_concerns_1': sum(r['Column'] == 'Published' and r['Workbook'] == 'Low' and r['Calculated'] == 'Some concerns' for r in validation) == 1,
    'invalid_violations_equal_original_plus_additional': all(int(r['Violations']) == int(r['Original Violations']) + int(r['Additional Violations']) for r in invalid),
}
proofs = [RENDER / 'Supplement.pdf', RENDER / 'TRIPOD-LLM.pdf']
proofs += [RENDER / 'Supplement' / f'page0001-{p:03}.png' for p in range(55,107)]
proofs += [RENDER / 'TRIPOD-LLM' / f'page0001-{p}.png' for p in range(1,6)]
evidence = {
    'head': subprocess.check_output(['git','rev-parse','HEAD'], cwd=ROOT, text=True).strip(),
    'method': 'Full individual-page visual inspection using tools.view_image; independent CSV-cell presence and count arithmetic checks below. Cell presence is not a substitute for visual or semantic review.',
    'supplement_page_count': len(doc),
    'tripod_page_count': len(pymupdf.open(RENDER / 'TRIPOD-LLM.pdf')),
    'table_proof_checks': results,
    'arithmetic_checks': arithmetic,
    'proof_sha256': {str(p.relative_to(ROOT)): hashlib.sha256(p.read_bytes()).hexdigest() for p in proofs},
}
(OUT / 'verification.json').write_text(json.dumps(evidence, indent=2, ensure_ascii=False), encoding='utf-8')
print(json.dumps({k:v for k,v in evidence.items() if k != 'proof_sha256'}, indent=2, ensure_ascii=False))
assert all(arithmetic.values())
assert not any(r['missing_cells'] for r in results)
