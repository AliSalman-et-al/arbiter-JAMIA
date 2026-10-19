# Literature brief: LLMs and Cochrane RoB 2

## Why this exists

We are writing a JAMIA (Research and Applications) paper on ARBITER (Agentic Risk of Bias Inference Tool for Evidence Reviews). We need an accurate map of prior work so that the Introduction states a real gap and the Discussion compares fairly.

ARBITER in one paragraph: an LLM agent reads trial reports and registry records and answers the RoB 2 signalling questions. A separate rule-based server (no AI) stores an unchangeable copy of each source, checks that every quoted passage exists in the stored copy, applies the official RoB 2 domain and overall algorithms to the model's answers, rejects incomplete or unbound answers, and writes an audit file that an independent verifier can check. On 102 trials from 16 meta-analyses, ARBITER and an unassisted model (same model, same files, no ARBITER) agreed poorly and similarly with published review labels (weighted kappa 0.34 vs 0.28). Two blinded adjudicators re-assessed every domain where an arm disagreed with the published label; where the two arms disagreed, they chose ARBITER's rating in 54 of 62 cells. Without ARBITER, 12.8% of domain ratings contradicted the model's own signalling answers under the RoB 2 algorithm. Published labels were usually less severe than the adjudicators' choice.

Our candidate gap claims, which your extraction must test:

- **G1 Algorithm enforcement**: prior LLM studies let the model state the domain judgement itself, or encode the algorithm only in the prompt; none computes judgements from the signalling answers in code and reports rule-consistency of the model's output.
- **G2 Evidence traceability**: prior studies do not bind each answer to a verified passage in a stored source, or produce an auditable record.
- **G3 Reference noise**: prior studies treat published (often Cochrane) labels as the reference standard, without measuring or correcting their error.
- **G4 Adjudication**: prior studies do not use blinded expert adjudication of disagreements between the model and the published label.
- **G5 Agentic/tool design**: prior studies use single prompts or chat interfaces, not an agent working through tools against a server.

Evidence that a prior study already did any of G1–G5 is the most valuable thing you can find. Report it plainly.

## Rules

- Read the **full text** (methods, results, discussion, supplements when reachable), not just the abstract. If you cannot obtain full text, say so explicitly and state what you used.
- Never invent numbers. Every number and every quotation must come from the source; give the section or table. Quote verbatim in double quotes.
- Useful full-text routes (shell has network): Europe PMC REST `https://www.ebi.ac.uk/europepmc/webservices/rest/PMC<id>/fullTextXML`; `https://www.ncbi.nlm.nih.gov/pmc/articles/PMC<id>/`; publisher pages via DOI; arXiv `https://arxiv.org/abs/<id>` and HTML `https://arxiv.org/html/<id>`; medRxiv. Save raw downloads only under `/tmp/`, never in the repo.
- Write only your assigned output file(s) under `docs/research/llm-rob2/`. Do not edit anything else in the repository. Do not commit.

## Extraction template (one section per paper)

```markdown
## <First author> <year>, <journal>: <short title>

- **DOI / IDs**:
- **Full text read**: yes/no; source used
- **Design**: (validation, feasibility, etc.; preregistered?)
- **Sample**: trials, outcomes, reviews/meta-analyses, fields
- **Tool**: RoB 2 / RoB 1 / other; effect of assignment or adhering
- **Models and dates**:
- **Inputs**: full text, protocol, registry, supplements? how provided
- **Prompting / system design**: single prompt, signalling questions, chain-of-thought, RAG, agent, tools
- **How domain judgements were produced**: model stated it / algorithm in prompt / algorithm applied in code to model answers
- **Rule-consistency checked?**: did they check whether judgements follow the RoB 2 algorithm? results
- **Evidence handling**: quotes requested? verified against source? stored? audit trail?
- **Reference standard**: what, and did they question or measure its reliability?
- **Adjudication of disagreements**: any? blinded? by whom?
- **Headline results**: kappa/accuracy by domain and overall, sensitivity/specificity, direction (does the model over- or under-flag risk relative to the reference?)
- **Repeatability, time, cost**:
- **Authors' stated limitations**: (verbatim where useful)
- **Authors' conclusions**:
- **Quotable sentences**: 2–5 verbatim with location
- **Bearing on G1–G5**: for each, supports gap / contradicts gap / not addressed, with one-line reason
- **Implication for ARBITER manuscript**: 1–3 lines
```

End your file with a short **Worker summary**: which gap claims your papers support or contradict, and anything surprising.
