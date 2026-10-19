# WP-M: manuscript prose (first full draft)

## Read first

1. `ANALYSIS-PLAN.md` section 7, "Story (Round 14)". This is the specification: OCAR, the message sentence, claim discipline, the landscape wording rules, the adjudication process, the Limitations additions, title, abstract order and Discussion order.
2. `GLOSSARY.md`, the reader-label table. Internal names never appear: no kit, no-kit, rob2-kit, meta label, Haiku or Sonnet, except that Methods name the model ID once.
3. `analysis/output/manuscript/results-sentences.md`, `figure-legends.md` and Tables 1–4. All numbers come from here or from `analysis/output/tables/*.csv`.
4. `docs/research/llm-rob2/SYNTHESIS.md` and `docs/research/ai-rob-landscape/SYNTHESIS.md`, which supply the citations and the related-work framing. Also read `analysis/data-curated/prior-work-comparison-notes.md`.
5. `analysis/round14-report.md` and `analysis/DEVIATIONS.md`, for which analyses are post hoc and why.
6. JAMIA author instructions for Research and Applications articles. Look them up online and record the URL and access date in the draft's front-matter notes. Follow the current limits: structured abstract headings and word limit, main-text word limit, required statements (lay summary if required, funding, competing interests, data availability, author contributions) and the reference style.

## Write

Write only `docs/manuscript/manuscript.md`. Also write `docs/manuscript/references.md`: the numbered reference list, each entry with a DOI verified to resolve to that title. Write nothing else.

## Writing standard

The story follows Schimel (*Writing Science*): OCAR, with the message sentence leading the abstract conclusion, the last paragraph of the Introduction and the first paragraph of the Discussion. Each paragraph has one job, and its first sentence says what that job is. Give findings first and support after. Use plain, active, short sentences. Figures and tables are cited as supporting actors, as in "(Figure 5)". Never narrate the figure.

**Section-by-section plan:**

- **Title:** exactly as in section 7.
- **Abstract:** JAMIA structured headings. Results in the section 7 order. The conclusion is the message sentence. No composite-reference results.
- **Background and significance (Opening, then Challenge):**
  1. RoB 2 matters, and it is slow and unreliable among humans (Minozzi 2020/2021; Hartling 2019; Zhang 2024). Evidence-synthesis bodies require oversight and transparency for AI (Flemyng 2025; RAISE).
  2. The lineage: RobotReviewer (Marshall 2016, *JAMIA*) linked ratings to sentences. LLM studies on RoB 2 report modest agreement and stricter ratings, and read that strictness as error (Nyrhi, ROBoto2, Gandhi, Taneri, Lai). Restrict this claim to RoB 2.
  3. Partial fixes exist: rules applied after the fact (Huang; Choi; ROBoto2); quotations checked after the fact (Liang); agents for other tools (Saadi); executable guideline logic in informatics (CPGPrompt). The field asks for purpose-built expert references (Eisele-Metzger 2025; Sahu 2026).
  4. The gap is the combination: rules and evidence checks as the route to every rating, plus a test of the published reference where it is disputed.
- **Objective:** one paragraph, ending with the message sentence in hedged, objective form.
- **Materials and methods (Action):**
  - System design (Fig 1) and worked example (Fig 2).
  - Benchmark: eTable 1, label-to-result matching, De Waal disclosure.
  - Arms: the unassisted arm mirrors the typical prior design. Input parity. Model ID, effort, harness, dates, ARBITER version. Both prompts quoted or referenced in eMethods.
  - Reference standards: published labels, then adjudication exactly as described in section 7 (no AI; independent rating frozen first; three labels in randomised order; no rationales shown). Cite Gartlehner 2025 as the design precedent.
  - Endpoints:
    - primary: the share of adjudicated disagreement cells where the adjudicators preferred ARBITER;
    - secondary: agreement with published labels, direction of disagreement, independent-rating agreement, rule consistency, audit metrics, runtime and cost;
    - post hoc analyses, labelled as such.
  - Statistics: stratified trial-cluster bootstrap, seed and B; no p-values.
  - Reporting: TRIPOD-LLM and GRRAS.
- **Results (Resolution):** steps R1–R7 in section 7 order, built from `results-sentences.md`. One paragraph per step. Every number is identical to its source.
- **Discussion:** points 1–9 from section 7 in that order. Table 4 is cited in the comparison with prior systems. Limitations are complete, per section 7. The Conclusion is two sentences.
- **Back matter:** placeholders in [square brackets] for author names, affiliations, funding, competing interests and contributions. Do not invent any of these. Data availability follows `ANALYSIS-PLAN.md` section 8 and the results.html plan.

## Hard rules

- **Never invent a number, a citation or an author detail.** Every number must exist in the committed outputs.
- Write `docs/manuscript/verify-numbers.py`, which extracts every number token from `manuscript.md` and checks each against the output CSVs, results sentences and tables. Run it, and list any number it cannot trace.
- Respect the word limits. Report the word count of each section.
- Never use "first", "over-flagging", "supported by evidence", "accuracy" (for the primary endpoint), "second reviewer", "unchangeable" or "tamper-proof". Write "to our knowledge" where novelty is implied.
- Do not commit.

## Final message

Report:

- section word counts against the JAMIA limits, with the URL used;
- the verify-numbers result;
- every placeholder left for the authors;
- every citation whose DOI you could not verify;
- any place where the story spec and the data seemed to conflict.
