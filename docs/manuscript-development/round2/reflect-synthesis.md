## Accepted

| Problem | Proposal | Routing |
|---|---|---|
| Reviewer advice based on a superseded brief can reverse an accepted manuscript decision. | Before applying conflicting advice, identify the latest accepted brief and rationale, and record why the recommendation changes or preserves that decision. | /home/ali/Documents/Code/skills/clinical-research-writing/SKILL.md — Operating Loop |
| Self-inspection after reviewer capacity failure can be reported as an independent review pass. | Report page coverage and reviewer provenance separately, identifying self-inspected ranges and any incomplete independent review. | /home/ali/.codex/plugins/cache/openai-primary-runtime/documents/26.1011.51657/skills/documents/SKILL.md — Visual review and Final response |
| Successful artifact checks can imply that an unexecuted production pipeline was verified. | State which checks ran, which production paths remained unexecuted and why, and limit verification claims to the evidence obtained. | /home/ali/.codex/plugins/cache/openai-primary-runtime/documents/26.1011.51657/skills/documents/SKILL.md — Final response |

## Rejected

- Principle: Create `verify-publication-parity` to teach source equality and verification after builds settle.
- Reason: structural

- Principle: Create `arbiter-publication-release` to encode refresh commands, interpreter selection, table comparisons, and deployment checks.
- Reason: structural

- Principle: Rerender and inspect pagination after changing Word paragraph keep settings.
- Reason: already-covered

- Principle: Add a second verification-boundary rule to clinical writing alongside the accepted document handoff rule.
- Reason: duplicate

## Backlog

- Stale derivative pages survived ordinary rendering; the Results refresh exposed an obsolete table link, so make finalized-source refresh a required staging dependency and reject stale generated inputs.

- Styling assertions confused renderer details with content integrity; the table verifier now compares Word and HTML cells, so retain that mechanism and exercise it through the release gate.

- Interpreter assumptions broke staging with `python: not found`; the publisher now supports an override with a Python 3 default, so preserve that selection and add an executable prerequisite check.

- Verification raced active producers, yielding temporary broken images and manifest mismatches; gate checks on successful build or deployment completion and bind results to the produced revision.

- Deployment completion alone did not establish release identity; require deployed manifest and file-hash equality against the staged source revision before marking a release verified.
