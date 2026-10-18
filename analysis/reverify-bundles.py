"""Run with the isolated, non-editably installed run-build Python interpreter."""
import csv
import hashlib
import importlib.metadata
import json
from pathlib import Path
import sys
import zipfile
import platform

from rob2_kit.application.finalization import verify_bundle
import rob2_kit

COMMIT = "2848c7926a2acc25402345a42be39d695a99861a"
EXCLUDED = {"atwine-2020", "haney-2004", "herrmann-2016"}

def main():
    root = Path(__file__).resolve().parent.parent
    version = importlib.metadata.version("rob2-kit")
    installed = Path(rob2_kit.__file__).resolve()
    if not installed.is_relative_to(Path(sys.prefix).resolve()):
        raise RuntimeError(f"Verifier is not installed in the isolated environment: {installed}")
    rows = []
    for model in ("sonnet", "haiku"):
        bundles = sorted((root / f"kit-{model}-5.5" / "bundles").glob("*.rob2.zip"))
        if not bundles:
            raise RuntimeError(f"No {model} bundles")
        for bundle in bundles:
            slug = bundle.name.removesuffix(".rob2.zip")
            diagnostic = {}
            try:
                passed = verify_bundle(bundle, diagnostic=diagnostic)
                result = "pass" if passed else "fail"
            except Exception as error:
                result = "error"
                diagnostic = {"exception": f"{type(error).__name__}: {error}"}
            with zipfile.ZipFile(bundle) as archive:
                receipt = json.loads(archive.read("verification.json"))
            archived_passed = receipt.get("result") == "verified"
            rows.append(dict(slug=slug, arm=f"ARBITER-{model.title()}",
                bundle_sha256=hashlib.sha256(bundle.read_bytes()).hexdigest(),
                verifier_version=version, verifier_commit=COMMIT, result=result,
                detail=json.dumps(diagnostic, sort_keys=True),
                population="excluded" if slug in EXCLUDED else "analysis",
                archived_result=receipt.get("result", "missing"),
                receipt_agreement=(result == "pass") == archived_passed if result != "error" else False,
                archived_receipt=json.dumps(receipt, sort_keys=True)))
    target = root / "analysis/data-derived/bundle-reverification.csv"
    with target.open("w", newline="", encoding="utf-8") as stream:
        writer = csv.DictWriter(stream, fieldnames=list(rows[0]))
        writer.writeheader()
        writer.writerows(rows)
    provenance = root / "analysis/provenance"
    provenance.mkdir(exist_ok=True)
    environment = {"python": platform.python_version(), "verifier_version": version,
        "verifier_commit": COMMIT, "installed_module": str(installed),
        "distributions": dict(sorted((d.metadata["Name"], d.version)
            for d in importlib.metadata.distributions()))}
    (provenance / "bundle-reverification-environment.json").write_text(
        json.dumps(environment, indent=2) + "\n", encoding="utf-8")
    summary = ["# Fresh bundle verification\n", f"Run build: `{COMMIT}`; distribution version `{version}`.\n",
        "Verifier: `rob2_kit.application.finalization.verify_bundle(path, diagnostic=...)`, "
        "the function used by both `rob2 verify` and finalization. "
        "This rereads archive bytes and recomputes bundle invariants; it does not trust the stored receipt.\n",
        "| Arm | Population | Fresh passes | Archived verified | Disagreements |",
        "|---|---|---:|---:|---:|"]
    for arm in sorted({r["arm"] for r in rows}):
        for population in ("analysis", "excluded"):
            group = [r for r in rows if r["arm"] == arm and r["population"] == population]
            summary.append(f"| {arm} | {population} | {sum(r['result'] == 'pass' for r in group)}/{len(group)} | "
                f"{sum(r['archived_result'] == 'verified' for r in group)}/{len(group)} | "
                f"{sum(not r['receipt_agreement'] for r in group)} |")
    summary.extend(["\nExcluded bundles present: Sonnet—atwine-2020, haney-2004, herrmann-2016; "
        "Haiku—herrmann-2016. Haiku has no atwine-2020 or haney-2004 bundle. "
        "Excluded trials are never pooled into the 102-trial results.\n",
        "## Isolated build and reproduction\n",
        "Export commit 2848c79 with `git archive --format=zip`; expand into a new temporary directory. "
        "Run `uv venv --python 3.13 <temp>/venv`, "
        "`uv build --wheel --out-dir <temp>/dist <temp>/source`, then "
        "`uv pip install --python <temp>/venv/Scripts/python.exe <temp>/dist/rob2_kit-0.13.0-py3-none-any.whl`. "
        "Run `<temp>/venv/Scripts/python.exe analysis/reverify-bundles.py` from the analysis checkout. "
        "Both source repositories remain read-only. The module-path assertion confirms a site-packages "
        "installation inside the isolated venv. Dependency versions are recorded in "
        "`bundle-reverification-environment.json`; this recreates the exact project commit, "
        "not an undocumented historical transitive-dependency environment.\n",
        "No tables or manuscript outputs were changed: the separate equivalence audit found "
        "behavioural differences. See `rename-equivalence.md`. No Quarto render was required.\n"])
    (provenance / "bundle-reverification-summary.md").write_text("\n".join(summary), encoding="utf-8")
    print(json.dumps({"version": version, "installed_module": str(installed),
                      "rows": len(rows), "results": {r: sum(x["result"] == r for x in rows)
                      for r in {x["result"] for x in rows}}, "first_receipt": receipt}, indent=2))

if __name__ == "__main__":
    main()
