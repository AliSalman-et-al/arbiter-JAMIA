from pathlib import Path
import csv,hashlib,json,subprocess,xml.etree.ElementTree as ET,difflib
from pdf2image import convert_from_path
ROOT=Path(__file__).resolve().parents[4]
QA=Path(__file__).with_name('proof');OLD=QA.parent.parent/'remediation/proof-jama'
POPPLER=Path.home()/'.cache/codex-runtimes/codex-primary-runtime/dependencies/native/poppler/Library/bin'
TEXT='C:/Program Files/Calibre2/app/bin/pdftotext.exe'
def digest(b):return hashlib.sha256(b).hexdigest()
def pages(pdf):
 xml=ET.fromstring(subprocess.check_output([TEXT,'-bbox',str(pdf),'-']))
 ns={'x':'http://www.w3.org/1999/xhtml'}
 return [(p,p.findall('x:word',ns)) for p in xml.findall('.//x:page',ns)]
records=[];checks=[]
for name in ['Table1','Table2','Table3','Manuscript','Supplement','TRIPOD-LLM']:
 folder=QA/name;folder.mkdir(exist_ok=True)
 images=convert_from_path(str(QA/f'{name}.pdf'),dpi=105,output_folder=str(folder),fmt='png',output_file='page',paths_only=True,poppler_path=str(POPPLER))
 old=pages(OLD/f'{name}.pdf');new=pages(QA/f'{name}.pdf')
 (QA/f'{name}-old.txt').write_text('\n\f\n'.join(' '.join(w.text or '' for w in ws) for _,ws in old),encoding='utf-8')
 (QA/f'{name}-new.txt').write_text('\n\f\n'.join(' '.join(w.text or '' for w in ws) for _,ws in new),encoding='utf-8')
 diffs=[]
 for i in range(max(len(old),len(new))):
  a=' '.join(w.text or '' for w in old[i][1]) if i<len(old) else ''
  b=' '.join(w.text or '' for w in new[i][1]) if i<len(new) else ''
  oldimage=next(iter(sorted((OLD/name).glob(f'page*-{i+1:0{3 if name=="Supplement" else 1}d}.png'))),None)
  if oldimage is None:
   oldimage=next((p for p in (OLD/name).glob('page*.png') if int(p.stem.rsplit('-',1)[-1])==i+1),None)
  oldhash=digest(oldimage.read_bytes()) if oldimage else ''
  newhash=digest(Path(images[i]).read_bytes()) if i<len(images) else ''
  records.append(dict(document=name,page=i+1,old_pages=len(old),new_pages=len(new),old_text_sha256=digest(a.encode()),new_text_sha256=digest(b.encode()),text_changed=a!=b,old_png_sha256=oldhash,new_png_sha256=newhash,visual_changed=oldhash!=newhash,reflow=len(old)!=len(new)))
  if a!=b:diffs.extend(difflib.unified_diff(a.split(),b.split(),fromfile=f'old page {i+1}',tofile=f'new page {i+1}',lineterm=''))
  if i<len(new):
   p,ws=new[i];outside=[w for w in ws if float(w.get('xMin'))<0 or float(w.get('yMin'))<0 or float(w.get('xMax'))>float(p.get('width')) or float(w.get('yMax'))>float(p.get('height'))]
   checks.append(dict(document=name,page=i+1,words=len(ws),outside_page=len(outside)))
 (QA/f'{name}-text.diff').write_text('\n'.join(diffs),encoding='utf-8')
 print(name,len(old),'->',len(new),'pages; changed text pages:',[r['page'] for r in records if r['document']==name and r['text_changed']],flush=True)
for filename,rows in [('page-diff.csv',records),('page-checks.csv',checks)]:
 with (QA/filename).open('w',encoding='utf-8',newline='') as f:
  w=csv.DictWriter(f,fieldnames=list(rows[0]));w.writeheader();w.writerows(rows)
assert all(r['words'] and not r['outside_page'] for r in checks)
