#!/usr/bin/env python3
"""Re-render frozen vector scenes with only the three authorised source strings.

Uses the original outlined SVG, bundled fonts and export_scene implementation;
no log-dependent provenance extraction or writes under figure1 are performed.
Audits source deltas, SVG geometry, semantic labels and image differences.
"""
from pathlib import Path
import sys,re,html,json,subprocess,io,hashlib,xml.etree.ElementTree as ET
ROOT=Path(__file__).resolve().parent.parent
sys.path.insert(0,str(ROOT/'analysis/figure1'))
import build
from PIL import Image,ImageChops,ImageDraw
import fitz,resvg_py,tempfile,shutil
BASE='120b332'
OUT=ROOT/'analysis/output/manuscript'
QA=ROOT/'analysis/round14-verification/round3-figures';QA.mkdir(parents=True,exist_ok=True)
def old(p):return subprocess.check_output(['git','show',f'{BASE}:{p}'],cwd=ROOT)
changes={'Figure1':{'and supporting evidence':'and cited evidence','Store an unchangeable':'Store a content-hashed'},'Figure2':{'direct support':'direct quotation'}}
source_changes={'build.py':changes['Figure1'],'figure2.py':changes['Figure2']}
for name,replacements in source_changes.items():
 p='analysis/figure1/'+name
 expected=old(p).decode()
 for a,b in replacements.items():assert expected.count(a)==1;expected=expected.replace(a,b)
 assert (ROOT/p).read_text()==expected,('Unexpected source edit',name)
for p in subprocess.check_output(['git','ls-tree','-r','--name-only',BASE,'analysis/figure1'],cwd=ROOT,text=True).splitlines():
 if Path(p).name not in source_changes:assert (ROOT/p).read_bytes()==old(p),p
NS={'s':'http://www.w3.org/2000/svg'}
pattern=r'<g aria-label=".*?</g>'
report=[]
def reconstruct(svg):
 scene=build.Scene();root=ET.fromstring(svg);scene.height=float(root.attrib['viewBox'].split()[-1])
 scene.svg=lambda:svg
 for group in re.findall(pattern,svg,re.S):
  el=ET.fromstring(group);value=el.attrib['aria-label'];paths=el.findall('path')
  transform=paths[0].attrib['transform']
  m=re.match(r'translate\(([-\d.]+) ([-\d.]+)\) scale\(([-\d.]+) ([-\d.]+)\)',transform);assert m,transform
  x,y,sx,sy=map(float,m.groups());size=-sy*1000
  # Infer face by the actual first non-space outlined glyph, never system fonts.
  char=next(c for c in value if c!=' ')
  faces=[]
  for face,font in scene.fonts.items():
   from fontTools.pens.svgPathPen import SVGPathPen
   pen=SVGPathPen(font.getGlyphSet());font.getGlyphSet()[font.getBestCmap()[ord(char)]].draw(pen)
   if pen.getCommands()==paths[0].attrib['d']:faces.append(face)
  assert len(faces)==1,(value,faces)
  face=faces[0];size=round(-sy*scene.fonts[face]['head'].unitsPerEm,4);scene.text(x,y,value,size,face,el.attrib['fill'],italic='skewX' in transform,stretch=sx/-sy)
 scene.parts=[]
 for el in root.findall('.//s:rect',NS):
  if el.attrib.get('fill')=='url(#not-asked)':scene.hatch_records.append(tuple(float(el.attrib[k]) for k in ['x','y','width','height']))
 images=root.findall('.//s:image',NS)
 if images:
  assert len(images)==1
  el=images[0];scene.report_image=dict(path=build.HERE/'qa/avatar-html-report-domain-view.png',**{k:float(el.attrib[v]) for k,v in [('x','x'),('y','y'),('w','width'),('h','height')]})
 return scene
for name,replacements in changes.items():
 before=old(f'analysis/output/manuscript/{name}.svg').decode()
 scene=reconstruct(before)
 groups=list(re.finditer(pattern,before,re.S));new=before;regions=[]
 for match,record in reversed(list(zip(groups,scene.pdf_text))):
  a=record['text']
  if a not in replacements:continue
  b=replacements[a];s=build.Scene()
  # Both Figure 1 edits use a centred label at the unchanged column centre.
  x=record['x']+scene.width(a,record['size'],record['face'])/2 if name=='Figure1' else record['x']
  s.text(x,record['y'],b,record['size'],record['face'],record['color'],anchor='middle' if name=='Figure1' else 'start')
  new=new[:match.start()]+''.join(s.parts)+new[match.end():]
  prior=scene.text_records[groups.index(match)]['bbox'];after=s.text_records[0]['bbox']
  regions.append([min(prior[0],after[0])-2,min(prior[1],after[1])-2,max(prior[2],after[2])+2,max(prior[3],after[3])+2])
 # Exact string-only semantic and structural proof; glyph paths only in affected groups.
 expected=[replacements.get(r['text'],r['text']) for r in scene.pdf_text]
 after_labels=[html.unescape(x) for x in re.findall(r'aria-label="(.*?)"',new)]
 assert after_labels==expected
 def neutral(svg):
  return re.sub(pattern,lambda m:'<CHANGED_TEXT/>' if html.unescape(re.search(r'aria-label="(.*?)"',m.group())[1]) in set(replacements)|set(replacements.values()) else m.group(),svg,flags=re.S)
 assert neutral(before)==neutral(new),'Unapproved SVG geometry change'
 # Replay each frozen SVG identically before applying text edits. Baseline PNGs
 # must match byte-for-byte decoded pixels under the pinned resvg renderer.
 baseline_png=resvg_py.svg_to_bytes(svg_string=before,width=1644,dpi=96,skip_system_fonts=True)
 assert ImageChops.difference(Image.open(io.BytesIO(baseline_png)).convert('RGB'),Image.open(io.BytesIO(old(f'analysis/output/manuscript/{name}.png'))).convert('RGB')).getbbox() is None
 with tempfile.TemporaryDirectory(prefix='round14-figure-') as temp:
  after_export=Path(temp);(after_export/'qa').mkdir()
  build.export_scene(reconstruct(new),after_export,name,{})
  for suffix in ['svg','pdf','png','tiff']:(OUT/f'{name}.{suffix}').write_bytes((after_export/f'{name}.{suffix}').read_bytes())
 diffs=[]
 for suffix in ['png','tiff','pdf']:
  def im(data):
   if suffix=='pdf':
    with fitz.open(stream=data,filetype='pdf') as d:
     pix=d[0].get_pixmap(dpi=160,alpha=False);return Image.frombytes('RGB',(pix.width,pix.height),pix.samples)
   return Image.open(io.BytesIO(data)).convert('RGB')
  a,b=im(old(f'analysis/output/manuscript/{name}.{suffix}')),im((OUT/f'{name}.{suffix}').read_bytes())
  diff=ImageChops.difference(a,b);mask=Image.new('L',a.size);draw=ImageDraw.Draw(mask)
  for x0,y0,x1,y1 in regions:draw.rectangle((int(x0*a.width/696),int(y0*a.height/scene.height),int(x1*a.width/696)+1,int(y1*a.height/scene.height)+1),fill=255)
  outside=diff.copy();outside.paste((0,0,0),(0,0),mask)
  assert outside.getbbox() is None,(name,suffix,'Pixels changed outside approved labels',outside.getbbox())
  diffs.append({'format':suffix,'changed_bbox':diff.getbbox(),'outside_approved_regions':0,'comparison':'actual committed 120b332 render versus current render'})
  if suffix=='png':diff.save(QA/f'{name}-difference.png');b.save(QA/f'{name}-after.png')
 report.append({'figure':name,'source_only_approved_strings':True,'approved_text_changes':replacements,'changed_svg_groups':len(regions),'svg_text_only_approved_strings':True,'all_other_svg_bytes_identical':True,'baseline_png_replay_pixel_identical':True,'actual_baseline_pdf_and_tiff_checked':True,'approved_regions_svg_units':regions,'diffs':diffs})
(QA/'proof.json').write_text(json.dumps(report,indent=2))
print(json.dumps(report,indent=2))
