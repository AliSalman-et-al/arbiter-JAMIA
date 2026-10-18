"""Reader-first AVATAR storyboard; archived evidence remains build-asserted."""
import hashlib,json,re
from collections import Counter
from build import (Scene,HERE,SLUG,INK,LLM,LAVENDER,MINT,HILITE,CONTEXT,GREY,DISPLAY,excerpt,lines_for,row,norm)

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
    s.title='AVATAR, assessed by ARBITER, domain by domain'
    s.description='Five domains connect source quotations, AI answers, rule-based checks and results. Selection of the reported result yields Some concerns.'
    size=10
    def text(x,y,t,face='regular',color=INK,italic=False):
        s.text(x,y,t,size,face,color,italic=italic)
    def wrap(x,y,t,w,face='regular',color=INK,italic=False):
        ls=lines_for(s,t,w,size,face)
        for j,line in enumerate(ls):text(x,y+j*12,line,face,color,italic)
        return y+len(ls)*12
    def check(x,y,t,w):
        s.add(f'<path d="M{x},{y-4} l3,3 l6,-8" fill="none" stroke="{INK}" stroke-width="1.4"/>')
        return wrap(x+14,y,t,w-14)
    def pill(x,y,t,w,fill=LAVENDER):
        s.rect(x,y,w,20,fill,5,INK,1.3,'pill');text(x+7,y+14,t,'bold')
    def doc(x,y):
        s.rect(x,y,13,17,'white',2,INK,1.2)
        for dy in (5,9,13):s.line(x+3,y+dy,x+10,y+dy,sw=.6)
    def quote(x,y,t,w,context=False):
        ls=lines_for(s,'“'+t+'”',w-12,size)
        s.rect(x,y,w,len(ls)*12+10,CONTEXT if context else HILITE,4,stroke='none',sw=0)
        for j,line in enumerate(ls):text(x+6,y+12+j*12,line)
        return y+len(ls)*12+10
    def chips(r,y):
        active={a['question_id']:a['answer'] for a in r['d']['answers']}
        abbr={'yes':'Y','no':'N','probably_no':'PN','probably_yes':'PY','no_information':'NI'}
        pattern=[]
        for j,(qid,num) in enumerate(sorted(r['numbers'].items(),key=lambda z:float(z[1]))):
            x=423+(j%4)*43;cy=y+(j//4)*25
            inactive=qid not in active
            s.rect(x,cy,39,19,'url(#not-asked)' if inactive else 'white',3,INK,.7,'pill')
            if inactive:s.hatch_records.append((x,cy,39,19))
            text(x+3,cy+13,num+(' '+abbr[active[qid]] if not inactive else ''),'regular',GREY if inactive else INK)
            pattern.append(abbr.get(active.get(qid),'NA'))
        assert pattern==patterns[rows.index(r)],pattern
        return y+((len(pattern)+3)//4)*25
    patterns=[['Y','Y','N'],['Y','Y','PN','NA','NA','Y','NA'],['Y','NA','NA','NA'],['PN','PN','Y','PN','NA'],['NI','PN','PN']]
    # Assert every comparator label from both the analysis-set export and its versioned source.
    for source in ('results-102/model-domain-labels.csv','model-domain-labels.csv'):
        labels=row(HERE.parents[1]/('no-kit-sonnet-5.5/'+source),slug=SLUG)
        assert all(labels['model_'+d]=='Low' for d in ['D1','D2','D3','D4','D5','Overall'])
    assert data['published']['D5']=='Low' and data['adjud']['preferred']=='Some concerns'
    trial=data['c']['batch']['trials'][0]
    assert 'Asymptomatic Severe Aortic Stenosis' in trial['registry']['title']
    assert 'all-cause' in trial['requested_outcome'].lower()
    assert 'independent of enrolling staff' in rows[0]['a']['unknowns'][0]
    assert 'No dated source therefore specifies this measurement and analysis.' in rows[4]['a']['justification']
    text(12,16,'AVATAR · early surgery vs watchful waiting in asymptomatic severe aortic stenosis · outcome: all-cause death','bold')
    text(12,33,'RoB 2 asks up to 22 questions in 5 domains. Results describe risk of bias.')
    text(12,50,'Y yes · PY / PN probably yes / no · N no · NI no information')
    s.rect(279,40,14,13,'url(#not-asked)',2,INK,.6,'pill');s.hatch_records.append((279,40,14,13))
    text(300,50,'not needed (RoB 2 branching)')
    text(12,67,'Evidence key: yellow = quote directly supports the answer · grey = background context · dashed = reasoning without a quote')
    s.add('<defs><pattern id="not-asked" width="6" height="6" patternUnits="userSpaceOnUse"><rect width="6" height="6" fill="#F7F7F5"/><path d="M0 6 L6 0" stroke="#AAA" stroke-width=".65"/></pattern></defs>')
    s.rect(305,80,108,59,LAVENDER,5,INK,1.5)
    s.rect(419,80,188,59,MINT,5,INK,1.5)
    # Book-style line glyphs identify document, model and rule-based actor.
    doc(158,88)
    s.rect(314,88,18,13,'white',2,INK,1)
    for x in (319,327):s.add(f'<circle cx="{x}" cy="93" r="1" fill="{INK}"/>')
    s.line(319,98,327,98,sw=.7)
    s.rect(428,87,16,16,'white',2,INK,1)
    for dy in (92,97):s.line(431,dy,441,dy,sw=.8)
    wrap(12,103,'Domain & question',128,'bold')
    text(177,100,'The sources say','bold')
    wrap(339,100,'AI model answers',68,'bold',LLM)
    wrap(450,95,'ARBITER (rule-based software, no AI) checks and applies the rules',150,'bold')
    text(619,103,'Result','bold')
    names=['Randomisation process','Deviations from intended interventions','Missing outcome data','Measurement of the outcome','Selection of the reported result']
    questions=['Was allocation concealed until participants were assigned?','Did participants know which treatment they received?','Were outcome data available for nearly all participants?','Did outcome assessors know the treatment? Could that have influenced how deaths were recorded?','Was the analysis plan fixed before the results were known?']
    nums=['1.2','2.1','3.1','4.3, 4.4','5.1']
    reasons=['Central web-based allocation.','Open-label surgery vs watchful waiting.','1 of 157 (0.6%) incomplete.','All-cause death involves no judgement.','The paper says “prespecified”, but no dated plan lists this analysis; the registry lists death only inside a combined outcome.']
    ys=[147,252,357,439,553];heights=[105,105,82,114,165]
    rows[0]['shown']=[(0,'… '+excerpt(rows[0]['bases'][0]['ev']['quote'],['web-based interactive response system','computer-generated','permuted-block sequence with variable block size.']))]
    for i,(r,y,h) in enumerate(zip(rows,ys,heights)):
        s.rect(8,y,680,h-5,'white',5,INK,1.7 if i==4 else .8)
        ny=wrap(16,y+17,names[i],126,'bold')
        ny=wrap(16,ny+5,questions[i],126)
        text(16,ny+4,nums[i],color=GREY)
        qy=y+15
        for index,q in r['shown']:
            src=r['bases'][index]
            label='Registry' if i==1 or (i==4 and index==0) else 'Paper p '+str(src['ev']['page'])
            if i==4:label+=' · context'
            # Every displayed quotation must be an ordered verbatim selection.
            source_quote=norm(src['ev']['quote']);cursor=0
            for part in q.split('…'):
                part=part.strip()
                if part:
                    found=source_quote.find(part,cursor)
                    assert found>=0,(label,part)
                    cursor=found+len(part)
            text(154,qy,label,'bold');qy=quote(152,qy+5,q,147,i==4)+14
        r['summary_quote']=' / '.join(q for _,q in r['shown'])
        if i==3:
            pill(307,y+10,'Yes',44);text(356,y+24,'→');pill(307,y+36,'Probably no',99)
            s.rect(305,y+61,106,43,'white',4,GREY,.7,'container')
            # Dashed boundary is the evidence key for reasoning without a quote.
            s.parts[-1]=s.parts[-1].replace('/>',' stroke-dasharray="3 3"/>')
            wrap(312,y+75,reasons[i],92,italic=True)
        else:
            pill(307,y+10,'No information' if i==4 else 'Yes',103 if i==4 else 44)
            wrap(309,y+47,reasons[i],100)
        cy=check(425,y+16,'Both quotes found in the stored sources' if i==4 else 'Found in the stored registry record' if i==1 else 'Quote found in stored paper'+(' (4.3)' if i==3 else ''),176)
        if i==0:cy=wrap(425,cy+2,'Open point recorded: whether the system was run independently of enrolling staff is not stated.',174)
        if i==3:cy=wrap(425,cy+2,'4.4 rests on reasoning, recorded as such (no quote).',174)
        cy=chips(r,cy+5)
        if i==1:wrap(425,cy+6,'3 questions not needed (RoB 2 rules)',174)
        elif i==4:wrap(425,cy+4,'RoB 2 rule: plan not shown to be fixed in advance; no sign of selective reporting → Some concerns',174)
        elif i==2:text(425,cy+5,'RoB 2 rules → Low')
        result=DISPLAY[r['d']['decision']['adopted']]
        s.rect(613,y+12,68,43 if i==4 else 24,'#DFF2F8' if i==4 else MINT,7,INK,1.5,'pill')
        wrap(621,y+28,result,54,'bold')
        if i<4:wrap(620,y+57,'RoB 2 rules',56,color=GREY)
    text(16,734,'Overall','bold')
    text(100,734,'ARBITER applies the RoB 2 rule: any domain with Some concerns → overall Some concerns')
    pill(581,722,'Some concerns',103,'#DFF2F8')
    notes=[('The AI model never sets the rating — ARBITER computes it from the answers with the official RoB 2 rules',16,206),('Every quote is checked against a stored, unchangeable copy of the source',246,190),('When the sources are silent, the answer says so — No information, not a guess',467,209)]
    for t,x,w in notes:
        wrap(x,779,t,w,italic=True)
        s.add(f'<path d="M{x+5},766 Q{x-5},756 {x+16},752" fill="none" stroke="{INK}" stroke-width="1"/>')
        s.line(x+16,752,x+22,750,arrow=True,sw=1)
    s.rect(8,823,680,77,'#FFF1E3',6,INK,1)
    text(16,838,'Without ARBITER','bold')
    wrap(16,853,'The same AI model, with the same instructions but without ARBITER, rated every domain Low. On question 5.1 it wrote:',443)
    wrap(16,877,'“'+rows[4]['unassisted']+'” — no source given; the registry lists death only inside a combined outcome.',443,italic=True)
    wrap(477,838,'Expert adjudicators (both): Some concerns',200,'bold')
    check(478,867,'ARBITER',85)
    s.line(566,859,574,867,sw=1.4);s.line(574,859,566,867,sw=1.4)
    text(581,867,'Without ARBITER')
    text(478,889,'Published review: Low')
    text(12,916,'Everything above is saved in one audit file (.arbiter.zip); an independent verifier checked it: verified.')
    rendered=' '.join(r['text'] for r in s.text_records)
    assert not re.search(r'eh_|sha256|_|span|adopted|proposal',rendered,re.I),'Reader-facing jargon guard'
    assert s.height/4<=230
    return s
