from pathlib import Path
import csv,json,math,statistics,openpyxl
ROOT=Path(__file__).resolve().parents[4]; OUT=Path(__file__).resolve().parent
def rows(path):
 with open(ROOT/path,encoding='utf-8-sig',newline='') as f:return list(csv.DictReader(f))
def table(name):return rows('analysis/output/tables/'+name+'.csv')
def close(a,b):assert math.isclose(float(a),float(b),abs_tol=1e-10),(a,b)
workbooks=[]
for i in (1,2):
 wb=openpyxl.load_workbook(ROOT/f'human-adjudication/adjudication-with-explanations-{i}.xlsx',read_only=True,data_only=True)
 it=wb['Adjudications'].values; hdr=next(it);workbooks.append([dict(zip(hdr,r)) for r in it if r[0]])
assert all(len(w)==510 for w in workbooks)
def overall(w,col):
 d={}
 for r in w:d[r['Trial']]=max(d.get(r['Trial'],'Low'),r[col],key=['Low','Some concerns','High'].index)
 return d
claims=[]
def claim(name,value,evidence):claims.append(dict(claim=name,value=value,evidence=evidence))
for i,w in enumerate(workbooks,1):
 lookup={(r['Trial'],r['Domain']):r for r in w}
 for r in table('independent-estimates'):
  if r['adjudicator']!=str(i) or r['domain']=='Overall' or r['metric']!='accuracy':continue
  group=[a for a in w if r['domain']=='D1-D5' or a['Domain']==r['domain']]
  col={'ARBITER':'Kit','Unassisted':'No-kit','Published':'Human'}[r['source']]
  count=sum(a[col]==a['Independent'] for a in group)
  assert int(r['n'])==len(group) and int(r['count'])==count
  close(r['estimate'],count/len(group))
 claim(f'Expert {i} all-cell agreement',str({s:sum(a[c]==a['Independent'] for a in w) for s,c in [('ARBITER','Kit'),('Unassisted','No-kit'),('Published','Human')]}),'Independent workbook Adjudications')
 # Full domain confusion matrix cells, independently from workbook labels.
 for r in table('independent-confusion'):
  if r['adjudicator']!=str(i) or r['domain']=='Overall':continue
  col={'ARBITER':'Kit','Unassisted':'No-kit','Published':'Human'}[r['source']]
  count=sum(a['Domain']==r['domain'] and a['Independent']==r['reference'] and (a[col] or 'Missing')==r['predicted'] for a in w)
  assert int(r['n'])==count,(r,count)
print('PASS every independent domain exact-agreement numerator/denominator and every expert domain confusion cell from original workbooks.')
source_a={r['slug']:r for r in rows('kit-sonnet-5.5/rob2kit-domain-labels.csv')}
source_b={r['slug']:r for r in rows('no-kit-sonnet-5.5/model-domain-labels.csv')}
for i,w in enumerate(workbooks,1):
 ref=overall(w,'Independent')
 for r in table('independent-confusion'):
  if r['adjudicator']!=str(i) or r['domain']!='Overall':continue
  prediction={s:({'ARBITER':source_a[s]['rob2kit_Overall'],'Unassisted':source_b[s]['model_Overall'],'Published':source_a[s]['human_Overall']}[r['source']]) for s in ref}
  if r['source']=='Published':prediction={s:v for s,v in prediction.items() if v in ['Low','Some concerns','High']}
  expected=sum(ref[s]==r['reference'] and v==r['predicted'] for s,v in prediction.items())
  assert int(r['n'])==expected
  assert len(prediction)==(81 if r['source']=='Published' else 102)
claim('Overall confusion populations','ARBITER/Unassisted 102; Published 81; experts derived by worst-domain rule','source domain-label CSVs and each original workbook')
print('PASS every expert Overall confusion cell and source-specific 102/81 population from original labels/workbooks.')
bykey=[{(a['Trial'],a['Domain']):a for a in w} for w in workbooks]
paired=list(zip(workbooks[0],[bykey[1][(a['Trial'],a['Domain'])] for a in workbooks[0]]))
discordant=[(a,b) for a,b in paired if a['Kit']!=a['No-kit']]
agreed=[(a,b) for a,b in discordant if a['Chosen label']==b['Chosen label']]
assert len(discordant)==80 and len(agreed)==60
assert sum(a['Kit']==a['Chosen label'] for a,b in agreed)==53
assert [sum(a['Kit']==r['Chosen label'] for a,b in discordant for r in [a if i==0 else b]) for i in (0,1)]==[63,61]
assert sum(a['Independent']==b['Independent'] for a,b in paired)==388
claim('Primary selection','80 discordant; 60 agreed; 20 splits; 53 ARBITER; 7 Unassisted','both Adjudications sheets, keyed Trial/Domain')
print('PASS primary 53/60, independent 63/80 and 61/80, 20 splits, and 388/510 expert reliability.')
# Recompute source summaries and computational units from current per-trial metrics.
metrics=rows('analysis/data-derived/arbiter-sonnet.csv')+rows('analysis/data-derived/baseline-sonnet.csv')
costs=[a for a in rows('analysis/data-derived/api-cost-trials.csv') if a['arm'] in ('ARBITER-Sonnet','Baseline-Sonnet')]
metric_by={(a['arm'],a['slug']):a for a in metrics}
for a in costs:
 point=(2*(float(a['result_input'])+float(a['side_input']))+4*(float(a['result_write1'])+float(a['side_write1']))+2.5*(float(a['result_write5'])+float(a['side_write5']))+.1*(float(a['result_read'])+float(a['side_read']))+10*(float(a['result_output'])+float(a['side_output'])))/1e6
 close(point,a['point'])
 # R/unchanged.R replaces raw harness cost with reconstructed API point cost.
 metric_by[(a['arm'],a['slug'])]['cost_usd']=str(point)
for r in table('process-summary'):
 rawarm={'ARBITER (Sonnet 5.5)':'ARBITER-Sonnet','Unassisted (Sonnet 5.5)':'Baseline-Sonnet'}[r['arm']]
 v=[float({'TRUE':'1','FALSE':'0'}.get(a[r['metric']],a[r['metric']])) for a in metrics if a['arm']==rawarm and a[r['metric']]]
 if not v:continue
 q=statistics.quantiles(v,n=4,method='inclusive')
 for key,value in [('median',statistics.median(v)),('q1',q[0]),('q3',q[2]),('total',sum(v))]:close(r[key],value)
for arm in ['ARBITER-Sonnet','Baseline-Sonnet']:
 v=[a for a in metrics if a['arm']==arm]
 claim(arm+' resource medians',str({'minutes':statistics.median(float(a['wall_seconds'])/60 for a in v),'USD equivalent':statistics.median(float(a['cost_usd']) for a in v)}),'per-trial run metrics; rate reconstruction independently checked')
print('PASS all 204 per-trial cost equivalents from token components and frozen Sonnet rates; all process summary quantiles/totals.')
bindings=[r for r in rows('analysis/data-derived/bundle-binding-counts.csv') if r['arm']=='ARBITER-Sonnet']
print('Binding columns:',list(bindings[0]))
for k in ['cited_records','bound_records','text_records','text_bound','visual_records','visual_bound','other_records']:
 if k in bindings[0]:print(k,sum(float(a[k]) for a in bindings))
assert [sum(int(a[k]) for a in bindings) for k in ['cited_records','bound_records','text_records','text_bound','visual_records','visual_bound']]==[1421,1421,1407,1407,14,14]
claim('Structural records','1421 cited/bound; 1407 text; 14 images; 8 trials visual','bundle-binding-counts.csv, Sonnet only')
with open(OUT/'claim-ledger.csv','w',encoding='utf-8',newline='') as f:
 w=csv.DictWriter(f,fieldnames=['claim','value','evidence']);w.writeheader();w.writerows(claims)
print('PASS independent counts/cost audit complete; no resampling, new estimates or output alteration.')
