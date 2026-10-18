# Figure 2 visual review — 18 October 2026

Reviewed the final 174 × 229 mm figure after the last build, rather than the superseded lane grid. Figure 1 is final: its four exports, six proofs, legend and alt text were checked byte-for-byte against HEAD and remain unchanged.

## Reference and print-size assessment

Read the PI’s STYLE-REFERENCE.md first and opened all 20 distinct images cited there. The implementation follows the book’s sequence lifelines (000166), black numbered badges (000191–193/000097), dark-tab evidence tags (000143), soft reasoning box (000168/000203), curved italic annotations (000014/000171), and paired trajectories/person header (000230/000226). A uses a top source tab to fit the full filenames; B uses the compact left tab.

Viewed qa/Figure2-final-size.png at its 658-pixel width, representing 174 mm on a 96-dpi display. This is a screen-based print-size assessment, not a physical paper proof. In the first five seconds, the reader sees two named actors and a downward numbered path in A; the mint check/algorithm block ends in the filled Some concerns pill. B reads as a compact summary with a conspicuous aligned judgement column: four Low outputs, then D5 and Overall Some concerns. C reads as two opposing trajectories: blue ARBITER → Some concerns → check, orange Unassisted → Low → cross. The main distinction between model proposal and server computation is visible before reading the long excerpts. The evidence locators and handles reward closer reading; they are not the first visual layer. A carries most of the detail and remains denser than a book illustration because the requested verbatim provenance occupies real space, but the six badges supply a single path. C’s registered-time-frame claim stays contiguous across two lines inside one Thought box.

## All 600-dpi TIFF tiles at 4×

Source TIFF SHA-256: 9ccbb6b70f6f77d78a2a4a7859196895d0c623c92b508a53af0462df8c09456c. Source is 4111 × 5410 pixels at 600 dpi, LZW. inspect_tiffs.py resamples to 384 dpi for 4× final size on a 96-dpi display and tiles the entire image into four rows by three columns. All 12 final tiles were opened individually after the last build. Exact crop bounds and hash are in visual-inspection.json; no area is omitted.

- r1c1–r1c3: actor labels, document glyphs, count, payload/tool pills, first two numbered messages and the first evidence tag. Clear glyphs, clean arrowheads, no clipping or crossings through labels.
- r2c1–r2c3: registry tag, both reasoning sentences, save/citation payload, both displayed handles with +2, check block and hash prefixes. Grey highlights identify context, the gap sentence is plain italic, and the mint block makes server computation visible. No text reaches outlines.
- r3c1–r3c3: return judgement, two curved annotations, review/export, B headers and D1–D4 rows. Tool pills have visible separation; answer numbers remain legible; hatch fill does not erase inactive question numbers; output pills align.
- r4c1–r4c3: D5, Overall, and both complete trajectories. Real tool names and counts are readable at 4×, the orange flag stays within the Thought box, outputs align, check/cross have distinct geometry, and both footer notes remain inside the frame. Words split across tile boundaries are intact in the full TIFF.

## Proofs and objective checks

Opened the final greyscale, deuteranopia, protanopia and tritanopia proofs. Labels, black contours, hatching and check/cross shapes retain the content when role colours converge. The outcome remains encoded in both words and shape. Direct-support yellow and context grey converge in greyscale, so evidence-type colour should be interpreted with the legend and source content; no answer or judgement depends on that hue distinction. CVD proofs are diagnostic full-severity RGB approximations.

The geometry gate reports zero violations across 136 text elements, 148 shapes and 18 arrow tips. Minimum text/stroke clearance is 0.36 mm (threshold 0.3); minimum arrow-tip/text clearance is 2.465 mm (threshold 0.8). Nothing lies outside the 174 × 229 mm frame; no pill or text overlaps. Minimum type is 7.0866 pt. PDF is vector, has embedded Fira fonts and no raster images; TIFF is 600-dpi LZW. SVG and extracted PDF text pass the legacy-name guard. Seven geometry regression fixtures pass; two final builds produce 27 byte-identical artifacts.

## Scientific and attribution review

Both displayed D5 passages were returned by read_pages toolu_01F15hTxheM7WBgGMfE4mYpa during D5; the request used four windows. The tag spans are saved evidence, not the wider read windows. The accepted 5.1 answer cites four handles; two appear with +2. Panel C explicitly uses selected whole-trial unique-call counts (15 context, 14 page-read, seven save calls), including failures and retries. Its marks indicate agreement/disagreement with adjudicators’ consensus preferred D5 judgement Some concerns. Published and Unassisted D5 are Low. No adjudicated Overall is claimed. All exact quotations, official question order, answer patterns, hashes, labels and archived verifier status are asserted at build time. Full trace: eTable 31.

Display adaptations are documented in DEVIATIONS.md: top source tabs in A, count labels stacked beneath tools in C, a ten-word D4 phrase retaining the full assessor group, and omission of close_trial from the compact export step. No scientific-content or dimensional-gate deviation. The obsolete without-Unassisted variant and its ten QA/export files are removed.
