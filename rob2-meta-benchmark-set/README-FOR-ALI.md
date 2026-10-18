# RoB 2 eval set from meta-analysis labels, full set (version 2)

Built 2026-10-03. 105 trials from 16 meta-analyses. This replaces the 2026-09-29 set (106 trials).
The sample is the first 7 in-set trials per meta-analysis in the meta's own table order; a trial
that cannot be obtained is replaced by the next in-set trial in that order. `ACQUIRE-NEEDS-ACCESS.md`
records each replacement and each trial that could not be obtained.

## What changed since the 2026-09-29 set

- Each label now says which result it refers to. `LABEL-TARGETS.csv` gives, per trial, the
  outcome, time point and contrast the meta's RoB 2 rating covers, quoted from the meta where the
  meta states it, and marked as inferred where it does not. It also gives the result to assess:
  the trial's primary outcome where that is what the meta rated, otherwise the result the meta
  rated, with its definition, the numbers as printed and the file and page in the trial's own
  files. 43 of the 105 targets moved from the trial primary to the result the meta rated
  (neuropathic pain responders, severe adverse events in the rifampin trials, mortality in the
  preoxygenation trials, all-cause death in the AVR trials, pain at 12 months in the low back pain
  trials, GI adverse events in the GLP-1 GI trials, and a few others).
- The same columns (`assess`, `assess_outcome`, `assess_values_as_printed`, `assess_source`,
  `assess_vs_label`, `label_outcome`) are appended to `OUTCOMES-batch.csv`, and
  `TRIAL-SUMMARY.csv` carries a short form of them.
- `metas/<meta_id>/` holds the meta pages that carry the labels and a `BINDING.md` quoting what
  each meta says its RoB 2 ratings cover, with file and page. Every label row also carries the
  meta's DOI and title.
- For the seven GLP-1 GI trials, the meta's GI adverse-event counts come from the ClinicalTrials.gov
  results tables, not from the papers. Those tables are now in each folder as
  `ctgov-results-<NCT>.pdf` (role `supplement`), rendered from the registry record without changes
  to the counts.
- Trial and label corrections:
  - SANCTUARY: the folder held the felzartamab trial (IGNAZ), which the meta does not include. The
    meta's SANCTUARY is the ravulizumab trial (Lafayette, JASN 2025), which is now in the folder.
  - ORIGIN: the meta's ORIGIN entry is the phase 3 ORIGIN 3 trial, with results from a sponsor
    webcast; the folder held the phase 2b paper. It is replaced by Barratt 2024 (cemdisiran,
    CJASN), the next trial in the meta's Table 1.
  - Gibbs 2023 is the same RCT as Chiba 2021 and was dropped under the one-RCT-once rule. The next
    trial in order (Lee 2023, Arthroscopy) is paywalled, so the ACL meta has 5 trials.
  - Getgood 2020: the meta's Figure 2 has two Getgood 2020 rows. Our report (AJSM, the meta's
    ref 15) is the row rated Some concerns for D1 and overall, not the all-Low row (ref 14).
  - AVATAR: the meta's labels and numbers are from the 2024 Eur Heart J long-term follow-up, which
    is now the main article; the 2022 Circulation report is kept as a supplement.
  - MONARCH 3: the 2017 JCO primary report is now the main article (the meta's PFS hazard ratio is
    from it); the 2024 final overall-survival paper is kept as a supplement.
  - Frat 2019: the label is taken from the meta's peri-intubation hypoxaemia row, which has the
    same domain values as the mortality row and matches the trial primary.
  - EXSCEL had the NCT, PMID and year of a different paper (NCT01455896 is FREEDOM CVO); now
    NCT01144338, PMID 28910237, 2017. Allen 2014 had the PMID and year of an unrelated 2024 paper.
    GetGoal-F1 and DURATION-8 now carry their NCT in `sources.toml`.
  - The IgA nephropathy meta's overall column is a 0-10 point sum, not a RoB 2 overall. It is now
    `(not given)`, with the point sum kept in the notes.
  - ASCET: the anchor quoted the high-on-aspirin platelet-reactivity subgroup; it now quotes the
    whole randomized comparison.

## Where the labels and targets stand

`assess_vs_label` in `LABEL-TARGETS.csv`, over 105 trials:

| status | trials | meaning |
|---|---|---|
| same | 33 | the meta states which result it rated, and the target is that result |
| same (rating covers several outcomes) | 11 | one rating per trial covering every outcome the meta took from it; the target is one of those |
| same (inferred) | 33 | the meta does not say; the target is the result the meta pooled from that trial |
| partly | 7 | close but not the same result (another contrast, time window or part of a composite) |
| partly (inferred) | 2 | as above, on an inferred binding |
| different | 5 | four clopidogrel trials, where the meta used individual participant data that the papers do not print; Bendix 1996, where the meta rated the 2-year follow-up (Spine 1998), which is paywalled |
| different (inferred) | 4 | the meta's result for the trial is not the target and is not printed in the trial files |
| unknown | 10 | the ACL and prehabilitation metas give one rating per report and do not say which result |

The meta-by-meta binding, with quotes, is in `metas/<meta_id>/BINDING.md` and in the `binding`
and `binding_evidence` columns.

## What is here

- `trials/<slug>/` - one folder per trial, ready for `input/`: the publisher PDF of the primary
  report as `main_article`, every supplement listed on the publisher page as `supplement`, and
  `sources.toml` with the NCT where the trial has one. DOC, DOCX and PPT supplements were
  converted to PDF with LibreOffice; the originals sit in `trials/<slug>/orig/` and carry no
  role. Files that are not the article or a supplement (an author manuscript, a conference
  poster, a correction notice) are named `other-*` and roled `other`.
- `LABEL-TARGETS.csv` - one row per trial: meta DOI and title, D1-D5 and overall as printed, where
  the labels sit, which result they refer to (`label_outcome`, `label_time_point`,
  `label_contrast`), how we know (`binding`, `binding_evidence`), the result to assess (`assess*`
  columns), whether it matches the label (`assess_vs_label` with a note), and the numbers the meta
  extracted for the trial with their locator.
- `OUTCOMES-batch.csv` - one row per trial: the primary outcome, its definition quoted from the
  methods, the anchor quoted from the abstract as printed, the registration id and notes, followed
  by the `assess*` columns.
- `LABELS-batch.csv` - one row per trial: D1 to D5 and overall as the meta printed them, with
  `label_source`.
- `TRIAL-SUMMARY.csv` - one line per trial for reading, with the label, the binding, the result to
  assess, whether it matches, and flags.
- `metas/` - the label pages and binding notes per meta.
- `FILES.csv` - every file in the tree with role, sha256, bytes, page count and provenance.

## Things to know

- Heard 2023 (the adverse-event report of STABILITY) was dropped under the one-RCT-once rule;
  Getgood 2020, the primary report of the same RCT, stays.
- Seven trial identities were corrected during acquisition in the earlier set (TESTING, Gupta
  2024, Hundscheid 2022, Clyman 2019, EXSCEL, ALIGN and "Roze 2011", which is Roze 2021); two more
  in this one (SANCTUARY, and ORIGIN dropped). The corrected DOIs are in the sheets; the old ones
  are in the notes column.
- Three articles are the accepted in-press version rather than the final typeset layout (Potsiurko
  2022, El-Khuffash 2021, Levin 2016); the text is the published text.
- Twenty-one trials have no per-trial overall judgement in their meta (the preoxygenation NMA and
  the JAMA SGLT2 meta give domains only; the IgA nephropathy meta gives a point sum), so D1-D5 are
  the usable labels there. Gupta 2024's overall is Low with D2 Some concerns, as the meta printed it.
- The Lancet Rheumatol meta uses its own overall rule (three or more Some concerns makes a trial
  High), so some of its High overalls come from that rule rather than a High domain.
- Registrations that are not NCT (ISRCTN, KCT) are recorded in `OUTCOMES-batch.csv` and not
  declared in `sources.toml`, which takes one NCT only. Barratt 2024's NCT is from the meta's
  label; the PDF text layer does not print it.
- Checks run on the tree: every `sources.toml` parses with exactly one `main_article`; page 1 of
  every main article reads as a results paper; every main article carries a Results heading or a
  numbered table or figure. The NCT in every `sources.toml` was checked against the main article: 72 match, 32 trials
  carry no NCT, and Barratt 2024 is the one whose PDF does not print it.

## Coverage by meta-analysis

| field | meta | trials |
|---|---|---|
| 01 General Medicine | Lancet, clopidogrel vs aspirin for secondary prevention of CAD (IPD meta) | 7 of 7 |
| 01 General Medicine (alternate) | JAMA, SGLT2 inhibitors | 7 of 7 |
| 02 Cardiology | JACC, AVR vs clinical surveillance in asymptomatic severe AS | 2 of 4 (EARLY TAVR and EVOLVED not obtainable) |
| 03 Oncology and Hematology | Lancet Oncol, CDK4/6 inhibitors plus endocrine therapy (IPD meta) | 7 of 7 |
| 04 Neurology | Lancet Neurol, pharmacotherapy and neuromodulation for neuropathic pain | 7 of 7 |
| 05 Psychiatry | Lancet Psychiatry, cannabinoids for mental and substance use disorders | 7 of 7 |
| 06 Gastroenterology and Hepatology | Gastroenterology, GLP-1 RAs and GI adverse events | 7 of 7 |
| 07 Pulmonary and Critical Care | Lancet Respir Med, preoxygenation strategies for intubation (NMA) | 7 of 7 |
| 08 Endocrinology Diabetes and Metabolism | Lancet Diabetes Endocrinol, GLP-1 RAs on kidney and CV outcomes | 7 of 7 |
| 09 Infectious Diseases | Clin Infect Dis, safety of triple-dose rifampin in TB | 7 of 7 |
| 10 Rheumatology and Immunology | Lancet Rheumatol, non-surgical interventions for chronic LBP | 7 of 7 |
| 11 Surgery and Perioperative | Br J Anaesth, home-based prehabilitation | 7 of 7 |
| 12 Obstetrics Gynecology and Reproductive | Hum Reprod Update, preconception lifestyle interventions | 7 of 7 |
| 13 Pediatrics | JAMA Pediatr, active treatment vs expectant management of PDA | 7 of 7 |
| 14 Nephrology | Clin J Am Soc Nephrol, therapies for proteinuria and eGFR in IgA nephropathy | 7 of 7 |
| 15 Orthopedics and Musculoskeletal | Am J Sports Med, lateral extra-articular procedure with ACL reconstruction | 5 of 7 (Heard 2023 and Gibbs 2023 dropped as duplicates; Lee 2023 paywalled) |
