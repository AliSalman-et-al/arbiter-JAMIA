"""Rebuild twice and compare the actual deliverables and diagnostic proofs."""
import argparse,hashlib,json,re,subprocess,sys
from pathlib import Path
HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[1]
OUT=ROOT/'analysis/output/manuscript'

def check_legends(path=OUT/'legends-fig1-2.md'):
    text=path.read_text(encoding='utf8')
    forbidden=re.search(r'rob2|2848c79|0\.13\.0|relabel|sha256|render|crop',text,re.IGNORECASE)
    assert forbidden is None, f'Production detail in legends: {forbidden.group()}'
    sections=re.split(r'(?m)^\*\*Figure ([12])\. ',text)
    assert sections[1::2]==['1','2'], 'Expected exactly Figures 1 and 2'
    counts={}
    for number,section in zip(sections[1::2],sections[2::2]):
        parts=section.split('Alt text:')
        assert len(parts)==2, f'Figure {number}: expected one alt text'
        legend,alt=parts
        # Include title words; exclude the figure number and Markdown markers.
        legend_words=len(legend.replace('**','').split())
        alt_words=len(alt.split())
        assert legend_words<=140, f'Figure {number}: legend has {legend_words} words (limit 140)'
        assert alt_words<=90, f'Figure {number}: alt text has {alt_words} words (limit 90)'
        counts[number]=dict(legend=legend_words,alt_text=alt_words)
    print('Legend word counts:',json.dumps(counts))
    return counts

def files():
    paths=[*OUT.glob('Figure1.*'),*OUT.glob('Figure2.*'),OUT/'figure1-notes.md',HERE/'qa.json',HERE/'save-rejections.csv',HERE/'save-rejections-summary.json',HERE/'avatar-save-retry.json']
    for n in [1,2]:
        paths.extend(OUT/'qa'/f'Figure{n}-{suffix}.png' for suffix in ['final-size','grayscale','deuteranopia','protanopia','tritanopia','pdf'])
    paths.append(HERE/'avatar-tool-counts.json')
    paths.append(HERE/'figure2-text-provenance.csv')
    paths.extend(sorted((HERE/'html-report').rglob('*.html')))
    paths.extend(HERE/'qa'/n for n in ['html-report-relabel.md','html-report-relabel.diff','avatar-html-report.png','avatar-html-report-table.png','avatar-html-report-domain-view.png','avatar-html-report-domain-view.json'])
    paths.append(OUT/'legends-fig1-2.md')
    return sorted(paths)

def hashes():
    return {p.relative_to(ROOT).as_posix():hashlib.sha256(p.read_bytes()).hexdigest() for p in files()}

def main():
    p=argparse.ArgumentParser();p.add_argument('--data-root',type=Path,required=True);p.add_argument('--logs-root',type=Path,required=True);p.add_argument('--arbiter-root',type=Path,required=True);args=p.parse_args()
    check_legends()
    subprocess.run([sys.executable,'-m','unittest','discover','-s',str(HERE),'-p','test_geometry.py'],check=True)
    command=[sys.executable,str(HERE/'build.py'),'--data-root',str(args.data_root),'--arbiter-root',str(args.arbiter_root),'--logs-root',str(args.logs_root)]
    subprocess.run(command,check=True);first=hashes()
    subprocess.run(command,check=True);second=hashes()
    changed=[k for k in first if first[k]!=second.get(k)]
    assert first.keys()==second.keys() and not changed,changed
    report=dict(two_builds_identical=True,files_checked=len(first),sha256=second)
    (HERE/'reproducibility.json').write_text(json.dumps(report,indent=2)+'\n')
    print(f'{len(first)} artifacts byte-identical across two builds.')
if __name__=='__main__':main()
