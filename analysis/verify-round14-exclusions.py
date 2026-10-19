#!/usr/bin/env python3
"""Inventory unreported-model paths and nonpublication references for release curation."""
from pathlib import Path
import subprocess
root=Path(__file__).resolve().parent.parent
paths=set()
for p in root.rglob('*'):
 if '.git' in p.parts or not p.is_file(): continue
 rel=p.relative_to(root).as_posix()
 if 'haiku' in rel.lower(): paths.add(rel)
# Include historical/planning/code references, including new untracked reports.
for base in ['analysis','docs']:
 for p in (root/base).rglob('*'):
  if not p.is_file() or p.suffix not in ['.R','.py','.md','.qmd','.txt','.json','.csv','.yml','.yaml','.log']: continue
  if any(part in ['renv','__pycache__'] for part in p.parts): continue
  if 'haiku' in p.read_text(errors='ignore').lower(): paths.add(p.relative_to(root).as_posix())
tracked=subprocess.run(['git','grep','-Iil','-e','Haiku'],cwd=root,text=True,capture_output=True)
paths.update(tracked.stdout.splitlines())
for name in ['ANALYSIS-PLAN.md','GLOSSARY.md']:
 if 'haiku' in (root/name).read_text().lower(): paths.add(name)
paths.add('analysis/round14-public-release-exclusions.txt')
out=root/'analysis/round14-public-release-exclusions.txt'
out.write_text('Public-release exclusions: unreported model paths and internal/historical references.\n'
 'Raw arm trees remain read-only; exclude these files from a Sonnet-only public release.\n'
 'The following list is exhaustive for model-named paths and all tracked text references and new analysis/docs text references.\n\n'+'\n'.join(sorted(paths))+'\n')
print(f'{len(paths)} paths written to {out}')
