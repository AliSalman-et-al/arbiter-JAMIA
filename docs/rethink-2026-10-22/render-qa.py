"""Read-only page QA of PDFs exported by installed Word; managed Python runtime."""
from pathlib import Path
import csv
import subprocess
import xml.etree.ElementTree as ET
from PIL import Image, ImageDraw
from pdf2image import convert_from_path

ROOT = Path(__file__).resolve().parents[2]
QA = Path(__file__).with_name('rendered')
POPPLER = Path.home()/'.cache/codex-runtimes/codex-primary-runtime/dependencies/native/poppler/Library/bin'
records = []
for name in ['Table1', 'Table2', 'Table3', 'Manuscript', 'Supplement', 'TRIPOD-LLM']:
    pdf = QA/f'{name}.pdf'
    folder = QA/name
    folder.mkdir(exist_ok=True)
    for old in list(folder.glob('page*.png')) + list(folder.glob('contact-*.jpg')):
        old.unlink()
    pages = convert_from_path(str(pdf), dpi=105, output_folder=str(folder), fmt='png',
                              output_file='page', paths_only=True, poppler_path=str(POPPLER))
    bbox = ET.fromstring(subprocess.check_output(['C:/Program Files/Calibre2/app/bin/pdftotext.exe', '-bbox', str(pdf), '-']))
    ns = {'x': 'http://www.w3.org/1999/xhtml'}
    for i, page in enumerate(bbox.findall('.//x:page', ns), 1):
        words = page.findall('x:word', ns)
        width, height = float(page.get('width')), float(page.get('height'))
        outside = [w for w in words if float(w.get('xMin')) < 0 or float(w.get('yMin')) < 0
                   or float(w.get('xMax')) > width or float(w.get('yMax')) > height]
        records.append(dict(document=name, page=i, words=len(words), outside_page=len(outside)))
    for start in range(0, len(pages), 9):
        canvas = Image.new('RGB', (1800, 2550), '#e4e4e4')
        draw = ImageDraw.Draw(canvas)
        for j, path in enumerate(pages[start:start+9]):
            im = Image.open(path).convert('RGB')
            im.thumbnail((590, 820))
            x, y = j % 3 * 600, j // 3 * 850
            canvas.paste(im, (x + (600-im.width)//2, y+25))
            draw.text((x+8, y+5), f'{name} page {start+j+1}', fill='black')
        canvas.save(folder/f'contact-{start+1:03}.jpg', quality=92)
    print(f'{name}: {len(pages)} pages rendered', flush=True)
with (QA/'page-checks.csv').open('w', newline='') as handle:
    writer = csv.DictWriter(handle, fieldnames=records[0])
    writer.writeheader()
    writer.writerows(records)
assert not any(row['outside_page'] or not row['words'] for row in records), 'Outside-page text or empty page'
print(f'PASS: {len(records)} pages; no empty pages or text outside page bounds')
