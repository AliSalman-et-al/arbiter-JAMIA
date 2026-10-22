"""Focused checks for the production gt/Word/HTML presentation contract."""
from pathlib import Path
from zipfile import ZipFile
import re,json,csv
from lxml import etree,html
ROOT=Path(__file__).resolve().parents[2]
OUT=ROOT/'analysis/output/manuscript'
NS={'w':'http://schemas.openxmlformats.org/wordprocessingml/2006/main'}
checks={}
for name in ['Table1','Table2','Table3','Manuscript','Supplement','TRIPOD-LLM']:
 with ZipFile(OUT/f'{name}.docx') as z:
  doc=etree.fromstring(z.read('word/document.xml'))
  paragraphs=[''.join(p.xpath('.//w:t/text()',namespaces=NS)) for p in doc.xpath('//w:p',namespaces=NS)]
  text='\n'.join(paragraphs)
  tables=doc.xpath('//w:tbl',namespaces=NS)
  assert tables,name
  assert not re.search(r'CI, confidence interval\.\s*CI, confidence interval|\bTRUE\b|\bFALSE\b',text),name
  assert not any(re.search(r'—[ \t]+—',p) for p in paragraphs),name
  for t in tables:
   assert t.xpath('./w:tblPr/w:tblLayout[@w:type="fixed"]',namespaces=NS),name
   assert t.xpath('./w:tr/w:trPr/w:tblHeader',namespaces=NS),name
   assert all(int(v)>=18 for v in t.xpath('.//w:sz/@w:val',namespaces=NS)),name
  assert any(n.startswith('word/footer') for n in z.namelist()),name
  if name=='Manuscript':
   assert len(tables)==3
   assert not any(re.match(r'eFigure [1-5][ .]',p) for p in paragraphs), 'Supplementary legends leaked into the main manuscript'
   assert sum(p.startswith('Alt text:') for p in paragraphs)==5
   for i in range(1,6):assert re.search(rf'Figure {i}[ .]',text)
   assert re.search(r'Word counts: main text [0-9]+; structured abstract [0-9]+[.]',text)
   styles=etree.fromstring(z.read('word/styles.xml'))
   assert styles.xpath('//w:style/w:pPr/w:spacing[@w:line="480"]',namespaces=NS)
  if name=='Supplement':
   normalized=' '.join('\n'.join(p for p in paragraphs if not p.startswith('Context: eh_')).split())
   trace_cells=0
   for trace in (ROOT/'analysis/output/tables').glob('avatar-trace-*.csv'):
    with trace.open(encoding='utf-8-sig',newline='') as f:
     for row in csv.DictReader(f):
      for value in row.values():
       if value:
        assert ' '.join(value.split()) in normalized,(trace.name,'missing original trace text',value[:70])
        trace_cells+=1
   assert trace_cells>50
   for p in doc.xpath('//w:body/w:p',namespaces=NS):
    caption=''.join(p.xpath('.//w:t/text()',namespaces=NS))
    style_id=p.xpath('./w:pPr/w:pStyle/@w:val',namespaces=NS)
    if caption.startswith(('eTable 13B.','eTable 16.')) and not any(s.lower().startswith('toc') for s in style_id):
     table=p.xpath('following-sibling::w:tbl[1]',namespaces=NS)[0]
     content=' '.join(table.xpath('.//w:t/text()',namespaces=NS))
     assert re.search(r'CI, (?:95% )?confidence interval',content),caption
     if caption.startswith('eTable 16.'):
      assert 'D1–D5' not in content and '81 trials' in content,caption
  checks[name]={'tables':len(tables),'page_footer':True,'editable_gt_ooxml':True}
  if name=='Supplement':checks[name]['original_trace_cells_retained']=trace_cells
for name in ['results','supplement']:
 page=html.fromstring((ROOT/f'analysis/{name}.html').read_bytes())
 tables=page.xpath('//table')
 assert len(page.xpath('//h1'))==1,(name,'duplicate document h1')
 assert tables and all('gt_table' in t.get('class','') for t in tables),name
 assert not page.xpath('//table//blockquote'),name
 if name=='supplement':
  ids=set(page.xpath('//@id'))
  navigation=page.xpath('//details//a[starts-with(@href,"#")]')
  assert len(navigation)>=40
  assert all(a.get('href')[1:] in ids for a in navigation)
 if name=='results':
  assert len(tables)==3
  assert not any(re.match(r'eFigure [1-5]',h.text_content()) for h in page.xpath('//h1|//h2|//h3|//h4'))
  imgs=page.xpath('//img[contains(@src,"data:")]')
  assert sum(len(i.get('alt',''))>60 for i in imgs)>=5
 for a in page.xpath('//a[@href]'):
  href=a.get('href').split('#')[0]
  if not href or re.match(r'[a-z]+:',href) or href.startswith('//'):continue
  if href=='index.html':continue # Landing page belongs to the parent packager.
  assert (ROOT/'analysis'/href).is_file(),(name,href)
 checks[name]={'native_gt_tables':len(tables),'no_blockquote_cells':True,'local_downloads_exist':True}
 if name=='supplement':checks[name]['validated_contents_links']=len(navigation)
source='\n'.join((ROOT/'analysis/R'/p).read_text(encoding='utf-8') for p in ['presentation.R','displays.R','manuscript-supplement.R'])
assert 'flextable::' not in source
assert 'gt::gt(' in source and 'gt::as_word(' in source and 'gt::as_raw_html(' in source
checks['production_table_path']='gt objects -> native Word OOXML and native HTML'
print(json.dumps({'PASS':True,'checks':checks},indent=2))
