"""Read-only checks of the WP-A2 revision against the accepted WP-A outputs."""
from pathlib import Path
import argparse,csv,json,re,subprocess,xml.etree.ElementTree as ET
from zipfile import ZipFile
p=argparse.ArgumentParser();p.add_argument('--before',type=Path,default=Path('/tmp/round16-a2-before'));args=p.parse_args()
r=Path(__file__).resolve().parents[1];before=args.before
checks=[]
def record(s):checks.append('PASS '+s);print(checks[-1])
def rows(p):return list(csv.DictReader(p.open()))
# No WP-A estimate or display-table CSV is changed by this revision.
files=list((before/'output/tables').glob('*.csv'))
for old in files:
 new=r/'output/tables'/old.name
 assert new.exists(),old.name
 assert rows(old)==rows(new),old.name
record(f'all {len(files)} accepted WP-A CSVs unchanged, including new Round 16 estimates and numbering inputs')
ns={'w':'http://schemas.openxmlformats.org/wordprocessingml/2006/main'}
def content(p):
 x=ET.fromstring(ZipFile(p).read('word/document.xml'))
 return [''.join(n.itertext()) for n in x.findall('.//w:t',ns)]
for old in (before/'output/manuscript').glob('*.docx'):
 a=content(old);b=content(r/'output/manuscript'/old.name)
 assert len(a)==len(b),old.name
 changes=[(x,y) for x,y in zip(a,b) if x!=y]
 if old.name=='Supplement.docx':
  assert len(changes)==1 and changes[0][0].replace('\n\n[Extracted table 1]','\n[Extracted table 1]')==changes[0][1],old.name
 elif old.name=='TRIPOD-LLM.docx':
  headers={'Reporting map continued','Guideline','Item','Topic','Section','Applicability and Notes'}
  assert [x for x in a if x not in headers]==[x for x in b if x not in headers],old.name
 else:assert not changes,old.name
record('all six rebuilt Word documents retain identical wording and table cells; one extra blank line in a source quotation is removed and reporting-map continuation headers follow rebuilt pagination; the supplement has no duplicated Results prose to replace')
numbering=r/'output/manuscript/qa/round16-display-numbering.csv'
assert numbering.read_bytes()==(before/'output/manuscript/qa'/numbering.name).read_bytes()
text=(r/'output/manuscript/results-sentences.md').read_text()
nums=[]
for match in re.finditer(r'eTables? (\d+)(?:–(\d+))?',text):
 nums.extend(range(int(match[1]),int(match[2] or match[1])+1))
assert nums==list(range(1,16)),nums
assert not re.search(r'eTable \d+; eTable',text)
record('numbering map unchanged; Results first eTable citations run consecutively 1–15, grouped as ranges')
# The new prose values and every number are already represented in the source-cell trace.
for phrase in ['42/81 matched Overall ratings (κ 0.33)','32/81 against Expert 1 and 60/81 against Expert 2',
 '97.8% versus 95.7%','95.1% versus 95.1%','Published in 5/88','Published in 14/88',
 '+15.7 (6.8–24.4)','−4.4 (−7.6 to −1.2)','all 1538 required answers cited evidence',
 '1407/1407 quotations were found in the stored source','all 102 audit files passed']:
 assert phrase in text,phrase
trace=rows(r/'output/tables/display-source-trace.csv')
known=set()
for row in trace:
 try:v=float(row['value'])
 except (ValueError,TypeError):continue
 for v in (v,v*100,v/60):
  for dp in (0,1,2):known.add(f'{v:.{dp}f}')
for token in re.findall(r'(?<![A-Za-z])(?:\d+\.\d+|\d+)',text):
 assert token in known,token
record('all Results number tokens resolve to source-cell trace values, including matched Overall, direction, published binary intervals and process counts')
# Extract final figure text from the PDFs, rather than trusting source strings alone.
def pdftext(n):return subprocess.check_output(['pdftotext',str(r/f'output/manuscript/Figure{n}.pdf'),'-'],text=True)
flow=' '.join(pdftext(3).split())
for phrase in ['105 benchmark trials','3 excluded: designs ARBITER does not support','102 trials × D1–D5 = 510 domain cells',
 'Independent-rating comparison: all 510 cells.','154 disputed cells','356 cells with three equal labels',
 '80 where the arms disagreed','60 with an agreed forced choice','20 split']:
 assert phrase in flow,phrase
assert 'assessed by both arms' not in flow
assert 'Exploratory strata' in pdftext(4) and 'Post hoc strata' not in pdftext(4)
assert 'Pooled n' not in pdftext(5) and 'each domain n' not in pdftext(5)
record('final Figure 3 population/side labels, Figure 4 exploratory heading and Figure 5A annotation removal verified from PDFs')
for n in [1,2,3,4,5]:
 for ext in ['png','tiff']:
  name=f'eFigure{n}.{ext}'
  assert (r/'output/manuscript'/name).read_bytes()==(before/'output/manuscript'/name).read_bytes(),name
record('all five supplemental figures retain identical PNG/TIFF pixels')
# Every CI in Figure 6 is inside the revised shared 55–95% axis.
ci_rows=[]
for name in ['independent-estimates','rules-only-agreement','signalling-paired-estimates']:
 for row in rows(r/f'output/tables/{name}.csv'):
  if row.get('adjudicator') not in ['1','2']:continue
  if name!='signalling-paired-estimates' and not (row['domain']=='D1-D5' and row['metric']=='accuracy' and row['source']!='Published'):continue
  ci_rows.append(row)
assert all(.55 <= float(x['lower']) <= float(x['upper']) <= .95 for x in ci_rows)
record('every Figure 6 confidence interval fits inside the shared 55–95% axis limits')
state=json.loads((r/'provenance/round16-a2-clean-state.json').read_text())
import hashlib
for name,digest in state['source_sha256'].items():assert hashlib.sha256((r/name).read_bytes()).hexdigest()==digest,name
record('all R generators identical to the versions used at the start of the clean full rebuild')
(r/'provenance/round16-a2-additional-verification.txt').write_text('\n'.join(checks)+'\n')
