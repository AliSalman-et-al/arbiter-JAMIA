"""Figure 2: a numbered sequence, compact domain summary, and paired trajectories."""
import hashlib
import json
import re
from collections import Counter
from build import (Scene, HERE, SLUG, INK, BLUE, LLM, LAVENDER, MINT, YELLOW,
                   HILITE, CONTEXT, GREY, UNASSISTED, DISPLAY, excerpt, lines_for)


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
    s.title='AVATAR: one answer, every domain, two trajectories'
    s.description='A: numbered agent–server sequence for D5 question 5.1. B: complete domain answer paths; the outlined D5 5.1 chip with A badge links to panel A. C: ARBITER and Unassisted D5 outputs compared with adjudicators.'
    assert data['unassisted']['model_D5']=='Low'
    assert data['published']['D5']=='Low'
    assert data['adjud']['preferred']=='Some concerns'
    assert data['bundle_facts']['sources']==7
    size=10
    def label(x,y,t,face='regular',color=INK,size=size,italic=False):
        if color=='white':color='#FFFFFF'
        if '✓' in t:
            left,right=t.split('✓',1)
            if left:s.text(x,y,left,size,face,color,italic=italic)
            cx=x+s.width(left,size,face)
            s.add(f'<path d="M{cx+1},{y-5} L{cx+5},{y-1} L{cx+12},{y-10}" fill="none" stroke="{color}" stroke-width="1.7"/>')
            if right:s.text(cx+15,y,right.lstrip(),size,face,color,italic=italic)
        elif t=='×':
            s.add(f'<path d="M{x+1},{y-11} L{x+12},{y}" fill="none" stroke="{color}" stroke-width="1.7"/><path d="M{x+12},{y-11} L{x+1},{y}" fill="none" stroke="{color}" stroke-width="1.7"/>')
        else:s.text(x,y,t,size,face,color,italic=italic)
    def box(x,y,w,h,fill='white',stroke=INK,sw=1.2,kind='pill'):
        s.rect(x,y,w,h,fill,6,stroke,sw,kind)
    def pill(x,y,t,w=None,fill='white',face='bold',color=INK):
        w=w or s.width(t,size,face)+14
        box(x,y,w,20,fill)
        label(x+7,y+13.5,t,face,color)
        return w
    def output(x,y,t,w=88):
        box(x,y,w,20,'#DFF2F8' if t=='Some concerns' else 'white',sw=2)
        label(x+7,y+13.5,t,'bold')
        return w
    def panel(y,tag,title):
        label(12,y,tag,'bold',size=16);label(32,y,title,'bold',size=12)
    def badge(n,y,title):
        s.add(f'<circle cx="88" cy="{y-3}" r="9" fill="{INK}"/>')
        s.text(88,y+.5,str(n),10,'bold','#FFFFFF',anchor='middle')
        label(104,y,title,'bold',size=11)
    def message(y,reverse=False):
        s.line(628 if reverse else 64,y,64 if reverse else 628,y,arrow=True,sw=1.6)
    def tag(x,y,w,source,quote,context=True):
        # A dark source tab and a highlighted quotation body share one outline.
        box(x,y,w,36,CONTEXT if context else HILITE,sw=1.4,kind='container')
        s.rect(x+2,y+2,w-4,16,INK,4,stroke='none',sw=0)
        label(x+8,y+13,source,'regular','white')
        ls=lines_for(s,quote,w-16,size)
        assert len(ls)<=2,(quote,ls)
        for k,line in enumerate(ls):label(x+8,y+29+12*k,line,italic=True)
    def robot(x,y,color):
        box(x,y,21,17,'white',stroke=color,sw=1.8,kind='container')
        s.add(f'<circle cx="{x+7}" cy="{y+6}" r="1.4" fill="{INK}"/><circle cx="{x+14}" cy="{y+6}" r="1.4" fill="{INK}"/>')
        s.line(x+6,y+12,x+15,y+12,sw=1)
        s.line(x+10,y-4,x+10,y,sw=1)
    def document(x,y,name):
        s.rect(x,y,15,21,'white',2,INK,1.3)
        for dy in [6,10,14]:s.line(x+4,y+dy,x+11,y+dy,sw=.7)
        label(x+20,y+14,name)

    panel(19,'A','Under the hood: one answer · AVATAR · D5 · question 5.1')
    box(14,32,106,28,LAVENDER,sw=2,kind='container');label(27,50,'LLM agent','bold',LLM,size=13)
    box(548,32,134,28,MINT,sw=2,kind='container');label(558,49,'ARBITER server','bold',size=12)
    label(550,75,'no model calls',color=GREY)
    # Source documents attach to the server; count and prefixes derive from the bundle.
    document(270,34,'PDF');document(330,34,'PDF');document(390,34,'registry')
    label(270,75,f"{data['bundle_facts']['sources']} sources captured · sha256",'bold')
    s.line(464,44,538,44,arrow=True,sw=1.4)
    s.line(59,60,59,64,sw=1.8)
    s.rect(54,64,10,550,LAVENDER,2,INK,1.8)
    s.line(633,60,633,64,sw=1.8)
    s.rect(628,64,10,550,MINT,2,INK,1.8)

    badge(1,106,'Get guidance');pill(285,91,'get_domain_context',face='mono');pill(422,91,'D5',face='mono');message(121)
    pill(189,130,'questions 5.1–5.3 + RoB 2 guidance',fill='#F4F4F2');message(158,True)
    badge(2,179,'Read sources');pill(285,164,'read_pages',face='mono');pill(405,164,'4 sources · 4 passages',face='mono');message(194)
    for y,(index,quote) in zip([203,245],rows[4]['shown']):
        b=rows[4]['bases'][index];ev=b['ev']
        tag(106,y,494,f"{b['src']['label']} · p {ev['page']} · L{ev['start_line']}–{ev['end_line']} · sha256 {ev['source_version'].split(':')[1][:8]}…",quote)

    # Return line follows the two source-tag payloads.
    message(284,True)
    badge(3,304,'Reason from context')
    box(106,314,494,43,LAVENDER,sw=1.5,kind='container')
    for y,t in [(328,'… '+rows[4]['reason']), (346,rows[4]['gap'])]:
        if y==328:s.rect(113,y-10, s.width(t,10)+8,13,CONTEXT,3,stroke='none',sw=0,kind='pill')
        label(117,y,t,italic=True)
    badge(4,379,'Save answer + citations');pill(327,364,'save_domain_judgment',face='mono')
    handles=[rows[4]['bases'][i]['ev']['handle'][:11]+'…' for i in [1,0]]
    assert len(rows[4]['bases'])==4
    payload='5.1 No information · cites '+handles[0]+' · '+handles[1]+' +2'
    w=pill(106,392,payload,fill=LAVENDER,face='mono')
    s.line(64,402,106,402,sw=1.6)
    s.line(106+w,402,628,402,arrow=True,sw=1.6)
    box(101,427,511,87,MINT,sw=1.5,kind='container')
    badge(5,443,'Check spans; compute judgement')
    hashes=[rows[4]['bases'][i]['ev']['source_version'].split(':')[1][:8] for i in [0,1]]
    assert hashes==['d32e23eb','592b9a6c']
    label(106,463,'✓ spans match sha256 '+hashes[1]+'… report · '+hashes[0]+'… registry','bold')
    d5abbr={'no_information':'NI','probably_no':'PN'}
    d5pattern=' · '.join(rows[4]['numbers'][a['question_id']]+' '+d5abbr[a['answer']] for a in rows[4]['d']['answers'])
    assert d5pattern=='5.1 NI · 5.2 PN · 5.3 PN'
    label(106,481,d5pattern+' → official RoB 2 algorithm')
    label(106,505,'proposed judgement · adopted, no override',color=GREY)
    output(462,491,'Some concerns');message(524,True)
    # Short curved notes occupy the actor margins, away from the exchange path.
    label(106,544,'The model only proposes answers and citations',italic=True)
    s.add(f'<path d="M44,531 Q17,513 43,482" fill="none" stroke="{INK}" stroke-width="1.2"/>')
    s.line(43,482,49,477,arrow=True,sw=1.2)
    label(328,558,'Every check and judgement is computed here — no model calls',italic=True)
    s.add(f'<path d="M665,531 Q681,509 648,482" fill="none" stroke="{INK}" stroke-width="1.2"/>')
    s.line(648,482,642,477,arrow=True,sw=1.2)
    badge(6,570,'Review + export')
    pill(140,580,'review_trial',face='mono');pill(235,580,'finalize_batch',face='mono')
    box(363,580,237,20,YELLOW,sw=1.3,kind='container')
    label(370,593,'.arbiter.zip ✓ independent verifier: verified')
    message(610)

    compress_sequence(s,.84)
    a_parts=len(s.parts);a_text=len(s.text_records);a_pdf=len(s.pdf_text);a_tips=len(s.arrow_tips)
    panel(621,'B','Same machinery, every domain')
    label(65,639,'Evidence','bold');label(300,639,'Answers · question order','bold');label(580,639,'Judgement','bold')
    s.add('<defs><pattern id="not-asked" width="6" height="6" patternUnits="userSpaceOnUse"><rect width="6" height="6" fill="#F7F7F5"/><path d="M-1 1 L1 -1 M0 6 L6 0 M5 7 L7 5" stroke="#CECECA" stroke-width=".65"/></pattern></defs>')
    phrases=[excerpt(rows[0]['bases'][0]['ev']['quote'],['computer-generated','permuted-block sequence']), 'Masking: NONE',excerpt(rows[2]['bases'][0]['ev']['quote'],['One patient','lost to follow-up','censored']),excerpt(rows[3]['bases'][0]['ev']['quote'],['Data and safety monitoring board members were not blinded']),excerpt(rows[4]['bases'][1]['ev']['quote'],['Prespecified secondary end points','Time to death'])]
    abbr={'yes':'Y','no':'N','probably_yes':'PY','probably_no':'PN','no_information':'NI'}
    # Question numbers sit above a uniform answer chip; inactive chips keep their number.
    for i,(r,phrase) in enumerate(zip(rows,phrases)):
        r['summary_quote']=phrase
        y=647+i*29
        pill(12,y+2,f'D{i+1}',33,fill=MINT)
        src='Registry' if i==1 else 'p '+str(r['bases'][1 if i==4 else 0]['ev']['page'])
        box(54,y,220 if i==4 else 230,26,CONTEXT if i==4 else HILITE,sw=.9,kind='container')
        s.rect(56,y+2,40,22,INK,3,stroke='none',sw=0)
        label(60,y+16,src,color='white')
        ls=lines_for(s,phrase,168 if i==4 else 178,10)
        assert len(ls)<=2
        for k,t in enumerate(ls):label(101,y+11+k*11,t)
        active={a['question_id']:a['answer'] for a in r['d']['answers']}
        for j,(qid,num) in enumerate(sorted(r['numbers'].items(),key=lambda z:float(z[1]))):
            x=300+j*35
            inactive=qid not in active
            label(x+5,y+8,num,color=GREY if inactive else INK,size=10)
            traced=i==4 and num=='5.1'
            box(x,y+12,29,14,'url(#not-asked)' if inactive else LAVENDER if traced else 'white',sw=2 if traced else .7)
            if traced:
                s.add(f'<circle cx="286" cy="{y+19}" r="6" fill="{INK}"/>')
                s.text(286,y+22.5,'A',10,'bold','#FFFFFF',anchor='middle')
            if inactive:s.hatch_records.append((x,y+12,29,14))
            else:label(x+7,y+23,abbr[active[qid]],'bold')
        s.line(552,y+15,568,y+15,arrow=True,sw=1.3)
        output(576,y+5,DISPLAY[r['d']['decision']['adopted']],108)
    pill(12,795,'Overall',54,fill=MINT)
    label(80,809,'any Some concerns → Some concerns','bold')
    s.line(552,805,568,805,arrow=True,sw=1.3);output(576,795,'Some concerns',108)

    shift_since(s,a_parts,a_text,a_pdf,a_tips,-90)
    panel(750,'C','Same trial, D5, with and without ARBITER')
    label(106,774,'Trajectory · this trial','bold');label(529,774,'Output','bold')
    label(602,774,'Adjudicators','bold')
    s.add(f'<circle cx="592" cy="764" r="3" fill="none" stroke="{INK}" stroke-width="1.2"/>')
    s.add(f'<path d="M586,773 Q586,768 592,768 Q598,768 598,773" fill="none" stroke="{INK}" stroke-width="1.2"/>')
    s.text(636,789,'preferred D5 judgement:',10,'regular',GREY,anchor='middle')
    s.text(636,802,'Some concerns',10,'regular',GREY,anchor='middle')
    counts=data['tool_audit']['displayed_counts']
    robot(14,817,BLUE);label(41,830,'ARBITER','bold',BLUE)
    # Stacked tool names retain real names at 7pt without compressing their glyphs.
    for x,t,n,w in [(106,'get_domain_context',counts['get_domain_context'],128),(242,'read_pages',counts['read_pages'],91),(341,'save_domain_judgment',counts['save_domain_judgment'],137)]:
        box(x,810,w,34,'#E4F5FB',sw=1.3,kind='container')
        label(x+6,823,t,'mono');label(x+6,838,'×'+str(n),'bold',BLUE)
    s.line(482,827,499,827,arrow=True,sw=1.3);output(506,817,'Some concerns',86)
    label(629,832,'✓','bold','#345C4A',size=17)
    label(367,838,'✓ server check',color=GREY)
    robot(14,869,UNASSISTED);label(41,882,'Unassisted','bold',UNASSISTED)
    box(106,847,372,48,'#FFF1E3',sw=1.3,kind='container')
    label(114,860,'Thought · no citation','bold',UNASSISTED)
    claim=rows[4]['unassisted']
    prefix='Time to death was a prespecified secondary endpoint with a'
    assert claim==prefix+' registered 5-year time frame.'
    label(114,873,prefix,italic=True)
    # The flagged phrase is a verbatim continuation in a separate orange outline.
    box(114,878,180,16,'white',stroke=UNASSISTED,sw=1.1,kind='outline')
    label(120,889,'registered 5-year time frame.',italic=True)
    s.line(482,877,499,877,arrow=True,sw=1.3);output(506,867,'Low',86)
    label(629,884,'×','bold','#7C3434',size=17)
    label(106,905,'D4: 4.3 skipped → invalid answer path',color=GREY)
    label(506,905,'Published: '+data['published']['D5'],color=GREY)
    footer=[r for r in s.text_records if r['text'].startswith(('D4: 4.3 skipped','Published:'))]
    assert len(footer)==2 and all(s.height-r['bbox'][3]>=12 for r in footer)
    assert s.height/4<=230
    return s


def compress_sequence(scene,factor):
    """Reduce vertical spacing only; glyph sizes, widths and stroke widths stay fixed."""
    import xml.etree.ElementTree as ET
    from svgpathtools import parse_path
    out=[]
    # Each part may be an opening group, so wrap the complete sequence once.
    root=ET.fromstring('<svg>'+''.join(scene.parts)+'</svg>')
    def visit(e,in_text=False):
        in_text=in_text or 'aria-label' in e.attrib
        if in_text:
            if e.tag=='path':
                e.set('transform',re.sub(r'translate\(([-\d.]+) ([-\d.]+)\)',lambda m:f'translate({m[1]} {float(m[2])*factor})',e.get('transform','')))
        else:
            for key in ['y','cy','y1','y2','height']:
                if key in e.attrib:e.set(key,str(float(e.get(key))*factor))
            if e.tag=='path':e.set('d',parse_path(e.get('d')).scaled(1,factor,origin=0j).d())
            if e.tag=='polygon':
                nums=[float(n) for n in re.findall(r'-?[\d.]+',e.get('points'))]
                e.set('points',' '.join(f'{x},{y*factor}' for x,y in zip(nums[::2],nums[1::2])))
        for child in e:visit(child,in_text)
    for child in root:visit(child);out.append(ET.tostring(child,encoding='unicode'))
    scene.parts=out
    for r in scene.text_records:
        delta=r['baseline']*(factor-1);r['baseline']+=delta;r['bbox'][1]+=delta;r['bbox'][3]+=delta
    for r in scene.pdf_text:r['y']*=factor
    scene.arrow_tips=[(x,y*factor) for x,y in scene.arrow_tips]


def shift_since(s,part,text,pdf,tip,dy):
    s.parts[part:]=[f'<g transform="translate(0 {dy})">',*s.parts[part:],'</g>']
    for r in s.text_records[text:]:
        r['baseline']+=dy;r['bbox'][1]+=dy;r['bbox'][3]+=dy
    for r in s.pdf_text[pdf:]:r['y']+=dy
    s.arrow_tips[tip:]=[(x,y+dy) for x,y in s.arrow_tips[tip:]]
    s.hatch_records=[(x,y+dy,w,h) for x,y,w,h in s.hatch_records]
