#!/usr/bin/env python3
"""Read committed bundle inventories; establish whether save rejections are recorded.
No failed-save count is inferred from successful domain histories.
"""
import csv,json,pathlib,re,zipfile
ROOT=pathlib.Path(__file__).resolve().parent
trials=[r['slug'] for r in csv.DictReader(open(ROOT.parent/'rob2-meta-benchmark-set/TRIAL-SUMMARY.csv')) if r['slug'] not in {'atwine-2020','haney-2004','herrmann-2016'}]
rows=[]; candidates=[]; members=0

def walk(value,path):
    if isinstance(value,dict):
        for k,v in value.items():
            if re.search(r'reject|attempt|error|validation',k,re.I): candidates.append({'path':path+'/'+k,'value':v})
            walk(v,path+'/'+k)
    elif isinstance(value,list):
        for v in value: walk(v,path)
for slug in trials:
    with zipfile.ZipFile(ROOT.parent/f'kit-sonnet-5.5/bundles/{slug}.rob2.zip') as z:
        d=json.loads(z.read('canonical.json'))
        for name in z.namelist():
            if name.endswith('.json'):
                members+=1;walk(json.loads(z.read(name)),slug+'/'+name)
    sources=d['batch']['trials'][0]['sources']
    present=any(s['role'] in {'registry','protocol','sap'} for s in sources)
    # Includes generic supplements; inventory alone is not a content audit of each PDF.
    inventory='; '.join(s['role']+': '+s['label'] for s in sources)
    rows.append(dict(slug=slug,registry_or_protocol_or_sap=present,
        registry=any(s['role']=='registry' for s in sources),source_inventory=inventory))
with open(ROOT/'output/tables/round2-bundle-inputs.csv','w') as f:
    w=csv.DictWriter(f,fieldnames=rows[0]);w.writeheader();w.writerows(rows)
report=dict(bundles=len(trials),json_members=members,candidate_keys=candidates,
    finding='No rejected-save or attempted-save records in committed bundle JSON; 53/637 cannot be derived. Successful histories do not provide the attempted-save denominator.')
(ROOT/'round14-verification/round2-rejected-saves.json').write_text(json.dumps(report,indent=2))
print(report['finding'],f'({len(trials)} bundles; {members} JSON members; {len(candidates)} candidate keys)')
