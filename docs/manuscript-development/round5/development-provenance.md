# Development-set provenance and limits of overlap verification

Research date: 23 October 2026. Read-only investigation, except this note. No git commands, agents, assessments, manuscript builds or statistical analyses were run. Search was bounded to the requested study records, four historical local rob2-kit snapshots, selected development documentation, and pinned GitHub resources. This note is ready for the manuscript writer; unresolved completeness does not block attributed wording.

## Conclusion for the writer

The author confirms that ARBITER was developed using its `eval/` set and that the current 105-trial benchmark was not used in development. Treat this as **author attestation**, now recorded in [author-interview.md](../author-interview.md), rather than an unanswered interview item.

Independent documentary evidence corroborates a real development corpus: ten named prostate-cancer trials, clinical source documents and registry captures, provisional RoB labels, assessment traces, development cohorts, synthetic premise contrasts, and prompt experiments. The recovered ten-trial catalog has no NCT intersection with the 78 populated NCT identifiers in the current 105-trial inventory. None of its 37 clinical PDFs has a SHA-256 matching the 264 document digests in the current benchmark file ledger. These checks support separation of the recovered corpus from the benchmark; they do not independently certify the author's complete development history or every possible trial/report alias.

**Suggested narrow Methods wording:**

> ARBITER was developed using an internal evaluation corpus containing ten prostate-cancer trials and synthetic diagnostic cases. The author reports that the 105-trial benchmark used in this study was not used in development.

**Optional eMethods addition:**

> A retrospective check found no shared registry identifiers between the recovered development catalog and the 78 benchmark trials with recorded NCT identifiers, and no identical PDF digests between the recovered development sources and the benchmark document ledger. This check did not establish an exhaustive history of development exposure.

Avoid “independently verified held-out benchmark,” “no development exposure,” “no overlap with any development material,” “prospectively frozen test set,” or “all prompts were selected without benchmark access.” None is established by this bounded investigation. The author's statement concerns ARBITER development; it is not a claim about foundation-model pretraining.

## Where eval was found and what the public release preserves

No current sibling ARBITER/rob2-kit checkout was found beside this study checkout. Historical copies were located at:

- `/home/ali/Documents/Codex/2026-10-02/task/rob2-kit/eval`
- `/home/ali/Documents/Codex/2026-10-02/task-3/rob2-kit/eval`
- `/home/ali/Documents/Codex/2026-10-02/task-4/rob2-kit/eval`
- `/home/ali/Documents/Codex/2026-10-07/task-3/rob2-kit/eval`

The first copy is the principal local source below, abbreviated **local root** as `/home/ali/Documents/Codex/2026-10-02/task/rob2-kit`. Each inspected catalog lists the same ten trial/NCT pairs. These are archived working files, not a newly verified checkout of the evaluated commit. Folder names and embedded report dates alone do not authenticate commit chronology.

The [pinned public eval directory](https://github.com/AliSalman-et-al/ARBITER/tree/2f549ae30f056ff441ea61a04b719968716f2219/eval) contains only `synthetic-heldout.json`. The [pinned .gitignore](https://github.com/AliSalman-et-al/ARBITER/blob/2f549ae30f056ff441ea61a04b719968716f2219/.gitignore) explicitly states that evaluation inputs, runs and traces stay local because reports are copyrighted and traces quote them; it ignores `eval/*` except the synthetic manifest. Thus the clinical eval corpus is absent from this public snapshot by an explicit publication policy. Its absence is not evidence that it never existed.

The [synthetic manifest](https://github.com/AliSalman-et-al/ARBITER/blob/2f549ae30f056ff441ea61a04b719968716f2219/eval/synthetic-heldout.json) uses placeholder trial `t`, synthetic model metadata and repeated-character example hashes. It exercises an evaluation contract; it is not the clinical development corpus or proof of a real held-out clinical evaluation.

The [GitHub history query pinned to the release and eval path](https://api.github.com/repos/AliSalman-et-al/ARBITER/commits?sha=2f549ae30f056ff441ea61a04b719968716f2219&path=eval&per_page=5) returned one root commit: `2f549ae30f056ff441ea61a04b719968716f2219`, “Initialize ARBITER 1.0.0,” author/committer Ali Salman, 18 October 2026 08:47:22 UTC, with no parents. This public history cannot reconstruct earlier prompt development. The [evaluated-ref request](https://github.com/AliSalman-et-al/ARBITER/tree/2848c7926a2acc25402345a42be39d695a99861a/eval) returned GitHub API 404, “No commit found for the ref 2848c7926a2acc25402345a42be39d695a99861a.” This establishes inaccessibility through this public repository request, not nonexistence of the evaluated revision.

Read [rename-equivalence.md](../../../analysis/provenance/rename-equivalence.md) and [mechanism.md](../interview-refinement/mechanism.md) as the release bridge. The retained audit reports equivalent assessment implementation/scientific pack/skill after documented naming normalization, but rejects whole-release equivalence. It records real-trial fixture removals, verifier and recovery-authorization changes. Do not recast it as a new overlap audit or infer an untouched release history. Its retained run-side `docs/evaluation/verification.md` text explicitly says the existing ten trials had informed the audit and were development material, not held out.

## Actual recovered corpus and purpose

Principal identity source: [local catalog](/home/ali/Documents/Codex/2026-10-02/task/rob2-kit/eval/reference/catalog/trials.csv). Its ten trial identities are:

- ARASENS — NCT02799602
- ARCHES — NCT02677896
- CHAARTED — NCT00309985
- ENZAMET — NCT02446405
- GETUG-AFU 15 — NCT00104715
- LATITUDE — NCT01715285
- PEACE-1 — NCT01957436
- STAMPEDE — NCT00268476
- SWOG-1216 — NCT01809691
- TITAN — NCT02489318

Retained `registry.json` identification and condition fields corroborate these identifiers and prostate-cancer trial identities. The catalog defines overall survival, progression-free survival and adverse-event targets; CHAARTED and GETUG-AFU 15 have the two survival targets. Provisional-label CSVs have 10 overall-survival, 10 progression-free-survival and 8 adverse-event rows, each with D1–D5 and overall ratings. These are 28 labelled trial/outcome rows, not 28 independent trials. `outcomes.csv` separately lists baseline-completion counts of 9, 8 and 10, respectively; do not confuse completion and reference-label denominators.

The first snapshot contains 532 eval files: 73 under `reference`, 447 under `runs`, eight under `cohorts`, and four root files. Reference material includes 37 PDFs, ten registry captures, ten source-role TOML files, ten qualification-case JSON files and six catalog files. Available PDFs include main reports, supplements, protocols and other reports. The four-copy inventory is not four independent development datasets.

The [development guide](/home/ali/Documents/Codex/2026-10-02/task/rob2-kit/docs/evaluation/rsi.md:3) describes diagnosis one trial and approved result at a time, separately from release qualification. Lines 28–34 explicitly call the ten existing trials development material already used in the audit. Planned controlled comparisons vary supplied passages, scope-matched facts, compact context and targeted warrant review; plan templates are not evidence all comparisons ran.

The [cohort account](/home/ali/Documents/Codex/2026-10-02/task/rob2-kit/eval/cohorts/README.md) documents assessment/label reconciliation and source-grounded diagnostic review. September 26–27 manifests use development partitions; the fresh September 27 campaign has 26 cases/130 domain cells and no held-out partition. Its source triage is AI-authored and provisional, not independent expert adjudication. The September 21 account calls its own 28-case baseline held out, but that historical designation does not establish that these trials remained untouched during subsequent development.

Synthetic fixtures additionally test evidential distinctions such as outcome availability versus event/censor arithmetic, ordinary nonadherence versus trial-context deviations, and differential ascertainment. `scientific-premise-contrasts-2026-09-27.json` and `synthetic-contrast-cards.json` explicitly identify their purpose as `development_only` and their reference status as provisional.

## Recoverable prompt history

This is a partial documentary reconstruction, not a complete prompt-selection log or a rerun of the historical experiments.

1. The [evaluation guide](/home/ali/Documents/Codex/2026-10-02/task/rob2-kit/docs/evaluation/README.md:257) supplies the generic launch template `/rob2-assess Assess risk of bias for {outcome} across the trials in input.` This instruction alone does not prove every historical invocation used exactly it.
2. The [ARASENS D3 comparison report](/home/ali/Documents/Codex/2026-10-02/task/rob2-kit/docs/evaluation/2026-09-27-arasens-d3-prompt-contrast.md) and `scripts/render_d3_card_prompt_contrast.py` preserve a generic comparison-card prompt reference (`8fa90ed5aec80de8bfc5dfb55e480b7a38f65dd8`), fixed September 26 context/reference revision (`d5528044066bc0300bd96ea4e99c25a35d58f6b0`) and literal D3 candidate wording. The candidate stresses matching observed outcomes/follow-up to the approved result, distinguishing event/censor totals from outcome availability, and retaining No information when availability is unknown. The report describes a stopped exploratory batch, a corrected 12-call comparison, no measured question-level benefit and subsequent production reversion. This is recorded development history, not independently reproduced performance evidence. The report also states that retrospective prompt hashes cannot prove the exact bytes delivered to each model.
3. The [scientific-contrast report](/home/ali/Documents/Codex/2026-10-02/task/rob2-kit/docs/evaluation/2026-09-27-scientific-contrasts.md) records synthetic prompt revision after an exploratory pilot. Its LATITUDE D4 section and `scripts/run_latitude_d4_card_prompt_contrast.py` preserve baseline/candidate wording concerning cumulative opportunities to detect adverse events. The report describes three paired repeats for LATITUDE plus a synthetic preservation case, explicitly declines a demonstrated scientific-gain claim and says to keep the candidate out of production pending independent adjudication. These saved-context reasoning diagnostics did not exercise the complete assessment lifecycle.
4. The current study's [runner account](../../../kit-sonnet-5.5/README.md:26) separately records the evaluated revision and benchmark template: `/rob2-assess Assess risk of bias for {assess_outcome} defined as {assess_values_as_printed} in {slug}.` The harness approved the result proposal unchanged and resumed with “Approved.” This documents benchmark delivery, not a historical optimization/search procedure.

No complete sequence of all prompt candidates, selection decisions or adoption dates up to the evaluated revision was recovered. No evidence here supports “no prompt development occurred”; documented experiments show that it did.

## Independent overlap checks and completeness limit

Checks used the first recovered catalog, retained registry records and PDFs against the current [TRIAL-SUMMARY.csv](../../../rob2-meta-benchmark-set/TRIAL-SUMMARY.csv) and [FILES.csv](../../../rob2-meta-benchmark-set/FILES.csv):

- Extracted case-insensitive `NCT` plus eight-digit identities from catalog and benchmark NCT fields: ten versus 78 unique identities, zero shared. The remaining 27 benchmark rows have empty NCT fields, so this is not a 105/105 registry-identity comparison.
- Inspected the 105 trial labels/assessment descriptions and searched benchmark CSV/Markdown records for the ten development trial names, registry identities and six clearly recovered NEJM main-report DOIs. No corresponding development-trial identity was found. The benchmark's seven oncology trials are MONALEESA-2/3/7, MONARCH-2/3/plus and PALOMA-2, distinct from the prostate-cancer catalog. Name/description inspection is supporting evidence, not an alias-complete identity resolution.
- Extracted the first two pages of each development main report with `pdftotext` to corroborate source identity. Six clearly recovered DOIs were `10.1056/NEJMoa2119115`, `10.1056/NEJMoa1503747`, `10.1056/NEJMoa1903835`, `10.1056/NEJMoa1704174`, `10.1056/NEJMoa1702900` and `10.1056/NEJMoa1903307`. Other DOI strings were absent or broken in this bounded extraction. No complete normalized DOI-to-DOI comparison was possible from the current benchmark ledger; DOI search is supplementary, not a certified DOI exclusion test.
- Computed SHA-256 for all 37 recovered source PDFs and compared with all 264 benchmark ledger digests (105 main articles, 159 supplements): zero shared. This is exact-document exclusion against recorded digests, not proof that different reports cannot concern the same randomized trial, and not a fresh verification of benchmark document bytes.

Reproducibility anchors (SHA-256): development `trials.csv` = `2ad8d35fbda915a4fc00aacf28e1ba7dbfb8735c5671ad79d62406903160b1ba`; current `TRIAL-SUMMARY.csv` = `d7faf6cff4cfd117b4f86c689a9ca2bad10ae21897b19778f119543b7ee5b20f`; current `FILES.csv` = `24a3a55bfe2ca1fc772332a5883f52f9127797d61c7cce869a6ed6279a3ede5a`.

The bounded directory search also found other archived benchmark and diagnostic workspaces, including a sibling historical `rob2-kit-benchmark` whose README describes a September 29 dataset and October 1 run archive. Their existence does not establish that the current benchmark informed development; filenames, folder dates and co-location cannot settle purpose or causal use. Those archives, all diagnostic snapshots, all historical test fixtures and every possible development input were not exhaustively audited. In particular, the retained release audit records real-clinical test fixtures outside `eval/`; the ten-trial comparison must not be generalized to all such material. Establishing an exhaustive no-exposure claim would require a fuller input inventory and authenticated change/usage chronology. Preserve the author's attestation without converting the present incompleteness into either a contradiction or an independent certification.
