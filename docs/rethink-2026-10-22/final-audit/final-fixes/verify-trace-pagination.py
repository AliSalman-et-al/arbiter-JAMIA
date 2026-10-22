from pathlib import Path
import subprocess,re,csv,json
QA=Path(__file__).parent
text=subprocess.check_output(['C:/Program Files/Calibre2/app/bin/pdftotext.exe','-layout',str(QA/'proof/Supplement.pdf'),'-']).decode()
pages=[p for p in text.split('\f') if p.strip()]
records=[]
for i,p in enumerate(pages,1):
 if 'Full verbatim quote:' in p or 'Context: eh_' in p or ('4.3' in p and 'Unassisted: Not applicable' in p):
  record={'page':i,'quote_starts':p.count('Full verbatim quote:'),'source_hashes':p.count('Source-version hash:'),'contexts':re.findall(r'Context: (eh_\w+)',p),'question_4_3':bool('4.3' in p and 'Unassisted: Not applicable' in p),'first_lines':[s.strip() for s in p.splitlines() if s.strip()][:2]}
  records.append(record)
  assert record['source_hashes']==record['quote_starts'],(i,'metadata split')
assert sum(r['quote_starts'] for r in records)==16
assert any(r['question_4_3'] for r in records)
(QA/'trace-pagination.json').write_text(json.dumps({'PASS':True,'records':records},indent=2))
print(json.dumps(records,indent=2))
