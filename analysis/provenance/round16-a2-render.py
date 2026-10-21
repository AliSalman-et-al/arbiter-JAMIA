"""Render every final Word page with LibreOffice and compare with accepted QA."""
from pathlib import Path
import subprocess,os,csv,hashlib
from PIL import Image,ImageDraw
import xml.etree.ElementTree as ET
r=Path(__file__).resolve().parents[1];qa=r/'output/manuscript/qa/round16-a2';qa.mkdir(exist_ok=True)
runtime=Path('/home/ali/.cache/codex-runtimes/codex-primary-runtime')
py=runtime/'dependencies/python/bin/python3'
renderer=runtime/'plugins/openai-primary-runtime/plugins/documents/skills/documents/render_docx.py'
env=os.environ.copy();env['PATH']=str(runtime/'dependencies/bin/override')+':'+env['PATH']
records=[]
for name in os.environ.get('ROUND16_DOCS','Table1,Table2,Table3,Table4,Supplement,TRIPOD-LLM').split(','):
 folder=qa/name
 if not (folder/f'{name}.pdf').exists(): subprocess.run([str(py),str(renderer),str(r/'output/manuscript'/f'{name}.docx'),'--output_dir',str(folder),'--emit_pdf'],env=env,check=True)
 xml=ET.fromstring(subprocess.check_output(['pdftotext','-bbox',str(folder/f'{name}.pdf'),'-']))
 ns={'x':'http://www.w3.org/1999/xhtml'};doc=xml.findall('.//x:page',ns)
 for i,page in enumerate(doc,1):
  words=page.findall('x:word',ns);width=float(page.attrib['width']);height=float(page.attrib['height'])
  outside=[w for w in words if float(w.attrib['xMin']) < -1 or float(w.attrib['yMin']) < -1 or float(w.attrib['xMax']) > width+1 or float(w.attrib['yMax']) > height+1]
  prior=Path('/tmp/round16-a2-before/output/manuscript/qa')/('round16-TRIPOD' if name=='TRIPOD-LLM' else f'round16-{name}')/f'page-{i}.png'
  now=folder/f'page-{i}.png'
  same=prior.exists() and Image.open(prior).size==Image.open(now).size and Image.open(prior).convert('RGB').tobytes()==Image.open(now).convert('RGB').tobytes()
  records.append(dict(document=name,page=i,words=len(words),outside_page=len(outside),identical_to_WPA=bool(same)))
 pages=sorted(folder.glob('page-*.png'),key=lambda p:int(p.stem.split('-')[-1]))
 for k in range(0,len(pages),6):
  out=Image.new('RGB',(1800,1720),'#eee');dr=ImageDraw.Draw(out)
  for j,p in enumerate(pages[k:k+6]):
   im=Image.open(p).convert('RGB');im.thumbnail((590,820));x=(j%3)*600+(600-im.width)//2;y=(j//3)*860+25
   out.paste(im,(x,y));dr.text(((j%3)*600+10,(j//3)*860+5),p.stem,fill='black')
  out.save(folder/f'contact-{k+1:03}.jpg',quality=90)
 print('Rendered',name,len(doc),'pages',flush=True)
if os.environ.get('ROUND16_PARTIAL'):raise SystemExit(0)
for name in ['Figure3','Figure4','Figure5','Figure6','eFigure1','eFigure2','eFigure3','eFigure4','eFigure5']:
 subprocess.run(['pdftoppm','-png','-r','160','-singlefile',str(r/'output/manuscript'/f'{name}.pdf'),str(qa/name)],check=True)
with (r/'provenance/round16-a2-page-comparison.csv').open('w') as f:
 w=csv.DictWriter(f,fieldnames=records[0]);w.writeheader();w.writerows(records)
assert not any(x['outside_page'] or not x['words'] for x in records)
print('Pages',len(records),'identical',sum(x['identical_to_WPA'] for x in records),'outside/empty 0',flush=True)
