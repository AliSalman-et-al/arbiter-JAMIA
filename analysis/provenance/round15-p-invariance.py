"""Verify display-only changes against the requested scientific baseline."""
from pathlib import Path
import csv,hashlib,re,subprocess
from zipfile import ZipFile
r=Path(__file__).resolve().parents[1];root=r.parent
baseline='0cbdfc3'
def gitbytes(p):return subprocess.check_output(['git','show',f'{baseline}:{p.relative_to(root)}'],cwd=root)
def refs(s):
 return re.sub(r'\b(Figure|Table) ([1-6])(?!\d)',lambda m:m[1]+' '+str(({4:5,5:4} if m[1]=='Figure' else {1:3,2:1,3:2}).get(int(m[2]),int(m[2]))),s)
rows=[]
for p in sorted((r/'output/tables').glob('*.csv')):
 if p.name.startswith('display-'):continue
 old=gitbytes(p);new=p.read_bytes();equal=old==new
 allowed=p.name in {'reporting-checklist-skeleton.csv','prior-work-evidence.csv'} and refs(old.decode())==new.decode()
 assert equal or allowed,p
 rows.append(dict(file=p.name,byte_identical=equal,allowed_change='Main display citations only' if allowed and not equal else ''))
with (r/'provenance/round15-p-estimate-invariance.csv').open('w') as f:
 w=csv.DictWriter(f,fieldnames=rows[0]);w.writeheader();w.writerows(rows)
for new,old in [(1,2),(2,3),(3,1),(4,4)]:
 p=r/f'output/tables/display-table{new}.csv';assert p.read_bytes()==gitbytes(r/f'output/tables/display-table{old}.csv'),p
figrows=[]
for new in range(1,7):
 old={4:5,5:4}.get(new,new)
 for ext in (['pdf','png','svg','tiff'] if new<3 else ['png','tiff']):
  p=r/f'output/manuscript/Figure{new}.{ext}';prior=gitbytes(r/f'output/manuscript/Figure{old}.{ext}')
  assert p.read_bytes()==prior,p
  figrows.append(dict(file=str(p.relative_to(r)),baseline_figure=old,identical=True))
with (r/'provenance/round15-p-figure-invariance.csv').open('w') as f:
 w=csv.DictWriter(f,fieldnames=figrows[0]);w.writeheader();w.writerows(figrows)
print(f'PASS {len(rows)} non-display CSVs: {sum(x["byte_identical"] for x in rows)} byte-identical; display citations only in the remaining files.')
print('PASS all four main display CSVs are byte-identical under the numbering map.')
print('PASS eight protected Figure 1/2 files byte-identical; all Figure 3–6 PNG/TIFF artwork byte-identical under the numbering map.')
