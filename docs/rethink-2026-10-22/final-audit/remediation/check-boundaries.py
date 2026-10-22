"""Check every final page boundary and record stable display/page locations."""
from pathlib import Path
import csv,re,subprocess,json
QA=Path(__file__).with_name('proof-jama')
records=[];locators=[];spills=[]
for name in ['Table1','Table2','Table3','Manuscript','Supplement','TRIPOD-LLM']:
 text=subprocess.check_output(['C:/Program Files/Calibre2/app/bin/pdftotext.exe','-layout',str(QA/f'{name}.pdf'),'-']).decode('utf-8')
 pages=[p for p in text.split('\f') if p.strip()]
 assert 'No table of contents entries found' not in text,(name,'empty Word navigation field')
 for i,page in enumerate(pages,1):
  lines=[s.strip() for s in page.splitlines() if s.strip()]
  assert re.search(rf'Page {i}\s*$',page),(name,i,'missing or incorrect footer')
  records.append({'document':name,'page':i,'first':' | '.join(lines[:2]),'last':' | '.join(lines[-3:]),'page_number':'PASS'})
  for line in lines:
   if not re.search(r'\.{3,}',line) and re.match(r'eTable \d+[A-C]?(?:\.| )|eFigure [1-5][ .]|AVATAR complete trace|Prompt templates and run provenance',line):
    locators.append({'document':name,'page':i,'locator':line})
 if name=='Supplement':
  toc_targets=[]
  for line in text.splitlines():
   match=re.match(r'^\s*(.+?)\s*\.{3,}\s*(\d+)\s*$',line)
   if match:
    heading,page=match[1].strip(),int(match[2])
    assert heading in ' '.join(pages[page-1].split()),(heading,page,'incorrect contents locator')
    toc_targets.append((heading,page))
  assert len(toc_targets)>=40,('incomplete navigation',len(toc_targets))
  start=next(i for i,p in enumerate(pages) if re.match(r'1[.] Reproducibility|eTable 1[.]? Benchmark',next(s.strip() for s in p.splitlines() if s.strip())))
  end=next(i for i,p in enumerate(pages) if re.search(r'eFigure 1[.]? Absolute agreement by domain',' '.join(p.split())) and 'Short horizontal ticks' in ' '.join(p.split()))
  for i in range(start,end):
   first=[s.strip() for s in pages[i].splitlines() if s.strip()][0]

   if not re.match(r'eTable \d|[1-7]\. ',first):spills.append((i+1,first))
 for field,rows in [('boundaries',records),('locators',locators)]:
  with (QA/f'{field}.csv').open('w',encoding='utf-8',newline='') as f:
   writer=csv.DictWriter(f,fieldnames=rows[0] if rows else ['document','page','locator']);writer.writeheader();writer.writerows(rows)
assert not spills,spills
print(json.dumps({'PASS':True,'pages_checked':len(records),'navigation_targets_checked':len(toc_targets),'scope':'Every footer and page boundary; every supplementary table panel starts with a stable caption or its section context.'},indent=2))
