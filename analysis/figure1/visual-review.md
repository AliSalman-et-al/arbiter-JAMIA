# Fine-detail figure verification, 2026-10-18

All requested defects were corrected. Figure 2 uses cubic callouts, heads aligned to their terminal tangents, 1.05 mm target clearance, separated highlighter rows, padded punctuation-inclusive orange outlines, and complete question–answer units. D4 4.4 clears the inference box; fitted dash runs join solid corners. Figure 1's red return stays in the agent/server gap, phase arrows are separated, and approval has one orthogonal bend. Scientific wording and `legends-fig1-2.md` are unchanged.

## Automated results

| Layout | Text/stroke pairs | Box pairs | Arrow/text pairs | Arrow/box pairs | Frame elements | Text/text pairs | Violations |
|---|---:|---:|---:|---:|---:|---:|---:|
| Figure 1 | 2,322 | 21 | 756 | 98 | 97 | 1,431 | 0 |
| Figure 2 | 9,266 | 1,770 | 452 | 240 | 197 | 6,328 | 0 |
| Without Unassisted | 5,183 | 1,176 | 292 | 196 | 146 | 2,628 | 0 |

Total: 32,599 checks, zero violations. Minimum text/stroke clearance: Figure 1 0.5263 mm, both Figure 2 layouts 0.3591 mm. All callout tips have 1.05 mm glyph-box clearance (threshold 0.8 mm). Geometry includes stroke thickness and solid arrowheads; glyph extents come from the bundled font outlines. Intentional nesting of layout containers is allowed; pill-within-pill overlap is rejected. Dashed paths are tested as continuous stroke envelopes, conservatively. Curve sampling intervals are at most 0.0375 mm; this is numerical geometry, supplemented by rendered inspection.

Seven regression fixtures pass: clear own-container text; text crossed by stroke; overlapping nested pills; tip near text; tip penetrating an unrelated box; frame overflow; text/text overlap. `verify.py` runs these before rebuilding twice. All 36 export/audit/proof artifacts are byte-identical. Every layout passes vector-only PDF, subset-embedded Fira fonts, the `rob2` legacy-name guard in SVG and extracted PDF text, and 600-dpi LZW TIFF checks. Minimum type is 7.23 pt in Figure 1 and 7.09 pt in both Figure 2 layouts.

Widths remain 174 mm. Heights are now 125, 289 and 276.75 mm respectively; more height preserves clearance and readable type. The without-Unassisted alternative has full SVG/PDF/PNG/TIFF exports. No unresolved collision was found.

## Rendered inspection

The entire three 600-dpi TIFFs were tiled, with no omitted area, into 39 crops sampled at 384 pixels/inch: 4× final size on a 96-dpi view. Each crop was opened at original pixel dimensions (about 877 × 630–875 px). `visual-inspection.json` identifies the exact TIFF bytes and crop rectangles; `inspect_tiffs.py` recreates the local PNGs. Grid coordinates below refer to those filenames (`r` row, `c` column), top to bottom and left to right. Region boundaries sometimes split a word; adjacent tiles were inspected together. The final arrowheads were rechecked after shortening shafts beneath the heads.

| Figure 1 crop | Region checked |
|---|---|
| r1c1 | Reviewer icon/labels, Capture header and reviewer/agent lane edges |
| r1c2 | Phase headers, approval box, horizontal approval connector, agent headings |
| r1c3 | Approval vertical drop and label, Review/export header, right reviewer/agent borders |
| r2c1 | Agent left labels, Capture request arrow, server top edge |
| r2c2 | Capture/proposal/assessment request-response pairs and tool/response labels |
| r2c3 | Assessment/export arrows, red return/head and rejection label, server top edge |
| r3c1 | Server left labels and bottom edge, Bundle label and left borders |
| r3c2 | Server phase content/separators and bundle description |
| r3c3 | Server right border, export-to-bundle arrow, bundle filename/right border |

| Figure 2 crop | Region checked |
|---|---|
| r1c1 | Evidence key, D1 chips/question, source-card edge, quote-row gaps, justification and Unknown label |
| r1c2 | Inference key corners/dashes, D1 answer/hash, Bound-span arc/head, quote ends and unknown text |
| r1c3 | Unassisted header, D1 answer units, rationale and right border |
| r2c1 | Recorded-gap tip, D2 chips/question/source/justification, branching target/head, row edges |
| r2c2 | Recorded-gap circle/label, D2 answer/card border, Branching arc/circle/label |
| r2c3 | D1/D2 right borders, complete D2 question–answer units, D2 rationale |
| r3c1 | D3 chips/question/source, quote rows and justification; D4 chips/question/source |
| r3c2 | D3 answer/card ends/row border; D4 answer and first quote line |
| r3c3 | D3 Unassisted answers/rationale; D4 4.3 NA outline, separator spacing, intact 4.5 NA |
| r4c1 | D4 review./events. pills, 4.4 question/answer, inference left corner/dashes, D5 chips/question/source |
| r4c2 | D4 justification/Probably-no clearance, inference upper border/text, D5 answer/hash/context pill |
| r4c3 | D4 allocation comma/padding and note, inference right corner; D5 registered-time-frame period/outline |
| r5c1 | D5 second source/context/justification/gap, algorithm target/head, adoption line, Overall/footer left |
| r5c2 | D5 source/quote ends, Algorithm arc/circle/label and adoption line; Overall chip/footer centre |
| r5c3 | D5 Unassisted note/borders, verifier text and right footer |

| Without-Unassisted crop | Region checked |
|---|---|
| r1c1 | Evidence key, D1 chips/question, quote-row gaps, justification, Unknown label |
| r1c2 | Inference key, D1 answer/hash, shortened Bound-span arc/head, quote and unknown text |
| r1c3 | D1 right card/row border, quote end, unknown text end |
| r2c1 | D1/D2 left row borders, D2 question/source/quote/justification, branching target/head |
| r2c2 | D1/D2 middle row borders, D2 answer/card, Branching circle/label |
| r2c3 | Recorded-gap arc/head/circle/label, D1/D2 right row/card borders |
| r3c1 | D3 chips/question/source/quote/justification and D4 chips/question/source |
| r3c2 | D3 answer, long quote, card/border and D4 question |
| r3c3 | D3 quote/card/row right edge and D4 card/row right edge |
| r4c1 | D4 quote/justification, 4.4 question/answer, inference left corner; D5 chips/question/source |
| r4c2 | D4 quote/justification ends, Probably-no clearance/inference text; D5 answer/context/source |
| r4c3 | D4 quote/justification punctuation, inference right corner; D5 card/row right border |
| r5c1 | D5 second quote/justification/gap, algorithm target/head, adoption line; Overall/footer left |
| r5c2 | D5 quote/justification ends, Algorithm arc/circle/label and adoption line; Overall chip/footer centre |
| r5c3 | D5 card/row right border; Overall/verifier/footer right |

All three layouts' final-size, greyscale, deuteranopia, protanopia and tritanopia proofs were inspected. Written evidence-type labels, dashed inference borders, answer chips and author flags remain identifiable. CVD transforms are approximate RGB diagnostics. Independent PDF TIFFs supply the fine-detail inspection rather than relying solely on the resvg previews.
