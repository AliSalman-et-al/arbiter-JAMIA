from pathlib import Path
import json,re,unicodedata
import pymupdf
root=Path(__file__).resolve().parent
qa=root/'output/manuscript/qa'
doc=pymupdf.open(qa/'round14-Supplement/Supplement.pdf')
def norm(s):return re.sub(r'[^\w]','',unicodedata.normalize('NFKC',s),flags=re.UNICODE).lower()
text=''.join(page.get_text() for page in doc)
# Repeated table headers may interrupt a quotation at a page boundary.
text=norm(text)
for header in ['Handle Source Page Lines Source-version hash Full verbatim quote','Question ARBITER Evidence handles (type) Justification Unknowns Counterevidence Unassisted']:
 text=text.replace(norm(header),'')
x=json.loads((root/'data-derived/avatar-trace.json').read_text())['proposal']['evidence']
if isinstance(x,dict):x=list(x.values())
rows=[{'quote':e.get('handle',''), 'characters':len(e['quote']),'complete':norm(e['quote']) in text}for e in x]
(qa/'round14-trace-quote-check.json').write_text(json.dumps(rows,indent=2))
print(f"Complete archived quotations in rendered PDF: {sum(r['complete'] for r in rows)}/{len(rows)}")
print([r for r in rows if not r['complete']])
