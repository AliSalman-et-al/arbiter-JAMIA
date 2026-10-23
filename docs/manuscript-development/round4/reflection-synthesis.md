## Accepted

| Problem | Proposal | Routing |
|---|---|---|
| A generic audience label let writers simplify familiar clinical concepts alongside unfamiliar software concepts. | Strengthen the existing audience guidance by recording familiarity per discipline in the story contract and sharing those criteria with every writer and judge. | `/home/ali/Documents/Code/skills/clinical-research-writing/SKILL.md` — Operating Loop, story contract and audience-fit audit. |
| A coauthored article supports observations about the article, not an individual author's writing preferences. | Require style exemplars to distinguish observed article features from author preferences supported by direct attribution. | `/home/ali/Documents/Code/skills/clinical-research-writing/SKILL.md` — minimum evidence pack. |
| Generic IMRaD and abstract templates can miss the target journal's required components. | Before outlining, inspect the journal's current article-type instructions and record required headings and abstract components in the evidence pack. | `/home/ali/Documents/Code/skills/clinical-research-writing/SKILL.md` — minimum evidence pack and outlining. |

## Rejected

- Principle: Missing methods facts should keep dependent interpretations provisional even when numbers are correct.
- Reason: already-covered — Hard Rules already separate facts from interpretation, and Story Contract explicitly requires returning a blocking gap instead of polished final-looking prose.

## Backlog

- Repeated heading names caused integration to confuse abstract and main-text Discussion while numerical checks passed; retain the existing structural checks and add a regression fixture requiring hierarchy-scoped edits and independently validated section order.
- Publication versions were confused during exemplar collection; add canonical-work metadata with separate version identifiers and publication status, then deduplicate counts and flag unresolved identity before exemplar selection.
- MCP verification returned identical normalized metadata for [the published record](https://pmc.ncbi.nlm.nih.gov/articles/PMC12005628/) and [the digest-identified preprint record](https://pmc.ncbi.nlm.nih.gov/articles/PMC11469465/); require publisher or repository version metadata because this lookup could not independently verify their distinction.

Parent disposition: apply audience and attribution discipline to this manuscript under existing user authorization. No shared skill files have been edited; those proposed edits remain subject to separate user approval. Preserve the existing structural audit when changing headings. The metadata lookup limitation is not evidence that the two repository versions are identical.
