# Riaz publication-history synthesis for ARBITER

## Scope and confidence

Four Luna Medium research slices covered the recent publication inventory, evidence-synthesis articles, clinical AI methods, and author voice across genres. The PubMed author query `Riaz IB[Author] AND (2023:2026[dp])` returned 72 records; the census worker screened their title/author/date records, and the parent independently confirmed the count on 23 October 2026. Primary publisher, Mayo/BEACON, PMC and preprint searches extended that frame. This is broad relevant-history coverage, not a claim that every publication was read in full or that every non-PubMed work was found.

Full-text readings overlap across slices and must not be summed into a paper count. The evidence-synthesis slice records eight complete works; other slices add distinct papers or different access levels. The census ledger has 43 source rows, including records, exclusions and version/context entries; it is not a count of 43 unique relevant papers. All four ledgers have consistent fields within each file.

The strongest guide to a research manuscript is the recurring practice across empirical articles. The sole-author JCO overview provides more direct evidence of individual wording, but its editorial genre and indexed-text access limit transfer. Shared original-draft credits establish participation, not ownership of each sentence. We can infer likely editorial priorities with qualification; we cannot promise his preference or approval.

## Practices to adopt

| Recurring practice | Supporting examples | Application to ARBITER |
| --- | --- | --- |
| Establish the practical clinical or evidence-use problem before introducing the computational solution. | Mayo living-evidence perspective; JAMIA extraction; npj distillation; living PARP meta-analysis | Open with RoB 2's role, the work required for result-specific assessments and updating evidence, then prior automation and the exact remaining problem. Introduce ARBITER only after that need is clear. |
| Explain what each unfamiliar operation receives, does and produces. | JAMIA preprocessing through cross-critique; npj teacher/student configurations; EviSearch extraction and review; FD-SCoPE retrieval versus derivation | Follow documents -> selected evidence -> signalling answers -> software-derived ratings -> retained assessment. Explain the purpose of each safeguard at its point of use. |
| Organize Results around meaningful comparisons or clinical strata, not a list of statistics. | Living mCRPC and PARP syntheses; npj outcome-specific results; JAMIA baseline and concordance groups | Benchmark composition -> Published exact agreement -> independent-expert exact agreement -> conditional primary label choice -> domain/answer detail -> structural checks -> computation. Exact agreement precedes kappa. Keep formal outcome status explicit. |
| Keep the endpoint, reference, population and uncertainty close to the result. | Clinical syntheses and empirical AI papers | Preserve 510 full-cohort cells separately from 80 discordant cells, 60 agreed choices and 20 splits. Do not use the selected-subset percentage as a broad accuracy claim. |
| Return to the intended task in Discussion and state concrete limits. | Living-review clinical interpretation; JAMIA/npj limitations; evidence-system discussions | Explain what an experienced reviewer can inspect and what the study established. Distinguish available capabilities from measured reviewer benefit and living-system deployment. |

These are useful repeated article features, not uniquely identifying stylistic fingerprints.

## Quirks and tendencies worth knowing

- **Substantial explanation is acceptable when it serves the question.** The empirical Methods sections are often dense. There is no basis for reducing ARBITER to uniformly short sentences or stripping established RoB/statistical terms. Use one coherent purpose per paragraph and vary sentence length.
- **Clinical syntheses use recurring subgroup-led sentences.** Patient/treatment/endpoint qualifiers often lead paragraphs. For ARBITER, use the reference source or domain to orient a paragraph, but do not reproduce every subgroup row in prose.
- **Transitions commonly connect a capability to a remaining constraint.** Make the reason for the next step explicit. Avoid filling every paragraph with the same “however” construction.
- **First-person plural is available, not compulsory.** Use “we” for study decisions/actions when it clarifies responsibility; use the system or software as subject for operations.
- **Review and perspective language is markedly broader.** The Cancer review and JCO overview contain expansive, future-facing claims. This is a real counterexample to an imagined consistently restrained voice. Borrow their clinical anchoring, not their superlatives or breadth of prediction.
- **Endings depend on genre.** Empirical papers qualify observed performance; perspectives can advocate an agenda. ARBITER should resolve its tested question and end on the evidence-linked record and bounded agreement finding.

## Specific mechanism wording

The implementation investigation supports explaining text evidence as a constrained source selection. The model can pass a returned passage reference, page/line range, or copied text as a locator. The tool matches the selection to captured text and stores the source slice. It does not accept arbitrary generated quotation wording as valid evidence. This is more precise than “the model never types citations.”

The safeguard constrains fabricated quotation wording in this pathway; it does not establish relevance, completeness, accurate PDF extraction or correct interpretation. Image descriptions remain model-written. The separate rating safeguard applies the official algorithms to recorded answers; it cannot repair an incorrect interpretation in those answers. State these boundaries once where the reader needs them, rather than repeating a general caveat throughout the paper.

## Source hierarchy for the rewrite

1. Current author instructions and actual study records control the study's meaning and order.
2. Verified implementation/provenance controls the mechanism account.
3. Primary literature controls claims about prior automation, workload and living evidence.
4. The publication-history sample supplies structural examples and possible editorial priorities.
5. Schimel/Heard/Zinsser and clinical-writing guidance supply the editing rubric; no coauthor's style overrides claim fidelity.

The full ARBITER expansion and evidence-linked title are author-confirmed. Published-first and exact-agreement-first are author-confirmed, not inferred from Riaz's papers. This research creates no requirement to cite a paper merely because he authored it.

## Quality corrections and access gaps

- The voice worker twice attributes the trial-table lookup/derived-attribute distinction to EviSearch. That is FD-SCoPE's task. The parent checked the cached EviSearch text, which concerns extraction, attribution, disagreement-directed review and feedback. Reject those misattributed examples and do not use the worker's cross-paper frequency counts as verified measurements.
- The clinical-ai worker's statement that the clinical-writing skill was unavailable is an erroneous environment claim. The parent read the actual skill and relevant Schimel OCAR passages; that worker used prior book summaries. Its article observations are not a fresh direct book audit.
- The Sol structure memo's provisional reference order is superseded by the author's Published-first confirmation, recorded in its parent addendum.
- ROBINS-I remains abstract/contributor-record level. The sole-author JCO overview was inspected through primary publisher-indexed passages; no complete local PDF was recovered. PICOS and several other records remain abstract/metadata-only. Do not use those records for unseen paragraph-level claims.
- The PARP meta-analysis was fully read by the evidence slice via an accessible mirror checked against primary metadata, although the census slice itself had only abstract-level access. These are different inspection scopes, not contradictory access claims.

Disposition: **use the cross-paper structure and task-oriented explanation, with the corrections above.** The author interview remains open on expert procedures, prompt development/overlap and endpoint chronology. No canonical manuscript or published artifact changed during this research stage.

## Reports

- [Publication census and source ledger](census/report.md)
- [Evidence-synthesis and clinical-methods reading](evidence/report.md)
- [Clinical AI methods reading](clinical-ai/report.md)
- [Voice and genre comparison; see corrections above](voice/report.md)
- [Detailed Sol paragraph maps](../riaz-structure.md)
- [Verified ARBITER mechanism](../mechanism.md)
