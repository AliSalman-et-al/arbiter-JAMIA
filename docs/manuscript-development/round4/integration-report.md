# Round 4 canonical integration report

Integrated on 23 October 2026 in `/home/ali/Documents/Code/arbiter-JAMIA`, against scientific baseline `e29154fd730885de89ae52aabaa18e31044b676a`. Starting HEAD was `d8c9fe078a3bab8b0d78068338d7d3c1517968b7`; canonical manuscript/reference blobs matched the scientific baseline. Sole writer; no agents, git mutations, statistical/R/source-data/figure edits, publication builds or generated publication artifacts.

## Inputs and editorial disposition

Read selection.md, judgment.md, parent-scores.md, B candidate and rationale, A candidate for the two selected grafts, methods-candidate.md, methods-parent-review.md, editorial-contract.md, research-synthesis.md and candidate-brief.md. Read `/home/ali/Documents/Code/skills/clinical-research-writing/SKILL.md` and its `references/revision-and-coaching.md`; applied the structure, clarity, flow, language and final structure sequence.

Used B's abstract, Introduction and Discussion, with the reviewed Methods/Results candidate. Retained the accepted title, “ARBITER: an auditable workflow for AI-assisted risk-of-bias assessment.” Preserved the current front matter and back matter verbatim and all 15 author-completion placeholders exactly. No placeholder was completed by inference.

## Exact edits by owned file

- `docs/manuscript/manuscript.md`: installed the selected B narrative around reviewed Methods/Results. Body H2 sequence is Introduction, Materials and methods, Results, Discussion; Introduction has H3 Background and significance and Objective; Discussion has H3 Conclusion. The five abstract headings remain Objective, Materials and Methods, Results, Discussion, Conclusion. Added the two selected A qualifications: rules-only recomputation cannot recover component effects, and acceptance/correction rates are not semantic validation. Replaced model-constancy claims with the observed common reported identifier/configuration and identical supplied documents; Methods explicitly says immutable underlying snapshot identity across the two dates was not established, without asserting an update. Made the ARBITER minus Unassisted Published contrast explicit in abstract and Discussion. Retained all four absolute expert-agreement numerators in the abstract. Kept expert-versus-arm source access explicit. Compressed LogiMed to its RoB 2 hierarchical-consistency contribution. Applied both Methods review edits: “conformed to the algorithms” and the operational quotation-check wording. Retained the evaluated `/rob2-assess` versus public `/arbiter-assess` command distinction and complete-release caveat.
- `docs/manuscript/references.md`: preserved all 19 baseline entries verbatim apart from their list numbers, added exactly three verified entries, and reordered the list by first manuscript use. Replaced all three author-year integration markers with numbered citations. Expanded baseline citation ranges before remapping; for example, B's baseline `[6–9]` becomes `[6,8,9,10]`, which does not inadvertently cite newly inserted RoBGuard [7].
- `docs/manuscript/verify-numbers.py`: added shared H2-aware `word_counts`, replaced the body section-order expectation, added an explicit Introduction subheading gate and an explicit Discussion Conclusion gate, and classified only the exact backticked `/rob2-assess` command as release-audit metadata. The command's digit remains extracted and reported. Numeric indexing/scaling, row-level headline checks, section extraction, word tokenization, display-citation checks and reference first-use/range-expansion checks remain intact. No general exemption for command digits, versions or study numbers was added.
- `docs/manuscript/assemble-publication.py`: uses the shared word-count function; starts the body page break at the original H2 Introduction; ends abstract formatting at the next H2/body heading after heading remapping, rather than a Background text sentinel. Extracted the existing abstract-label formatting into a callable helper for an in-memory regression. Replaced hardcoded `fields.[14,15]` handling with a reporting-sentence-scoped numeric-callout binder, including citations split into another run. Final reporting references happen still to be [14,15], but the helper also passes a [24,25] regression. No table insertion, table-content comparison, table-layout or figure code was changed.
- `scripts/test-manuscript.py`: added three source-only tests covering repeated abstract/body Discussion and Conclusion headings, scoped word counting and Introduction validation, reporting-citation renumbering/run splitting, and exact command-metadata scope. Formatting tests execute the actual helper functions from their AST in memory, avoiding the assembler's publication-writing top level. Existing tests remain intact.
- `docs/manuscript-development/round4/integration-report.md`: this report.

## Reference mapping and primary verification

Baseline ID → final ID: 1→1; 2→2; 3→3; 4→4; 5→5; 6→6; 7→8; 8→9; 9→10; 10→16; 11→11; 12→12; 13→13; 14→14; 15→15; 16→19; 17→20; 18→17; 19→22. All remain cited. Final first-use sequence and bibliography are exactly 1–22, with no gaps, unused entries or unresolved author-year markers.

New references:

- **[7] RoBGuard:** Ji C, Zhao B, Wang Z, et al.; COLING 2025 proceedings, pp. 1258–1277 (bibliography abbreviates the range to 1258–77). Checked the [primary ACL record](https://aclanthology.org/2025.coling-main.84/), including its author list, title, proceedings and page metadata, and retained `/tmp/arbiter-r4-fulltexts/systems/robguard.txt`. The Introduction's question-reformulation, multimodal-parsing and model-role-collaboration clause is supported by the primary framework account. Uses the stable ACL URL; no DOI was invented.
- **[18] LogiMed-RoB:** Huang J, Tang Z, Ling Q, Kuang Z, E H; *Can LLMs Follow Medical Expert Logic? A Benchmark for Hierarchical Logical Consistency in Risk-of-Bias Assessment*. Checked the [primary arXiv v1 record](https://arxiv.org/abs/2609.11185v1): submitted 10 September 2026, with the explicit comment “Accepted to EMNLP 2026 Main Conference.” Inspected retained `/tmp/arbiter-r4-fulltexts/benchmarks/LogiMed-RoB.txt`, section 3.3.1 and its hierarchy account, which separates the RoB 2 logic track from the RoB 1 evidence track. Bibliography identifies the inspected v1 and records acceptance; it does not call the report unreviewed or invent proceedings metadata. Manuscript claims only the RoB 2 hierarchical-consistency contribution.
- **[21] Soboczenski2019:** Soboczenski F, Trikalinos TA, Kuiper J, et al.; *Machine learning to help researchers evaluate biases in clinical trials: a prospective, randomized user study*. Checked the [primary publisher record and full text](https://link.springer.com/article/10.1186/s12911-019-0814-z), including authors, title, journal, 2019;19:96 and DOI 10.1186/s12911-019-0814-z. Also inspected retained `/tmp/arbiter-r4-fulltexts/reviewer_use/soboczenski2019.txt`, Methods and randomized assisted/manual task design. The manuscript retains the earlier-instrument/four-domain boundary and transfers no benefit estimate to ARBITER.

Existing bibliography metadata was preserved, not newly rewritten. Primary records and retained fulltexts, rather than agreement among research reports, control the three additions.

## Audit results and counts

PASS: 328 numeric tokens extracted; 208 traced to retained outputs; 120 explicitly classified as metadata/editorial; zero untraced. The exact command contributes one metadata digit. All row-level headline checks pass. An altered expert numerator (`371/510` → `370/510`) was rejected by the headline gate. AST comparison against the scientific baseline confirmed unchanged numeric-indexing, headline and display-citation helper bodies.

PASS: exact H2 order, five abstract labels, two Introduction labels and Discussion Conclusion. Reference first use is sequential 1–22. Main display first-use sequence remains Figure 1, Figure 2, Figure 3, Table 1, Table 2, Figure 4, Figure 5, Table 3 (sequential within each display class).

Whitespace word counts exclude headings and numeric citation callouts; Markdown links count their labels:

- Abstract: **225/250**.
- Introduction: **292**.
- Materials and methods: **1618**.
- Results: **552**.
- Discussion, including Conclusion: **886**; Conclusion alone: **50**.
- Body total: **3348**, strictly below 4000.
- Back matter, excluded from body: **208**.

PASS: all baseline Results numeric tokens, including their repetition counts, match the integrated Results exactly after removing citation callouts. This includes both expert full-cohort comparisons, 63/80 and 61/80 choice sensitivities, 53/80 split-loss sensitivity, unfavorable D3 five-level contrast and collapsed reversal, smaller D5 Expert 2 interval, Published contrast, process-audit objects and computation. Methods retains all study conditions, target/source caveats, pending fields, fixed-review bootstrap scope and evaluated/public-release distinctions. Narrative interpretation remains bounded to the complete workflows and observed references.

PASS: seven source-only tests. The existing built-artifact test was skipped by design; stale publication artifacts are not treated as proof of this revision. Source syntax checks and `git diff --check` passed. No artifact was built or saved by the in-memory DOCX tests.

## Commands

Executed from the repository root:

```bash
PYTHONDONTWRITEBYTECODE=1 python3 docs/manuscript/verify-numbers.py
PYTHONDONTWRITEBYTECODE=1 /home/ali/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/bin/python3 scripts/test-manuscript.py -v
git diff --check
git diff -- docs/manuscript/manuscript.md docs/manuscript/references.md docs/manuscript/verify-numbers.py docs/manuscript/assemble-publication.py scripts/test-manuscript.py
git status --short
git rev-parse HEAD
git diff e29154fd730885de89ae52aabaa18e31044b676a -- docs/manuscript/manuscript.md docs/manuscript/references.md
```

Additional read-only Python heredoc audits used `git show e29154fd730885de89ae52aabaa18e31044b676a:docs/manuscript/{manuscript,references}.md` to compare front/back sections, placeholder Counters, complete baseline reference strings and Results numeric-token Counters. A separate AST comparison asserted unchanged bodies for `normal`, `sections`, `words`, `docx_text`, `output_index`, `rows`, `headline_checks`, `display_citations` and `citation_order_checks`; it invoked `headline_checks` on the canonical text and the altered-numerator string. Independent range expansion asserted first-use IDs equal `list(range(1,23))`. `compile(source, path, 'exec')` checked the three Python sources without writing bytecode or executing assembly. Primary metadata was opened directly at the three linked records; retained fulltexts were read with `sed`/`rg`.

Environment diagnostics: `python` is absent, and system `python3` lacks `python-docx`. No package was installed. The existing managed interpreter above supplies DOCX dependencies and ran all source-only tests successfully.

## Outstanding work and scope

No known unresolved integration defect or unresolved citation marker remains. The 15 original placeholders, author declarations, archival registration and unavailable methods facts remain pending author completion. The new snapshot sentence documents an unestablished identity, not a detected model change.

As required by selection.md, independent scientific and expert-readability reviews of the integrated manuscript must precede publication rebuilding and visual proof. This integration does not claim those reviews or final acceptance. No publication build was attempted.

Pre-existing changes in `docs/manuscript-development/decisions.tsv` and the untracked round4 candidate/review inputs were observed and left untouched. Only the six authorized files listed above were written by this integration. Protected tables, layouts, outputs, sources and figures were not edited; their publication presentation will require the deferred build/proof step after text review.
