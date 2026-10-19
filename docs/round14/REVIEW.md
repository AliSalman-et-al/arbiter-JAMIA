# Round 14 review log (orchestrator)

## WP-T review, 2026-10-19

**Verdict:** accepted, with revisions to apply when WP-A is revised. They are held until then because WP-A is reading the CSV schema.

The curator's citation corrections were verified against PubMed esummary:

- The JMIR 2026 first author is Lai YJ.
- The Saadi DOI is `10.1136/bmjdh-2026-000034`.

`docs/research/llm-rob2/SYNTHESIS.md` has been corrected.

Revisions requested:

1. **The input-parity column is ill-defined for single-arm studies.** Prior studies compare one model against a reference, so "parity between arms" does not apply to them. Rename the column for display to "Registry or protocol given to the model". Keep a separate footnote saying that only this study gave both compared arms identical inputs. Re-check each cell against that definition.
2. **"Partly" needs a definition per column, in the table notes.** Example: "Agent with tools — Partly: web browsing in a chat interface, or a retrieval pipeline, without an agent calling tools." Gandhi's browsing and Liang's retrieval should read that way.
3. Keep "Not reported" (NR) distinct from "No" in the display. Define both in the notes.
4. Footnote 3 on ARBITER ("overrides permitted; none occurred") stays.

## WP-A round 1 review, 2026-10-19

**Verdict:** accepted and committed as the round-2 baseline. Every preliminary number reproduced. Invariance holds over 7,303 cells, 571 tests pass, and the release scan finds zero Haiku matches. I inspected Figures 4 and 5 and Tables 2 and 4.

Revisions for round 2, added to `WP-A2.md`:

1. **Fig 4B "post hoc" label.** The direction-of-disagreement counts were pre-specified, as the old Fig 5B in the 2026-10-18 plan. Only the CIs are new. Remove "Post hoc" from the axis title. The legend says the intervals were added post hoc. The results sentence drops "in the post hoc analysis". Record the reasoning in DEVIATIONS.
2. **Rules-only results sentence is misleading.** "Unassisted wins changed from 7 to 10" hides the fact that the 3 changed cells became ties with ARBITER. Rewrite along these lines: "3 of the 62 disagreements changed, each to ARBITER's rating, which the adjudicators had chosen; the other 59 were unchanged." Apply the same framing in the eTable title and footnote.
3. **R2 needs the strictness fact.** Add to the R2 sentence that, where a model disagreed with the published label, it was usually the stricter rating: ARBITER 88 of 124 and Unassisted 69 of 115, the `all_n` values from the direction table. Recompute these in the pipeline.
4. **R6 wording.** "every quoted text record was linked to its stored source" becomes "every quotation was found in its content-hashed stored source". Rule breaks are 0 "by design".
5. **Table 4:**
   - Restore the "Rule breaks measured" column. It is in the CSV and is a key difference between the studies.
   - Replace the DOIs in the notes with reference callouts, such as `[ref: Eisele-Metzger 2025]` placeholders, for the manuscript reference list.
   - Shorten the notes.
   - Title: "source verification" becomes "quotation checks".
6. **No "Sonnet" in reader-facing main text or tables.** Table 2's note says "at least one Sonnet arm", and Table 4 note j says "510 Sonnet domains". The model is named in Methods only, per the GLOSSARY label table.
7. **Rejected saves (53/637) in the protected Figure 1 legend have no committed source.** If the committed bundles record rejected saves, derive the count reproducibly into `data-derived/`, and test it. Otherwise flag the number for the authors to source or remove. Do not edit Figure 1.
8. **Fig 5 post hoc rows.** Show the ARBITER / Unassisted / neither counts, like the upper rows: 44/1/0 and 10/6/1. Recompute these.
