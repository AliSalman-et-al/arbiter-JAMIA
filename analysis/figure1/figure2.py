"""Reader-first AVATAR storyboard; archived evidence remains build-asserted."""
import csv,hashlib,json,re
from pathlib import Path
from collections import Counter
from build import (Scene,HERE,SLUG,INK,LLM,LAVENDER,MINT,HILITE,CONTEXT,GREY,DISPLAY,excerpt,lines_for,row,norm,draw_actor_icon,draw_source_icon)

def tool_audit(root):
    calls={};results={};log_hashes={}
    for path in sorted((root/f'kit-sonnet-5.5/logs/{SLUG}').glob('turn*.jsonl'),key=lambda p:int(re.search(r'turn(\d+)',p.name)[1])):
        log_hashes[path.name]=hashlib.sha256(path.read_bytes()).hexdigest()
        for line in path.read_text(encoding='utf8').splitlines():
            blocks=json.loads(line).get('message',{}).get('content',[])
            if not isinstance(blocks,list):continue
            for b in blocks:
                if b.get('type')=='tool_use':
                    if b['id'] in calls:assert calls[b['id']]==b
                    calls[b['id']]=b
                if b.get('type')=='tool_result':results[b['tool_use_id']]=b
    counts=dict(sorted(Counter(b['name'].split('__')[-1] for b in calls.values()).items()))
    selected='toolu_01F15hTxheM7WBgGMfE4mYpa'
    assert calls[selected]['name'].endswith('read_pages')
    windows=calls[selected]['input']['windows']
    assert len(windows)==4 and len({w['source_id'] for w in windows})==4
    result=results[selected]['content']
    pages=json.loads(result)['data']['pages']
    assert len(pages)==4 and len({p['source_id'] for p in pages})==4
    assert all(p in result for p in ['Prespecified secondary end points included','Primary outcome 1: all cause death'])
    audit=dict(trial=SLUG,scope='this trial',counting='Unique tool-use IDs, including failed attempts and retries; not evidence-read counts per domain.',counts=counts,log_sha256=log_hashes,
               d5_passages_returned_by=dict(tool='read_pages',tool_use_id=selected),
               displayed_counts={k:counts[k] for k in ['get_domain_context','read_pages','save_domain_judgment']})
    path=HERE/'avatar-tool-counts.json'
    assert json.loads(path.read_text())==audit,'Derived tool audit differs from logs'
    return audit



def draw_trace(data,rows):
    s=Scene();s.height=920
    provenance=[]
    def record(area,shown,source,value,kind='verbatim excerpt'):
        cursor=0
        if kind=='verbatim excerpt':
            for part in shown.strip('“”').split('…'):
                part=norm(part)
                if part:
                    found=norm(value).find(part,cursor)
                    assert found>=0,(area,shown,source)
                    cursor=found+len(part)
        provenance.append(dict(area=area,displayed=shown,bundle_path=source,recorded_value=value,derivation=kind))
        return shown
    rule_map={
        'randomization.low':'Low',
        'deviations.low':'Low',
        'missing.low':'Low',
        'measurement.low':'Low',
        'selection.some_concerns':'Some concerns',
        'overall.any_concerns':'Any domain with Some concerns → overall Some concerns (no domain High)'}
    guidance=Path('C:/Users/Ali-Salman/Documents/Code/rob2-kit/src/rob2_kit/skills/rob2-assess/references')
    for domain in ('randomization','deviations','missing','measurement','selection'):
        official=(guidance/(domain+'.md')).read_text(encoding='utf8')
        assert '## Algorithm' in official and '**Low:**' in official
    assert '**Some concerns:** 5.1 No/Probably no/No information;' in (guidance/'selection.md').read_text(encoding='utf8')
    def rule(recorded,path,area='Result'):
        assert len(recorded)==1 and recorded[0] in rule_map
        return record(area,rule_map[recorded[0]],path,json.dumps(recorded),'fixed official-rule mapping')
    s.title='AVATAR, assessed by ARBITER, domain by domain'
    s.description='Every cited snippet for six displayed questions, clear verbatim AI reasons, evidence against the answers, open points, answer paths and computed results.'
    for source in ('results-102/model-domain-labels.csv','model-domain-labels.csv'):
        labels=row(HERE.parents[1]/('no-kit-sonnet-5.5/'+source),slug=SLUG)
        assert all(labels['model_'+d]=='Low' for d in ['D1','D2','D3','D4','D5','Overall'])
    assert data['published']['D5']=='Low' and data['adjud']['preferred']=='Some concerns'
    assert all(r['bases'][0]['basis']['kind']=='direct_support' for r in rows[:4])
    size=10
    def text(x,y,t,face='regular',color=INK,italic=False,font_size=None):
        s.text(x,y,t,font_size or size,face,color,italic=italic)
    def wrap(x,y,t,w,face='regular',color=INK,italic=False,font_size=None):
        fsize=font_size or size;leading=12 if fsize>10 else 11
        ls=lines_for(s,t,w,fsize,face)
        for j,line in enumerate(ls):text(x,y+j*leading,line,face,color,italic,font_size=fsize)
        return y+len(ls)*leading
    def labeled(x,y,label,value,w):
        prefix=s.width(label,10,'bold')+4
        words=value.split();first=[]
        while words and s.width(' '.join(first+[words[0]]),10)<=w-prefix:
            first.append(words.pop(0))
        text(x,y,label,'bold',GREY,font_size=10)
        text(x+prefix,y,' '.join(first),color=GREY,font_size=10)
        return wrap(x,y+11,' '.join(words),w,color=GREY,font_size=10) if words else y+11
    def check(x,y,t,w):
        s.add(f'<path d="M{x},{y-4} l3,3 l6,-8" fill="none" stroke="{INK}" stroke-width="1.4"/>')
        return wrap(x+14,y,t,w-14,font_size=10)
    def pill(x,y,t,w,fill=LAVENDER):
        s.rect(x,y,w,20,fill,5,INK,1.1,'pill');text(x+6,y+14,t,'bold')
    def icon(x,y,kind):draw_actor_icon(s,x+2,y-6,kind,.7)
    def source_icon(x,y,kind):draw_source_icon(s,x,y,kind)
    def quote(x,y,q,w,src):
        label=src['letter']+' · p '+str(src['ev']['page'])
        ls=lines_for(s,'“'+q+'”',w-55,10)
        h=max(20,len(ls)*11+8)
        s.rect(x,y,w,h,CONTEXT if src['basis']['kind']=='context' else HILITE,3,stroke='none' if src['basis']['kind']=='context' else INK,sw=0 if src['basis']['kind']=='context' else .7)
        s.rect(x,y,44,h,INK,3,stroke='none',sw=0)
        s.text(x+22,y+h/2+3.4,label,10,'bold','#FFFFFF',anchor='middle')
        for j,line in enumerate(ls):text(x+50,y+13+j*11,line,font_size=10)
        return y+h+4
    def chips(r,y):
        active={a['question_id']:a['answer'] for a in r['d']['answers']}
        abbr={'yes':'Y','no':'N','probably_no':'PN','probably_yes':'PY','no_information':'NI'}
        pattern=[]
        for j,(qid,num) in enumerate(sorted(r['numbers'].items(),key=lambda z:float(z[1]))):
            x=505+(j%3)*37;cy=y+(j//3)*22;inactive=qid not in active
            deciding=qid in r['d']['driver_questions']
            s.rect(x,cy,34,19,'url(#not-asked)' if inactive else 'white',3,INK,1.5 if deciding else .6,'pill')
            if inactive:
                s.hatch_records.append((x,cy,34,19))
            text(x+2,cy+13,num+(' '+abbr[active[qid]] if not inactive else ''),color=GREY if inactive else INK,font_size=10)
            record('ARBITER',num+(' '+abbr[active[qid]] if not inactive else ''),r['path']+'.answers / inactive_questions',qid+': '+str(active.get(qid,'inactive')),'official number + fixed answer abbreviation')
            pattern.append(abbr.get(active.get(qid),'NA'))
        assert pattern==patterns[rows.index(r)],pattern
        return y+((len(pattern)+2)//3)*22
    patterns=[['Y','Y','N'],['Y','Y','PN','NA','NA','Y','NA'],['Y','NA','NA','NA'],['PN','PN','Y','PN','NA'],['NI','PN','PN']]
    source_ids=['source_695a701','source_7f7b055','source_b28064b','source_4332139']
    sources=data['c']['batch']['trials'][0]['sources']
    cards=[next(src for src in sources if src['id'].startswith(prefix)) for prefix in source_ids]
    letters={src['id']:chr(65+i) for i,src in enumerate(cards)}
    assert [src['label'] for src in cards]==['CIRCULATIONAHA.121.057639.pdf','ehae585.pdf','ClinicalTrials.gov NCT02436655','Current registry-linked sap: SAP_000.pdf']
    selections=[
        [['Table 2 Selected baseline characteristics'],['Diabetes mellitus 14 (17.9%) 23 (29.1%) .07']],
        [['Symptom onset','AS progression'],['Patients randomized to AVR surgery who received delayed surgery','due to COVID -19'],['Patients in the conservative treatment group were referred','for surgery in case of onset of AS-related symptoms'],['physical visits','substituted by phone follow-up.']],
        [['All patients were included in the analysis.','One patient','lost to follow-up','censored']],
        [['Data and safety monitoring board members were not blinded to','the treatment allocation during events review.']],
        [['all cause death,','(MACE) including:'],['Prespecified secondary','Time to death'],['all analyses','intention-to-treat principle,'],['-Amendment to surgical delays-']]]
    # Expected exact open points and counter-evidence are part of the content gate.
    assert rows[0]['a']['counterevidence']==[dict(basis_index=1,implication='Diabetes was less common in early surgery (17.9% vs 29.1%), which could favour surgery, but P=.07 is compatible with chance and the 2022 paper attributes it to chance.')]
    assert rows[1]['a']['counterevidence']==[dict(basis_index=3,implication='The authors note pandemic-related follow-up substitution by phone and lengthened AVR delays could have increased clinical risk. These arose from the pandemic, not the trial context, and no deaths occurred while awaiting scheduled surgery in the conservative group.')]
    assert [r['a']['unknowns'] for r in rows]==[[],['Reasons for declining surgery are not described in detail.'],[],[],['Whether the published protocol listed time to all-cause death and its Cox analysis, and its date relative to unblinded data.']]
    assert len(rows[0]['bases'])==2 and len(rows[1]['bases'])==4 and len(rows[4]['bases'])==4
    assert [b['basis']['kind'] for b in rows[0]['bases']]==['direct_support','context']
    assert [b['basis']['kind'] for b in rows[1]['bases']]==['direct_support','context','context','context']
    assert all(b['basis']['kind']=='context' for b in rows[4]['bases'])
    for r,parts in zip(rows,selections):
        assert len(parts)==len(r['bases'])
        r['shown']=[]
        for j,(src,ps) in enumerate(zip(r['bases'],parts)):
            q=excerpt(src['ev']['quote'],ps)+' …'
            assert len(q.split())<=21  # broad D4 quote is shortened below to <=15
            if r is rows[3]:q=excerpt(src['ev']['quote'],['members were not blinded to','the treatment allocation during events review.'])+' …'
            if r is rows[1] and j==1:q=excerpt(src['ev']['quote'],['delayed surgery','due to COVID -19'])+' …'
            if r is rows[1] and j==2:q=excerpt(src['ev']['quote'],['referred','AS-related symptoms'])+' …'
            if r is rows[1] and j==3:q=excerpt(src['ev']['quote'],['physical visits','phone follow-up.'])+' …'
            cursor=0
            for part in q.split('…'):
                part=part.strip()
                if part:
                    found=norm(src['ev']['quote']).find(part,cursor)
                    assert found>=0,(src['ev']['identity'],part)
                    cursor=found+len(part)
            assert len(q.replace('…','').split())<=15,(q,len(q.split()))
            src['letter']=letters[src['ev']['source_id']]
            r['shown'].append((j,q))
        r['summary_quote']=' / '.join(q for _,q in r['shown'])
    # Dates are supported by the bundle's own quotations/recorded rationale.
    assert 'first submitted 30 Apr 2015' in rows[4]['a']['justification']
    assert 'Circulation 2022 and EHJ 2024' in rows[4]['a']['justification']
    assert 'Date of amendment: 04.01.2021' in rows[4]['bases'][3]['ev']['quote']
    assert data['bundle_facts']==dict(sources=7,evidence_records=16,answered=15,not_asked=7,verifier='verified')
    s.text(12,18,'AVATAR · early surgery vs watchful waiting · outcome: all-cause death',11.5,'bold')
    text(12,35,'Asymptomatic severe aortic stenosis · RoB 2 asks up to 22 questions about risk of bias across 5 domains.')
    text(12,53,'Y yes · PY / PN probably yes / no · N no · NI no information')
    s.add('<defs><pattern id="not-asked" width="6" height="6" patternUnits="userSpaceOnUse"><rect width="6" height="6" fill="#FAFAF8"/><path d="M0 6 L6 0" stroke="#BBB" stroke-width=".5"/></pattern></defs>')
    for x,w,label,fill,stroke,dashed in [(12,112,'direct quotation',HILITE,INK,False),(135,85,'context',CONTEXT,'none',False),(231,125,'inference (no quote)','white',GREY,True)]:
        s.rect(x,64,w,17,fill,3,stroke,.7)
        if dashed:s.parts[-1]=s.parts[-1].replace('/>',' stroke-dasharray="3 3"/>')
        text(x+6,76,label)
    s.rect(530,64,14,17,'url(#not-asked)',2,INK,.6,'pill');s.hatch_records.append((530,64,14,17))
    text(550,76,'not needed (RoB 2 branching)')
    s.text(12,96,'Sources stored',11.5,'bold');text(125,96,'7 sources stored · 4 cited below',color=GREY)
    for i,(src,name) in enumerate(zip(cards,['Circulation report · 2022','Eur Heart J report · 2024','ClinicalTrials.gov · 2015','Protocol amendment · 2021'])):
        x=12+i*171;s.rect(x,104,163,26,'#F8F8F6',4,INK,.7)
        source_icon(x+8,109,'registry' if i==2 else 'amendment' if i==3 else 'paper')
        text(x+30,121,chr(65+i)+' · '+name,'bold')
        assert any(b['ev']['source_version']==src['projection_hash'] for r in rows for b in r['bases'])
    for x,label,w,kind in [(12,'Domain & question',130,'doc'),(145,'The sources say',220,'doc'),(371,'AI model answers',100,'model'),(505,'ARBITER',121,'server'),(632,'RoB 2 result',52,'doc')]:
        if kind in ('model','server'):icon(x,141,kind)
        text(x+(18 if kind in ('model','server') else 0),152,label,'bold')
    text(505,166,'checks quotes + rules, no AI',color=GREY)
    text(371,166,'interprets evidence',color=GREY)
    size=10.6
    names=['Randomisation process','Deviations from intended interventions','Missing outcome data','Outcome measurement','Selection of the reported result']
    questions=['Did baseline differences suggest a problem with randomisation?','Did the trial itself cause departures from the intended treatment?','Were outcome data available for nearly all participants?','Did assessors know the treatment? Could that affect how deaths were recorded?','Was the analysis plan fixed before the results were known?']
    nums=['1.3','2.3','3.1','4.3, 4.4','5.1']
    reason_parts=[
        ['The age difference is 1 year in medians. This is compatible with chance'],
        ['Crossover from conservative care to surgery (35/79) was driven by protocol-defined indications'],
        ['1/157 (0.6%) has incomplete outcome data.'],
        ['All-cause death','involves no judgement'],
        ['published protocol','is not among the captured Sources','the report statements are not date-stamped before unblinded data.']]
    reasons=[]
    for i,r in enumerate(rows):
        r['path']=f'canonical.json/domain_records/{SLUG}:domain:'+r['a']['question_id'].split(':')[1]
        base=next(a['justification'] for a in r['d']['answers'] if a['question_id']=='sq:measurement:influence-possible') if i==3 else r['a']['justification']
        shown='“'+excerpt(base,reason_parts[i])+(' …' if i in (0,1) else '')+'”'
        reasons.append(record('AI model',shown,r['path']+'.answers/'+('sq:measurement:influence-possible' if i==3 else r['a']['question_id'])+'.justification',base))
        r['displayed_justification']=shown
    # Compact content-driven rows leave no empty D5 tail.
    y=172
    for i,r in enumerate(rows):
        start=len(s.parts);first_text=len(s.text_records);s.add('ROW_PLACEHOLDER')
        ny=wrap(16,y+16,names[i],125,'bold');ny=wrap(16,ny+3,questions[i],125);s.text(16,ny+1,nums[i],10,color=GREY)
        qy=y+7
        for index,q in r['shown']:
            record('The sources say',q,'evidence/'+r['bases'][index]['ev']['identity'].split(':')[1]+'.json:quote',r['bases'][index]['ev']['quote'])
            src=r['bases'][index]
            record('The sources say',src['letter']+' · p '+str(src['ev']['page']),'evidence/'+src['ev']['identity'].split(':')[1]+'.json:source_id/page',src['ev']['source_id']+': '+str(src['ev']['page']),'fixed source-letter key + recorded page')
            qy=quote(145,qy,q,220,src)
        if i==3:
            pill(371,y+7,'Yes',44);pill(371,y+33,'Probably no',123)
            s.rect(371,y+60,123,39,'white',4,GREY,.7)
            s.parts[-1]=s.parts[-1].replace('/>',' stroke-dasharray="3 3"/>')
            ay=wrap(377,y+73,reasons[i],112,italic=True)
        else:
            pill(371,y+7,DISPLAY[r['a']['answer']],123 if i in (1,4) else 44)
            ay=wrap(375,y+42,reasons[i],118)
        cy=chips(r,y+8)
        if r['d']['driver_questions']:
            assert r['d']['driver_questions']==[r['a']['question_id']]
            deciding='decided by question '+r['numbers'][r['d']['driver_questions'][0]]
            record('ARBITER',deciding,r['path']+'.driver_questions',json.dumps(r['d']['driver_questions']),'fixed driver wording + official question number')
            cy=wrap(505,cy+9,deciding,121,font_size=10)
        assert r['d']['trace']==[r['a']['question_id'].split(':')[1]+'.'+r['d']['decision']['adopted']]
        result=rule(r['d']['trace'],r['path']+'.trace')
        assert result==DISPLAY[r['d']['decision']['adopted']]
        record('Result',result,r['path']+'.decision.adopted',r['d']['decision']['adopted'],'fixed judgement label')
        for answer in r['d']['answers']:
            if answer['question_id'] in [r['a']['question_id'],'sq:measurement:influence-possible']:
                record('AI model',DISPLAY[answer['answer']],r['path']+'.answers/'+answer['question_id']+'.answer',answer['answer'],'fixed answer label')
        s.rect(632,y+7,49,41 if i==4 else 24,'#DFF2F8' if i==4 else 'white',5,INK,1.5,'pill')
        wrap(638,y+22,result,37,'bold',font_size=10)
        bottom=max(ny+8,qy,ay+5,cy+3)
        for ce in r['a']['counterevidence']:
            value=ce['implication']
            if i==0:value=excerpt(value,['Diabetes was less common in early surgery (17.9% vs 29.1%),','but P=.07 is compatible with chance'])
            # Verbatim trimmed, with no paraphrase of contrary evidence.
            if i==1:value=excerpt(value,['pandemic-related follow-up substitution by phone and lengthened AVR delays could have increased clinical risk.','not the trial context','no deaths occurred while awaiting scheduled surgery'])
            record('Weighed against',value,r['path']+'.answers/'+r['a']['question_id']+'.counterevidence',ce['implication'])
            bottom=labeled(16,bottom+8,'Weighed against:',value,660)
        for unknown in r['a']['unknowns']:
            record('Open point',unknown,r['path']+'.answers/'+r['a']['question_id']+'.unknowns',unknown)
            bottom=labeled(16,bottom+7,'? Open point:',unknown,660)
        h=bottom-y+6
        s.parts[start]=f'<rect data-kind="container" x="8" y="{y}" width="680" height="{h}" rx="5" fill="white" stroke="{INK}" stroke-width=".7"/>'
        # Inspect exactly the text strings that become SVG aria-labels and PDF text.
        # Domain/question paraphrases and the two structural labels are explicitly outside this audit.
        for t in s.text_records[first_text:]:
            if t['bbox'][0]<144 and t['text'] not in ('Weighed against:','? Open point:'):
                if not any(norm(t['text']) in norm(p['displayed']) for p in provenance if p['area'] in ('Weighed against','Open point')):continue
            if t['text'] in ('Weighed against:','? Open point:'):continue
            matches=[p for p in provenance if norm(t['text']).strip('“”') in norm(p['displayed'])]
            assert matches,('Untraced final SVG text',t['text'])
            for p in matches:p.setdefault('svg_text_lines',[]).append(t['text'])
        y+=h+4
    size=10
    overall_start=len(s.text_records)
    s.rect(8,y,680,55,'white',5,INK,.7)
    text(16,y+20,'Overall','bold')
    wrap(90,y+20,rule(data['c']['snapshots'][SLUG]['overall_trace'],'canonical.json/snapshots/'+SLUG+'.overall_trace','ARBITER'),475)
    s.rect(632,y+7,49,41,'#DFF2F8',5,INK,1.5,'pill');wrap(638,y+22,'Some concerns',37,'bold');y+=59
    record('Result','Some concerns','canonical.json/snapshots/'+SLUG+'.overall',data['c']['snapshots'][SLUG]['overall'],'fixed judgement label')
    for t in s.text_records[overall_start:]:
        if t['text']=='Overall':continue
        matches=[p for p in provenance if norm(t['text']) in norm(p['displayed'])]
        assert matches,t['text']
        for p in matches:p.setdefault('svg_text_lines',[]).append(t['text'])
    text(12,y+10,'This trial: 15 questions answered · 7 not needed · 16 quotes, all found in the stored sources')
    wrap(12,y+26,"All of this appears in ARBITER's HTML report for the reviewer and is saved in one audit file (.arbiter.zip), checked by an independent verifier.",670)
    text(12,y+42,'Published D5: Low · Blinded D5 choice, both human reviews: Some concerns')
    s.height=y+46
    rendered=' '.join(r['text'] for r in s.text_records)
    assert not re.search(r'eh_|sha256|_|span|adopted|proposal',rendered,re.I),'Reader-facing jargon guard'
    assert s.height/4<=230,s.height/4
    # Every semantic string in these columns must be covered by a trace record.
    provenance.append(dict(area='ARBITER',displayed='Overall: Some concerns',bundle_path='canonical.json/snapshots/'+SLUG+'.overall',recorded_value=data['c']['snapshots'][SLUG]['overall'],derivation='fixed judgement label'))
    for p in provenance:p['svg_text_lines']=json.dumps(p.get('svg_text_lines',[]),ensure_ascii=False)
    with (HERE/'figure2-text-provenance.csv').open('w',encoding='utf8',newline='') as f:
        writer=csv.DictWriter(f,fieldnames=['area','displayed','bundle_path','recorded_value','derivation','svg_text_lines']);writer.writeheader();writer.writerows(provenance)
    return s
