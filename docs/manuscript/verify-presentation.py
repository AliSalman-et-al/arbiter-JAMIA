"""Focused checks for the production gt/Word/HTML presentation contract."""
from pathlib import Path
from zipfile import ZipFile
import re,json,csv,importlib.util
from lxml import etree,html
ROOT=Path(__file__).resolve().parents[2]
OUT=ROOT/'analysis/output/manuscript'
NS={'w':'http://schemas.openxmlformats.org/wordprocessingml/2006/main'}
checks={}
spec=importlib.util.spec_from_file_location('report_refresh',ROOT/'scripts/report-refresh.py')
refresh=importlib.util.module_from_spec(spec)
spec.loader.exec_module(refresh)
metadata=refresh.metadata
for name in ['Table1','Table2','Table3','Main-analysis','Supplement','TRIPOD-LLM']:
 with ZipFile(OUT/f'{name}.docx') as z:
  doc=etree.fromstring(z.read('word/document.xml'))
  paragraphs=[''.join(p.xpath('.//w:t/text()',namespaces=NS)) for p in doc.xpath('//w:p',namespaces=NS)]
  text='\n'.join(paragraphs)
  assert 'Unassisted' not in text,f'{name}: comparison arm display rename missing'
  assert not re.search(r'\bExpert [12]\b',text),f'{name}: old numbered human-reference label'
  tables=doc.xpath('//w:tbl',namespaces=NS)
  assert tables,name
  assert not re.search(r'CI, confidence interval\.\s*CI, confidence interval|\bTRUE\b|\bFALSE\b',text),name
  assert not any(re.search(r'—[ \t]+—',p) for p in paragraphs),name
  for t in tables:
   assert t.xpath('./w:tblPr/w:tblLayout[@w:type="fixed"]',namespaces=NS),name
   assert t.xpath('./w:tr/w:trPr/w:tblHeader',namespaces=NS),name
   assert all(int(v)>=18 for v in t.xpath('.//w:sz/@w:val',namespaces=NS)),name
  assert any(n.startswith('word/footer') for n in z.namelist()),name
  if name in {'Table2','Main-analysis'}:
   assert 'B. Structural record checks' not in text,name
   assert 'B. Computational resources' in text,name
   assert 'C. Evidence records (ARBITER only)' in text,name
   for label,value in [('Active required answers citing evidence','1,538/1,538'),
                       ('Text spans with complete binding fields','1,407/1,407'),
                       ('Image records with complete fields','14/14'),
                       ('Exported records passing structural verification','102/102')]:
    row=next(t for t in doc.xpath('//w:tr',namespaces=NS) if label in ''.join(t.xpath('.//w:t/text()',namespaces=NS)))
    row_text=' '.join(row.xpath('.//w:t/text()',namespaces=NS))
    assert value in row_text and 'Not available' in row_text,(name,label,row_text)
   assert 'do not assess whether evidence supports an answer' in text,name
  if name=='Main-analysis':
   assert len(tables)==metadata.MAIN_TABLE_COUNT
   assert len(doc.xpath('//w:drawing',namespaces=NS))==metadata.MAIN_FIGURE_COUNT
  if name=='Supplement':
   assert 'Main Table 3 contains conditional-choice sensitivities' in text
   assert not re.search(r'(?<!e)\bTable 4\b',text.split('Prompt templates and run provenance')[0]),'Old main table reference remains'
   assert not doc.xpath('//w:drawing',namespaces=NS),'Retired supplementary figures remain'
   assert not any(re.match(r'eTable .*?(Benchmark targets and sources|Exploratory diagnostic checks|Rules-only recomputation)',p) for p in paragraphs),'Removed table family remains'
   for number in range(1,metadata.SUPPLEMENT_TABLE_COUNT+1):
    assert any(p.startswith(f'eTable {number}.') for p in paragraphs),f'Missing eTable {number}'
   assert not re.search(r'post[ -]?hoc',' '.join(''.join(t.xpath('.//w:t/text()',namespaces=NS)) for t in tables),re.I),'Post hoc term remains in tables'
   headings=[int(m[1]) for p in paragraphs if (m:=re.match(r'^eTable (\d+)\.',p))]
   assert headings==list(range(1,14)),headings
   assert not any(re.match(r'eTable \d+[A-Z][ .]',p) for p in paragraphs),'Lettered eTable remains'
   assert not any(re.search(r'post[ -]?hoc',p,re.I) for p in paragraphs if p.startswith('eTable ')), 'Post hoc table label remains'
   for caption in ('eTable 6. Pooled category disagreements',
                   'eTable 13. Paired signalling-answer differences by question','eTable 11. Signalling eligibility counts'):
    assert caption in paragraphs,caption
   for value in ('−39.6','−28.4'):
    assert value in text,('Retained adverse diagnostic missing',value)
   assert '26 October 2026' in text and '54645d75e7a8b32bbf09968893e7be45faa4cab4' in text
   relationships=etree.fromstring(z.read('word/_rels/document.xml.rels'))
   targets=relationships.xpath('//@Target')
   for label,url in metadata.WORKED_EXAMPLE_LINKS:
    assert url in targets,(label,'Current complete worked example link missing')
    source=url.split('/blob/main/',1)[1]
    assert (ROOT/source).is_file(),source
  checks[name]={'tables':len(tables),'page_footer':True,'editable_gt_ooxml':True}
  if name=='Supplement':checks[name]['thirteen_tables_in_citation_order']=True
for name in ['results','supplement']:
 page=html.fromstring((ROOT/f'analysis/{name}.html').read_bytes())
 tables=page.xpath('//table')
 assert len(page.xpath('//h1'))==1,(name,'duplicate document h1')
 assert tables and all(t.xpath('ancestor::*[contains(concat(" ",normalize-space(@class)," ")," manuscript-table ")]') for t in tables),name
 sources=[OUT/f'Table{i}.docx' for i in metadata.MAIN_TABLE_NUMBERS] if name=='results' else [OUT/'Supplement.docx']
 assert refresh.html_cells(page)==[cells for source in sources for cells in refresh.word_cells(source)],(name,'HTML differs from finalized gt Word tables')
 assert not page.xpath('//table//blockquote'),name
 if name=='supplement':
  ids=set(page.xpath('//@id'))
  navigation=page.xpath('//details//a[starts-with(@href,"#")]')
  for number in range(1,metadata.SUPPLEMENT_TABLE_COUNT+1):
   assert any(a.text_content().startswith(f'eTable {number}.') for a in navigation),number
  assert all(a.get('href')[1:] in ids for a in navigation)
 if name=='results':
  assert len(tables)==metadata.MAIN_TABLE_COUNT
  assert not any(re.match(r'eFigure [1-5]',h.text_content()) for h in page.xpath('//h1|//h2|//h3|//h4'))
  imgs=page.xpath('//img[contains(@src,"data:")]')
  assert sum(len(i.get('alt',''))>60 for i in imgs)==metadata.MAIN_FIGURE_COUNT
  for label,url in metadata.WORKED_EXAMPLE_LINKS:
   assert page.xpath('//a[@href=$url]',url=url),(name,label)
 for a in page.xpath('//a[@href]'):
  href=a.get('href').split('#')[0]
  if not href or re.match(r'[a-z]+:',href) or href.startswith('//'):continue
  if href=='index.html':continue # Landing page belongs to the parent packager.
  assert (ROOT/'analysis'/href).is_file(),(name,href)
 checks[name]={'native_tables_from_gt_word':len(tables),'source_cell_equality':True,'no_blockquote_cells':True,'local_downloads_exist':True}
 if name=='supplement':checks[name]['validated_contents_links']=len(navigation)
source='\n'.join((ROOT/'analysis/R'/p).read_text(encoding='utf-8') for p in ['presentation.R','displays.R','manuscript-supplement.R'])
assert 'flextable::' not in source
assert 'gt::gt(' in source and 'gt::as_word(' in source and 'gt::as_raw_html(' in source
checks['production_table_path']='gt objects -> native Word OOXML -> verified native HTML'
print(json.dumps({'PASS':True,'checks':checks},indent=2))
