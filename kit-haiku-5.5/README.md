# rob2-kit benchmark: Claude Code, Haiku 5.5 (Medium)

Run 2026-10-14, rob2-kit 2848c79 (same commit as the Sonnet kit run), model claude-haiku-5-5, effort medium.
Same 105 trials as the Sonnet kit run (rob2-meta-set-full-2026-10-03, with acquire_documents = true for the 73
trials with an NCT). Scored on Ali's 102 (atwine-2020, haney-2004, herrmann-2016 excluded) in results-102/ and on
all 105 in results-105/. Claude Code 2.1.278, isolated scratch home (no claude.ai connectors, no synced or bundled
skills, no auto memory). Stop rule (Zaid, 2026-10-14): when a session ended before finishing, the harness replied
"Continue." and nothing else, at most twice per phase; every such reply is in continues.csv and in
logs/<slug>/meta.json ("continues").

Prompt and approval as in the Sonnet kit run: "/rob2-assess Assess risk of bias for {assess_outcome} defined as
{assess_values_as_printed} in {slug}." (verbatim); at Proposal Review the harness approved the proposal
unchanged with `rob2 review` and resumed with "Approved.". The rule was in place for cases started after 17:20;
cases that had ended unfinished before then (6 from the server not being ready after resume or the Mac sleeping,
4 where Haiku stopped) were rerun from scratch under it. 103 of 105 finalized (not finalized: atwine-2020,
haney-2004, both outside the 102). Web search and web fetch were available as in the Sonnet kit run; 0 web calls
in any case.

## Results on the 102

| scope | cells | exact | Low vs SC/High | all-Low baseline |
|---|---|---|---|---|
| D1-D5 pooled | 510 | 355/510 = 69.6% | 375/510 = 73.5% | 427/510 = 83.7% |
| Overall | 81 | 43/81 = 53.1% | 54/81 = 66.7% | 42/81 = 51.9% |
| D1-D5 and Overall pooled | 591 | 398/591 = 67.3% | 429/591 = 72.6% | 469/591 = 79.4% |
|---|---|---|---|---|
| Overall | 81 | 43/81 = 53.1% | 54/81 = 66.7% | 42/81 = 51.9% |
|---|---|---|---|---|
|---|---|---|---|---|

Files: results-102/ and results-105/ (rob2kit-domain-labels.csv/.xlsx-ready csv, rob2kit-signalling-answers.csv,
accuracy.md with by-domain and by-field tables), continues.csv, logs/<slug>/ (turn*.jsonl stream-json, review.txt,
meta.json), bundles/<slug>.rob2.zip, scripts.
