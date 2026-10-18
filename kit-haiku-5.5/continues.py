"""List every case where the harness replied "Continue." (the stop rule), for a bench folder.
Usage: python bench/continues.py <bench> [<bench> ...]  -> prints and writes <bench>/continues.csv"""
import csv, glob, json, sys
for b in sys.argv[1:]:
    rows = []
    for p in sorted(glob.glob(f"{b}/logs/*/meta.json")):
        m = json.load(open(p))
        for c in m.get("continues", []):
            rows.append({"slug": m["slug"], "turn": c["turn"], "phase": c.get("phase", ""), "model_said_before": c["previous_answer_tail"].replace("\n", " ")[-300:]})
    with open(f"{b}/continues.csv", "w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=["slug", "turn", "phase", "model_said_before"]); w.writeheader(); w.writerows(rows)
    print(b, len(rows), "Continue replies in", len({r["slug"] for r in rows}), "cases")
