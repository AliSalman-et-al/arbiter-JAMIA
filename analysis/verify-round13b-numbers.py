"""Round 13b display audit against 116fd4b; no statistical changes allowed."""
from pathlib import Path
from collections import Counter
import csv, hashlib, io, json, re, subprocess, tempfile, zipfile
import xml.etree.ElementTree as ET
ROOT = Path(__file__).resolve().parent.parent
BASE = '116fd4b'
QA = ROOT / 'analysis/output/manuscript/qa'
NUM = re.compile(r'[−-]?\d+(?:[.,]\d+)*')
def old(path):
    return subprocess.check_output(['git','show',f'{BASE}:{path}'],cwd=ROOT)
def tokens(s):
    return NUM.findall(s.replace('\u2060',''))
def doc_text(blob):
    with zipfile.ZipFile(io.BytesIO(blob)) as z:
        root = ET.fromstring(z.read('word/document.xml'))
    ns = {'w':'http://schemas.openxmlformats.org/wordprocessingml/2006/main'}
    return '\n'.join(''.join(p.itertext()) for p in root.findall('.//w:p',ns))
def rows(name):
    with (ROOT/f'analysis/output/tables/{name}.csv').open(encoding='utf-8-sig',newline='') as f:
        return list(csv.DictReader(f))
report, streams = [], {}
for i in range(1,5):
    path = f'analysis/output/manuscript/Table{i}.docx'
    a,b = doc_text(old(path)),doc_text((ROOT/path).read_bytes())
    assert tokens(a)==tokens(b),f'Table {i}: numbers changed'
    assert not re.search(r'−\d+(?:\.\d+)?–|–−\d',b),f'Table {i}: ambiguous negative CI'
    streams[path] = {'before':tokens(a),'after':tokens(b)}
    report.append(f'PASS Table {i}: every number token identical, including title and note.')
path = 'analysis/output/manuscript/Supplement.docx'
a,b = doc_text(old(path)),doc_text((ROOT/path).read_bytes())
assert tokens(a)==tokens(b),'Supplement: numbers changed'
assert not re.search(r'−\d+(?:\.\d+)?–|–−\d',b),'Supplement: ambiguous negative CI'
streams[path] = {'before':tokens(a),'after':tokens(b)}
report.append('PASS Supplement: every number token identical; no ambiguous negative CI.')
# Independently reconcile the two displayed numerators to distinct primary loss cells.
cells = [r for r in rows('error-localisation-cells') if r['source']=='Baseline-Sonnet' and r['population']=='Primary']
assert len(cells)==len({(r['slug'],r['domain']) for r in cells})
counts = [r for r in rows('no-decisive-counts') if r['source']=='Baseline-Sonnet']
eligible = sum(int(r['eligible']) for r in counts)
with_decisive = sum(int(r['with_decisive']) for r in counts)
question = next(r for r in rows('error-localisation-frequency') if r['source']=='Baseline-Sonnet' and r['population']=='Primary' and r['question']=='5.1')
q_n = int(question['n'])
assert len(cells)==eligible==47
assert sum(bool(r['decisive_questions']) for r in cells)==with_decisive==29
assert sum('5.1' in r['decisive_questions'].split('; ') for r in cells)==q_n==18
path = 'analysis/output/manuscript/results-sentences.md'
a,b = old(path).decode('utf-8'),(ROOT/path).read_text(encoding='utf-8')
expected = a.replace('assessed in 4 arms','assessed in four arms')
old_sentence = next(s for s in a.splitlines() if s.startswith('The question of whether'))
new_sentence = f'Among the {eligible} eligible unassisted ratings the adjudicators did not choose, {with_decisive} hinged on at least one question that alone changed the rating; the analysis-plan question ({question["question"]}) did so in {q_n} (Figure 6).'
expected = expected.replace(old_sentence,new_sentence)
assert tokens(expected)==tokens(b),'Unexpected results number change'
streams[path] = {'before':tokens(a),'after':tokens(b),'approved_after':tokens(expected)}
report.append('PASS results: only approved four-arms spelling and CSV-derived Figure 6 sentence changes; 47/29/18 reconciled to distinct primary cells.')
# Compare complete figure number multisets, allowing only layout-driven reading-order changes.
with tempfile.TemporaryDirectory() as tmp:
    pdf_paths = []
    for i in range(3,7):
        path = f'analysis/output/manuscript/Figure{i}.pdf'
        prior = Path(tmp)/f'before-Figure{i}.pdf'; prior.write_bytes(old(path))
        pdf_paths.extend([str(prior),str(ROOT/path)])
    script = Path(tmp)/'pdf-text.R'
    script.write_text('args <- commandArgs(TRUE); jsonlite::write_json(lapply(args[-1],pdftools::pdf_text),args[1],auto_unbox=TRUE)',encoding='utf-8')
    out = Path(tmp)/'texts.json'
    subprocess.run(['Rscript',str(script),str(out),*pdf_paths],check=True,cwd=ROOT,stdout=subprocess.PIPE,stderr=subprocess.PIPE)
    texts = json.loads(out.read_text(encoding='utf-8'))
    for i in range(4):
        a,b = texts[2*i:2*i+2]
        assert Counter(tokens(a))==Counter(tokens(b)),f'Figure {i+3}: number changed'
        report.append(f'PASS Figure {i+3}: complete displayed number multiset identical.')
# Every tracked CSV and protected Figure 1/2 asset, including figure1/, is frozen.
paths = subprocess.check_output(['git','ls-files'],cwd=ROOT,text=True).splitlines()
frozen = [p for p in paths if p.endswith('.csv') or p.startswith('analysis/figure1/') or re.match(r'analysis/output/manuscript/(Figure[12][.]|legends-fig1-2[.]|figure1-notes[.])',p)]
for p in frozen:
    a,b = subprocess.check_output(['git','cat-file','--filters',f'{BASE}:{p}'],cwd=ROOT),(ROOT/p).read_bytes()
    if p.endswith('.csv'):
        a,b = a.replace(b'\r\n',b'\n'),b.replace(b'\r\n',b'\n')
    assert a==b,f'Frozen input changed: {p}'
report.append(f'PASS {len(frozen)} tracked CSV/protected files unchanged (CSV line endings normalised).')
hashes = json.loads((QA/'round13-input-hashes.json').read_text())
for p,expected in hashes.items():
    content = (ROOT/p).read_bytes()
    if p.endswith('.csv'):
        assert content.replace(b'\r\n',b'\n')==old(p.replace('\\','/')).replace(b'\r\n',b'\n'),p
    else:
        assert hashlib.sha256(content).hexdigest()==expected,p
report.append(f'PASS all {len(hashes)} Round 13 frozen inputs/artwork files also unchanged.')
(QA/'round13b-number-token-streams.json').write_text(json.dumps(streams,ensure_ascii=False,indent=2),encoding='utf-8')
(QA/'round13b-number-audit.txt').write_text('\n'.join(report)+'\n',encoding='utf-8')
print('\n'.join(report))
