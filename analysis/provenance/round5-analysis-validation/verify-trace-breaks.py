import csv,json,re,zipfile
from pathlib import Path
from lxml import etree
root=Path(__file__).parent/'analysis'
with zipfile.ZipFile(root/'output/manuscript/Supplement.docx') as z: xml=etree.fromstring(z.read('word/document.xml'))
ns={'w':'http://schemas.openxmlformats.org/wordprocessingml/2006/main'}
norm=lambda s:re.sub(r'\s+',' ',s)
def txt(p,breaks):
 return ''.join((' ' if etree.QName(n).localname in ('br','cr','tab') else n.text or '') for n in p.xpath('.//w:t|.//w:br|.//w:cr|.//w:tab',namespaces=ns)) if breaks else ''.join(p.itertext())
old=norm(' '.join(txt(p,False) for p in xml.xpath('//w:p',namespaces=ns)))
new=norm(' '.join(txt(p,True) for p in xml.xpath('//w:p',namespaces=ns)))
rows=[]
for name in ('avatar-trace-answers.csv','avatar-trace-evidence.csv'):
 for i,row in enumerate(csv.DictReader((root/'output/tables'/name).open()),2):
  for key,value in row.items():
   if value and norm(value) not in old:
    rows.append({'file':name,'row':i,'column':key,'length':len(value),'present_with_breaks':norm(value) in new})
result={'missing_under_old_extractor':len(rows),'restored_with_breaks':sum(r['present_with_breaks'] for r in rows),'rows':rows}
print(json.dumps(result,indent=2))
for rownum in (5,10,12,13):
 row=list(csv.DictReader((root/'output/tables/avatar-trace-evidence.csv').open()))[rownum-2]
 value=norm(row['Full verbatim quote']); start=new.find(value[:50]); print('row',rownum,'prefix_position',start)
 if start>=0:
  observed=new[start:start+len(value)]
  first=next((i for i,(a,b) in enumerate(zip(value,observed)) if a!=b),None)
  if first is not None: print('first difference',first,repr(value[max(0,first-25):first+35]),repr(observed[max(0,first-25):first+35]),'codepoints',ord(value[first]),ord(observed[first]))
