"""Rebuild Figures 1–2 from archived assessments, logs, labels and ARBITER source.

All text is drawn from bundled OFL fonts as vector outlines; no system font lookup.
The scene is in quarter-millimetres: 696 units = 174 mm.
"""
from __future__ import annotations

import base64
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
        evidence_members=[n for n in z.namelist() if n.startswith('evidence/') and n.endswith('.json')]
        assert len(evidence_members)==len(c['proposal']['evidence'])==16
        source_records={src['id']:src for src in c['batch']['trials'][0]['sources']}
        for member in evidence_members:
            item=json.loads(z.read(member))
            assert item==c['proposal']['evidence'][item['identity']]
            assert item['source_version']==source_records[item['source_id']]['projection_hash']
            assert item['page']>=1 and 1<=item['start_line']<=item['end_line']
        assert c['report_format']=='none'

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
    assert '**Some concerns:** 5.1 No/Probably no/No information;' in guidance
    assert '**High:** 5.2 Yes/Probably yes; or 5.3 Yes/Probably yes.' in guidance
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

    def line(self, x1, y1, x2, y2, dotted=False, arrow=False, sw=1.8, kind=None):
        role = f' data-kind="{kind or "arrow"}"' if kind or arrow else ""
        dash = ' stroke-dasharray="1 6" stroke-linecap="round"' if dotted else ""
        self.add(f'<path d="M{x1},{y1} L{x2},{y2}" fill="none" stroke="{INK}" stroke-width="{sw}"{role}{dash}/>')
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


def draw_actor_icon(s,x,y,kind,scale=1):
    def rect(dx,dy,w,h):s.rect(x+dx*scale,y+dy*scale,w*scale,h*scale,'white',scale,INK,.8*scale)
    def line(x1,y1,x2,y2):s.line(x+x1*scale,y+y1*scale,x+x2*scale,y+y2*scale,sw=.8*scale)
    def dot(dx,dy,r):s.add(f'<circle cx="{x+dx*scale}" cy="{y+dy*scale}" r="{r*scale}" fill="{INK}"/>')
    if kind=='model':
        rect(0,3,14,11);line(7,0,7,3);dot(7,-1,1)
        for dx in (4,10):dot(dx,7,.8)
        line(4,11,10,11);line(-2,6,-2,11);line(16,6,16,11)
        line(7,14,7,18);rect(1,18,12,10)
        line(-2,20,-2,27);line(16,20,16,27)
        line(4,28,4,31);line(10,28,10,31)
    elif kind=='server':
        for dy in (0,11,22):
            rect(0,dy,14,7);dot(3,dy+3.5,.65);line(6,dy+3.5,11,dy+3.5)
    else:raise ValueError(kind)


def draw_source_icon(s,x,y,kind):
    if kind=='registry':
        s.rect(x,y+1,14,17,'white',2,INK,.8)
        s.line(x+1,y+6,x+13,y+6,sw=.7)
        for dy in (9,13):
            s.add(f'<circle cx="{x+3}" cy="{y+dy}" r=".65" fill="{INK}"/>')
            s.line(x+6,y+dy,x+11,y+dy,sw=.65)
    else:
        s.add(f'<path d="M{x},{y} H{x+9} L{x+14},{y+5} V{y+18} H{x} Z" fill="white" stroke="{INK}" stroke-width=".8" stroke-linejoin="round"/>')
        s.add(f'<path d="M{x+9},{y} V{y+5} H{x+14}" fill="none" stroke="{INK}" stroke-width=".8"/>')
        if kind=='amendment':
            s.add(f'<path d="M{x+3},{y+10} l2,2 l5,-5" fill="none" stroke="{INK}" stroke-width=".8"/>')
            s.line(x+3,y+15,x+11,y+15,sw=.8)
        else:
            for dy,length in [(9,8),(12,8),(15,5)]:s.line(x+3,y+dy,x+3+length,y+dy,sw=.65)

def draw_workflow(data):
    s=Scene();s.height=528
    s.description='Reviewer, AI model, rule-based server and audit file, ending in the actual AVATAR HTML report.'
    centers=[196,336,476,616]
    for phase,cx in zip(PHASES,centers):s.text(cx,16,phase,11,'bold',anchor='middle')
    draw_source_icon(s,25,3,'paper')
    s.text(47,15,'Trial reports + registry',10)
    s.line(150,13,168,13,arrow=True,sw=1)
    s.rect(12,28,672,38,'#F5F5F3',6,INK,1.5)
    s.add('<circle cx="32" cy="42" r="4" fill="white" stroke="#171717" stroke-width="1"/>')
    s.add('<path d="M25 59 Q25 48 32 48 Q39 48 39 59 Z" fill="white" stroke="#171717" stroke-width="1"/>')
    s.text(47,47,'Reviewer',11,'bold');s.text(47,61,'Person',10,color=GREY)
    for cx,first,second in [(196,'Chooses the trial','and outcome'),(336,'Approves the result','arbiter review'),(616,'Receives','HTML report + audit file')]:
        s.text(cx,46,first,11,'bold',anchor='middle')
        s.text(cx,61,second,10,'mono' if cx==336 else 'regular',GREY if cx==336 else INK,anchor='middle')
    s.line(402,49,476,49,sw=1,kind="connector");s.line(476,49,476,73,arrow=True,sw=1)
    s.rect(12,77,672,49,LAVENDER,6,INK,1.5)
    draw_actor_icon(s,25,88,'model')
    s.text(47,94,'LLM agent',11,'bold',LLM)
    s.text(47,107,'Follows the',10,color=GREY);s.text(47,119,'assessment guide',10,color=GREY)
    for cx,top,bottom in zip(centers,['Locate trial reports','Specify the outcome','Read text or page images','Review the answers'],['and registry records','and analysis to assess','Select and cite evidence','and supporting evidence']):
        if cx==476:
            for y,label in zip([92,105,118],[top,bottom,'Answer RoB 2 questions']):s.text(cx,y,label,10,'bold',LLM,anchor='middle')
        else:
            s.text(cx,96,top,10,'bold',LLM,anchor='middle');s.text(cx,113,bottom,10,'bold',LLM,anchor='middle')
    for x in [266,406,546]:s.line(x,84,x,119,dotted=True,sw=.6)
    visible=[['prepare_batch','list_sources','search_sources','search_sources_batch'],['validate_proposal','save_proposal'],['get_domain_context','read_pages','render_page','select_text_evidence','select_visual_evidence','save_domain_judgment'],['review_trial','finalize_batch']]
    assert all(data['tool_audit']['counts'].get(t,0)>0 for t in ['search_sources','search_sources_batch','read_pages'])
    for cx,tools in zip(centers,visible):
        track={476:398,616:554}.get(cx,cx-70)
        s.line(track,126,track,202,arrow=True,sw=1)
        s.line(track,202,track,126,arrow=True,sw=1)
        for y,tool in zip({2:[148,180],4:[140,156,172,188],6:[140,151,162,173,184,195]}[len(tools)],tools):
            s.text(cx,y,tool,10,'mono',GREY,anchor='middle')
    s.rect(12,204,672,60,MINT,6,INK,1.5)
    draw_actor_icon(s,25,218,'server')
    s.text(47,225,'ARBITER server',11,'bold')
    s.text(47,238,'Rule-based software',10);s.text(47,250,'No AI',10)
    for cx,phrases in zip(centers,[['Store an unchangeable','copy of each source'],['Check and record','the choice'],['Check every quote','Apply the RoB 2 rules'],['Keep the full record','Package the audit file','Write the HTML report']]):
        for j,phrase in enumerate(phrases):s.text(cx,(231 if len(phrases)==2 else 218)+j*12,phrase,10,'bold',anchor='middle')
    s.text(616,256,'arbiter report',10,'mono',GREY,anchor='middle')
    for x in [266,406,546]:s.line(x,211,x,257,dotted=True,sw=.6)
    # Export gives the reviewer two concrete outputs; the fork remains below all text.
    s.line(616,264,616,286,arrow=True,sw=1)
    s.line(616,277,165,277,sw=1,kind="connector");s.line(165,277,165,330,arrow=True,sw=1)
    visual_source=Path('C:/Users/Ali-Salman/Documents/Code/rob2-kit/src/rob2_kit/application/evidence.py').read_text(encoding='utf8')
    for tool in ('render_page','select_visual_evidence','select_text_evidence'):
        assert 'def '+tool+'(' in visual_source
        assert data['tool_audit']['counts'].get(tool,0)==0
    s.rect(12,334,306,78,YELLOW,6,INK,1.5)
    s.text(165,351,'Audit file',12,'bold',anchor='middle')
    s.text(165,366,'.arbiter.zip',10,'mono',anchor='middle')
    s.text(165,384,'Every source, quote, answer',11,anchor='middle')
    s.text(165,399,'and decision',11,anchor='middle')
    # Focus on the actual domain-results area; full table and trial-page captures remain in QA.
    path=HERE/'qa/avatar-html-report-domain-view.png'
    meta=json.loads((HERE/'qa/avatar-html-report-domain-view.json').read_text())
    image=Image.open(path);iw=312;ih=iw*image.height/image.width
    min_font=meta['min_font_css_px']*iw/meta['clip_css_px']['width']*72/101.6
    assert min_font>=7
    s.rect(364,290,320,28+ih,'#F5F5F3',5,INK,1.2)
    s.text(375,305,'ARBITER · AVATAR · HTML report',10,'bold')
    encoded=base64.b64encode(path.read_bytes()).decode()
    s.add(f'<image x="368" y="314" width="312" height="{ih}" href="data:image/png;base64,{encoded}"/>')
    s.report_image=dict(path=path,x=368,y=314,w=312,h=ih,min_text_pt=min_font)
    s.rect(12,461,306,33,'white',5,INK,1.2)
    s.add('<path d="M25 469 L32 467 L39 469 V476 Q39 481 32 485 Q25 481 25 476 Z" fill="white" stroke="#171717" stroke-width=".9" stroke-linejoin="round"/>')
    s.add('<path d="M28 475 l3 3 l5 -6" fill="none" stroke="#171717" stroke-width="1.1" stroke-linecap="round" stroke-linejoin="round"/>')
    s.text(47,482,'Checkable by an independent verifier',10,'bold')
    s.line(165,412,165,457,arrow=True,sw=1)
    s.line(364,445,340,445,sw=1,kind="connector");s.line(340,445,340,477,sw=1,kind="connector")
    s.line(340,477,322,477,arrow=True,sw=1)
    s.tool_stack=visible[2]
    return s

# Figure 2: verbatim selections are asserted against archived evidence/reasoning.
DOMAINS=['randomization','deviations','missing','measurement','selection']
SELECTED=['baseline-imbalance','context-deviations','data-available','assessor-aware','prespecified-analysis']
QUESTIONS=['1.3 Did baseline differences between intervention groups suggest a problem with the randomization process?',
'2.3 Were there deviations from the intended intervention that arose because of the trial context?',
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
            assert a['answer']==['no','probably_no','yes','yes','no_information'][i]
            assert d['decision']['proposed']==d['decision']['adopted'] and d['decision']['adjudication'] is None
            bases=[]
            for b in a['bases']:
                ev=json.loads(z.read('evidence/'+b['evidence'].split(':')[1]+'.json'))
                src=next(s for s in c['batch']['trials'][0]['sources'] if s['id']==ev['source_id'])
                assert src['projection_hash']==ev['source_version']
                assert c['proposal']['evidence'][b['evidence']]==ev
                assert norm(b['source'])==norm(ev['quote'])
                assert 1<=ev['start_line']<=ev['end_line'] and ev['page']>=1
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
    r[0]['reason']=r[0]['a']['justification']
    r[1]['reason']=r[1]['a']['justification']
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
    r[4]['reason']=r[4]['a']['justification']
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
    assert (answered,inactive,evidence_count,len(sources))==(15,7,16,7)
    assert len({ev['source_id'] for ev in c['proposal']['evidence'].values()})==4
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
    # Grep the final SVG's semantic strings, not merely the drawing inputs.
    svg_labels=[html.unescape(label) for label in re.findall(r'aria-label="(.*?)"',svg)]
    assert svg_labels==[r['text'] for r in scene.text_records]
    if name=='Figure2':
        traced=list(csv.DictReader((HERE/'figure2-text-provenance.csv').open(encoding='utf8')))
        for p in traced:
            for line in json.loads(p['svg_text_lines']):assert line in svg_labels,(line,'missing from final SVG')
    assert not re.search('rob2',svg,re.I),'Legacy name in rendered text'
    png=resvg_py.svg_to_bytes(svg_string=svg,width=1644,dpi=96,skip_system_fonts=True)
    # Windows viewers may memory-map the previous image; replace instead of truncating it.
    temporary_png=out/f'.{name}.render.png'
    temporary_png.write_bytes(png)
    temporary_png.replace(out/f'{name}.png')
    proof_dir=out if out.name=='qa' else out/'qa'
    (out/f'{name}.svg').write_text(svg,encoding='utf8')
    # PDF uses the same positions with subset-embedded TrueType fonts. SVG remains outlined.
    from reportlab.pdfgen.canvas import Canvas
    from reportlab.lib.colors import HexColor
    pdf_svg=re.sub(r'<g aria-label=.*?</g>','',svg,flags=re.S)
    pdf_svg=re.sub(r'<image .*?/>','',pdf_svg)
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
        canvas.setStrokeColor(HexColor('#DDDDDA'));canvas.setLineWidth(.4)
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
    if hasattr(scene,'report_image'):
        from reportlab.lib.utils import ImageReader
        r=scene.report_image
        canvas.drawImage(ImageReader(str(r['path'])),r['x']*factor,(scene.height-r['y']-r['h'])*factor,width=r['w']*factor,height=r['h']*factor)
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
        image_count=len(page.get_images())
        assert image_count==(1 if hasattr(scene,'report_image') else 0)
        fonts=page.get_fonts(full=True)
        assert fonts and all('Fira' in f[3] and f[1]=='ttf' for f in fonts),fonts
        assert all(len(pdf.extract_font(f[0])[3])>0 for f in fonts),'Missing embedded font bytes'
        assert not re.search('rob2',page.get_text(),re.I)
        if name=='Figure2':assert not re.search(r'eh_|sha256|_|span|adopted|proposal',page.get_text(),re.I)
        pix=page.get_pixmap(dpi=600,alpha=False)
        image=Image.frombytes('RGB',(pix.width,pix.height),pix.samples)
        image.save(out/f'{name}.tiff',compression='tiff_lzw',dpi=(600,600))
        with Image.open(out/f'{name}.tiff') as tif:
            assert tif.tag_v2[259]==5 and tuple(tif.info['dpi'])==(600,600)
        proof=page.get_pixmap(dpi=160,alpha=False)
        Image.frombytes('RGB',(proof.width,proof.height),proof.samples).save(proof_dir/f'{name}-pdf.png')
    preview=Image.open(io.BytesIO(png)).convert('RGB')
    diagnostic_proofs(preview,proof_dir,name,scene.height)
    return dict(geometry=geometry,width_mm=174,height_mm=scene.height/4,min_text_pt=min(r['size_pt'] for r in scene.text_records),vector_pdf=not hasattr(scene,'report_image'),vector_diagram=True,raster_images=image_count,embedded_fonts=[f[3] for f in fonts],tiff_dpi=600,tiff_compression='LZW',text_elements=len(scene.text_records))


def diagnostic_proofs(preview,directory,name,height):
    ImageOps.grayscale(preview).save(directory/f'{name}-grayscale.png')
    matrices={'deuteranopia':(.367322,.860646,-.227968,0,.280085,.672501,.047413,0,-.011820,.042940,.968881,0),
    'protanopia':(.152286,1.052583,-.204868,0,.114503,.786281,.099216,0,-.003882,-.048116,1.051998,0),
    'tritanopia':(1.255528,-.076749,-.178779,0,-.078411,.930809,.147602,0,.004733,.691367,.303900,0)}
    for label,matrix in matrices.items():preview.convert('RGB',matrix).save(directory/f'{name}-{label}.png')
    preview.resize((658,round(658*height/W)),Image.Resampling.LANCZOS).save(directory/f'{name}-final-size.png')


def write_notes(data,rows,out):
    text=['# Figures 1–2: provenance and display notes','',
          'The workflow uses plain labels above representative real MCP calls. Tool definitions and the public audit-file extension are checked against ARBITER source commit `'+data['source_commit']+'`. The frozen rejection audit remains in save-rejections.csv and its summary JSON.',
          '', '## AVATAR storyboard', '',
          'The registry title identifies aortic valve replacement versus conservative treatment in asymptomatic severe aortic stenosis (AVATAR). Early surgery versus watchful waiting is the reader-facing description of this comparison. The requested outcome is all-cause death. Source letters: A = Circulation 2022 report; B = Eur Heart J 2024 report; C = ClinicalTrials.gov NCT02436655 (first submitted 2015); D = surgical-delay protocol amendment dated 4 Jan 2021. Page numbers refer to the respective stored source record.',
          '', 'Source quotations are verbatim selections with ellipses for omissions and normalized extraction whitespace. Two extraction breaks are joined: assign-↵ment and cen↵sored. Questions are paraphrased; official wording is retained below and in eTable 31. Model reasons are verbatim excerpts, with ellipses for omissions.',
          '', 'Every manifest hash and source-version binding is checked at build time. The archive stores source identities and evidence quotations, rather than complete trial PDFs. Source-version identities bind each quote to its stored text copy and remain asserted internally. Fingerprints and their explanation are omitted from the displayed figure. Archived independent-verifier receipt: '+data['verification']['result']+'; this is a structure/evidence-binding check, not a clinical judgement.',
          '', 'D5 rule checked against the scientific-pack selection.md Algorithm section: High if 5.2 or 5.3 is Yes/Probably yes; otherwise Some concerns if 5.1 is No/Probably no/No information, or 5.2/5.3 is No information. NI/PN/PN therefore yields Some concerns. The overall.any_concerns rule is asserted from the bundle; the figure describes this trial, where no domain is High.',
          '', 'Both adjudicators preferred D5 Some concerns; Published D5 is Low. Overall was not adjudicated. The Without ARBITER comparison strip has been removed.',
          '', 'Bundle SHA-256: `'+data['bundle_sha256']+'`. AVATAR is illustrative, not representative.',
          '', '## Save-call rejection audit', '',json.dumps(json.loads((HERE/'save-rejections-summary.json').read_text()),indent=2)]
    text += ['', '## Fixed recorded-rule display mapping', '', 'Algorithm text is read from rob2-kit commit 2848c7926a2acc25402345a42be39d695a99861a, the exact run build. No model-generated clinical interpretation is placed in the ARBITER column. Each domain trace ID is asserted to match its adopted result; driver question IDs select the outlined chip and its official number.']
    pack=Path('C:/Users/Ali-Salman/Documents/Code/rob2-kit/src/rob2_kit/skills/rob2-assess/references')
    for domain in DOMAINS:
        path=pack/(domain+'.md');content=path.read_text(encoding='utf8').splitlines()
        begin=content.index('## Algorithm')+1
        end=next((j for j in range(begin,len(content)) if content[j].startswith('## ')),len(content))
        text += ['', f'- `{domain}.md:{begin}–{end}`: '+ ' '.join(content[begin:end]).strip()]
    text += ['', '- `src/rob2_kit/logic/evaluator.py:361`: recorded `overall.any_concerns`; plain-language wording agrees with `src/rob2_kit/application/report.py:47` (at least one Some concerns and no High).', '- The four Low trace IDs map to the visible “Low” result pills; `selection.some_concerns` maps to the “Some concerns” result pill. Repeated per-row rule labels are omitted because the header names the software’s RoB 2 rule role. The additional D5 line is “decided by question 5.1”, mapped from recorded driver_questions. The complete semantic SVG text audit is analysis/figure1/figure2-text-provenance.csv; every row string in the source, AI and software/result columns is covered, with only the fixed Weighed against/Open point structural labels exempted.']
    for i,r in enumerate(rows,1):
        text += ['',f'## Domain {i}', '',r['question'],'',
                 'Displayed source quotation(s): '+r['summary_quote'],'',
                 'Displayed model justification (verbatim excerpt): '+r['displayed_justification'],'','Full recorded selected-answer justification: '+r['a']['justification'],'',
                 'Unknowns: '+json.dumps(r['a']['unknowns'],ensure_ascii=False),'',
                 'Complete answers, inactive branches and decision:',json.dumps(dict(answers=r['d']['answers'],inactive=r['d']['inactive_questions'],decision=r['d']['decision']),ensure_ascii=False,indent=2),'',
                 'Full selected-answer evidence:',json.dumps(r['bases'],ensure_ascii=False,indent=2)]
        if i==4:text += ['', '4.4 reasoning basis: '+json.dumps(r['inference_basis'],ensure_ascii=False),'',r['inference']]
        if i==5:text += ['', 'The exact run-build HTML render succeeded. Product-name-only substitutions are proved in analysis/figure1/qa/html-report-relabel.md; the original and relabelled renders are retained. Figure 1 shows the actual trial page’s five domain-navigation results and first domain card in a framed detail. The full trial page and full summary table are retained separately. The responsive viewport is native HTML, with no injected styling.']
    (out/'figure1-notes.md').write_text('\n'.join(text)+'\n',encoding='utf8')


def main():
    p=argparse.ArgumentParser();p.add_argument('--data-root',type=Path,default=ROOT);p.add_argument('--logs-root',type=Path,required=True);p.add_argument('--arbiter-root',type=Path,required=True);args=p.parse_args()
    from relabel_report import main as relabel_report
    relabel_report()
    data=load(args.data_root,args.arbiter_root);rows=trace_data(data,args.data_root,args.logs_root)
    from figure2 import draw_trace, tool_audit
    data['tool_audit']=tool_audit(args.logs_root)
    out=ROOT/'analysis/output/manuscript';(out/'qa').mkdir(parents=True,exist_ok=True)
    from geometry import check
    workflow=draw_workflow(data)
    workflow_geometry=check(workflow)
    assert workflow.height/4<=132
    assert workflow_geometry['passed'],json.dumps(workflow_geometry,indent=2)
    scene=draw_trace(data,rows);geometry=check(scene)
    if not geometry['passed']:
        raise AssertionError(json.dumps(geometry,indent=2))
    qa=json.loads((HERE/'qa.json').read_text())
    qa.pop('Figure2-without-unassisted',None)
    qa['Figure1']=export_scene(workflow,out,'Figure1',workflow_geometry)
    qa['Figure2']=export_scene(scene,out,'Figure2',geometry)
    qa['Figure2']['bundle_facts']=data['bundle_facts']
    qa['Figure2']['reader_jargon_guard']=True
    qa['Figure2']['all_quotes_answers_labels_asserted']=True
    qa['Figure1']['raster_report_thumbnail']=workflow.report_image['min_text_pt']
    qa['Figure2']['text_provenance_asserted']=True
    write_notes(data,rows,out)
    (HERE/'qa.json').write_text(json.dumps(qa,indent=2)+'\n')
    print(json.dumps(qa['Figure2'],indent=2))
if __name__=='__main__':main()
