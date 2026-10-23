import csv,hashlib,json,math
from pathlib import Path
root=Path(__file__).parent
start=(root/'numerical-run.R').stat().st_mtime
records=[]
for p in sorted((root/'analysis/output/tables').glob('*.csv')):
 if p.stat().st_mtime<=start: continue
 old=root/'retained-tables'/p.name
 a=list(csv.reader(old.open())); b=list(csv.reader(p.open()))
 rec={'file':p.name,'rows':len(b)-1,'byte_identical':old.read_bytes()==p.read_bytes(),'old_sha256':hashlib.sha256(old.read_bytes()).hexdigest(),'new_sha256':hashlib.sha256(p.read_bytes()).hexdigest(),'max_numeric_abs_difference':0,'changed_cells':0,'non_numeric_changes':[]}
 assert len(a)==len(b),(p.name,'rows')
 assert a[0]==b[0],(p.name,'columns')
 for i,(x,y) in enumerate(zip(a[1:],b[1:]),2):
  assert len(x)==len(y),(p.name,i)
  for j,(s,t) in enumerate(zip(x,y)):
   if s==t: continue
   rec['changed_cells']+=1
   try:
    s,t=float(s),float(t)
    delta=abs(s-t)
    assert math.isfinite(s) and math.isfinite(t) and delta<=1e-12,(p.name,i,a[0][j],s,t)
    rec['max_numeric_abs_difference']=max(rec['max_numeric_abs_difference'],delta)
   except ValueError: rec['non_numeric_changes'].append([i,a[0][j],s,t])
 assert not rec['non_numeric_changes'],rec
 records.append(rec)
result={'regenerated_tables':len(records),'byte_identical_tables':sum(r['byte_identical'] for r in records),'changed_numeric_cells':sum(r['changed_cells'] for r in records),'max_numeric_abs_difference':max((r['max_numeric_abs_difference'] for r in records),default=0),'tables':records}
(root/'numerical-comparison.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps({k:v for k,v in result.items() if k!='tables'},indent=2))
