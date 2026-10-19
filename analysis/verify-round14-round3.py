#!/usr/bin/env python3
"""Audit approved text removals and actual publication artifacts for WP-A3."""
from pathlib import Path
import csv,json,re,subprocess,zipfile,xml.etree.ElementTree as ET
ROOT=Path(__file__).resolve().parent.parent
BASE='120b332';OUT=ROOT/'analysis/output/manuscript';QA=ROOT/'analysis/round14-verification'
def old(p):return subprocess.check_output(['git','show',f'{BASE}:{p}'],cwd=ROOT).decode()
# Claim-removal exceptions are exact deletions, not blanket writable-file waivers.
p='analysis/output/manuscript/legends-fig1-2.md'
expected=re.sub(r' Across the 102 trials, the server rejected .*?resubmission\.','',old(p))
assert (ROOT/p).read_text()==expected
p='analysis/output/manuscript/figure1-notes.md'
expected=old(p).replace(' The frozen rejection audit remains in save-rejections.csv and its summary JSON.','')
expected=re.sub(r'## Save-call rejection audit\n.*?(?=## Fixed recorded-rule)','',expected,flags=re.S)
expected=re.sub(r' Across 102 trials, 53 of 637 .*?resubmission\.','',expected)
assert (ROOT/p).read_text()==expected
W={'w':'http://schemas.openxmlformats.org/wordprocessingml/2006/main'}
def word(data):
 import io
 with zipfile.ZipFile(io.BytesIO(data)) as z:return ET.fromstring(z.read('word/document.xml'))
def table(data):
 xml=word(data)
 return [[''.join(t.text or '' for t in c.findall('.//w:t',W)) for c in r.findall('w:tc',W)] for r in xml.findall('.//w:tbl',W)[0].findall('w:tr',W)]
a=table(subprocess.check_output(['git','show',f'{BASE}:analysis/output/manuscript/Table4.docx'],cwd=ROOT));b=table((OUT/'Table4.docx').read_bytes())
expected=[[c.replace('[ref: This study]','This study (ARBITER)') for c in row] for row in a[:-1]]
assert expected==b[:-1],'Table 4 retained feature cells changed'
assert 'eTable 32' in ' '.join(b[-1]) and 'prior-work-comparison-notes.md' not in ' '.join(b[-1])
rows=list(csv.DictReader((ROOT/'analysis/data-curated/prior-work-evidence-condensed.csv').open()))
assert len(rows)==11 and len({r['Study'] for r in rows})==11
assert all('“' in r['Quoted cell evidence and locations'] and ' — ' in r['Quoted cell evidence and locations'] for r in rows)
scanned=[];findings=[]
for directory in ['analysis/output/manuscript','analysis/output/tables','analysis/output/figures']:
 for p in (ROOT/directory).rglob('*'):
  if not p.is_file():continue
  if p.suffix=='.docx':text=' '.join(word(p.read_bytes()).itertext())
  elif p.suffix=='.pdf':text=subprocess.check_output(['pdftotext',str(p),'-']).decode(errors='replace')
  elif p.suffix in {'.md','.txt','.csv','.json','.html','.svg'}:text=p.read_text(errors='replace')
  else:continue
  scanned.append(str(p.relative_to(ROOT)))
  if re.search(r'53\s*(?:/|of)\s*637|"total_calls"\s*:\s*637|"rejected"\s*:\s*53',text,re.I):findings.append(str(p.relative_to(ROOT)))
for p in [ROOT/'analysis/results.html',ROOT/'analysis/supplement.html']:
 scanned.append(str(p.relative_to(ROOT)))
 if re.search(r'53\s*(?:/|of)\s*637',p.read_text()):findings.append(str(p.relative_to(ROOT)))
assert not findings,findings
supplement=' '.join(word((OUT/'Supplement.docx').read_bytes()).itertext())
assert 'disagreement with a published label may partly reflect outcome mismatch' in supplement
assert 'For De Waal 2021, the registry record supplied to both arms belongs to a different trial.' in supplement
assert '33 targets' in supplement and '11 match' in supplement and '32 match' in supplement and '7 partly match, 9 differ and 10' in supplement
assert 'Evidence and quotation locations for the prior-work comparison' in supplement
report={'baseline':BASE,'exact_legend_and_notes_deletions':True,'table4_all_retained_body_cells_unchanged_except_authorised_study_label':True,'new_eTable':32,'evidence_studies':len(rows),'claim_scan_artifacts':len(scanned),'claim_scan_matches':findings,'methods_and_limitations_verified_in_actual_Word':True}
(QA/'round3-text-proof.json').write_text(json.dumps(report,indent=2))
print(json.dumps(report,indent=2))
