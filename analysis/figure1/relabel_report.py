"""Product-name-only copy of the exact run-build report; byte-level diff proof."""
import difflib,hashlib,json
from pathlib import Path
HERE=Path(__file__).resolve().parent
SUBSTITUTIONS=[('rob2-kit','ARBITER'),('rob2 kit','ARBITER'),('Rob2-kit','ARBITER'),('Rob2 kit','ARBITER'),('rob2 verify','arbiter verify'),('rob2 report','arbiter report'),('rob2 review','arbiter review'),('.rob2.zip','.arbiter.zip')]
def main():
    raw=HERE/'html-report/raw';out=HERE/'html-report/relabelled';proof=[];diff=[]
    for path in sorted(raw.rglob('*')):
        if not path.is_file():continue
        original=path.read_bytes();text=original.decode('utf8');renamed=text;counts=[]
        for before,after in SUBSTITUTIONS:
            n=renamed.count(before);renamed=renamed.replace(before,after)
            counts.append((before,after,n,text.count(before),renamed.count(before),text.count(after),renamed.count(after)))
        target=out/path.relative_to(raw);target.parent.mkdir(parents=True,exist_ok=True);target.write_bytes(renamed.encode('utf8'))
        # Replay exact substitutions: equality proves no other bytes changed.
        expected=original
        for before,after in SUBSTITUTIONS:expected=expected.replace(before.encode(),after.encode())
        assert expected==target.read_bytes()
        proof.extend([f'## {path.relative_to(raw).as_posix()}','',f'Raw SHA-256: `{hashlib.sha256(original).hexdigest()}`',f'Relabelled SHA-256: `{hashlib.sha256(expected).hexdigest()}`','', '| Before | After | Replacements | Before-string raw / copy | After-string raw / copy |','|---|---|---:|---:|---:|'])
        for before,after,n,br,bc,ar,ac in counts:proof.append(f'| `{before}` | `{after}` | {n} | {br} / {bc} | {ar} / {ac} |')
        diff.extend(difflib.unified_diff(text.splitlines(True),renamed.splitlines(True),fromfile='raw/'+path.relative_to(raw).as_posix(),tofile='relabelled/'+path.relative_to(raw).as_posix()))
    (HERE/'qa/html-report-relabel.diff').write_text(''.join(diff),encoding='utf8')
    (HERE/'qa/html-report-relabel.md').write_text('\n'.join(['# Exact run-build HTML report and product relabel','', 'Run build: rob2-kit commit `2848c7926a2acc25402345a42be39d695a99861a`, version 0.13.0; installed non-editably into `%TEMP%/arbiter-avatar-2848c79` with `uv venv` and `uv pip install --python <venv>/Scripts/python.exe C:/Users/Ali-Salman/Documents/Code/rob2-kit playwright`. No source changes.', '', '`<venv>/Scripts/rob2.exe report kit-sonnet-5.5/bundles/banovic26-avatar-2024.rob2.zip --output analysis/figure1/html-report/raw` succeeded. Both original HTML files are retained.','', 'Only literal product names/CLI names/extensions are replaced in the copy, in the order below. RoB 2 (the instrument), source quotations, decisions, numbers, CSS and layout are unchanged. The original build version remains 0.13.0. Each file is asserted byte-equal to replaying exactly this substitution list. The full unified diff is [html-report-relabel.diff](html-report-relabel.diff).','',*proof,'']),encoding='utf8')
if __name__=='__main__':main()
