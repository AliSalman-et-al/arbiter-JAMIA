# Figure 1 notes

## Tool-to-phase grouping

ARBITER 1.0.0. Line references below are to `src/arbiter/interfaces/mcp/server.py` in the ARBITER source checkout. The figure shows representative tools, without server prefixes. This is a functional grouping, not an assertion that tools can run only in one phase.

- **Capture:** `prepare_batch` (line 2572), `acquire_companion_source` (line 2735), `admit_companion_source` (line 2768), `list_sources` (line 2810).
- **Propose & approve:** `validate_proposal` (line 3991), `save_proposal` (line 4023), `request_proposal_approval` (line 4145).
- **Assess each domain:** `get_domain_context` (line 4350), `read_guidance` (line 2447), `read_pages` (line 3255), `search_sources` (line 2873), `calculate_arithmetic` (line 2477), `save_working_checkpoint` (line 2675), `save_domain_judgment` (line 4542), `get_status` (line 2623).
- **Review & export:** `review_trial` (line 4648), `close_trial` (line 4802), `finalize_batch` (line 4831).

Capture freezes source bytes and searchable projections. Companion acquisition/admission can also occur later; admission invalidates the affected review. `read_pages`, `search_sources`, `list_sources`, `read_guidance`, `get_status`, and working checkpoints support more than one phase. `calculate_arithmetic` is optional stateless arithmetic, not judgement generation. `save_domain_judgment` accepts the agent's answers, binds evidence and invokes the official algorithm. `review_trial` computes/reviews the overall result; `close_trial` closes its current review; `finalize_batch` packages already-final trial records. `request_proposal_approval` requests human approval through MCP elicitation; the runs used the host `rob2 review` route. It is not an agent self-approval. The drawing's arrows represent agent requests and a packaged artifact, not a complete call sequence.

Skill reference: `src/arbiter/skills/arbiter-assess/references/selection.md`, question 5.1. The skill supplies the question-by-question guidance; the server makes no model calls.

## Exact trace

- Trial: `banovic26-avatar-2024`; outcome: all-cause death, long-term follow-up. Bundle SHA-256: `d6d683efd3acce82f9e0ee233d194223c569ffb7ac76ab74e45c6c4071fb6655`.
- Question 5.1: Were the data analysed in accordance with a pre-specified plan finalized before unblinded outcome data were available?
- Answer: **No information**; this question is the recorded D5 driver.
- Figure excerpt (11 words, one omission): “Prespecified secondary end points included the following: … Time to death”.
- File: `CIRCULATIONAHA.121.057639.pdf`, physical page 4; bound evidence span lines 16–35, character offsets [612, 1492). The excerpt components are on lines 21 and 34; ellipsis omits intervening secondary endpoints.
- Evidence: `sha256:7ad155913c1c58263ae1f68422aa27e610b681a3d164be094e441d48d5fd3bb4` / `eh_7ad155913c1c5826`; source ID `source_695a701df7a7b784e50a68c4ab749ed7917e3cb84d87a08196adbdf37c6e4d56`.
- Source version (searchable projection SHA-256): `sha256:592b9a6c531c0b049f2039fffd71fd128e6a604e908c06cec2bb153c4878b8a0`. The figure displays its first 12 hex characters, not the PDF byte hash.
- Captured PDF byte SHA-256: `sha256:dd643e8a0fc65605457c9a030145c67c4d87c43095476bd2b3440008f8513fab`.
- Binding semantics: this basis is recorded as **context**, not direct support. The report's use of 'prespecified' does not establish when the plan was finalized. The repeated yellow pills link the context passage to the answer's reasoning, not proof of missing information from one quote alone.

Recorded justification:

The registry entry (first submitted 30 Apr 2015, before enrolment began in June 2015) names all-cause death only as a component of composite outcomes. It does not list time to all-cause death as a separate outcome. The Circulation 2022 and EHJ 2024 reports describe 'time to death' as a prespecified secondary end point analysed with Kaplan-Meier and Cox models, citing a published protocol. That protocol is not among the captured Sources, and the report statements are not date-stamped before unblinded data. The only SAP-type document is an amendment dated 4 Jan 2021 about COVID surgical delays. No dated source therefore specifies this measurement and analysis.

Full server-extracted passage:

> Trial End Points
> The primary end point was a composite of all-cause mortality
> or major adverse cardiovascular events (MACEs) composed of
> acute myocardial infarction, stroke, and unplanned HF hospital-
> ization needing intravenous treatment with diuretics or inotro-
> pes. Prespecified secondary end points included the following:
> • In-hospital and 30-day postoperative mortality in oper-
> ated patients in both groups
> • Repeat aortic valve surgery in operated patients in both
> groups
> • Repeated MACEs, including stroke, acute myocardial
> infarction, or unplanned HF hospitalization needing IV
> diuretic treatment
> • Major bleeding defined as types 3, 4, and 5 according
> to the consensus report from the Bleeding Academic
> Research Consortium13
> • Thromboembolic complications on the basis of clinical
> symptoms, signs, and imaging studies
> • Time to death
> • Time to first HF hospitalization

D5 answer set: 5.1: No information; 5.2: Probably no; 5.3: Probably no. NI = No information; PN = Probably no.
Proposed and adopted: Some concerns / Some concerns; authority: algorithm; no override. Verification result: `verified` (from archived verification.json; the build does not re-run the independent verifier).

Label sources: `rob2-meta-benchmark-set/LABEL-TARGETS.csv`; `kit-sonnet-5.5/rob2kit-domain-labels.csv`; `no-kit-sonnet-5.5/model-domain-labels.csv`; `analysis/output/tables/adjudication-analysis-cells.csv` (both adjudicators' preferred labels agree). All are loaded at build time; the ARBITER D5 label is checked against the bundle.
ARBITER source commit inspected: `2f549ae30f056ff441ea61a04b719968716f2219`. The build checks all archived manifest content hashes; it reads, rather than re-runs, the archived verifier receipt.

## Draft legend

**Figure 1. ARBITER workflow and evidence trace.** (A) A reviewer approves the result to be assessed before domain assessment starts. The LLM agent uses the arbiter-assess skill to read sources and answer RoB 2 signalling questions. The model-free ARBITER MCP server captures and versions sources, binds cited text spans, computes domain and overall judgements using the official RoB 2 algorithms, records the assessment history and exports a verifiable bundle. Representative MCP calls are shown in monospace; tools used across phases are grouped by function in these notes. (B) AVATAR, all-cause death at long-term follow-up: the report describes time to death as prespecified, but the agent records no information for question 5.1 because the captured sources do not establish a plan for this measurement and analysis finalized before unblinded outcome data were available. Yellow highlighting links the report excerpt, recorded as context, to that answer. The complete D5 answer set produces Some concerns, adopted without override. The hash prefix identifies the captured source projection; archived bundle verification confirms binding and structural checks, not the clinical correctness of the answer. Published and Unassisted judgements are Low; both adjudicators prefer Some concerns. D1–D5, RoB 2 domains; NI, no information; PN, probably no; MCP, Model Context Protocol.

## Alt text

Two panels. A: Reviewer, lavender LLM agent, mint deterministic ARBITER server and pale-yellow bundle lanes span Capture, Propose and approve, Assess each domain, and Review and export. Reviewer approval precedes assessment. The agent supplies cited answers; the server checks spans and computes judgements. B: AVATAR has Low judgements for D1–D4 and Some concerns for D5 and Overall. A cited passage calls time to death a prespecified secondary endpoint. Question 5.1 is No information because a dated plan is not established by captured sources. D5 answers NI, PN, PN yield Some concerns, adopted unchanged. The passage is bound to a hashed captured source; archived bundle verification is verified. Published Low; adjudicators Some concerns; Unassisted Low.
