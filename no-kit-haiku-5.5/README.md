# No-kit baseline: Claude Code, Haiku 5.5 (Medium)

Run 2026-10-14, model claude-haiku-5-5, effort medium, no rob2-kit.
Same 105 trials as the Sonnet kit run (rob2-meta-set-full-2026-10-03, with acquire_documents = true for the 73
trials with an NCT). Scored on Ali's 102 (atwine-2020, haney-2004, herrmann-2016 excluded) in results-102/ and on
all 105 in results-105/. Claude Code 2.1.278, isolated scratch home (no claude.ai connectors, no synced or bundled
skills, no auto memory). Stop rule (Zaid, 2026-10-14): when a session ended before finishing, the harness replied
"Continue." and nothing else, at most twice per phase; every such reply is in continues.csv and in
logs/<slug>/meta.json ("continues").

- Tools: only Read, Glob and Grep (`--tools Read,Glob,Grep`), no MCP servers (`--strict-mcp-config`), no skills
  (`--disable-slash-commands`), no web search or fetch. poppler installed so Read renders PDFs.
- Inputs (input parity with the kit runs): each trial's folder as delivered (main article, supplements,
  sources.toml), plus registry/<NCT>.md, the exact Markdown projection of the ClinicalTrials.gov record that
  rob2-kit showed the model in the Sonnet kit run (74 trials; copies in registry-markdown/), and the 60 protocol
  and SAP PDFs rob2-kit acquired from ClinicalTrials.gov. Built by build_nokit_inputs.py; nothing re-fetched.
- Prompt: the kit prompt without "/rob2-assess" ("Assess risk of bias for {assess_outcome} defined as
  {assess_values_as_printed} in {slug}."), followed by one fixed output-format sentence (nokit-format.txt; no
  RoB guidance). D1-D5 and Overall are read from the "FINAL:" line, signalling answers from the table.
- All 105 complete in one turn; no "Continue." was needed.

## Results on the 102

| scope | cells | exact | Low vs SC/High | all-Low baseline |
|---|---|---|---|---|
| D1-D5 pooled | 510 | 336/510 = 65.9% | 356/510 = 69.8% | 427/510 = 83.7% |
| Overall | 81 | 35/81 = 43.2% | 47/81 = 58.0% | 42/81 = 51.9% |
| D1-D5 and Overall pooled | 591 | 371/591 = 62.8% | 403/591 = 68.2% | 469/591 = 79.4% |
|---|---|---|---|---|
| Overall | 81 | 35/81 = 43.2% | 47/81 = 58.0% | 42/81 = 51.9% |
|---|---|---|---|---|
|---|---|---|---|---|

Files: results-102/ and results-105/ (model-domain-labels.csv, model-signalling-answers.csv, accuracy.md),
logs/<slug>/ (turn*.jsonl, final.md = the model's answer, meta.json), registry-markdown/, scripts.
