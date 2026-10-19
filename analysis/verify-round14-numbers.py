#!/usr/bin/env python3
"""Exhaustive retained CSV numeric-cell audit against the fixed parent."""
import csv, io, json, re, subprocess, pathlib, collections, decimal, zipfile, xml.etree.ElementTree as ET
ROOT=pathlib.Path(__file__).resolve().parent.parent
BASE='bfe7111'
OUT=ROOT/'analysis/round14-verification'; OUT.mkdir(parents=True,exist_ok=True)
def git(*args): return subprocess.check_output(['git',*args],cwd=ROOT)
def old(path): return git('show',f'{BASE}:{path}')
MAP={'ARBITER (Sonnet 5.5)':'ARBITER-Sonnet','Unassisted (Sonnet 5.5)':'Baseline-Sonnet','Unassisted template':'Baseline template','Unassisted output-format instruction':'Baseline output-format instruction','Unassisted_label':'Baseline_label','Adjudicator 1 vs Adjudicator 2':'A vs Z','Adjudicator 1 independent':'A independent','Adjudicator 2 independent':'Z independent','published label':'meta label','Unassisted':'Baseline','Published':'Meta','All-Low rule':'All-Low','Rating contradicts its own answers':'Violation','Required question skipped':'Invalid answer path','Any rule break':'Departure','Adjudicators agreed with it':'Vindicated','Adjudicator 1':'A','Adjudicator 2':'Z'}
def decode(v):
 for a,b in MAP.items():
  if any(k in a for k in ['Sonnet',' vs ','independent',' label']): v=v.replace(a,b)
 return MAP.get(v,v)
def rows(data):
 result=[]
 for row in csv.DictReader(io.StringIO(data.decode('utf-8-sig'))):
  if any('haiku' in str(v).lower() for v in row.values()): continue
  row={decode(k):decode(v or '') for k,v in row.items() if 'haiku' not in k.lower()}
  if row.get('source')=='Baseline': row['source']='Unassisted'
  if row.get('reference') in ['A','Z']: row['reference']='Adjudicator '+row['reference']
  result.append(row)
 return result
def signature(row):
 # Every field identifies the row; numeric spelling is normalised at full decimal precision.
 def val(v):
  v=v.replace('\r\n','\n')
  try: return ('number',str(decimal.Decimal(v).normalize())) if v else ('text','')
  except decimal.InvalidOperation: return ('text',v)
 return tuple(sorted((k,val(v)) for k,v in row.items()))
rename={'table1.csv':'benchmark-set.csv','table2.csv':'table1.csv','table2-differences.csv':'table1-differences.csv','table4-reliability.csv':'table2-reliability.csv'}
dropped={'table5-haiku.csv','missing-sensitivity.csv','missing-sensitivity-differences.csv','recorded-overrides.csv','efigure2-disagreement-patterns.csv','artifact-verification.csv'}
report={'base':BASE,'csv':[],'protected':[],'tables':[],'failures':[]}
paths=git('ls-tree','-r','--name-only',BASE).decode().splitlines()
for path in paths:
 if path.startswith('analysis/output/tables/') and path.endswith('.csv'):
  name=pathlib.Path(path).name
  if name in dropped: continue
  target=ROOT/'analysis/output/tables'/rename.get(name,name)
  if not target.exists(): report['failures'].append(f'Missing retained CSV: {target}'); continue
  before,after=rows(old(path)),rows(target.read_bytes())
  a,b=collections.Counter(map(signature,before)),collections.Counter(map(signature,after))
  good=a==b
  numeric=sum(sum(bool(re.fullmatch(r'-?\d+(?:\.\d+)?(?:[eE][+-]?\d+)?',v)) for v in r.values()) for r in after)
  report['csv'].append({'old':path,'new':str(target.relative_to(ROOT)),'rows':len(after),'numeric_cells':numeric,'identical':good})
  if not good: report['failures'].append({'csv':name,'removed':list((a-b).elements())[:3],'added':list((b-a).elements())[:3]})
 # Inputs and protected figures including notes are immutable.
 if path.startswith(('kit-sonnet-5.5/','no-kit-sonnet-5.5/','kit-haiku-5.5/','no-kit-haiku-5.5/','human-adjudication/','rob2-meta-benchmark-set/','analysis/data-derived/','analysis/figure1/')) or re.search(r'analysis/output/manuscript/Figure[12][.]',path) or re.search(r'analysis/output/manuscript/.*[Ff]ig(?:ure)?[12].*notes',path) or path=='analysis/output/manuscript/legends-fig1-2.md' or (path.startswith('analysis/output/manuscript/qa/') and re.search(r'Figure[12][.-]',path)):
  disk=(ROOT/path).read_bytes(); parent=old(path)
  if pathlib.Path(path).suffix.lower() in {'.csv','.md','.txt','.json','.jsonl','.toml','.yml','.yaml','.svg','.html','.css','.js','.py','.r','.ps1'}:
   disk=disk.replace(b'\r\n',b'\n');parent=parent.replace(b'\r\n',b'\n')
  good=disk==parent
  report['protected'].append({'path':path,'identical':good})
  if not good: report['failures'].append('Protected file changed: '+path)
W={'w':'http://schemas.openxmlformats.org/wordprocessingml/2006/main'}
def table_cells(data):
 with zipfile.ZipFile(io.BytesIO(data)) as z: tree=ET.fromstring(z.read('word/document.xml'))
 tables=tree.findall('.//w:tbl',W)
 # Footer notes occupy their own final row; compare body numeric cells separately.
 return [[''.join(c.itertext()) for c in []]] if not tables else [[ ''.join(t.text or '' for t in c.findall('.//w:t',W)) for c in row.findall('w:tc',W)] for row in tables[0].findall('w:tr',W)]
for new,previous in [(1,2),(2,4),(3,3)]:
 a=table_cells(old(f'analysis/output/manuscript/Table{previous}.docx')); b=table_cells((ROOT/f'analysis/output/manuscript/Table{new}.docx').read_bytes())
 # All numeric body cells, including CI strings. Footer and title references are intentionally renumbered.
 def numeric_cells(rs):
  return [cell for row in rs[:-1] for cell in row if re.search(r'\d',cell)]
 av,bv=numeric_cells(a),numeric_cells(b); good=av==bv
 def footer_tokens(rs):
  note=' '.join(rs[-1])
  note=re.sub(r'eTables?\s+\d+(?:(?:\s*(?:[–-]|and|,)\s*)\d+)*','eTable REF',note)
  note=note.replace('recorded overrides: 0/510.','') # Explicit Round 14 addition.
  return re.findall(r'\d+(?:[.,]\d+)*',note)
 footer_good=footer_tokens(a)==footer_tokens(b)
 report['tables'].append({'old':previous,'new':new,'numeric_cells':len(bv),'identical':good,'retained_footer_numbers_identical':footer_good,'authorised_footer_changes':'Renumbered eTable references; Table 3 adds 0/510 overrides'})
 if not footer_good: report['failures'].append({'table':new,'footer_before':footer_tokens(a),'footer_after':footer_tokens(b)})
 if not good: report['failures'].append({'table':new,'before':av,'after':bv})
(OUT/'round14-invariance.json').write_text(json.dumps(report,indent=2,ensure_ascii=False))
print(f"CSV: {len(report['csv'])} files, {sum(r['numeric_cells'] for r in report['csv'])} numeric cells; protected: {len(report['protected'])}; retained main tables: {len(report['tables'])}")
print(json.dumps(report['failures'],indent=2,ensure_ascii=False))
raise SystemExit(bool(report['failures']))
