# Derived run metrics

One CSV per arm, restricted to the 102-trial analysis set. Reports read these
files; they do not open raw logs or bundles. Regenerate from analysis/ with:

```powershell
& 'C:/Program Files/R/R-4.6.1/bin/Rscript.exe' R/extract-run-metrics.R
```

The extractor requires every trial's metadata and turn JSONL. It streams each
turn log in bounded chunks and compares terminal token counters with metadata.
Only after the complete inventory validates does it write the four CSVs.
Re-extraction was checked to produce byte-identical CSVs.

Seconds, token counters, harness-reported USD, and agent steps are sums across
turns. Thinking tokens are a component of output tokens. Continue counts agree
between metadata and the continuation CSV. Approval is whether the ARBITER
result-approval command succeeded; baseline approval is unavailable.

Bundle fields contain structural-verification results, active-answer and
evidence-basis counts, compact JSON for the basis-count distribution, and domain
decisions (proposed, adopted, independently computed algorithm output, and any
recorded override rationale/evidence). Baseline trace fields are unavailable.
The empty award-1-2014 Haiku bundle has no assessed domains; its presence or
structural verification supplies no missing judgement. Scoring remains governed
by the frozen exported labels.

Round 3 adds bundle-path-checks.csv (all domain history records, final flags,
required-path validity and active-answer completeness) and
bundle-trace-evidence.csv (eligible consensus cells with linked cited passages,
source/page locators, evidence identifiers and abbreviated answers). Regenerate
both with `Rscript extract-bundle-review.R`. This bundle-only extractor fails
on missing bundles and invalid ARBITER paths and does not require raw logs.
