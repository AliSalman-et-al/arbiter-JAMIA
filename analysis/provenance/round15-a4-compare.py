"""Compare rebuilt documents against the accepted WP-A3 artifacts saved before cleaning."""
from pathlib import Path
from zipfile import ZipFile
from lxml import etree as E
import difflib,json,csv,hashlib,re
root=Path(__file__).resolve().parents[1]
old=Path('/tmp/round15-a4-before/output')
ns={'w':'http://schemas.openxmlformats.org/wordprocessingml/2006/main'}
def extract(p):
 x=E.fromstring(ZipFile(p).read('word/document.xml'))
 paragraphs=[''.join(y.xpath('.//w:t/text()',namespaces=ns)) for y in x.xpath('//w:body/w:p',namespaces=ns)]
 tables=[[[''.join(c.xpath('.//w:t/text()',namespaces=ns)) for c in row.xpath('./w:tc',namespaces=ns)] for row in t.xpath('./w:tr',namespaces=ns)] for t in x.xpath('//w:tbl',namespaces=ns)]
 return paragraphs,tables
def permitted_replacements(text):
 replacements={
 'in question-map.csv':'(eTable 5)',
 'LABEL-TARGETS.csv links':'The benchmark label-target documentation links',
 'Source: benchmark README-FOR-ALI.md, LABEL-TARGETS.csv and per-review BINDING.md; label-target-summary.csv recomputes matching categories.':'The benchmark documentation and per-review binding evidence support these categories (eTable 11).',
 'Years come from TRIAL-SUMMARY.csv and trial-label years where that field is blank; the benchmark README identifies':'Years come from the benchmark trial summaries and trial-label years where that field is blank (eTable 11); the benchmark documentation identifies',
 'R and package versions are in session-info.txt and renv.lock.':'The reproducibility records include the R and package versions.',
 'ehae585.pdf':'AVATAR long-term follow-up report',
 'CIRCULATIONAHA.121.057639.pdf':'AVATAR original trial report',
 'Current registry-linked sap: SAP_000.pdf':'Current registry-linked statistical analysis plan',
 'bundle-domain-checks.csv':'eTable 14', 'table3-supplement.csv':'eTable 14',
 'audit-summary.csv':'eTable 19',
 'canonical.json and verification.json':'canonical bundle records and verification receipts',
 'docs/round15/BRIEF.md':'the full-coverage expert assessment specification'}
 sources=['independent-confusion','independent-estimates','forced-choice','revised-ratings','signalling-estimates','rules-only-primary','independent-differences','expert-reliability','direction-of-disagreement','primary-endpoint','benchmark-set','agreement-meta','agreement-unweighted','table3-supplement','invalid-path-sensitivity','table5','api-cost-summary','api-token-reconciliation','audit-summary','derived-overall-validation','prior-work-evidence']
 for i,source in enumerate(sources,1):text=text.replace('Source: '+source+'.csv.',f'eTable {i}.')
 for old,new in replacements.items():text=text.replace(old,new)
 return text
records={}
for name in ['Supplement','TRIPOD-LLM','Table1','Table2','Table3','Table4']:
 a,at=extract(old/'manuscript'/f'{name}.docx');b,bt=extract(root/'output/manuscript'/f'{name}.docx')
 (root/'provenance'/f'round15-a4-{name}-text.diff').write_text('\n'.join(difflib.unified_diff(a,b,fromfile='accepted',tofile='rebuilt',lineterm='',n=0)))
 (root/'provenance'/f'round15-a4-{name}-cells.diff').write_text('\n'.join(difflib.unified_diff([json.dumps((i,j,k,c),ensure_ascii=False) for i,t in enumerate(at) for j,row in enumerate(t) for k,c in enumerate(row)],[json.dumps((i,j,k,c),ensure_ascii=False) for i,t in enumerate(bt) for j,row in enumerate(t) for k,c in enumerate(row)],fromfile='accepted',tofile='rebuilt',lineterm='',n=0)))
 assert [permitted_replacements(v) for v in a]==b,(name,'unexpected paragraph change')
 assert [[[permitted_replacements(c) for c in row] for row in t] for t in at]==bt,(name,'unexpected table cell change')
 records[name]={'matches_after_requested_replacements':True,'accepted_paragraphs':len(a),'rebuilt_paragraphs':len(b),'accepted_tables':len(at),'rebuilt_tables':len(bt),'identical_table_cells':at==bt,'identical_text':a==b}
(root/'provenance/round15-a4-document-comparison.json').write_text(json.dumps(records,indent=2))
rows=[]
for item in csv.DictReader((root/'provenance/round15-a3-estimate-invariance.csv').open()):
 name=item['file']
 if not (root/'output/tables'/name).exists():
  rows.append(dict(file=name,accepted_sha256=hashlib.sha256((old/'tables'/name).read_bytes()).hexdigest(),rebuilt_sha256='',identical='Removed stale output, outside current pipeline'))
  continue
 a=hashlib.sha256((old/'tables'/name).read_bytes()).hexdigest();b=hashlib.sha256((root/'output/tables'/name).read_bytes()).hexdigest()
 rows.append(dict(file=name,accepted_sha256=a,rebuilt_sha256=b,identical=a==b))
with (root/'provenance/round15-a4-estimate-invariance.csv').open('w') as f:
 w=csv.DictWriter(f,fieldnames=list(rows[0]));w.writeheader();w.writerows(rows)
print(json.dumps(records,indent=2));print('CSV changes:',[x['file'] for x in rows if x['identical'] is False])
