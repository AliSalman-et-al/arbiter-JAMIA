"""Rebuild twice and compare the actual deliverables and diagnostic proofs."""
import argparse,hashlib,json,subprocess,sys
from pathlib import Path
HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[1]
OUT=ROOT/'analysis/output/manuscript'

def files():
    paths=[*OUT.glob('Figure1.*'),*OUT.glob('Figure2.*'),OUT/'figure1-notes.md',HERE/'qa.json',HERE/'save-rejections.csv',HERE/'save-rejections-summary.json',HERE/'avatar-save-retry.json']
    for n in [1,2]:
        paths.extend(OUT/'qa'/f'Figure{n}-{suffix}.png' for suffix in ['final-size','grayscale','deuteranopia','protanopia','tritanopia','pdf'])
    paths.extend((OUT/'qa').glob('Figure2-without-unassisted.*'))
    paths.append(OUT/'qa/Figure2-without-unassisted-pdf.png')
    paths.extend(OUT/'qa'/f'Figure2-without-unassisted-{suffix}.png' for suffix in ['final-size','grayscale','deuteranopia','protanopia','tritanopia'])
    paths.append(OUT/'legends-fig1-2.md')
    return sorted(paths)

def hashes():
    return {p.relative_to(ROOT).as_posix():hashlib.sha256(p.read_bytes()).hexdigest() for p in files()}

def main():
    p=argparse.ArgumentParser();p.add_argument('--data-root',type=Path,required=True);p.add_argument('--arbiter-root',type=Path,required=True);args=p.parse_args()
    subprocess.run([sys.executable,'-m','unittest','discover','-s',str(HERE),'-p','test_geometry.py'],check=True)
    command=[sys.executable,str(HERE/'build.py'),'--data-root',str(args.data_root),'--arbiter-root',str(args.arbiter_root)]
    subprocess.run(command,check=True,capture_output=True);first=hashes()
    subprocess.run(command,check=True,capture_output=True);second=hashes()
    changed=[k for k in first if first[k]!=second.get(k)]
    assert first.keys()==second.keys() and not changed,changed
    report=dict(two_builds_identical=True,files_checked=len(first),sha256=second)
    (HERE/'reproducibility.json').write_text(json.dumps(report,indent=2)+'\n')
    print(f'{len(first)} artifacts byte-identical across two builds.')
if __name__=='__main__':main()
