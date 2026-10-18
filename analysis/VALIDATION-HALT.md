# Section 5.4 validation halt

The supplied data fail the binding 100% domain-algorithm reproduction gate.
No algorithm was changed to fit the labels. Downstream analysis and manuscript
outputs have not been implemented after this failure.

## Mismatch

- Arm: ARBITER-Haiku
- Trial: hill-2017
- Domain: D1
- Reported judgement: Some concerns
- Official proposed judgement: Low
- 1.1 sequence: no_information (active=yes)
- 1.2 concealment: probably_yes (active=yes)
- 1.3 baseline imbalance: no (active=yes)

The full guidance (22 August 2019), Table 4, printed page 20, maps
1.1=Y/PY/NI, 1.2=Y/PY, and 1.3=NI/N/PN to Low. Its Table 3, printed
page 19, also explicitly permits no information about sequence generation
when allocation concealment is adequate and no problematic imbalance exists.

Source: <https://www.cochrane.de/sites/cochrane.de/files/uploads/RoB_2.0_guidance_2019.pdf>.
Cross-check: <https://github.com/AliSalman-et-al/ARBITER/blob/2f549ae30f056ff441ea61a04b719968716f2219/src/arbiter/logic/evaluator.py>,
`evaluate_domain`, randomization branch. Question mapping is in
`src/arbiter/packs/scientific.py`, `_QUESTION_LOCATORS`, at that commit.
Source code was cloned into the Windows TEMP directory outside this repository.
This is the retrieved source commit, not a verified benchmark-run commit.

All 510 ARBITER-Sonnet domain labels reproduce. Of 505 observed ARBITER-Haiku
labels, 504 reproduce and one differs. The remaining five cells, all domains of
award-1-2014, have missing reported labels and signalling answers, and cannot
be evaluated. Even excluding those five missing cells, reproduction is below 100%.

The guidance permits assessors to override proposed algorithm judgements.
The arm CSVs do not establish whether this mismatch is an intended override,
an export issue or something else. The binding plan nevertheless demands exact
reproduction, so that permission does not authorize bypassing this gate.

## Reproduce

From analysis/, run `Rscript validate.R`. It writes the mismatch, question mapping
and validation summary CSVs before stopping with the gate error. The test suite
also includes an explicit mandatory gate test; that test is intentionally failing
on the unmodified supplied inputs. The other tests check the official branches,
Overall classification, the 102-trial population, baseline count, and exact
154-cell adjudication set and row order.

The baseline-Sonnet exact agreement count is verified as 395/510; adjudication
has 129 consensus and 25 split cells. The 129 consensus cells comprise 62
discordant and 67 arm-agreeing cells; the 25 split cells comprise 18 discordant
and seven arm-agreeing cells. Endpoint estimates, bootstrap CIs, agreement
metrics and Tables 1-4 are not produced at this halt.
