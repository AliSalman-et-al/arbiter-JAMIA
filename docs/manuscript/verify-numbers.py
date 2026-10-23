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
                            for places in (0, 1, 2):
                                rounded = (numeric * scale).quantize(
                                    Decimal(10) ** -places, rounding=ROUND_HALF_UP)
                                index[normal(str(rounded))].add(location + f" [scale {scale}, {places} dp]")
    texts = [(OUTPUT / "manuscript/results-sentences.md")]
    for path in texts:
        for line_number, line in enumerate(path.read_text().splitlines(), 1):
            for match in NUMBER.finditer(line):
                index[normal(match.group())].add(f"{path.relative_to(ROOT)}:{line_number}")
    for i in range(1, 4):
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
        "display cross-reference": r"\b(?:Figures?|Tables?|eTables?|eFigures?)\s+\d+(?:[AB]|[–-]\d+)?(?:,\d+(?:[–-]\d+)?)*",
        "instrument identifier": r"\bRoB 2\b",
        "domain identifier": r"\bD[1-5](?:[–-]D[1-5])?\b",
        "expert identifier": r"\bExperts? [12](?: and [12])?\b",
        "interval convention": r"\b95%",
        "model identifier": r"`claude-sonnet-5-5`",
        "harness version (run README)": r"Claude Code 2\.1\.278",
        "software version (analysis plan)": r"ARBITER 1\.0\.0",
        "software commit (analysis plan)": r"2f549ae(?:30f056ff441ea61a04b719968716f2219)?",
        "date (run README or editorial search/access date)": r"\b(?:12|14|18|19|21) October 2026\b",
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
    """Tie headline claims to identified source rows, not just token occurrence."""
    failures = []

    def check(condition, description):
        if not condition:
            failures.append(description)

    def selected(filename, **keys):
        found = [r for r in rows(filename) if all(r.get(k) == v for k, v in keys.items())]
        if len(found) != 1:
            failures.append(f"Expected one row in {filename}: {keys}; found {len(found)}")
            return {}
        return found[0]

    primary = selected("primary-endpoint.csv", analysis="Consensus", metric="ARBITER")
    check((primary.get("count"), primary.get("n")) == ("53", "60"), "Primary source counts changed")
    check("53/60" in text and "7/60" in text, "Primary counts missing")
    for field, expected in (("estimate", 88.3), ("lower", 79.7), ("upper", 96.3)):
        check(round(float(primary.get(field, "nan")) * 100, 1) == expected,
              f"Primary {field} changed")
    check("88%; 95% CI, 80–96%" in text, "Primary displayed estimate/interval changed")
    for expert, expected in (("1", (371, 332, 301)), ("2", (433, 400, 362))):
        for source, count in zip(("ARBITER", "Unassisted", "Published"), expected):
            row = selected("independent-estimates.csv", adjudicator=expert,
                           source=source, domain="D1-D5", metric="accuracy")
            check((row.get("count"), row.get("n")) == (str(count), "510"),
                  f"Independent agreement changed: {expert}, {source}")
            check(f"{count}/510" in text, f"Independent count missing: {expert}, {source}")
    for expert, values in (("1", (7.6, 5.1, 10.2)), ("2", (6.5, 3.5, 9.4))):
        row = selected("independent-differences.csv", adjudicator=expert,
                       domain="D1-D5", metric="accuracy", comparison="ARBITER minus Unassisted")
        check(tuple(round(float(row.get(k, "nan")) * 100, 1)
                    for k in ("estimate", "lower", "upper")) == values,
              f"Paired independent difference changed: {expert}")
        check(f"{values[0]}" in sections(text)["Abstract"] and
              f"{values[1]}–{values[2]}" in sections(text)["Abstract"],
              f"Abstract paired difference missing: {expert}")
    for expert, count in (("1", 64), ("2", 65)):
        row = selected("direction-of-disagreement.csv", source="ARBITER", direction="Stricter",
                       adjudicator=expert, outcome="Expert matches model")
        check((row.get("count"), row.get("n")) == (str(count), "88"), "Directional count changed")

    changed = rows("rules-only-changed.csv")
    check(len(changed) == 26 and sum(r["discordant"] == "TRUE" for r in changed) == 6,
          "Rules-only changed population changed")
    repaired = selected("rules-only-primary.csv", analysis="Consensus", metric="Unassisted")
    check((repaired.get("count"), repaired.get("n")) == ("8", "60"), "Recomputed credit changed")
    for expert, count in (("1", 324), ("2", 391)):
        row = selected("rules-only-agreement.csv", adjudicator=expert, source="Unassisted",
                       domain="D1-D5", metric="accuracy")
        check(row.get("count") == str(count), "Recomputed independent agreement changed")

    audit = selected("table3.csv", arm="Unassisted (Sonnet 5.5)", domain="D1-D5", status="Any rule break")
    check((audit.get("count"), audit.get("n")) == ("65", "509"), "Rule audit changed")
    check("65/509" in text and "1407/1407" in text, "Audit claims missing")
    methods = sections(text)["Materials and methods"]
    check("all 510 cells" in methods and "formal primary endpoint" in methods,
          "Full-cohort and conditional endpoint definitions missing")
    check(not re.search(r"18 October 2026|before the expert ratings.*analysed|prespecified", methods),
          "Chronology declaration retained")
    check(re.findall(r"^### (.+)$", methods, re.M) == ["System design", "Benchmark and assessment arms",
          "Independent expert references", "Outcomes", "Statistical analysis"], "Methods structure changed")
    check("https://github.com/AliSalman-et-al/ARBITER/" in methods and "2f549ae" in methods,
          "Live and evaluated software citations missing")
    for source, count in (("Published", 427), ("ARBITER", 375), ("Unassisted", 407),
                          ("Expert 1", 277), ("Expert 2", 346)):
        row = selected("severity-distribution.csv", source=source, population="D1-D5", label="Low")
        check((row.get("count"), row.get("n")) == (str(count), "510"),
              f"Severity distribution changed: {source}")

    for expert, metric, values in (("1", "sensitivity", (16.3, 10.6, 22.1)),
                                   ("1", "specificity", (2.2, 0.7, 3.9)),
                                   ("2", "sensitivity", (19.5, 12.8, 26.4)),
                                   ("2", "specificity", (0.0, -2.5, 2.6))):
        row = selected("independent-binary-differences.csv", adjudicator=expert, metric=metric,
                       domain="D1-D5", comparison="ARBITER minus Unassisted")
        check(tuple(round(float(row.get(k, "nan")) * 100, 1)
                    for k in ("estimate", "lower", "upper")) == values,
              f"Expert binary difference changed: {expert}, {metric}")
        interval = (f"{values[1]}–{values[2]}" if values[1] >= 0
                    else f"{values[1]} to {values[2]}").replace("-", "−")

    for metric, scale, values in (("accuracy", 100, (-1.8, -5.1, 1.6)),
                                  ("kappa", 1, (0.06, -0.03, 0.14)),
                                  ("sensitivity", 100, (15.7, 6.8, 24.4)),
                                  ("specificity", 100, (-4.4, -7.6, -1.2))):
        row = selected("agreement-meta-differences.csv", metric=metric, domain="D1-D5",
                       reference="Published",
                       comparison="ARBITER (Sonnet 5.5) minus Unassisted (Sonnet 5.5)")
        places = 2 if metric == "kappa" else 1
        check(tuple(round(float(row.get(k, "nan")) * scale, places)
                    for k in ("estimate", "lower", "upper")) == values,
              f"Published-label paired difference changed: {metric}")
    row = selected("expert-reliability-matched.csv", metric="accuracy", domain="Overall")
    check((row.get("count"), row.get("n")) == ("42", "81"),
          "Matched expert Overall reliability changed")
    return failures


def display_citations(text):
    """Expand lists/ranges and ignore repeated panel citations within each class."""
    ordered = []
    pattern = r"\b(Figures?|Tables?|eTables?|eFigures?)\s+(\d+[AB]?(?:[–-]\d+[AB]?)?(?:,\s*\d+[AB]?(?:[–-]\d+[AB]?)?)*)"
    for match in re.finditer(pattern, text):
        kind = match[1].rstrip("s")
        for part in match[2].split(","):
            ends = re.split("[–-]", re.sub("[AB]", "", part.strip()))
            for number in range(int(ends[0]), int(ends[-1]) + 1):
                item = f"{kind} {number}"
                if item not in ordered:
                    ordered.append(item)
    return ordered


def citation_order_checks(text):
    ordered = display_citations(text)
    failures = []
    for kind, count in (("Figure", 5), ("Table", 3)):
        observed = [item for item in ordered if item.startswith(kind + " ")]
        expected = [f"{kind} {i}" for i in range(1, count + 1)]
        if observed != expected:
            failures.append(f"Citation order mismatch: {kind}: {observed}; expected {expected}")
    return failures


def structure_checks(text):
    expected = ['Front-matter notes', 'Abstract', 'Background and significance',
                'Objective', 'Materials and methods', 'Results', 'Discussion', 'Back matter']
    observed = re.findall(r'^## (.+)$', text, re.M)
    failures = [] if observed == expected else [f'Section order mismatch: {observed}']
    abstract = sections(text).get('Abstract', '')
    headings = re.findall(r'^### (.+)$', abstract, re.M)
    if headings != ['Objective', 'Materials and Methods', 'Results', 'Discussion', 'Conclusion']:
        failures.append(f'Abstract heading mismatch: {headings}')
    if len(re.findall(r'^#(?: |$)', text, re.M)) != 1:
        failures.append('Manuscript must contain exactly one top-level title')
    return failures


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
    failures = structure_checks(text) + headline_checks(text)
    if counts["Abstract"] > 250 or main_count > 4000:
        failures.append("JAMIA word limit exceeded")
    banned = re.findall(r"\b(?:first|over-flagging|second reviewer|unchangeable|tamper-proof|Haiku|ground truth|accuracy|correct|kit|hid|reversed|masked|expert-level|matched experts|Adjudicator)\b|supported by evidence",
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
    first_use = []
    for callout in re.findall(r"\[([\d,–-]+)\]", text):
        for part in callout.split(","):
            ends = re.split("[–-]", part)
            for number in range(int(ends[0]), int(ends[-1]) + 1):
                if number not in first_use:
                    first_use.append(number)
    if first_use != sorted(reference_ids):
        failures.append(f"Reference first-use order: {first_use}")
    if used_ids != reference_ids:
        failures.append(f"Reference mismatch: used {sorted(used_ids)}, listed {sorted(reference_ids)}")
    print(f"Extracted {len(traced) + len(nonresults) + len(missing)} numeric tokens from the entire manuscript.")
    print(f"Output-traced: {len(traced)}; non-result/editorial: {len(nonresults)}; UNTRACED: {len(missing)}.")
    print(f"Sources: {file_count} output CSVs, generated results sentences and Tables 1–3.")
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
    ordered = display_citations(text)
    citation_failures = citation_order_checks(text)
    failures.extend(citation_failures)
    for failure in citation_failures:
        print(f"FAIL: {failure}")
    print("Displays in order of initial citation: " + "; ".join(ordered))
    print("Citation-order assertion: " + ("FAIL" if citation_failures else "PASS (main figures and tables)"))
    print("eMethods is cited separately as an unnumbered supplementary item.")
    print("PASS" if not missing and not failures else "FAIL")
    return int(bool(missing or failures))


if __name__ == "__main__":
    sys.exit(main())
