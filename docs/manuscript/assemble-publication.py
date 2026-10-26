"""Assemble native gt tables, manuscript structure and page navigation."""
from pathlib import Path
from copy import deepcopy
import importlib.util
import re
import sys
import csv
from docx import Document
from docx.shared import Inches, Pt, RGBColor
from docx.oxml import OxmlElement
from docx.oxml.ns import qn
from docx.text.paragraph import Paragraph
from docx.enum.style import WD_STYLE_TYPE

ROOT = Path(__file__).resolve().parents[2]
OUT = ROOT/'analysis/output/manuscript'
spec = importlib.util.spec_from_file_location('manuscript_sources', ROOT/'scripts/manuscript-sources.py')
metadata = importlib.util.module_from_spec(spec); spec.loader.exec_module(metadata)
spec = importlib.util.spec_from_file_location('numbers', Path(__file__).with_name('verify-numbers.py'))
numbers = importlib.util.module_from_spec(spec); spec.loader.exec_module(numbers)
text = numbers.MANUSCRIPT.read_text(encoding='utf-8'); sections = numbers.sections(text)
counts, main_words = numbers.word_counts(text)
abstract_words = counts['Abstract']

def bind_final_reference(p):
    match = re.search(r'(?<=[.!?])(?=\[[\d,–-]+\]$)', p.text)
    if match is None:
        return
    offset = match.start()
    for run in p.runs:
        if offset <= len(run.text):
            run.text = run.text[:offset] + '\u2060' + run.text[offset:]
            break
        offset -= len(run.text)


def format_abstract(doc):
    # The next body H2 ends the abstract, even when subsection names repeat.
    in_abstract = False
    for p in list(doc.paragraphs):
        if p.style.name == 'Heading 1':
            in_abstract = p.text == 'ABSTRACT'
            if in_abstract:
                p.paragraph_format.line_spacing = 1
            continue
        if in_abstract and p.style.name == 'Heading 2':
            next_node = p._p.getnext()
            if next_node is not None and next_node.tag == qn('w:p'):
                following = Paragraph(next_node, doc._body)
                label = p.text
                p._element.getparent().remove(p._element)
                run = OxmlElement('w:r'); props = OxmlElement('w:rPr'); props.append(OxmlElement('w:b')); run.append(props)
                t = OxmlElement('w:t'); t.set(qn('xml:space'), 'preserve'); t.text = label + '. '; run.append(t)
                following._p.insert(1 if following._p.pPr is not None else 0, run)
                following.paragraph_format.space_after = Pt(4)

def page_numbers(doc):
    for section in doc.sections:
        p = section.footer.paragraphs[0]; p.alignment = 2
        p.clear(); p.add_run('Page ')
        field = OxmlElement('w:fldSimple'); field.set(qn('w:instr'),'PAGE')
        p._p.append(field)
        for r in p.runs:r.font.name='Arial';r.font.size=Pt(9)

def bookkeep(doc):
    # Word updates TOC/PAGEREF fields on opening or with the COM proof helper.
    toc_fields=[f for f in doc.element.xpath('.//w:instrText') if f.text and f.text.strip().startswith('TOC ')]
    if toc_fields:
        if 'TOC 1' not in doc.styles:
            doc.styles.add_style('TOC 1',WD_STYLE_TYPE.PARAGRAPH,builtin=True)
        for style in doc.styles:
            if style.type==WD_STYLE_TYPE.PARAGRAPH and style.name.lower().startswith('toc'):
                style.font.name='Arial';style.font.size=Pt(10)
        # officer's renamed heading styles do not reliably populate Word's
        # built-in-heading TOC. Select actual stable reader locators explicitly.
        nav_name='Heading navigation'
        if nav_name not in doc.styles:
            nav=doc.styles.add_style(nav_name,WD_STYLE_TYPE.PARAGRAPH)
            nav.base_style=doc.styles['heading 2']
        for p in doc.paragraphs:
            if p.style.name.lower().startswith('heading'):
                selected=bool(re.match(r'^(eTable \d+[A-C]?[ .]|eFigure [1-5][ .]|[1-7]\. |eMethods|AVATAR complete trace$|Prompt templates and run provenance$)',p.text))
                if selected and '(continued ' not in p.text:p.style=doc.styles[nav_name]
        for field in toc_fields:field.text='TOC \\t "Heading navigation,1" \\h \\z'
    settings=doc.settings.element
    old=settings.find(qn('w:updateFields'))
    if old is None:old=OxmlElement('w:updateFields');settings.append(old)
    old.set(qn('w:val'),'true')
    ours=[b for b in doc.element.xpath('.//w:bookmarkStart') if b.get(qn('w:name'),'').startswith('loc_')]
    identifiers={b.get(qn('w:id')) for b in ours}
    for b in ours+[b for b in doc.element.xpath('.//w:bookmarkEnd') if b.get(qn('w:id')) in identifiers]:
        b.getparent().remove(b)
    next_id=max([int(b.get(qn('w:id'),'0')) for b in doc.element.xpath('.//w:bookmarkStart')]+[0])+1
    for i,p in enumerate(doc.paragraphs):
        if p.style.name.lower().startswith('heading'):
            start=OxmlElement('w:bookmarkStart');start.set(qn('w:id'),str(next_id+i));start.set(qn('w:name'),f'loc_{i}')
            end=OxmlElement('w:bookmarkEnd');end.set(qn('w:id'),str(next_id+i))
            p._p.insert(0,start);p._p.append(end)
    for p in doc.paragraphs:
        if p.style.name.lower().startswith('heading') or re.match(r'^e?Figure [1-5] ',p.text):
            for run in p.runs:
                run.text=re.sub(r'^(e?Table [0-9]+[A-C]?|e?Figure [0-9]+) ',r'\1. ',run.text)
    page_numbers(doc)

path=OUT/'Manuscript.docx';doc=Document(path)
for section in doc.sections:
    section.top_margin=section.bottom_margin=Inches(.75)
    section.left_margin=section.right_margin=Inches(.7)
# Journal prose and captions double-spaced; native gt cells retain their own spacing.
for style in doc.styles:
    if style.type == 1:
        style.font.name='Arial';style.font.size=Pt(11);style.font.color.rgb=RGBColor(0,0,0)
        for fonts in style.element.xpath('./w:rPr/w:rFonts'):
            for key in list(fonts.attrib):
                if key.endswith('Theme'):
                    del fonts.attrib[key]
        style.paragraph_format.line_spacing=2
        style.paragraph_format.space_after=Pt(0)
        if style.name in ['Heading 1','Heading 2']:
            style.font.bold=True
            style.paragraph_format.keep_with_next=True
for p in list(doc.paragraphs):
    original_style=p.style.name
    # Keep paragraph-final numeric citations with the preceding word.
    bind_final_reference(p)
    if p.text=='Front-matter notes':
        p._element.getparent().remove(p._element)
        continue
    if original_style=='Heading 2' and p.text in ['Abstract','Introduction']:
        p.paragraph_format.page_break_before=True
    # Pandoc's # title, ## sections and ### subsections are one level deeper
    # than the manuscript hierarchy required by the journal.
    if original_style=='Heading 1':
        p.style=doc.styles['Title']
        for r in p.runs:r.bold=True;r.font.size=Pt(14)
    elif original_style=='Heading 2':
        p.style=doc.styles['Heading 1']
        for r in p.runs:r.text=r.text.upper();r.bold=True
    elif original_style=='Heading 3':
        p.style=doc.styles['Heading 2']
        for r in p.runs:r.bold=True
# Structured abstract uses bold inline labels, leaving room for all five parts
# on its separate page without changing the required double spacing.
format_abstract(doc)
# Actual generated counts on title page.
anchor=next(p for p in doc.paragraphs if p.text.startswith('Keywords:'))
countp=OxmlElement('w:p');anchor._p.addnext(countp)
from docx.text.paragraph import Paragraph
Paragraph(countp,doc._body).add_run(f'Word counts: main text {main_words}; structured abstract {abstract_words}.')
# Insert complete editable native gt table blocks immediately after first citation.
for i in range(1,metadata.MAIN_TABLE_COUNT+1):
    anchor=next(p for p in doc.paragraphs if re.search(rf'\bTable {i}\b',p.text))
    anchor.paragraph_format.keep_together=True
    anchor.paragraph_format.keep_with_next=False
    table_doc=Document(OUT/f'Table{i}.docx')
    for element in table_doc.element.body:
        if element.tag==qn('w:sectPr'):continue
        copied=deepcopy(element)
        if copied.tag==qn('w:p'):
            p=Paragraph(copied,doc._body)
            p.paragraph_format.line_spacing=1
            if p.text.startswith('Table '):
                p.style=doc.styles['Heading 2']
                p.paragraph_format.keep_with_next=True
                p.paragraph_format.page_break_before=False
                p.paragraph_format.space_after=Pt(4)
                for run in p.runs:run.bold=True
        if copied.tag==qn('w:tbl'):
            if i==3:
                # Reserve a clear gutter for the long image-region label.
                for cell in copied.xpath('./w:tr/w:tc[1]'):
                    if ''.join(cell.xpath('.//w:t/text()'))=='Image regions linked to their page':
                        cell.xpath('./w:tcPr/w:tcMar/w:end')[0].set(qn('w:w'),'900')
            # Table cells must not inherit double spacing from manuscript prose.
            for cellp in copied.xpath('.//w:p'):
                paragraph=Paragraph(cellp,doc._body)
                paragraph.paragraph_format.line_spacing=1
                paragraph.paragraph_format.space_before=Pt(0)
                paragraph.paragraph_format.space_after=Pt(0)
                paragraph.paragraph_format.keep_with_next=True
            for cellp in copied.xpath('./w:tr[last()]//w:p'):
                Paragraph(cellp,doc._body).paragraph_format.keep_with_next=False
        anchor._p.addnext(copied)
        anchor=Paragraph(copied,doc._body)  # XML sibling insertion only
# All five main legends, with explicit alt text, at manuscript end.
doc.add_heading('FIGURE LEGENDS',level=1).paragraph_format.page_break_before=True
spec = importlib.util.spec_from_file_location('manuscript_sources', ROOT/'scripts/manuscript-sources.py')
metadata = importlib.util.module_from_spec(spec); spec.loader.exec_module(metadata)
for j, (caption, alt) in enumerate(metadata.main_legends((OUT/'figure-legends.md').read_text(encoding='utf-8'))):
    cap=doc.add_paragraph(caption)
    cap.paragraph_format.page_break_before=bool(j)
    cap.paragraph_format.keep_together=True
    cap.paragraph_format.keep_with_next=True
    altp=doc.add_paragraph('Alt text: '+alt)
    altp.paragraph_format.keep_together=True
    if j == 1:
        for label, url in metadata.WORKED_EXAMPLE_LINKS:
            paragraph = doc.add_paragraph()
            link = OxmlElement('w:hyperlink')
            link.set(qn('r:id'), paragraph.part.relate_to(url,
                     'http://schemas.openxmlformats.org/officeDocument/2006/relationships/hyperlink', is_external=True))
            run = OxmlElement('w:r')
            content = OxmlElement('w:t')
            content.text = label
            run.append(content)
            link.append(run)
            paragraph._p.append(link)
bookkeep(doc);doc.save(path)
# Fail at the assembly boundary if any embedded table is stale or altered.
# Whitespace/run layout may differ, but every cell and note must match.
def table_text(table):
    return [' '.join(cell.text.split()) for row in table.rows for cell in row.cells]
assembled = Document(path)
assert len(assembled.tables) == metadata.MAIN_TABLE_COUNT
for i, embedded in enumerate(assembled.tables, 1):
    standalone = Document(OUT/f'Table{i}.docx')
    assert len(standalone.tables) == 1
    assert table_text(embedded) == table_text(standalone.tables[0]), f'Table {i}: embedded text differs'
# All six production documents use printed pagination and stable heading bookmarks.
for name in ([] if '--main-only' in sys.argv else ['Table1','Table2','Table3','Supplement','TRIPOD-LLM']):
    path=OUT/f'{name}.docx';doc=Document(path)
    if name=='Supplement':
        assert not doc.inline_shapes, 'The compact supplement has no supplementary figures'
        for p in doc.paragraphs:
            if not p.style.name.lower().startswith('heading'):
                p.paragraph_format.line_spacing=1.3
                p.paragraph_format.space_after=Pt(4)
    bookkeep(doc);doc.save(path)
print(f'Manuscript assembled: 3 native gt tables; 5 legends and alt texts; {main_words} main words; {abstract_words} abstract words.')
