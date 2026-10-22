from pathlib import Path
import csv,hashlib,io,json,subprocess
ROOT=Path(__file__).resolve().parents[2] if '__file__' in globals() and __file__!='<stdin>' else Path.cwd()
base=json.loads((ROOT/'docs/rethink-2026-10-22/implementation-baseline.json').read_text(encoding='utf-8-sig'))
report={'head':subprocess.check_output(['git','rev-parse','HEAD'],cwd=ROOT).decode().strip(),'protected_files':len(base['protected']),'protected_mismatches':[],'numeric_files':[],'numeric_mismatches':[]}
for file,digest in base['protected'].items():
 if hashlib.sha256((ROOT/file).read_bytes()).hexdigest().lower()!=digest.lower():report['protected_mismatches'].append(file)
fields={'estimate','lower','upper','count','n','valid_replicates','median','q25','q75','mean','total'}
for file in base['tables']:
 prior=subprocess.check_output(['git','show',base['head']+':analysis/output/tables/'+file],cwd=ROOT).decode('utf-8-sig')
 old=list(csv.DictReader(io.StringIO(prior)));new=list(csv.DictReader(io.StringIO((ROOT/'analysis/output/tables'/file).read_text(encoding='utf-8-sig'))))
 if old:
  keys=fields.intersection(old[0])
  if keys:
   report['numeric_files'].append(file)
   if len(old)!=len(new) or any(any(a[k]!=b.get(k) for k in keys) for a,b in zip(old,new)):report['numeric_mismatches'].append(file)
report['PASS']=not report['protected_mismatches'] and not report['numeric_mismatches'] and report['head']==base['head']
(ROOT/'docs/rethink-2026-10-22/implementation-invariance.json').write_text(json.dumps(report,indent=2))
print('PASS' if report['PASS'] else 'FAIL',report['protected_files'],'protected files;',len(report['numeric_files']),'numerical CSVs;',report['protected_mismatches'],report['numeric_mismatches'])
assert report['PASS']
