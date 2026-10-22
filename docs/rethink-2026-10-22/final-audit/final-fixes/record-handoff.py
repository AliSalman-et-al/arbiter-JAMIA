from pathlib import Path
import csv,hashlib,json,subprocess
ROOT=Path(__file__).resolve().parents[4];QA=Path(__file__).parent
# Retained independent reviews must remain byte-identical.
checked=0
for name in ['a','b']:
 for r in csv.DictReader((QA.parent/f'final-vision-{name}/coverage.csv').open(encoding='utf-8-sig')):
  path=ROOT/(r.get('image_file') or r.get('proof_file'))
  assert hashlib.sha256(path.read_bytes()).hexdigest()==r['sha256'],str(path)
  checked+=1
(QA/'retained-review-hashes.json').write_text(json.dumps({'PASS':True,'old_reviewed_images_byte_unchanged':checked},indent=2))
# Actual Word bookmarks to exact old heading text, preferring complete lines.
old=QA.parent/'remediation/proof-jama';texts={};lines={}
bookmarks=list(csv.DictReader((QA/'proof/bookmarks.csv').open(encoding='utf-8-sig')))
for name in {r['document'] for r in bookmarks}:
 raw=subprocess.check_output(['C:/Program Files/Calibre2/app/bin/pdftotext.exe','-layout',str(old/f'{name}.pdf'),'-']).decode()
 pages=[p for p in raw.split('\f') if p.strip()]
 texts[name]=[' '.join(p.split()) for p in pages]
 lines[name]=[{' '.join(line.split()) for line in p.splitlines()} for p in pages]
records=[]
for r in bookmarks:
 heading=' '.join(r['text'].split())
 candidates=[i for i,p in enumerate(lines[r['document']],1) if heading in p]
 if not candidates:candidates=[i for i,p in enumerate(texts[r['document']],1) if heading and heading in p]
 if r['document']=='Supplement' and len(candidates)>1:candidates=[i for i in candidates if i>2]
 status='same page' if candidates==[int(r['page'])] else ('page changed' if len(candidates)==1 else 'multiple/no exact old text matches')
 records.append({**r,'old_pdf_pages':','.join(map(str,candidates)),'page_disposition':status})
with (QA/'proof/bookmark-page-diff.csv').open('w',encoding='utf-8',newline='') as f:
 w=csv.DictWriter(f,fieldnames=records[0]);w.writeheader();w.writerows(records)
# Final artifact inventory.
files=list((ROOT/'analysis/output/manuscript').glob('*.docx'))+list((ROOT/'analysis/output/manuscript').glob('Figure[1-5].*'))+[ROOT/'analysis/results.html',ROOT/'analysis/supplement.html']+list((QA/'proof').glob('*.pdf'))+list((QA/'proof').glob('*.docx'))
with (QA/'artifact-hashes.csv').open('w',encoding='utf-8',newline='') as f:
 w=csv.writer(f);w.writerow(['path','bytes','sha256'])
 for p in files:w.writerow([p.relative_to(ROOT).as_posix(),p.stat().st_size,hashlib.sha256(p.read_bytes()).hexdigest()])
print('Retained reviews:',checked,'unchanged images; current Word bookmarks:',len(records))
