# Derived run metrics

One CSV per arm, restricted to the 102-trial analysis set. Reports read these
files; they do not open raw logs or bundles. Regenerate from analysis/ with:

```powershell
& 'C:/Program Files/R/R-4.6.1/bin/Rscript.exe' R/extract-run-metrics.R
```

The extractor requires every trial's metadata and turn JSONL. It streams each
turn log in bounded chunks and compares terminal token counters with metadata.
Only after the complete inventory validates does it write the two reported CSVs.
Re-extraction was checked to produce byte-identical CSVs.

Seconds, token counters, harness-reported USD, and agent steps are sums across
turns. Thinking tokens are a component of output tokens. Continue counts agree
between metadata and the continuation CSV. Approval is whether the ARBITER
result-approval command succeeded; baseline approval is unavailable.

Bundle fields contain structural-verification results, active-answer and
evidence-basis counts, compact JSON for the basis-count distribution, and domain
decisions (proposed, adopted, independently computed algorithm output, and any
recorded override rationale/evidence). Baseline trace fields are unavailable.
`bundle-path-checks.csv` contains all domain history records, final flags, required-path validity and active-answer completeness. `bundle-binding-counts.csv` records source binding. Regenerate these files with `Rscript extract-bundle-review.R`; the extractor stops on missing bundles and invalid paths and does not need raw logs.

The binding cost amendment is implemented by `Rscript extract-api-costs.R`.
It streams raw logs and requires every terminal result. api-cost-turns.csv and
api-cost-trials.csv retain request, terminal, side-call and signed residual token
components, tier counts, compaction flags, API point/lower/upper equivalents,
five-minute side-write sensitivity and unusable harness cost. Table 5 uses the
API point estimate. The reconciliation and complete cost summaries are exported
by run.R. Rates are frozen to plan section 5.8. Synthetic zero-usage messages
are excluded. Reports read derived CSVs and never stream raw logs during render.

## Full-coverage expert signalling data

`expert-signalling-components.csv` is regenerated from the `Signalling evidence` sheet of each full-coverage expert workbook by `R/signalling.R`. Each row identifies the original workbook row, expert, trial, phase, domain, numbered question and explicit answer component. Raw answers, change text, evidence and guidance are retained. `change` normalises the question-row text to retained, changed or mixed; stated from/to answers and transition strings are preserved. Empty change status in the independent phase is expected. Unresolved answers receive a parse issue and remain missing.

`expert-signalling-comparisons.csv` joins those independent components to the arm answers through the official question-number mapping. Scalars are not broadcast across components. Evaluability and its reason are explicit. NA, inactive questions, missing answers and unmatched components are excluded from agreement, and all exclusions are counted. These files are intermediate data, not reader-facing tables.
