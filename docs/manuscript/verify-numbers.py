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
External literature uses unique literal sentence spans and citation/DOI identity
from round6/external-facts.tsv, separately from study-output traces. Recorded
source metadata is required, but its scientific interpretation is not verified.
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
EXTERNAL_FACTS = ROOT / "docs/manuscript-development/round6/external-facts.tsv"
EXTERNAL_COLUMNS = {"id", "exact_text", "reference", "doi", "metric_context",
                    "locator", "access_level", "boundary"}
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


def word_counts(text):
    content = sections(text)
    counts = {name: words(content[name]) for name in
              ("Abstract", "Introduction", "Materials and methods", "Results", "Discussion", "Back matter")}
    conclusion = content["Discussion"].split("### Conclusion\n", 1)
    counts["Conclusion (within Discussion)"] = words(conclusion[1]) if len(conclusion) == 2 else 0
    main_count = sum(counts[name] for name in
                     ("Introduction", "Materials and methods", "Results", "Discussion"))
    return counts, main_count


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
        "instrument identifier": r"\b(?:RoB [12]|ROBOTO2)\b",
        "domain identifier": r"\bD[1-5](?:[–-]D[1-5])?\b",
        "human review identifier": r"\bHuman Reviews? [12](?: and [12])?\b",
        "disclosed AI model identifier": r"\b(?:GPT-6-Astra|GPT-6\.1-Sol|GPT-6-Luna)\b",
        "interval convention": r"\b95%",
        "model identifier": r"`claude-sonnet-5-5`",
        "evaluated assessment command (release audit)": r"`/rob2-assess`",
        "harness version (run README)": r"Claude Code 2\.1\.278",
        "software version (analysis plan)": r"ARBITER 1\.0\.0",
        "software commit (analysis plan)": r"2f549ae(?:30f056ff441ea61a04b719968716f2219)?",
        "date (run README or editorial search/access date)": r"\b(?:12|14|18|19|21) October 2026\b",
        "literature shorthand year (bibliography)": r"(?:Hartling 2019|Zhang 2024)",
        "review search eligibility years (author-supplied benchmark provenance)": r"(?<=Europe PMC for )2025–2026(?= meta-analyses)",
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


def citation_ids(text):
    result = set()
    for callout in re.findall(r"\[([\d,–-]+)\]", text):
        for part in callout.split(","):
            ends = re.split("[–-]", part)
            result.update(range(int(ends[0]), int(ends[-1]) + 1))
    return result


def sentence_spans(text):
    """Literal prose units, retaining trailing numeric citation callouts."""
    pattern = r".*?(?:[.!?](?:\[[\d,–-]+\])?(?=\s|$)|$)"
    return [(m.start() + len(m[0]) - len(m[0].lstrip()), m.end())
            for m in re.finditer(pattern, text) if m[0].strip()]


OWN_STUDY = re.compile(
    r"\b(?:ARBITER|Unassisted|our|we|this (?:study|benchmark)|the arms|the experts)\b", re.I)


def empirical_numbers(text):
    metadata = metadata_spans(text)
    return [m for m in NUMBER.finditer(text)
            if not any(a <= m.start() and m.end() <= b for a, b, _ in metadata)]


def literature_contexts(text):
    """Conservatively route cited literature prose away from study CSV lookup.

    Attribution is structural, not semantic: uncited prose cannot in general be
    identified as literature automatically. Ledger matching itself is literal.
    """
    result = []
    for paragraph in re.finditer(r"[^\n]+", text):
        if not citation_ids(paragraph[0]) or paragraph[0].startswith("#"):
            continue
        for a, b in sentence_spans(paragraph[0]):
            sentence = paragraph[0][a:b]
            if not OWN_STUDY.search(sentence):
                result.append((paragraph.start() + a, paragraph.start() + b))
    return result


def external_claim_checks(text, references, ledger_path=EXTERNAL_FACTS):
    """Validate literal occurrence and recorded provenance, never source truth.

    Each row is a unique complete sentence/group in one paragraph. No numeric
    whitelist, regex matching, occurrence selector or optional columns required.
    Invalid rows grant no external classification, even if their numbers occur
    in study outputs. Source access/metric/boundary descriptions remain human
    attestations; we require them but do not claim to validate their meaning.
    """
    failures, spans = [], []
    try:
        with Path(ledger_path).open(encoding="utf-8-sig", newline="") as handle:
            reader = csv.DictReader(handle, delimiter="\t")
            if reader.fieldnames and len(reader.fieldnames) != len(set(reader.fieldnames)):
                return [], ["External ledger has ambiguous duplicate column names"]
            if not EXTERNAL_COLUMNS <= set(reader.fieldnames or []):
                return [], ["External ledger missing required columns: " +
                            ", ".join(sorted(EXTERNAL_COLUMNS - set(reader.fieldnames or [])))]
            records = list(reader)
    except OSError as error:
        return [], [f"External ledger unavailable: {ledger_path}: {error}"]
    bibliography = {int(m[1]): m[2] for m in re.finditer(
        r"^(\d+)\.\s+(.*?)(?=^\d+\.\s|\Z)", references, re.M | re.S)}
    ids, texts = set(), set()
    for row_number, row in enumerate(records, 2):
        label = f"External ledger row {row_number} ({row.get('id', '')})"
        errors = []
        if None in row or any(not (row.get(k) or "").strip() for k in EXTERNAL_COLUMNS):
            failures.append(f"{label}: missing source metadata or malformed TSV row")
            continue
        exact = row["exact_text"]
        if row["id"] in ids or exact in texts:
            errors.append("duplicate id or exact_text")
        ids.add(row["id"])
        texts.add(exact)
        if any(c in exact for c in "\t\r\n") or exact != exact.strip():
            errors.append("exact_text must be a single verbatim prose line")
        occurrences = [m.start() for m in re.finditer(re.escape(exact), text)]
        if len(occurrences) != 1:
            errors.append(f"exact_text occurrence count {len(occurrences)}; expected 1")
        reference = row["reference"]
        if not re.fullmatch(r"[1-9]\d*", reference):
            errors.append("reference must be one numeric bibliography id")
        elif int(reference) not in citation_ids(exact):
            errors.append("reference not cited in exact_text")
        doi = row["doi"]
        if not re.fullmatch(r"10\.\d{4,9}/[^\s]+", doi, re.I):
            errors.append("doi must be a plain DOI")
        else:
            source = bibliography.get(int(reference), "") if reference.isdigit() else ""
            source_dois = re.findall(r"10\.\d{4,9}/[^\s\]\[()<>,]+", source, re.I)
            if doi.lower() not in {d.rstrip(".").lower() for d in source_dois}:
                errors.append("DOI does not identify the cited bibliography entry")
        if "ophthalmic surgical research assessors" in " ".join(row[k] for k in EXTERNAL_COLUMNS).lower():
            errors.append("superseded Gandhi OSRA expansion; original systematic review authors required")
        if not empirical_numbers(exact):
            errors.append("exact_text has no external empirical numeric tokens")
        if any(OWN_STUDY.search(exact[a:b]) and empirical_numbers(exact[a:b])
               for a, b in sentence_spans(exact)):
            errors.append("own-study numeric sentence cannot be externally classified")
        if len(occurrences) == 1:
            start, end = occurrences[0], occurrences[0] + len(exact)
            preceding = text[:start]
            section = re.findall(r"^## (.+)$", preceding, re.M)
            if not section or section[-1] not in {"Introduction", "Discussion"}:
                errors.append("external span must be in Introduction or Discussion")
            paragraph_start = text.rfind("\n", 0, start) + 1
            paragraph_end = text.find("\n", end)
            if paragraph_end < 0:
                paragraph_end = len(text)
            units = sentence_spans(text[paragraph_start:paragraph_end])
            if (start - paragraph_start not in {a for a, _ in units} or
                    end - paragraph_start not in {b for _, b in units}):
                errors.append("exact_text must cover complete sentence(s), including citations")
            if any(start < b and a < end for a, b, _ in spans):
                errors.append("overlapping external spans")
        if errors:
            failures.extend(f"{label}: {error}" for error in errors)
        else:
            spans.append((start, end, f"{row['id']}; reference {reference}; doi:{doi}; "
                          f"{row['locator']}; access: {row['access_level']}"))
    if "ophthalmic surgical research assessors" in text.lower():
        failures.append("Superseded Gandhi OSRA expansion in manuscript")
    return spans, failures


def classify_numbers(text, index, external_spans):
    """External provenance has its own class and never enters the CSV index."""
    metadata = metadata_spans(text)
    contexts = literature_contexts(text)
    traced, external, nonresults, missing = [], [], [], []
    for match in NUMBER.finditer(text):
        token = match.group()
        line = text.count("\n", 0, match.start()) + 1
        labels = [label for a, b, label in metadata if a <= match.start() and match.end() <= b]
        sources = [source for a, b, source in external_spans if a <= match.start() and match.end() <= b]
        if labels:
            nonresults.append((line, token, labels[0]))
        elif sources:
            external.append((line, token, sources[0]))
        elif any(a <= match.start() and match.end() <= b for a, b in contexts):
            missing.append((line, token, "external literature requires exact ledger span"))
        elif normal(token) in index:
            traced.append((line, token, sorted(index[normal(token)])[0]))
        else:
            missing.append((line, token, text.splitlines()[line - 1]))
    return traced, external, nonresults, missing


def rows(filename):
    with (OUTPUT / "tables" / filename).open(encoding="utf-8-sig", newline="") as handle:
        return list(csv.DictReader(handle))


def endpoint_definition_checks(methods):
    """Accept reviewed equivalent definitions, independently of result values."""
    outcomes = methods.split("### Outcomes\n", 1)[-1].split("### Statistical analysis\n", 1)[0]
    full_cohort = bool(re.search(r"(?:all 510 cells|across 510 cells)", outcomes))
    original = ("The denominator included only cells in which both human reviewers chose the same label" in outcomes
                and "among cells where the arms' ratings differed" in outcomes)
    revised = ("The conditional label-choice analysis included the cells where the arms differed and both human reviewers chose the same label." in outcomes
               and "Its numerator counted agreed labels matching ARBITER." in outcomes)
    return [] if full_cohort and (original or revised) else [
        "Full-cohort and conditional endpoint definitions missing"]


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

    choice = selected("primary-endpoint.csv", analysis="Consensus", metric="ARBITER")
    check((choice.get("count"), choice.get("n")) == ("53", "60"), "Conditional-choice source counts changed")
    check("53/60" in text and "7/60" in text, "Conditional-choice counts missing")
    for field, expected in (("estimate", 88.3), ("lower", 79.7), ("upper", 96.3)):
        check(round(float(choice.get(field, "nan")) * 100, 1) == expected,
              f"Conditional-choice {field} changed")
    check("88%; 95% CI, 80–96%" in text, "Conditional-choice displayed estimate/interval changed")
    check(all(s in text for s in ("80 cells", "60 and split in 20", "53/80")),
          "Conditional-choice selection or split-loss sensitivity missing")
    for expert, expected in (("1", (371, 332, 301)), ("2", (433, 400, 362))):
        for source, count in zip(("ARBITER", "Unassisted", "Published"), expected):
            row = selected("independent-estimates.csv", adjudicator=expert,
                           source=source, domain="D1-D5", metric="accuracy")
            check((row.get("count"), row.get("n")) == (str(count), "510"),
                  f"Independent agreement changed: {expert}, {source}")
            if source != "Published":
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
    audit = selected("table3.csv", arm="Unassisted (Sonnet 5.5)", domain="D1-D5", status="Any rule break")
    check((audit.get("count"), audit.get("n")) == ("65", "509"), "Rule audit changed")
    check("65/509" in text and "1407/1407" in text, "Audit claims missing")
    methods = sections(text)["Materials and methods"]
    failures.extend(endpoint_definition_checks(methods))
    check(not re.search(r"formal primary endpoint|confirmatory|prespecified secondary", methods, re.I),
          "Superseded prospective outcome hierarchy retained")
    check(not re.search(r"18 October 2026|before the expert ratings.*analysed|prespecified", methods),
          "Chronology declaration retained")
    check(re.findall(r"^### (.+)$", methods, re.M) == ["System design", "Benchmark and assessment arms",
          "Independent human reviews", "Outcomes", "Statistical analysis"], "Methods structure changed")
    check("https://github.com/AliSalman-et-al/ARBITER/" in methods and "2f549ae" in methods,
          "Live and evaluated software citations missing")
    for source, count in (("Published", 427), ("ARBITER", 375), ("Unassisted", 407),
                          ("Expert 1", 277), ("Expert 2", 346)):
        row = selected("severity-distribution.csv", source=source, population="D1-D5", label="Low")
        check((row.get("count"), row.get("n")) == (str(count), "510"),
              f"Severity distribution changed: {source}")

    for metric, scale, values in (("accuracy", 100, (-1.8, -5.1, 1.6)),
                                  ("kappa", 1, (0.06, -0.03, 0.14))):
        row = selected("agreement-meta-differences.csv", metric=metric, domain="D1-D5",
                       reference="Published",
                       comparison="ARBITER (Sonnet 5.5) minus Unassisted (Sonnet 5.5)")
        places = 2 if metric == "kappa" else 1
        check(tuple(round(float(row.get(k, "nan")) * scale, places)
                    for k in ("estimate", "lower", "upper")) == values,
              f"Published-label paired difference changed: {metric}")
    reliability = selected("expert-reliability.csv", metric="accuracy", domain="D1-D5")
    check((reliability.get("count"), reliability.get("n")) == ("388", "510"),
          "Independent expert reliability changed")
    check("388/510" in text, "Expert disagreement context missing")
    for level, values in (("five", (-10.3, -17.2, -3.2)),
                          ("collapsed", (8.5, 3.5, 13.7))):
        row = selected("signalling-differences.csv", adjudicator="1", group="D3", level=level)
        check(row.get("n") == "165", f"D3 paired signalling population changed: {level}")
        check(tuple(round(float(row.get(k, "nan")) * 100, 1)
                    for k in ("estimate", "lower", "upper")) == values,
              f"D3 coding-dependent signalling result changed: {level}")
    check("−10.3" in text and "+8.5" in text, "Unfavorable signalling contrast missing")
    for expert, n, estimate in (("1", "101", -39.6), ("2", "102", -28.4)):
        five = selected("signalling-differences.csv", adjudicator=expert, group="4.1", level="five")
        collapsed = selected("signalling-differences.csv", adjudicator=expert, group="4.1", level="collapsed")
        check(five.get("n") == collapsed.get("n") == n and
              round(float(five.get("estimate", "nan")) * 100, 1) == estimate and
              float(collapsed.get("estimate", "nan")) == 0,
              f"Question 4.1 adverse/collapsed comparison changed: {expert}")
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
    expected = ['Front-matter notes', 'Abstract', 'Introduction',
                'Materials and methods', 'Results', 'Discussion', 'Back matter']
    observed = re.findall(r'^## (.+)$', text, re.M)
    failures = [] if observed == expected else [f'Section order mismatch: {observed}']
    abstract = sections(text).get('Abstract', '')
    headings = re.findall(r'^### (.+)$', abstract, re.M)
    if headings != ['Objective', 'Materials and Methods', 'Results', 'Discussion', 'Conclusion']:
        failures.append(f'Abstract heading mismatch: {headings}')
    introduction = sections(text).get('Introduction', '')
    headings = re.findall(r'^### (.+)$', introduction, re.M)
    if headings != ['Background and significance', 'Objective']:
        failures.append(f'Introduction heading mismatch: {headings}')
    discussion = sections(text).get('Discussion', '')
    headings = re.findall(r'^### (.+)$', discussion, re.M)
    if headings != ['Conclusion']:
        failures.append(f'Discussion heading mismatch: {headings}')
    if len(re.findall(r'^#(?: |$)', text, re.M)) != 1:
        failures.append('Manuscript must contain exactly one top-level title')
    return failures


def wording_checks(text, external_spans):
    pattern = (r"\b(?:first|over-flagging|second reviewer|unchangeable|tamper-proof|Haiku|ground truth|accuracy|correct|kit|hid|reversed|masked|expert-level|matched experts|Adjudicator)\b|supported by evidence")
    reporting_order = [m.span() for m in re.finditer(
        r"We report published-label agreement first, followed by agreement with independent human reviews", text)]
    banned = []
    for match in re.finditer(pattern, text, re.I):
        # A source's sequential groups and masked human panel are legitimate
        # literature descriptions; this does not permit priority/blinding claims
        # elsewhere in the manuscript or exempt any other prohibited wording.
        if match[0].lower() in {"first", "masked"} and any(
                a <= match.start() and match.end() <= b for a, b, _ in external_spans):
            continue
        if match[0].lower() == "first" and any(
                a <= match.start() and match.end() <= b for a, b in reporting_order):
            continue
        banned.append(match[0])
    return [f"Prohibited wording: {banned}"] if banned else []


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--verbose", action="store_true")
    args = parser.parse_args()
    text = MANUSCRIPT.read_text()
    required_sections = {"Abstract", "Introduction", "Materials and methods",
                         "Results", "Discussion", "Back matter"}
    if not required_sections <= sections(text).keys():
        for failure in structure_checks(text):
            print(f"FAIL: {failure}")
        print("FAIL: Required manuscript sections missing; number audit cannot run on partial integration")
        return 1
    index, file_count = output_index()
    refs = REFERENCES.read_text()
    external_spans, external_failures = external_claim_checks(text, refs)
    traced, external, nonresults, missing = classify_numbers(text, index, external_spans)
    counts, main_count = word_counts(text)
    failures = structure_checks(text) + headline_checks(text) + external_failures
    if counts["Abstract"] > 250 or main_count > 4000:
        failures.append("JAMIA word limit exceeded")
    failures.extend(wording_checks(text, external_spans))
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
    print(f"Extracted {len(traced) + len(external) + len(nonresults) + len(missing)} numeric tokens from the entire manuscript.")
    print(f"Output-traced: {len(traced)}; external-literature: {len(external)}; "
          f"non-result/editorial: {len(nonresults)}; UNTRACED: {len(missing)}.")
    print(f"Sources: {file_count} output CSVs, generated results sentences and Tables 1–3.")
    print(f"External ledger: {len(external_spans)} exact spans; {EXTERNAL_FACTS.relative_to(ROOT)}.")
    print("External checks validate recorded traceability, not source truth or semantic validity.")
    if args.verbose:
        for line, token, source in traced:
            print(f"TRACE line {line}: {token} -> {source}")
        for line, token, source in external:
            print(f"EXTERNAL line {line}: {token} -> {source}")
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
