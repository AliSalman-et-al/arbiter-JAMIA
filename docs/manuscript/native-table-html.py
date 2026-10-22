"""Replace Word-converted tables with native gt HTML from the same objects."""
from pathlib import Path
from lxml import html,etree
import re
ROOT=Path(__file__).resolve().parents[2]
QA=ROOT/'analysis/output/manuscript/qa'
root=html.fragment_fromstring((QA/'supplement-body.html').read_text(encoding='utf-8'),create_parent='div')
tables=root.xpath('.//table')
native=(QA/'supplement-gt.html').read_text(encoding='utf-8').split('\n<!--GT_TABLE_BOUNDARY-->\n')
assert len(tables)==len(native),(len(tables),len(native))
for old,raw in zip(tables,native):
    replacement=html.fragment_fromstring(raw,create_parent='div')
    for table in replacement.xpath('.//table'):
        table.set('data-quarto-disable-processing','true')
    old.getparent().replace(old,replacement)
for h in root.xpath('.//h1|.//p[contains(@class,"heading")]'):
    if ' '.join(h.text_content().split())=='ARBITER supplementary methods and results':h.getparent().remove(h)
# Word's evaluated page-linked contents is replaced by HTML's own anchors.
contents=next(p for p in root.xpath('.//p|.//h2') if ' '.join(p.text_content().split())=='Contents and stable display locators')
next_node=contents.getnext()
while next_node is not None and ' '.join(next_node.text_content().split())!='Algorithms and validation':
    following=next_node.getnext();next_node.getparent().remove(next_node);next_node=following
# Pandoc preserves custom Word headings as p.heading after Word normalizes the
# style names. Restore semantic headings using that explicit style metadata.
for p in root.xpath('.//p[contains(@class,"heading")]'):
    title=' '.join(p.text_content().split())
    p.tag='h1' if re.match(r'^[1-7]\. |^AVATAR complete trace$|^Prompt templates and run provenance$',title) else 'h2'
headers=root.xpath('.//h1|.//h2|.//h3')
nav=html.Element('details');summary=etree.SubElement(nav,'summary')
summary.text='Contents and stable display locators'
listing=etree.SubElement(nav,'ul');seen={};before_results=True
for h in headers:
    title=' '.join(h.text_content().split())
    if title=='Contents and stable display locators':
        h.getparent().replace(h,nav)
        continue
    slug='supp-'+re.sub(r'[^a-z0-9]+','-',title.lower()).strip('-')
    seen[slug]=seen.get(slug,0)+1
    h.set('id',slug+(f'-{seen[slug]}' if seen[slug]>1 else ''))
    original=h.tag
    h.tag='h'+str(min(6,int(original[1])+1))
    if re.match(r'^1\. ',title):before_results=False
    if title=='Prompt templates and run provenance':h.tag='h2'
    selected=before_results or bool(re.match(r'^(eTable \d|eFigure [1-5]|[1-7]\. |AVATAR complete trace$|Prompt templates and run provenance$)',title))
    if selected and '(continued ' not in title:
        item=etree.SubElement(listing,'li');link=etree.SubElement(item,'a',href='#'+h.get('id'));link.text=title
for prefix,label in [('Algorithms and validation','Supplementary methods'),('eFigure 1.','Supplementary figures')]:
    target=next(h for h in root.xpath('.//h2|.//h3|.//h4') if ' '.join(h.text_content().split()).startswith(prefix))
    heading=html.Element('h2');heading.text=label;target.addprevious(heading)
(QA/'supplement-native.html').write_text(html.tostring(root,encoding='unicode'),encoding='utf-8')
