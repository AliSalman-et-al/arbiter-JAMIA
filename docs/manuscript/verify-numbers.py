#!/usr/bin/env python3
"""Read-only manuscript number audit; run from any directory with Python 3.

Every digit token is classified, including tokens inside citations and versions.
Study numbers must occur in committed output CSVs, generated results prose or
main tables. CSV coefficients/proportions allow their publication rounding and
percentage scaling; process durations allow seconds-to-minutes conversion.
Non-result identifiers, metadata and editorial counts are reported separately,
never silently treated as verified study results. --verbose prints each token's
source. This checks traceability, not whether a number supports its surrounding
claim; explicit row-level checks below additionally protect the headline claims.
Nothing is written. A missing empirical token, failed claim or word limit exits 1.
"""

import argparse
import csv
from collections import Counter, defaultdict
from decimal import Decimal, InvalidOperation, ROUND_HALF_UP
from pathlib import Path
import re
import sys
from xml.etree import ElementTree as ET
from zipfile import ZipFile


ROOT = Path(__file__).resolve().parents[2]
MANUSCRIPT = Path(__file__).with_name("manuscript.md")
REFERENCES = Path(__file__).with_name("references.md")
OUTPUT = ROOT / "analysis/output"
NUMBER = re.compile(r"[−-]?\d+(?:,\d{3})*(?:\.\d+)*")
VALUE = re.compile(r"[+-]?\d+(?:\.\d+)?(?:[eE][+-]?\d+)?\Z")
NS = {"w": "http://schemas.openxmlformats.org/wordprocessingml/2006/main"}


def normal(value):
    value = value.replace(",", "").replace("−", "-")
    try:
        return str(Decimal(value).normalize())
    except InvalidOperation:
        return value


def sections(text):
    return dict(re.findall(r"^## ([^\n]+)\n(.*?)(?=^## |\Z)", text, re.M | re.S))


def words(text):
    text = re.sub(r"^#{1,6} .*?$", "", text, flags=re.M)
    text = re.sub(r"\[[\d,–-]+\]", "", text)
    text = re.sub(r"\[([^\]]+)\]\([^)]+\)", r"\1", text)
    return len(text.split())


def docx_text(path):
    with ZipFile(path) as archive:
        tree = ET.fromstring(archive.read("word/document.xml"))
    return "\n".join("".join(t.text or "" for t in p.findall(".//w:t", NS))
                     for p in tree.findall(".//w:p", NS))


def output_index():
    index = defaultdict(set)
    files = sorted((OUTPUT / "tables").glob("*.csv"))
    for path in files:
        with path.open(encoding="utf-8-sig", newline="") as handle:
            for row_number, row in enumerate(csv.DictReader(handle), 2):
                for column, value in row.items():
                    if value is None or not VALUE.fullmatch(value):
                        continue
                    location = f"{path.relative_to(ROOT)}:{row_number}:{column}"
                    index[normal(value)].add(location)
                    numeric = Decimal(value)
                    # Only statistical fields receive display rounding/scaling.
                    if column in {"estimate", "lower", "upper", "agreement", "share",
                                  "median", "q25", "q75", "mean", "total"}:
                        scales = [Decimal(1)]
                        if column in {"estimate", "lower", "upper", "agreement", "share"}:
                            scales.append(Decimal(100))
                        if "process" in path.name or path.name == "table5.csv":
                            scales.append(Decimal(1) / Decimal(60))
                        for scale in scales:
                            for places in (1, 2):
                                rounded = (numeric * scale).quantize(
                                    Decimal(10) ** -places, rounding=ROUND_HALF_UP)
                                index[normal(str(rounded))].add(location + f" [scale {scale}, {places} dp]")
    texts = [(OUTPUT / "manuscript/results-sentences.md")]
    for path in texts:
        for line_number, line in enumerate(path.read_text().splitlines(), 1):
            for match in NUMBER.finditer(line):
                index[normal(match.group())].add(f"{path.relative_to(ROOT)}:{line_number}")
    for i in range(1, 5):
        path = OUTPUT / f"manuscript/Table{i}.docx"
        for match in NUMBER.finditer(docx_text(path)):
            index[normal(match.group())].add(str(path.relative_to(ROOT)))
    return index, len(files)


def metadata_spans(text):
    """Return labelled spans; all underlying digit tokens are still extracted."""
    result = []
    patterns = {
        "URL": r"https?://[^\s)]+",
        "reference callout": r"\[[\d,–-]+\]",
        "display cross-reference": r"\b(?:Figure|Table|eTables?|eFigure)\s+\d+(?:[AB]|[–-]\d+)?",
        "instrument identifier": r"\bRoB 2\b",
        "question identifier": r"\b(?:question|Question)\s*\(?5\.1\)?|\(5\.1\)",
        "adjudicator identifier": r"\bAdjudicator [12]\b",
        "interval convention": r"\b95%",
        "model identifier": r"`claude-sonnet-5-5`",
        "harness version (run README)": r"Claude Code 2\.1\.278",
        "software version (analysis plan)": r"ARBITER 1\.0\.0",
        "software commit (analysis plan)": r"2f549ae(?:30f056ff441ea61a04b719968716f2219)?",
        "date (run README or editorial search/access date)": r"\b(?:12|14|19) October 2026\b",
        "literature shorthand year (bibliography)": r"(?:Hartling 2019|Zhang 2024)",
    }
    for label, pattern in patterns.items():
        result.extend((m.start(), m.end(), label) for m in re.finditer(pattern, text))
    # Editorial front matter and computed counts have no study-output provenance.
    for name, label in [("Front-matter notes", "editorial metadata / journal requirement"),
                        ("Draft completion notes", "editorial completion note")]:
        match = re.search(rf"^## {name}\n.*?(?=^## |\Z)", text, re.M | re.S)
        if match:
            result.append((match.start(), match.end(), label))
    return result


def rows(filename):
    with (OUTPUT / "tables" / filename).open(encoding="utf-8-sig", newline="") as handle:
        return list(csv.DictReader(handle))


def headline_checks(text):
    """Check source-row identity as well as occurrence of key manuscript claims."""
    failures = []

    def check(condition, description):
        if not condition:
            failures.append(description)

    primary = {r["metric"]: r for r in rows("primary-endpoint.csv") if r["analysis"] == "Consensus"}
    check([(r, primary[r]["count"], primary[r]["n"]) for r in ("ARBITER", "Unassisted", "Neither")]
          == [("ARBITER", "54", "62"), ("Unassisted", "7", "62"), ("Neither", "1", "62")],
          "Primary source counts changed")
    check("54/62" in text and "7/62" in text and "1/62" in text, "Primary counts missing")
    check(round(float(primary["ARBITER"]["estimate"]) * 100, 1) == 87.1
          and round(float(primary["ARBITER"]["lower"]) * 100, 1) == 79.0
          and round(float(primary["ARBITER"]["upper"]) * 100, 1) == 94.3, "Primary interval changed")
    directions = {(r["source"], r["direction"]): (r["n"], r["consensus_n"])
                  for r in rows("vindicated-disagreements.csv")
                  if r["outcome"] == "Adjudicators agreed with it"}
    check(directions == {("ARBITER", "More severe"): ("73", "77"),
                         ("ARBITER", "Less severe"): ("22", "28"),
                         ("Unassisted", "More severe"): ("48", "59"),
                         ("Unassisted", "Less severe"): ("19", "38")}, "Direction source counts changed")
    agreement = {(r["arm"].split(" (")[0], r["metric"]): r for r in rows("table1.csv")
                 if r["domain"] == "D1-D5"}
    check(agreement[("ARBITER", "accuracy")]["count"] == "386"
          and agreement[("Unassisted", "accuracy")]["count"] == "395", "Published agreement changed")
    audit = {(r["arm"].split(" (")[0], r["status"]): r for r in rows("table3.csv")
             if r["domain"] == "D1-D5"}
    check(audit[("Unassisted", "Any rule break")]["count"] == "65"
          and audit[("Unassisted", "Any rule break")]["n"] == "509"
          and audit[("ARBITER", "Recorded override")]["count"] == "0", "Rule audit changed")
    credit = {(r["metric"], r["version"]): r["count"]
              for r in rows("rules-only-recomputation-win_share.csv")}
    check(credit[("Unassisted", "Reported")] == "7"
          and credit[("Unassisted", "Recomputed")] == "10"
          and credit[("ARBITER", "Recomputed")] == "54", "Recomputed label credit changed")
    changed = [r for r in rows("rules-only-recomputation-changed.csv")
               if r["consensus"] == "TRUE" and r["discordant"] == "TRUE"]
    check(len(changed) == 3 and all(r["recomputed"] == r["preferred"] for r in changed),
          "Rules-only changed arm-disagreement cells changed")
    plan_losses = rows("question51-mechanism.csv")
    check(len(plan_losses) == 18
          and sum(r["registry_or_protocol_or_sap"] == "TRUE" for r in plan_losses) == 13
          and all(r["mentions_document"] == "FALSE" for r in plan_losses),
          "Question 5.1 loss/document counts changed")
    check("created ties" in text, "Recomputation tie qualification missing")
    check("## Results" in text and "composite" not in sections(text)["Results"].lower(),
          "Composite reference must stay outside Results")
    return failures


def supplementary_citations(text):
    """Expand ranges in citation order without changing supplement numbering."""
    ordered = []
    for match in re.finditer(r"\b(eTables?|eFigures?)\s+(\d+)(?:[–-](\d+))?", text):
        kind = "eTable" if match[1].startswith("eTable") else "eFigure"
        for number in range(int(match[2]), int(match[3] or match[2]) + 1):
            item = f"{kind} {number}"
            if item not in ordered:
                ordered.append(item)
    return ordered


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--verbose", action="store_true")
    args = parser.parse_args()
    text = MANUSCRIPT.read_text()
    index, file_count = output_index()
    spans = metadata_spans(text)
    traced, nonresults, missing = [], [], []
    for match in NUMBER.finditer(text):
        token = match.group()
        line = text.count("\n", 0, match.start()) + 1
        labels = [label for start, end, label in spans if start <= match.start() < end]
        if labels:
            nonresults.append((line, token, labels[0]))
        elif normal(token) in index:
            traced.append((line, token, sorted(index[normal(token)])[0]))
        else:
            missing.append((line, token, text.splitlines()[line - 1]))
    content = sections(text)
    counts = {name: words(content[name]) for name in
              ("Abstract", "Background and significance", "Objective",
               "Materials and methods", "Results", "Discussion")}
    counts["Back matter"] = words(content["Back matter"])
    discussion = content["Discussion"]
    counts["Conclusion (within Discussion)"] = words(discussion.split("### Conclusion\n", 1)[1])
    main_count = sum(counts[name] for name in
                     ("Background and significance", "Objective", "Materials and methods", "Results", "Discussion"))
    failures = headline_checks(text)
    if counts["Abstract"] > 250 or main_count > 4000:
        failures.append("JAMIA word limit exceeded")
    banned = re.findall(r"\b(?:first|over-flagging|second reviewer|unchangeable|tamper-proof|Haiku|kit)\b|supported by evidence",
                        text, re.I)
    if banned:
        failures.append(f"Prohibited wording: {banned}")
    refs = REFERENCES.read_text()
    reference_ids = {int(n) for n in re.findall(r"^(\d+)\.", refs, re.M)}
    used_ids = set()
    for callout in re.findall(r"\[([\d,–-]+)\]", text):
        for part in callout.split(","):
            ends = re.split("[–-]", part)
            used_ids.update(range(int(ends[0]), int(ends[-1]) + 1))
    if used_ids != reference_ids:
        failures.append(f"Reference mismatch: used {sorted(used_ids)}, listed {sorted(reference_ids)}")
    print(f"Extracted {len(traced) + len(nonresults) + len(missing)} numeric tokens from the entire manuscript.")
    print(f"Output-traced: {len(traced)}; non-result/editorial: {len(nonresults)}; UNTRACED: {len(missing)}.")
    print(f"Sources: {file_count} output CSVs, generated results sentences and Tables 1–4.")
    if args.verbose:
        for line, token, source in traced:
            print(f"TRACE line {line}: {token} -> {source}")
    print("Non-result tokens (not claimed to trace to statistical outputs):")
    for (token, label), count in sorted(Counter((t, label) for _, t, label in nonresults).items()):
        print(f"  {token}: {label} ({count} occurrence(s))")
    for line, token, context in missing:
        print(f"UNTRACED line {line}: {token}: {context}")
    print("Section word counts (whitespace words; headings and numeric citation callouts excluded):")
    for name, count in counts.items():
        print(f"  {name}: {count}")
    print(f"  Main text total: {main_count}/4000; abstract: {counts['Abstract']}/250")
    for failure in failures:
        print(f"FAIL: {failure}")
    ordered = supplementary_citations(text)
    print("Supplementary items in order of initial citation: " + "; ".join(ordered))
    if not any(item.startswith("eFigure") for item in ordered):
        print("No eFigures cited in the manuscript.")
    print("eMethods is cited separately as an unnumbered supplementary item.")
    print("PASS" if not missing and not failures else "FAIL")
    return int(bool(missing or failures))


if __name__ == "__main__":
    sys.exit(main())
