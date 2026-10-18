"""Rebuild Figures 1–2 from archived assessments, logs, labels and ARBITER source.

All text is drawn from bundled OFL fonts as vector outlines; no system font lookup.
The scene is in quarter-millimetres: 696 units = 174 mm.
"""
from __future__ import annotations

import argparse
import csv
import hashlib
import html
import io
import json
import re
import subprocess
import zipfile
from pathlib import Path

import fitz
import resvg_py
from fontTools.pens.svgPathPen import SVGPathPen
from fontTools.pens.boundsPen import BoundsPen
from fontTools.ttLib import TTFont
from PIL import Image, ImageOps
from reportlab.graphics import renderPDF
from reportlab import rl_config
from svglib.svglib import svg2rlg

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
SLUG = "banovic26-avatar-2024"
W, H = 696, 478
INK = "#171717"
BLUE = "#00A1D5"
LLM = "#555DB3"
LAVENDER = "#E6E4F5"
MINT = "#E4F2EA"
YELLOW = "#FFF7D6"
HILITE = "#FFEA83"
GREY = "#626262"
CONTEXT = "#E7E7E4"
UNASSISTED = "#DF8F44"
DISPLAY = {"low": "Low", "some_concerns": "Some concerns", "high": "High",
           "no_information": "No information", "probably_no": "Probably no",
           "probably_yes": "Probably yes", "yes": "Yes", "no": "No"}
PHASES = {
    "Capture": ["prepare_batch", "acquire_companion_source", "admit_companion_source", "list_sources"],
    "Propose & approve": ["validate_proposal", "save_proposal", "request_proposal_approval"],
    "Assess each domain": ["get_domain_context", "read_guidance", "read_pages", "search_sources",
                           "calculate_arithmetic", "save_working_checkpoint", "save_domain_judgment", "get_status"],
    "Review & export": ["review_trial", "close_trial", "finalize_batch"],
}


def row(path, **where):
    with path.open(encoding="utf-8-sig", newline="") as f:
        matches = [r for r in csv.DictReader(f) if all(r[k] == v for k, v in where.items())]
    assert len(matches) == 1, (path, where, len(matches))
    return matches[0]


def load(data_root, source_root):
    bundle = data_root / f"kit-sonnet-5.5/bundles/{SLUG}.rob2.zip"
    with zipfile.ZipFile(bundle) as z:
        manifest = json.loads(z.read("manifest.json"))
        for entry in manifest["files"]:
            assert "sha256:" + hashlib.sha256(z.read(entry["path"])).hexdigest() == entry["sha256"]
        c = json.loads(z.read("canonical.json"))
        verification = json.loads(z.read("verification.json"))
        history = c["domain_history_records"][f"{SLUG}:domain:selection"]
        d = history[-1]
        a = next(a for a in d["answers"] if a["question_id"] == "sq:selection:prespecified-analysis")
        choices = []
        for basis in a["bases"]:
            ev = json.loads(z.read(f"evidence/{basis['evidence'].split(':')[1]}.json"))
            if re.search(r"Prespecified secondary end points.*?following:", ev["quote"]):
                choices.append((basis, ev))
        assert len(choices) == 1
        basis, ev = choices[0]
    first = re.search(r"Prespecified secondary end points.*?following:", ev["quote"]).group()
    last = re.search(r"(?m)^• (Time to death)$", ev["quote"]).group(1)
    excerpt = first + " … " + last
    assert len(excerpt.split()) <= 30
    trial = next(t for t in c["batch"]["trials"] if t["id"] == SLUG)
    src = next(s for s in trial["sources"] if s["id"] == ev["source_id"])
    assert src["projection_hash"] == ev["source_version"]
    assert basis["kind"] == "context" and a["answer"] == "no_information"
    assert a["question_id"] in d["driver_questions"]
    assert d["decision"]["adjudication"] is None
    assert d["decision"]["proposed"] == d["decision"]["adopted"]
    assert d["decision"]["authority"] == "algorithm"
    labels = row(data_root / "kit-sonnet-5.5/rob2kit-domain-labels.csv", slug=SLUG)
    for number, domain in enumerate(["randomization", "deviations", "missing", "measurement", "selection"], 1):
        record = c["domain_records"][f"{SLUG}:domain:{domain}"]
        assert labels[f"rob2kit_D{number}"] == DISPLAY[record["decision"]["adopted"]]
    assert labels["rob2kit_Overall"] == DISPLAY[c["snapshots"][SLUG]["aggregation"]["adopted"]]
    published = row(data_root / "rob2-meta-benchmark-set/LABEL-TARGETS.csv", slug=SLUG)
    unassisted = row(data_root / "no-kit-sonnet-5.5/model-domain-labels.csv", slug=SLUG)
    adjud = row(data_root / "analysis/output/tables/adjudication-analysis-cells.csv", slug=SLUG, domain="D5")
    assert adjud["consensus"] == "TRUE" and adjud["chosen_label_A"] == adjud["chosen_label_Z"]
    assert labels["rob2kit_D5"] == DISPLAY[d["decision"]["adopted"]] == adjud["preferred"]
    assert verification["result"] == "verified"
    server_path = source_root / "src/arbiter/interfaces/mcp/server.py"
    server = server_path.read_text(encoding="utf-8")
    cli = (source_root / "src/arbiter/interfaces/cli/app.py").read_text(encoding="utf-8")
    project = (source_root / "pyproject.toml").read_text(encoding="utf-8")
    finalization = (source_root / "src/arbiter/application/finalization.py").read_text(encoding="utf-8")
    assert 'arbiter = "arbiter.interfaces.cli.app:main"' in project
    assert '"review"' in cli and ".arbiter.zip" in cli and ".arbiter.zip" in finalization
    lines = {}
    for tools in PHASES.values():
        for tool in tools:
            match = re.search(rf"(?m)^(?:async )?def {tool}\(", server)
            assert match, tool
            lines[tool] = server[:match.start()].count("\n") + 1
    guidance = (source_root / "src/arbiter/skills/arbiter-assess/references/selection.md").read_text(encoding="utf-8")
    question = re.search(r"## 5\.1 .*?\) (.*?)\n", guidance).group(1)
    source_commit = subprocess.check_output(["git", "-C", str(source_root), "rev-parse", "HEAD"], text=True).strip()
    trial_name = re.search(r"\((\w+) Trial\)", trial["registry"]["title"]).group(1)
    outcome_name = trial["requested_outcome"].split(",")[0].lower()
    excerpt_lines = [ev["start_line"] + ev["quote"][:ev["quote"].index(part)].count("\n") for part in [first,last]]
    return dict(c=c, d=d, answer=a, evidence=ev, source=src, excerpt=excerpt, first=first,
                last=last, labels=labels, published=published, unassisted=unassisted,
                adjud=adjud, verification=verification, tool_lines=lines, question=question,
                bundle_sha256=hashlib.sha256(bundle.read_bytes()).hexdigest(), server_path=server_path,
                source_commit=source_commit, excerpt_lines=excerpt_lines,
                trace_title=f"{trial_name} · {outcome_name}")


class Scene:
    def __init__(self):
        self.parts = []
        self.text_records = []
        self.height = H
        self.title = "ARBITER workflow"
        self.description = "Reviewer approval, agent tool calls, deterministic server validation and verifiable bundle."
        self.pdf_text = []
        self.arrow_tips = []
        self.hatch_records = []
        self.fonts = {k: TTFont(HERE / "fonts" / filename) for k, filename in {
            "regular": "FiraSansCondensed-Regular.ttf", "bold": "FiraSansCondensed-Bold.ttf",
            "mono": "FiraCode-Regular.ttf"}.items()}

    def add(self, s):
        self.parts.append(s)

    def rect(self, x, y, w, h, fill="white", r=10, stroke=INK, sw=2, kind="container"):
        self.add(f'<rect data-kind="{kind}" x="{x}" y="{y}" width="{w}" height="{h}" rx="{r}" fill="{fill}" stroke="{stroke}" stroke-width="{sw}"/>')

    def line(self, x1, y1, x2, y2, dotted=False, arrow=False, sw=1.8):
        dash = ' stroke-dasharray="1 6" stroke-linecap="round"' if dotted else ""
        self.add(f'<path d="M{x1},{y1} L{x2},{y2}" fill="none" stroke="{INK}" stroke-width="{sw}"{dash}/>')
        if arrow:
            self.arrow_tips.append((x2, y2))
            import math
            angle = math.atan2(y2-y1, x2-x1)
            pts = [(x2, y2)] + [(x2-7*math.cos(angle)+s*3.2*math.sin(angle),
                               y2-7*math.sin(angle)-s*3.2*math.cos(angle)) for s in [-1, 1]]
            self.add('<polygon points="' + ' '.join(f'{x},{y}' for x,y in pts) + f'" fill="{INK}"/>')

    def width(self, value, size, face="regular"):
        font = self.fonts[face]
        cmap = font.getBestCmap()
        return sum(font["hmtx"][cmap[ord(ch)]][0] for ch in value) * size / font["head"].unitsPerEm

    def text(self, x, y, value, size=11.5, face="regular", color=INK, anchor="start", italic=False, stretch=1):
        assert size * 174 / W * 72 / 25.4 >= 7, (value, size)
        font = self.fonts[face]
        cmap, glyphs = font.getBestCmap(), font.getGlyphSet()
        scale = size / font["head"].unitsPerEm
        width = self.width(value, size, face) * stretch
        if anchor == "middle":
            x -= width / 2
        assert x >= 0 and x + width <= W, (value, x, width)
        self.pdf_text.append(dict(x=x,y=y,text=value,size=size,face=face,color=color,stretch=stretch,italic=italic))
        bounds = []
        cursor = x
        for char in value:
            pen = BoundsPen(glyphs)
            glyphs[cmap[ord(char)]].draw(pen)
            if pen.bounds:
                a,b,c,d = pen.bounds
                bounds.append((cursor+a*scale*stretch, y-d*scale, cursor+c*scale*stretch, y-b*scale))
            cursor += font["hmtx"][cmap[ord(char)]][0]*scale*stretch
        bbox = [min(b[0] for b in bounds),min(b[1] for b in bounds),max(b[2] for b in bounds),max(b[3] for b in bounds)]
        if italic:
            bbox[2] += size*.21256
        self.text_records.append(dict(text=value, size_pt=size * 72/101.6, x=x, baseline=y, width=width, bbox=bbox))
        self.add(f'<g aria-label="{html.escape(value, quote=True)}" fill="{color}"><title>{html.escape(value)}</title>')
        for char in value:
            name = cmap[ord(char)]
            pen = SVGPathPen(glyphs)
            glyphs[name].draw(pen)
            if pen.getCommands():
                shear = " skewX(12)" if italic else ""
                self.add(f'<path transform="translate({x:.5f} {y}) scale({scale*stretch:.7f} {-scale:.7f}){shear}" d="{pen.getCommands()}"/>')
            x += font["hmtx"][name][0] * scale * stretch
        self.add('</g>')

    def wrap(self, x, y, value, max_width, size=11.5, face="regular", color=INK, leading=15):
        words, line = value.split(), ""
        for word in words:
            trial = f"{line} {word}".strip()
            if self.width(trial, size, face) > max_width and line:
                self.text(x, y, line, size, face, color)
                y += leading
                line = word
            else:
                line = trial
        if line:
            self.text(x, y, line, size, face, color)
        return y

    def pill(self, x, y, text, size=11.5, fill=HILITE, face="bold"):
        width = self.width(text, size, face) + 14
        self.rect(x, y-13, width, 21, fill, 8, sw=1.2,kind="pill")
        self.text(x+7, y+1, text, size, face)
        return width

    def svg(self):
        return (f'<svg xmlns="http://www.w3.org/2000/svg" width="174mm" height="{self.height/4}mm" viewBox="0 0 {W} {self.height}" role="img">'
                f'<title>{html.escape(self.title)}</title>'
                f'<desc>{html.escape(self.description)}</desc>'
                '<rect width="100%" height="100%" fill="white"/>' + ''.join(self.parts) + '</svg>')


def draw_workflow(data):
    s = Scene()
    # Panel A: four horizontal lanes, four left-to-right phases.
    # Each heading is centered on the same column as its agent/server content.
    centers = [216, 348, 480, 612]
    for i, (phase, cx) in enumerate(zip(PHASES, centers), 1):
        s.text(cx, 53, phase, 12.4, "bold", anchor="middle")
        if i < 4:
            midpoint = (cx + centers[i]) / 2
            s.line(midpoint-7, 49, midpoint+7, 49, arrow=True, sw=1.4)
    # The single human icon uses only geometric strokes.
    s.rect(12, 68, 672, 61, "#F5F5F3", 11)
    s.add('<circle cx="30" cy="88" r="6" fill="white" stroke="#171717" stroke-width="2"/>')
    s.add('<path d="M19 112 Q19 98 30 98 Q41 98 41 112 Z" fill="white" stroke="#171717" stroke-width="2"/>')
    s.text(49, 94, "Reviewer", 12.5, "bold")
    s.text(49, 111, "Human", 10.5, color=GREY)
    s.text(216, 94, "Define the", 11.5, anchor="middle")
    s.text(216, 110, "requested outcome", 11.5, anchor="middle")
    s.rect(284, 76, 128, 45, "white", 8, sw=2.3)
    s.text(348, 94, "Approve the result", 12, "bold", anchor="middle")
    s.text(348, 111, "arbiter review", 10.5, "mono", anchor="middle")
    s.text(612, 94, "Report +", 11.5, "bold", anchor="middle")
    s.text(612, 111, "verifiable bundle", 11.5, "bold", anchor="middle")
    s.line(412, 99, 480, 99)
    s.line(480, 99, 480, 146, arrow=True)
    s.text(490, 140, "unlocks domain work", 10.2)

    s.rect(12, 146, 672, 70, LAVENDER, 11, sw=2.3)
    s.text(25, 168, "LLM agent", 14, "bold", LLM)
    s.text(25, 187, "/arbiter-assess", 11.5, "bold", LLM)
    s.text(25, 202, "Guides each question", 10.5, color=GREY)
    for cx, top, bottom in zip(centers,
            ["Read the reports", "Identify a result", "Answer signalling", "Inspect the"],
            ["and registry", "for approval", "questions + cite", "assessment"]):
        s.text(cx, 174, top, 12, "bold", LLM, "middle")
        s.text(cx, 193, bottom, 12, "bold", LLM, "middle")
    for x in [282, 414, 546]:
        s.line(x, 155, x, 207, dotted=True, sw=1)

    # Paired arrows: requests down the left, responses up the right of each column.
    visible = [["prepare_batch", "list_sources"], ["validate_proposal", "save_proposal"],
               ["get_domain_context", "save_domain_judgment"], ["review_trial", "finalize_batch"]]
    responses = ["source list", "validation result", "proposed judgement", "review report"]
    for cx, calls, response in zip(centers, visible, responses):
        request_x = cx-52 if cx==612 else cx-56
        response_x = cx+56
        s.line(request_x, 216, request_x, 302, arrow=True, sw=1.4)
        s.line(response_x, 302, response_x, 216, arrow=True, sw=1.4)
        for y, call in zip([239, 262], calls):
            assert s.width(call, 10.2, "mono") * .92 < 118
            s.text(cx, y, call, 10.2, "mono", anchor="middle", stretch=.84 if cx==480 else .92)
        s.text(cx, 281, response, 10.5, anchor="middle", italic=True)

    s.rect(12, 302, 672, 77, MINT, 11, sw=2.3)
    s.text(25, 324, "ARBITER server", 13.5, "bold")
    s.text(25, 343, "deterministic;", 10.5)
    s.text(25, 359, "no model calls", 10.5)
    for cx, top, bottom in zip(centers,
            ["Capture sources", "Validate & store", "Check cited spans", "Record history"],
            ["Bind their versions", "the result proposal", "Compute judgements", "Verify & package"]):
        s.text(cx, 330, top, 11.5, "bold", anchor="middle")
        s.text(cx, 350, bottom, 11.2, anchor="middle")
    for x in [282, 414, 546]:
        s.line(x, 313, x, 367, dotted=True, sw=1)
    s.line(612, 379, 612, 403, arrow=True)
    s.rect(12, 403, 672, 43, YELLOW, 10, sw=2)
    s.text(25, 429, "Bundle", 13, "bold")
    s.text(155, 420, "Source identities + bound evidence + complete history", 11.5)
    s.text(155, 438, "Checked by an independent verifier", 11.5)
    s.text(612, 429, ".arbiter.zip", 10.5, "mono", anchor="middle")

    s.height = 456
    # Remove the former panel-heading margin from both variants.
    s.parts=['<g transform="translate(0 -28)">',*s.parts,'</g>']
    for record in s.pdf_text:record['y']-=28
    for record in s.text_records:
        record['baseline']-=28
        record['bbox'][1]-=28;record['bbox'][3]-=28
    s.arrow_tips=[(x,y-28) for x,y in s.arrow_tips]
    s.height-=28
    return s

# Figure 2: verbatim selections are asserted against archived evidence/reasoning.
DOMAINS=['randomization','deviations','missing','measurement','selection']
SELECTED=['concealment','participants-aware','data-available','assessor-aware','prespecified-analysis']
QUESTIONS=['1.2 Was the allocation sequence concealed until participants were enrolled and assigned to interventions?',
'2.1 Were participants aware of their assigned intervention during the trial?',
'3.1 Were data for this outcome available for all, or nearly all, participants randomized?',
'4.3 Were outcome assessors aware of the intervention received by study participants?',
'5.1 Were the data that produced this result analysed in accordance with a pre-specified analysis plan that was finalized before unblinded outcome data were available for analysis?']

def norm(s):
    return re.sub(r'\s+',' ',s.replace('assign-\nment','assignment').replace('cen\nsored','censored')).strip()

def excerpt(value, parts):
    value=norm(value)
    for part in parts: assert part in value, (part,value)
    return ' … '.join(parts)

def trace_data(data,root,logs_root=None):
    logs_root=logs_root or root
    c=data['c'];rows=[]
    official={};locators={}
    def collect(value):
        if isinstance(value,dict):
            qid=value.get('id',value.get('question_id'))
            wording=value.get('wording',value.get('question'))
            if isinstance(qid,str) and qid.startswith('sq:') and isinstance(wording,str):
                official[qid]=wording
                if value.get('guidance_locator'):locators[qid]=value['guidance_locator']
            for child in value.values():collect(child)
        elif isinstance(value,list):
            for child in value:collect(child)
    for path in sorted((logs_root/f'kit-sonnet-5.5/logs/{SLUG}').glob('turn*.jsonl')):
        for line in path.open(encoding='utf8'):
            event=json.loads(line);content=event.get('message',{}).get('content',[])
            if not isinstance(content,list):continue
            for b in content:
                if b.get('type')=='tool_result' and isinstance(b.get('content'),str):
                    try:collect(json.loads(b['content']))
                    except json.JSONDecodeError:pass
    assert len(official)==22, len(official)
    with zipfile.ZipFile(root/f'kit-sonnet-5.5/bundles/{SLUG}.rob2.zip') as z:
        for i,(domain,suffix) in enumerate(zip(DOMAINS,SELECTED)):
            d=c['domain_records'][f'{SLUG}:domain:{domain}']
            a=next(a for a in d['answers'] if a['question_id']==f'sq:{domain}:{suffix}')
            assert a['answer']==['yes','yes','yes','yes','no_information'][i]
            assert d['decision']['proposed']==d['decision']['adopted'] and d['decision']['adjudication'] is None
            bases=[]
            for b in a['bases']:
                ev=json.loads(z.read('evidence/'+b['evidence'].split(':')[1]+'.json'))
                src=next(s for s in c['batch']['trials'][0]['sources'] if s['id']==ev['source_id'])
                assert src['projection_hash']==ev['source_version']
                bases.append(dict(basis=b,ev=ev,src=src))
            assert official[a['question_id']].endswith(QUESTIONS[i].split(' ',1)[1]), (QUESTIONS[i],official[a['question_id']])
            numbers={}
            for qid in [a['question_id'] for a in d['answers']]+d['inactive_questions']:
                match=re.search(r'(?<!\d)([1-5]\.[1-7])(?!\d)',locators[qid])
                assert match,(qid,locators[qid])
                numbers[qid]=match.group(1)
            assert len(set(numbers.values()))==len(numbers)
            rows.append(dict(d=d,a=a,bases=bases,question=official[a['question_id']],numbers=numbers))
    r=rows
    r[0]['shown']=[(0,'… '+excerpt(r[0]['bases'][0]['ev']['quote'],['web-based interactive response system. The assignment to each treatment group was computer-generated and','by means of a permuted-block sequence with variable block size.']))]
    r[0]['reason']=excerpt(r[0]['a']['justification'],['web-based interactive response system'])
    r[1]['shown']=[(0,excerpt(r[1]['bases'][0]['ev']['quote'],['Masking: NONE']))]
    r[1]['reason']=excerpt(r[1]['a']['justification'],['The registry lists masking as NONE'])
    for suffix,number in [('affected-outcome','2.4'),('balanced','2.5'),('substantial-impact','2.7')]:
        assert number in locators[f'sq:deviations:{suffix}']
    assert r[1]['d']['inactive_questions']==['sq:deviations:affected-outcome','sq:deviations:balanced','sq:deviations:substantial-impact']
    r[2]['shown']=[(0,excerpt(r[2]['bases'][0]['ev']['quote'],['All patients were included in the analysis.','One patient','lost to follow-up','censored'])+'…')]
    r[2]['reason']=excerpt(r[2]['a']['justification'],['so 1/157 (0.6%) has incomplete outcome data.'])
    r[3]['shown']=[(0,excerpt(r[3]['bases'][0]['ev']['quote'],['Data and safety monitoring board members were not blinded to the treatment allocation during events review.']))]
    r[3]['reason']=excerpt(r[3]['a']['justification'],['DSMB members were not blinded to allocation'])
    inf=next(a for a in r[3]['d']['answers'] if a['question_id']=='sq:measurement:influence-possible')
    assert inf['answer']=='probably_no' and inf['bases'][0]['kind']=='inference'
    assert 'influenced by knowledge' in official[inf['question_id']]
    r[3]['inference_question']=official[inf['question_id']]
    r[3]['inference_basis']=inf['bases'][0]
    r[3]['inference']=excerpt(inf['justification'],['All-cause death is an observer-reported outcome that involves no judgement'])
    r[4]['shown']=[(1,excerpt(r[4]['bases'][1]['ev']['quote'],['Prespecified secondary end points included the following:','Time to death'])),(0,excerpt(r[4]['bases'][0]['ev']['quote'],['Primary outcome 1: all cause death, Major Adverse Cardiac Event (MACE) including:'])+' …')]
    r[4]['reason']=excerpt(r[4]['a']['justification'],['names all-cause death only as a component of composite outcomes.'])
    r[4]['gap']=excerpt(r[4]['a']['justification'],['No dated source therefore specifies this measurement and analysis.'])
    final=(logs_root/f'no-kit-sonnet-5.5/logs/{SLUG}/final.md').read_text(encoding='utf8')
    rationale={int(n):t for n,t in re.findall(r'- \*\*D(\d):\*\* (.*)',final)}
    answers={}
    for n,q,a in re.findall(r'\| D(\d)[^|]*\| ([\d.]+) \| (\w+) \|',final):answers[q]=a
    assert answers['4.1']=='N' and answers['4.2']=='N' and answers['4.3']=='NA'
    table=root/'analysis/output/tables/domain-consistency-cells.csv'
    with table.open(encoding='utf-8-sig') as f:
        candidates=[a for a in csv.DictReader(f) if a.get('slug')==SLUG and a.get('domain')=='D4']
    assert any('invalid' in json.dumps(a).lower() for a in candidates),candidates
    excerpts=[['Allocation used a computer-generated, centre-stratified permuted-block sequence delivered through a web-based interactive response system, so concealment was adequate.'],
              ['The trial was open label, so participants and clinicians knew the assignments.'],
              ['All 157 patients were analysed. One patient lost to follow-up was censored.'],
              ['Death is an objective outcome. Assessors were not blinded to allocation, but this cannot plausibly bias an all-cause death count.'],
              ['Time to death was a prespecified secondary endpoint with a registered 5-year time frame.']]
    for i,item in enumerate(r,1):
        item['unassisted']=excerpt(rationale[i],excerpts[i-1]);item['unassisted_full']=rationale[i]
        item['unassisted_answers']=' · '.join(f'{q}\u00a0{a}' for q,a in answers.items() if q.startswith(str(i)+'.'))
    assert c['snapshots'][SLUG]['aggregation']['rule']=='overall.any_concerns'
    assert c['snapshots'][SLUG]['aggregation']['adopted']=='some_concerns'
    with zipfile.ZipFile(root/f'kit-sonnet-5.5/bundles/{SLUG}.rob2.zip') as z:
        evidence_count=len([n for n in z.namelist() if n.startswith('evidence/') and n.endswith('.json')])
    sources=c['batch']['trials'][0]['sources']
    assert all(re.fullmatch(r'sha256:[0-9a-f]{64}',src['projection_hash']) for src in sources)
    answered=sum(len(r['d']['answers']) for r in rows)
    inactive=sum(len(r['d']['inactive_questions']) for r in rows)
    assert (answered,inactive)==(15,7)
    data['bundle_facts']=dict(sources=len(sources),evidence_records=evidence_count,answered=answered,not_asked=inactive,verifier=data['verification']['result'])
    return rows


def lines_for(s,text,width,size=10.3,face='regular'):
    result=[];line=''
    answer_list=bool(re.match(r'^\d\.\d\u00a0',text))
    units=text.split(' · ') if answer_list else text.split(' ')
    for unit_index,word in enumerate(units):
        if answer_list and unit_index: word='· '+word
        trial=(line+' '+word).strip(' ')
        if s.width(trial,size,face)>width and line:result.append(line);line=word
        else:line=trial
    if line:result.append(line)
    return result


def export_scene(scene,out,name,geometry):
    from reportlab.pdfbase import pdfmetrics
    from reportlab.pdfbase.ttfonts import TTFont as PDFont
    for face,filename in [('regular','FiraSansCondensed-Regular.ttf'),('bold','FiraSansCondensed-Bold.ttf'),('mono','FiraCode-Regular.ttf')]:
        pdfmetrics.registerFont(PDFont('Fira-'+face,str(HERE/'fonts'/filename)))
    svg=scene.svg()
    assert not re.search('rob2',svg,re.I),'Legacy name in rendered text'
    png=resvg_py.svg_to_bytes(svg_string=svg,width=1644,dpi=96,skip_system_fonts=True)
    (out/f'{name}.png').write_bytes(png)
    proof_dir=out if out.name=='qa' else out/'qa'
    (out/f'{name}.svg').write_text(svg,encoding='utf8')
    # PDF uses the same positions with subset-embedded TrueType fonts. SVG remains outlined.
    from reportlab.pdfgen.canvas import Canvas
    from reportlab.lib.colors import HexColor
    pdf_svg=re.sub(r'<g aria-label=.*?</g>','',svg,flags=re.S)
    pdf_svg=re.sub(r'<defs>.*?</defs>','',pdf_svg,flags=re.S).replace('url(#not-asked)','#F7F7F5')
    rl_config.invariant=True
    factor=72/101.6
    canvas=Canvas(str(out/f'{name}.pdf'),pagesize=(W*factor,scene.height*factor),invariant=1,pageCompression=1)
    renderPDF.draw(svg2rlg(io.BytesIO(pdf_svg.encode())),canvas,0,0)
    # PDF equivalent of the SVG pattern: repeated diagonal vectors clipped to each chip.
    for x,y,w,h in scene.hatch_records:
        canvas.saveState()
        canvas.translate(0,scene.height*factor);canvas.scale(factor,-factor)
        clip=canvas.beginPath();clip.roundRect(x,y,w,h,5)
        canvas.clipPath(clip,stroke=0,fill=0)
        canvas.setStrokeColor(HexColor('#CECECA'));canvas.setLineWidth(.65)
        for offset in range(-24,int(w)+24,6):
            canvas.line(x+offset,y+h,x+offset+h,y)
        canvas.restoreState()
    for r in scene.pdf_text:
        canvas.saveState()
        canvas.translate(r['x']*factor,(scene.height-r['y'])*factor)
        canvas.transform(r['stretch'],0,.21256 if r['italic'] else 0,1,0,0)
        canvas.setFillColor(HexColor(r['color']))
        canvas.setFont('Fira-'+r['face'],r['size']*factor)
        canvas.drawString(0,0,r['text'])
        canvas.restoreState()
    canvas.showPage();canvas.save()
    with fitz.open(out/f'{name}.pdf') as doc:
        page=doc[0]
        for xref in page.get_contents():
            stream=doc.xref_stream(xref)
            stream=re.sub(rb'BT(?:(?!ET).)*ET',lambda m:m.group() if re.search(rb'\bT[Jj]\b',m.group()) else b'',stream,flags=re.S)
            doc.update_stream(xref,stream)
        for font in page.get_fonts(full=True):
            if 'Fira' not in font[3]:doc.xref_set_key(page.xref,'Resources/Font/'+font[4],'null')
        cleaned=doc.tobytes(garbage=4,deflate=True,no_new_id=True)
    (out/f'{name}.pdf').write_bytes(cleaned)
    with fitz.open(out/f'{name}.pdf') as pdf:
        page=pdf[0]
        assert abs(page.rect.width-174*72/25.4)<.02
        assert len(page.get_images())==0
        fonts=page.get_fonts(full=True)
        assert fonts and all('Fira' in f[3] and f[1]=='ttf' for f in fonts),fonts
        assert all(len(pdf.extract_font(f[0])[3])>0 for f in fonts),'Missing embedded font bytes'
        assert not re.search('rob2',page.get_text(),re.I)
        pix=page.get_pixmap(dpi=600,alpha=False)
        image=Image.frombytes('RGB',(pix.width,pix.height),pix.samples)
        image.save(out/f'{name}.tiff',compression='tiff_lzw',dpi=(600,600))
        with Image.open(out/f'{name}.tiff') as tif:
            assert tif.tag_v2[259]==5 and tuple(tif.info['dpi'])==(600,600)
        proof=page.get_pixmap(dpi=160,alpha=False)
        Image.frombytes('RGB',(proof.width,proof.height),proof.samples).save(proof_dir/f'{name}-pdf.png')
    preview=Image.open(io.BytesIO(png)).convert('RGB')
    diagnostic_proofs(preview,proof_dir,name,scene.height)
    return dict(geometry=geometry,width_mm=174,height_mm=scene.height/4,min_text_pt=min(r['size_pt'] for r in scene.text_records),vector_pdf=True,embedded_fonts=[f[3] for f in fonts],tiff_dpi=600,tiff_compression='LZW',text_elements=len(scene.text_records))


def diagnostic_proofs(preview,directory,name,height):
    ImageOps.grayscale(preview).save(directory/f'{name}-grayscale.png')
    matrices={'deuteranopia':(.367322,.860646,-.227968,0,.280085,.672501,.047413,0,-.011820,.042940,.968881,0),
    'protanopia':(.152286,1.052583,-.204868,0,.114503,.786281,.099216,0,-.003882,-.048116,1.051998,0),
    'tritanopia':(1.255528,-.076749,-.178779,0,-.078411,.930809,.147602,0,.004733,.691367,.303900,0)}
    for label,matrix in matrices.items():preview.convert('RGB',matrix).save(directory/f'{name}-{label}.png')
    preview.resize((658,round(658*height/W)),Image.Resampling.LANCZOS).save(directory/f'{name}-final-size.png')


def write_notes(data,rows,out):
    text=['# Figures 1–2: provenance and display notes','','## Figure 1','',
    'The workflow is a functional grouping of representative real MCP tools. Response labels are explanatory summaries. Rejection and recovery counts appear in the legend only; no return arrow is drawn. Approval uses the public `arbiter review` command; archived inputs retain their historical names. The server proposes judgements from the official algorithm; adopted judgements may differ through a recorded override. AVATAR has no override.',
    '', '## Save-call rejection audit','',json.dumps(json.loads((HERE/'save-rejections-summary.json').read_text()),indent=2),
    '', 'The CSV has one row per unique tool-use ID, matched to its tool result across all turn logs. Trials come from the Sonnet domain-label file with the three design exclusions; exactly 102 are required. Rejected means an error flag or an explicit not-saved/error result. Reasons are classified from actual error details, not the scientific validity of a judgement. Accepted includes repeat successful saves. Chronology uses numeric turn ordering and unique call insertion order. All 47 trial-domain assessments with rejections ended with successful saves; none of the 510 domains lacked one. All 53 rejected calls have a later accepted save for their domain. One PALOMA-2 call omitted the domain entirely; its attribution to D1 is inferred from the explicit D1 retries immediately before and after it, asserted by the audit and marked in the CSV. One malformed JSON input retains a literal domain_id in its raw input. Counts describe Sonnet only; they are not a failure rate across all ARBITER models.',
    '', '## Figure 2','',f'Bundle SHA-256: `{data["bundle_sha256"]}`. Manifest content hashes checked at every build. Archived verifier: `{data["verification"]["result"]}`; this does not certify clinical correctness. Source hash prefixes identify searchable projections, not PDF bytes. Quotes preserve source text; whitespace wraps are collapsed. Two extraction line breaks are joined for legibility: assign-↵ment → assignment and cen↵sored → censored. No words are substituted. Ellipses denote omissions. Official question excerpts are shortened, with ellipses, from the RoB 2 wording.',
    '', 'AVATAR log correction: the rejected D3 save (`toolu_01CTHBEhdF5BAGdpapeh9D5F`) flattened the locator fields directly into the basis. The accepted retry (`toolu_01PN3CESV3Hj5VbcRRWKbc5E`) nested source/page/lines under `bases[].evidence`, an accepted source-span reference form; it did **not** submit an `eh_…` string. The server bound it as `eh_e66d374e838e8c6d`. Therefore the figure illustrates schema/binding validation, not a claim that literal handles are the only accepted syntax.\n\nPanel A follows six numbered steps: guidance, source reading, agent reasoning, save with citations, deterministic checks and algorithm, and review/export. Two source tags and their two matching context highlights show the registry and report evidence. Step 5 displays two of four cited searchable-projection hash prefixes. Panel B shows one short source phrase per domain, every active answer and every inactive branch, and aligned domain/Overall outputs. Panel C uses whole-trial tool counts, explicitly labelled this trial, because earlier reads served multiple domains. Counts include failed attempts and retries. The complete Unassisted D5 claim is verbatim; only its registered-time-frame phrase is outlined orange. The D4 note records its skipped 4.3 invalid path. Check/cross marks compare D5 with adjudicators’ consensus preferred judgement, Some concerns; they are not verifier verdicts. Published D5 is Low. The verifier is an archived structural/binding receipt. No without-Unassisted variant is produced. Full trace: eTable 31.','']
    text += ['## Bundle strip facts','',json.dumps(data['bundle_facts'],indent=2),'',
             'Captured sources (searchable projection hashes):','']
    for source in data['c']['batch']['trials'][0]['sources']:
        text.append(f"- `{source['label']}`: `{source['id']}`; `{source['projection_hash']}`.")
    text.append('')
    tool_notes=['## Workflow tool provenance','',f'ARBITER source commit: `{data["source_commit"]}`. Definitions: `src/arbiter/interfaces/mcp/server.py`.','']
    for phase,names in PHASES.items():
        tool_notes.append(phase+': '+', '.join(f'`{name}` (line {data["tool_lines"][name]})' for name in names)+'.')
    text[6:6]=tool_notes+['']
    for i,r in enumerate(rows,1):
        text += [f'### D{i}', '',QUESTIONS[i-1].split()[0]+': '+r['question'], '',f'Answer: {DISPLAY[r["a"]["answer"]]}. Proposed/adopted: {r["d"]["decision"]["proposed"]}/{r["d"]["decision"]["adopted"]}.', '', 'Full recorded justification:',r['a']['justification'],'','Selected justification excerpt (displayed only for D5 in A):',r['reason']+('…' if not r['reason'].endswith('.') else ''),'','Unknowns:',json.dumps(r['a']['unknowns'],ensure_ascii=False),'']
        pattern=[]
        active={a['question_id']:a['answer'] for a in r['d']['answers']}
        for qid,number in sorted(r['numbers'].items(),key=lambda item:tuple(map(int,item[1].split('.')))):
            pattern.append(number+': '+active.get(qid,'not asked (RoB 2 branching)')+' ['+qid+']')
        text += ['Full displayed server pattern:','; '.join(pattern),'']
        text += ['Panel B displayed evidence phrase: '+r['summary_quote'],'']
        shown=dict(r['shown'])
        for index,b in enumerate(r['bases']):
            quote=shown.get(index,'Not displayed; additional cited evidence.')
            ev=b['ev']
            text += [f'**{b["basis"]["kind"]}**: `{b["src"]["label"]}`, page {ev["page"]}, bound lines {ev["start_line"]}–{ev["end_line"]}.',f'Handle `{ev["handle"]}`; evidence `{ev["identity"]}`; source `{ev["source_id"]}`; source projection `{ev["source_version"]}`.','',f'Selected source excerpt (A shows the D5 pair; B uses the shorter phrase above): {quote}','','Full bound span:','',ev['quote'],'']
        if i==5:text+=['Displayed recorded gap: '+r['gap'],'']
        if i==4:text+=['Official 4.4 question: '+r['inference_question'],'Inference basis: '+json.dumps(r['inference_basis'],ensure_ascii=False),'Inference (no quotation displayed): '+r['inference']+'…','The inference basis still references the same bound evidence as 4.3. This inference is retained here for provenance; Panel B displays its PN answer chip without a reasoning box. The bound 4.3 span explicitly includes the DSMB unblinding sentence; there is no citation mismatch.','']
        text += ['Unassisted answers: '+r['unassisted_answers'].replace('\u00a0',' '),'',('Unassisted excerpt: ' if i in (4,5) else 'Archived unassisted excerpt (not displayed): ')+r['unassisted'],'','Unassisted full rationale: '+r['unassisted_full'],'']
    text += ['## Tool attribution and counts', '', json.dumps(data['tool_audit'],indent=2), '', 'Both D5 context passages were returned by read_pages toolu_01F15hTxheM7WBgGMfE4mYpa during D5. The report and registry had also been read earlier. Four windows were requested by that D5 read; the displayed source tags identify the narrower saved evidence spans, not the complete read windows. D5 used three get_domain_context pages, one read_pages call, one search_sources call, and two save attempts (the first rejected). The second D5 save reclassified registry evidence as context and was accepted. Panel C is a compact selection of whole-trial tool categories, not a complete count of all MCP calls. review_trial, close_trial and finalize_batch occurred once each; close_trial is omitted from the compact export step.', '']
    (out/'figure1-notes.md').write_text('\n'.join(text),encoding='utf8')


def main():
    p=argparse.ArgumentParser();p.add_argument('--data-root',type=Path,default=ROOT);p.add_argument('--logs-root',type=Path,required=True);p.add_argument('--arbiter-root',type=Path,required=True);args=p.parse_args()
    data=load(args.data_root,args.arbiter_root);rows=trace_data(data,args.data_root,args.logs_root)
    from figure2 import draw_trace, tool_audit
    data['tool_audit']=tool_audit(args.logs_root)
    out=ROOT/'analysis/output/manuscript';(out/'qa').mkdir(parents=True,exist_ok=True)
    from geometry import check
    scene=draw_trace(data,rows);geometry=check(scene)
    if not geometry['passed']:
        raise AssertionError(json.dumps(geometry,indent=2))
    qa=json.loads((HERE/'qa.json').read_text())
    qa.pop('Figure2-without-unassisted',None)
    qa['Figure2']=export_scene(scene,out,'Figure2',geometry)
    qa['Figure2']['bundle_facts']=data['bundle_facts']
    write_notes(data,rows,out)
    (HERE/'qa.json').write_text(json.dumps(qa,indent=2)+'\n')
    print(json.dumps(qa['Figure2'],indent=2))
if __name__=='__main__':main()
