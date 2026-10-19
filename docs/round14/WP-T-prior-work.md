# WP-T: curated data for Table 4 (comparison with prior work)

Read `docs/round14/BRIEF.md` and `docs/research/llm-rob2/SYNTHESIS.md` first.

## Scope

Write only:

- `analysis/data-curated/prior-work-comparison.csv`
- `analysis/data-curated/prior-work-comparison-notes.md`

Do not touch any other file.

## Rows

Use these rows, in this order. Add none without stating why in the notes.

1. Eisele-Metzger 2025, Res Synth Methods, Claude 2
2. Huang 2025, J Med Internet Res
3. Lai 2026, J Med Internet Res
4. Nyrhi 2026, EBioMedicine
5. Gandhi 2026, PLoS One
6. Choi 2026, J Evid-Based Pract
7. Hevia 2025, ROBoto2, EMNLP demos
8. Liang 2026, JMIR AI
9. Saadi 2026, BMJ Digit Health AI (ROBINS-I)
10. This study (ARBITER)

## Columns (CSV schema)

`study_id, citation_short, doi, tool, n_trials, rules_applied_in_code, rules_enforced_during_assessment, rule_breaks_measured, quotations_verified_against_stored_source, audit_file, agent_with_tools, reference_standard, independent_reference_or_adjudication, input_parity_registry_protocol, note_marks`

- Feature cells take exactly one of `Yes`, `Partly`, `No`, `Not reported`.
- `reference_standard` is a short free-text phrase, such as "Cochrane labels" or "masked 3-person panel".
- `note_marks` holds footnote letters that point into the notes file.

## Evidence rule

Every `Yes` or `Partly` needs a verbatim quotation with its location, recorded in the notes file. Take the quotation from the full text, which is reachable through the DOIs; Europe PMC, PMC and arXiv HTML all work.

The `w*.md` extraction files in `docs/research/llm-rob2/` are leads, not proof. Re-check each claim against the source, and correct any lead that turns out to be wrong.

Use `Not reported` when the paper is silent, and `No` only when the paper shows absence. For example, Taneri and Gandhi state the inputs given to the model.

If the full text is unavailable, say so, and use only the abstract plus clearly marked `Not reported`.

## Row 10, this study

Fill row 10 from the repository only:

- `ANALYSIS-PLAN.md`
- `kit-sonnet-5.5/README.md` and `no-kit-sonnet-5.5/README.md`
- `analysis/output/tables/table3.csv`
- `analysis/output/tables/audit-summary.csv`

`n_trials` is 102. The adjudication answer is "blinded adjudication of disagreement cells".

## Notes file

The notes file gives, per row: the full citation, the full-text source used, a quotation for each `Yes`/`Partly` cell, and any corrections to the `w*.md` leads.

End it with a list of the footnote texts suitable for the table's notes, in plain language, keeping each line short.
