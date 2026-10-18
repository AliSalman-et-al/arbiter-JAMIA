"""Run one rob2-kit benchmark case in Claude Code, emulating an uncoached researcher.

Isolation: CLAUDE_CONFIG_DIR is a scratch home with no skills, plugins, CLAUDE.md or memory; the
rob2-kit plugin is loaded per session with --plugin-dir from a clone pinned at the commit under
test; the working directory holds only input/<slug>/. Turn 1 sends Ali's prompt. If the session
stops at Proposal Review, the case does what a researcher would: approves the pending Review
unchanged with `rob2 review` (answering yes), then resumes the session with "Approved." and nothing
else. Every turn is logged as Claude Code stream-json (JSONL).

Usage: uv run python bench/run_case.py <slug> [--bench ~/rob2-bench-sonnet] [--target assess|primary]
       [--model claude-sonnet-5-5] [--effort medium]"""
import argparse, csv, json, os, shutil, subprocess, sys, time
HERE = os.path.dirname(os.path.abspath(__file__)); META = os.path.dirname(HERE)
ap = argparse.ArgumentParser()
ap.add_argument("slug"); ap.add_argument("--bench", default=os.path.expanduser("~/rob2-bench-sonnet"))
ap.add_argument("--target", choices=["assess", "primary"], default="assess")
ap.add_argument("--model", default="claude-sonnet-5-5"); ap.add_argument("--effort", default="medium")
ap.add_argument("--timeout", type=int, default=3600)
a = ap.parse_args()
O = {r["slug"]: r for r in csv.DictReader(open(f"{META}/OUTCOMES-batch.csv", encoding="utf-8"))}
o = O[a.slug]
outcome, definition = ((o["assess_outcome"], o["assess_values_as_printed"]) if a.target == "assess"
                       else (o["primary_outcome"], o["anchor_as_printed"]))
# Ali 2026-10-12 12:05: each field copied verbatim (no case change, no trimming of punctuation)
prompt = f"/rob2-assess Assess risk of bias for {outcome} defined as {definition} in {a.slug}."

kit = os.path.realpath(f"{a.bench}/rob2-kit"); home = os.path.realpath(f"{a.bench}/claude-home")  # login is keyed to the real path
case = f"{a.bench}/cases/{a.slug}"; logs = f"{a.bench}/logs/{a.slug}"
if os.path.exists(case): shutil.rmtree(case)
shutil.copytree(f"{META}/trials/{a.slug}", f"{case}/input/{a.slug}", ignore=shutil.ignore_patterns("orig"))
os.makedirs(logs, exist_ok=True)
env = dict(os.environ, CLAUDE_CONFIG_DIR=home, ENABLE_CLAUDEAI_MCP_SERVERS="false",
           CLAUDE_CODE_DISABLE_AUTO_MEMORY="1", CLAUDE_CODE_DISABLE_BUNDLED_SKILLS="1")  # plus claude-home/settings.json (bench/claude-home-settings.json)
for k in ("ANTHROPIC_API_KEY", "CLAUDE_CODE_OAUTH_TOKEN"): env.pop(k, None)
base = ["claude", "-p", "--model", a.model, "--effort", a.effort, "--output-format", "stream-json", "--verbose",
        "--plugin-dir", kit, "--permission-mode", "bypassPermissions"]
meta = {"slug": a.slug, "target": a.target, "prompt": prompt, "model": a.model, "effort": a.effort,
        "kit_commit": subprocess.run(["git", "-C", kit, "rev-parse", "HEAD"], capture_output=True, text=True).stdout.strip(),
        "claude_version": subprocess.run(["claude", "--version"], capture_output=True, text=True).stdout.strip(), "turns": []}

def turn(n, args):
    t0 = time.time(); path = f"{logs}/turn{n}.jsonl"
    with open(path, "w") as f:
        p = subprocess.run(base + args, cwd=case, env=env, stdout=f, stderr=subprocess.PIPE, text=True, timeout=a.timeout)
    sid = None; result = None
    for line in open(path):
        try: e = json.loads(line)
        except ValueError: continue
        sid = e.get("session_id") or sid
        if e.get("type") == "result": result = e
    meta["turns"].append({"n": n, "args": args[:1] if args and not args[0].startswith("--") else args, "exit": p.returncode,
                          "seconds": round(time.time() - t0, 1), "stderr_tail": p.stderr[-500:],
                          "usage": (result or {}).get("usage"), "cost_usd": (result or {}).get("total_cost_usd"),
                          "is_error": (result or {}).get("is_error"), "num_turns": (result or {}).get("num_turns")})
    return sid, (result or {}).get("result", "")

def rob2(*cmd, inp=None):
    return subprocess.run(["uvx", "--from", kit, "rob2", *cmd], cwd=case, input=inp, capture_output=True, text=True, timeout=600)

# Stop rule (Zaid, 2026-10-14): when the session ends before the approval step or before
# finalizing, reply "Continue." and nothing else, at most twice per phase; every such reply is
# recorded in meta["continues"] (and bench/continues.py lists them).
meta["continues"] = []
finalized = lambda: os.path.isdir(f"{case}/.rob2-kit/finalized") and bool(os.listdir(f"{case}/.rob2-kit/finalized"))
n = 1
sid, text = turn(n, [prompt])
st = rob2("status"); meta["status_after_turn1"] = st.stdout[-2000:]
for _ in range(2):
    if "researcher_review" in st.stdout or finalized() or not sid: break
    n += 1; meta["continues"].append({"turn": n, "phase": "before approval", "previous_answer_tail": text[-600:]})
    sid, text = turn(n, ["Continue.", "--resume", sid]); st = rob2("status")
if "researcher_review" in st.stdout:
    rv = rob2("review", inp="yes\n")
    open(f"{logs}/review.txt", "w").write(rv.stdout + "\n--- stderr ---\n" + rv.stderr)
    meta["review_exit"] = rv.returncode
    if sid:
        n += 1; sid, text = turn(n, ["Approved.", "--resume", sid])
        for _ in range(2):
            if finalized() or not sid: break
            n += 1; meta["continues"].append({"turn": n, "phase": "after approval", "previous_answer_tail": text[-600:]})
            sid, text = turn(n, ["Continue.", "--resume", sid])
meta["final_status"] = rob2("status").stdout[-3000:]
meta["finalized"] = sorted(os.listdir(f"{case}/.rob2-kit/finalized")) if os.path.isdir(f"{case}/.rob2-kit/finalized") else []
json.dump(meta, open(f"{logs}/meta.json", "w"), indent=1)
print(json.dumps({k: meta[k] for k in ("slug", "finalized")}), [(t["n"], t["exit"], t["seconds"], t["cost_usd"]) for t in meta["turns"]])
