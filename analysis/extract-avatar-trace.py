# Extract the illustrative trial once; reports never need the gitignored logs.
import csv,json,re,zipfile
from pathlib import Path
root=Path(__file__).resolve().parent
repo=root.parent
slug='banovic26-avatar-2024'
with zipfile.ZipFile(repo/f'kit-sonnet-5.5/bundles/{slug}.rob2.zip') as z:
    bundle=json.loads(z.read('canonical.json'))
text=(repo/f'no-kit-sonnet-5.5/logs/{slug}/final.md').read_text(encoding='utf-8')
rationales=dict(re.findall(r'^- \*\*(D[1-5]):\*\* (.*)$',text,re.M))
assert len(rationales)==5
(root/'data-derived/avatar-unassisted-rationale.json').write_text(json.dumps(rationales,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
# Retain the relevant canonical payload to make extraction independently auditable.
projection={k:bundle[k] for k in ('domain_records','proposal','snapshots','batch')}
(root/'data-derived/avatar-trace.json').write_text(json.dumps(projection,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
