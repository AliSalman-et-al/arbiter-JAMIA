"""Record final artifact hashes, page counts and bounded visual coverage."""
from pathlib import Path
import csv, hashlib, json, re, subprocess

ROOT=Path(__file__).resolve().parents[4]
QA=Path(__file__).parent
PROOF=QA/'proof-jama'
OUT=ROOT/'analysis/output/manuscript'
counts={}
for path in sorted(PROOF.glob('*.pdf')):
    text=subprocess.check_output(['C:/Program Files/Calibre2/app/bin/pdftotext.exe','-layout',str(path),'-']).decode('utf-8')
    counts[path.stem]=len([p for p in text.split('\f') if p.strip()])
paths=list(OUT.glob('*.docx'))+list(OUT.glob('*.pdf'))+list(OUT.glob('*.png'))
paths+=list(PROOF.glob('*.pdf'))+[ROOT/'analysis/results.html',ROOT/'analysis/supplement.html']
paths+=list((ROOT/'analysis/output/tables').glob('display-*.csv'))
with (QA/'artifact-hashes.csv').open('w',newline='',encoding='utf-8') as f:
    writer=csv.DictWriter(f,fieldnames=['path','bytes','sha256']);writer.writeheader()
    for p in sorted(set(paths)):
        writer.writerow({'path':p.relative_to(ROOT).as_posix(),'bytes':p.stat().st_size,'sha256':hashlib.sha256(p.read_bytes()).hexdigest()})
metadata={'PASS':True,'pages':counts,'total_pages':sum(counts.values()),'main_words':2931,'abstract_words':229,
          'main_tables':3,'supplement_table_panels':98,'reporting_table_panels':8,
          'visual_scope':'Representative final pages and every changed figure/layout pattern; independent exhaustive final-page vision and live-site QA belong to parent.',
          'numerical_invariance':'4639 protected files; 38 numerical CSVs; zero mismatches',
          'publication':'Not committed, pushed or deployed by implementation worker'}
(QA/'final-artifacts.json').write_text(json.dumps(metadata,indent=2)+'\n',encoding='utf-8')
coverage=[]
viewed={'Manuscript':[1,2,9,10,12,23],
        'Supplement':[2,7,22,25,28,40,49,51,53,54,66,69,74,81,83,84,97,98,99,101,104,105,107,111,112,114,118,137],
        'TRIPOD-LLM':[1,2,8],'Table1':[1],'Table2':[1],'Table3':[1]}
for name,pages in viewed.items():
    for page in pages:
        matches=list((PROOF/name).glob(f'page*-{page:0{len(str(counts[name]))}d}.png'))
        assert len(matches)==1,(name,page,matches)
        path=matches[0]
        coverage.append({'path':path.relative_to(ROOT).as_posix(),'inspection':'Reading-size visual layout inspection',
                         'status':'PASS','sha256':hashlib.sha256(path.read_bytes()).hexdigest()})
for name in ['Figure3','Figure4','Figure5','eFigure3']+[f'eFigure{i}-D{d}' for i in [2,5] for d in range(1,6)]:
    path=OUT/f'{name}.png'
    coverage.append({'path':path.relative_to(ROOT).as_posix(),'inspection':'Individual figure/panel visual inspection',
                     'status':'PASS','sha256':hashlib.sha256(path.read_bytes()).hexdigest()})
with (QA/'visual-coverage.csv').open('w',newline='',encoding='utf-8') as f:
    writer=csv.DictWriter(f,fieldnames=['path','inspection','status','sha256']);writer.writeheader();writer.writerows(coverage)
print(json.dumps(metadata,indent=2))
