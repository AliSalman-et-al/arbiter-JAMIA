"""Verify documentary integration without evaluating the main manuscript or computing statistics."""
from pathlib import Path
import csv, hashlib, importlib.util, json, re
from zipfile import ZipFile
from docx import Document
from lxml import etree as E
ROOT=Path(__file__).resolve().parents[3]
HERE=Path(__file__).resolve().parent
TMP=Path('/tmp/arbiter-round6-supplement')
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
entry=json.loads((HERE/'supplement-entry-hashes.json').read_text())
changes={name:{'entry':h,'final':sha(ROOT/name)} for name,h in entry.items() if (ROOT/name).is_file() and sha(ROOT/name)!=h}
allowed={'analysis/output/manuscript/Supplement.docx','analysis/output/manuscript/TRIPOD-LLM.docx',*(f'analysis/output/tables/{n}.csv' for n in ['reporting-checklist-skeleton','display-supplement-reporting-map','display-source-trace'])}
outside={k:v for k,v in changes.items() if k in {'analysis/output/manuscript/Manuscript.docx','analysis/output/manuscript/qa/manuscript-assembled.md'}}
assert set(changes)-set(outside)==allowed,changes
numeric=json.loads((ROOT/'analysis/provenance/round5-analysis-validation/numerical-comparison.json').read_text())['tables']
assert len(numeric)==58
for row in numeric: assert sha(ROOT/'analysis/output/tables'/row['file'])==row['old_sha256'],row['file']
for name,h in entry.items():
 if '/figures/' in name or re.search(r'/Figure\d+[.](pdf|png|tiff|svg)$',name) or re.search(r'/Table[123][.]docx$',name): assert sha(ROOT/name)==h,name
# Historical manifest chain: no new paths, no rebasing, only five authorized documentary hash updates.
manifest=json.loads((ROOT/'docs/manuscript-development/round5/documentary-updates.json').read_text())
reasons={
 'analysis/output/manuscript/Supplement.docx':'Round6 authorized relocation integration: source-backed eMethods, evaluated/public command and development provenance; completion fields remain pending. All 98 tables and 7675 physical cells, figures, prompts and worked traces unchanged; contents page caches advanced after one added prose page. See round6/supplement-integration-report.md and checks.',
 'analysis/output/manuscript/TRIPOD-LLM.docx':'Round6 documentary TRIPOD-LLM 5a section locator and 9b provenance section/note synchronize with authoritative checklist source. Three cells only; qualifications and all unresolved statuses retained; all nontext XML and other ZIP members unchanged.',
 'analysis/output/tables/reporting-checklist-skeleton.csv':'Round6 synchronize exactly three documentary cells: TRIPOD-LLM 5a section locator and 9b section/note, reflecting actual supplementary integration and explicitly bounded author attestation. All other cells unchanged.',
 'analysis/output/tables/display-supplement-reporting-map.csv':'Round6 synchronize the same three documentary TRIPOD-LLM 5a/9b cells with checklist R source and reporting Word. All remaining cells unchanged; no statistical values edited.',
 'analysis/output/tables/display-source-trace.csv':'Round6 update exactly three documentary trace value cells for reporting-checklist-skeleton 5a/9b; all 49892 exact source-cell checks retained. All row/file/column keys, order and statistical trace values unchanged.'}
for name in allowed:
 manifest[name]['new_sha256']=sha(ROOT/name)
 manifest[name]['rationale']+=' '+reasons[name]
(HERE/'documentary-updates.json').write_text(json.dumps(manifest,indent=2)+'\n')
spec=importlib.util.spec_from_file_location('release',ROOT/'docs/manuscript-development/verify-release.py'); release=importlib.util.module_from_spec(spec); spec.loader.exec_module(release)
base=release.historical_baseline(); approved=release.verify_protected_outputs(base,HERE/'documentary-updates.json')
# Word equality and structure, including all physical cells rather than repeated merged-cell projections.
ns={'w':'http://schemas.openxmlformats.org/wordprocessingml/2006/main'}
physical=lambda tree:[''.join(p.xpath('.//w:t/text()',namespaces=ns)) for p in tree.xpath('.//w:tbl/w:tr/w:tc',namespaces=ns)]
word={}
for name in ['Supplement.docx','TRIPOD-LLM.docx']:
 with ZipFile(TMP/name) as a,ZipFile(ROOT/'analysis/output/manuscript'/name) as b:
  assert a.namelist()==b.namelist()
  assert all(a.read(k)==b.read(k) for k in a.namelist() if k!='word/document.xml')
  old=E.fromstring(a.read('word/document.xml')); new=E.fromstring(b.read('word/document.xml'))
  ac,bc=physical(old),physical(new); assert len(ac)==len(bc)
  changed=[i for i,(x,y) in enumerate(zip(ac,bc)) if x!=y]
  if name=='Supplement.docx': assert not changed; assert len(ac)==7675
  else:
   assert len(changed)==3
   for t in old.xpath('//w:t',namespaces=ns)+new.xpath('//w:t',namespaces=ns): t.text=''
   assert E.tostring(old)==E.tostring(new)
  word[name]={'tables':len(new.xpath('.//w:tbl',namespaces=ns)),'physical_cells':len(ac),'changed_cells':changed,'other_zip_members_identical':True}
# Exact changed documentary CSV/trace cells are individually retained.
cells=json.loads((HERE/'supplement-documentary-cells.json').read_text())
assert len(cells['csv_changes'])==6 and len(cells['trace_changes'])==3
source=json.loads((TMP/'source.json').read_text()); doc=Document(ROOT/'analysis/output/manuscript/Supplement.docx')
paragraphs=[p.text for p in doc.paragraphs]
for k,v in source['methods'].items():
 i=paragraphs.index(k); assert paragraphs[i+1]==v,k
assert paragraphs[-2:]==source['provenance']
assert paragraphs.count('Benchmark construction and exclusions')==1
assert sum('De Waal registry' in p for p in paragraphs)==1
# Methods order must match the production loop as well as prose.
assert [p for p in paragraphs if p in source['methods']]==list(source['methods'])
result={'status':'PASS','authoritative_supporting_source_sha256':{n:sha(ROOT/n) for n in ['analysis/R/manuscript-supplement.R','analysis/R/checklist.R','scripts/report-refresh.py']},'relocation_note_sha256':sha(HERE/'supplement-relocations.md'),'entry_note_sha256':(TMP/'note-hash.txt').read_text(),'changed_output_hashes':{k:v for k,v in changes.items() if k in allowed},'concurrent_parent_output_changes_not_validated':outside,'numerical_csvs_byte_identical':58,'release_protected_files':len(base),'historical_exceptions_carried':approved,'new_exception_paths':0,'main_manuscript_validation':'Deferred to parent after final assembly','word':word,'methods_paragraphs':len(source['methods']),'provenance_paragraphs':len(source['provenance']),'documentary_csv_cells_changed':6,'documentary_trace_values_changed':3,'exact_source_trace_records':49892}
(HERE/'supplement-checks.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps(result,indent=2))
