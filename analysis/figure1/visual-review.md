# Figure 2 polish verification, 2026-10-18

Figure 1 is unchanged byte for byte. Figure 2 now uses identical bold-title/grey-subtitle baselines in all three lanes, one baseline for the evidence and branching keys, equal-size evidence-key pills, pale-blue D1–D5 chips, and a fixed right-hand judgement column. Complete server answer blocks are vertically centred to the left of right-pointing arrows. Domain and Overall judgement chips share the same x coordinate. Evidence and agent text remains top-aligned. The bundle facts form two aligned lines; the filename is right-aligned. Unassisted D4/D5 use measured inline positions, snug orange flags, an adjacent closing quotation mark and a consistently indented Registry continuation. Scientific excerpts and answer patterns remain archive-asserted.

## Automated results

| Layout | Height, mm | Minimum type, pt | Geometry checks | Violations |
|---|---:|---:|---:|---:|
| Figure1 | 107 | 7.23 | 4,162 | 0 |
| Figure2 | 224.25 | 7.09 | 27,767 | 0 |
| Figure2-without-unassisted | 201.75 | 7.09 | 24,780 | 0 |

All widths are 174 mm. Across the three layouts, 56,709 geometric checks pass with zero violations. Minimum Figure 2 text/stroke clearance is 0.335 mm (gate 0.3 mm); minimum arrow-tip/text clearance is 2.755 mm (gate 0.8 mm). The geometry gate retains exact bundled-font glyph bounds, stroke thickness, conservative continuous inference-outline envelopes and curve sampling ≤0.0375 mm. SVG paint definitions are excluded from scene obstacles; the actual hatched-chip outlines remain checked. No geometry thresholds were relaxed. Both Figure 2 variants satisfy the strengthened ≤225 mm target, within the requested ≤230 mm limit.

Inactive questions use a genuine SVG diagonal pattern: light-grey diagonal lines over a very-light-grey fill, grey number text and a solid grey outline. PDF export repeats diagonal vector lines clipped to the same rounded chip geometry before drawing text; it does not depend on SVG-pattern support in the PDF converter. The hatching is a background fill, not slash characters or a dashed outline. Dashed outlines exclusively identify inference.

Seven geometry regression fixtures pass. `verify.py` completed two builds with 36 byte-identical artifacts. Vector-only PDFs, embedded bundled Fira TrueType fonts, SVG/PDF `rob2` legacy-name guards, archive/source hash assertions, minimum 7 pt type and 600-dpi LZW TIFF checks all pass. Figure 1 exports and proofs have no Git changes relative to 4f8ed13.

Bundle facts remain seven captured and hashed sources, 16 evidence records, 15 answered signalling questions, seven not asked, independent verifier verified. The archived domain patterns and Overall Some concerns decision are unchanged. The verifier remains the archived structural/binding receipt.

## Complete TIFF inspection at 4×

After the final double build, `inspect_tiffs.py` tiled the entire PDF-derived 600-dpi TIFFs at 384 px/in (4× final size on a 96-dpi display). All 30 tiles were opened and inspected at original dimensions: six Figure 1 tiles, 12 Figure 2 tiles and 12 without-Unassisted tiles. `visual-inspection.json` records the final TIFF hashes, source dimensions and complete crop bounds. Adjacent tiles were read together across split text.

| Tiles opened | Inspection |
|---|---|
| Figure1 r1c1–r1c3, r2c1–r2c3 | Accepted reviewer/agent/server/bundle layout, approval bend, tool labels, arrows and borders; unchanged. |
| Figure2 r1c1–r1c3 | Parallel headers, single key baseline, D1 metadata/quote/unknown, hatch key and D1 answer block → aligned Low. |
| Figure2 r2c1–r2c3 | D2 and D3 metadata, quoted evidence, question/answer/justification text, complete branching patterns and hatch-filled chips. |
| Figure2 r3c1–r3c3 | D4 DSMB quote, both emphasized answers, inference clearance/dashes, D5 report/registry context and Some concerns column. |
| Figure2 r4c1–r4c3 | D5 context ending, aligned Overall chip, two-line bundle strip/filename, inline D4/D5 flags, closing quote, Registry continuation and D5 footer. |
| Without-Unassisted r1c1–r1c3 | Same parallel headers/keys and D1 evidence, agent text and centred server block. |
| Without-Unassisted r2c1–r2c3 | Complete D2/D3 cards, full server patterns, hatching, horizontal arrows and shared judgement column. |
| Without-Unassisted r3c1–r3c3 | D4 metadata/quote/justification/inference, complete server pattern and aligned Low; D5 card beginning. |
| Without-Unassisted r4c1–r4c3 | D5 context/justification and complete server pattern, D5/Overall aligned Some concerns, bundle facts/filename and footer. |

No clipped text, colliding borders, missing answer chips or misplaced arrows were found. The hatch fill is visibly diagonal in the independent PDF-derived TIFFs and agrees with the SVG encoding. All judgement chips share their left edge in the right-hand sub-column; the widest Some concerns chips finish near the lane edge. D4/D5 inline flag padding and quote proximity are consistent with the clearance gate. Row heights follow the tallest cell, so shorter evidence or server content retains only the space required by its neighbour.

Both Figure 2 final-size proofs, greyscale proofs and deuteranopia/protanopia/tritanopia diagnostics were opened and inspected. Labels, solid outlined active chips, diagonal hatching and dashed inference remain distinguishable without relying solely on colour. CVD transforms are approximate RGB diagnostics. The legend, alt text and provenance notes describe the diagonal hatch fill and shared judgement column. No requested work remains incomplete.
