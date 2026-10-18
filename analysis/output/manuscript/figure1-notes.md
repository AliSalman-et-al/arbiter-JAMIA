# Figures 1–2: provenance and display notes

## Figure 1

The workflow is a functional grouping of representative real MCP tools. Response labels and the rejection arrow are explanatory summaries. Approval uses the public `arbiter review` command; archived inputs retain their historical names. The server proposes judgements from the official algorithm; adopted judgements may differ through a recorded override. AVATAR has no override.

## Workflow tool provenance

ARBITER source commit: `2f549ae30f056ff441ea61a04b719968716f2219`. Definitions: `src/arbiter/interfaces/mcp/server.py`.

Capture: `prepare_batch` (line 2572), `acquire_companion_source` (line 2735), `admit_companion_source` (line 2768), `list_sources` (line 2810).
Propose & approve: `validate_proposal` (line 3991), `save_proposal` (line 4023), `request_proposal_approval` (line 4145).
Assess each domain: `get_domain_context` (line 4350), `read_guidance` (line 2447), `read_pages` (line 3255), `search_sources` (line 2873), `calculate_arithmetic` (line 2477), `save_working_checkpoint` (line 2675), `save_domain_judgment` (line 4542), `get_status` (line 2623).
Review & export: `review_trial` (line 4648), `close_trial` (line 4802), `finalize_batch` (line 4831).

## Save-call rejection audit

{
  "trials": 102,
  "total_calls": 637,
  "rejected": 53,
  "by_reason": {
    "accepted": 584,
    "evidence_or_basis_schema": 32,
    "other_validation": 21
  },
  "avatar_calls": 7,
  "avatar_rejected": 1
}

The CSV has one row per unique tool-use ID, matched to its tool result across all turn logs. Trials come from the Sonnet domain-label file with the three design exclusions; exactly 102 are required. Rejected means an error flag or an explicit not-saved/error result. Reasons are classified from actual error details, not the scientific validity of a judgement. Accepted includes repeat successful saves. Counts describe Sonnet only; they are not a failure rate across all ARBITER models.

## Figure 2

Bundle SHA-256: `d6d683efd3acce82f9e0ee233d194223c569ffb7ac76ab74e45c6c4071fb6655`. Manifest content hashes checked at every build. Archived verifier: `verified`; this does not certify clinical correctness. Source hash prefixes identify searchable projections, not PDF bytes. Quotes preserve source text; whitespace wraps are collapsed. Two extraction line breaks are joined for legibility: assign-↵ment → assignment and cen↵sored → censored. No words are substituted. Ellipses denote omissions. Official question excerpts are shortened, with ellipses, from the RoB 2 wording.

AVATAR log correction: the rejected D3 save (`toolu_01CTHBEhdF5BAGdpapeh9D5F`) flattened the locator fields directly into the basis. The accepted retry (`toolu_01PN3CESV3Hj5VbcRRWKbc5E`) nested source/page/lines under `bases[].evidence`, an accepted source-span reference form; it did **not** submit an `eh_…` string. The server bound it as `eh_e66d374e838e8c6d`. Therefore the figure illustrates schema/binding validation, not a claim that literal handles are the only accepted syntax.

The four numbered callouts identify span binding, branching, the server algorithm and unknowns. Yellow links direct-support source text to the corresponding recorded reasoning. Lavender links context text to the recorded composite-outcome interpretation. The missing dated plan remains plain text: a context quotation does not itself prove absence. Unnumbered comparison callouts identify the Unassisted invalid path and the registry comparison. The footer compares **D5**, the domain adjudicated for this trial; the same Published/Unassisted labels also apply to Overall, but Overall was not adjudicated.

### D1

1.2: Was the allocation sequence concealed until participants were enrolled and assigned to interventions?

Answer: Yes. Proposed/adopted: low/low.

Full recorded justification:
Patients were randomized using a web-based interactive response system, a central remote allocation method independent of enrolment staff. Variable block size limits predictability of the last allocations in a block.

Displayed justification excerpt:
Patients were randomized using a web-based interactive response system…

Unknowns:
["Whether the central system was run by a unit independent of enrolling staff is not stated explicitly."]

**direct_support**: `CIRCULATIONAHA.121.057639.pdf`, page 3, bound lines 46–50.
Handle `eh_d6c269341c7d8a5d`; evidence `sha256:d6c269341c7d8a5d5cb1b3dd7eaa6c26a63009a60f6b09d34dd2be02d496f349`; source `source_695a701df7a7b784e50a68c4ab749ed7917e3cb84d87a08196adbdf37c6e4d56`; source projection `sha256:592b9a6c531c0b049f2039fffd71fd128e6a604e908c06cec2bb153c4878b8a0`.

Displayed quote: … web-based interactive response system. The assignment to each treatment group was computer-generated and … by means of a permuted-block sequence with variable block size.

Full bound span:

randomly assigned to early surgery or conservative treatment
using a web-based interactive response system. The assign-
ment to each treatment group was computer-generated and
stratified according to the participating centers by means of
a permuted-block sequence with variable block size. Details

Unassisted answers: 1.1 Y · 1.2 Y · 1.3 PN

Unassisted displayed excerpt: Allocation used a computer-generated, centre-stratified permuted-block sequence delivered through a web-based interactive response system, so concealment was adequate.

Unassisted full rationale: Allocation used a computer-generated, centre-stratified permuted-block sequence delivered through a web-based interactive response system, so concealment was adequate. The baseline differences in age (P = .02) and haemoglobin (P = .01) are consistent with chance across about 25 variables.

### D2

2.1: Were participants aware of their assigned intervention during the trial?

Answer: Yes. Proposed/adopted: low/low.

Full recorded justification:
The registry lists masking as NONE, and the comparison is surgical valve replacement versus watchful waiting, which cannot be hidden from participants.

Displayed justification excerpt:
The registry lists masking as NONE…

Unknowns:
[]

**direct_support**: `ClinicalTrials.gov NCT02436655`, page 1, bound lines 67–68.
Handle `eh_975aac3202107531`; evidence `sha256:975aac3202107531915fbf535a75cc136f9b747b9d65d2e916ae80c99a59576e`; source `source_b28064bc31d3335957e34134a4873694fc9f01af0ca3640ab719d51f1ae00099`; source projection `sha256:d32e23eb2a1e9a1505bbcf5f930b2af72508c4887cea3775a63e30ab95ba16e0`.

Displayed quote: Masking: NONE

Full bound span:

#### Masking info
- Masking: NONE

Unassisted answers: 2.1 Y · 2.2 Y · 2.3 PN · 2.4 NA · 2.5 NA · 2.6 Y · 2.7 NA

Unassisted displayed excerpt: The trial was open label, so participants and clinicians knew the assignments.

Unassisted full rationale: The trial was open label, so participants and clinicians knew the assignments. Surgery in the conservative arm followed protocol-defined triggers such as symptom onset. Six of 78 early-surgery patients did not receive surgery, and some surgeries were delayed by COVID-19. These are not deviations likely to affect the outcome. The analysis was intention-to-treat.

### D3

3.1: Were data for this outcome available for all, or nearly all, participants randomized?

Answer: Yes. Proposed/adopted: low/low.

Full recorded justification:
All 157 randomized patients were analysed and median follow-up was 63 months. Only one patient (early-surgery arm) was lost to follow-up and censored at last contact, so 1/157 (0.6%) has incomplete outcome data. This is far fewer than the observed deaths, so any outcome for that patient could not materially change the HR of 0.44.

Displayed justification excerpt:
so 1/157 (0.6%) has incomplete outcome data.

Unknowns:
[]

**direct_support**: `ehae585.pdf`, page 6, bound lines 26–32.
Handle `eh_e66d374e838e8c6d`; evidence `sha256:e66d374e838e8c6ddbc115270872899bc6e58f850549df46d3e7ea953537067c`; source `source_7f7b055eb93e03bcd72c8fe32984a531050e324a0b58555dbc9701c8b3e2d5e7`; source projection `sha256:a890f771fd05ebda4edada403fa59475add7dfa13409e53bbca7f38407265ae3`.

Displayed quote: All patients were included in the analysis. … One patient, who was randomized to early surgery, has been lost to follow-up, and this patient was censored…

Full bound span:

nificant heterogeneity between both groups was noted. All patients
were included in the analysis. Median follow-up for all patients was
63 months [interquartile range (IQR) 48-75). Median follow-up in sur
vivors was 68 months (IQR 58-79). One patient, who was randomized
to early surgery, has been lost to follow-up, and this patient was cen
sored when the last follow-up information was available and included
in the intention-to-treat analysis (Figure 1).

Unassisted answers: 3.1 Y · 3.2 NA · 3.3 NA · 3.4 NA

Unassisted displayed excerpt: All 157 patients were analysed. One patient lost to follow-up was censored.

Unassisted full rationale: All 157 patients were analysed. One patient lost to follow-up was censored.

### D4

4.3: If N/PN/NI to 4.1 and 4.2: Were outcome assessors aware of the intervention received by study participants?

Answer: Yes. Proposed/adopted: low/low.

Full recorded justification:
The trial was open-label (registry masking: none), and the report states that DSMB members were not blinded to allocation when reviewing events. Site investigators recording deaths were also aware of the allocation.

Displayed justification excerpt:
the report states that DSMB members were not blinded to allocation when reviewing events.

Unknowns:
[]

**direct_support**: `ehae585.pdf`, page 3, bound lines 1–116.
Handle `eh_3ce4199af9d487f3`; evidence `sha256:3ce4199af9d487f3e5ca3f79d7aa594f229272e2c0d58e52514ccdb17a749a68`; source `source_7f7b055eb93e03bcd72c8fe32984a531050e324a0b58555dbc9701c8b3e2d5e7`; source projection `sha256:a890f771fd05ebda4edada403fa59475add7dfa13409e53bbca7f38407265ae3`.

Displayed quote: Data and safety monitoring board members were not blinded to the treatment allocation during events review.

Full bound span:

Introduction
Aortic stenosis (AS) is the single most common valvular heart disease re
quiring intervention in developed countries and is projected to double by
2050 in both the USA and Europe.1 The approach to symptomatic pa
tients with severe AS is straightforward. Surgical aortic valve replacement
(AVR) and, more recently, transcatheter aortic valve implantation (TAVI)
procedures are Class I recommendation to relieve symptoms and im
prove survival in symptomatic patients with severe AS.2,3
Conversely, the question of when and how to treat truly asymptom
atic patients with severe AS and normal left ventricular (LV) systolic
function is still subject to debate and ongoing research. To date, two
randomized trials have demonstrated benefit of early AVR in compari
son with conservative strategy in asymptomatic patients with severe
and very severe AS patients.4,5 In addition, there are several ongoing
randomized trials investigating the role of early TAVI and/or early sur
gical AVR in asymptomatic AS.
The Aortic Valve Replacement Versus Conservative Treatment in
Asymptomatic Severe Aortic Stenosis (AVATAR) trial is an investigator-
initiated, prospective, multinational, randomized, controlled, parallel-group,
event-driven trial that compared the safety and efficacy of early surgery in
the treatment of truly asymptomatic patients with severe AS and LV ejec
tion fraction (LVEF) ≥ 50% vs. conservative treatment with watchful wait
ing strategy and AVR only after symptom onset, or other guidelines
directed Class I or II indications for AVR.3,6 In the primary analysis of the
AVATAR trial, asymptomatic AS patients randomized to early surgery
had a lower incidence of the composite primary outcome comprising all-
cause death, acute myocardial infarction, stroke, or unplanned hospitaliza
tion for heart failure (HF), compared with patients who were randomized
to conservative treatment.5 We now report the results of the AVATAR
trial after extended follow-up at 5 years.
Methods
Study design and oversight
The AVATAR trial (ClinicalTrials.gov identifier NCT02436655) protocol
and protocol update were designed by the first co-authors and steering
committee co-chairmen and was approved by the steering committee of
the AVATAR trial.7,8 The clinical and outcomes data were collected by per
sonnel at the participating sites and were sent directly to the data coordinat
ing centre at the University Clinical Center of Serbia. No extramural funding
was used to support this work. The authors, members of the steering com
mittee, and investigators are solely responsible for the design and conduct of
this trial, all analyses, drafting and editing of the article, and its final contents.
Independent statistician conducted the long-term data analyses.
The trial was conducted in accordance with the Declaration of Helsinki. All
participants provided written informed consent. An independent data and
safety monitoring board (DSMB) adjudicated all serious adverse events and
oversaw the safety of the trial. The article was prepared by the first author
and steering committee co-chairmen and was reviewed and edited by mem
bers of the steering committee and authors. All authors reviewed the article,
approved its submission for publication, and vouched for the accuracy and
completeness of the data and for the fidelity of the trial to the protocol.
Study population
The study inclusion and exclusion criteria are shown in Table 1; trial flowchart
is shown in Figure 1. Briefly, a total of 157 patients with severe AS according to
the guidelines were enrolled in the trial: 79 were randomized to conservative
treatment and 78 were randomized to early surgery. To prove truly asymp
tomatic status, exercise testing was performed in all candidates to evaluate
symptom status according to a standardized protocol using treadmill or semi-
supine ergo-bicycle. To consider exercise testing negative, which was manda
tory for inclusion, all candidates needed to reach a projected submaximal
heart rate. Positive exercise test included onset of AS-related symptoms,
fall in systolic blood pressure (≥20 mmHg from the baseline values), or
Electrocardiography (ECG) or stress echocardiography signs of myocardial
ischaemia.9
Follow-up and trial endpoints
Patients were followed according to the protocol every 6 months for the
first year and then yearly with the in-person visits at the participating study
centre. As the trial was affected by the Covid-19 pandemic, contact with
patients who could not come in person was made by phone. For any event
that was registered, the medical records were asked for and reviewed.
Adverse clinical events were adjudicated by the DSMB per protocol defini
tions.7,8 Data and safety monitoring board members were not blinded to
the treatment allocation during events review. They adjudicated the events
by consensus.
Table 1 Eligibility inclusion/exclusion criteria
Inclusion criteria
• Men and women of any ethnic origin aged ≥18 years
• Written informed consent
• Vmax across the aortic valve > 4 m/s or P mean ≥ 40 mmHg and AVA ≤
1 cm2 or AVAi ≤ 0.6 cm2/m2 at rest
• Without reported symptoms
• Society of Thoracic Surgeons score < 8%
Exclusion criteria
Participation in another clinical trial within 30 days prior to
randomization
• Pregnant or nursing women
• Mental condition rendering the patient unable to understand the
nature, scope, and possible consequences of the study or to follow the
protocol
• Positive stress-test defined as follows:
(a)
Anginal chest pain during testing
(b)
Syncope or dizziness during testing
(c)
Decrease in systolic blood pressure during exercise ≥ 20 mmHg
(d)
Malignant arrhythmia during exercise testing (VT or VF)
• Left ventricular ejection fraction < 50% at rest
• Very severe AS defined as Vmax > 5.5 m/s at rest
• Significant disease of other valves: mitral stenosis with Pmean > 5 mg, or
any significant regurgitation ≥ 3+
• Recent previous myocardial infarction (<1 year)
• Need for additional aortic root replacement (i.e. Bentall) or ascending
aorta surgery in asymptomatic patients undergoing AVR
• Previous coronary bypass surgery
• Previous any heart valve surgery
• Impaired renal function, i.e. creatinine > 200 μmol/L or glomerular
filtration rate < 30 mL/min/1.73 m2
• Significant pulmonary hypertension at rest (systolic pulmonary artery
pressure > 50 mmHg)
• Uncontrolled hypertension at rest (systolic blood pressure >
180 mmHg and diastolic blood pressure > 100 mmHg)
• Significant comorbidity with reduced life expectancy (<3 years)
• Uncontrolled diabetes mellitus (HbA1c > 9%)
• Significant chronic obstructive pulmonary disease (FEV1 < 70% of
predicted value)

Inference (no quotation displayed): All-cause death is an observer-reported outcome that involves no judgement…
The inference basis still references the same bound evidence as 4.3; a dashed outline distinguishes the reasoning from quoted direct support. The bound 4.3 span explicitly includes the DSMB unblinding sentence; there is no citation mismatch.

Unassisted answers: 4.1 N · 4.2 N · 4.3 NA · 4.4 NA · 4.5 NA

Unassisted displayed excerpt: Death is an objective outcome. Assessors were not blinded to allocation, but this cannot plausibly bias an all-cause death count.

Unassisted full rationale: Death is an objective outcome. Assessors were not blinded to allocation, but this cannot plausibly bias an all-cause death count.

### D5

5.1: Were the data that produced this result analysed in accordance with a pre-specified analysis plan that was finalized before unblinded outcome data were available for analysis?

Answer: No information. Proposed/adopted: some_concerns/some_concerns.

Full recorded justification:
The registry entry (first submitted 30 Apr 2015, before enrolment began in June 2015) names all-cause death only as a component of composite outcomes. It does not list time to all-cause death as a separate outcome. The Circulation 2022 and EHJ 2024 reports describe 'time to death' as a prespecified secondary end point analysed with Kaplan-Meier and Cox models, citing a published protocol. That protocol is not among the captured Sources, and the report statements are not date-stamped before unblinded data. The only SAP-type document is an amendment dated 4 Jan 2021 about COVID surgical delays. No dated source therefore specifies this measurement and analysis.

Displayed justification excerpt:
names all-cause death only as a component of composite outcomes.

Unknowns:
["Whether the published protocol listed time to all-cause death and its Cox analysis, and its date relative to unblinded data."]

**context**: `CIRCULATIONAHA.121.057639.pdf`, page 4, bound lines 16–35.
Handle `eh_7ad155913c1c5826`; evidence `sha256:7ad155913c1c58263ae1f68422aa27e610b681a3d164be094e441d48d5fd3bb4`; source `source_695a701df7a7b784e50a68c4ab749ed7917e3cb84d87a08196adbdf37c6e4d56`; source projection `sha256:592b9a6c531c0b049f2039fffd71fd128e6a604e908c06cec2bb153c4878b8a0`.

Displayed quote: Prespecified secondary end points included the following: … Time to death

Full bound span:

Trial End Points
The primary end point was a composite of all-cause mortality
or major adverse cardiovascular events (MACEs) composed of
acute myocardial infarction, stroke, and unplanned HF hospital-
ization needing intravenous treatment with diuretics or inotro-
pes. Prespecified secondary end points included the following:
• In-hospital and 30-day postoperative mortality in oper-
ated patients in both groups
• Repeat aortic valve surgery in operated patients in both
groups
• Repeated MACEs, including stroke, acute myocardial
infarction, or unplanned HF hospitalization needing IV
diuretic treatment
• Major bleeding defined as types 3, 4, and 5 according
to the consensus report from the Bleeding Academic
Research Consortium13
• Thromboembolic complications on the basis of clinical
symptoms, signs, and imaging studies
• Time to death
• Time to first HF hospitalization

**context**: `ClinicalTrials.gov NCT02436655`, page 1, bound lines 95–101.
Handle `eh_d54a2600ddc753b3`; evidence `sha256:d54a2600ddc753b357c613143d0dc578719c891b861e7a229dd6edfb68ae27c1`; source `source_b28064bc31d3335957e34134a4873694fc9f01af0ca3640ab719d51f1ae00099`; source projection `sha256:d32e23eb2a1e9a1505bbcf5f930b2af72508c4887cea3775a63e30ab95ba16e0`.

Displayed quote: Primary outcome 1: all cause death, Major Adverse Cardiac Event (MACE) including: …

Full bound span:

### Primary outcome 1: all cause death, Major Adverse Cardiac Event (MACE) including: ( Acute Myocardial Infarction - AMI, Stroke - CVI, unplanned hospitalization for Heart failure (HF) needing intravenous treatment
- Measure: all cause death, Major Adverse Cardiac Event (MACE) including: ( Acute Myocardial Infarction - AMI, Stroke - CVI, unplanned hospitalization for Heart failure (HF) needing intravenous treatment
- Time frame: 36 months

### Primary outcome 2: all cause death, Major Adverse Cardiac Event (MACE) including: ( Acute Myocardial Infarction - AMI, Stroke - CVI, unplanned hospitalization for Heart failure (HF) needing intravenous treatment
- Measure: all cause death, Major Adverse Cardiac Event (MACE) including: ( Acute Myocardial Infarction - AMI, Stroke - CVI, unplanned hospitalization for Heart failure (HF) needing intravenous treatment
- Time frame: 5 years

Displayed gap (plain text, not highlighted as evidence): No dated source therefore specifies this measurement and analysis.

Unassisted answers: 5.1 PY · 5.2 PN · 5.3 PN

Unassisted displayed excerpt: Time to death was a prespecified secondary endpoint with a registered 5-year time frame.

Unassisted full rationale: Time to death was a prespecified secondary endpoint with a registered 5-year time frame. It was analysed with a single Cox model, and the SAP amendment only addresses COVID-19 delays. I found no sign of selective reporting. A small concern is that the extended follow-up was a later analysis, but it matches the registered time frame.
