"""Reproduce the authorized Figure 3 wording repair without rerunning analyses."""
from pathlib import Path
import hashlib
import json
import re
import shutil
import subprocess
import tempfile
from PIL import Image
from pypdf import PdfReader, PdfWriter
from pypdf.generic import ContentStream, FloatObject, TextStringObject

ROOT = Path(__file__).resolve().parents[3]
BASE = '343febaecae7ba506f8f520a7a5524c5ba154555'
REL = 'analysis/output/manuscript/Figure3.pdf'
REPLACEMENTS = {
    'Same Sonnet model; one run per arm': 'Same model identifier; one run per arm',
    'Conditional primary endpoint: 80 cells': 'Conditional label choice: 80 cells',
    '53 favor ARBITER': '53 match ARBITER',
}

with tempfile.TemporaryDirectory(prefix='arbiter-flow-labels-') as folder:
    folder = Path(folder)
    before = subprocess.check_output(['git', 'show', f'{BASE}:{REL}'], cwd=ROOT)
    source = folder / 'original.pdf'
    source.write_bytes(before)
    reader = PdfReader(source)
    page = reader.pages[0]
    content = ContentStream(page.get_contents(), reader)
    ops, seen = [], []
    font, size = None, None
    for args, operator in content.operations:
        if operator == b'Tf':
            font = page['/Resources']['/Font'][args[0]].get_object()
            size = float(args[1])
        if operator == b'Tj' and str(args[0]) in REPLACEMENTS:
            old, new = str(args[0]), REPLACEMENTS[str(args[0])]
            first, widths = int(font['/FirstChar']), font['/Widths']
            def width(text):
                values = [float(widths[ord(c) - first]) for c in text]
                assert all(v > 0 for v in values), 'Replacement requires absent subset glyph'
                return sum(values) * size / 1000
            dx = (width(old) - width(new)) / 2
            ops += [([FloatObject(dx), FloatObject(0)], b'Td'),
                    ([TextStringObject(new)], b'Tj'),
                    ([FloatObject(-dx), FloatObject(0)], b'Td')]
            seen.append(old)
        else:
            ops.append((args, operator))
    assert set(seen) == set(REPLACEMENTS) and len(seen) == 3
    content.operations = ops
    page.replace_contents(content)
    writer = PdfWriter()
    writer.add_page(page)
    target = ROOT / REL
    with target.open('wb') as stream:
        writer.write(stream)
    after_text = PdfReader(target).pages[0].extract_text()
    before_text = reader.pages[0].extract_text()
    for old, new in REPLACEMENTS.items():
        assert new in after_text and old not in after_text
    original_text = PdfReader(source).pages[0].extract_text()
    expected = original_text
    for old, new in REPLACEMENTS.items():
        expected = expected.replace(old, new)
    assert after_text.split() == expected.split(), 'Unexpected figure text change'
    assert re.findall(r'\d+(?:\.\d+)?', original_text) == re.findall(r'\d+(?:\.\d+)?', after_text)
    for ext, dimensions, dpi in [('png', (1096, 944), 160), ('tiff', (4110, 3543), 600)]:
        out = folder / ext
        subprocess.run(['pdftoppm', '-singlefile', '-png', '-scale-to-x', str(dimensions[0]),
                        '-scale-to-y', str(dimensions[1]), str(target), str(out)], check=True,
                       stdout=subprocess.DEVNULL, stderr=subprocess.PIPE)
        with Image.open(out.with_suffix('.png')) as im:
            assert im.size == dimensions
            kwargs = {'dpi': (dpi, dpi)}
            if ext == 'tiff': kwargs['compression'] = 'tiff_lzw'
            im.save(target.with_suffix('.' + ext), **kwargs)
    for ext in ['pdf', 'png']:
        shutil.copyfile(target.with_suffix('.' + ext), ROOT / f'analysis/output/figures/figure3.{ext}')
    report = {'baseline_commit': BASE, 'baseline_pdf_sha256': hashlib.sha256(before).hexdigest(),
              'changes': REPLACEMENTS, 'numeric_text_unchanged': True,
              'vector_operations': 'All original nontext drawing operations retained; only three text strings and local centering offsets changed.',
              'raster_note': 'PNG/TIFF rerendered from vector PDF at original pixel dimensions; raster bytes differ.'}
    (ROOT / 'docs/manuscript-development/round5/flow-label-repair.json').write_text(json.dumps(report, indent=2) + '\n')
    print('PASS: three Figure 3 labels repaired; numerical text and original drawing operations preserved.')
