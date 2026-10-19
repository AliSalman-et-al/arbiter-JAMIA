# WP-M round 2: manuscript revision (orchestrator review of draft 1)

Draft 1 is accurate and well disciplined. All 302 number tokens trace, the citations are honest and the length is 3,291 of 4,000 words. Revise `docs/manuscript/manuscript.md`, `references.md` and `verify-numbers.py` only. Re-run `verify-numbers.py`. Do not commit.

## A. Correct the story where the data contradict it (most important)

1. **The Unassisted arm is a minimal-prompt condition**, not "the typical prior design". Its prompt was the task sentence plus an output-format sentence, with no RoB 2 guidance (`no-kit-sonnet-5.5/README.md`). Several prior studies used structured RoB 2 prompts (Lai 2026; Taneri 2025; Gandhi 2026; Huang 2025).
   - Methods: describe the Unassisted arm exactly as above.
   - Delete "mirroring the typical prompted design in prior work".
   - Optionally add that its agreement with published labels was modest, like the agreement reported in prior studies. Do not quote a numeric range, because the metrics differ.
   - Limitations: add a sentence saying no structured-prompt comparator was tested. Because ARBITER's skill carries RoB 2 guidance, the contribution of guidance cannot be separated from that of the software.
   - Discussion, rules-only paragraph: say the answer differences may reflect the guidance and the workflow together.
   - Keep the claim at system level.

## B. Schimel structure

2. **Paraphrase the message; never paste it.** The same five-sentence block appears verbatim in the abstract Conclusion, the Objective and the Discussion opening. Each location needs its own wording:
   - **Objective:** the question and hypothesis only, with no results. Remove "Every ARBITER rating follows… this was the design aim tested".
   - **Discussion opening:** 2–3 sentences giving the principal finding and its meaning.
   - **Abstract Conclusion:** 1–2 sentences.
3. **End the Background on the question.** Its last paragraph should close with the explicit Challenge question, along the lines of: "Whether a workflow that enforces the rules and checks the evidence changes the answers a model gives, and whether stricter model ratings are errors or corrections, has not been tested against blinded adjudication." Keep one "to our knowledge" sentence. Delete the defensive sentence "This bounded claim concerns the combination; each component has precedents." The preceding paragraph already credits the precedents.
4. **Abstract**, at 250 words or fewer:
   - **Results:** add the rules-only finding (3 of 62 changed) and the question 5.1 finding (18 losses; supplied documents never mentioned). Keep the strictness and primary numbers.
   - **Discussion:** 2–3 interpretive sentences. Stricter ratings were mostly upheld, so agreement with published labels misleads as a benchmark. The gain came from the answers, not the arithmetic. The cells were selected on disagreement.
   - **Conclusion:** 1–2 sentences.
5. **Remove the lay summary.** JAMIA does not require one, according to your own check.
6. **Results:** move "Human checking time was not measured" to the Discussion cost paragraph.
7. **Limitations:** split into two paragraphs.
   - Design and attribution: system-level claim, no structured-prompt comparator, single run, possible training exposure.
   - Reference and measurement: selection on disagreement, forced choice, unaudited agreed cells, broad or mismatched labels, small strata, Overall not adjudicated, quotation support not assessed.
8. Remove the full stop at the end of the title.

## C. Housekeeping

9. **eTable citation order.** Methods cite eTable 3 (AVATAR) before eTables 1–2. List in your final message the order in which each eTable and eFigure is first cited, so the pipeline can renumber the supplement. Do not renumber anything yourself.
10. Keep every other hard rule from `WP-M-manuscript.md`. Report word counts again.

## Final message

Report:

- what changed for each item above;
- the new abstract, in full;
- word counts;
- the verify-numbers result;
- the first-citation order of supplementary items.
