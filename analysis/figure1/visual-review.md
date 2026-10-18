# Lane-redesign visual verification, 2026-10-18

Figure 1 removes the rejection return and its red label; the audited rejection sentence is in the legend. Its paired phase arrows retain at least 5 mm centreline spacing between neighbouring phases, and approval uses one horizontal run plus one vertical drop. Figure 2 implements the agreed Evidence → LLM agent → ARBITER server rows, with pale-grey context, complete official-numbered server patterns, inactive-question hatching, Overall and bundle strips, and only two Unassisted contrasts. No numbered callouts remain.

## Automated results

| Layout | Height, mm | Text/stroke pairs | Box pairs | Arrow/text pairs | Arrow/box pairs | Frame elements | Text/text pairs | Violations |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| Figure 1 | 107 | 2,040 | 15 | 663 | 78 | 91 | 1,275 | 0 |
| Figure 2 | 230 | 13,020 | 3,570 | 1,860 | 1,275 | 255 | 7,626 | 0 |
| Without Unassisted | 206.75 | 11,628 | 3,321 | 1,710 | 1,230 | 242 | 6,441 | 0 |

All widths are 174 mm. Total: **56,340 checks, zero violations**. Minimum text/stroke clearance is 0.5263 mm for Figure 1 and 0.35 mm for both Figure 2 layouts (threshold 0.3 mm). Minimum arrow-tip/text clearance is 1.8447 mm and 2.725 mm respectively (threshold 0.8 mm). There are no overlapping pills, text overlaps, unrelated-box arrow penetrations or out-of-frame elements. The unchanged geometry gate includes actual stroke thickness and solid arrowheads, exact bundled-font glyph extents and conservative continuous dashed envelopes, with curve sampling ≤0.0375 mm. Failures stop export.

Seven geometry regression fixtures pass: own-container text clearance; crossed text; nested overlapping pills; tip near text; tip penetrating an unrelated box; frame overflow; text overlap. `verify.py` then completed two builds with **36 byte-identical artifacts**. Vector-only PDFs, subset-embedded Fira fonts, SVG/PDF `rob2` legacy-name guards and 600-dpi LZW TIFF checks pass. Minimum type is 7.23 pt / 7.09 pt. Explicit height gates retain Figure 1 ≤110 mm, Figure 2 ≤235 mm and the stricter agreed Figure 2 design limit ≤230 mm.

Bundle facts are derived from the archive on each build: **seven sources captured and hashed; 16 evidence records; 15 signalling answers; seven questions not asked; independent verifier verified**. The archived Overall rule is `overall.any_concerns`, with Some concerns adopted. All source metadata and scientific excerpts are asserted. Rejection-audit assertions match the legend: 102 trials, 637 calls, 53 rejected (32 evidence/citation structure; 21 other input errors), followed by successful saves in every affected domain.

## Complete TIFF inspection at 4×

`inspect_tiffs.py` resized the independent PDF-derived 600-dpi TIFFs to 384 pixels/inch and tiled their **entire area**, with no omitted pixels. Each crop was opened at original pixel dimensions, giving 4× final size on a 96-dpi display. There are 30 crops: six for Figure 1, 12 for Figure 2 and 12 for the no-contrast variant. `visual-inspection.json` records the exact TIFF SHA-256 values, source dimensions and every crop bound. Adjacent crops were inspected together where boundaries split text. All regions below were inspected after the final double build.

| Figure 1 crop | Region checked |
|---|---|
| r1c1 | Reviewer icon/text, Capture heading, agent lane left edge and labels |
| r1c2 | Phase headings/arrows, approval box and horizontal connector, agent content/separators |
| r1c3 | Approval drop/head/label, Review/export heading and reviewer/agent right borders |
| r2c1 | Capture arrows, server label/border, bundle left edge and text |
| r2c2 | Proposal/assessment request-response labels, arrow separation, server phase text and bundle centre |
| r2c3 | Export arrows, server right edge, bundle drop/head, filename and right border |

| Figure 2 crop | Region checked |
|---|---|
| r1c1 | Evidence-aligned key, D1 source chip/page/lines/hash, yellow quote rows and card border |
| r1c2 | Agent header, D1 question/answer, labelled linked justification, complete unknown and gutter arrow |
| r1c3 | Server header/key, inactive-chip hatch margin, D1 selected 1.2 chip, full pattern, judgement arrow and Low chip |
| r2c1 | D2 registry/Masking quote, D3 provenance and shortened verbatim quote, D4 source-chip start |
| r2c2 | D2/D3 questions and answer pills, linked justifications including 1/157 (0.6%), D4 4.3 and arrows |
| r2c3 | Complete D2 branching pattern, hatching separated from glyphs, D3 three inactive questions, D4 pattern start |
| r3c1 | D4 DSMB quote and row bottom; D5 report context and registry source-chip/quote start |
| r3c2 | D4 linked justification, 4.4 answer clearance and inference dashes; D5 No information and context justification |
| r3c3 | D4 full pattern with both displayed questions emphasized, Low arrow/chip; D5 NI/PN/PN and Some concerns |
| r4c1 | D5 registry quote end, Overall rule, bundle facts, D4 4.3 NA orange flag, D5 claim and annotation starts |
| r4c2 | Bundle evidence/verifier facts, D4 unblinding quote → invalid path, padded D5 phrase outline and footer |
| r4c3 | Overall chip, bundle filename, strip/right borders and Unassisted footer |

| Without-Unassisted crop | Region checked |
|---|---|
| r1c1 | Evidence key, D1 source identifiers and yellow quote rows |
| r1c2 | Agent header, D1 question/pill/justification and complete unknown |
| r1c3 | Server header/key, D1 full pattern/selected question, arrow and Low chip |
| r2c1 | D1 lower border, D2 registry/quote, D3 provenance/quote and row borders |
| r2c2 | D2/D3 question-answer baselines, labelled justifications and centred arrows |
| r2c3 | D2 full pattern/inactive set, D3 full pattern/three inactive chips, judgements |
| r3c1 | D4 provenance/DSMB quote, lower border and D5 report-context start |
| r3c2 | D4 4.3 and 4.4 pills, justification, inference corners/dashes and D5 question |
| r3c3 | D4 full pattern and Low, both emphasized questions; D5 NI/PN/PN start |
| r4c1 | D5 report/registry context, Overall rule, bundle facts and Published footer |
| r4c2 | D5 linked justification, bundle evidence/verifier facts, Adjudicators footer |
| r4c3 | D5 Some concerns, Overall chip, bundle filename/right edge and Unassisted footer |

No collisions, clipped text, ambiguous answer wrapping or misplaced arrowheads were found. Highlighter rows have separated fill boundaries. Source metadata remains distinct from quotes; context grey no longer competes with agent lavender. Hatching stays in a reserved chip margin and does not cross numbers. Heavy outlines identify the selected questions clearly. The two Unassisted flags have padded, unfilled orange borders. The no-contrast variant preserves the same row/column geometry, bundle and footer.

All three final-size proofs, greyscale proofs and deuteranopia/protanopia/tritanopia diagnostic views were opened and inspected. Written headers, answer labels, heavy selected-question outlines, hatched inactive chips and dashed inference remain identifiable without relying solely on colour. The CVD transforms are approximate display-RGB diagnostics. The independent PDF-derived TIFF tiles supply the fine-detail inspection rather than relying only on resvg previews. Obsolete Figure 1/2 QA renders from the older designs are removed; unrelated figures’ proofs are unchanged.

No unresolved visual defect or deviation from the agreed dimensional targets remains. The extra PDF/SVG/TIFF exports for the no-contrast PNG are retained for reproducibility. See `DEVIATIONS.md` for quote trimming and scientific scope, and `figure1-notes.md` for complete provenance.
