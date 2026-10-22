from pathlib import Path
import csv,json
OUT=Path(__file__).resolve().parent
def write(name,data):
 with (OUT/name).open('w',encoding='utf-8-sig',newline='') as f:
  w=csv.DictWriter(f,fieldnames=list(data[0]));w.writeheader();w.writerows(data)
with (OUT/'supplement-mapping.csv').open(encoding='utf-8-sig') as f:specs=list(csv.DictReader(f))
ranges={1:(5,6),2:(7,14),3:(17,17),4:(18,18),5:(19,24),6:(25,26),7:(27,27),8:(28,31),9:(33,33),10:(34,34),11:(35,36),12:(37,37),13:(39,44),14:(53,53),15:(61,61),16:(62,63),17:(64,65),18:(66,69),19:(70,70),20:(71,71),21:(72,73),22:(74,76),23:(77,77)}
visual={6,14,17,18,24,26,27,31,32,33,34,36,37,44,48,52,53,61,63,65,69,70,71,73,76,77,78,79,80,81,82}
issues={1:'N6',2:'N9',3:'N6,N9',4:'N9',5:'N1,N6',6:'N2',10:'N6',11:'N10',12:'N6',13:'N3 (attached paired table),N11 (eligibility)',14:'N4',15:'N5,N6',16:'N9',17:'N6',18:'N6',21:'N7,N6',22:'N7,N6'}
ledger=[]
for s in specs:
 n=int(s['number']);a,b=ranges[n]
 ledger.append({'display':f'eTable {n}','pages':f'Supplement {a}-{b}','source':s['source']+'.csv','generator':'manuscript-supplement.R::supplement_entries / supplement_note','inspected':'all display rows and builder/CSV/Word/HTML contract; actual rendered page '+','.join(str(p) for p in range(a,b+1) if p in visual),'result':'ISSUES '+issues[n] if n in issues else 'PASS numerical mapping','rows':s['rows'],'population_units_ci':s['note']})
for n,src,pop,result in [(1,'benchmark-characteristics; benchmark-documents; severity-distribution','102 trials; 510 reference cells; counts and percentages','N9'),(2,'primary-endpoint','53/60 primary; 63/80,61/80,53/80 sensitivities; percentile CI percent','PASS'),(3,'table3; table5; audit-summary','510/509 cells;1538 answers;1407 text;14 images;102 bundles;102 paired trials','PASS')]:
 ledger.append({'display':f'Table {n}','pages':f'Table{n} page 1','source':src,'generator':'displays.R::build_displays','inspected':'all rows source and actual current rendered page0001-1.png','result':result,'rows':'all','population_units_ci':pop})
for n,src,gen,pop in [(1,'protected artwork','protected bytes','architecture; no benchmark numerical estimand'),(2,'protected artwork; avatar-trace.json; AVATAR bundle','avatar_trace_blocks','22 questions;15 active+7 inactive;16 stored quote records;7 stored sources; illustration'),(3,'benchmark-set; adjudication-analysis-cells','study_flow_plot','105 minus3=102;16 reviews;510 cells;80 discordant=60agreed+20split;53ARBITER'),(4,'independent-estimates; independent-differences; agreement-meta-differences','domain_agreement_plot','510 pooled;102/domain;two separate experts;percent absolute;paired pp;95%CI;full510Published'),(5,'signalling-differences','signalling_difference_plot','paired eligible components;both experts;all5domains;five/collapsed;pp;95%CI')]:
 ledger.append({'display':f'Figure {n}','pages':f'publication Figure{n}.png','source':src,'generator':'manuscript-figures.R::'+gen if n>=3 else gen,'inspected':'actual image;source/count mapping;protected hash where applicable','result':'PASS numerical mapping','rows':'all selected plot data','population_units_ci':pop})
for n,src,gen,pop in [(1,'independent-estimates;expert-reliability','expert_reference_plot','102/domain;Overall102arms/expert and81Published;source-specific absolute rates;percentile95%CI'),(2,'signalling-differences','question_difference_plot(FALSE)','question rows collapsed only;paired n>=20;pp;95%CI'),(3,'forest-meta;meta-analyses','forest_plot','16reviews;botharms;weighted kappa;undefined marked;degenerate retained;95%CI'),(4,'signalling-estimates','signalling_plot','source-specific eligible n;all5domains;two experts;five/collapsed;absolute percent;95%CI'),(5,'signalling-differences','question_difference_plot(TRUE)','all22questions each expert;five/collapsed;zero/sparse included;pairedn;pp;95%CI')]:
 ledger.append({'display':f'eFigure {n}','pages':f'Supplement {77+n}','source':src,'generator':'manuscript-figures.R::'+gen,'inspected':'actual rendered full page;source selection and metric/denominator mapping','result':'N8 (legend duplication); numerical mapping PASS','rows':'all selected plot data','population_units_ci':pop})
extras=[('Unweighted agreement with each expert','15-16','expert-unweighted','PASS'),('Paired binary differences','32','independent-binary-differences','PASS'),('Retained and changed signalling answers','38','answer-changes','PASS'),('Five-level disagreement types','45','signalling-disagreement-types','PASS'),('Paired signalling differences','46-48','signalling-differences','N3'),('Signalling comparison eligibility','49-52','signalling-eligibility','N11'),('Independent agreement after rules-only','54-58','rules-only-agreement','PASS'),('Cells changed by rules-only','59-60','rules-only-changed','PASS'),('AVATAR complete trace','83-105','avatar-trace-answers;avatar-trace-evidence','PASS source/Word contract;visual review other owner'),('Prompt provenance','106','prompt-template-example','PASS source/Word contract;visual review other owner')]
for title,p,src,result in extras:ledger.append({'display':title,'pages':'Supplement '+p,'source':src,'generator':'manuscript-supplement.R / avatar-trace.R','inspected':'source and all-row Word/HTML contract;actual pages only where named in page ledger','result':result,'rows':'all','population_units_ci':'see report and source-contracts.log'})
write('display-ledger.csv',ledger)
pages=json.loads((OUT/'page-text.json').read_text(encoding='utf-8'))
pl=[]
for p in pages:
 doc=p['document'];n=p['page'];seen=(doc.startswith('Table') or (doc=='Supplement' and n in visual))
 displays=[x['display'] for x in ledger if doc=='Supplement' and any(str(n)==str(v) for v in [])]
 if doc=='Supplement':
  displays=[f'eTable {k}' for k,(a,b) in ranges.items() if a<=n<=b]
  for title,span,src,result in extras:
   ab=[int(v) for v in span.split('-')]
   if ab[0]<=n<=ab[-1]:displays.append(title)
  if 78<=n<=82:displays.append(f'eFigure {n-77}')
 else:displays=[doc]
 pl.append({'document':doc,'page':n,'display':'; '.join(displays),'numerical_inspection':'actual page image + source/CSV contracts' if seen else 'page text inventory + document/CSV contract; visual review assigned to other owner','image_inspected_by_numbers':seen,'result':'see display-ledger issues for this display; no standalone page layout certification' if doc=='Supplement' else ('PASS numerical rows' if doc.startswith('Table') else 'PASS manuscript number/reporting-map contract; visual other owner')})
write('page-ledger.csv',pl)
print('Wrote',len(ledger),'display/component entries;',len(pl),'page entries;',sum(r['image_inspected_by_numbers'] for r in pl),'actual document-page images inspected; plus all five standalone main figure images.')
