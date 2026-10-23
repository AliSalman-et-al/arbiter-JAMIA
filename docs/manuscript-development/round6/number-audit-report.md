# Round-six number audit implementation

Implemented in `docs/manuscript/verify-numbers.py`; regression coverage in `scripts/test-manuscript.py`. No manuscript, bibliography, external ledger, statistical output, R code, or publication artifact was edited by this worker. No git commands, builds, or delegated agents were used.

## Ledger contract

The integration-owned `docs/manuscript-development/round6/external-facts.tsv` requires exactly the agreed set of fields (additional columns are permitted but not required):

`id`, `exact_text`, `reference`, `doi`, `metric_context`, `locator`, `access_level`, `boundary`.

Every required cell must be populated. `reference` is one positive numeric bibliography ID; `doi` is a plain DOI. `exact_text` is a unique, verbatim complete manuscript sentence or contiguous sentence group in one paragraph, including its numeric citation. Literal tabs/newlines, partial numeric snippets, duplicate IDs/text, duplicate header names, and overlapping ledger spans fail. Matching is literal, not a regular expression or numeric whitelist. A row must occur exactly once. Its citation must include `reference`, and that bibliography entry must contain the same DOI. Missing ledger/schema/metadata, changed prose or values, changed citations, and changed bibliography identities fail without granting external classification.

External spans are restricted to Introduction or Discussion. Numeric sentences naming ARBITER, Unassisted, or own-study indicators cannot be externally classified, including when placed in a group with an external sentence. The Gandhi correction is explicit: the known erroneous “ophthalmic surgical research assessors” expansion fails in either ledger metadata or manuscript prose; original systematic review authors is accepted.

## Classification and retained scientific guards

Output now separates output-traced, external-literature, metadata/editorial, and untraced numeric tokens. `--verbose` prints each external token with ledger ID, reference, DOI, locator, and access level. Cited literature sentences and the non-own-study sentences in their paragraphs cannot fall back to study CSV lookup when their ledger coverage is absent or invalid. Equal values in the study CSVs do not rescue an external claim mutation.

All original source-row checks, required study results, hierarchy/chronology prohibitions, section requirements, and display/reference-order checks remain. Frozen `primary-*.csv` filenames were retained. After reading the integrated Methods, endpoint prose checks were separated into `endpoint_definition_checks`: both the previous definition and the revised explicit conditional-population/numerator wording are accepted, while mutations of the 510-cell population, arm disagreement, both-expert agreement, or ARBITER numerator fail. This does not restore obsolete prospective-primary terminology.

The words “first” and “masked” are allowed within valid external spans, where they describe Minozzi's sequential groups and Gandhi's human panel. The exact reporting-order phrase “We report published-label agreement first, followed by independent-expert agreement” is also accepted. Priority/blinding claims elsewhere and all other existing prohibited terms remain guarded.

Partial manuscript integration now returns a clear missing-section failure instead of crashing during word counting.

## Validation observed on 23 October 2026

- `uv run --with python-docx python scripts/test-manuscript.py`: **25 tests run, OK, 1 skipped**. The skipped test requires built publication artifacts, deliberately outside this task. System `python3` lacks python-docx; uv supplied that test dependency without repository edits.
- The tests include positive exact spans and sentence groups; numeric and narrative mutations even when numbers exist in a study index; missing rows/schema/metadata; citation and DOI mismatch; ambiguous occurrences and overlapping/duplicate entries; whole-sentence boundaries; source-context correction; own-result leakage; original primary-count enforcement; and equivalent versus scientifically changed endpoint definitions. The live integrated ledger is also checked against current manuscript and references.
- `python3 docs/manuscript/verify-numbers.py`: **exit 1**, with **305 tokens: 184 output-traced, 25 external-literature, 96 metadata/editorial, 0 untraced**. All **6 integrated external spans passed**; 98 output CSVs and the existing generated prose/main tables supplied study traces. Main text was 3329/4000 words and abstract 217/250 under the verifier's documented counting rule. Display citation order passed.

Two preserved integration requirements still failed in that observed manuscript snapshot:

1. `Introduction heading mismatch: []` — required `Background and significance` and `Objective` subheadings were absent.
2. `Live and evaluated software citations missing` — the Methods lacked its required live source URL and evaluated commit identity. A commit link in Back matter does not satisfy this existing Methods check.

These are integration-owner follow-ups, not waived checks. Re-run the verifier after those edits and after any subsequent manuscript/ledger/reference changes; the numbers above describe the observed snapshot, not a final release assertion.

## What this audit establishes

The external audit checks exact recorded traceability and bibliography linkage. It does not fetch sources, certify access descriptions, independently interpret metrics/denominators, or validate whether a cited source supports a scientific claim. Metadata presence is necessary but does not establish metadata truth. Identification of unledgered external material is conservative and structural: cited prose is routed away from study outputs; entirely uncited, unattributed prose cannot always be recognized as external literature automatically. The integration owner must supply coverage for every imported claim and inspect its source context. The original CSV-token lookup also remains a traceability check, with the existing explicit source-row assertions protecting specified study results; it is not comprehensive semantic validation of every study sentence.
