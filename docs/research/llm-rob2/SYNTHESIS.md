# Synthesis: LLMs and Cochrane RoB 2 (search through 19 October 2026)

Sources: eight full-text extraction files in this folder (`w1`–`w8`), built by following `BRIEF.md`. Every number below is from those files, which quote section and table locations. Where full text was not read, that is stated.

## 1. Evidence map

| Study | Tool, sample | How domain ratings were produced | Rules checked in code? | Evidence handling | Reference | Disagreement adjudication | Direction vs reference |
|---|---|---|---|---|---|---|---|
| Eisele-Metzger 2025 RSM (Claude 2) | RoB 2, 100 RCTs | Model stated them | Overall rule only, by authors: 2/100 broke it | None | Cochrane labels, called "imperfect" | Unblinded review of extreme discrepancies | κ 0.10–0.31 by domain |
| Huang 2025 JMIR | RoB 2, 46 RCTs | Model stated them; authors also derived them from model answers in Excel | Partly: derived ratings compared, departures not counted | Rationales only | 3 trained reviewers and Cochrane, compared with each other | None | Derived ratings: D2 adhering 55%→95%, Overall adhering 70%→90% against reviewers |
| Lai 2026 JMIR | RoB 2, 29 RCTs | Decision trees written into the prompt; model followed them | No | Rationales only | Cochrane; "not definitive or immune to error" | Error categorisation only | Sensitivity fell and specificity rose across runs |
| Nyrhi 2026 EBioMedicine (preregistered) | RoB 2, 100 RCTs from high-impact meta-analyses; 4 LLMs | Model stated them | No | None | Published labels as gold standard | None | Every model shifted to Some concerns or High; authors call this "overly stringent" |
| Nagao 2026 AJP (abstract only) | RoB 2, 180 RCTs | Full algorithm in the prompt | Not reported | Not reported | Published labels | None | D5 weakest |
| Gandhi 2026 PLoS One | RoB 2, 50 RCTs from 50 meta-analyses | Model, with signalling logic in the prompt | No | None | **Masked 3-person panel re-rated all trials** | Panel internal consensus only | High risk: published 12%, panel 22%, o3 34% |
| Taneri 2025 CESM | RoB 2, 84 RCTs | Model, after signalling-question prompts plus a consistency prompt | No | None | Cochrane labels | None | 36.5% of "Some concerns" escalated to High |
| Choi 2026 J Evid-Based Pract (pilot) | RoB 2, **1 RCT**, 38 runs | Model (Gemini) and ROBoto2 | **Yes: algorithm coded; conformance 43%, 51% and 60%** | ROBoto2 retrieval | 1 expert (3 transcription errors caught by the rule check) | None | — |
| ROBoto2, Hevia 2025 EMNLP demo | RoB 2, 521 trials | **Flowchart applied in code** after the model's answers | By design; no rate reported | Retrieved passages, human edits stored | Expert annotations, κ 0.40 between annotators | None | LLMs "overly conservative" |
| Liang 2026 JMIR AI | RoB 2, 97 trials, 1 Cochrane review | Model output | No | **Verification after the fact: passages retrieved and claims labelled with verbatim quotes; support 60–65%** | Cochrane labels | None | Binary accuracy 90–98% |
| Šuster 2024 RSM | RoB 2, large corpus | Direct prediction and decomposition | No independent engine | None | Published labels | None | Near trivial baselines |
| Li 2026 BMC MRM | RoB 1 | Model | — | Verbatim evidence extracted, not verified | Checked on a subset | Disagreement between models triggers human review | — |
| Saadi 2026 BMJ Digit Health AI (partial full text) | ROBINS-I, 171 studies | **"Agent-based structured implementations"**; model states the domain rating | Not reported | None | Concordant human teams only | None | — |
| Gartlehner 2025 Ann Intern Med (data extraction, not RoB) | 63 studies, 9,341 items | — | — | Adjudicators checked the source reports | **Human-only extraction not treated as gold** | **Blinded adjudication of discordant items only** | Human-only workflow 11% errors, AI-assisted 9% |

The remaining studies (Rose 2025, Descamps 2025, Kuitunen 2024 and 2025, Barsby 2025, Xiong 2026, Lai 2024, GEPA, RoBIn, RoBGuard) fit the dominant pattern: the model stated the ratings, there was no rule check, no verified evidence and no adjudication, and published or expert labels were the reference. Full text was not read for Nagao, Xiong or Kuitunen 2025, and only partly for Barsby and Saadi.

## 2. Gap verdicts

| Claim | Verdict | Defensible wording |
|---|---|---|
| G1 Algorithm enforcement | **Broad form falsified** (ROBoto2 computes ratings in code; Choi 2026 measured conformance on one trial; Huang derived ratings in Excel). | Prior work computed RoB 2 ratings from model answers after the fact, or inside a human-in-the-loop interface, and one single-trial pilot measured rule conformance. No study has made the official algorithm the only route to a rating, rejected incomplete answers, or measured how often an unassisted model's ratings break the rules across a benchmark. |
| G2 Evidence traceability | **Holds with qualification** (Liang 2026 verifies quotes after the fact; ROBoto2 retrieves passages). | Recent work retrieves passages and checks whether generated claims are supported, after generation. We found none that binds each answer to a quotation verified against a locked copy of the source *before the answer is accepted*, with an audit file that someone else can verify. |
| G3 Reference noise | **Recognised, but not quantified for disagreement cells** (Eisele-Metzger, Sahu, Lai 2026, Gandhi, Nyrhi all acknowledge it; Gandhi used a masked panel; Huang compared Cochrane with reviewers; Hartling 2019 and Zhang 2024 show published labels vary). | The field recognises that published labels are fallible and has called for purpose-built expert references. Studies keep reading LLM strictness as model error, but none has tested which side is right on the cells where they disagree. |
| G4 Blinded adjudication | **Holds for RoB**; precedent in data extraction (Gartlehner 2025). | We found no RoB evaluation that used blinded experts to adjudicate disagreements between models and published labels. A data-extraction study within reviews (Gartlehner 2025) gives the design precedent. |
| G5 Agentic or tool design | **Holds with qualification** (Saadi 2026 agent for ROBINS-I; ROBoto2 pipeline). | Agent-based and retrieval pipelines exist. What is new is an agent constrained by a separate rule-based service that validates answers and evidence, computes every rating, and emits an audit trail that can be verified. |

**Contribution, restated:** not any single element, but making the rules and the evidence checks the only path by which a rating can be produced. This is evaluated against an unassisted model, using blinded adjudication of the disagreement cells as the reference. Avoid "first"; use "to our knowledge" and re-run a dated database search before submission.

## 3. Findings that strengthen our story

1. **Five or more studies report that LLMs rate risk of bias more strictly than published labels.** The examples are Nyrhi ("overly stringent"), ROBoto2 ("overly conservative"), Gandhi (34% High vs 12%), Taneri and Lai 2026. Nearly all read this as model error. Gandhi's masked panel was also stricter than the published labels (22% vs 12%), which agrees with our adjudication. Our blinded adjudication of the disagreement cells tests this directly: when the two arms disagreed, the adjudicators chose the stricter ARBITER rating in 44 of 45 cells.
2. **Taking the rating away from the model already helps in other studies.** Huang's derived ratings improved D2 adhering by 40 percentage points. In Choi's pilot, recomputing ratings raised agreement with the expert. Our 12.8% rule-break rate for the unassisted model is a benchmark-scale measurement of the same problem. Choi's 43–60% conformance came from one trial and different tools, so do not compare magnitudes directly.
3. **The field has asked for a purpose-built expert reference** (Eisele-Metzger 2025 Discussion; Sahu 2026; Eisele-Metzger 2026 response, which notes the cost). Adjudicating only the disagreement cells is an affordable version of that.
4. **Governance asks for auditability.** The Flemyng 2025 position statement and RAISE call for human oversight and full reporting of any AI that makes or suggests judgements. They do not show that auditability improves accuracy, so keep those claims separate.
5. **Agreement can be high while support is low.** Liang 2026: binary accuracy 90–98%, but only 60–65% of claims were supported by the source. This argues that agreement metrics alone cannot establish trustworthiness.

## 4. Opening material

- Minozzi 2020: Fleiss κ 0.16 for overall ratings between experienced raters; 28 minutes per outcome.
- Minozzi 2021: implementation guidance raised agreement but took about 40 hours to build.
- Hartling 2019 and Zhang 2024: Cochrane reviews rating the same trials disagree.
- Pollock 2024: Cochrane's lessons on RoB 2, which call for piloting and full reporting of supporting evidence.
- Laignelot 2026: systematic review across review tasks found only six LLM RoB performance studies, with accuracy ranging 0.44–0.90.

## 5. Citation list

Verify each DOI at reference-manager import.

- Eisele-Metzger A, et al. Res Synth Methods 2025. doi:10.1017/rsm.2025.12
- Sahu V. Res Synth Methods 2026. doi:10.1017/rsm.2026.10073
- Eisele-Metzger A, et al. Res Synth Methods 2026 (response). doi:10.1017/rsm.2026.10102
- Huang J, et al. J Med Internet Res 2025. doi:10.2196/70450
- Lai YJ, et al. J Med Internet Res 2026. doi:10.2196/84915 (first author verified 2026-10-19)
- Lai H, et al. JAMA Netw Open 2024. doi:10.1001/jamanetworkopen.2024.12687
- Nyrhi, et al. EBioMedicine 2026. doi:10.1016/j.ebiom.2026.106238
- Nagao, et al. Am J Perinatol 2026. doi:10.1055/a-2793-9092 (abstract only)
- Gandhi, et al. PLoS One 2026. doi:10.1371/journal.pone.0353155
- Taneri, et al. Cochrane Evid Synth Methods 2025. doi:10.1002/cesm.70044
- Choi J, Swan H, Kim MJ, Kim HJ. J Evid-Based Pract 2026;2(2):91–97. doi:10.63528/jebp.2026.00011 (author list verified 2026-10-19)
- Hevia A, et al. ROBoto2. EMNLP 2025 System Demonstrations; arXiv:2511.03048
- Liang, et al. JMIR AI 2026;5:e93761. doi:10.2196/93761
- Šuster S, et al. Res Synth Methods 2024. doi:10.1002/jrsm.1749
- Li, et al. BMC Med Res Methodol 2026. doi:10.1186/s12874-025-02763-3
- Saadi, et al. BMJ Digit Health AI 2026. doi:10.1136/bmjdh-2026-000034 (DOI corrected and verified 2026-10-19)
- Gartlehner G, et al. Ann Intern Med 2025;178:1763–71. doi:10.7326/ANNALS-25-00739
- Rose CJ, et al. Cochrane Evid Synth Methods 2025. doi:10.1002/cesm.70048
- Minozzi S, et al. J Clin Epidemiol 2020. doi:10.1016/j.jclinepi.2020.06.015
- Minozzi S, et al. J Clin Epidemiol 2021. doi:10.1016/j.jclinepi.2021.09.021
- Hartling L, et al. BMJ Open 2019. doi:10.1136/bmjopen-2018-028382
- Zhang, et al. J Clin Epidemiol 2024. PMC11191165 (DOI to confirm)
- Pollock, et al. 2024, "Ten tips…". PMC11795937 (DOI to confirm)
- Flemyng E, et al. JBI Evid Synth 2025. doi:10.11124/JBIES-25-00480
- RAISE recommendations. doi:10.17605/OSF.IO/FWAUD
- Laignelot, et al. J Clin Epidemiol 2026. doi:10.1016/j.jclinepi.2026.112221

## 6. Open items before submission

- Full text of Nagao 2026 and Xiong 2026, both paywalled; obtain through a library.
- Confirm the DOIs for Zhang 2024 and Pollock 2024.
- Re-run a dated database search the week before submission, for the "to our knowledge" statement.
