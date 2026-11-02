"""R-08 artifact checks, using saved pre-edit Word tables and frozen numeric exports."""
from pathlib import Path
import hashlib,json,re
from docx import Document
from lxml import html
ROOT=Path(__file__).resolve().parents[3]
OUT=ROOT/'analysis/output/manuscript'
BEFORE=ROOT/'.audit/r08-before'
PROV=ROOT/'analysis/provenance/r08'
def rows(path):
 return [[c.text.strip() for c in r.cells] for t in Document(path).tables for r in t.rows]
def text(path):
 d=Document(path)
 return '\n'.join([p.text for p in d.paragraphs]+[' '.join(r) for r in rows(path)])
assert rows(BEFORE/'Table1.docx')==rows(OUT/'Table2.docx')
assert rows(BEFORE/'Table2.docx')==rows(OUT/'Table4.docx')
old=rows(BEFORE/'Table3.docx');new=rows(OUT/'Table3.docx')
assert new[:len(old)-1]==old[:-1], 'Existing process/resource rows changed'
expected={'Active required answers citing evidence':(1538,1538),'Text spans with complete binding fields':(1407,1407),'Image records with complete fields':(14,14),'Exported records passing verification':(102,102)}
for label,(numerator,denominator) in expected.items():
 row=next(r for r in new if r[0]==label)
 assert row[1].split()[0].replace(',','')==f'{numerator}/{denominator}',row
 assert row[2]=='Not available',row
assert 'C. Evidence records (ARBITER only)' in text(OUT/'Table3.docx')
assert 'do not assess whether evidence supports an answer' in text(OUT/'Table3.docx')
for number,title in [(2,'Benchmark and reference context'),(3,'Process checks and computational resources'),(4,'Conditional blinded-label choices and sensitivities')]:
 assert f'Table {number}. {title}' in text(OUT/f'Table{number}.docx')
supp=text(OUT/'Supplement.docx')
for value in ('1,538/1,538','1,407/1,407','14/14','102/102'):
 assert value in supp,('Supplement evidence count missing',value)
assert 'Main Table 4 contains conditional-choice sensitivities' in supp
assert not re.search(r'(?<!e)\bTable 1\b',supp)
assert 'Main Table 2 contains conditional-choice' not in supp
assert not (OUT/'Table1.docx').exists()
for f,h in json.loads((PROV/'before-numerical-hashes.json').read_text()).items():
 assert hashlib.sha256((ROOT/f).read_bytes()).hexdigest()==h,f
page=html.parse(str(ROOT/'analysis/results.html'))
assert [n.get('aria-label') for n in page.xpath('//section[@aria-label]') if n.get('aria-label').startswith('Table ')]==['Table 2','Table 3','Table 4']
result={'renumbered_tables_match_original_cells':True,'existing_table3_rows_unchanged':True,'evidence_counts':expected,'direct_prompting_evidence':'Not available','supplement_cross_references':'passed','frozen_numerical_exports':'unchanged'}
(PROV/'verification.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps(result,indent=2))
