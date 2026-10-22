# Approved implementation handoff

The author answered yes to the final shared-understanding checkpoint and requested implementation by GPT-6.1 Sol with relevant Pstack skills applied efficiently. No further design approval is required. Implement the complete rebuild, not another proposal.

## Scope authority

Read `rebuild-brief.md` and `second-review/blueprint.md` first. These consolidate accepted decisions and adjudicate the earlier worker reports. Read `legacy-display-review.md` selectively to locate old output defects. `discussion.md` supplies decision context. Reuse this research instead of reopening it. The latest author direction excludes chronology/history declarations from the manuscript and supplement; do not add a reconciliation requirement.

The paper is a JAMIA system-and-evaluation article about an available, inspectable RoB 2 workflow and its same-model evaluation. Follow the OCAR argument and local writing-book applications in the blueprint. Use journal article conventions for manuscript prose. Pstack technical-writing advice must not turn the paper into developer documentation.

## Ownership and constraints

You are the sole implementation worker, but you are not alone in the shared checkout. Preserve others' edits and adapt to them. The parent will handle independent review after your return. Do not spawn nested agents, launch design panels, or repeat the literature swarm. Do not commit, push, open a PR, or modify skills. Leave a reviewable working diff.

Own the necessary analysis presentation/export code, manuscript source and references, generated current publication/HTML outputs, and focused verification updates. Typical locations are `analysis/R/`, `analysis/run.R`, `analysis/verify-output.R`, `analysis/tests/testthat/`, `docs/manuscript/`, `analysis/output/`, `analysis/results.html`, and `analysis/supplement.html`. Discover the actual generators before editing. Do not hand-edit generated deliverables as a substitute for fixing their source. Do not modify raw data, expert workbooks, historical plans/reports, or input logs.

Hard requirements:

- Preserve Figure 1 and Figure 2 source artwork and output bytes. Capture and compare hashes.
- Sonnet-only study reporting in the manuscript and supplement. Do not mention the separate one-off experiment. Prior literature can be discussed accurately without expanding this study's scope.
- No published-target matching subset, filter, stratum, or sensitivity. Full 510-cell domain comparisons remain. The ordinary 81-trial observed Published Overall subset remains a missingness rule.
- Retain the formal conditional primary endpoint, 53/60 agreed choices from 80 arm-discordant cells with 20 splits. All-cell separate-expert comparisons carry the broader explanation.
- Reuse finalized estimands, bootstrap mechanics and verified numerical estimates. No new model experiments or speculative hypothesis tests. Only justified descriptive transformations needed for the agreed diagnostics.
- Target five main figures and three tables. A sixth figure is permitted only if actual legibility requires it. Figures 1–2 remain protected. Build Figures 3–5, Tables 1–3 and the reorganized supplement according to the blueprint.
- Distinguish absolute rates, paired differences, source-specific versus paired eligible denominators, five-level versus collapsed answers, derived Overall, structural checks and resource estimates.
- No accuracy/truth, expert-equivalence, causal component, semantic-support verification, or human-time-saving claims. Make the positive system contribution concrete and cite the public repository plus evaluated version.
- Omit chronology/history declarations from manuscript and supplement. Explain what the evaluation did, including expert sequence, populations, outcomes and methods.

## Efficient workflow

Apply the following Pstack leaf skills, reading their SKILL.md files under `C:/Users/Ali-Salman/.codex/plugins/cache/pstack-claude/pstack/0.9.101/skills/`: `principle-sequence-verifiable-units`, `principle-prove-it-works`, `technical-writing`, and `unslop`. Use other skills only where they solve a concrete implementation problem. The user prioritizes efficient usage; avoid recursive optional agent workflows. Parent owns the later independent review. Keep a concise progress/check record, not a transcript.

1. Inspect the generation path and existing tests. Record baseline commit, dirty paths and protected hashes. Save a compact numerical baseline outside overwrite targets if necessary. Existing research docs are untracked and `GLOSSARY.md` has accepted edits; preserve them.
2. Rebuild display organization and supplement navigation in the generators. Check output counts, estimate/denominator mapping and protection before moving on. The numerical Figure 4 prototype in `second-review/figure4-prototype.R` is a design reference, not a required implementation to copy.
3. Rewrite manuscript, captions and reference integration around OCAR. Follow the blueprint's paragraph jobs and draft abstract as a starting point, not a rigid script. Resolve citation placeholders. Use existing verified literature first; browse primary sources only for an actual unresolved claim. Keep main text within JAMIA's 4,000-word and abstract within 250-word limits.
4. Rebuild all current publication artifacts and the two HTML views together. Older HTML used obsolete 54/62 counts and different display numbering. Ensure one current numerical story across outputs.
5. Run meaningful existing checks and inspect actual rendered figures/tables/documents at reading size. Update checks for intended display changes without weakening numerical/protected-artwork guarantees. Fix failures and rerun only affected checks unless broader evidence requires it.

The documented commands from `analysis/` are `Rscript run.R`, `Rscript -e 'testthat::test_dir("tests/testthat")'`, and `Rscript verify-output.R`. Also inspect/use `docs/manuscript/verify-numbers.py` where applicable. Windows has Rscript at `C:/Program Files/R/R-4.6.1/bin/Rscript.exe`. R locale warnings occurred during the prototype but it rendered successfully. Inspect package availability before restoring/installing broadly. Use document/PDF skills when needed for generation and rendered QA; report any true rendering limitations rather than substituting metadata checks.

## Return contract

Write `implementation-report.md` beside this handoff. Report PASS/ISSUES/BLOCKED, baseline/head, changed source and artifact paths, retained numerical checks, protected hashes, exact verification commands and outcomes, rendered QA performed, any material unresolved defects and output links. Do not declare completion until manuscript, generated displays, supplement and HTML agree, or clearly identify a concrete external blocker. Do not repeat chronology concerns or ask for already-settled decisions. Return a concise summary to the parent for review.
