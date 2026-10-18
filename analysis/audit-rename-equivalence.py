"""Compare committed trees without writing to either source repository."""
import argparse
import collections
import difflib
import re
import subprocess
from pathlib import Path

RUN = "2848c7926a2acc25402345a42be39d695a99861a"
PUBLIC = "2f549ae30f056ff441ea61a04b719968716f2219"
# Ordered, literal identity substitutions; RoB 2 scientific terminology is untouched.
MAP = [
    ("rob2_kit", "arbiter"), ("rob2-assess", "arbiter-assess"),
    ("rob2-kit", "arbiter"), ("Rob2Kit", "Arbiter"),
    ("ROB2_KIT", "ARBITER"), ("ROB2-KIT", "ARBITER"),
    (".rob2.zip", ".arbiter.zip"),
    ("Rob2-kit", "Arbiter-kit"), ("ROB2_", "ARBITER_"),
    ("rob2_", "arbiter_"), ("rob2://", "arbiter://"),
    ("mcp__rob2__", "mcp__arbiter__"),
]

# Classifications apply to the complete residual hunks, not to the names removed
# by normalisation. Test-only behavioural changes are kept visible as such.
BEHAVIOURAL = {
    ".gitattributes": "Removes the historical-evaluation checkout byte-preservation rule.",
    "scripts/benchmark_recovery_exec_allowlist.json": "Replaces the populated campaign recovery allowlist with an empty public template; changes which recorded recovery programs qualify.",
    "scripts/verify_bundle.py": "Adds a historical pack hash to the accepted uniform-answer-basis set and changes the reported-statistics compatibility descriptor hash; verifier acceptance/compatibility changes.",
    "tests/test_domain_submission.py": "Removes import-time loading of a removed rejected-submission fixture (test setup only).",
    "tests/test_execution_authority.py": "Changes recovery test input to synthetic cases and different trial/outcome names (test-only coverage); the first hunk is string reflow only.",
    "tests/test_intake_contract.py": "Replaces real trial names with synthetic names in duplicate-label tests (test data only).",
    "tests/test_model_facing_assets.py": "Replaces the clinical/evaluation-term exclusion regex with three explicit private-data canaries; changes test acceptance.",
    "tests/test_proposal_evidence_binding.py": "Adds _projection_hash and a source_version to the evidence fixture (test setup); import movement alone is formatting.",
    "tests/test_typed_proposal_routes.py": "Replaces trial, intervention, outcome, effect and CI test data with synthetic values (test data only).",
}

def classify(name, hunk):
    if name.startswith("tests/fixtures/"):
        return "behavioural", "Adds/removes evaluation fixtures; test inputs only, not the shipped scientific pack."
    if name in BEHAVIOURAL:
        if name == "tests/test_execution_authority.py" and hunk.startswith("@@ -385,"):
            return "naming-only", "Adjacent literal string reflow; identical evaluated text."
        if name == "tests/test_proposal_evidence_binding.py" and hunk.startswith("@@ -7,"):
            return "naming-only", "Import ordering after package rename."
        return "behavioural", BEHAVIOURAL[name]
    if name.startswith("docs/") and name not in {"docs/release/public-contract.json", "docs/release/verify.py"}:
        return "docs-only", "Documentation edit/addition/deletion; complete text is in the residual appendix."
    if name in {"README.md", "CONTEXT.md", "GLOSSARY.md", "CITATION.cff"}:
        return "docs-only", "Product/release documentation and historical-record cleanup."
    return "naming-only", "Release identity/version, rename-derived schema hashes, namespace string, or mechanical formatting/import ordering; no algorithm change."

def normalise(value):
    for old, new in MAP:
        value = value.replace(old, new)
    # Product token in CLI calls, helper names, MCP namespaces and file paths.
    # Scientific text "RoB 2" and pack hashes are never substituted.
    return re.sub(r"\brob2\b(?!\.parallel\.assignment)", "arbiter", value)

def git(repo, *args):
    return subprocess.check_output(["git", "-C", str(repo), *args])

def tree(repo, commit):
    result = {}
    entries = git(repo, "ls-tree", "-r", commit).decode().splitlines()
    objects = [line.split("\t", 1)[0].split()[2] for line in entries]
    batch = subprocess.run(["git", "-C", str(repo), "cat-file", "--batch"],
        input=("\n".join(objects) + "\n").encode(), capture_output=True, check=True).stdout
    offset = 0
    for line in entries:
        meta, name = line.split("\t", 1)
        mode, _, oid = meta.split()
        key = normalise(name)
        if key in result:
            raise RuntimeError(f"Normalisation collision: {key}")
        header_end = batch.index(b"\n", offset)
        header = batch[offset:header_end].decode().split()
        if header[:2] != [oid, "blob"]:
            raise RuntimeError(f"Unexpected Git object: {header}")
        size = int(header[2])
        raw = batch[header_end + 1:header_end + 1 + size]
        offset = header_end + 2 + size
        try:
            text = normalise(raw.decode("utf-8").replace("\r\n", "\n"))
        except UnicodeDecodeError:
            text = "BINARY sha256:" + __import__("hashlib").sha256(raw).hexdigest() + "\n"
        result[key] = (mode, text)
    return result

def main():
    p = argparse.ArgumentParser()
    p.add_argument("run_repo", type=Path)
    p.add_argument("public_repo", type=Path)
    args = p.parse_args()
    a, b = tree(args.run_repo, RUN), tree(args.public_repo, PUBLIC)
    out = Path(__file__).parent / "provenance"
    out.mkdir(exist_ok=True)
    diffs = []
    index = []
    counts = collections.Counter()
    for name in sorted(a.keys() | b.keys()):
        old, new = a.get(name, (None, "")), b.get(name, (None, ""))
        if old == new:
            continue
        counts["files"] += 1
        delta = "".join(difflib.unified_diff(old[1].splitlines(True), new[1].splitlines(True),
                        fromfile="run/" + name, tofile="public/" + name))
        if old[0] != new[0]:
            delta = f"mode {old[0]} -> {new[0]}\n" + delta
        counts["hunks"] += len(re.findall(r"^@@", delta, re.M))
        for hunk in re.findall(r"^@@.*$", delta, re.M):
            category, reason = classify(name, hunk)
            counts[category] += 1
            index.append(f"| `{name}` | `{hunk}` | {category} | {reason} |")
        fence = "`" * max(4, 1 + max((len(m) for m in re.findall(r"`+", delta)), default=0))
        diffs.append(f"## {name}\n\n{fence}diff\n{delta}{fence}\n")
    (out / "rename-residuals.md").write_text(
        "# Complete residual diff after identity normalisation\n\n"
        "Generated by `analysis/audit-rename-equivalence.py`; run → public. "
        "Every tracked path is included, including additions, deletions and file modes.\n\n"
        + "\n".join(diffs), encoding="utf-8")
    report = f"""# Run-build/public-release equivalence audit

**Verdict: not rename-only. Behavioural residuals exist. Do not use the proposed ‘identical apart from naming’ Methods sentence. PI wording decision required.**

The shipped assessment implementation, scientific pack, domain algorithms and assessment skill/prompts have no behavioural residual after the documented identity normalisation. This narrower observation does not establish equivalence of the complete releases.

## Behavioural differences

- `scripts/verify_bundle.py`, hunks `@@ -173,6 +173,7 @@` and `@@ -216,7 +217,7 @@`: public release adds `sha256:28ebc17dafc456a7f5805b4371dc359fa15fe7625fba2a158c3fc011b3e2f5ae` to `_UNIFORM_ANSWER_BASIS_PACKS` and changes `_REPORTED_STATISTICS_SCIENTIFIC_PACK.content_hash` from `sha256:bea71e3fffc8624fa5c1ed66043a21e22828970398501c9d455cb1faf664f891` to that hash. These are literal hash/compatibility changes left unnormalised. This is the separate dependency-free verifier, not the installed CLI verifier used for the fresh bundle checks.
- `scripts/benchmark_recovery_exec_allowlist.json`: public release empties the retained campaign allowlist (19 turns to zero, empty turns/cells). This changes benchmark recovery authorisation for scripts consuming that file.
- `.gitattributes`: drops `tests/fixtures/historical-evaluation/** -text`, changing the checkout policy for that path.
- Test-only changes remove three rejected-submission fixtures, introduce `recovery-exec-synthetic.json`, replace real clinical test inputs with synthetic inputs, change the private-evaluation-term detection regex, and add an evidence `source_version`. These affect validation coverage/setup; they are not changes to the packaged RoB 2 algorithms.

No tables, supplement, deviations, analysis plan, or draft Methods wording were edited. The fresh verification succeeds independently; the equivalence condition fails.

## Method and scope

Compared Git objects at run commit `{RUN}` in `C:/Users/Ali-Salman/Documents/Code/rob2-kit` with public commit `{PUBLIC}` in `C:/Users/Ali-Salman/Documents/Code/ARBITER`. Read-only `git ls-tree`/`git cat-file` inspect every tracked blob and file mode, ignoring working-tree/untracked content. No source checkout was modified. Script: `analysis/audit-rename-equivalence.py`. Reproduce with `python analysis/audit-rename-equivalence.py <run-repo> <public-repo>`.

All tracked paths are compared, not just Python: src, MCP tool definitions/contract manifest, packaged scientific text and algorithms, skills/prompts, host and plugin files, scripts, documentation, tests, build metadata and dependency lockfile. UTF-8 text uses LF for comparison; non-UTF-8 blobs compare SHA-256. No JSON reformatting, hash substitution, version substitution, or whitespace stripping is used. Normalised-path collisions stop the audit. Hunk locations refer to normalised contents; paths in the index are normalised public names. A removed file is represented by its complete deletion hunk.

### Normalisation map

Ordered literal substitutions (both paths and contents):

"""
    report += "\n".join(f"- `{old}` → `{new}`" for old, new in MAP)
    report += f"""

Then regex `\\brob2\\b(?!\\.parallel\\.assignment)` → `arbiter` maps remaining product tokens (CLI/helper/file names, URI/MCP namespaces), preserving the scientific identifier `rob2.parallel.assignment`. Python word-boundary rules apply; escaped `\\nrob2` and embedded `mcp__rob2` examples may remain in the residual index and are classified there. Scientific prose ‘RoB 2’, algorithms, numbers, compatibility hashes and release versions remain unnormalised. Product capitalisation variants not in the map remain explicit documentation/naming residuals.

### Coverage result

Run tree: {len(a)} tracked paths; public tree: {len(b)} tracked paths. Union after mapping: {len(a.keys() | b.keys())} paths; {len(a.keys() | b.keys()) - counts['files']} identical, {counts['files']} residual paths, {counts['hunks']} residual hunks. Hunk classes: {counts['naming-only']} naming-only, {counts['docs-only']} docs-only, {counts['behavioural']} behavioural (including test/configuration changes).

Within `src`, the only residuals are package `__version__` and manifest `contract_version` (0.13.0 → 1.0.0). The entire scientific pack, application finalization/verifier, algorithms and all assessment skill/prompt files are identical after identity normalisation. MCP tool definitions are identical after normalisation; the archived generated manifest retains nine changed output-schema hashes and its release version. Schema hashes are not erased: their naming-only classification is supported by the corresponding schema source being identical after normalisation. Runtime/development dependency entries are unchanged; the lockfile residual is the root project release version.

## Complete hunk classification

Every residual hunk is indexed below. ‘naming-only’ includes release identity metadata and mechanically induced formatting/import order, with unchanged evaluated content. ‘behavioural’ includes test/configuration behaviour; the reason states its scope. Full verbatim normalised hunks, including every added/deleted line, are in [rename-residuals.md](rename-residuals.md). This index and that appendix together are the complete residual record.

| Normalised file | Hunk (run → public) | Classification | Reason |
|---|---|---|---|
"""
    report += "\n".join(index) + "\n"
    (out / "rename-equivalence.md").write_text(report, encoding="utf-8")
    print(dict(counts))

if __name__ == "__main__":
    main()
