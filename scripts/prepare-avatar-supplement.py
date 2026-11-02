"""Package the supplied AVATAR report without changing its assessment content."""
from pathlib import Path
import hashlib
import json
import re

from lxml import html

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / 'analysis/data-curated/banovic26-avatar-2024-source.html'
TARGET = ROOT / 'analysis/output/manuscript/banovic26-avatar-2024.html'

original = SOURCE.read_bytes()
assert original.count(b'href="../index.html"') == 1
packaged = original.replace(b'href="../index.html"', b'href="#"')
assert packaged.replace(b'href="#"', b'href="../index.html"', 1) == original
before, after = html.fromstring(original), html.fromstring(packaged)
assert before.text_content() == after.text_content()
assert not after.xpath('//script|//link[@rel="stylesheet"]')
assert not re.search(rb'@import|url\(', packaged, re.I)
for element in after.xpath('//*[@src or @href]'):
    for attribute in ('src', 'href'):
        value = element.get(attribute)
        if value:
            assert value.startswith(('data:', '#', 'https://')), (element.tag, attribute, value)
TARGET.write_bytes(packaged)
record = {'source': str(SOURCE.relative_to(ROOT)), 'output': str(TARGET.relative_to(ROOT)),
          'source_sha256': hashlib.sha256(original).hexdigest(),
          'output_sha256': hashlib.sha256(packaged).hexdigest(),
          'only_change': 'Batch-index brand link now returns to the top of this report.',
          'assessment_text_unchanged': True, 'no_external_rendering_dependencies': True}
(ROOT / 'analysis/provenance/avatar-html-supplement.json').write_text(json.dumps(record, indent=2) + '\n')
print('PASS: standalone AVATAR HTML prepared; assessment text and embedded evidence unchanged.')
