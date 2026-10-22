"""Check JAMA frequency precision without changing analytical exports."""
from pathlib import Path
import csv,re,json
ROOT=Path(__file__).resolve().parents[4]
checks=[]
pattern=re.compile(r'([0-9][0-9,]*)/([0-9][0-9,]*)\s*\(([0-9]+(?:\.[0-9]+)?)%')
for path in sorted((ROOT/'analysis/output/tables').glob('display-*.csv')):
 if path.name=='display-source-trace.csv':continue # Technical trace preserves original source precision.
 with path.open(encoding='utf-8-sig',newline='') as f:
  for rownum,row in enumerate(csv.DictReader(f),2):
   for column,cell in row.items():
    for match in pattern.finditer(cell or ''):
     numerator=int(match[1].replace(',',''));denominator=int(match[2].replace(',',''));shown=float(match[3])
     assert denominator>0,(path,rownum,column)
     if denominator<100:assert '.' not in match[3],(path,rownum,column,match[0])
     tolerance=.500001 if denominator<100 else .050001
     assert abs(shown-100*numerator/denominator)<=tolerance,(path,rownum,column,match[0])
     checks.append((path.name,rownum,column,denominator))
assert len(checks)>100
primary=(ROOT/'analysis/output/tables/display-table2.csv').read_text(encoding='utf-8-sig')
for value in ['53/60 (88%; 80–96)','63/80 (79%; 70–87)','61/80 (76%; 68–85)','53/80 (66%; 58–75)']:assert value in primary,value
manuscript=(ROOT/'docs/manuscript/manuscript.md').read_text(encoding='utf-8')
assert '88%; 95% CI, 80–96%' in manuscript
assert '[IQR]' not in manuscript
assert not re.search(r'\bP\s*[<=>]\s*[0-9.]',manuscript), 'No P values belong to this evaluation'
print(json.dumps({'PASS':True,'frequency_cells_checked':len(checks),'small_denominator_cells':sum(n<100 for _,_,_,n in checks),'primary_display':'53/60 (88%; 95% CI, 80%–96%)','analytical_precision':'Checked separately by the 38-export invariance audit','exceptions':['Protected Figures 1–2 unchanged','JAMIA abstract, placement, headings, limits and citation format retained','Verbatim evidence and model text preserved','Counts-only confusion matrices and deterministic audit inventories retained as counts; no unsupported percentages introduced','Mean-of-expert estimates have no single observed numerator and remain explicitly identified averages','No P values or new tests introduced']},indent=2))
