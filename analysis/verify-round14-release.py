#!/usr/bin/env python3
"""Scan actual publication artifacts, including compressed Word and PDF text."""
from pathlib import Path
import re, subprocess, zipfile, xml.etree.ElementTree as ET
root=Path(__file__).resolve().parent
findings=[]; scanned=0
for directory in ['output/manuscript','output/tables','output/figures']:
 for p in (root/directory).rglob('*'):
  if not p.is_file(): continue
  if p.suffix=='.docx':
   with zipfile.ZipFile(p) as z:
    text=' '.join(ET.fromstring(z.read('word/document.xml')).itertext())
  elif p.suffix=='.pdf': text=subprocess.check_output(['pdftotext',str(p),'-']).decode(errors='replace')
  elif p.suffix.lower() in ['.txt','.md','.csv','.json','.html','.svg']: text=p.read_text(errors='replace')
  else: continue
  scanned+=1
  if re.search('haiku',text,re.I): findings.append(str(p.relative_to(root)))
for name in ['results.html','supplement.html','README.md']:
 p=root/name
 if p.exists():
  scanned+=1
  if re.search('haiku',p.read_text(),re.I): findings.append(name)
print(f'Scanned {scanned} text, Word and PDF publication artifacts; Haiku matches: {len(findings)}')
for p in findings: print(p)
raise SystemExit(bool(findings))
