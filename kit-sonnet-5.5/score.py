"""Score finalized rob2-kit bundles against the meta labels (LABELS-batch.csv) and write Ali's two
spreadsheets plus the accuracy report.

Reads <bench>/cases/<slug>/.rob2-kit/finalized/*.rob2.zip (canonical.json: domain_records for D1-D5
and the signalling answers, trial_reviews.<slug>.aggregation.adopted for Overall).
Writes to <bench>/results/:
  rob2kit-signalling-answers.csv  one row per trial x signalling question: answer, active/inactive, justification
  rob2kit-domain-labels.csv       one row per trial: rob2-kit D1-D5 and Overall beside the human labels
  accuracy.md                     exact and Low vs Some concerns/High accuracy, overall, by domain, by field,
                                  with the all-Low baseline over the same cells
Usage: uv run python bench/score.py [--bench ~/rob2-bench-sonnet] [--label "Sonnet 5.5 (Medium)"]"""
import argparse, collections, csv, glob, json, os, zipfile
HERE = os.path.dirname(os.path.abspath(__file__)); META = os.path.dirname(HERE)
ap = argparse.ArgumentParser(); ap.add_argument("--bench", default=os.path.expanduser("~/rob2-bench-sonnet"))
ap.add_argument("--label", default="Claude Code, Sonnet 5.5 (Medium)"); a = ap.parse_args()
DOM = {"randomization": "D1", "deviations": "D2", "missing": "D3", "measurement": "D4", "selection": "D5"}
NORM = {"low": "Low", "some_concerns": "Some concerns", "high": "High"}
VALID = {"Low", "Some concerns", "High"}
L = {r["slug"]: r for r in csv.DictReader(open(f"{META}/LABELS-batch.csv", encoding="utf-8"))}
FIELD = {r["slug"]: r["field"] for r in csv.DictReader(open(f"{META}/TRIAL-SUMMARY.csv", encoding="utf-8"))}
out = f"{a.bench}/results"; os.makedirs(out, exist_ok=True)
labels, answers, missing = [], [], []
for slug in L:
    z = sorted(glob.glob(f"{a.bench}/cases/{slug}/.rob2-kit/finalized/*.rob2.zip"))
    if not z: missing.append(slug); continue
    c = json.loads(zipfile.ZipFile(z[-1]).read("canonical.json"))
    tool = {}
    for rec in c.get("domain_records", {}).values():
        d = DOM.get(rec.get("domain_id", "").split(":")[-1])
        if not d: continue
        tool[d] = NORM.get(str(rec.get("judgment")), rec.get("judgment"))
        active = set(rec.get("active_questions") or [])
        for ans in rec.get("answers", []):
            answers.append({"slug": slug, "field": FIELD.get(slug, ""), "domain": d, "question_id": ans.get("question_id"),
                            "answer": ans.get("answer"), "active": "yes" if not active or ans.get("question_id") in active else "no",
                            "justification": ans.get("justification", "")})
        for q in rec.get("inactive_questions") or []:
            qid = q if isinstance(q, str) else q.get("question_id")
            if not any(x["slug"] == slug and x["question_id"] == qid for x in answers):
                answers.append({"slug": slug, "field": FIELD.get(slug, ""), "domain": d, "question_id": qid,
                                "answer": "not_applicable", "active": "no", "justification": ""})
    agg = (c.get("trial_reviews", {}).get(slug) or {}).get("aggregation") or {}
    tool["Overall"] = NORM.get(str(agg.get("adopted")), agg.get("adopted") or "")
    row = {"slug": slug, "field": FIELD.get(slug, ""), "meta_id": L[slug]["meta_id"]}
    for d in ("D1", "D2", "D3", "D4", "D5", "Overall"):
        h = L[slug]["overall" if d == "Overall" else d]
        row[f"rob2kit_{d}"] = tool.get(d, ""); row[f"human_{d}"] = h
        row[f"exact_{d}"] = "" if h not in VALID else int(tool.get(d) == h)
        row[f"binary_{d}"] = "" if h not in VALID else int((tool.get(d) == "Low") == (h == "Low"))
    row["bundle"] = os.path.basename(z[-1]); labels.append(row)
answers.sort(key=lambda r: (r["slug"], r["domain"], str(r["question_id"])))
for name, rows in (("rob2kit-domain-labels.csv", labels), ("rob2kit-signalling-answers.csv", answers)):
    if rows:
        with open(f"{out}/{name}", "w", newline="", encoding="utf-8") as f:
            w = csv.DictWriter(f, fieldnames=list(rows[0].keys())); w.writeheader(); w.writerows(rows)

def acc(rows, doms):
    n = ex = bi = lo = lb = 0
    for r in rows:
        for d in doms:
            h = r[f"human_{d}"]
            if h not in VALID: continue
            n += 1; ex += r[f"exact_{d}"]; bi += r[f"binary_{d}"]; lo += h == "Low"; lb += 1  # all-Low: exact = binary = (h == Low)
    return n, ex, bi, lo
def line(name, rows, doms):
    n, ex, bi, lo = acc(rows, doms)
    if not n: return f"| {name} | 0 | - | - | - |"
    return f"| {name} | {n} | {ex}/{n} = {ex/n:.1%} | {bi}/{n} = {bi/n:.1%} | {lo}/{n} = {lo/n:.1%} |"
D5 = ["D1", "D2", "D3", "D4", "D5"]
md = [f"# rob2-kit benchmark: {a.label}", "",
      f"Trials finalized: {len(labels)} of {len(L)}." + (f" Not finalized: {', '.join(missing)}." if missing else ""),
      "Cells with a human label of Low, Some concerns or High only (Overall is absent for 21 trials whose meta gives no per-trial overall).",
      "Exact = same label; Low vs SC/High = Some concerns and High counted as one class. All-Low baseline = predicting Low everywhere (its exact and binary accuracy are the same).", "",
      "| scope | cells | exact | Low vs SC/High | all-Low baseline |", "|---|---|---|---|---|",
      line("D1-D5 pooled", labels, D5), line("Overall", labels, ["Overall"]),
      line("D1-D5 and Overall pooled", labels, D5 + ["Overall"])]
md += ["", "## By domain", "", "| domain | cells | exact | Low vs SC/High | all-Low baseline |", "|---|---|---|---|---|"]
md += [line(d, labels, [d]) for d in D5 + ["Overall"]]
md += ["", "## By field (D1-D5 pooled)", "", "| field | cells | exact | Low vs SC/High | all-Low baseline |", "|---|---|---|---|---|"]
byf = collections.defaultdict(list)
for r in labels: byf[r["field"]].append(r)
md += [line(f, byf[f], D5) for f in sorted(byf)]
md += ["", "## By field (Overall)", "", "| field | cells | exact | Low vs SC/High | all-Low baseline |", "|---|---|---|---|---|"]
md += [line(f, byf[f], ["Overall"]) for f in sorted(byf)]
open(f"{out}/accuracy.md", "w", encoding="utf-8").write("\n".join(md) + "\n")
print("\n".join(md[:10]))
