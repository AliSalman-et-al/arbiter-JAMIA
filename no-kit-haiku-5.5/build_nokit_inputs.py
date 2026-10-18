"""Build the no-kit benchmark inputs with input parity to the rob2-kit runs.

For each trial: the same input folder the kit got (main article, supplements, sources.toml), plus
everything rob2-kit captured from ClinicalTrials.gov in the Sonnet kit run (2026-10-12):
  registry/<NCT>.md      the exact Markdown projection of the registry record rob2-kit showed the
                         model (derivative.sqlite3 pages for the registry source, pages joined)
  registry/<file>.pdf    the protocol / SAP documents acquired with acquire_documents = true
Writes <out>/inputs/<slug>/ and <out>/inputs-manifest.csv. Nothing is fetched.
Usage: uv run python bench/build_nokit_inputs.py [--kit-bench ~/rob2-bench-sonnet] [--out ~/rob2-bench-nokit]"""
import argparse, csv, glob, hashlib, json, os, shutil, sqlite3
HERE = os.path.dirname(os.path.abspath(__file__)); META = os.path.dirname(HERE)
ap = argparse.ArgumentParser(); ap.add_argument("--kit-bench", default=os.path.expanduser("~/rob2-bench-sonnet"))
ap.add_argument("--out", default=os.path.expanduser("~/rob2-bench-nokit")); a = ap.parse_args()
slugs = [r["slug"] for r in csv.DictReader(open(f"{META}/LABELS-batch.csv", encoding="utf-8"))]
rows = []
for s in slugs:
    dst = f"{a.out}/inputs/{s}"
    if os.path.exists(dst): shutil.rmtree(dst)
    shutil.copytree(f"{META}/trials/{s}", dst, ignore=shutil.ignore_patterns("orig"))
    k = f"{a.kit_bench}/cases/{s}/.rob2-kit"; reg_md = reg_docs = 0; nct = ""
    db = f"{k}/derivative.sqlite3"
    if os.path.exists(db):
        con = sqlite3.connect(db)
        for sid, payload in con.execute("select source_id, payload from source_index"):
            p = json.loads(payload)
            if p.get("origin") != "registry": continue
            os.makedirs(f"{dst}/registry", exist_ok=True)
            if p.get("role") == "registry":
                nct = p.get("label", "").split()[-1]
                pages = [t for (t,) in con.execute("select text from pages where source_id=? order by page", (sid,))]
                open(f"{dst}/registry/{nct}.md", "w", encoding="utf-8").write("\n\n".join(pages).rstrip() + "\n"); reg_md += 1
            else:
                name = os.path.basename(p.get("logical_path") or sid + ".pdf")
                if name == "capture.json": continue  # rob2-kit bookkeeping, not a document
                shutil.copy(f"{k}/sources/{s}/{sid}.bin", f"{dst}/registry/{name}"); reg_docs += 1
    files = sorted(os.path.relpath(f, dst) for f in glob.glob(f"{dst}/**/*", recursive=True) if os.path.isfile(f))
    rows.append({"slug": s, "nct": nct, "registry_markdown": reg_md, "registry_documents": reg_docs, "files": "; ".join(files)})
with open(f"{a.out}/inputs-manifest.csv", "w", newline="", encoding="utf-8") as f:
    w = csv.DictWriter(f, fieldnames=list(rows[0].keys())); w.writeheader(); w.writerows(rows)
print(len(rows), "trials;", sum(r["registry_markdown"] for r in rows), "registry Markdown;", sum(r["registry_documents"] for r in rows), "registry documents")
