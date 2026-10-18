"""Run one no-kit baseline case: the raw model in Claude Code with no rob2-kit plugin, no skills,
no MCP servers and only Read, Glob and Grep, on the same inputs as the kit runs
(bench/build_nokit_inputs.py: PDFs, sources.toml, registry Markdown and registry documents).

Prompt: Ali's kit prompt without the leading "/rob2-assess", fields copied verbatim from
OUTCOMES-batch.csv (assess_outcome, assess_values_as_printed, slug), followed by the text in
--format-file if given (the output-format sentence, pending Ali's ruling). If the session ends
without the expected answer and --continue-reply is set, the session is resumed with that reply
(at most --max-continues times); every turn is logged as stream-json JSONL.

Usage: uv run python bench/run_nokit_case.py <slug> [--bench ~/rob2-bench-nokit-haiku] [--inputs ~/rob2-bench-nokit/inputs]
       [--model claude-haiku-5-5] [--effort medium] [--format-file bench/nokit-format.txt]
       [--continue-reply "Continue."] [--max-continues 2] [--prompt-override TEXT]"""
import argparse, csv, json, os, shutil, subprocess, time
HERE = os.path.dirname(os.path.abspath(__file__)); META = os.path.dirname(HERE)
ap = argparse.ArgumentParser()
ap.add_argument("slug"); ap.add_argument("--bench", default=os.path.expanduser("~/rob2-bench-nokit-haiku"))
ap.add_argument("--inputs", default=os.path.expanduser("~/rob2-bench-nokit/inputs"))
ap.add_argument("--home", default=os.path.expanduser("~/rob2-bench-sonnet/claude-home"))
ap.add_argument("--model", default="claude-haiku-5-5"); ap.add_argument("--effort", default="medium")
ap.add_argument("--format-file"); ap.add_argument("--continue-reply"); ap.add_argument("--max-continues", type=int, default=2)
ap.add_argument("--done-marker", default="", help="text whose presence in the final answer means the case is complete")
ap.add_argument("--prompt-override"); ap.add_argument("--timeout", type=int, default=3600)
a = ap.parse_args()
o = {r["slug"]: r for r in csv.DictReader(open(f"{META}/OUTCOMES-batch.csv", encoding="utf-8"))}[a.slug]
prompt = f"Assess risk of bias for {o['assess_outcome']} defined as {o['assess_values_as_printed']} in {a.slug}."
if a.format_file: prompt += "\n\n" + open(a.format_file, encoding="utf-8").read().strip()
if a.prompt_override: prompt = a.prompt_override
case = f"{a.bench}/cases/{a.slug}"; logs = f"{a.bench}/logs/{a.slug}"
if os.path.exists(case): shutil.rmtree(case)
shutil.copytree(f"{a.inputs}/{a.slug}", f"{case}/input/{a.slug}")
os.makedirs(logs, exist_ok=True)
env = dict(os.environ, CLAUDE_CONFIG_DIR=os.path.realpath(a.home), ENABLE_CLAUDEAI_MCP_SERVERS="false",
           CLAUDE_CODE_DISABLE_AUTO_MEMORY="1", CLAUDE_CODE_DISABLE_BUNDLED_SKILLS="1")
for k in ("ANTHROPIC_API_KEY", "CLAUDE_CODE_OAUTH_TOKEN"): env.pop(k, None)
base = ["claude", "-p", "--model", a.model, "--effort", a.effort, "--output-format", "stream-json", "--verbose",
        "--tools", "Read,Glob,Grep", "--strict-mcp-config", "--disable-slash-commands", "--permission-mode", "bypassPermissions"]
meta = {"slug": a.slug, "prompt": prompt, "model": a.model, "effort": a.effort, "condition": "no-kit",
        "claude_version": subprocess.run(["claude", "--version"], capture_output=True, text=True).stdout.strip(), "turns": []}

def turn(n, args):
    t0 = time.time(); path = f"{logs}/turn{n}.jsonl"
    with open(path, "w") as f:
        p = subprocess.run(base + args, cwd=case, env=env, stdout=f, stderr=subprocess.PIPE, text=True, timeout=a.timeout)
    sid = res = None
    for line in open(path):
        try: e = json.loads(line)
        except ValueError: continue
        sid = e.get("session_id") or sid
        if e.get("type") == "result": res = e
    meta["turns"].append({"n": n, "message": args[0], "exit": p.returncode, "seconds": round(time.time() - t0, 1),
                          "stderr_tail": p.stderr[-500:], "usage": (res or {}).get("usage"), "cost_usd": (res or {}).get("total_cost_usd"),
                          "is_error": (res or {}).get("is_error"), "num_turns": (res or {}).get("num_turns")})
    return sid, (res or {}).get("result", "") or ""

sid, text = turn(1, [prompt])
n = 1; meta["continues"] = []
while a.continue_reply and a.done_marker and a.done_marker not in text and sid and n <= a.max_continues:
    n += 1; meta["continues"].append({"turn": n, "previous_answer_tail": text[-600:]})
    sid, text = turn(n, [a.continue_reply, "--resume", sid])
open(f"{logs}/final.md", "w", encoding="utf-8").write(text)
meta["complete"] = bool(a.done_marker) and a.done_marker in text
json.dump(meta, open(f"{logs}/meta.json", "w"), indent=1)
print(json.dumps({"slug": a.slug, "turns": len(meta["turns"]), "complete": meta["complete"]}), [(t["n"], t["exit"], t["seconds"], t["cost_usd"]) for t in meta["turns"]])
