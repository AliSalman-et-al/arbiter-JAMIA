# Run-build/public-release equivalence audit

**Verdict: not rename-only. Behavioural residuals exist. Do not use the proposed ‘identical apart from naming’ Methods sentence. PI wording decision required.**

The shipped assessment implementation, scientific pack, domain algorithms and assessment skill/prompts have no behavioural residual after the documented identity normalisation. This narrower observation does not establish equivalence of the complete releases.

## Behavioural differences

- `scripts/verify_bundle.py`, hunks `@@ -173,6 +173,7 @@` and `@@ -216,7 +217,7 @@`: public release adds `sha256:28ebc17dafc456a7f5805b4371dc359fa15fe7625fba2a158c3fc011b3e2f5ae` to `_UNIFORM_ANSWER_BASIS_PACKS` and changes `_REPORTED_STATISTICS_SCIENTIFIC_PACK.content_hash` from `sha256:bea71e3fffc8624fa5c1ed66043a21e22828970398501c9d455cb1faf664f891` to that hash. These are literal hash/compatibility changes left unnormalised. This is the separate dependency-free verifier, not the installed CLI verifier used for the fresh bundle checks.
- `scripts/benchmark_recovery_exec_allowlist.json`: public release empties the retained campaign allowlist (19 turns to zero, empty turns/cells). This changes benchmark recovery authorisation for scripts consuming that file.
- `.gitattributes`: drops `tests/fixtures/historical-evaluation/** -text`, changing the checkout policy for that path.
- Test-only changes remove three rejected-submission fixtures, introduce `recovery-exec-synthetic.json`, replace real clinical test inputs with synthetic inputs, change the private-evaluation-term detection regex, and add an evidence `source_version`. These affect validation coverage/setup; they are not changes to the packaged RoB 2 algorithms.

No tables, supplement, deviations, analysis plan, or draft Methods wording were edited. The fresh verification succeeds independently; the equivalence condition fails.

## Method and scope

Compared Git objects at run commit `2848c7926a2acc25402345a42be39d695a99861a` in `C:/Users/Ali-Salman/Documents/Code/rob2-kit` with public commit `2f549ae30f056ff441ea61a04b719968716f2219` in `C:/Users/Ali-Salman/Documents/Code/ARBITER`. Read-only `git ls-tree`/`git cat-file` inspect every tracked blob and file mode, ignoring working-tree/untracked content. No source checkout was modified. Script: `analysis/audit-rename-equivalence.py`. Reproduce with `python analysis/audit-rename-equivalence.py <run-repo> <public-repo>`.

All tracked paths are compared, not just Python: src, MCP tool definitions/contract manifest, packaged scientific text and algorithms, skills/prompts, host and plugin files, scripts, documentation, tests, build metadata and dependency lockfile. UTF-8 text uses LF for comparison; non-UTF-8 blobs compare SHA-256. No JSON reformatting, hash substitution, version substitution, or whitespace stripping is used. Normalised-path collisions stop the audit. Hunk locations refer to normalised contents; paths in the index are normalised public names. A removed file is represented by its complete deletion hunk.

### Normalisation map

Ordered literal substitutions (both paths and contents):

- `rob2_kit` → `arbiter`
- `rob2-assess` → `arbiter-assess`
- `rob2-kit` → `arbiter`
- `Rob2Kit` → `Arbiter`
- `ROB2_KIT` → `ARBITER`
- `ROB2-KIT` → `ARBITER`
- `.rob2.zip` → `.arbiter.zip`
- `Rob2-kit` → `Arbiter-kit`
- `ROB2_` → `ARBITER_`
- `rob2_` → `arbiter_`
- `rob2://` → `arbiter://`
- `mcp__rob2__` → `mcp__arbiter__`

Then regex `\brob2\b(?!\.parallel\.assignment)` → `arbiter` maps remaining product tokens (CLI/helper/file names, URI/MCP namespaces), preserving the scientific identifier `rob2.parallel.assignment`. Python word-boundary rules apply; escaped `\nrob2` and embedded `mcp__rob2` examples may remain in the residual index and are classified there. Scientific prose ‘RoB 2’, algorithms, numbers, compatibility hashes and release versions remain unnormalised. Product capitalisation variants not in the map remain explicit documentation/naming residuals.

### Coverage result

Run tree: 291 tracked paths; public tree: 285 tracked paths. Union after mapping: 294 paths; 234 identical, 60 residual paths, 101 residual hunks. Hunk classes: 38 naming-only, 42 docs-only, 21 behavioural (including test/configuration changes).

Within `src`, the only residuals are package `__version__` and manifest `contract_version` (0.13.0 → 1.0.0). The entire scientific pack, application finalization/verifier, algorithms and all assessment skill/prompt files are identical after identity normalisation. MCP tool definitions are identical after normalisation; the archived generated manifest retains nine changed output-schema hashes and its release version. Schema hashes are not erased: their naming-only classification is supported by the corresponding schema source being identical after normalisation. Runtime/development dependency entries are unchanged; the lockfile residual is the root project release version.

## Complete hunk classification

Every residual hunk is indexed below. ‘naming-only’ includes release identity metadata and mechanically induced formatting/import order, with unchanged evaluated content. ‘behavioural’ includes test/configuration behaviour; the reason states its scope. Full verbatim normalised hunks, including every added/deleted line, are in [rename-residuals.md](rename-residuals.md). This index and that appendix together are the complete residual record.

| Normalised file | Hunk (run → public) | Classification | Reason |
|---|---|---|---|
| `.claude-plugin/plugin.json` | `@@ -1,18 +1,33 @@` | naming-only | Release identity/version, rename-derived schema hashes, namespace string, or mechanical formatting/import ordering; no algorithm change. |
| `.codex-plugin/mcp.json` | `@@ -2,7 +2,7 @@` | naming-only | Release identity/version, rename-derived schema hashes, namespace string, or mechanical formatting/import ordering; no algorithm change. |
| `.codex-plugin/plugin.json` | `@@ -1,16 +1,26 @@` | naming-only | Release identity/version, rename-derived schema hashes, namespace string, or mechanical formatting/import ordering; no algorithm change. |
| `.gitattributes` | `@@ -1,4 +1,3 @@` | behavioural | Removes the historical-evaluation checkout byte-preservation rule. |
| `.github/workflows/ci.yml` | `@@ -152,4 +152,4 @@` | naming-only | Release identity/version, rename-derived schema hashes, namespace string, or mechanical formatting/import ordering; no algorithm change. |
| `CITATION.cff` | `@@ -1,15 +1,15 @@` | docs-only | Product/release documentation and historical-record cleanup. |
| `CONTEXT.md` | `@@ -1,4 +1,11 @@` | docs-only | Product/release documentation and historical-record cleanup. |
| `CONTEXT.md` | `@@ -462,7 +469,7 @@` | docs-only | Product/release documentation and historical-record cleanup. |
| `CONTEXT.md` | `@@ -557,10 +564,9 @@` | docs-only | Product/release documentation and historical-record cleanup. |
| `GLOSSARY.md` | `@@ -0,0 +1,13 @@` | docs-only | Product/release documentation and historical-record cleanup. |
| `README.md` | `@@ -1,6 +1,8 @@` | docs-only | Product/release documentation and historical-record cleanup. |
| `README.md` | `@@ -18,7 +20,7 @@` | docs-only | Product/release documentation and historical-record cleanup. |
| `README.md` | `@@ -122,7 +124,7 @@` | docs-only | Product/release documentation and historical-record cleanup. |
| `README.md` | `@@ -152,7 +154,7 @@` | docs-only | Product/release documentation and historical-record cleanup. |
| `README.md` | `@@ -180,7 +182,7 @@` | docs-only | Product/release documentation and historical-record cleanup. |
| `README.md` | `@@ -198,14 +200,22 @@` | docs-only | Product/release documentation and historical-record cleanup. |
| `docs/acceptance/v0-4-host-matrix.md` | `@@ -1,116 +0,0 @@` | docs-only | Documentation edit/addition/deletion; complete text is in the residual appendix. |
| `docs/adr/0025-owner-confirmed-redistribution-permission.md` | `@@ -1,9 +0,0 @@` | docs-only | Documentation edit/addition/deletion; complete text is in the residual appendix. |
| `docs/adr/0028-breaking-v0-3-workflow-cutover.md` | `@@ -1,7 +0,0 @@` | docs-only | Documentation edit/addition/deletion; complete text is in the residual appendix. |
| `docs/adr/0029-use-licensed-arbiter-text.md` | `@@ -6,17 +6,14 @@` | docs-only | Documentation edit/addition/deletion; complete text is in the residual appendix. |
| `docs/adr/0029-use-licensed-arbiter-text.md` | `@@ -31,5 +28,5 @@` | docs-only | Documentation edit/addition/deletion; complete text is in the residual appendix. |
| `docs/adr/0030-proposal-gate-and-model-owned-continuation.md` | `@@ -41,7 +41,7 @@` | docs-only | Documentation edit/addition/deletion; complete text is in the residual appendix. |
| `docs/adr/0031-v0-4-evidence-first-interaction.md` | `@@ -1,270 +0,0 @@` | docs-only | Documentation edit/addition/deletion; complete text is in the residual appendix. |
| `docs/adr/0032-host-owned-investigation-sufficiency.md` | `@@ -12,8 +12,8 @@` | docs-only | Documentation edit/addition/deletion; complete text is in the residual appendix. |
| `docs/adr/0035-retain-current-overall-aggregation.md` | `@@ -1,15 +0,0 @@` | docs-only | Documentation edit/addition/deletion; complete text is in the residual appendix. |
| `docs/adr/0036-atomic-domain-submission.md` | `@@ -29,8 +29,8 @@` | docs-only | Documentation edit/addition/deletion; complete text is in the residual appendix. |
| `docs/adr/0037-single-trial-proposal-selection.md` | `@@ -4,7 +4,9 @@` | docs-only | Documentation edit/addition/deletion; complete text is in the residual appendix. |
| `docs/adr/0037-single-trial-proposal-selection.md` | `@@ -20,10 +22,13 @@` | docs-only | Documentation edit/addition/deletion; complete text is in the residual appendix. |
| `docs/adr/0039-conditional-cumulative-concerns.md` | `@@ -1,6 +1,6 @@` | docs-only | Documentation edit/addition/deletion; complete text is in the residual appendix. |
| `docs/adr/0039-conditional-cumulative-concerns.md` | `@@ -44,3 +44,6 @@` | docs-only | Documentation edit/addition/deletion; complete text is in the residual appendix. |
| `docs/adr/0040-reasoned-domain-adjudication.md` | `@@ -80,3 +80,6 @@` | docs-only | Documentation edit/addition/deletion; complete text is in the residual appendix. |
| `docs/adr/0043-ancillary-result-statistics-and-source-meaning.md` | `@@ -24,4 +24,5 @@` | docs-only | Documentation edit/addition/deletion; complete text is in the residual appendix. |
| `docs/adr/0045-json-sources-project-as-markdown.md` | `@@ -28,7 +28,7 @@` | docs-only | Documentation edit/addition/deletion; complete text is in the residual appendix. |
| `docs/adr/0046-arbiter-identity.md` | `@@ -0,0 +1,8 @@` | docs-only | Documentation edit/addition/deletion; complete text is in the residual appendix. |
| `docs/agents/domain.md` | `@@ -2,6 +2,7 @@` | docs-only | Documentation edit/addition/deletion; complete text is in the residual appendix. |
| `docs/agents/domain.md` | `@@ -21,4 +22,4 @@` | docs-only | Documentation edit/addition/deletion; complete text is in the residual appendix. |
| `docs/evaluation/README.md` | `@@ -72,9 +72,8 @@` | docs-only | Documentation edit/addition/deletion; complete text is in the residual appendix. |
| `docs/evaluation/README.md` | `@@ -173,13 +172,6 @@` | docs-only | Documentation edit/addition/deletion; complete text is in the residual appendix. |
| `docs/evaluation/README.md` | `@@ -222,36 +214,3 @@` | docs-only | Documentation edit/addition/deletion; complete text is in the residual appendix. |
| `docs/evaluation/proposal-diagnostic-protocol.md` | `@@ -1,7 +0,0 @@` | docs-only | Documentation edit/addition/deletion; complete text is in the residual appendix. |
| `docs/evaluation/verification.md` | `@@ -26,12 +26,10 @@` | docs-only | Documentation edit/addition/deletion; complete text is in the residual appendix. |
| `docs/evaluation/verification.md` | `@@ -132,7 +130,7 @@` | docs-only | Documentation edit/addition/deletion; complete text is in the residual appendix. |
| `docs/evaluation/verification.md` | `@@ -406,26 +404,6 @@` | docs-only | Documentation edit/addition/deletion; complete text is in the residual appendix. |
| `docs/operational-guidance.md` | `@@ -23,8 +23,7 @@` | docs-only | Documentation edit/addition/deletion; complete text is in the residual appendix. |
| `docs/operational-guidance.md` | `@@ -35,3 +34,6 @@` | docs-only | Documentation edit/addition/deletion; complete text is in the residual appendix. |
| `docs/release/README.md` | `@@ -2,93 +2,64 @@` | docs-only | Documentation edit/addition/deletion; complete text is in the residual appendix. |
| `docs/release/public-contract.json` | `@@ -1,4 +1,4 @@` | naming-only | Release identity/version, rename-derived schema hashes, namespace string, or mechanical formatting/import ordering; no algorithm change. |
| `docs/release/public-contract.json` | `@@ -34,7 +34,7 @@` | naming-only | Release identity/version, rename-derived schema hashes, namespace string, or mechanical formatting/import ordering; no algorithm change. |
| `docs/release/public-contract.json` | `@@ -79,7 +79,7 @@` | naming-only | Release identity/version, rename-derived schema hashes, namespace string, or mechanical formatting/import ordering; no algorithm change. |
| `docs/release/public-contract.json` | `@@ -88,7 +88,7 @@` | naming-only | Release identity/version, rename-derived schema hashes, namespace string, or mechanical formatting/import ordering; no algorithm change. |
| `docs/release/public-contract.json` | `@@ -97,7 +97,7 @@` | naming-only | Release identity/version, rename-derived schema hashes, namespace string, or mechanical formatting/import ordering; no algorithm change. |
| `docs/release/public-contract.json` | `@@ -169,7 +169,7 @@` | naming-only | Release identity/version, rename-derived schema hashes, namespace string, or mechanical formatting/import ordering; no algorithm change. |
| `docs/release/public-contract.json` | `@@ -178,7 +178,7 @@` | naming-only | Release identity/version, rename-derived schema hashes, namespace string, or mechanical formatting/import ordering; no algorithm change. |
| `docs/release/public-contract.json` | `@@ -187,7 +187,7 @@` | naming-only | Release identity/version, rename-derived schema hashes, namespace string, or mechanical formatting/import ordering; no algorithm change. |
| `docs/release/public-contract.json` | `@@ -205,7 +205,7 @@` | naming-only | Release identity/version, rename-derived schema hashes, namespace string, or mechanical formatting/import ordering; no algorithm change. |
| `docs/release/verify.py` | `@@ -34,7 +34,7 @@` | naming-only | Release identity/version, rename-derived schema hashes, namespace string, or mechanical formatting/import ordering; no algorithm change. |
| `docs/release/verify.py` | `@@ -617,7 +617,7 @@` | naming-only | Release identity/version, rename-derived schema hashes, namespace string, or mechanical formatting/import ordering; no algorithm change. |
| `docs/user-guide.md` | `@@ -1,4 +1,4 @@` | docs-only | Documentation edit/addition/deletion; complete text is in the residual appendix. |
| `pyproject.toml` | `@@ -1,7 +1,7 @@` | naming-only | Release identity/version, rename-derived schema hashes, namespace string, or mechanical formatting/import ordering; no algorithm change. |
| `scripts/benchmark_contract.py` | `@@ -992,7 +992,7 @@` | naming-only | Release identity/version, rename-derived schema hashes, namespace string, or mechanical formatting/import ordering; no algorithm change. |
| `scripts/benchmark_contract.py` | `@@ -3515,7 +3515,7 @@` | naming-only | Release identity/version, rename-derived schema hashes, namespace string, or mechanical formatting/import ordering; no algorithm change. |
| `scripts/benchmark_contract.py` | `@@ -3544,11 +3544,11 @@` | naming-only | Release identity/version, rename-derived schema hashes, namespace string, or mechanical formatting/import ordering; no algorithm change. |
| `scripts/benchmark_contract.py` | `@@ -3556,14 +3556,14 @@` | naming-only | Release identity/version, rename-derived schema hashes, namespace string, or mechanical formatting/import ordering; no algorithm change. |
| `scripts/benchmark_recovery_exec_allowlist.json` | `@@ -1,667 +1,8 @@` | behavioural | Replaces the populated campaign recovery allowlist with an empty public template; changes which recorded recovery programs qualify. |
| `scripts/export_factual_audit.py` | `@@ -265,7 +265,7 @@` | naming-only | Release identity/version, rename-derived schema hashes, namespace string, or mechanical formatting/import ordering; no algorithm change. |
| `scripts/run_domain_probe.py` | `@@ -53,7 +53,7 @@` | naming-only | Release identity/version, rename-derived schema hashes, namespace string, or mechanical formatting/import ordering; no algorithm change. |
| `scripts/verify_bundle.py` | `@@ -173,6 +173,7 @@` | behavioural | Adds a historical pack hash to the accepted uniform-answer-basis set and changes the reported-statistics compatibility descriptor hash; verifier acceptance/compatibility changes. |
| `scripts/verify_bundle.py` | `@@ -216,7 +217,7 @@` | behavioural | Adds a historical pack hash to the accepted uniform-answer-basis set and changes the reported-statistics compatibility descriptor hash; verifier acceptance/compatibility changes. |
| `src/arbiter/__init__.py` | `@@ -1,3 +1,3 @@` | naming-only | Release identity/version, rename-derived schema hashes, namespace string, or mechanical formatting/import ordering; no algorithm change. |
| `src/arbiter/contract_manifest.py` | `@@ -43,7 +43,7 @@` | naming-only | Release identity/version, rename-derived schema hashes, namespace string, or mechanical formatting/import ordering; no algorithm change. |
| `tests/e2e/agent.py` | `@@ -254,7 +254,9 @@` | naming-only | Release identity/version, rename-derived schema hashes, namespace string, or mechanical formatting/import ordering; no algorithm change. |
| `tests/e2e/test_assessment.py` | `@@ -211,7 +211,9 @@` | naming-only | Release identity/version, rename-derived schema hashes, namespace string, or mechanical formatting/import ordering; no algorithm change. |
| `tests/e2e/test_codex.py` | `@@ -11,10 +11,10 @@` | naming-only | Release identity/version, rename-derived schema hashes, namespace string, or mechanical formatting/import ordering; no algorithm change. |
| `tests/fixtures/an-d2-rejected-counterpoints.json` | `@@ -1,131 +0,0 @@` | behavioural | Adds/removes evaluation fixtures; test inputs only, not the shipped scientific pack. |
| `tests/fixtures/monarch-plus-rejected-submissions.json` | `@@ -1,387 +0,0 @@` | behavioural | Adds/removes evaluation fixtures; test inputs only, not the shipped scientific pack. |
| `tests/fixtures/monarch-plus-separated-rejected-submissions.json` | `@@ -1,208 +0,0 @@` | behavioural | Adds/removes evaluation fixtures; test inputs only, not the shipped scientific pack. |
| `tests/fixtures/recovery-exec-synthetic.json` | `@@ -0,0 +1,161 @@` | behavioural | Adds/removes evaluation fixtures; test inputs only, not the shipped scientific pack. |
| `tests/release/test_release_manifest.py` | `@@ -58,7 +58,7 @@` | naming-only | Release identity/version, rename-derived schema hashes, namespace string, or mechanical formatting/import ordering; no algorithm change. |
| `tests/release/test_release_manifest.py` | `@@ -69,14 +69,16 @@` | naming-only | Release identity/version, rename-derived schema hashes, namespace string, or mechanical formatting/import ordering; no algorithm change. |
| `tests/release/test_release_manifest.py` | `@@ -90,7 +92,7 @@` | naming-only | Release identity/version, rename-derived schema hashes, namespace string, or mechanical formatting/import ordering; no algorithm change. |
| `tests/test_domain_probe_controls.py` | `@@ -145,7 +145,9 @@` | naming-only | Release identity/version, rename-derived schema hashes, namespace string, or mechanical formatting/import ordering; no algorithm change. |
| `tests/test_domain_submission.py` | `@@ -1,6 +1,5 @@` | behavioural | Removes import-time loading of a removed rejected-submission fixture (test setup only). |
| `tests/test_domain_submission.py` | `@@ -8,10 +7,6 @@` | behavioural | Removes import-time loading of a removed rejected-submission fixture (test setup only). |
| `tests/test_execution_authority.py` | `@@ -385,7 +385,8 @@` | naming-only | Adjacent literal string reflow; identical evaluated text. |
| `tests/test_execution_authority.py` | `@@ -734,24 +735,24 @@` | behavioural | Changes recovery test input to synthetic cases and different trial/outcome names (test-only coverage); the first hunk is string reflow only. |
| `tests/test_execution_authority.py` | `@@ -1196,7 +1197,7 @@` | behavioural | Changes recovery test input to synthetic cases and different trial/outcome names (test-only coverage); the first hunk is string reflow only. |
| `tests/test_intake_contract.py` | `@@ -87,14 +87,14 @@` | behavioural | Replaces real trial names with synthetic names in duplicate-label tests (test data only). |
| `tests/test_model_facing_assets.py` | `@@ -20,9 +20,7 @@` | behavioural | Replaces the clinical/evaluation-term exclusion regex with three explicit private-data canaries; changes test acceptance. |
| `tests/test_proposal_contract.py` | `@@ -4,7 +4,6 @@` | naming-only | Release identity/version, rename-derived schema hashes, namespace string, or mechanical formatting/import ordering; no algorithm change. |
| `tests/test_proposal_contract.py` | `@@ -13,6 +12,7 @@` | naming-only | Release identity/version, rename-derived schema hashes, namespace string, or mechanical formatting/import ordering; no algorithm change. |
| `tests/test_proposal_evidence_binding.py` | `@@ -7,7 +7,6 @@` | naming-only | Import ordering after package rename. |
| `tests/test_proposal_evidence_binding.py` | `@@ -21,9 +20,10 @@` | behavioural | Adds _projection_hash and a source_version to the evidence fixture (test setup); import movement alone is formatting. |
| `tests/test_proposal_evidence_binding.py` | `@@ -121,6 +121,7 @@` | behavioural | Adds _projection_hash and a source_version to the evidence fixture (test setup); import movement alone is formatting. |
| `tests/test_result_semantics.py` | `@@ -449,8 +449,7 @@` | naming-only | Release identity/version, rename-derived schema hashes, namespace string, or mechanical formatting/import ordering; no algorithm change. |
| `tests/test_typed_proposal_routes.py` | `@@ -20,7 +20,7 @@` | behavioural | Replaces trial, intervention, outcome, effect and CI test data with synthetic values (test data only). |
| `tests/test_typed_proposal_routes.py` | `@@ -28,27 +28,27 @@` | behavioural | Replaces trial, intervention, outcome, effect and CI test data with synthetic values (test data only). |
| `tests/test_typed_proposal_routes.py` | `@@ -142,12 +142,12 @@` | behavioural | Replaces trial, intervention, outcome, effect and CI test data with synthetic values (test data only). |
| `tests/test_typed_proposal_routes.py` | `@@ -156,12 +156,12 @@` | behavioural | Replaces trial, intervention, outcome, effect and CI test data with synthetic values (test data only). |
| `tests/test_typed_proposal_routes.py` | `@@ -169,13 +169,13 @@` | behavioural | Replaces trial, intervention, outcome, effect and CI test data with synthetic values (test data only). |
| `tests/test_verification_scripts.py` | `@@ -145,7 +145,8 @@` | naming-only | Release identity/version, rename-derived schema hashes, namespace string, or mechanical formatting/import ordering; no algorithm change. |
| `uv.lock` | `@@ -1427,7 +1427,7 @@` | naming-only | Release identity/version, rename-derived schema hashes, namespace string, or mechanical formatting/import ordering; no algorithm change. |
