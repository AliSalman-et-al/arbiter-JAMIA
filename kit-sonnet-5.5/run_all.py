"""Run every delivered trial through bench/run_case.py, N at a time, skipping trials that already
have a finalized bundle. Progress goes to <bench>/run_all.log. Re-run to resume.
Usage: uv run python bench/run_all.py [--jobs 3] [--bench ~/rob2-bench-sonnet] [--only slug ...]"""
import argparse, csv, glob, os, subprocess, sys, time
from concurrent.futures import ThreadPoolExecutor
HERE = os.path.dirname(os.path.abspath(__file__)); META = os.path.dirname(HERE)
ap = argparse.ArgumentParser(); ap.add_argument("--jobs", type=int, default=3)
ap.add_argument("--bench", default=os.path.expanduser("~/rob2-bench-sonnet")); ap.add_argument("--only", nargs="*")
a = ap.parse_args()
slugs = a.only or [r["slug"] for r in csv.DictReader(open(f"{META}/LABELS-batch.csv", encoding="utf-8"))]
todo = [s for s in slugs if not glob.glob(f"{a.bench}/cases/{s}/.rob2-kit/finalized/*.rob2.zip")]
log = open(f"{a.bench}/run_all.log", "a", buffering=1)
log.write(f"{time.strftime('%Y-%m-%d %H:%M:%S')} start: {len(todo)} to run, jobs={a.jobs}\n")
state = {"quick_fails": 0, "stop": False}
def one(s):
    if state["stop"]: return
    t0 = time.time()
    p = subprocess.run([sys.executable, f"{HERE}/run_case.py", s, "--bench", a.bench], capture_output=True, text=True)
    log.write(f"{time.strftime('%H:%M:%S')} {s} exit={p.returncode} {round((time.time()-t0)/60,1)}min {p.stdout.strip()[-200:]} {p.stderr.strip()[-200:]}\n")
    done = bool(glob.glob(f"{a.bench}/cases/{s}/.rob2-kit/finalized/*.rob2.zip"))
    state["quick_fails"] = 0 if done or time.time() - t0 > 180 else state["quick_fails"] + 1
    if state["quick_fails"] >= 3 and not state["stop"]:
        state["stop"] = True
        log.write(f"{time.strftime('%H:%M:%S')} STOPPING: 3 cases in a row failed in under 3 minutes without a finalized bundle (network, MCP server or usage limit); rerun to resume\n")
with ThreadPoolExecutor(a.jobs) as ex: list(ex.map(one, todo))
log.write(f"{time.strftime('%Y-%m-%d %H:%M:%S')} done\n")
