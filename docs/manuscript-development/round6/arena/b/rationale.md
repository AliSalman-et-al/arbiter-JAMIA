# Candidate B: rationale and integration record

This is a complete independent manuscript candidate against baseline e5298934d2dc34dc127117a56eb5b73ce765e5f3. Only this output directory was written. No analysis, canonical file, build, git state, agent, or external message was changed or created.

## Story and evidence boundary

The clinical problem is retaining a defensible connection between a result-specific bias judgment and its evidence. The question is whether a complete evidence-linked workflow changes agreement relative to minimal prompting while making that connection inspectable. The answer is reference-dependent: no clear Published agreement advantage, higher agreement with each independent expert, and observed answer-to-rule conformance. Documentary support and reviewer benefit are separate, untested properties.

Introduction develops sampled reliability findings into the interpretation/implementation problem, then narrows existing automation capabilities to three distinct evaluation questions. Methods uses investigator actions and explains what the software receives, checks and stores. Discussion interprets the Published/expert discrepancy through possible target and convention differences without claiming those explanations were demonstrated. Gandhi develops reference dependence; Choi develops the answer-to-rule distinction; Liang develops the passage-to-answer gap; Soboczenski develops the need for measured human workflow outcomes. Their metrics are not ranked against ARBITER.

Results are verbatim from the canonical manuscript, verified by direct string equality after section extraction. All its numbers, unfavorable findings, display callouts and supplemental-results callouts are retained. Abstract is rewritten and Published-first. No formal primary/secondary/confirmatory outcome hierarchy is introduced; postanalysis reporting order remains explicit.

## Counts

Whitespace-separated counts, including subsection headings: abstract 228; Introduction 346; Methods 1452; Results 554; Discussion including Conclusion 932. Main body 3292 including main headings, excluding abstract/front/back matter/references. These conservative counts meet abstract ≤250 and body ≤4000. The canonical build/count program was not run, as requested. The front-matter count instruction now points to these candidate counts rather than falsely claiming a candidate build report exists.

## Alternatives considered and rejected

- A system-by-system literature inventory was rejected in favor of several comparisons with a defined argumentative purpose. RobotReviewer/ROBOTO2/RoBGuard remain concise capability precedents; numerical retrieval and editing results were not necessary to the core question.
- A headline centered on 53/60 was rejected because that is conditional on 80 arm disagreements and 60 agreed choices, with 20 splits. Full-cohort independent agreement carries the broader comparison.
- Treating Published as an inferior reference was rejected. Predominantly Low labels and target mismatch may change agreement but do not establish which judgments are correct.
- Attributing gains to executable rules was rejected: instructions, software and computational effort differ together. Rules-only recomputation cannot isolate their effects.
- Huang's numerical comparison was omitted. The in-flight parent correction establishes repeated assessments and invalidates inferred 11/20 and 19/20 counts. The corrected Evaluation Study title remains in the bibliography; no Table 4 number or reconstructed denominator enters the candidate.
- RoBGuard numerical performance was omitted because the split denominator was unresolved. RoB2-Evaluator was omitted because no full text was accessible; no inaccessible numbers or method claims were added. Nyrhi and LogiMed numerical/landscape detours were omitted because they did not advance the selected argument.
- Broad systematic-review duration estimates and clinical numbers from writing exemplars were omitted. Neither is needed to motivate this bounded appraisal study.
- Compression to short report-like declarations was rejected. Connective explanation is retained where it helps distinguish a finding, its plausible interpretation and the remaining uncertainty.

## Writing guidance and author examples

Read the clinical-research-writing SKILL.md, CONTEXT.md and manuscript-workflow reference. Read actual Joshua Schimel book text in the existing plain-text extraction at /tmp/schimel-writing-science.txt, especially §§3.3–3.4, 6.2–6.3, chapter 11, §16.10 and chapter 18/Methods (report locators). Also directly parsed the actual book index.html under /home/ali/Documents/Code/skills/book-references/Schimel Joshua/Writing Science_ How to Write Papers t Cited and Proposals That Get Funded/ and checked §§6.3, 11.1 and 16.10 against that source. The operative practices are a precise gap, local paragraph arguments, concrete evidence followed by interpretation, and scope matched to the design. No statistical guidance from the book was adopted.

Read frame.md, schimel-reading.md, author-exemplar-parent-review.md, all requested research reports and both requested scientific source ledgers, and the existing Riaz-history synthesis. Parent corrections override raw researcher errors, including ED corresponding-author identity and Joshua Schimel's name. Read the new salman-fulltexts/report.md and ejhf-parent-reading.md during drafting. Preferred article-level practice comes from the EJHF evidence→unresolved question progression and its comparisons differentiated by design/measurement. This informs the Published/expert discussion and rule-versus-interpretation distinction. The ED article is provisional contextual evidence only. The newly available report did not establish a retrieved Circulation full text; no such inspection or personal voice preference is claimed. No coauthor's paragraph authorship or approval is inferred.

## Change and retention map

- Front matter: title, article type, display totals, author/contact placeholders and keywords retained; candidate-specific word-count instruction substituted.
- Abstract: complete rewrite, exact agreement before coefficients, Published before independent experts, conditional choices and single-run boundary retained.
- Introduction: replaces broad reliability statements and extended system inventory with an empirical reliability argument and specific evaluation gap. General living-review motivation remains, without a review-duration number.
- System Methods: explicitly describes copied text as a locator and accepted quotations as actual stored source slices; separates captured-text fidelity from extraction/interpretation validity; keeps image limitation, proposed/adopted distinction, override requirements and AVATAR callout.
- Benchmark Methods: retains purposive sampling, unverified rankings/dates, table-order/availability selection, three author-designated exclusions including Atwine uncertainty, 43/105 target revisions, incomplete target alignment, identical supplied inputs, De Waal mismatch, complete-workflow comparison, single runs/dates and unknown snapshot identity.
- Expert Methods: retains independent-first frozen assessments, no AI, author-confirmed same materials/target prompt and access to guidance, randomized offered-label order, later revised ratings and all expert/procedure placeholders.
- Outcomes/statistics: compresses wording while preserving coding, missingness, component matching, process-check definitions, exploratory populations, bootstrap settings and scope, no multiplicity adjustment, reporting guidelines and no outcome hierarchy.
- Results: verbatim, all numbers and Figure 3–5/Table 1–3 callouts retained. Figure 1–2 and complete AVATAR trace callouts retained in Methods.
- Discussion: replaces repeated results/audit recitation with reference dependence, domain/coding interpretation, internal conformance, documentary support, design limitations and measured human workload as connected arguments.
- Back matter: retained verbatim, including all unverified author declarations, AI disclosure, pending archive/dataset citation, public release commit and repository/results/supplement artifact links.

## Exact proposed supplementary relocations

The following text is proposed for insertion by the parent. It has NOT been inserted into any existing supplementary artifact, and this candidate does not claim that these new blocks already exist there. Main text retains the scientific limitations and points to existing eMethods material. If integrating the candidate, add these blocks at the targets below before publishing.

### Target: eMethods → Software revision and public-release correspondence

> The installable public release is ARBITER 1.0.0, commit [2f549ae](https://github.com/AliSalman-et-al/ARBITER/tree/2f549ae30f056ff441ea61a04b719968716f2219). The evaluated runner invoked `/rob2-assess`; `/arbiter-assess` is the public command name. The retained release audit documents correspondence between the evaluated and public assessment commands, without establishing equivalence of the complete releases. Results pertain to the evaluated software revision, identified in eMethods.

### Target: eMethods → Development exposure and prompt provenance

> Recovered ARBITER `eval/` records contain ten prostate-cancer trials and synthetic diagnostic cases used in development. The author reports that the 102-trial benchmark was not used in development; the recovered records do not establish an exhaustive development-exposure history. [Pending: complete prompt and assessment-skill selection history and version-freeze documentation.]

### Target: eMethods → Prompt templates and execution protocol

> The retained prompt materials include both prompt templates, the command invoking the ARBITER assessment skill, the Unassisted format instruction and a filled example. The protocol allowed “Continue.” at most twice per phase without coaching. Unassisted received copies of the registry records and acquired documents from the ARBITER run; these were not fetched anew.

### Target: eMethods → Source checks and audit interpretation

> Runtime source-text matching, assessment-file verification and the structural source-provenance audit assess different objects. Runtime selection matches a locator to captured source text and stores the actual captured slice. The structural audit checks the retained source and location records and did not independently re-extract quotations from original documents. Image records link rendered source regions to model-written transcriptions. Neither source-location checks nor assessment-file integrity checks establish that a quotation or image interpretation justifies a signalling answer.

These blocks consolidate operational detail; duplicated statements that remain scientifically important in the main manuscript are intentional. No own Results numbers were relocated.

## Reference mapping

Candidate references are consecutive in first-citation order. Full retained entries are in references.md. Canonical old→candidate new: 1→1; 2→2; 3→3; 5→4; 6→5; 7→6; 8→7; 9→8; 10→9; 11→10; 14→11; 15→12; 16→13; 18→14; 20→15; 22→16; 23→17. Canonical 4, 12, 13, 17, 19 and 21 are omitted because their associated comparisons were removed. No new bibliographic work is introduced. Huang's corrected Evaluation Study title is retained.

## Verification and residual checks for parent

Direct checks confirmed exact canonical Results and back-matter equality, all five figure and three table callouts, consecutive first-use citations and bibliography correspondence, placeholder retention, and counts below both limits. Primary cached text was directly inspected for Gandhi pairwise percentages, Choi Table 3 conformance, Liang sample/support statistics and Soboczenski Table 3/time-model distinction. Minozzi findings retain access-qualified researcher provenance, supplemented by live PubMed/publisher-indexed abstract retrieval; complete primary body access is not claimed. All added external quantitative facts, their units and access boundaries are in external-facts.tsv.
