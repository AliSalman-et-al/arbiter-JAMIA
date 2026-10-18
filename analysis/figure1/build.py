"""Rebuild Figure 1 from the archived assessment, labels and ARBITER source.

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
from fontTools.ttLib import TTFont
from PIL import Image, ImageOps
from reportlab.graphics import renderPDF
from reportlab import rl_config
from svglib.svglib import svg2rlg

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
SLUG = "banovic26-avatar-2024"
W, H = 696, 816
INK = "#171717"
BLUE = "#00A1D5"
LLM = "#555DB3"
LAVENDER = "#E6E4F5"
MINT = "#E4F2EA"
YELLOW = "#FFF7D6"
HILITE = "#FFEA83"
GREY = "#626262"
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
        self.fonts = {k: TTFont(HERE / "fonts" / filename) for k, filename in {
            "regular": "FiraSansCondensed-Regular.ttf", "bold": "FiraSansCondensed-Bold.ttf",
            "mono": "FiraCode-Regular.ttf"}.items()}

    def add(self, s):
        self.parts.append(s)

    def rect(self, x, y, w, h, fill="white", r=10, stroke=INK, sw=2):
        self.add(f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="{r}" fill="{fill}" stroke="{stroke}" stroke-width="{sw}"/>')

    def line(self, x1, y1, x2, y2, dotted=False, arrow=False, sw=1.8):
        dash = ' stroke-dasharray="1 6" stroke-linecap="round"' if dotted else ""
        self.add(f'<path d="M{x1},{y1} L{x2},{y2}" fill="none" stroke="{INK}" stroke-width="{sw}"{dash}/>')
        if arrow:
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
        self.text_records.append(dict(text=value, size_pt=size * 72/101.6, x=x, baseline=y, width=width))
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
        self.rect(x, y-13, width, 21, fill, 8, sw=1.2)
        self.text(x+7, y+1, text, size, face)
        return width

    def svg(self):
        return (f'<svg xmlns="http://www.w3.org/2000/svg" width="174mm" height="{H/4}mm" viewBox="0 0 {W} {H}" role="img">'
                '<title>ARBITER workflow and an AVATAR Domain 5 answer traced to source evidence</title>'
                '<desc>Reviewer approval precedes domain assessment. The agent answers questions; the deterministic server computes judgements. AVATAR question 5.1 is No information.</desc>'
                '<rect width="100%" height="100%" fill="white"/>' + ''.join(self.parts) + '</svg>')


def draw(data):
    s = Scene()
    # Panel A: four horizontal lanes, four left-to-right phases.
    s.text(12, 23, "A", 19, "bold")
    s.text(35, 23, "How ARBITER works", 17, "bold")
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
    s.line(412, 99, 420, 99)
    s.line(420, 99, 420, 119)
    s.line(420, 119, 480, 119)
    s.line(480, 119, 480, 146, arrow=True)
    s.text(480, 111, "unlocks domain work", 10.2, anchor="middle")

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
        s.line(cx-61, 216, cx-61, 300, arrow=True, sw=1.4)
        s.line(cx+61, 300, cx+61, 216, arrow=True, sw=1.4)
        for y, call in zip([239, 262], calls):
            assert s.width(call, 10.2, "mono") * .92 < 118
            s.text(cx, y, call, 10.2, "mono", anchor="middle", stretch=.92)
        s.text(cx, 287, response, 10.5, anchor="middle", italic=True)

    s.rect(12, 300, 672, 77, MINT, 11, sw=2.3)
    s.text(25, 322, "ARBITER server", 13.5, "bold")
    s.text(25, 341, "deterministic;", 10.5)
    s.text(25, 357, "no model calls", 10.5)
    for cx, top, bottom in zip(centers,
            ["Capture sources", "Validate & store", "Check cited spans", "Record history"],
            ["Bind their versions", "the result proposal", "Compute judgements", "Verify & package"]):
        s.text(cx, 328, top, 11.5, "bold", anchor="middle")
        s.text(cx, 348, bottom, 11.2, anchor="middle")
    for x in [282, 414, 546]:
        s.line(x, 311, x, 365, dotted=True, sw=1)
    s.line(612, 377, 612, 395, arrow=True)
    s.rect(12, 395, 672, 43, YELLOW, 10, sw=2)
    s.text(25, 421, "Bundle", 13, "bold")
    s.text(155, 412, "Source identities + bound evidence + complete history", 11.5)
    s.text(155, 430, "Checked by an independent verifier", 11.5)
    s.text(612, 421, ".arbiter.zip", 10.5, "mono", anchor="middle")
    s.line(12, 452, 684, 452, dotted=True)

    # Panel B: source, answer and algorithm are separate visual objects.
    s.text(12, 479, "B", 19, "bold")
    s.text(35, 479, "One answer, traced", 17, "bold")
    s.text(684-s.width(data["trace_title"], 12), 479, data["trace_title"], 12, color=GREY)
    s.text(12, 517, "ARBITER", 12, "bold", BLUE)
    positions = [130, 212, 294, 376, 470, 616]
    for name, cx in zip(["D1", "D2", "D3", "D4", "D5", "Overall"], positions):
        value = data["labels"][f"rob2kit_{name}"]
        fill = "#DFF2F8" if name in ["D5", "Overall"] else "#F5F6F6"
        width = 128 if name == "Overall" else (108 if name == "D5" else 74)
        s.rect(cx-width/2, 491, width, 42, fill, 7, sw=1.3)
        s.text(cx, 506, name, 10.5, color=GREY, anchor="middle")
        s.text(cx, 524, value, 11.6, "bold", anchor="middle")
    s.line(527, 513, 548, 513, arrow=True, sw=1.4)

    s.rect(12, 549, 321, 144, "#F5F5F3", 11, sw=2.2)
    s.text(25, 571, "Cited passage", 12.5, "bold")
    s.text(25, 588, data["source"]["label"], 10.5, color=GREY)
    ev = data["evidence"]
    s.text(25, 604, f"Page {ev['page']} · bound span: lines {ev['start_line']}–{ev['end_line']}", 10.5, color=GREY)
    # Yellow is reserved for source text and its reference within the reasoning.
    s.pill(25, 631, data["first"], 11.2, face="regular")
    s.pill(25, 657, "… " + data["last"], 11.2, face="regular")
    s.text(25, 682, "Context cited for 5.1; excerpt shortened", 10.5, color=GREY)

    s.line(333, 624, 352, 624, arrow=True)
    s.rect(352, 549, 332, 144, LAVENDER, 11, sw=2.2)
    s.text(365, 571, "5.1  Was the analysis prespecified?", 12.5, "bold", LLM)
    s.pill(365, 595, DISPLAY[data["answer"]["answer"]], 12, fill="#F4F3FA")
    s.text(365, 634, "Report", 11.5)
    s.pill(400, 633, "calls the endpoint prespecified", 11.5, face="regular")
    s.text(365, 661, "No dated analysis plan captured → 5.1 = NI.", 11.5, "bold")

    s.rect(12, 707, 672, 74, MINT, 10, sw=2)
    s.line(25, 752, 671, 752, sw=.6)
    answers = data["d"]["answers"]
    answer_short = {"no_information": "NI", "probably_no": "PN", "probably_yes": "PY", "yes": "Y", "no": "N"}
    answer_set = " · ".join(f"5.{i} {answer_short[a['answer']]}" for i, a in enumerate(answers, 1))
    s.text(25, 724, "D5 answer set", 10.5, color=GREY)
    s.text(25, 741, answer_set, 12, "bold")
    s.line(219, 730, 249, 730, arrow=True)
    s.text(260, 724, "Official RoB 2 algorithm", 10.5, color=GREY)
    s.text(260, 741, "Proposed: " + DISPLAY[data["d"]["decision"]["proposed"]], 12, "bold")
    s.text(488, 724, "Adopted judgement", 10.5, color=GREY)
    s.text(488, 741, DISPLAY[data["d"]["decision"]["adopted"]] + " (no override)", 12, "bold")

    s.text(25, 770, f"Span bound to source version · SHA-256 {ev['source_version'].split(':')[1][:12]}…", 10.5)
    verifier = "Bundle verifier: " + data["verification"]["result"]
    s.text(671-s.width(verifier, 10.5, "bold"), 770, verifier, 10.5, "bold")
    footer = [("Published:", data["published"]["D5"], "#374E55"),
              ("Adjudicators:", data["adjud"]["preferred"], INK),
              ("Unassisted:", data["unassisted"]["model_D5"], "#DF8F44")]
    x = 12
    for i, (label, value, color) in enumerate(footer):
        s.text(x, 800, label, 12, color=GREY)
        x += s.width(label, 12) + 4
        s.text(x, 800, value, 12, "bold", color)
        x += s.width(value, 12, "bold") + 12
        if i < 2:
            s.text(x, 800, "·", 12)
            x += 13
    return s


def notes(data):
    ev = data["evidence"]
    lines = ["# Figure 1 notes", "", "## Tool-to-phase grouping", "",
             "ARBITER 1.0.0. Line references below are to `src/arbiter/interfaces/mcp/server.py` in the ARBITER source checkout. The figure shows representative tools, without server prefixes. This is a functional grouping, not an assertion that tools can run only in one phase.", ""]
    for phase, tools in PHASES.items():
        lines.append(f"- **{phase}:** " + ", ".join(f"`{t}` (line {data['tool_lines'][t]})" for t in tools) + ".")
    lines += ["", "Capture freezes source bytes and searchable projections. Companion acquisition/admission can also occur later; admission invalidates the affected review. `read_pages`, `search_sources`, `list_sources`, `read_guidance`, `get_status`, and working checkpoints support more than one phase. `calculate_arithmetic` is optional stateless arithmetic, not judgement generation. `save_domain_judgment` accepts the agent's answers, binds evidence and invokes the official algorithm. `review_trial` computes/reviews the overall result; `close_trial` closes its current review; `finalize_batch` packages already-final trial records. `request_proposal_approval` requests human approval through MCP elicitation; the figure uses the public `arbiter review` command (the archived run used its pre-rename equivalent). It is not an agent self-approval. Downward arrows carry representative tool calls; upward arrows carry short illustrative response labels: source list, validation result, proposed judgement and review report. These are response summaries, not literal response payloads. A separate arrow leads to the packaged `.arbiter.zip` artifact. `list_sources` is shown in Capture; `read_pages` remains grouped with assessment because it supports repeated reading.",
              "", "Skill reference: `src/arbiter/skills/arbiter-assess/references/selection.md`, question 5.1. The skill supplies the question-by-question guidance; the server makes no model calls.",
              "", "## Exact trace", "",
              f"- Trial: `{SLUG}`; outcome: all-cause death, long-term follow-up. Bundle SHA-256: `{data['bundle_sha256']}`.",
              f"- Question 5.1: {data['question']}",
              f"- Answer: **{DISPLAY[data['answer']['answer']]}**; this question is the recorded D5 driver.",
              f"- Figure excerpt ({len(data['excerpt'].split())} words, one omission): “{data['excerpt']}”.",
              f"- File: `{data['source']['label']}`, physical page {ev['page']}; bound evidence span lines {ev['start_line']}–{ev['end_line']}, character offsets [{ev['start']}, {ev['end']}). The excerpt components are on lines {data['excerpt_lines'][0]} and {data['excerpt_lines'][1]}; ellipsis omits intervening secondary endpoints.",
              f"- Evidence: `{ev['identity']}` / `{ev['handle']}`; source ID `{ev['source_id']}`.",
              f"- Source version (searchable projection SHA-256): `{ev['source_version']}`. The figure displays its first 12 hex characters, not the PDF byte hash.",
              f"- Captured PDF byte SHA-256: `{data['source']['sha256']}`.",
              "- Binding semantics: this basis is recorded as **context**, not direct support. The report's use of 'prespecified' does not establish when the plan was finalized. Yellow links the quoted passage to the words “calls the endpoint prespecified” in the recorded-reasoning summary. The No information answer has a neutral pill. The context quote alone does not prove that a plan is missing.",
              "", "Recorded justification:", "", data["answer"]["justification"], "",
              "Full server-extracted passage:", "", "> " + ev["quote"].replace("\n", "\n> "), "",
              "D5 answer set: " + "; ".join(f"5.{i}: {DISPLAY[a['answer']]}" for i,a in enumerate(data['d']['answers'],1)) + ". NI = No information; PN = Probably no.",
              f"Proposed and adopted: {DISPLAY[data['d']['decision']['proposed']]} / {DISPLAY[data['d']['decision']['adopted']]}; authority: {data['d']['decision']['authority']}; no override. Verification result: `{data['verification']['result']}` (from archived verification.json; the build does not re-run the independent verifier).",
              "", "Label sources: `rob2-meta-benchmark-set/LABEL-TARGETS.csv`; `kit-sonnet-5.5/rob2kit-domain-labels.csv`; `no-kit-sonnet-5.5/model-domain-labels.csv`; `analysis/output/tables/adjudication-analysis-cells.csv` (both adjudicators' preferred labels agree). All are loaded at build time; the ARBITER D5 label is checked against the bundle.",
              f"ARBITER source commit inspected: `{data['source_commit']}`. The build checks all archived manifest content hashes; it reads, rather than re-runs, the archived verifier receipt.",
              "", "## Draft legend", "",
              "**Figure 1. ARBITER workflow and evidence trace.** (A) A reviewer approves the result to be assessed before domain assessment starts. The LLM agent uses the arbiter-assess skill to read sources and answer RoB 2 signalling questions. The model-free ARBITER MCP server captures and versions sources, binds cited text spans, computes domain and overall judgements using the official RoB 2 algorithms, records the assessment history and exports a verifiable bundle. Representative MCP calls are shown in monospace on downward request arrows; upward arrows carry italic response summaries. Approval through `arbiter review` unlocks domain work; the reviewer receives a report and a `.arbiter.zip` bundle checked by an independent verifier. Tools used across phases are grouped by function in these notes. (B) AVATAR, all-cause death at long-term follow-up: the report describes time to death as prespecified, but the agent records no information for question 5.1 because the captured sources do not establish a plan for this measurement and analysis finalized before unblinded outcome data were available. Yellow highlighting links the report excerpt, recorded as context, to the passage-referencing words in the reasoning; the answer pill is neutral. The complete D5 answer set produces Some concerns, adopted without override. The hash prefix identifies the captured source projection; archived bundle verification confirms binding and structural checks, not the clinical correctness of the answer. Published and Unassisted judgements are Low; both adjudicators prefer Some concerns. D1–D5, RoB 2 domains; NI, no information; PN, probably no; MCP, Model Context Protocol.",
              "", "## Alt text", "",
              "Two panels. A: Reviewer, lavender LLM agent, mint deterministic ARBITER server and pale-yellow bundle lanes span Capture, Propose and approve, Assess each domain, and Review and export. Reviewer approval via arbiter review unlocks domain work. The reviewer receives a report and verifiable .arbiter.zip bundle. Downward tool-call arrows and upward response arrows connect agent and server. The agent supplies cited answers; the server checks spans and computes judgements. B: AVATAR has Low judgements for D1–D4 and Some concerns for D5 and Overall. A cited passage calls time to death a prespecified secondary endpoint. Yellow links that quoted passage to the reasoning phrase “calls the endpoint prespecified”. A neutral pill gives question 5.1 as No information because a dated plan is not established by captured sources. D5 answers NI, PN, PN yield Some concerns, adopted unchanged. The passage is bound to a hashed captured source; archived bundle verification is verified. Published Low; adjudicators Some concerns; Unassisted Low.", ""]
    return "\n".join(lines)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--data-root", type=Path, default=ROOT)
    parser.add_argument("--arbiter-root", type=Path, required=True)
    args = parser.parse_args()
    data = load(args.data_root, args.arbiter_root)
    scene = draw(data)
    out = ROOT / "analysis/output/manuscript"
    out.mkdir(parents=True, exist_ok=True)
    svg = scene.svg()
    assert not re.search("rob2", svg, re.I), "Pre-rename identifier in SVG text"
    (out / "Figure1.svg").write_text(svg, encoding="utf-8")
    rl_config.invariant = True
    drawing = svg2rlg(io.BytesIO(svg.encode()))
    renderPDF.drawToFile(drawing, str(out / "Figure1.pdf"))
    # ReportLab registers an unused Times-Roman font and emits an empty BT/ET
    # preamble even for a path-only scene. Remove it and compress the PDF.
    with fitz.open(out / "Figure1.pdf") as pdf:
        page = pdf[0]
        assert not page.get_text().strip()
        for xref in page.get_contents():
            stream = pdf.xref_stream(xref)
            pdf.update_stream(xref, re.sub(rb"\bBT\b.*?\bET\b", b"", stream, flags=re.S))
        pdf.xref_set_key(page.xref, "Resources/Font", "<<>>")
        vector_pdf = pdf.tobytes(garbage=4, deflate=True, no_new_id=True)
    (out / "Figure1.pdf").write_bytes(vector_pdf)
    # resvg renders exactly the same outlined SVG, independently of PDF export.
    png = resvg_py.svg_to_bytes(svg_string=svg, width=1644, dpi=96, skip_system_fonts=True)
    (out / "Figure1.png").write_bytes(png)
    with fitz.open(out / "Figure1.pdf") as pdf:
        page = pdf[0]
        assert abs(page.rect.width - 174*72/25.4) < .02
        assert len(page.get_images()) == 0, "PDF must contain vector paths, no raster image"
        pix = page.get_pixmap(dpi=600, alpha=False)
        image = Image.frombytes("RGB", (pix.width, pix.height), pix.samples)
        image.save(out / "Figure1.tif", compression="tiff_lzw", dpi=(600,600))
        pdf_preview = page.get_pixmap(dpi=240, alpha=False)
        Image.frombytes("RGB", (pdf_preview.width,pdf_preview.height), pdf_preview.samples).save(HERE / "qa-pdf.png")
    preview = Image.open(io.BytesIO(png)).convert("RGB")
    ImageOps.grayscale(preview).save(HERE / "qa-grayscale.png")
    # Approximate diagnostic preview: Machado deuteranopia matrix on display RGB.
    # Grayscale remains the stronger check that no judgement relies on hue.
    preview.convert("RGB", (.367322,.860646,-.227968,0, .280085,.672501,.047413,0,
                            -.011820,.042940,.968881,0)).save(HERE / "qa-deuteranopia.png")
    # Physical-size review surrogate: 174 mm at a 96-dpi display, alongside print-resolution proof.
    preview.resize((658, round(658*H/W)), Image.Resampling.LANCZOS).save(HERE / "qa-final-size.png")
    (out / "figure1-notes.md").write_text(notes(data), encoding="utf-8")
    qa = dict(width_mm=174, height_mm=H/4, min_text_pt=min(r["size_pt"] for r in scene.text_records),
              text_elements=len(scene.text_records), no_legacy_names=True, pdf_vector_only=True, tiff_pixels=image.size,
              tiff_dpi=[600,600], tiff_compression="LZW", font_strategy="all text outlined from bundled OFL fonts",
              bundle_sha256=data["bundle_sha256"], evidence=data["evidence"]["identity"],
              source_projection=data["evidence"]["source_version"], verification=data["verification"]["result"])
    (HERE / "qa.json").write_text(json.dumps(qa, indent=2)+"\n", encoding="utf-8")
    print(json.dumps(qa, indent=2))


if __name__ == "__main__":
    main()
