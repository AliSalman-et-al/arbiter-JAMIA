# Round 7 implementation report

Implemented the replacement plan section 5.6 using independent signalling answers
and the previously validated domain algorithms. No human or LLM taxonomy coding
is used. Work remains on main, with no push. The implementation and tests are in
09977a9 (Implement signalling-question error localisation with tested ordered
classes); the following output/report commit contains this report, the generated
exports and removal of the obsolete coding materials. Starting HEAD was
194101f448bfa73f5625338917626ed718080a89. ANALYSIS-PLAN.md, GLOSSARY.md and all
input data folders are unchanged.

The brief described a repository without a remote, but `git remote -v` shows an
existing origin at https://github.com/AliSalman-et-al/arbiter-JAMIA.git. It was left
unchanged. No fetch, push or other remote operation was performed.

## Populations and reproduced counts

Workbook slug/domain row order is identical between A and Z. The guide confirms
that independent answers precede blinded label comparison and that explanations
contain repeated full-trial text. Losses and usability are scored by label equality.

| Losing source | All consensus losses | Primary: both usable | Sensitivity: at least one usable |
|---|---:|---:|---:|
| ARBITER-Sonnet | 13 | 10 | 12 |
| Baseline-Sonnet | 60 | 47 | 57 |
| Meta label | 100 | Not localisable | Not localisable |

These exactly reproduce the lead's 13/60/100 and 10/12, 47/57 counts. The sensitivity
population includes the primary population. Meta losses have no signalling answers;
their direction remains in section 5.5. Haiku is excluded.

## Class counts

The first applicable class wins, in the prescribed order.

| Class | ARBITER primary | ARBITER sensitivity | Baseline primary | Baseline sensitivity |
|---|---:|---:|---:|---:|
| Judgement departs from own answers | 0 | 0 | 4 | 4 |
| Single decisive question | 6 | 6 | 27 | 29 |
| Several decisive questions | 1 | 1 | 2 | 2 |
| Jointly decisive | 2 | 4 | 11 | 18 |
| Answers agree, judgement differs | 1 | 1 | 2 | 2 |
| Not attributable | 0 | 0 | 1 | 2 |
| Total | 10 | 12 | 47 | 57 |

Primary class counts fit as six additional Table 4 rows. Both populations appear
in the supplement. Cell audit exports retain discordant, individually decisive,
adjudicators-differ, unresolved-reference and invalid-substitution questions,
algorithm outputs and reference-judgement departure flags.

## Decisive questions

Every nonzero primary frequency is shown below; all 22 questions including zeros
and both populations are in error-localisation-frequency.csv. Short text is an
abbreviation of official RoB 2 wording, mapped in the existing question-map function.

| Question | Short text | ARBITER primary | Baseline primary |
|---|---|---:|---:|
| 1.2 | Concealment until enrolment and assignment | 1 | 3 |
| 2.3 | Deviations arising from trial context | 3 | 3 |
| 2.6 | Appropriate analysis of assignment effect | 0 | 3 |
| 2.7 | Substantial impact of analysing outside assigned groups | 1 | 0 |
| 3.1 | Outcome data available for nearly everyone | 0 | 1 |
| 4.5 | Assessment likely influenced by awareness | 0 | 1 |
| 5.1 | Analysis plan finalised before unblinding | 2 | 18 |
| 5.2 | Result selected from eligible outcome measurements | 0 | 1 |
| 5.3 | Result selected from eligible analyses | 1 | 1 |

ARBITER's leading questions are 2.3 (3) and 5.1 (2), unchanged in sensitivity.
Baseline's leading question is 5.1 (18), then 1.2, 2.3 and 2.6 (3 each).
Sensitivity increases Baseline 2.6 to 4 and 5.2 to 2; other individual-question
frequencies are unchanged. Cells can contribute several individually decisive
questions. Jointly decisive sets contribute no individual-question frequencies.
The supplement includes a title-free horizontal-bar PNG/PDF with primary counts,
ARBITER teal and Baseline orange. Zero-in-both-source questions are omitted only
from the figure.

## Parsing, interpretation and quote candidates

Exactly one answer cannot be assigned a single value: chiba-2021 D3, adjudicator A,
question 3.4, recorded as NI at 6 months; PY at 12 months. The entire qualified value
is preserved in error-localisation-issues.csv. No time point is selected. Neither
independent judgement matches preferred, so this cell is outside both populations.

NI and NA remain separate. Substitution changes only the specified answer; stored
NA values are retained even when an upstream substitution makes a new question
required. An invalid path supplies no algorithm judgement and is not counted as
an individually decisive change. Joint substitution must reach preferred. These
choices, incomplete comparisons and reference-algorithm departure flags are
documented in DEVIATIONS.md entries 21–23. Under the plan's exact no-discordant
criterion, class 5 may include adjudicator disagreement; such questions are flagged
separately, so the class name must not be interpreted as unanimous answer equality.
No unresolved data-selection uncertainty remains; counterfactual results describe
the algorithm on recorded answers, not a fresh clinical reassessment.

discussion-quote-candidates.csv contains five cells per source, selected without
reading or ranking explanation content. Sort primary before sensitivity-only,
single-decisive before the other ordered classes, then slug/domain alphabetically;
take five per source. All ten selected cells are primary and single-decisive.

- ARBITER: bausys-2023 D2, fulop-2021 D1, hanafiah-2022 D2, ibrahim-2017 D2,
  sung-2020 D2.
- Baseline: abbasi-2012 D2, allen-2014 D5, an-2021 D2, apalla-2013 D5, ascet D5.

Both full adjudication_explanation columns are preserved verbatim and independently
compared with the workbook strings. The obsolete codebook, blank/working coding
sheets, embedded second-coder sample, instructions, functions/tests and report
placeholders are removed. Historical round reports remain provenance. The unused
historical coding-sample seed remains in the unchanged reproducibility CSV.

## Validation

- From analysis/, the full testthat suite passes without failures, errors, warnings
  or skips. New hand-built tests cover all six classes, Baseline label departure,
  ARBITER no-discordance, joint substitution, adjudicator disagreement, distinct
  NI/NA, parse failures, invalid counterfactual paths and both eligibility populations.
  Regression checks independently reproduce the lead's observed counts.
- `quarto render` successfully rebuilt both reports through the project renv
  environment. Existing Windows R startup locale warnings remain.
- `Rscript verify-output.R` passes existing artifact checks and the new six table
  exports, 6000 × 3300 PNG (10 × 5.5 inches, 600 dpi) and one-page PDF checks.
- `Rscript verify-round7.R` compares every retained repository CSV to immutable
  starting HEAD: all 81 retained CSVs are byte-identical. Exactly six CSVs are new
  and the three obsolete coding CSVs are removed. No previous numerical export or
  derived input changes. The prohibited-name scan passes both rendered HTML files,
  all output CSV/Markdown files and text extracted from all six figure PDFs.
- The new PNG was visually inspected: labels/counts are legible, bars match the
  frequency table, colours are correct and there is no title within the image.
- All five existing regenerated PDFs have identical extracted text to starting
  HEAD; incidental binary changes were discarded. Existing PNGs are unchanged.
- `git diff --check` passes. No dependency, input-data or plan/glossary change was
  needed. No remote push was performed.
