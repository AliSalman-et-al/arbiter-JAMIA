#!/usr/bin/env python3
from pathlib import Path
from PIL import Image,ImageDraw
import pymupdf
qa=Path(__file__).resolve().parent/'output/manuscript/qa'
for name in ['Supplement','TRIPOD-LLM']:
 p=qa/f'round14-{name}'; files=sorted(p.glob('page-*.png'),key=lambda x:int(x.stem.split('-')[-1]))
 for old in qa.glob(f'round14-{name}-contact-*.png'): old.unlink()
 for start in range(0,len(files),8):
  out=Image.new('RGB',(1600,1200),'#d5d5d5');draw=ImageDraw.Draw(out)
  for i,f in enumerate(files[start:start+8]):
   im=Image.open(f).convert('RGB'); im.thumbnail((390,560));x=(i%4)*400;y=(i//4)*600
   out.paste(im,(x+(400-im.width)//2,y+28));draw.text((x+12,y+8),f'{name}: {f.stem}',fill='black')
  out.save(qa/f'round14-{name}-contact-{start//8+1}.png')
 doc=pymupdf.open(next(p.glob('*.pdf')))
 lines=[f'{i+1}: {len(page.get_text())} chars: '+page.get_text().replace('\n',' ')[:140].rstrip() for i,page in enumerate(doc)]
 (qa/f'round14-{name}-page-text.txt').write_text('\n'.join(lines))
 print(name,len(doc),'pages')
