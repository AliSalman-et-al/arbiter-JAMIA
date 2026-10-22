from pathlib import Path
import subprocess, json, re, fitz
ROOT=Path(__file__).resolve().parents[4]
OUT=Path(__file__).resolve().parent
head=subprocess.check_output(['git','rev-parse','HEAD'],cwd=ROOT,text=True).strip()
(OUT/'checkout.json').write_text(json.dumps({'baseline':'951dddd3e28e0d6316c641491667353e0b851a78','actual_head':head,'method':'git rev-parse HEAD; read-only uncommitted file audit; no rebuild'},indent=2))
# Verifier is copied byte-for-byte except ALL provenance destinations are redirected.
s=(ROOT/'analysis/verify-output.R').read_text(encoding='utf-8-sig')
s=s.replace("'provenance", "'../docs/rethink-2026-10-22/final-audit/numbers/provenance")
(OUT/'verify-output-audit.R').write_text(s,encoding='utf-8')
s=(ROOT/'docs/rethink-2026-10-22/verify-rebuild.py').read_text(encoding='utf-8-sig')
s=s.replace("ROOT=Path(__file__).resolve().parents[2] if '__file__' in globals() and __file__!='<stdin>' else Path.cwd()",'ROOT=Path('+repr(str(ROOT))+')')
s=s.replace("ROOT/'docs/rethink-2026-10-22/implementation-invariance.json'","ROOT/'docs/rethink-2026-10-22/final-audit/numbers/invariance.json'")
(OUT/'verify-rebuild-audit.py').write_text(s,encoding='utf-8')
pages=[]
for name in ['Manuscript','Supplement','Table1','Table2','Table3','TRIPOD-LLM']:
 d=fitz.open(ROOT/'docs/rethink-2026-10-22/rendered'/f'{name}.pdf')
 for i,p in enumerate(d):
  t=p.get_text()
  pages.append({'document':name,'page':i+1,'text':t})
(OUT/'page-text.json').write_text(json.dumps(pages,ensure_ascii=False,indent=2),encoding='utf-8')
for p in pages:
 if p['document']=='Supplement':
  t=p['text']; headings=re.findall(r'(?:eTable \d+[^\n]*|eFigure \d+[^\n]*|[^\n]*(?:continued|differences|eligibility)[^\n]*)',t)
  print(p['page'], ' | '.join(headings[:4]) or t[:95].replace('\n',' '))
