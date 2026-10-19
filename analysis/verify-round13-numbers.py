"""Audit every displayed number token against the parent commit and frozen files."""
from pathlib import Path
import difflib, hashlib, io, json, re, subprocess, zipfile
import xml.etree.ElementTree as ET
ROOT = Path(__file__).resolve().parent.parent
BASE = "7c3474a"
QA = ROOT / "analysis/output/manuscript/qa"
NUM = re.compile(r"(?<![0-9])[−-]?\d+(?:[.,]\d+)*")
def tokens(text):
    return NUM.findall(text)
def old(path):
    return subprocess.check_output(["git", "show", f"{BASE}:{path}"], cwd=ROOT)
def doc_text(blob):
    with zipfile.ZipFile(io.BytesIO(blob)) as z:
        root = ET.fromstring(z.read("word/document.xml"))
    ns = {"w": "http://schemas.openxmlformats.org/wordprocessingml/2006/main"}
    return "\n".join("".join(p.itertext()) for p in root.findall(".//w:p", ns))
def table_rows(blob):
    with zipfile.ZipFile(io.BytesIO(blob)) as z:
        root = ET.fromstring(z.read("word/document.xml"))
    ns = {"w": "http://schemas.openxmlformats.org/wordprocessingml/2006/main"}
    return [["".join(c.itertext()).strip() for c in row.findall("w:tc", ns)]
            for row in root.findall(".//w:tbl/w:tr", ns)]
# The last table row is the note; compare every statistical body cell separately.
for i in (1, 2, 4):
    path = f"analysis/output/manuscript/Table{i}.docx"
    a, b = table_rows(old(path)), table_rows((ROOT/path).read_bytes())
    assert tokens(" ".join(" ".join(row) for row in a[:-1])) == tokens(" ".join(" ".join(row) for row in b[:-1])), f"Table {i} numeric values changed"
path = "analysis/output/manuscript/Table3.docx"
a, b = table_rows(old(path)), table_rows((ROOT/path).read_bytes())
assert [tokens(" ".join(r)) for r in a[:10]] == [tokens(" ".join(r)) for r in b[:10]]
assert [tokens(" ".join(r)) for r in a[-6:-1]] == [tokens(" ".join(r)) for r in b[-6:-1]]
overall = [r for r in b if r[0].startswith("Overall rating follows")]
assert len(overall) == 1 and overall[0][1:] == ["102/102 (100.0%)"] * 2
report = ["Every numeric token, including titles, labels and notes, is included below.",
          "Only changed token spans are printed; complete before/after streams are saved in JSON.",
          "Approved changes: Table 3 combines exact agreement and permitted escalation;",
          "results spell out Sixteen and add 60.5% (78/129) and the eligible total 47 (29+18).", ""]
streams = {}
paths = ["analysis/output/manuscript/results-sentences.md"] + [f"analysis/output/manuscript/Table{i}.docx" for i in range(1, 5)]
for path in paths:
    before, after = old(path), (ROOT/path).read_bytes()
    if path.endswith(".docx"):
        before, after = doc_text(before), doc_text(after)
    else:
        before, after = before.decode("utf-8"), after.decode("utf-8")
    a, b = tokens(before), tokens(after)
    streams[path] = {"before": a, "after": b}
    report.append(f"{path}: {len(a)} -> {len(b)} tokens")
    changes = 0
    for op, i, j, k, l in difflib.SequenceMatcher(a=a, b=b, autojunk=False).get_opcodes():
        if op != "equal":
            changes += 1
            report.append(f"  {op} before[{i}:{j}] {a[i:j]} -> after[{k}:{l}] {b[k:l]}")
    if not changes:
        report.append("  IDENTICAL")
    report.append("")
# No statistical CSV or protected Figure 1/2 file may change, even when rebuilt.
hashes = json.loads((QA/"round13-input-hashes.json").read_text())
changed = []
for path, expected in hashes.items():
    content = (ROOT/path).read_bytes()
    # readr normalises CRLF to LF on Windows; compare canonical text for CSVs.
    if path.endswith(".csv"):
        reference = old(path.replace("\\", "/"))
        same = content.replace(b"\r\n", b"\n") == reference.replace(b"\r\n", b"\n")
    else:
        same = hashlib.sha256(content).hexdigest() == expected
    if not same:
        changed.append(path)
assert not changed, changed
report.append("PASS: every numeric body value in Tables 1, 2 and 4 is unchanged; Table 3 changes only the authorised Overall block.")
report.append(f"PASS: {len(hashes)} frozen CSV/protected files unchanged (CSV line endings normalised).")
(QA/"round13-number-token-streams.json").write_text(json.dumps(streams, ensure_ascii=False, indent=2), encoding="utf-8")
(QA/"round13-number-token-diff.txt").write_text("\n".join(report)+"\n", encoding="utf-8")
print("\n".join(report))
