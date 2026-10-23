# Publication workflow backlog

Local project tracker created for the requested reflect workflow. No external team devex tracker was designated. These are structural follow-ups, not completed repairs.

| ID | Task | Existing evidence/mechanism | Remaining acceptance condition |
|---|---|---|---|
| PUB-01 | Make finalized report refresh a staging dependency | report-refresh.py repairs stale includes; R entry points invoke it | Clean-checkout release gate rejects stale generated report inputs |
| PUB-02 | Retain content-based table parity in the release gate | verify-presentation.py compares HTML/Word cells | Gate exercises equality and fails on an intentionally altered cell |
| PUB-03 | Validate executable prerequisites | Publisher already defaults to Python 3 with ARBITER_PYTHON override | Early actionable failure when interpreter/build prerequisite is absent |
| PUB-04 | Bind verification to completed producers | Prior transient broken images/manifest mismatch disappeared after build completion | Gate waits for successful producer completion and records exact revision |
| PUB-05 | Verify deployed release identity | Prior live manifest and 50-file byte equality check succeeded | Repeatable release gate compares deployment to staged revision before verified status |

## Skill proposals: pending, not applied

The full Accepted / Rejected / Backlog synthesis is [reflect-synthesis.md](reflect-synthesis.md).

Accepted judgment-level proposals remain appropriate after structural review:

1. Clinical-writing Operating Loop: resolve conflicting reviewer advice against the latest accepted brief and rationale, while distinguishing project authority from evidence supporting scientific claims.
2. Documents visual-review reporting: separate page coverage from reviewer independence, naming self-inspected ranges and failed reviews.
3. Documents handoff: state executed checks and unexecuted production paths with reasons; limit verification claims accordingly.

These rules concern interpretation and reporting, which scripts alone cannot fully enforce. The earlier handoff did not explicitly claim every page was independently reviewed or that the full R pipeline ran; the proposals improve precision rather than establish intentional misreporting.

Rejected proposals remain rejected: two new publication skills are better addressed structurally (PUB-01–05); pagination rerendering is already covered; a second clinical-writing verification-boundary rule duplicates the documents proposal.

No shared skill file was edited. The reflect skill requires presenting the full synthesis and explicit approval before applying accepted shared-skill edits.
