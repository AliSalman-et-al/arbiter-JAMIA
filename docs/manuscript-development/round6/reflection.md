# Round-six reflection

Status: proposed skill changes only; none applied. The backlog below is recorded in this repository's manuscript-development tracker. The parent structural-enforcement check retained the three mechanism proposals in Backlog; the five Accepted proposals require editorial/source judgment.

## Accepted

| Problem | Proposal | Routing |
|---|---|---|
| Established methods became witness testimony, obscuring the investigators’ account. | Require investigator-voiced Methods and move reconstruction history to supporting material unless it changes interpretation. | `/home/ali/Documents/Code/skills/clinical-research-writing/SKILL.md` — Operating Loop §8, section placement. |
| Generic citation language concealed the evidence supporting the argument. | Make “credible evidence chain” actionable by requiring the relevant literature finding, available magnitude, and contextual boundary. | `/home/ali/Documents/Code/skills/clinical-research-writing/SKILL.md` — Core Moves. |
| Percentages were converted to counts without establishing the assessment denominator. | Clarify “valid transformation” by requiring verified assessment units, repetitions, and aggregation before deriving counts. | `/home/ali/Documents/Code/skills/clinical-research-writing/SKILL.md` — Hard Rules. |
| Correct numeric tokens survived alongside a false comparator identity, confirmed against the [primary abstract](https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0353155). | Require primary-source checks of consequential definitions and complete claim relationships before distributing evidence packs and during final audit. | `/home/ali/Documents/Code/skills/clinical-research-writing/SKILL.md` — Operating Loop §§3 and 8. |
| Arena’s consensus instruction can mistake shared factual inheritance for independent corroboration. | Qualify “ship the consensus shape” so agreement on design never substitutes for verification of shared factual premises. | `/home/ali/.codex/plugins/cache/pstack-claude/pstack/0.9.102/skills/arena/SKILL.md` — Phase E. |

## Rejected

- Principle: Inspect repeated assessments before deriving counts from percentages.
- Reason: duplicate — merged into the accepted numerical-transformation clarification.

- Principle: Verify shared-pack acronyms and comparator identities against primary text.
- Reason: duplicate — merged into the accepted evidence-pack and claim-relationship check.

- Principle: Preserve investigator knowledge without manufacturing uncertainty through attribution.
- Reason: duplicate — merged into the accepted investigator-voice and section-placement edit.

- Principle: Verify comparator, assessment unit, and aggregation alongside numerical tokens.
- Reason: duplicate — incorporated into the accepted numerical-transformation and complete-claim checks.

## Backlog

- **Generated-include dependencies:** Quarto encountered a missing manuscript include while rendering Results; enforce prerequisite generation and retain a clean-checkout rendering test with generated includes absent.
- **External-claim provenance:** Literature claims could appear validated through coincidental study-CSV matches; retain the existing exact-span, reference/DOI, and separate-classification checks, with regression coverage for coincidental matches.
- **Protected publication artifacts:** Prose integration needed to preserve finalized statistical and supporting outputs; expose the existing manuscript-only build path through an explicit build target and verify protected-artifact hashes remain unchanged.
