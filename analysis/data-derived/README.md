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

The binding cost amendment is implemented by `Rscript extract-api-costs.R`.
It streams raw logs and requires every terminal result. api-cost-turns.csv and
api-cost-trials.csv retain request, terminal, side-call and signed residual token
components, tier counts, compaction flags, API point/lower/upper equivalents,
five-minute side-write sensitivity and unusable harness cost. Table 5 uses the
API point estimate. The reconciliation and complete cost summaries are exported
by run.R. Rates are frozen to plan section 5.8. Synthetic zero-usage messages
are excluded. Reports read derived CSVs and never stream raw logs during render.
