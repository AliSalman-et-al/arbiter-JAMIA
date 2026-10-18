# Figures 1–2: provenance and display notes

The workflow uses plain labels above representative real MCP calls. Tool definitions and the public audit-file extension are checked against ARBITER source commit `2f549ae30f056ff441ea61a04b719968716f2219`. The frozen rejection audit remains in save-rejections.csv and its summary JSON.

## AVATAR storyboard

The registry title identifies aortic valve replacement versus conservative treatment in asymptomatic severe aortic stenosis (AVATAR). Early surgery versus watchful waiting is the reader-facing description of this comparison. The requested outcome is all-cause death. Paper page numbers refer to CIRCULATIONAHA.121.057639.pdf; the registry is NCT02436655.

Source quotations are verbatim selections with ellipses for omissions and normalized extraction whitespace. Two extraction breaks are joined: assign-↵ment and cen↵sored. Questions and plain reasons are paraphrased; official wording is retained below and in eTable 31.

Every manifest hash and source-version binding is checked at build time. The archive stores source identities and evidence quotations, rather than complete trial PDFs. Its stored evidence is the unchangeable source copy referenced by the illustration. Archived independent-verifier receipt: verified; this is a structure/evidence-binding check, not a clinical judgement.

D5 rule checked against the scientific-pack selection.md Algorithm section: High if 5.2 or 5.3 is Yes/Probably yes; otherwise Some concerns if 5.1 is No/Probably no/No information, or 5.2/5.3 is No information. NI/PN/PN therefore yields Some concerns. The overall.any_concerns rule is asserted from the bundle; the figure describes this trial, where no domain is High.

All six Without ARBITER labels are asserted against both results-102/model-domain-labels.csv and the versioned model-domain-labels.csv. The quoted 5.1 claim is asserted against the ignored final run log. Both adjudicators preferred D5 Some concerns; Published D5 is Low. Overall was not adjudicated. Check/cross mean agreement/disagreement with this consensus preferred D5 judgement.

Bundle SHA-256: `d6d683efd3acce82f9e0ee233d194223c569ffb7ac76ab74e45c6c4071fb6655`. AVATAR is illustrative, not representative.

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
  "avatar_rejected": 1,
  "trial_domains_audited": 510,
  "domain_attribution_inferred_calls": [
    "toolu_01SEACoGACFkmrTarcdeV4oH"
  ],
  "domains_with_rejection": 47,
  "domains_final_save_succeeded_after_rejection": 47,
  "rejections_followed_by_success_same_domain": 53,
  "domains_without_successful_save": [],
  "domains_final_call_rejected": []
}

## Domain 1

Was the allocation sequence concealed until participants were enrolled and assigned to interventions?

Displayed source quotation(s): … web-based interactive response system … computer-generated … permuted-block sequence with variable block size.

Full recorded selected-answer justification: Patients were randomized using a web-based interactive response system, a central remote allocation method independent of enrolment staff. Variable block size limits predictability of the last allocations in a block.

Unknowns: ["Whether the central system was run by a unit independent of enrolling staff is not stated explicitly."]

Complete answers, inactive branches and decision:
{
  "answers": [
    {
      "answer": "yes",
      "bases": [
        {
          "evidence": "sha256:d6c269341c7d8a5d5cb1b3dd7eaa6c26a63009a60f6b09d34dd2be02d496f349",
          "kind": "direct_support",
          "source": "randomly assigned to early surgery or conservative treatment\nusing a web-based interactive response system. The assign-\nment to each treatment group was computer-generated and\nstratified according to the participating centers by means of\na permuted-block sequence with variable block size. Details"
        }
      ],
      "counterevidence": [],
      "justification": "The original AVATAR paper states the assignment was computer-generated and stratified by centre using a permuted-block sequence with variable block size, which is a random component.",
      "question_id": "sq:randomization:sequence",
      "unknowns": []
    },
    {
      "answer": "yes",
      "bases": [
        {
          "evidence": "sha256:d6c269341c7d8a5d5cb1b3dd7eaa6c26a63009a60f6b09d34dd2be02d496f349",
          "kind": "direct_support",
          "source": "randomly assigned to early surgery or conservative treatment\nusing a web-based interactive response system. The assign-\nment to each treatment group was computer-generated and\nstratified according to the participating centers by means of\na permuted-block sequence with variable block size. Details"
        }
      ],
      "counterevidence": [],
      "justification": "Patients were randomized using a web-based interactive response system, a central remote allocation method independent of enrolment staff. Variable block size limits predictability of the last allocations in a block.",
      "question_id": "sq:randomization:concealment",
      "unknowns": [
        "Whether the central system was run by a unit independent of enrolling staff is not stated explicitly."
      ]
    },
    {
      "answer": "no",
      "bases": [
        {
          "evidence": "sha256:92eed84c7b98e37ce92ea9048bdeb3edad965e52d804e9ad4fee8ae26afbab63",
          "kind": "direct_support",
          "source": "Table 2 Selected baseline characteristics of the study population\nEarly surgery group (n = 78)\nConservative treatment group (n = 79)\nP-value\nDemographics and comorbidities\nAge, years, median (IQR)\n68 (63-73)\n69 (64-75)\n.02\nSex (female)\n32 (41.0%)\n35 (44.3%)\n.67\nSTS score, median (IQR)\n1.6 (1.1-2.2)\n1.8 (1.2-2.7)\n.67\nDays from randomization to surgery, median (IQR)\n55 (36-79)\n476 (226-1098)\n<.001\nDiabetes mellitus\n14 (17.9%)\n23 (29.1%)\n.07\nHypertension\n69 (88.4%)\n70 (88.6%)\n.44\nHistory of PCI\n1 (1.3%)\n2 (2.5%)\n.44\nHistory of stroke\n2 (2.5%)\n2 (2.5%)\n.92\nPeripheral arterial disease\n0 (0%)\n1 (1.36%)\n.80\nLaboratory parameters\nBNP, pg/mLa, median (IQR)\n83 (53-127)\n89 (58-149)\n.61\nNT-proBNP, pg/mLa, median (IQR)\n381 (153-660)\n347 (186-722)\n.45\nHaemoglobin, g/L, median (IQR)\n141 (131-150)\n134 (128-141)\n.01\nCreatinine, μmol/L, median (IQR)\n80 (66-94)\n76 (67-92)\n.27\nBlood glucose, mmol/L, median (IQR)\n5.6 (5.3-6.7)\n5.6 (5.1-6.8)\n.70\nEchocardiography\nLVESV, mL, median (IQR)\n28 (20-41)\n33 (22-42)\n.96\nLVEDV, mL, median (IQR)\n113 (89-142)\n113 (96-126)\n.54\nLV mass index, g/m2, median (IQR)\n152 (133-175)\n160 (139-183)\n.67\nLeft atrium, cm\n4.1 (3.8-4.4)\n4.2 (3.9-4.4)\n.68\nSVi, mL/m2, median (IQR)\n39 (33-48)\n42 (34-51)\n.58\nPA systolic pressure, mmHg, median (IQR)\n30 (26-36)\n30 (27-37)\n.82\nVmax, m/s, median (IQR)\n4.5 (4.3-4.8)\n4.5 (4.2-4.7)\n.13\nPmean, mmHg, median (IQR)\n51 (44-58)\n50 (43-59)\n.16\nPmax, mmHg, median (IQR)\n82 (74-90)\n79 (70-90)\n.18\nAVA, cm2, median (IQR)\n0.73 (0.55-0.84)\n0.74 (0.59-0.89)\n.29\nAVAi, cm2/m2, median (IQR)\n0.37 (0.3-0.42)\n0.37 (0.31-0.46)\n.08\nE/eʹ, median (IQR)\n12.2 (9.6-16.3)\n12.2 (8.8-18.1)\n.54"
        },
        {
          "evidence": "sha256:58abdac52262aa33c6b0b4e3230462e089b195b924aa9f551aababd5d48495c4",
          "kind": "context",
          "source": "Diabetes mellitus\n14 (17.9%)\n23 (29.1%)\n.07"
        }
      ],
      "counterevidence": [
        {
          "basis_index": 1,
          "implication": "Diabetes was less common in early surgery (17.9% vs 29.1%), which could favour surgery, but P=.07 is compatible with chance and the 2022 paper attributes it to chance."
        }
      ],
      "justification": "Group sizes were 78 vs 79. Of about 25 baseline comparisons in Table 2, only age (P=.02) and haemoglobin (P=.01) were nominally significant, and diabetes was P=.07. The age difference is 1 year in medians. This is compatible with chance and none approaches P<0.001.",
      "question_id": "sq:randomization:baseline-imbalance",
      "unknowns": []
    }
  ],
  "inactive": [],
  "decision": {
    "adjudication": null,
    "adopted": "low",
    "authority": "algorithm",
    "contract": "rob2-kit.domain.reasoned-adjudication.v1",
    "proposed": "low",
    "trace_authority": "proposed_algorithm"
  }
}

Full selected-answer evidence:
[
  {
    "basis": {
      "evidence": "sha256:d6c269341c7d8a5d5cb1b3dd7eaa6c26a63009a60f6b09d34dd2be02d496f349",
      "kind": "direct_support",
      "source": "randomly assigned to early surgery or conservative treatment\nusing a web-based interactive response system. The assign-\nment to each treatment group was computer-generated and\nstratified according to the participating centers by means of\na permuted-block sequence with variable block size. Details"
    },
    "ev": {
      "end": 2769,
      "end_line": 50,
      "handle": "eh_d6c269341c7d8a5d",
      "identity": "sha256:d6c269341c7d8a5d5cb1b3dd7eaa6c26a63009a60f6b09d34dd2be02d496f349",
      "kind": "narrative",
      "page": 3,
      "quote": "randomly assigned to early surgery or conservative treatment\nusing a web-based interactive response system. The assign-\nment to each treatment group was computer-generated and\nstratified according to the participating centers by means of\na permuted-block sequence with variable block size. Details",
      "source_id": "source_695a701df7a7b784e50a68c4ab749ed7917e3cb84d87a08196adbdf37c6e4d56",
      "source_version": "sha256:592b9a6c531c0b049f2039fffd71fd128e6a604e908c06cec2bb153c4878b8a0",
      "start": 2472,
      "start_line": 46,
      "trial_id": "banovic26-avatar-2024"
    },
    "src": {
      "declared_role": "supplement",
      "id": "source_695a701df7a7b784e50a68c4ab749ed7917e3cb84d87a08196adbdf37c6e4d56",
      "label": "CIRCULATIONAHA.121.057639.pdf",
      "logical_path": "CIRCULATIONAHA.121.057639.pdf",
      "media_type": "application/pdf",
      "origin": "local_dossier",
      "page_count": 11,
      "projection_hash": "sha256:592b9a6c531c0b049f2039fffd71fd128e6a604e908c06cec2bb153c4878b8a0",
      "role": "supplement",
      "sha256": "sha256:dd643e8a0fc65605457c9a030145c67c4d87c43095476bd2b3440008f8513fab",
      "trial_id": "banovic26-avatar-2024"
    }
  }
]

## Domain 2

Were participants aware of their assigned intervention during the trial?

Displayed source quotation(s): Masking: NONE

Full recorded selected-answer justification: The registry lists masking as NONE, and the comparison is surgical valve replacement versus watchful waiting, which cannot be hidden from participants.

Unknowns: []

Complete answers, inactive branches and decision:
{
  "answers": [
    {
      "answer": "yes",
      "bases": [
        {
          "evidence": "sha256:975aac3202107531915fbf535a75cc136f9b747b9d65d2e916ae80c99a59576e",
          "kind": "direct_support",
          "source": "#### Masking info\n- Masking: NONE"
        },
        {
          "evidence": "sha256:3ce4199af9d487f3e5ca3f79d7aa594f229272e2c0d58e52514ccdb17a749a68",
          "kind": "context",
          "source": "Introduction\nAortic stenosis (AS) is the single most common valvular heart disease re\nquiring intervention in developed countries and is projected to double by\n2050 in both the USA and Europe.1 The approach to symptomatic pa\ntients with severe AS is straightforward. Surgical aortic valve replacement\n(AVR) and, more recently, transcatheter aortic valve implantation (TAVI)\nprocedures are Class I recommendation to relieve symptoms and im\nprove survival in symptomatic patients with severe AS.2,3\nConversely, the question of when and how to treat truly asymptom\natic patients with severe AS and normal left ventricular (LV) systolic\nfunction is still subject to debate and ongoing research. To date, two\nrandomized trials have demonstrated benefit of early AVR in compari\nson with conservative strategy in asymptomatic patients with severe\nand very severe AS patients.4,5 In addition, there are several ongoing\nrandomized trials investigating the role of early TAVI and/or early sur\ngical AVR in asymptomatic AS.\nThe Aortic Valve Replacement Versus Conservative Treatment in\nAsymptomatic Severe Aortic Stenosis (AVATAR) trial is an investigator-\ninitiated, prospective, multinational, randomized, controlled, parallel-group,\nevent-driven trial that compared the safety and efficacy of early surgery in\nthe treatment of truly asymptomatic patients with severe AS and LV ejec\ntion fraction (LVEF) ≥ 50% vs. conservative treatment with watchful wait\ning strategy and AVR only after symptom onset, or other guidelines\ndirected Class I or II indications for AVR.3,6 In the primary analysis of the\nAVATAR trial, asymptomatic AS patients randomized to early surgery\nhad a lower incidence of the composite primary outcome comprising all-\ncause death, acute myocardial infarction, stroke, or unplanned hospitaliza\ntion for heart failure (HF), compared with patients who were randomized\nto conservative treatment.5 We now report the results of the AVATAR\ntrial after extended follow-up at 5 years.\nMethods\nStudy design and oversight\nThe AVATAR trial (ClinicalTrials.gov identifier NCT02436655) protocol\nand protocol update were designed by the first co-authors and steering\ncommittee co-chairmen and was approved by the steering committee of\nthe AVATAR trial.7,8 The clinical and outcomes data were collected by per\nsonnel at the participating sites and were sent directly to the data coordinat\ning centre at the University Clinical Center of Serbia. No extramural funding\nwas used to support this work. The authors, members of the steering com\nmittee, and investigators are solely responsible for the design and conduct of\nthis trial, all analyses, drafting and editing of the article, and its final contents.\nIndependent statistician conducted the long-term data analyses.\nThe trial was conducted in accordance with the Declaration of Helsinki. All\nparticipants provided written informed consent. An independent data and\nsafety monitoring board (DSMB) adjudicated all serious adverse events and\noversaw the safety of the trial. The article was prepared by the first author\nand steering committee co-chairmen and was reviewed and edited by mem\nbers of the steering committee and authors. All authors reviewed the article,\napproved its submission for publication, and vouched for the accuracy and\ncompleteness of the data and for the fidelity of the trial to the protocol.\nStudy population\nThe study inclusion and exclusion criteria are shown in Table 1; trial flowchart\nis shown in Figure 1. Briefly, a total of 157 patients with severe AS according to\nthe guidelines were enrolled in the trial: 79 were randomized to conservative\ntreatment and 78 were randomized to early surgery. To prove truly asymp\ntomatic status, exercise testing was performed in all candidates to evaluate\nsymptom status according to a standardized protocol using treadmill or semi-\nsupine ergo-bicycle. To consider exercise testing negative, which was manda\ntory for inclusion, all candidates needed to reach a projected submaximal\nheart rate. Positive exercise test included onset of AS-related symptoms,\nfall in systolic blood pressure (≥20 mmHg from the baseline values), or\nElectrocardiography (ECG) or stress echocardiography signs of myocardial\nischaemia.9\nFollow-up and trial endpoints\nPatients were followed according to the protocol every 6 months for the\nfirst year and then yearly with the in-person visits at the participating study\ncentre. As the trial was affected by the Covid-19 pandemic, contact with\npatients who could not come in person was made by phone. For any event\nthat was registered, the medical records were asked for and reviewed.\nAdverse clinical events were adjudicated by the DSMB per protocol defini\ntions.7,8 Data and safety monitoring board members were not blinded to\nthe treatment allocation during events review. They adjudicated the events\nby consensus.\nTable 1 Eligibility inclusion/exclusion criteria\nInclusion criteria\n• Men and women of any ethnic origin aged ≥18 years\n• Written informed consent\n• Vmax across the aortic valve > 4 m/s or P mean ≥ 40 mmHg and AVA ≤\n1 cm2 or AVAi ≤ 0.6 cm2/m2 at rest\n• Without reported symptoms\n• Society of Thoracic Surgeons score < 8%\nExclusion criteria\nParticipation in another clinical trial within 30 days prior to\nrandomization\n• Pregnant or nursing women\n• Mental condition rendering the patient unable to understand the\nnature, scope, and possible consequences of the study or to follow the\nprotocol\n• Positive stress-test defined as follows:\n(a)\nAnginal chest pain during testing\n(b)\nSyncope or dizziness during testing\n(c)\nDecrease in systolic blood pressure during exercise ≥ 20 mmHg\n(d)\nMalignant arrhythmia during exercise testing (VT or VF)\n• Left ventricular ejection fraction < 50% at rest\n• Very severe AS defined as Vmax > 5.5 m/s at rest\n• Significant disease of other valves: mitral stenosis with Pmean > 5 mg, or\nany significant regurgitation ≥ 3+\n• Recent previous myocardial infarction (<1 year)\n• Need for additional aortic root replacement (i.e. Bentall) or ascending\naorta surgery in asymptomatic patients undergoing AVR\n• Previous coronary bypass surgery\n• Previous any heart valve surgery\n• Impaired renal function, i.e. creatinine > 200 μmol/L or glomerular\nfiltration rate < 30 mL/min/1.73 m2\n• Significant pulmonary hypertension at rest (systolic pulmonary artery\npressure > 50 mmHg)\n• Uncontrolled hypertension at rest (systolic blood pressure >\n180 mmHg and diastolic blood pressure > 100 mmHg)\n• Significant comorbidity with reduced life expectancy (<3 years)\n• Uncontrolled diabetes mellitus (HbA1c > 9%)\n• Significant chronic obstructive pulmonary disease (FEV1 < 70% of\npredicted value)"
        }
      ],
      "counterevidence": [],
      "justification": "The registry lists masking as NONE, and the comparison is surgical valve replacement versus watchful waiting, which cannot be hidden from participants.",
      "question_id": "sq:deviations:participants-aware",
      "unknowns": []
    },
    {
      "answer": "yes",
      "bases": [
        {
          "evidence": "sha256:975aac3202107531915fbf535a75cc136f9b747b9d65d2e916ae80c99a59576e",
          "kind": "direct_support",
          "source": "#### Masking info\n- Masking: NONE"
        }
      ],
      "counterevidence": [],
      "justification": "Open-label surgery versus conservative care means clinicians and surgeons delivering care knew the assignment. Allocation was concealed until assignment, but blinding afterwards was impossible.",
      "question_id": "sq:deviations:personnel-aware",
      "unknowns": []
    },
    {
      "answer": "probably_no",
      "bases": [
        {
          "evidence": "sha256:c8e09588406362068c63d28ee7744e10fdea103745ca129638782c1afcba65ff",
          "kind": "direct_support",
          "source": "3-year follow-up information available for all patients. For binary outcomes,\nwe used a generalized linear model assuming a binomial distribution with a\nlog link function to report risk ratios and 95% CI. We conducted subgroup\nanalyses accompanied by a P for interaction to assess the consistency of the\ntreatment effect on the primary outcome according to the following pre-\ndefined variables: age (<65 vs. ≥65), sex, baseline ejection fraction (<60%\nvs. ≥60%), and country of trial site. P-values and 95% CI for secondary out\ncomes and secondary analyses of the primary outcome were not adjusted\nfor multiple testing and are considered exploratory. For the post hoc ana\nlyses of echocardiography readouts of valve severity and LVEF in patients\nin the conservative group, we calculated the mean change from baseline\nto 12-month follow-up for all patients in the conservative group with avail\nable data and the mean change from baseline to final follow-up for all pa\ntients in the conservative group that underwent surgery and had available\ndata. We conducted paired t-tests to derive P-values and 95% CI for the\nmean changes from baseline.11 This analysis was repeated for patients in\nthe conservative group that underwent AVR. Analyses were performed\nusing Stata, version 18.0.\nResults\nPatients and follow-up\nMain patient characteristics at baseline are summarized in Table 2. The\naverage age of enrolled patients was 67 years, 57% were men, the ma\njority of patients had a degenerative aetiology of AS (84.7%), and the\nmedian estimated operative mortality according to the Society of\nThoracic Surgeons predicted risk of mortality score was 1.7%. No sig\nnificant heterogeneity between both groups was noted. All patients\nwere included in the analysis. Median follow-up for all patients was\n63 months [interquartile range (IQR) 48-75). Median follow-up in sur\nvivors was 68 months (IQR 58-79). One patient, who was randomized\nto early surgery, has been lost to follow-up, and this patient was cen\nsored when the last follow-up information was available and included\nin the intention-to-treat analysis (Figure 1).\nAortic valve replacement procedures\nIn the early surgery group, AVR was performed in 72 of the 78 patients\n(92.3%). Among the six patients that did not undergo AVR per random\nization, one patient, as above mentioned, was lost to follow-up, and one\ndied prior to valve surgery. Four patients were available for the extended\nfollow-up. Among them, one patient died unoperated after 2113 days;\ntwo became symptomatic and underwent intervention after 691 and\n791 days, respectively; and one remained asymptomatic and AVR free\nthroughout the entire follow-up (Figure 1). The median time from ran\ndomization to AVR in the early surgery group was 55 days (IQR 36-79).\nThirty-five out of the 79 patients (44.3%) in the conservative treatment\ngroup had surgery during follow-up. Median time from randomization\nto surgery in the conservative treatment group was 476 days (IQR\n226-1098). At the time of AVR, the mean age of patients in the control\np = 0.002\nHR = 0.42 (95% CI 0.24 to 0.73)\n0%\n10%\n20%\n30%\n40%\n50%\n60%\nPrimary composite endpoint\nincidence\n79\n61\n52\n29\n11\nControl\n78\n69\n67\n48\n13\nEarly surgery\nParticipants, n\n0\n20\n40\n60\n80\nTime (Months)\nEarly surgery\nConservative treatment\nFigure 2 Cumulative incidence of primary composite outcome (intention-to-treat population)\nTable 3 Indications for aortic valve replacement in the\nconservative treatment group\nSymptom onset (including increased fatigue)\n18 (51.4%)\nAS progression\n6 (17.1%)\nDecrease in LVEF\n3 (8.6%)\nCombination of factors\n8 (22.9%)\nAS, aortic stenosis; LVEF, left ventricular ejection fraction.\nAortic valve replacement vs. conservative treatment 4531\nDownloaded from academic.oup.com/eurheartj/article/45/42/4526/7742145 by guest on 03 October 2026\n\n[Extracted table 1]\n|Symptom onset (including increased fatigue) 1|8 (51.4%)|\n|---|---|\n|AS progression 6 (17.1%)||\n|Decrease in LVEF|3 (8.6%)|\n|Combination of factors 8 (22.9%)||"
        },
        {
          "evidence": "sha256:22d01d9384e1a67794311f3f65876073345f53cfb724c4ed6cbfcbebac3d2f92",
          "kind": "context",
          "source": "Amendmen to statystical analysis\n\n\n1. Patients randomized to AVR surgery who received delayed surgery\n(more than 8 weeks after randomization) due to COVID -19 public\nhealth emergency will be documented and this delay will be defined\nas an anticipated minor deviation from the clinical protocol\n2. Appropriate statistical procedures will be performed and results\nwill be published according to the FDA guidance \"Conduct of Clinical\nTrials of Medical Products During the COVID-19 Public Health\nEmergency Guidance for Industry, investigators, and Institutional\nReview Boards\""
        },
        {
          "evidence": "sha256:4b5761bf573cc28798af1ab59f4cf7cd5957111d8b9b535c112d3ae8f419205a",
          "kind": "context",
          "source": "Patients in the conservative treatment group were referred\nfor surgery in case of onset of AS-related symptoms, if the\nLVEF decreased to <50%, or if the peak aortic jet velocity\nincreased each year by >0.3 m/s on follow-up echocardiog-\nraphy, according to European Society of Cardiology guide-\nlines on valvular disease at the time the study was designed.11\nConservative treatment included the treatment of risk factors\nand comorbidities."
        },
        {
          "evidence": "sha256:05e667d2d41d385843fce8092c896af651d2f651bcfdc8a7fd1d2841801879af",
          "kind": "context",
          "source": "follow-up and lengthening AVR delays. Pre-defined physical visits were\nsubstituted by phone follow-up. Such surveillance within the watchful\nwaiting may hypothetically impact timely detection of symptoms conse\nquently leading to increased clinical risk, including sudden death.\nNevertheless, in the conservative group, none of the patients experi\nenced MACE or died while awaiting the scheduled surgery. It is of\nnote that in the small number of patients undergoing TAVR, delays ap\npeared shorter as compared with the surgical intervention."
        }
      ],
      "counterevidence": [
        {
          "basis_index": 3,
          "implication": "The authors note pandemic-related follow-up substitution by phone and lengthened AVR delays could have increased clinical risk. These arose from the pandemic, not the trial context, and no deaths occurred while awaiting scheduled surgery in the conservative group."
        }
      ],
      "justification": "Crossover from conservative care to surgery (35/79) was driven by protocol-defined indications (symptom onset, AS progression, LVEF decline), as Table 3 and the protocol show, so it is consistent with the protocol rather than trial-context driven. Surgical delays beyond 8 weeks arose from the COVID-19 public-health emergency and were documented as an anticipated minor deviation in the SAP amendment. Four early-surgery patients did not receive surgery as assigned, for reasons like infection or declining, which could occur outside a trial.",
      "question_id": "sq:deviations:context-deviations",
      "unknowns": [
        "Reasons for declining surgery are not described in detail."
      ]
    },
    {
      "answer": "yes",
      "bases": [
        {
          "evidence": "sha256:30fa222ec5523dcc0f12be9e8de34b50b47f1fd9395d04d630e7a97a8b274e71",
          "kind": "direct_support",
          "source": "Statistical analysis\nWe conducted all analyses according to the intention-to-treat principle,\nwhere all patients were included in the analysis as they were randomized.\nFor the analysis of the primary outcome, we built a Kaplan-Meier graph\nwith a log rank P-value to test for a difference between early surgery and\ncontrol intervention at a two-sided α value of 0.05 and used a Cox propor\ntional hazards model to derive hazard ratios (HRs) with 95% confidence in\ntervals (CIs) for treatment effect estimation.\nTime-to-event secondary outcomes were analysed using the same meth\nods applied for the analysis of the primary outcome. For MACE, all-cause\ndeath, HF hospitalization, and cardiovascular death, we repeated the ana\nlysis as described above restricted to a 3-year follow-up, with complete"
        },
        {
          "evidence": "sha256:c8e09588406362068c63d28ee7744e10fdea103745ca129638782c1afcba65ff",
          "kind": "direct_support",
          "source": "3-year follow-up information available for all patients. For binary outcomes,\nwe used a generalized linear model assuming a binomial distribution with a\nlog link function to report risk ratios and 95% CI. We conducted subgroup\nanalyses accompanied by a P for interaction to assess the consistency of the\ntreatment effect on the primary outcome according to the following pre-\ndefined variables: age (<65 vs. ≥65), sex, baseline ejection fraction (<60%\nvs. ≥60%), and country of trial site. P-values and 95% CI for secondary out\ncomes and secondary analyses of the primary outcome were not adjusted\nfor multiple testing and are considered exploratory. For the post hoc ana\nlyses of echocardiography readouts of valve severity and LVEF in patients\nin the conservative group, we calculated the mean change from baseline\nto 12-month follow-up for all patients in the conservative group with avail\nable data and the mean change from baseline to final follow-up for all pa\ntients in the conservative group that underwent surgery and had available\ndata. We conducted paired t-tests to derive P-values and 95% CI for the\nmean changes from baseline.11 This analysis was repeated for patients in\nthe conservative group that underwent AVR. Analyses were performed\nusing Stata, version 18.0.\nResults\nPatients and follow-up\nMain patient characteristics at baseline are summarized in Table 2. The\naverage age of enrolled patients was 67 years, 57% were men, the ma\njority of patients had a degenerative aetiology of AS (84.7%), and the\nmedian estimated operative mortality according to the Society of\nThoracic Surgeons predicted risk of mortality score was 1.7%. No sig\nnificant heterogeneity between both groups was noted. All patients\nwere included in the analysis. Median follow-up for all patients was\n63 months [interquartile range (IQR) 48-75). Median follow-up in sur\nvivors was 68 months (IQR 58-79). One patient, who was randomized\nto early surgery, has been lost to follow-up, and this patient was cen\nsored when the last follow-up information was available and included\nin the intention-to-treat analysis (Figure 1).\nAortic valve replacement procedures\nIn the early surgery group, AVR was performed in 72 of the 78 patients\n(92.3%). Among the six patients that did not undergo AVR per random\nization, one patient, as above mentioned, was lost to follow-up, and one\ndied prior to valve surgery. Four patients were available for the extended\nfollow-up. Among them, one patient died unoperated after 2113 days;\ntwo became symptomatic and underwent intervention after 691 and\n791 days, respectively; and one remained asymptomatic and AVR free\nthroughout the entire follow-up (Figure 1). The median time from ran\ndomization to AVR in the early surgery group was 55 days (IQR 36-79).\nThirty-five out of the 79 patients (44.3%) in the conservative treatment\ngroup had surgery during follow-up. Median time from randomization\nto surgery in the conservative treatment group was 476 days (IQR\n226-1098). At the time of AVR, the mean age of patients in the control\np = 0.002\nHR = 0.42 (95% CI 0.24 to 0.73)\n0%\n10%\n20%\n30%\n40%\n50%\n60%\nPrimary composite endpoint\nincidence\n79\n61\n52\n29\n11\nControl\n78\n69\n67\n48\n13\nEarly surgery\nParticipants, n\n0\n20\n40\n60\n80\nTime (Months)\nEarly surgery\nConservative treatment\nFigure 2 Cumulative incidence of primary composite outcome (intention-to-treat population)\nTable 3 Indications for aortic valve replacement in the\nconservative treatment group\nSymptom onset (including increased fatigue)\n18 (51.4%)\nAS progression\n6 (17.1%)\nDecrease in LVEF\n3 (8.6%)\nCombination of factors\n8 (22.9%)\nAS, aortic stenosis; LVEF, left ventricular ejection fraction.\nAortic valve replacement vs. conservative treatment 4531\nDownloaded from academic.oup.com/eurheartj/article/45/42/4526/7742145 by guest on 03 October 2026\n\n[Extracted table 1]\n|Symptom onset (including increased fatigue) 1|8 (51.4%)|\n|---|---|\n|AS progression 6 (17.1%)||\n|Decrease in LVEF|3 (8.6%)|\n|Combination of factors 8 (22.9%)||"
        }
      ],
      "counterevidence": [],
      "justification": "All analyses were intention-to-treat as randomized, and all 157 patients were included. One early-surgery patient lost to follow-up was censored and still analysed.",
      "question_id": "sq:deviations:appropriate-analysis",
      "unknowns": []
    }
  ],
  "inactive": [
    "sq:deviations:affected-outcome",
    "sq:deviations:balanced",
    "sq:deviations:substantial-impact"
  ],
  "decision": {
    "adjudication": null,
    "adopted": "low",
    "authority": "algorithm",
    "contract": "rob2-kit.domain.reasoned-adjudication.v1",
    "proposed": "low",
    "trace_authority": "proposed_algorithm"
  }
}

Full selected-answer evidence:
[
  {
    "basis": {
      "evidence": "sha256:975aac3202107531915fbf535a75cc136f9b747b9d65d2e916ae80c99a59576e",
      "kind": "direct_support",
      "source": "#### Masking info\n- Masking: NONE"
    },
    "ev": {
      "end": 4033,
      "end_line": 68,
      "handle": "eh_975aac3202107531",
      "identity": "sha256:975aac3202107531915fbf535a75cc136f9b747b9d65d2e916ae80c99a59576e",
      "kind": "narrative",
      "page": 1,
      "quote": "#### Masking info\n- Masking: NONE",
      "source_id": "source_b28064bc31d3335957e34134a4873694fc9f01af0ca3640ab719d51f1ae00099",
      "source_version": "sha256:d32e23eb2a1e9a1505bbcf5f930b2af72508c4887cea3775a63e30ab95ba16e0",
      "start": 4000,
      "start_line": 67,
      "trial_id": "banovic26-avatar-2024"
    },
    "src": {
      "declared_role": null,
      "id": "source_b28064bc31d3335957e34134a4873694fc9f01af0ca3640ab719d51f1ae00099",
      "label": "ClinicalTrials.gov NCT02436655",
      "logical_path": "registry/NCT02436655.json",
      "media_type": "application/json",
      "origin": "registry",
      "page_count": 1,
      "projection_hash": "sha256:d32e23eb2a1e9a1505bbcf5f930b2af72508c4887cea3775a63e30ab95ba16e0",
      "role": "registry",
      "sha256": "sha256:e7246ef60bb7dd9426caad8be13e304abb1adc1bef3dfa29f468070fd6935b35",
      "trial_id": "banovic26-avatar-2024"
    }
  },
  {
    "basis": {
      "evidence": "sha256:3ce4199af9d487f3e5ca3f79d7aa594f229272e2c0d58e52514ccdb17a749a68",
      "kind": "context",
      "source": "Introduction\nAortic stenosis (AS) is the single most common valvular heart disease re\nquiring intervention in developed countries and is projected to double by\n2050 in both the USA and Europe.1 The approach to symptomatic pa\ntients with severe AS is straightforward. Surgical aortic valve replacement\n(AVR) and, more recently, transcatheter aortic valve implantation (TAVI)\nprocedures are Class I recommendation to relieve symptoms and im\nprove survival in symptomatic patients with severe AS.2,3\nConversely, the question of when and how to treat truly asymptom\natic patients with severe AS and normal left ventricular (LV) systolic\nfunction is still subject to debate and ongoing research. To date, two\nrandomized trials have demonstrated benefit of early AVR in compari\nson with conservative strategy in asymptomatic patients with severe\nand very severe AS patients.4,5 In addition, there are several ongoing\nrandomized trials investigating the role of early TAVI and/or early sur\ngical AVR in asymptomatic AS.\nThe Aortic Valve Replacement Versus Conservative Treatment in\nAsymptomatic Severe Aortic Stenosis (AVATAR) trial is an investigator-\ninitiated, prospective, multinational, randomized, controlled, parallel-group,\nevent-driven trial that compared the safety and efficacy of early surgery in\nthe treatment of truly asymptomatic patients with severe AS and LV ejec\ntion fraction (LVEF) ≥ 50% vs. conservative treatment with watchful wait\ning strategy and AVR only after symptom onset, or other guidelines\ndirected Class I or II indications for AVR.3,6 In the primary analysis of the\nAVATAR trial, asymptomatic AS patients randomized to early surgery\nhad a lower incidence of the composite primary outcome comprising all-\ncause death, acute myocardial infarction, stroke, or unplanned hospitaliza\ntion for heart failure (HF), compared with patients who were randomized\nto conservative treatment.5 We now report the results of the AVATAR\ntrial after extended follow-up at 5 years.\nMethods\nStudy design and oversight\nThe AVATAR trial (ClinicalTrials.gov identifier NCT02436655) protocol\nand protocol update were designed by the first co-authors and steering\ncommittee co-chairmen and was approved by the steering committee of\nthe AVATAR trial.7,8 The clinical and outcomes data were collected by per\nsonnel at the participating sites and were sent directly to the data coordinat\ning centre at the University Clinical Center of Serbia. No extramural funding\nwas used to support this work. The authors, members of the steering com\nmittee, and investigators are solely responsible for the design and conduct of\nthis trial, all analyses, drafting and editing of the article, and its final contents.\nIndependent statistician conducted the long-term data analyses.\nThe trial was conducted in accordance with the Declaration of Helsinki. All\nparticipants provided written informed consent. An independent data and\nsafety monitoring board (DSMB) adjudicated all serious adverse events and\noversaw the safety of the trial. The article was prepared by the first author\nand steering committee co-chairmen and was reviewed and edited by mem\nbers of the steering committee and authors. All authors reviewed the article,\napproved its submission for publication, and vouched for the accuracy and\ncompleteness of the data and for the fidelity of the trial to the protocol.\nStudy population\nThe study inclusion and exclusion criteria are shown in Table 1; trial flowchart\nis shown in Figure 1. Briefly, a total of 157 patients with severe AS according to\nthe guidelines were enrolled in the trial: 79 were randomized to conservative\ntreatment and 78 were randomized to early surgery. To prove truly asymp\ntomatic status, exercise testing was performed in all candidates to evaluate\nsymptom status according to a standardized protocol using treadmill or semi-\nsupine ergo-bicycle. To consider exercise testing negative, which was manda\ntory for inclusion, all candidates needed to reach a projected submaximal\nheart rate. Positive exercise test included onset of AS-related symptoms,\nfall in systolic blood pressure (≥20 mmHg from the baseline values), or\nElectrocardiography (ECG) or stress echocardiography signs of myocardial\nischaemia.9\nFollow-up and trial endpoints\nPatients were followed according to the protocol every 6 months for the\nfirst year and then yearly with the in-person visits at the participating study\ncentre. As the trial was affected by the Covid-19 pandemic, contact with\npatients who could not come in person was made by phone. For any event\nthat was registered, the medical records were asked for and reviewed.\nAdverse clinical events were adjudicated by the DSMB per protocol defini\ntions.7,8 Data and safety monitoring board members were not blinded to\nthe treatment allocation during events review. They adjudicated the events\nby consensus.\nTable 1 Eligibility inclusion/exclusion criteria\nInclusion criteria\n• Men and women of any ethnic origin aged ≥18 years\n• Written informed consent\n• Vmax across the aortic valve > 4 m/s or P mean ≥ 40 mmHg and AVA ≤\n1 cm2 or AVAi ≤ 0.6 cm2/m2 at rest\n• Without reported symptoms\n• Society of Thoracic Surgeons score < 8%\nExclusion criteria\nParticipation in another clinical trial within 30 days prior to\nrandomization\n• Pregnant or nursing women\n• Mental condition rendering the patient unable to understand the\nnature, scope, and possible consequences of the study or to follow the\nprotocol\n• Positive stress-test defined as follows:\n(a)\nAnginal chest pain during testing\n(b)\nSyncope or dizziness during testing\n(c)\nDecrease in systolic blood pressure during exercise ≥ 20 mmHg\n(d)\nMalignant arrhythmia during exercise testing (VT or VF)\n• Left ventricular ejection fraction < 50% at rest\n• Very severe AS defined as Vmax > 5.5 m/s at rest\n• Significant disease of other valves: mitral stenosis with Pmean > 5 mg, or\nany significant regurgitation ≥ 3+\n• Recent previous myocardial infarction (<1 year)\n• Need for additional aortic root replacement (i.e. Bentall) or ascending\naorta surgery in asymptomatic patients undergoing AVR\n• Previous coronary bypass surgery\n• Previous any heart valve surgery\n• Impaired renal function, i.e. creatinine > 200 μmol/L or glomerular\nfiltration rate < 30 mL/min/1.73 m2\n• Significant pulmonary hypertension at rest (systolic pulmonary artery\npressure > 50 mmHg)\n• Uncontrolled hypertension at rest (systolic blood pressure >\n180 mmHg and diastolic blood pressure > 100 mmHg)\n• Significant comorbidity with reduced life expectancy (<3 years)\n• Uncontrolled diabetes mellitus (HbA1c > 9%)\n• Significant chronic obstructive pulmonary disease (FEV1 < 70% of\npredicted value)"
    },
    "ev": {
      "end": 6665,
      "end_line": 116,
      "handle": "eh_3ce4199af9d487f3",
      "identity": "sha256:3ce4199af9d487f3e5ca3f79d7aa594f229272e2c0d58e52514ccdb17a749a68",
      "kind": "narrative",
      "page": 3,
      "quote": "Introduction\nAortic stenosis (AS) is the single most common valvular heart disease re\nquiring intervention in developed countries and is projected to double by\n2050 in both the USA and Europe.1 The approach to symptomatic pa\ntients with severe AS is straightforward. Surgical aortic valve replacement\n(AVR) and, more recently, transcatheter aortic valve implantation (TAVI)\nprocedures are Class I recommendation to relieve symptoms and im\nprove survival in symptomatic patients with severe AS.2,3\nConversely, the question of when and how to treat truly asymptom\natic patients with severe AS and normal left ventricular (LV) systolic\nfunction is still subject to debate and ongoing research. To date, two\nrandomized trials have demonstrated benefit of early AVR in compari\nson with conservative strategy in asymptomatic patients with severe\nand very severe AS patients.4,5 In addition, there are several ongoing\nrandomized trials investigating the role of early TAVI and/or early sur\ngical AVR in asymptomatic AS.\nThe Aortic Valve Replacement Versus Conservative Treatment in\nAsymptomatic Severe Aortic Stenosis (AVATAR) trial is an investigator-\ninitiated, prospective, multinational, randomized, controlled, parallel-group,\nevent-driven trial that compared the safety and efficacy of early surgery in\nthe treatment of truly asymptomatic patients with severe AS and LV ejec\ntion fraction (LVEF) ≥ 50% vs. conservative treatment with watchful wait\ning strategy and AVR only after symptom onset, or other guidelines\ndirected Class I or II indications for AVR.3,6 In the primary analysis of the\nAVATAR trial, asymptomatic AS patients randomized to early surgery\nhad a lower incidence of the composite primary outcome comprising all-\ncause death, acute myocardial infarction, stroke, or unplanned hospitaliza\ntion for heart failure (HF), compared with patients who were randomized\nto conservative treatment.5 We now report the results of the AVATAR\ntrial after extended follow-up at 5 years.\nMethods\nStudy design and oversight\nThe AVATAR trial (ClinicalTrials.gov identifier NCT02436655) protocol\nand protocol update were designed by the first co-authors and steering\ncommittee co-chairmen and was approved by the steering committee of\nthe AVATAR trial.7,8 The clinical and outcomes data were collected by per\nsonnel at the participating sites and were sent directly to the data coordinat\ning centre at the University Clinical Center of Serbia. No extramural funding\nwas used to support this work. The authors, members of the steering com\nmittee, and investigators are solely responsible for the design and conduct of\nthis trial, all analyses, drafting and editing of the article, and its final contents.\nIndependent statistician conducted the long-term data analyses.\nThe trial was conducted in accordance with the Declaration of Helsinki. All\nparticipants provided written informed consent. An independent data and\nsafety monitoring board (DSMB) adjudicated all serious adverse events and\noversaw the safety of the trial. The article was prepared by the first author\nand steering committee co-chairmen and was reviewed and edited by mem\nbers of the steering committee and authors. All authors reviewed the article,\napproved its submission for publication, and vouched for the accuracy and\ncompleteness of the data and for the fidelity of the trial to the protocol.\nStudy population\nThe study inclusion and exclusion criteria are shown in Table 1; trial flowchart\nis shown in Figure 1. Briefly, a total of 157 patients with severe AS according to\nthe guidelines were enrolled in the trial: 79 were randomized to conservative\ntreatment and 78 were randomized to early surgery. To prove truly asymp\ntomatic status, exercise testing was performed in all candidates to evaluate\nsymptom status according to a standardized protocol using treadmill or semi-\nsupine ergo-bicycle. To consider exercise testing negative, which was manda\ntory for inclusion, all candidates needed to reach a projected submaximal\nheart rate. Positive exercise test included onset of AS-related symptoms,\nfall in systolic blood pressure (≥20 mmHg from the baseline values), or\nElectrocardiography (ECG) or stress echocardiography signs of myocardial\nischaemia.9\nFollow-up and trial endpoints\nPatients were followed according to the protocol every 6 months for the\nfirst year and then yearly with the in-person visits at the participating study\ncentre. As the trial was affected by the Covid-19 pandemic, contact with\npatients who could not come in person was made by phone. For any event\nthat was registered, the medical records were asked for and reviewed.\nAdverse clinical events were adjudicated by the DSMB per protocol defini\ntions.7,8 Data and safety monitoring board members were not blinded to\nthe treatment allocation during events review. They adjudicated the events\nby consensus.\nTable 1 Eligibility inclusion/exclusion criteria\nInclusion criteria\n• Men and women of any ethnic origin aged ≥18 years\n• Written informed consent\n• Vmax across the aortic valve > 4 m/s or P mean ≥ 40 mmHg and AVA ≤\n1 cm2 or AVAi ≤ 0.6 cm2/m2 at rest\n• Without reported symptoms\n• Society of Thoracic Surgeons score < 8%\nExclusion criteria\nParticipation in another clinical trial within 30 days prior to\nrandomization\n• Pregnant or nursing women\n• Mental condition rendering the patient unable to understand the\nnature, scope, and possible consequences of the study or to follow the\nprotocol\n• Positive stress-test defined as follows:\n(a)\nAnginal chest pain during testing\n(b)\nSyncope or dizziness during testing\n(c)\nDecrease in systolic blood pressure during exercise ≥ 20 mmHg\n(d)\nMalignant arrhythmia during exercise testing (VT or VF)\n• Left ventricular ejection fraction < 50% at rest\n• Very severe AS defined as Vmax > 5.5 m/s at rest\n• Significant disease of other valves: mitral stenosis with Pmean > 5 mg, or\nany significant regurgitation ≥ 3+\n• Recent previous myocardial infarction (<1 year)\n• Need for additional aortic root replacement (i.e. Bentall) or ascending\naorta surgery in asymptomatic patients undergoing AVR\n• Previous coronary bypass surgery\n• Previous any heart valve surgery\n• Impaired renal function, i.e. creatinine > 200 μmol/L or glomerular\nfiltration rate < 30 mL/min/1.73 m2\n• Significant pulmonary hypertension at rest (systolic pulmonary artery\npressure > 50 mmHg)\n• Uncontrolled hypertension at rest (systolic blood pressure >\n180 mmHg and diastolic blood pressure > 100 mmHg)\n• Significant comorbidity with reduced life expectancy (<3 years)\n• Uncontrolled diabetes mellitus (HbA1c > 9%)\n• Significant chronic obstructive pulmonary disease (FEV1 < 70% of\npredicted value)",
      "source_id": "source_7f7b055eb93e03bcd72c8fe32984a531050e324a0b58555dbc9701c8b3e2d5e7",
      "source_version": "sha256:a890f771fd05ebda4edada403fa59475add7dfa13409e53bbca7f38407265ae3",
      "start": 0,
      "start_line": 1,
      "trial_id": "banovic26-avatar-2024"
    },
    "src": {
      "declared_role": "main_article",
      "id": "source_7f7b055eb93e03bcd72c8fe32984a531050e324a0b58555dbc9701c8b3e2d5e7",
      "label": "ehae585.pdf",
      "logical_path": "ehae585.pdf",
      "media_type": "application/pdf",
      "origin": "local_dossier",
      "page_count": 10,
      "projection_hash": "sha256:a890f771fd05ebda4edada403fa59475add7dfa13409e53bbca7f38407265ae3",
      "role": "main_article",
      "sha256": "sha256:844778e139c06d130531978d4d574f575a3a2bc078d2cc0fb407746abeff7bf5",
      "trial_id": "banovic26-avatar-2024"
    }
  }
]

## Domain 3

Were data for this outcome available for all, or nearly all, participants randomized?

Displayed source quotation(s): All patients were included in the analysis. … One patient … lost to follow-up … censored…

Full recorded selected-answer justification: All 157 randomized patients were analysed and median follow-up was 63 months. Only one patient (early-surgery arm) was lost to follow-up and censored at last contact, so 1/157 (0.6%) has incomplete outcome data. This is far fewer than the observed deaths, so any outcome for that patient could not materially change the HR of 0.44.

Unknowns: []

Complete answers, inactive branches and decision:
{
  "answers": [
    {
      "answer": "yes",
      "bases": [
        {
          "evidence": "sha256:e66d374e838e8c6ddbc115270872899bc6e58f850549df46d3e7ea953537067c",
          "kind": "direct_support",
          "source": "nificant heterogeneity between both groups was noted. All patients\nwere included in the analysis. Median follow-up for all patients was\n63 months [interquartile range (IQR) 48-75). Median follow-up in sur\nvivors was 68 months (IQR 58-79). One patient, who was randomized\nto early surgery, has been lost to follow-up, and this patient was cen\nsored when the last follow-up information was available and included\nin the intention-to-treat analysis (Figure 1)."
        }
      ],
      "counterevidence": [],
      "justification": "All 157 randomized patients were analysed and median follow-up was 63 months. Only one patient (early-surgery arm) was lost to follow-up and censored at last contact, so 1/157 (0.6%) has incomplete outcome data. This is far fewer than the observed deaths, so any outcome for that patient could not materially change the HR of 0.44.",
      "question_id": "sq:missing:data-available",
      "unknowns": []
    }
  ],
  "inactive": [
    "sq:missing:evidence-unbiased",
    "sq:missing:true-value-dependent",
    "sq:missing:likely-dependent"
  ],
  "decision": {
    "adjudication": null,
    "adopted": "low",
    "authority": "algorithm",
    "contract": "rob2-kit.domain.reasoned-adjudication.v1",
    "proposed": "low",
    "trace_authority": "proposed_algorithm"
  }
}

Full selected-answer evidence:
[
  {
    "basis": {
      "evidence": "sha256:e66d374e838e8c6ddbc115270872899bc6e58f850549df46d3e7ea953537067c",
      "kind": "direct_support",
      "source": "nificant heterogeneity between both groups was noted. All patients\nwere included in the analysis. Median follow-up for all patients was\n63 months [interquartile range (IQR) 48-75). Median follow-up in sur\nvivors was 68 months (IQR 58-79). One patient, who was randomized\nto early surgery, has been lost to follow-up, and this patient was cen\nsored when the last follow-up information was available and included\nin the intention-to-treat analysis (Figure 1)."
    },
    "ev": {
      "end": 2113,
      "end_line": 32,
      "handle": "eh_e66d374e838e8c6d",
      "identity": "sha256:e66d374e838e8c6ddbc115270872899bc6e58f850549df46d3e7ea953537067c",
      "kind": "narrative",
      "page": 6,
      "quote": "nificant heterogeneity between both groups was noted. All patients\nwere included in the analysis. Median follow-up for all patients was\n63 months [interquartile range (IQR) 48-75). Median follow-up in sur\nvivors was 68 months (IQR 58-79). One patient, who was randomized\nto early surgery, has been lost to follow-up, and this patient was cen\nsored when the last follow-up information was available and included\nin the intention-to-treat analysis (Figure 1).",
      "source_id": "source_7f7b055eb93e03bcd72c8fe32984a531050e324a0b58555dbc9701c8b3e2d5e7",
      "source_version": "sha256:a890f771fd05ebda4edada403fa59475add7dfa13409e53bbca7f38407265ae3",
      "start": 1656,
      "start_line": 26,
      "trial_id": "banovic26-avatar-2024"
    },
    "src": {
      "declared_role": "main_article",
      "id": "source_7f7b055eb93e03bcd72c8fe32984a531050e324a0b58555dbc9701c8b3e2d5e7",
      "label": "ehae585.pdf",
      "logical_path": "ehae585.pdf",
      "media_type": "application/pdf",
      "origin": "local_dossier",
      "page_count": 10,
      "projection_hash": "sha256:a890f771fd05ebda4edada403fa59475add7dfa13409e53bbca7f38407265ae3",
      "role": "main_article",
      "sha256": "sha256:844778e139c06d130531978d4d574f575a3a2bc078d2cc0fb407746abeff7bf5",
      "trial_id": "banovic26-avatar-2024"
    }
  }
]

## Domain 4

If N/PN/NI to 4.1 and 4.2: Were outcome assessors aware of the intervention received by study participants?

Displayed source quotation(s): Data and safety monitoring board members were not blinded to the treatment allocation during events review.

Full recorded selected-answer justification: The trial was open-label (registry masking: none), and the report states that DSMB members were not blinded to allocation when reviewing events. Site investigators recording deaths were also aware of the allocation.

Unknowns: []

Complete answers, inactive branches and decision:
{
  "answers": [
    {
      "answer": "probably_no",
      "bases": [
        {
          "evidence": "sha256:3ce4199af9d487f3e5ca3f79d7aa594f229272e2c0d58e52514ccdb17a749a68",
          "kind": "direct_support",
          "source": "Introduction\nAortic stenosis (AS) is the single most common valvular heart disease re\nquiring intervention in developed countries and is projected to double by\n2050 in both the USA and Europe.1 The approach to symptomatic pa\ntients with severe AS is straightforward. Surgical aortic valve replacement\n(AVR) and, more recently, transcatheter aortic valve implantation (TAVI)\nprocedures are Class I recommendation to relieve symptoms and im\nprove survival in symptomatic patients with severe AS.2,3\nConversely, the question of when and how to treat truly asymptom\natic patients with severe AS and normal left ventricular (LV) systolic\nfunction is still subject to debate and ongoing research. To date, two\nrandomized trials have demonstrated benefit of early AVR in compari\nson with conservative strategy in asymptomatic patients with severe\nand very severe AS patients.4,5 In addition, there are several ongoing\nrandomized trials investigating the role of early TAVI and/or early sur\ngical AVR in asymptomatic AS.\nThe Aortic Valve Replacement Versus Conservative Treatment in\nAsymptomatic Severe Aortic Stenosis (AVATAR) trial is an investigator-\ninitiated, prospective, multinational, randomized, controlled, parallel-group,\nevent-driven trial that compared the safety and efficacy of early surgery in\nthe treatment of truly asymptomatic patients with severe AS and LV ejec\ntion fraction (LVEF) ≥ 50% vs. conservative treatment with watchful wait\ning strategy and AVR only after symptom onset, or other guidelines\ndirected Class I or II indications for AVR.3,6 In the primary analysis of the\nAVATAR trial, asymptomatic AS patients randomized to early surgery\nhad a lower incidence of the composite primary outcome comprising all-\ncause death, acute myocardial infarction, stroke, or unplanned hospitaliza\ntion for heart failure (HF), compared with patients who were randomized\nto conservative treatment.5 We now report the results of the AVATAR\ntrial after extended follow-up at 5 years.\nMethods\nStudy design and oversight\nThe AVATAR trial (ClinicalTrials.gov identifier NCT02436655) protocol\nand protocol update were designed by the first co-authors and steering\ncommittee co-chairmen and was approved by the steering committee of\nthe AVATAR trial.7,8 The clinical and outcomes data were collected by per\nsonnel at the participating sites and were sent directly to the data coordinat\ning centre at the University Clinical Center of Serbia. No extramural funding\nwas used to support this work. The authors, members of the steering com\nmittee, and investigators are solely responsible for the design and conduct of\nthis trial, all analyses, drafting and editing of the article, and its final contents.\nIndependent statistician conducted the long-term data analyses.\nThe trial was conducted in accordance with the Declaration of Helsinki. All\nparticipants provided written informed consent. An independent data and\nsafety monitoring board (DSMB) adjudicated all serious adverse events and\noversaw the safety of the trial. The article was prepared by the first author\nand steering committee co-chairmen and was reviewed and edited by mem\nbers of the steering committee and authors. All authors reviewed the article,\napproved its submission for publication, and vouched for the accuracy and\ncompleteness of the data and for the fidelity of the trial to the protocol.\nStudy population\nThe study inclusion and exclusion criteria are shown in Table 1; trial flowchart\nis shown in Figure 1. Briefly, a total of 157 patients with severe AS according to\nthe guidelines were enrolled in the trial: 79 were randomized to conservative\ntreatment and 78 were randomized to early surgery. To prove truly asymp\ntomatic status, exercise testing was performed in all candidates to evaluate\nsymptom status according to a standardized protocol using treadmill or semi-\nsupine ergo-bicycle. To consider exercise testing negative, which was manda\ntory for inclusion, all candidates needed to reach a projected submaximal\nheart rate. Positive exercise test included onset of AS-related symptoms,\nfall in systolic blood pressure (≥20 mmHg from the baseline values), or\nElectrocardiography (ECG) or stress echocardiography signs of myocardial\nischaemia.9\nFollow-up and trial endpoints\nPatients were followed according to the protocol every 6 months for the\nfirst year and then yearly with the in-person visits at the participating study\ncentre. As the trial was affected by the Covid-19 pandemic, contact with\npatients who could not come in person was made by phone. For any event\nthat was registered, the medical records were asked for and reviewed.\nAdverse clinical events were adjudicated by the DSMB per protocol defini\ntions.7,8 Data and safety monitoring board members were not blinded to\nthe treatment allocation during events review. They adjudicated the events\nby consensus.\nTable 1 Eligibility inclusion/exclusion criteria\nInclusion criteria\n• Men and women of any ethnic origin aged ≥18 years\n• Written informed consent\n• Vmax across the aortic valve > 4 m/s or P mean ≥ 40 mmHg and AVA ≤\n1 cm2 or AVAi ≤ 0.6 cm2/m2 at rest\n• Without reported symptoms\n• Society of Thoracic Surgeons score < 8%\nExclusion criteria\nParticipation in another clinical trial within 30 days prior to\nrandomization\n• Pregnant or nursing women\n• Mental condition rendering the patient unable to understand the\nnature, scope, and possible consequences of the study or to follow the\nprotocol\n• Positive stress-test defined as follows:\n(a)\nAnginal chest pain during testing\n(b)\nSyncope or dizziness during testing\n(c)\nDecrease in systolic blood pressure during exercise ≥ 20 mmHg\n(d)\nMalignant arrhythmia during exercise testing (VT or VF)\n• Left ventricular ejection fraction < 50% at rest\n• Very severe AS defined as Vmax > 5.5 m/s at rest\n• Significant disease of other valves: mitral stenosis with Pmean > 5 mg, or\nany significant regurgitation ≥ 3+\n• Recent previous myocardial infarction (<1 year)\n• Need for additional aortic root replacement (i.e. Bentall) or ascending\naorta surgery in asymptomatic patients undergoing AVR\n• Previous coronary bypass surgery\n• Previous any heart valve surgery\n• Impaired renal function, i.e. creatinine > 200 μmol/L or glomerular\nfiltration rate < 30 mL/min/1.73 m2\n• Significant pulmonary hypertension at rest (systolic pulmonary artery\npressure > 50 mmHg)\n• Uncontrolled hypertension at rest (systolic blood pressure >\n180 mmHg and diastolic blood pressure > 100 mmHg)\n• Significant comorbidity with reduced life expectancy (<3 years)\n• Uncontrolled diabetes mellitus (HbA1c > 9%)\n• Significant chronic obstructive pulmonary disease (FEV1 < 70% of\npredicted value)"
        }
      ],
      "counterevidence": [],
      "justification": "All-cause death is a pre-specified, objective event ascertained through scheduled follow-up (6-monthly in year 1, then yearly), phone contact when in-person visits were not possible, and review of medical records for any registered event. Nothing suggests an insensitive method or an instrument with poor validity.",
      "question_id": "sq:measurement:method-inappropriate",
      "unknowns": []
    },
    {
      "answer": "probably_no",
      "bases": [
        {
          "evidence": "sha256:3ce4199af9d487f3e5ca3f79d7aa594f229272e2c0d58e52514ccdb17a749a68",
          "kind": "direct_support",
          "source": "Introduction\nAortic stenosis (AS) is the single most common valvular heart disease re\nquiring intervention in developed countries and is projected to double by\n2050 in both the USA and Europe.1 The approach to symptomatic pa\ntients with severe AS is straightforward. Surgical aortic valve replacement\n(AVR) and, more recently, transcatheter aortic valve implantation (TAVI)\nprocedures are Class I recommendation to relieve symptoms and im\nprove survival in symptomatic patients with severe AS.2,3\nConversely, the question of when and how to treat truly asymptom\natic patients with severe AS and normal left ventricular (LV) systolic\nfunction is still subject to debate and ongoing research. To date, two\nrandomized trials have demonstrated benefit of early AVR in compari\nson with conservative strategy in asymptomatic patients with severe\nand very severe AS patients.4,5 In addition, there are several ongoing\nrandomized trials investigating the role of early TAVI and/or early sur\ngical AVR in asymptomatic AS.\nThe Aortic Valve Replacement Versus Conservative Treatment in\nAsymptomatic Severe Aortic Stenosis (AVATAR) trial is an investigator-\ninitiated, prospective, multinational, randomized, controlled, parallel-group,\nevent-driven trial that compared the safety and efficacy of early surgery in\nthe treatment of truly asymptomatic patients with severe AS and LV ejec\ntion fraction (LVEF) ≥ 50% vs. conservative treatment with watchful wait\ning strategy and AVR only after symptom onset, or other guidelines\ndirected Class I or II indications for AVR.3,6 In the primary analysis of the\nAVATAR trial, asymptomatic AS patients randomized to early surgery\nhad a lower incidence of the composite primary outcome comprising all-\ncause death, acute myocardial infarction, stroke, or unplanned hospitaliza\ntion for heart failure (HF), compared with patients who were randomized\nto conservative treatment.5 We now report the results of the AVATAR\ntrial after extended follow-up at 5 years.\nMethods\nStudy design and oversight\nThe AVATAR trial (ClinicalTrials.gov identifier NCT02436655) protocol\nand protocol update were designed by the first co-authors and steering\ncommittee co-chairmen and was approved by the steering committee of\nthe AVATAR trial.7,8 The clinical and outcomes data were collected by per\nsonnel at the participating sites and were sent directly to the data coordinat\ning centre at the University Clinical Center of Serbia. No extramural funding\nwas used to support this work. The authors, members of the steering com\nmittee, and investigators are solely responsible for the design and conduct of\nthis trial, all analyses, drafting and editing of the article, and its final contents.\nIndependent statistician conducted the long-term data analyses.\nThe trial was conducted in accordance with the Declaration of Helsinki. All\nparticipants provided written informed consent. An independent data and\nsafety monitoring board (DSMB) adjudicated all serious adverse events and\noversaw the safety of the trial. The article was prepared by the first author\nand steering committee co-chairmen and was reviewed and edited by mem\nbers of the steering committee and authors. All authors reviewed the article,\napproved its submission for publication, and vouched for the accuracy and\ncompleteness of the data and for the fidelity of the trial to the protocol.\nStudy population\nThe study inclusion and exclusion criteria are shown in Table 1; trial flowchart\nis shown in Figure 1. Briefly, a total of 157 patients with severe AS according to\nthe guidelines were enrolled in the trial: 79 were randomized to conservative\ntreatment and 78 were randomized to early surgery. To prove truly asymp\ntomatic status, exercise testing was performed in all candidates to evaluate\nsymptom status according to a standardized protocol using treadmill or semi-\nsupine ergo-bicycle. To consider exercise testing negative, which was manda\ntory for inclusion, all candidates needed to reach a projected submaximal\nheart rate. Positive exercise test included onset of AS-related symptoms,\nfall in systolic blood pressure (≥20 mmHg from the baseline values), or\nElectrocardiography (ECG) or stress echocardiography signs of myocardial\nischaemia.9\nFollow-up and trial endpoints\nPatients were followed according to the protocol every 6 months for the\nfirst year and then yearly with the in-person visits at the participating study\ncentre. As the trial was affected by the Covid-19 pandemic, contact with\npatients who could not come in person was made by phone. For any event\nthat was registered, the medical records were asked for and reviewed.\nAdverse clinical events were adjudicated by the DSMB per protocol defini\ntions.7,8 Data and safety monitoring board members were not blinded to\nthe treatment allocation during events review. They adjudicated the events\nby consensus.\nTable 1 Eligibility inclusion/exclusion criteria\nInclusion criteria\n• Men and women of any ethnic origin aged ≥18 years\n• Written informed consent\n• Vmax across the aortic valve > 4 m/s or P mean ≥ 40 mmHg and AVA ≤\n1 cm2 or AVAi ≤ 0.6 cm2/m2 at rest\n• Without reported symptoms\n• Society of Thoracic Surgeons score < 8%\nExclusion criteria\nParticipation in another clinical trial within 30 days prior to\nrandomization\n• Pregnant or nursing women\n• Mental condition rendering the patient unable to understand the\nnature, scope, and possible consequences of the study or to follow the\nprotocol\n• Positive stress-test defined as follows:\n(a)\nAnginal chest pain during testing\n(b)\nSyncope or dizziness during testing\n(c)\nDecrease in systolic blood pressure during exercise ≥ 20 mmHg\n(d)\nMalignant arrhythmia during exercise testing (VT or VF)\n• Left ventricular ejection fraction < 50% at rest\n• Very severe AS defined as Vmax > 5.5 m/s at rest\n• Significant disease of other valves: mitral stenosis with Pmean > 5 mg, or\nany significant regurgitation ≥ 3+\n• Recent previous myocardial infarction (<1 year)\n• Need for additional aortic root replacement (i.e. Bentall) or ascending\naorta surgery in asymptomatic patients undergoing AVR\n• Previous coronary bypass surgery\n• Previous any heart valve surgery\n• Impaired renal function, i.e. creatinine > 200 μmol/L or glomerular\nfiltration rate < 30 mL/min/1.73 m2\n• Significant pulmonary hypertension at rest (systolic pulmonary artery\npressure > 50 mmHg)\n• Uncontrolled hypertension at rest (systolic blood pressure >\n180 mmHg and diastolic blood pressure > 100 mmHg)\n• Significant comorbidity with reduced life expectancy (<3 years)\n• Uncontrolled diabetes mellitus (HbA1c > 9%)\n• Significant chronic obstructive pulmonary disease (FEV1 < 70% of\npredicted value)"
        }
      ],
      "counterevidence": [],
      "justification": "Both arms followed the same protocol schedule, and COVID-related phone follow-up applied to patients regardless of arm. Death is hard to miss, so any difference in contact opportunities (e.g. surgery visits) is unlikely to change ascertainment of death.",
      "question_id": "sq:measurement:differential",
      "unknowns": [
        "Whether vital status was verified from registries in both arms is not stated."
      ]
    },
    {
      "answer": "yes",
      "bases": [
        {
          "evidence": "sha256:3ce4199af9d487f3e5ca3f79d7aa594f229272e2c0d58e52514ccdb17a749a68",
          "kind": "direct_support",
          "source": "Introduction\nAortic stenosis (AS) is the single most common valvular heart disease re\nquiring intervention in developed countries and is projected to double by\n2050 in both the USA and Europe.1 The approach to symptomatic pa\ntients with severe AS is straightforward. Surgical aortic valve replacement\n(AVR) and, more recently, transcatheter aortic valve implantation (TAVI)\nprocedures are Class I recommendation to relieve symptoms and im\nprove survival in symptomatic patients with severe AS.2,3\nConversely, the question of when and how to treat truly asymptom\natic patients with severe AS and normal left ventricular (LV) systolic\nfunction is still subject to debate and ongoing research. To date, two\nrandomized trials have demonstrated benefit of early AVR in compari\nson with conservative strategy in asymptomatic patients with severe\nand very severe AS patients.4,5 In addition, there are several ongoing\nrandomized trials investigating the role of early TAVI and/or early sur\ngical AVR in asymptomatic AS.\nThe Aortic Valve Replacement Versus Conservative Treatment in\nAsymptomatic Severe Aortic Stenosis (AVATAR) trial is an investigator-\ninitiated, prospective, multinational, randomized, controlled, parallel-group,\nevent-driven trial that compared the safety and efficacy of early surgery in\nthe treatment of truly asymptomatic patients with severe AS and LV ejec\ntion fraction (LVEF) ≥ 50% vs. conservative treatment with watchful wait\ning strategy and AVR only after symptom onset, or other guidelines\ndirected Class I or II indications for AVR.3,6 In the primary analysis of the\nAVATAR trial, asymptomatic AS patients randomized to early surgery\nhad a lower incidence of the composite primary outcome comprising all-\ncause death, acute myocardial infarction, stroke, or unplanned hospitaliza\ntion for heart failure (HF), compared with patients who were randomized\nto conservative treatment.5 We now report the results of the AVATAR\ntrial after extended follow-up at 5 years.\nMethods\nStudy design and oversight\nThe AVATAR trial (ClinicalTrials.gov identifier NCT02436655) protocol\nand protocol update were designed by the first co-authors and steering\ncommittee co-chairmen and was approved by the steering committee of\nthe AVATAR trial.7,8 The clinical and outcomes data were collected by per\nsonnel at the participating sites and were sent directly to the data coordinat\ning centre at the University Clinical Center of Serbia. No extramural funding\nwas used to support this work. The authors, members of the steering com\nmittee, and investigators are solely responsible for the design and conduct of\nthis trial, all analyses, drafting and editing of the article, and its final contents.\nIndependent statistician conducted the long-term data analyses.\nThe trial was conducted in accordance with the Declaration of Helsinki. All\nparticipants provided written informed consent. An independent data and\nsafety monitoring board (DSMB) adjudicated all serious adverse events and\noversaw the safety of the trial. The article was prepared by the first author\nand steering committee co-chairmen and was reviewed and edited by mem\nbers of the steering committee and authors. All authors reviewed the article,\napproved its submission for publication, and vouched for the accuracy and\ncompleteness of the data and for the fidelity of the trial to the protocol.\nStudy population\nThe study inclusion and exclusion criteria are shown in Table 1; trial flowchart\nis shown in Figure 1. Briefly, a total of 157 patients with severe AS according to\nthe guidelines were enrolled in the trial: 79 were randomized to conservative\ntreatment and 78 were randomized to early surgery. To prove truly asymp\ntomatic status, exercise testing was performed in all candidates to evaluate\nsymptom status according to a standardized protocol using treadmill or semi-\nsupine ergo-bicycle. To consider exercise testing negative, which was manda\ntory for inclusion, all candidates needed to reach a projected submaximal\nheart rate. Positive exercise test included onset of AS-related symptoms,\nfall in systolic blood pressure (≥20 mmHg from the baseline values), or\nElectrocardiography (ECG) or stress echocardiography signs of myocardial\nischaemia.9\nFollow-up and trial endpoints\nPatients were followed according to the protocol every 6 months for the\nfirst year and then yearly with the in-person visits at the participating study\ncentre. As the trial was affected by the Covid-19 pandemic, contact with\npatients who could not come in person was made by phone. For any event\nthat was registered, the medical records were asked for and reviewed.\nAdverse clinical events were adjudicated by the DSMB per protocol defini\ntions.7,8 Data and safety monitoring board members were not blinded to\nthe treatment allocation during events review. They adjudicated the events\nby consensus.\nTable 1 Eligibility inclusion/exclusion criteria\nInclusion criteria\n• Men and women of any ethnic origin aged ≥18 years\n• Written informed consent\n• Vmax across the aortic valve > 4 m/s or P mean ≥ 40 mmHg and AVA ≤\n1 cm2 or AVAi ≤ 0.6 cm2/m2 at rest\n• Without reported symptoms\n• Society of Thoracic Surgeons score < 8%\nExclusion criteria\nParticipation in another clinical trial within 30 days prior to\nrandomization\n• Pregnant or nursing women\n• Mental condition rendering the patient unable to understand the\nnature, scope, and possible consequences of the study or to follow the\nprotocol\n• Positive stress-test defined as follows:\n(a)\nAnginal chest pain during testing\n(b)\nSyncope or dizziness during testing\n(c)\nDecrease in systolic blood pressure during exercise ≥ 20 mmHg\n(d)\nMalignant arrhythmia during exercise testing (VT or VF)\n• Left ventricular ejection fraction < 50% at rest\n• Very severe AS defined as Vmax > 5.5 m/s at rest\n• Significant disease of other valves: mitral stenosis with Pmean > 5 mg, or\nany significant regurgitation ≥ 3+\n• Recent previous myocardial infarction (<1 year)\n• Need for additional aortic root replacement (i.e. Bentall) or ascending\naorta surgery in asymptomatic patients undergoing AVR\n• Previous coronary bypass surgery\n• Previous any heart valve surgery\n• Impaired renal function, i.e. creatinine > 200 μmol/L or glomerular\nfiltration rate < 30 mL/min/1.73 m2\n• Significant pulmonary hypertension at rest (systolic pulmonary artery\npressure > 50 mmHg)\n• Uncontrolled hypertension at rest (systolic blood pressure >\n180 mmHg and diastolic blood pressure > 100 mmHg)\n• Significant comorbidity with reduced life expectancy (<3 years)\n• Uncontrolled diabetes mellitus (HbA1c > 9%)\n• Significant chronic obstructive pulmonary disease (FEV1 < 70% of\npredicted value)"
        }
      ],
      "counterevidence": [],
      "justification": "The trial was open-label (registry masking: none), and the report states that DSMB members were not blinded to allocation when reviewing events. Site investigators recording deaths were also aware of the allocation.",
      "question_id": "sq:measurement:assessor-aware",
      "unknowns": []
    },
    {
      "answer": "probably_no",
      "bases": [
        {
          "evidence": "sha256:3ce4199af9d487f3e5ca3f79d7aa594f229272e2c0d58e52514ccdb17a749a68",
          "kind": "inference",
          "source": "Introduction\nAortic stenosis (AS) is the single most common valvular heart disease re\nquiring intervention in developed countries and is projected to double by\n2050 in both the USA and Europe.1 The approach to symptomatic pa\ntients with severe AS is straightforward. Surgical aortic valve replacement\n(AVR) and, more recently, transcatheter aortic valve implantation (TAVI)\nprocedures are Class I recommendation to relieve symptoms and im\nprove survival in symptomatic patients with severe AS.2,3\nConversely, the question of when and how to treat truly asymptom\natic patients with severe AS and normal left ventricular (LV) systolic\nfunction is still subject to debate and ongoing research. To date, two\nrandomized trials have demonstrated benefit of early AVR in compari\nson with conservative strategy in asymptomatic patients with severe\nand very severe AS patients.4,5 In addition, there are several ongoing\nrandomized trials investigating the role of early TAVI and/or early sur\ngical AVR in asymptomatic AS.\nThe Aortic Valve Replacement Versus Conservative Treatment in\nAsymptomatic Severe Aortic Stenosis (AVATAR) trial is an investigator-\ninitiated, prospective, multinational, randomized, controlled, parallel-group,\nevent-driven trial that compared the safety and efficacy of early surgery in\nthe treatment of truly asymptomatic patients with severe AS and LV ejec\ntion fraction (LVEF) ≥ 50% vs. conservative treatment with watchful wait\ning strategy and AVR only after symptom onset, or other guidelines\ndirected Class I or II indications for AVR.3,6 In the primary analysis of the\nAVATAR trial, asymptomatic AS patients randomized to early surgery\nhad a lower incidence of the composite primary outcome comprising all-\ncause death, acute myocardial infarction, stroke, or unplanned hospitaliza\ntion for heart failure (HF), compared with patients who were randomized\nto conservative treatment.5 We now report the results of the AVATAR\ntrial after extended follow-up at 5 years.\nMethods\nStudy design and oversight\nThe AVATAR trial (ClinicalTrials.gov identifier NCT02436655) protocol\nand protocol update were designed by the first co-authors and steering\ncommittee co-chairmen and was approved by the steering committee of\nthe AVATAR trial.7,8 The clinical and outcomes data were collected by per\nsonnel at the participating sites and were sent directly to the data coordinat\ning centre at the University Clinical Center of Serbia. No extramural funding\nwas used to support this work. The authors, members of the steering com\nmittee, and investigators are solely responsible for the design and conduct of\nthis trial, all analyses, drafting and editing of the article, and its final contents.\nIndependent statistician conducted the long-term data analyses.\nThe trial was conducted in accordance with the Declaration of Helsinki. All\nparticipants provided written informed consent. An independent data and\nsafety monitoring board (DSMB) adjudicated all serious adverse events and\noversaw the safety of the trial. The article was prepared by the first author\nand steering committee co-chairmen and was reviewed and edited by mem\nbers of the steering committee and authors. All authors reviewed the article,\napproved its submission for publication, and vouched for the accuracy and\ncompleteness of the data and for the fidelity of the trial to the protocol.\nStudy population\nThe study inclusion and exclusion criteria are shown in Table 1; trial flowchart\nis shown in Figure 1. Briefly, a total of 157 patients with severe AS according to\nthe guidelines were enrolled in the trial: 79 were randomized to conservative\ntreatment and 78 were randomized to early surgery. To prove truly asymp\ntomatic status, exercise testing was performed in all candidates to evaluate\nsymptom status according to a standardized protocol using treadmill or semi-\nsupine ergo-bicycle. To consider exercise testing negative, which was manda\ntory for inclusion, all candidates needed to reach a projected submaximal\nheart rate. Positive exercise test included onset of AS-related symptoms,\nfall in systolic blood pressure (≥20 mmHg from the baseline values), or\nElectrocardiography (ECG) or stress echocardiography signs of myocardial\nischaemia.9\nFollow-up and trial endpoints\nPatients were followed according to the protocol every 6 months for the\nfirst year and then yearly with the in-person visits at the participating study\ncentre. As the trial was affected by the Covid-19 pandemic, contact with\npatients who could not come in person was made by phone. For any event\nthat was registered, the medical records were asked for and reviewed.\nAdverse clinical events were adjudicated by the DSMB per protocol defini\ntions.7,8 Data and safety monitoring board members were not blinded to\nthe treatment allocation during events review. They adjudicated the events\nby consensus.\nTable 1 Eligibility inclusion/exclusion criteria\nInclusion criteria\n• Men and women of any ethnic origin aged ≥18 years\n• Written informed consent\n• Vmax across the aortic valve > 4 m/s or P mean ≥ 40 mmHg and AVA ≤\n1 cm2 or AVAi ≤ 0.6 cm2/m2 at rest\n• Without reported symptoms\n• Society of Thoracic Surgeons score < 8%\nExclusion criteria\nParticipation in another clinical trial within 30 days prior to\nrandomization\n• Pregnant or nursing women\n• Mental condition rendering the patient unable to understand the\nnature, scope, and possible consequences of the study or to follow the\nprotocol\n• Positive stress-test defined as follows:\n(a)\nAnginal chest pain during testing\n(b)\nSyncope or dizziness during testing\n(c)\nDecrease in systolic blood pressure during exercise ≥ 20 mmHg\n(d)\nMalignant arrhythmia during exercise testing (VT or VF)\n• Left ventricular ejection fraction < 50% at rest\n• Very severe AS defined as Vmax > 5.5 m/s at rest\n• Significant disease of other valves: mitral stenosis with Pmean > 5 mg, or\nany significant regurgitation ≥ 3+\n• Recent previous myocardial infarction (<1 year)\n• Need for additional aortic root replacement (i.e. Bentall) or ascending\naorta surgery in asymptomatic patients undergoing AVR\n• Previous coronary bypass surgery\n• Previous any heart valve surgery\n• Impaired renal function, i.e. creatinine > 200 μmol/L or glomerular\nfiltration rate < 30 mL/min/1.73 m2\n• Significant pulmonary hypertension at rest (systolic pulmonary artery\npressure > 50 mmHg)\n• Uncontrolled hypertension at rest (systolic blood pressure >\n180 mmHg and diastolic blood pressure > 100 mmHg)\n• Significant comorbidity with reduced life expectancy (<3 years)\n• Uncontrolled diabetes mellitus (HbA1c > 9%)\n• Significant chronic obstructive pulmonary disease (FEV1 < 70% of\npredicted value)"
        }
      ],
      "counterevidence": [],
      "justification": "All-cause death is an observer-reported outcome that involves no judgement, so knowledge of the intervention is unlikely to influence its assessment, even though the assessors were aware of the allocation.",
      "question_id": "sq:measurement:influence-possible",
      "unknowns": []
    }
  ],
  "inactive": [
    "sq:measurement:influence-likely"
  ],
  "decision": {
    "adjudication": null,
    "adopted": "low",
    "authority": "algorithm",
    "contract": "rob2-kit.domain.reasoned-adjudication.v1",
    "proposed": "low",
    "trace_authority": "proposed_algorithm"
  }
}

Full selected-answer evidence:
[
  {
    "basis": {
      "evidence": "sha256:3ce4199af9d487f3e5ca3f79d7aa594f229272e2c0d58e52514ccdb17a749a68",
      "kind": "direct_support",
      "source": "Introduction\nAortic stenosis (AS) is the single most common valvular heart disease re\nquiring intervention in developed countries and is projected to double by\n2050 in both the USA and Europe.1 The approach to symptomatic pa\ntients with severe AS is straightforward. Surgical aortic valve replacement\n(AVR) and, more recently, transcatheter aortic valve implantation (TAVI)\nprocedures are Class I recommendation to relieve symptoms and im\nprove survival in symptomatic patients with severe AS.2,3\nConversely, the question of when and how to treat truly asymptom\natic patients with severe AS and normal left ventricular (LV) systolic\nfunction is still subject to debate and ongoing research. To date, two\nrandomized trials have demonstrated benefit of early AVR in compari\nson with conservative strategy in asymptomatic patients with severe\nand very severe AS patients.4,5 In addition, there are several ongoing\nrandomized trials investigating the role of early TAVI and/or early sur\ngical AVR in asymptomatic AS.\nThe Aortic Valve Replacement Versus Conservative Treatment in\nAsymptomatic Severe Aortic Stenosis (AVATAR) trial is an investigator-\ninitiated, prospective, multinational, randomized, controlled, parallel-group,\nevent-driven trial that compared the safety and efficacy of early surgery in\nthe treatment of truly asymptomatic patients with severe AS and LV ejec\ntion fraction (LVEF) ≥ 50% vs. conservative treatment with watchful wait\ning strategy and AVR only after symptom onset, or other guidelines\ndirected Class I or II indications for AVR.3,6 In the primary analysis of the\nAVATAR trial, asymptomatic AS patients randomized to early surgery\nhad a lower incidence of the composite primary outcome comprising all-\ncause death, acute myocardial infarction, stroke, or unplanned hospitaliza\ntion for heart failure (HF), compared with patients who were randomized\nto conservative treatment.5 We now report the results of the AVATAR\ntrial after extended follow-up at 5 years.\nMethods\nStudy design and oversight\nThe AVATAR trial (ClinicalTrials.gov identifier NCT02436655) protocol\nand protocol update were designed by the first co-authors and steering\ncommittee co-chairmen and was approved by the steering committee of\nthe AVATAR trial.7,8 The clinical and outcomes data were collected by per\nsonnel at the participating sites and were sent directly to the data coordinat\ning centre at the University Clinical Center of Serbia. No extramural funding\nwas used to support this work. The authors, members of the steering com\nmittee, and investigators are solely responsible for the design and conduct of\nthis trial, all analyses, drafting and editing of the article, and its final contents.\nIndependent statistician conducted the long-term data analyses.\nThe trial was conducted in accordance with the Declaration of Helsinki. All\nparticipants provided written informed consent. An independent data and\nsafety monitoring board (DSMB) adjudicated all serious adverse events and\noversaw the safety of the trial. The article was prepared by the first author\nand steering committee co-chairmen and was reviewed and edited by mem\nbers of the steering committee and authors. All authors reviewed the article,\napproved its submission for publication, and vouched for the accuracy and\ncompleteness of the data and for the fidelity of the trial to the protocol.\nStudy population\nThe study inclusion and exclusion criteria are shown in Table 1; trial flowchart\nis shown in Figure 1. Briefly, a total of 157 patients with severe AS according to\nthe guidelines were enrolled in the trial: 79 were randomized to conservative\ntreatment and 78 were randomized to early surgery. To prove truly asymp\ntomatic status, exercise testing was performed in all candidates to evaluate\nsymptom status according to a standardized protocol using treadmill or semi-\nsupine ergo-bicycle. To consider exercise testing negative, which was manda\ntory for inclusion, all candidates needed to reach a projected submaximal\nheart rate. Positive exercise test included onset of AS-related symptoms,\nfall in systolic blood pressure (≥20 mmHg from the baseline values), or\nElectrocardiography (ECG) or stress echocardiography signs of myocardial\nischaemia.9\nFollow-up and trial endpoints\nPatients were followed according to the protocol every 6 months for the\nfirst year and then yearly with the in-person visits at the participating study\ncentre. As the trial was affected by the Covid-19 pandemic, contact with\npatients who could not come in person was made by phone. For any event\nthat was registered, the medical records were asked for and reviewed.\nAdverse clinical events were adjudicated by the DSMB per protocol defini\ntions.7,8 Data and safety monitoring board members were not blinded to\nthe treatment allocation during events review. They adjudicated the events\nby consensus.\nTable 1 Eligibility inclusion/exclusion criteria\nInclusion criteria\n• Men and women of any ethnic origin aged ≥18 years\n• Written informed consent\n• Vmax across the aortic valve > 4 m/s or P mean ≥ 40 mmHg and AVA ≤\n1 cm2 or AVAi ≤ 0.6 cm2/m2 at rest\n• Without reported symptoms\n• Society of Thoracic Surgeons score < 8%\nExclusion criteria\nParticipation in another clinical trial within 30 days prior to\nrandomization\n• Pregnant or nursing women\n• Mental condition rendering the patient unable to understand the\nnature, scope, and possible consequences of the study or to follow the\nprotocol\n• Positive stress-test defined as follows:\n(a)\nAnginal chest pain during testing\n(b)\nSyncope or dizziness during testing\n(c)\nDecrease in systolic blood pressure during exercise ≥ 20 mmHg\n(d)\nMalignant arrhythmia during exercise testing (VT or VF)\n• Left ventricular ejection fraction < 50% at rest\n• Very severe AS defined as Vmax > 5.5 m/s at rest\n• Significant disease of other valves: mitral stenosis with Pmean > 5 mg, or\nany significant regurgitation ≥ 3+\n• Recent previous myocardial infarction (<1 year)\n• Need for additional aortic root replacement (i.e. Bentall) or ascending\naorta surgery in asymptomatic patients undergoing AVR\n• Previous coronary bypass surgery\n• Previous any heart valve surgery\n• Impaired renal function, i.e. creatinine > 200 μmol/L or glomerular\nfiltration rate < 30 mL/min/1.73 m2\n• Significant pulmonary hypertension at rest (systolic pulmonary artery\npressure > 50 mmHg)\n• Uncontrolled hypertension at rest (systolic blood pressure >\n180 mmHg and diastolic blood pressure > 100 mmHg)\n• Significant comorbidity with reduced life expectancy (<3 years)\n• Uncontrolled diabetes mellitus (HbA1c > 9%)\n• Significant chronic obstructive pulmonary disease (FEV1 < 70% of\npredicted value)"
    },
    "ev": {
      "end": 6665,
      "end_line": 116,
      "handle": "eh_3ce4199af9d487f3",
      "identity": "sha256:3ce4199af9d487f3e5ca3f79d7aa594f229272e2c0d58e52514ccdb17a749a68",
      "kind": "narrative",
      "page": 3,
      "quote": "Introduction\nAortic stenosis (AS) is the single most common valvular heart disease re\nquiring intervention in developed countries and is projected to double by\n2050 in both the USA and Europe.1 The approach to symptomatic pa\ntients with severe AS is straightforward. Surgical aortic valve replacement\n(AVR) and, more recently, transcatheter aortic valve implantation (TAVI)\nprocedures are Class I recommendation to relieve symptoms and im\nprove survival in symptomatic patients with severe AS.2,3\nConversely, the question of when and how to treat truly asymptom\natic patients with severe AS and normal left ventricular (LV) systolic\nfunction is still subject to debate and ongoing research. To date, two\nrandomized trials have demonstrated benefit of early AVR in compari\nson with conservative strategy in asymptomatic patients with severe\nand very severe AS patients.4,5 In addition, there are several ongoing\nrandomized trials investigating the role of early TAVI and/or early sur\ngical AVR in asymptomatic AS.\nThe Aortic Valve Replacement Versus Conservative Treatment in\nAsymptomatic Severe Aortic Stenosis (AVATAR) trial is an investigator-\ninitiated, prospective, multinational, randomized, controlled, parallel-group,\nevent-driven trial that compared the safety and efficacy of early surgery in\nthe treatment of truly asymptomatic patients with severe AS and LV ejec\ntion fraction (LVEF) ≥ 50% vs. conservative treatment with watchful wait\ning strategy and AVR only after symptom onset, or other guidelines\ndirected Class I or II indications for AVR.3,6 In the primary analysis of the\nAVATAR trial, asymptomatic AS patients randomized to early surgery\nhad a lower incidence of the composite primary outcome comprising all-\ncause death, acute myocardial infarction, stroke, or unplanned hospitaliza\ntion for heart failure (HF), compared with patients who were randomized\nto conservative treatment.5 We now report the results of the AVATAR\ntrial after extended follow-up at 5 years.\nMethods\nStudy design and oversight\nThe AVATAR trial (ClinicalTrials.gov identifier NCT02436655) protocol\nand protocol update were designed by the first co-authors and steering\ncommittee co-chairmen and was approved by the steering committee of\nthe AVATAR trial.7,8 The clinical and outcomes data were collected by per\nsonnel at the participating sites and were sent directly to the data coordinat\ning centre at the University Clinical Center of Serbia. No extramural funding\nwas used to support this work. The authors, members of the steering com\nmittee, and investigators are solely responsible for the design and conduct of\nthis trial, all analyses, drafting and editing of the article, and its final contents.\nIndependent statistician conducted the long-term data analyses.\nThe trial was conducted in accordance with the Declaration of Helsinki. All\nparticipants provided written informed consent. An independent data and\nsafety monitoring board (DSMB) adjudicated all serious adverse events and\noversaw the safety of the trial. The article was prepared by the first author\nand steering committee co-chairmen and was reviewed and edited by mem\nbers of the steering committee and authors. All authors reviewed the article,\napproved its submission for publication, and vouched for the accuracy and\ncompleteness of the data and for the fidelity of the trial to the protocol.\nStudy population\nThe study inclusion and exclusion criteria are shown in Table 1; trial flowchart\nis shown in Figure 1. Briefly, a total of 157 patients with severe AS according to\nthe guidelines were enrolled in the trial: 79 were randomized to conservative\ntreatment and 78 were randomized to early surgery. To prove truly asymp\ntomatic status, exercise testing was performed in all candidates to evaluate\nsymptom status according to a standardized protocol using treadmill or semi-\nsupine ergo-bicycle. To consider exercise testing negative, which was manda\ntory for inclusion, all candidates needed to reach a projected submaximal\nheart rate. Positive exercise test included onset of AS-related symptoms,\nfall in systolic blood pressure (≥20 mmHg from the baseline values), or\nElectrocardiography (ECG) or stress echocardiography signs of myocardial\nischaemia.9\nFollow-up and trial endpoints\nPatients were followed according to the protocol every 6 months for the\nfirst year and then yearly with the in-person visits at the participating study\ncentre. As the trial was affected by the Covid-19 pandemic, contact with\npatients who could not come in person was made by phone. For any event\nthat was registered, the medical records were asked for and reviewed.\nAdverse clinical events were adjudicated by the DSMB per protocol defini\ntions.7,8 Data and safety monitoring board members were not blinded to\nthe treatment allocation during events review. They adjudicated the events\nby consensus.\nTable 1 Eligibility inclusion/exclusion criteria\nInclusion criteria\n• Men and women of any ethnic origin aged ≥18 years\n• Written informed consent\n• Vmax across the aortic valve > 4 m/s or P mean ≥ 40 mmHg and AVA ≤\n1 cm2 or AVAi ≤ 0.6 cm2/m2 at rest\n• Without reported symptoms\n• Society of Thoracic Surgeons score < 8%\nExclusion criteria\nParticipation in another clinical trial within 30 days prior to\nrandomization\n• Pregnant or nursing women\n• Mental condition rendering the patient unable to understand the\nnature, scope, and possible consequences of the study or to follow the\nprotocol\n• Positive stress-test defined as follows:\n(a)\nAnginal chest pain during testing\n(b)\nSyncope or dizziness during testing\n(c)\nDecrease in systolic blood pressure during exercise ≥ 20 mmHg\n(d)\nMalignant arrhythmia during exercise testing (VT or VF)\n• Left ventricular ejection fraction < 50% at rest\n• Very severe AS defined as Vmax > 5.5 m/s at rest\n• Significant disease of other valves: mitral stenosis with Pmean > 5 mg, or\nany significant regurgitation ≥ 3+\n• Recent previous myocardial infarction (<1 year)\n• Need for additional aortic root replacement (i.e. Bentall) or ascending\naorta surgery in asymptomatic patients undergoing AVR\n• Previous coronary bypass surgery\n• Previous any heart valve surgery\n• Impaired renal function, i.e. creatinine > 200 μmol/L or glomerular\nfiltration rate < 30 mL/min/1.73 m2\n• Significant pulmonary hypertension at rest (systolic pulmonary artery\npressure > 50 mmHg)\n• Uncontrolled hypertension at rest (systolic blood pressure >\n180 mmHg and diastolic blood pressure > 100 mmHg)\n• Significant comorbidity with reduced life expectancy (<3 years)\n• Uncontrolled diabetes mellitus (HbA1c > 9%)\n• Significant chronic obstructive pulmonary disease (FEV1 < 70% of\npredicted value)",
      "source_id": "source_7f7b055eb93e03bcd72c8fe32984a531050e324a0b58555dbc9701c8b3e2d5e7",
      "source_version": "sha256:a890f771fd05ebda4edada403fa59475add7dfa13409e53bbca7f38407265ae3",
      "start": 0,
      "start_line": 1,
      "trial_id": "banovic26-avatar-2024"
    },
    "src": {
      "declared_role": "main_article",
      "id": "source_7f7b055eb93e03bcd72c8fe32984a531050e324a0b58555dbc9701c8b3e2d5e7",
      "label": "ehae585.pdf",
      "logical_path": "ehae585.pdf",
      "media_type": "application/pdf",
      "origin": "local_dossier",
      "page_count": 10,
      "projection_hash": "sha256:a890f771fd05ebda4edada403fa59475add7dfa13409e53bbca7f38407265ae3",
      "role": "main_article",
      "sha256": "sha256:844778e139c06d130531978d4d574f575a3a2bc078d2cc0fb407746abeff7bf5",
      "trial_id": "banovic26-avatar-2024"
    }
  }
]

4.4 reasoning basis: {"evidence": "sha256:3ce4199af9d487f3e5ca3f79d7aa594f229272e2c0d58e52514ccdb17a749a68", "kind": "inference", "source": "Introduction\nAortic stenosis (AS) is the single most common valvular heart disease re\nquiring intervention in developed countries and is projected to double by\n2050 in both the USA and Europe.1 The approach to symptomatic pa\ntients with severe AS is straightforward. Surgical aortic valve replacement\n(AVR) and, more recently, transcatheter aortic valve implantation (TAVI)\nprocedures are Class I recommendation to relieve symptoms and im\nprove survival in symptomatic patients with severe AS.2,3\nConversely, the question of when and how to treat truly asymptom\natic patients with severe AS and normal left ventricular (LV) systolic\nfunction is still subject to debate and ongoing research. To date, two\nrandomized trials have demonstrated benefit of early AVR in compari\nson with conservative strategy in asymptomatic patients with severe\nand very severe AS patients.4,5 In addition, there are several ongoing\nrandomized trials investigating the role of early TAVI and/or early sur\ngical AVR in asymptomatic AS.\nThe Aortic Valve Replacement Versus Conservative Treatment in\nAsymptomatic Severe Aortic Stenosis (AVATAR) trial is an investigator-\ninitiated, prospective, multinational, randomized, controlled, parallel-group,\nevent-driven trial that compared the safety and efficacy of early surgery in\nthe treatment of truly asymptomatic patients with severe AS and LV ejec\ntion fraction (LVEF) ≥ 50% vs. conservative treatment with watchful wait\ning strategy and AVR only after symptom onset, or other guidelines\ndirected Class I or II indications for AVR.3,6 In the primary analysis of the\nAVATAR trial, asymptomatic AS patients randomized to early surgery\nhad a lower incidence of the composite primary outcome comprising all-\ncause death, acute myocardial infarction, stroke, or unplanned hospitaliza\ntion for heart failure (HF), compared with patients who were randomized\nto conservative treatment.5 We now report the results of the AVATAR\ntrial after extended follow-up at 5 years.\nMethods\nStudy design and oversight\nThe AVATAR trial (ClinicalTrials.gov identifier NCT02436655) protocol\nand protocol update were designed by the first co-authors and steering\ncommittee co-chairmen and was approved by the steering committee of\nthe AVATAR trial.7,8 The clinical and outcomes data were collected by per\nsonnel at the participating sites and were sent directly to the data coordinat\ning centre at the University Clinical Center of Serbia. No extramural funding\nwas used to support this work. The authors, members of the steering com\nmittee, and investigators are solely responsible for the design and conduct of\nthis trial, all analyses, drafting and editing of the article, and its final contents.\nIndependent statistician conducted the long-term data analyses.\nThe trial was conducted in accordance with the Declaration of Helsinki. All\nparticipants provided written informed consent. An independent data and\nsafety monitoring board (DSMB) adjudicated all serious adverse events and\noversaw the safety of the trial. The article was prepared by the first author\nand steering committee co-chairmen and was reviewed and edited by mem\nbers of the steering committee and authors. All authors reviewed the article,\napproved its submission for publication, and vouched for the accuracy and\ncompleteness of the data and for the fidelity of the trial to the protocol.\nStudy population\nThe study inclusion and exclusion criteria are shown in Table 1; trial flowchart\nis shown in Figure 1. Briefly, a total of 157 patients with severe AS according to\nthe guidelines were enrolled in the trial: 79 were randomized to conservative\ntreatment and 78 were randomized to early surgery. To prove truly asymp\ntomatic status, exercise testing was performed in all candidates to evaluate\nsymptom status according to a standardized protocol using treadmill or semi-\nsupine ergo-bicycle. To consider exercise testing negative, which was manda\ntory for inclusion, all candidates needed to reach a projected submaximal\nheart rate. Positive exercise test included onset of AS-related symptoms,\nfall in systolic blood pressure (≥20 mmHg from the baseline values), or\nElectrocardiography (ECG) or stress echocardiography signs of myocardial\nischaemia.9\nFollow-up and trial endpoints\nPatients were followed according to the protocol every 6 months for the\nfirst year and then yearly with the in-person visits at the participating study\ncentre. As the trial was affected by the Covid-19 pandemic, contact with\npatients who could not come in person was made by phone. For any event\nthat was registered, the medical records were asked for and reviewed.\nAdverse clinical events were adjudicated by the DSMB per protocol defini\ntions.7,8 Data and safety monitoring board members were not blinded to\nthe treatment allocation during events review. They adjudicated the events\nby consensus.\nTable 1 Eligibility inclusion/exclusion criteria\nInclusion criteria\n• Men and women of any ethnic origin aged ≥18 years\n• Written informed consent\n• Vmax across the aortic valve > 4 m/s or P mean ≥ 40 mmHg and AVA ≤\n1 cm2 or AVAi ≤ 0.6 cm2/m2 at rest\n• Without reported symptoms\n• Society of Thoracic Surgeons score < 8%\nExclusion criteria\nParticipation in another clinical trial within 30 days prior to\nrandomization\n• Pregnant or nursing women\n• Mental condition rendering the patient unable to understand the\nnature, scope, and possible consequences of the study or to follow the\nprotocol\n• Positive stress-test defined as follows:\n(a)\nAnginal chest pain during testing\n(b)\nSyncope or dizziness during testing\n(c)\nDecrease in systolic blood pressure during exercise ≥ 20 mmHg\n(d)\nMalignant arrhythmia during exercise testing (VT or VF)\n• Left ventricular ejection fraction < 50% at rest\n• Very severe AS defined as Vmax > 5.5 m/s at rest\n• Significant disease of other valves: mitral stenosis with Pmean > 5 mg, or\nany significant regurgitation ≥ 3+\n• Recent previous myocardial infarction (<1 year)\n• Need for additional aortic root replacement (i.e. Bentall) or ascending\naorta surgery in asymptomatic patients undergoing AVR\n• Previous coronary bypass surgery\n• Previous any heart valve surgery\n• Impaired renal function, i.e. creatinine > 200 μmol/L or glomerular\nfiltration rate < 30 mL/min/1.73 m2\n• Significant pulmonary hypertension at rest (systolic pulmonary artery\npressure > 50 mmHg)\n• Uncontrolled hypertension at rest (systolic blood pressure >\n180 mmHg and diastolic blood pressure > 100 mmHg)\n• Significant comorbidity with reduced life expectancy (<3 years)\n• Uncontrolled diabetes mellitus (HbA1c > 9%)\n• Significant chronic obstructive pulmonary disease (FEV1 < 70% of\npredicted value)"}

All-cause death is an observer-reported outcome that involves no judgement

## Domain 5

Were the data that produced this result analysed in accordance with a pre-specified analysis plan that was finalized before unblinded outcome data were available for analysis?

Displayed source quotation(s): Prespecified secondary end points included the following: … Time to death / Primary outcome 1: all cause death, Major Adverse Cardiac Event (MACE) including: …

Full recorded selected-answer justification: The registry entry (first submitted 30 Apr 2015, before enrolment began in June 2015) names all-cause death only as a component of composite outcomes. It does not list time to all-cause death as a separate outcome. The Circulation 2022 and EHJ 2024 reports describe 'time to death' as a prespecified secondary end point analysed with Kaplan-Meier and Cox models, citing a published protocol. That protocol is not among the captured Sources, and the report statements are not date-stamped before unblinded data. The only SAP-type document is an amendment dated 4 Jan 2021 about COVID surgical delays. No dated source therefore specifies this measurement and analysis.

Unknowns: ["Whether the published protocol listed time to all-cause death and its Cox analysis, and its date relative to unblinded data."]

Complete answers, inactive branches and decision:
{
  "answers": [
    {
      "answer": "no_information",
      "bases": [
        {
          "evidence": "sha256:d54a2600ddc753b357c613143d0dc578719c891b861e7a229dd6edfb68ae27c1",
          "kind": "context",
          "source": "### Primary outcome 1: all cause death, Major Adverse Cardiac Event (MACE) including: ( Acute Myocardial Infarction - AMI, Stroke - CVI, unplanned hospitalization for Heart failure (HF) needing intravenous treatment\n- Measure: all cause death, Major Adverse Cardiac Event (MACE) including: ( Acute Myocardial Infarction - AMI, Stroke - CVI, unplanned hospitalization for Heart failure (HF) needing intravenous treatment\n- Time frame: 36 months\n\n### Primary outcome 2: all cause death, Major Adverse Cardiac Event (MACE) including: ( Acute Myocardial Infarction - AMI, Stroke - CVI, unplanned hospitalization for Heart failure (HF) needing intravenous treatment\n- Measure: all cause death, Major Adverse Cardiac Event (MACE) including: ( Acute Myocardial Infarction - AMI, Stroke - CVI, unplanned hospitalization for Heart failure (HF) needing intravenous treatment\n- Time frame: 5 years"
        },
        {
          "evidence": "sha256:7ad155913c1c58263ae1f68422aa27e610b681a3d164be094e441d48d5fd3bb4",
          "kind": "context",
          "source": "Trial End Points\nThe primary end point was a composite of all-cause mortality\nor major adverse cardiovascular events (MACEs) composed of\nacute myocardial infarction, stroke, and unplanned HF hospital-\nization needing intravenous treatment with diuretics or inotro-\npes. Prespecified secondary end points included the following:\n• In-hospital and 30-day postoperative mortality in oper-\nated patients in both groups\n• Repeat aortic valve surgery in operated patients in both\ngroups\n• Repeated MACEs, including stroke, acute myocardial\ninfarction, or unplanned HF hospitalization needing IV\ndiuretic treatment\n• Major bleeding defined as types 3, 4, and 5 according\nto the consensus report from the Bleeding Academic\nResearch Consortium13\n• Thromboembolic complications on the basis of clinical\nsymptoms, signs, and imaging studies\n• Time to death\n• Time to first HF hospitalization"
        },
        {
          "evidence": "sha256:30fa222ec5523dcc0f12be9e8de34b50b47f1fd9395d04d630e7a97a8b274e71",
          "kind": "context",
          "source": "Statistical analysis\nWe conducted all analyses according to the intention-to-treat principle,\nwhere all patients were included in the analysis as they were randomized.\nFor the analysis of the primary outcome, we built a Kaplan-Meier graph\nwith a log rank P-value to test for a difference between early surgery and\ncontrol intervention at a two-sided α value of 0.05 and used a Cox propor\ntional hazards model to derive hazard ratios (HRs) with 95% confidence in\ntervals (CIs) for treatment effect estimation.\nTime-to-event secondary outcomes were analysed using the same meth\nods applied for the analysis of the primary outcome. For MACE, all-cause\ndeath, HF hospitalization, and cardiovascular death, we repeated the ana\nlysis as described above restricted to a 3-year follow-up, with complete"
        },
        {
          "evidence": "sha256:7961ea6680167af2b56d24aa7a11a26f7a8d663d778579792b179efef84de4b0",
          "kind": "context",
          "source": "Avatar trial protocol\n-Amendment to surgical delays-\n\n\nAortic Valve Replacement Versus Conservative Treatment in\nAsymptomatic Severe Aortic Stenosis (AVATAR trial)\nNCT number : NCT02436655.\nDate of amendment: 04.01.2021"
        }
      ],
      "counterevidence": [],
      "justification": "The registry entry (first submitted 30 Apr 2015, before enrolment began in June 2015) names all-cause death only as a component of composite outcomes. It does not list time to all-cause death as a separate outcome. The Circulation 2022 and EHJ 2024 reports describe 'time to death' as a prespecified secondary end point analysed with Kaplan-Meier and Cox models, citing a published protocol. That protocol is not among the captured Sources, and the report statements are not date-stamped before unblinded data. The only SAP-type document is an amendment dated 4 Jan 2021 about COVID surgical delays. No dated source therefore specifies this measurement and analysis.",
      "question_id": "sq:selection:prespecified-analysis",
      "unknowns": [
        "Whether the published protocol listed time to all-cause death and its Cox analysis, and its date relative to unblinded data."
      ]
    },
    {
      "answer": "probably_no",
      "bases": [
        {
          "evidence": "sha256:30fa222ec5523dcc0f12be9e8de34b50b47f1fd9395d04d630e7a97a8b274e71",
          "kind": "direct_support",
          "source": "Statistical analysis\nWe conducted all analyses according to the intention-to-treat principle,\nwhere all patients were included in the analysis as they were randomized.\nFor the analysis of the primary outcome, we built a Kaplan-Meier graph\nwith a log rank P-value to test for a difference between early surgery and\ncontrol intervention at a two-sided α value of 0.05 and used a Cox propor\ntional hazards model to derive hazard ratios (HRs) with 95% confidence in\ntervals (CIs) for treatment effect estimation.\nTime-to-event secondary outcomes were analysed using the same meth\nods applied for the analysis of the primary outcome. For MACE, all-cause\ndeath, HF hospitalization, and cardiovascular death, we repeated the ana\nlysis as described above restricted to a 3-year follow-up, with complete"
        },
        {
          "evidence": "sha256:d54a2600ddc753b357c613143d0dc578719c891b861e7a229dd6edfb68ae27c1",
          "kind": "context",
          "source": "### Primary outcome 1: all cause death, Major Adverse Cardiac Event (MACE) including: ( Acute Myocardial Infarction - AMI, Stroke - CVI, unplanned hospitalization for Heart failure (HF) needing intravenous treatment\n- Measure: all cause death, Major Adverse Cardiac Event (MACE) including: ( Acute Myocardial Infarction - AMI, Stroke - CVI, unplanned hospitalization for Heart failure (HF) needing intravenous treatment\n- Time frame: 36 months\n\n### Primary outcome 2: all cause death, Major Adverse Cardiac Event (MACE) including: ( Acute Myocardial Infarction - AMI, Stroke - CVI, unplanned hospitalization for Heart failure (HF) needing intravenous treatment\n- Measure: all cause death, Major Adverse Cardiac Event (MACE) including: ( Acute Myocardial Infarction - AMI, Stroke - CVI, unplanned hospitalization for Heart failure (HF) needing intravenous treatment\n- Time frame: 5 years"
        }
      ],
      "counterevidence": [],
      "justification": "All-cause death is a single, unambiguous event, so there is essentially one way to measure the outcome domain. The registered time frames were 36 months and 5 years. The 2024 report states that all-cause death was analysed over the full follow-up and also restricted to 3 years, so no eligible time point appears to have been omitted in favour of a more favourable one.",
      "question_id": "sq:selection:multiple-measurements",
      "unknowns": []
    },
    {
      "answer": "probably_no",
      "bases": [
        {
          "evidence": "sha256:30fa222ec5523dcc0f12be9e8de34b50b47f1fd9395d04d630e7a97a8b274e71",
          "kind": "direct_support",
          "source": "Statistical analysis\nWe conducted all analyses according to the intention-to-treat principle,\nwhere all patients were included in the analysis as they were randomized.\nFor the analysis of the primary outcome, we built a Kaplan-Meier graph\nwith a log rank P-value to test for a difference between early surgery and\ncontrol intervention at a two-sided α value of 0.05 and used a Cox propor\ntional hazards model to derive hazard ratios (HRs) with 95% confidence in\ntervals (CIs) for treatment effect estimation.\nTime-to-event secondary outcomes were analysed using the same meth\nods applied for the analysis of the primary outcome. For MACE, all-cause\ndeath, HF hospitalization, and cardiovascular death, we repeated the ana\nlysis as described above restricted to a 3-year follow-up, with complete"
        },
        {
          "evidence": "sha256:f625637d366df2a074d73e83abb4d51636efff24297918423e027e19d9acd933",
          "kind": "context",
          "source": "were compared by using 2-sample t tests. A Kaplan-Meier\nestimator was used to estimate the distribution of time to pri-\nmary and time-to-event secondary end points (eg, survival and\ntime to first HF hospitalization) and a log-rank test to compare\nthem between the 2 treatment groups. A Cox proportional-\nhazards regression model that included treatment was used\nto estimate the hazard ratio comparing the early surgery and\nthe conservative treatment groups. For dichotomous second-"
        }
      ],
      "counterevidence": [],
      "justification": "Time-to-event secondary outcomes were analysed with the same Kaplan-Meier, log-rank and Cox model (treatment only) used for the primary outcome, and the same method was used in the 2022 paper. No covariate-adjusted or alternative models are described, and the long-term and 3-year analyses are both reported.",
      "question_id": "sq:selection:multiple-analyses",
      "unknowns": []
    }
  ],
  "inactive": [],
  "decision": {
    "adjudication": null,
    "adopted": "some_concerns",
    "authority": "algorithm",
    "contract": "rob2-kit.domain.reasoned-adjudication.v1",
    "proposed": "some_concerns",
    "trace_authority": "proposed_algorithm"
  }
}

Full selected-answer evidence:
[
  {
    "basis": {
      "evidence": "sha256:d54a2600ddc753b357c613143d0dc578719c891b861e7a229dd6edfb68ae27c1",
      "kind": "context",
      "source": "### Primary outcome 1: all cause death, Major Adverse Cardiac Event (MACE) including: ( Acute Myocardial Infarction - AMI, Stroke - CVI, unplanned hospitalization for Heart failure (HF) needing intravenous treatment\n- Measure: all cause death, Major Adverse Cardiac Event (MACE) including: ( Acute Myocardial Infarction - AMI, Stroke - CVI, unplanned hospitalization for Heart failure (HF) needing intravenous treatment\n- Time frame: 36 months\n\n### Primary outcome 2: all cause death, Major Adverse Cardiac Event (MACE) including: ( Acute Myocardial Infarction - AMI, Stroke - CVI, unplanned hospitalization for Heart failure (HF) needing intravenous treatment\n- Measure: all cause death, Major Adverse Cardiac Event (MACE) including: ( Acute Myocardial Infarction - AMI, Stroke - CVI, unplanned hospitalization for Heart failure (HF) needing intravenous treatment\n- Time frame: 5 years"
    },
    "ev": {
      "end": 5842,
      "end_line": 101,
      "handle": "eh_d54a2600ddc753b3",
      "identity": "sha256:d54a2600ddc753b357c613143d0dc578719c891b861e7a229dd6edfb68ae27c1",
      "kind": "narrative",
      "page": 1,
      "quote": "### Primary outcome 1: all cause death, Major Adverse Cardiac Event (MACE) including: ( Acute Myocardial Infarction - AMI, Stroke - CVI, unplanned hospitalization for Heart failure (HF) needing intravenous treatment\n- Measure: all cause death, Major Adverse Cardiac Event (MACE) including: ( Acute Myocardial Infarction - AMI, Stroke - CVI, unplanned hospitalization for Heart failure (HF) needing intravenous treatment\n- Time frame: 36 months\n\n### Primary outcome 2: all cause death, Major Adverse Cardiac Event (MACE) including: ( Acute Myocardial Infarction - AMI, Stroke - CVI, unplanned hospitalization for Heart failure (HF) needing intravenous treatment\n- Measure: all cause death, Major Adverse Cardiac Event (MACE) including: ( Acute Myocardial Infarction - AMI, Stroke - CVI, unplanned hospitalization for Heart failure (HF) needing intravenous treatment\n- Time frame: 5 years",
      "source_id": "source_b28064bc31d3335957e34134a4873694fc9f01af0ca3640ab719d51f1ae00099",
      "source_version": "sha256:d32e23eb2a1e9a1505bbcf5f930b2af72508c4887cea3775a63e30ab95ba16e0",
      "start": 4956,
      "start_line": 95,
      "trial_id": "banovic26-avatar-2024"
    },
    "src": {
      "declared_role": null,
      "id": "source_b28064bc31d3335957e34134a4873694fc9f01af0ca3640ab719d51f1ae00099",
      "label": "ClinicalTrials.gov NCT02436655",
      "logical_path": "registry/NCT02436655.json",
      "media_type": "application/json",
      "origin": "registry",
      "page_count": 1,
      "projection_hash": "sha256:d32e23eb2a1e9a1505bbcf5f930b2af72508c4887cea3775a63e30ab95ba16e0",
      "role": "registry",
      "sha256": "sha256:e7246ef60bb7dd9426caad8be13e304abb1adc1bef3dfa29f468070fd6935b35",
      "trial_id": "banovic26-avatar-2024"
    }
  },
  {
    "basis": {
      "evidence": "sha256:7ad155913c1c58263ae1f68422aa27e610b681a3d164be094e441d48d5fd3bb4",
      "kind": "context",
      "source": "Trial End Points\nThe primary end point was a composite of all-cause mortality\nor major adverse cardiovascular events (MACEs) composed of\nacute myocardial infarction, stroke, and unplanned HF hospital-\nization needing intravenous treatment with diuretics or inotro-\npes. Prespecified secondary end points included the following:\n• In-hospital and 30-day postoperative mortality in oper-\nated patients in both groups\n• Repeat aortic valve surgery in operated patients in both\ngroups\n• Repeated MACEs, including stroke, acute myocardial\ninfarction, or unplanned HF hospitalization needing IV\ndiuretic treatment\n• Major bleeding defined as types 3, 4, and 5 according\nto the consensus report from the Bleeding Academic\nResearch Consortium13\n• Thromboembolic complications on the basis of clinical\nsymptoms, signs, and imaging studies\n• Time to death\n• Time to first HF hospitalization"
    },
    "ev": {
      "end": 1492,
      "end_line": 35,
      "handle": "eh_7ad155913c1c5826",
      "identity": "sha256:7ad155913c1c58263ae1f68422aa27e610b681a3d164be094e441d48d5fd3bb4",
      "kind": "narrative",
      "page": 4,
      "quote": "Trial End Points\nThe primary end point was a composite of all-cause mortality\nor major adverse cardiovascular events (MACEs) composed of\nacute myocardial infarction, stroke, and unplanned HF hospital-\nization needing intravenous treatment with diuretics or inotro-\npes. Prespecified secondary end points included the following:\n• In-hospital and 30-day postoperative mortality in oper-\nated patients in both groups\n• Repeat aortic valve surgery in operated patients in both\ngroups\n• Repeated MACEs, including stroke, acute myocardial\ninfarction, or unplanned HF hospitalization needing IV\ndiuretic treatment\n• Major bleeding defined as types 3, 4, and 5 according\nto the consensus report from the Bleeding Academic\nResearch Consortium13\n• Thromboembolic complications on the basis of clinical\nsymptoms, signs, and imaging studies\n• Time to death\n• Time to first HF hospitalization",
      "source_id": "source_695a701df7a7b784e50a68c4ab749ed7917e3cb84d87a08196adbdf37c6e4d56",
      "source_version": "sha256:592b9a6c531c0b049f2039fffd71fd128e6a604e908c06cec2bb153c4878b8a0",
      "start": 612,
      "start_line": 16,
      "trial_id": "banovic26-avatar-2024"
    },
    "src": {
      "declared_role": "supplement",
      "id": "source_695a701df7a7b784e50a68c4ab749ed7917e3cb84d87a08196adbdf37c6e4d56",
      "label": "CIRCULATIONAHA.121.057639.pdf",
      "logical_path": "CIRCULATIONAHA.121.057639.pdf",
      "media_type": "application/pdf",
      "origin": "local_dossier",
      "page_count": 11,
      "projection_hash": "sha256:592b9a6c531c0b049f2039fffd71fd128e6a604e908c06cec2bb153c4878b8a0",
      "role": "supplement",
      "sha256": "sha256:dd643e8a0fc65605457c9a030145c67c4d87c43095476bd2b3440008f8513fab",
      "trial_id": "banovic26-avatar-2024"
    }
  },
  {
    "basis": {
      "evidence": "sha256:30fa222ec5523dcc0f12be9e8de34b50b47f1fd9395d04d630e7a97a8b274e71",
      "kind": "context",
      "source": "Statistical analysis\nWe conducted all analyses according to the intention-to-treat principle,\nwhere all patients were included in the analysis as they were randomized.\nFor the analysis of the primary outcome, we built a Kaplan-Meier graph\nwith a log rank P-value to test for a difference between early surgery and\ncontrol intervention at a two-sided α value of 0.05 and used a Cox propor\ntional hazards model to derive hazard ratios (HRs) with 95% confidence in\ntervals (CIs) for treatment effect estimation.\nTime-to-event secondary outcomes were analysed using the same meth\nods applied for the analysis of the primary outcome. For MACE, all-cause\ndeath, HF hospitalization, and cardiovascular death, we repeated the ana\nlysis as described above restricted to a 3-year follow-up, with complete"
    },
    "ev": {
      "end": 1602,
      "end_line": 24,
      "handle": "eh_30fa222ec5523dcc",
      "identity": "sha256:30fa222ec5523dcc0f12be9e8de34b50b47f1fd9395d04d630e7a97a8b274e71",
      "kind": "narrative",
      "page": 5,
      "quote": "Statistical analysis\nWe conducted all analyses according to the intention-to-treat principle,\nwhere all patients were included in the analysis as they were randomized.\nFor the analysis of the primary outcome, we built a Kaplan-Meier graph\nwith a log rank P-value to test for a difference between early surgery and\ncontrol intervention at a two-sided α value of 0.05 and used a Cox propor\ntional hazards model to derive hazard ratios (HRs) with 95% confidence in\ntervals (CIs) for treatment effect estimation.\nTime-to-event secondary outcomes were analysed using the same meth\nods applied for the analysis of the primary outcome. For MACE, all-cause\ndeath, HF hospitalization, and cardiovascular death, we repeated the ana\nlysis as described above restricted to a 3-year follow-up, with complete",
      "source_id": "source_7f7b055eb93e03bcd72c8fe32984a531050e324a0b58555dbc9701c8b3e2d5e7",
      "source_version": "sha256:a890f771fd05ebda4edada403fa59475add7dfa13409e53bbca7f38407265ae3",
      "start": 808,
      "start_line": 13,
      "trial_id": "banovic26-avatar-2024"
    },
    "src": {
      "declared_role": "main_article",
      "id": "source_7f7b055eb93e03bcd72c8fe32984a531050e324a0b58555dbc9701c8b3e2d5e7",
      "label": "ehae585.pdf",
      "logical_path": "ehae585.pdf",
      "media_type": "application/pdf",
      "origin": "local_dossier",
      "page_count": 10,
      "projection_hash": "sha256:a890f771fd05ebda4edada403fa59475add7dfa13409e53bbca7f38407265ae3",
      "role": "main_article",
      "sha256": "sha256:844778e139c06d130531978d4d574f575a3a2bc078d2cc0fb407746abeff7bf5",
      "trial_id": "banovic26-avatar-2024"
    }
  },
  {
    "basis": {
      "evidence": "sha256:7961ea6680167af2b56d24aa7a11a26f7a8d663d778579792b179efef84de4b0",
      "kind": "context",
      "source": "Avatar trial protocol\n-Amendment to surgical delays-\n\n\nAortic Valve Replacement Versus Conservative Treatment in\nAsymptomatic Severe Aortic Stenosis (AVATAR trial)\nNCT number : NCT02436655.\nDate of amendment: 04.01.2021"
    },
    "ev": {
      "end": 219,
      "end_line": 8,
      "handle": "eh_7961ea6680167af2",
      "identity": "sha256:7961ea6680167af2b56d24aa7a11a26f7a8d663d778579792b179efef84de4b0",
      "kind": "narrative",
      "page": 1,
      "quote": "Avatar trial protocol\n-Amendment to surgical delays-\n\n\nAortic Valve Replacement Versus Conservative Treatment in\nAsymptomatic Severe Aortic Stenosis (AVATAR trial)\nNCT number : NCT02436655.\nDate of amendment: 04.01.2021",
      "source_id": "source_43321397d4087181f02a8d4c4efa651b92ee599bac4192a6784e12dd0bbfdcd9",
      "source_version": "sha256:ba0a932949980d33e88502105917caa5b9b14037acc62aa12c8b2f14b6deb8b3",
      "start": 0,
      "start_line": 1,
      "trial_id": "banovic26-avatar-2024"
    },
    "src": {
      "declared_role": null,
      "id": "source_43321397d4087181f02a8d4c4efa651b92ee599bac4192a6784e12dd0bbfdcd9",
      "label": "Current registry-linked sap: SAP_000.pdf",
      "logical_path": "registry_documents/4fe2c40400a1b76a/SAP_000.pdf",
      "media_type": "application/pdf",
      "origin": "registry",
      "page_count": 2,
      "projection_hash": "sha256:ba0a932949980d33e88502105917caa5b9b14037acc62aa12c8b2f14b6deb8b3",
      "role": "sap",
      "sha256": "sha256:a0a89920266b027b4795d68ce4811b14b5ebbcf5b42a8811185edf55ffe34c54",
      "trial_id": "banovic26-avatar-2024"
    }
  }
]

Without ARBITER: Time to death was a prespecified secondary endpoint with a registered 5-year time frame. It was analysed with a single Cox model, and the SAP amendment only addresses COVID-19 delays. I found no sign of selective reporting. A small concern is that the extended follow-up was a later analysis, but it matches the registered time frame.
