# rob2-kit benchmark: Claude Code, Sonnet 5.5 (Medium)

Run 2026-10-12, 12:12 to 19:17 EDT, on the 105 trials of `rob2-meta-set-full-2026-10-03` with
`acquire_documents = true` under `[registry]` in the 73 `sources.toml` files that carry an NCT.
All 105 cases finalized.

## Results

`results/accuracy.md` has every table. Headline:

| scope | cells | exact | Low vs SC/High | all-Low baseline |
|---|---|---|---|---|
| D1-D5 pooled | 525 | 74.3% | 78.5% | 83.0% |
| Overall | 84 | 56.0% | 72.6% | 51.2% |
| D1-D5 and Overall pooled | 609 | 71.8% | 77.7% | 78.7% |

Only cells with a human label of Low, Some concerns or High are scored. Overall is absent for 21
trials whose meta gives no per-trial overall (preoxygenation and SGLT2 metas give domains only,
the IgA meta gives a point sum).

- `results/rob2kit-domain-labels.xlsx` (and `.csv`): one row per trial, rob2-kit D1-D5 and
  Overall beside the human labels, with exact and Low vs SC/High match flags.
- `results/rob2kit-signalling-answers.xlsx` (and `.csv`): one row per trial and signalling
  question, with rob2-kit's answer, whether the question was active, and its justification.

## Setup

- rob2-kit commit 2848c79 (main, 2026-10-12 15:32 UTC), loaded with `--plugin-dir` from a local
  clone. Claude Code 2.1.278, `claude -p --model claude-sonnet-5-5 --effort medium
  --output-format stream-json --verbose --permission-mode bypassPermissions`.
- Isolation: a scratch `CLAUDE_CONFIG_DIR` with no skills, plugins, CLAUDE.md or memory, plus
  `claude-home-settings.json` (claude.ai connectors off, synced and bundled skills off, auto
  memory off) and `ENABLE_CLAUDEAI_MCP_SERVERS=false`, `CLAUDE_CODE_DISABLE_AUTO_MEMORY=1`,
  `CLAUDE_CODE_DISABLE_BUNDLED_SKILLS=1`. Each case ran in its own folder holding only
  `input/<slug>/`. The session loaded only the rob2-kit plugin and its MCP server.
- Prompt, verbatim fields: `/rob2-assess Assess risk of bias for {assess_outcome} defined as
  {assess_values_as_printed} in {slug}.` The exact prompt per case is in `logs/<slug>/meta.json`.
- Human emulation, no coaching: in `-p` mode Claude Code cannot show the approval elicitation, so
  every session stopped at Proposal Review and asked for `rob2 review`. The harness answered `yes`
  to `rob2 review` (approving the proposed Result unchanged) and resumed the session with
  "Approved." and nothing else. Every case took exactly these two turns.
- Logs: `logs/<slug>/turn1.jsonl` and `turn2.jsonl` (stream-json), `review.txt` (the approval),
  `meta.json` (prompt, commit, timings, usage). Finalized bundles: `bundles/<slug>.rob2.zip`.
- Scripts: `run_case.py`, `run_all.py`, `score.py`.

Median 7.5 minutes per case. Usage over the run: about 577M tokens, almost all cache reads.
