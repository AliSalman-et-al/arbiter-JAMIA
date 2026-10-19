#!/usr/bin/env python3
"""QA geometry and raster metadata of the real publication files."""
from pathlib import Path
import json
import pymupdf as fitz
from PIL import Image
root=Path(__file__).resolve().parent
qa=root/'output/manuscript/qa'
report={'figures':[],'documents':[],'failures':[]}
for name in ['Figure1','Figure2','Figure3','Figure4','Figure5','Figure6','eFigure1']:
 p=root/f'output/manuscript/{name}.pdf'; doc=fitz.open(p)
 entry={'name':name,'pages':len(doc),'width_mm':doc[0].rect.width*25.4/72}
 if abs(entry['width_mm']-174)>.2: report['failures'].append(f'{name}: width is not 174 mm')
 if len(doc)!=1: report['failures'].append(f'{name}: unexpected pages')
 if name not in ['Figure1','Figure2']:
  spans=[s for b in doc[0].get_text('dict')['blocks'] if 'lines' in b for l in b['lines'] for s in l['spans'] if s['text'].strip()]
  entry['min_text_pt']=min(s['size'] for s in spans)
  if entry['min_text_pt']<6.95: report['failures'].append(f'{name}: text below 7 pt')
 with Image.open(root/f'output/manuscript/{name}.tiff') as im:
  entry.update(tiff_size=im.size,tiff_dpi=tuple(float(v) for v in im.info.get('dpi',(0,0))),compression=im.info.get('compression'))
  if round(im.info.get('dpi',(0,))[0])!=600 or im.info.get('compression')!='tiff_lzw': report['failures'].append(f'{name}: TIFF format')
 report['figures'].append(entry)
for name in ['Table1','Table2','Table3','Table4','Supplement','TRIPOD-LLM']:
 p=qa/f'round14-{name}'/'rendered.pdf'
 if not p.exists():
  # The packaged renderer retains the original basename for its PDF.
  candidates=list((qa/f'round14-{name}').glob('*.pdf'))
  if not candidates: report['failures'].append(f'{name}: missing rendered PDF');continue
  p=candidates[0]
 doc=fitz.open(p);entry={'name':name,'pdf':str(p.relative_to(root)),'pages':len(doc),'out_of_page_spans':[]}
 for i,page in enumerate(doc):
  if not page.get_text().strip() and not page.get_images(): report['failures'].append(f'{name}: blank page {i+1}')
  for b in page.get_text('dict')['blocks']:
   for l in b.get('lines',[]):
    for s in l['spans']:
     x0,y0,x1,y1=s['bbox']
     if s['text'].strip() and (x0<-.5 or y0<-.5 or x1>page.rect.width+.5 or y1>page.rect.height+.5): entry['out_of_page_spans'].append([i+1,s['text'],s['bbox']])
 if entry['out_of_page_spans']: report['failures'].append(f'{name}: text outside page')
 report['documents'].append(entry)
(qa/'round14-layout.json').write_text(json.dumps(report,indent=2))
print(json.dumps(report,indent=2))
raise SystemExit(bool(report['failures']))
