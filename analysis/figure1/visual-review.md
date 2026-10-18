# Visual review: Figures 1–2

This is an agent’s walkthrough from the perspective of a clinician unfamiliar with ARBITER, not a clinician user study. I inspected the actual PDF-derived 600-dpi TIFFs in all 21 tiles at 4× final size, both 174 mm print-size proofs, the two complete greyscale/CVD proof sheets, and the relabelled HTML trial page and summary-table screenshots.

## Clinician walkthrough

Figure 1 tells me who does what. I choose the trial and outcome and approve the result to assess. The AI reads reports and answers questions; the mint server stores the sources, checks quotes and applies the official rules. The server also writes the HTML report. The yellow audit-file lane describes the retained record and its independent check. I receive both an HTML report and an audit file. The large framed crop below is an actual report table for AVATAR, with readable trial title, death outcome, effect estimate and domain/Overall results. The caption connects that concrete output to the workflow. I can read the primary action labels without needing to understand the small grey tool names.

Figure 2 first identifies the trial, comparison and all-cause-death outcome, then explains what RoB 2 is asking. Answer abbreviations occupy one key row. The next row shows the actual evidence swatches: an outlined yellow box, grey box and dashed box, plus light not-needed hatching. Four source cards occupy their own line, with a fingerprint explanation below. The fingerprints identify stored copies; they are not opaque clinical evidence themselves.

Each row reads left to right across the same five columns: domain/question, cited source passages, AI answer and verbatim justification excerpt, server checks/answer chips/official rule, result. Question numbers allow me to find the full official wording in eTable 31. Ellipses show that the AI reasons are excerpts. The model’s clinical interpretation is confined to its column. The ARBITER column states only quotation checking, the recorded answers and the official rule outcome; it does not invent a second clinical explanation.

For baseline imbalance, I see the baseline table and diabetes figures, the AI’s “compatible with chance” excerpt, and the recorded counter-evidence. For deviations, all four snippets remain visible; the AI cites protocol-defined indications and the COVID-19 emergency. The Weighed against line retains the clinical-risk qualification, and the Open point retains the unknown reasons for declining surgery. These remain visible even though the answer is Probably no.

For missing data, the AI’s 1/157 (0.6%) excerpt explains the Yes answer. For measurement, the unblinded-assessor passage supports Yes, while a separate dashed inference box carries the verbatim “involves no judgement” excerpt for Probably no. Its absence of a quotation is explicit.

D5 has four grey context snippets and a clear open point about the dated protocol. “No dated source therefore specifies this measurement and analysis” is the AI’s own recorded wording. No information flows through the complete NI/PN/PN answer pattern to the recorded official-rule result, Some concerns. The heavier 5.1 chip and deciding-question line identify the recorded driver. The heavier D5 frame draws attention without an empty band or an intrusive annotation arrow. Overall uses the same aligned result column. The footer explains the HTML report and independently verified audit file, and identifies the published/expert D5 judgements without implying that Overall was adjudicated.

## Findings corrected during this pass

- Replaced handwritten clinical summaries in the software column with fixed mappings of recorded rule IDs, supported by file/line citations to all five official algorithms. Asserted the D5 driver and the Overall trace.
- Replaced model paraphrases with ordered verbatim excerpts. Added a trace CSV covering every semantic source/AI/software/result row string, counter-evidence and open point, and checked those strings against final SVG aria-labels.
- Removed all three curved annotation arrows and moved their explanations to the legend. Kept icons only for AI model and ARBITER in the column headers. The evidence key now uses visual swatches as requested.
- The first PDF tile review caught a stale hatch coordinate: the not-needed key’s hatch strokes appeared above the inference key while its own box was blank. Corrected the PDF hatch record to the actual key rectangle and reopened all final Figure 2 tiles. The hatch is now inside the box in SVG and PDF, with no stray decoration.
- Inset the report-table screenshot inside its browser frame so it does not cover the dark outer edge. Reopened all final Figure 1 tiles; the frame is continuous.
- Low result pills are white with heavy outlines, matching the style reference; Some concerns remains pale blue. Overall is in the same result column.
- Inspected source tabs, source letters/pages, fingerprints, all chip/hatch positions, quote punctuation, justification excerpts, counter-evidence/open points, rule labels, 5.1 outline, result pills, footer and figure edges. Tile-boundary cuts are inspection crops, not figure clipping. No remaining collision, stray stroke, broken glyph or orphan word was found.

## Actual inspection and limits

Figure 1: nine tiles (r1–r3 × c1–c3). Figure 2: twelve tiles (r1–r4 × c1–c3). These were generated at 384 pixels/in from the final 600-dpi TIFFs, equivalent to 4× at a 96-dpi view. Both final-size proofs are 658 pixels wide, representing 174 mm at 96 dpi. Greyscale, deuteranopia, protanopia and tritanopia sheets preserve the evidence distinction through outlines/dashes/hatching; the report table retains tick/exclamation redundancy when colours change. Both print-size views remain readable.

The exact run-build HTML render succeeded. Both raw and product-name-only copies are retained, with counts, byte-replay assertions and a full diff. I opened the relabelled AVATAR trial-page screenshot and the actual table crop. This build places its summary table on the one-trial batch page, not the trial page, so that is the crop used in Figure 1. The separate trial-page screenshot remains in qa/avatar-html-report.png. No HTML was restyled. Figure 1 contains exactly one raster image; all diagram text remains vector with embedded fonts. Figure 2 is entirely vector. This is the documented exception required for a real browser thumbnail.

- Figure1: 174 × 125.0 mm; minimum diagram type 7.0866 pt; zero geometry violations; minimum text/stroke clearance 0.6425 mm. Embedded Fira fonts; SVG/PDF/PNG and 600-dpi LZW TIFF passed.
- Figure2: 174 × 228.375 mm; minimum diagram type 7.0866 pt; zero geometry violations; minimum text/stroke clearance 0.37 mm. Embedded Fira fonts; SVG/PDF/PNG and 600-dpi LZW TIFF passed.
- Report thumbnail: minimum captured font 7.4007 pt.
- Seven geometry regression fixtures passed; all thresholds retained.
- 80 provenance rows; source/AI/software/result strings are asserted, including final semantic SVG text. All 16 archived evidence identities/source-version bindings, 22 answer positions, counter-evidence and unknowns, domain/Overall results, published/expert labels and log-derived counts passed.
- Legacy-name/jargon guards passed in scenes, final SVG and extracted PDF text (source fingerprints remain permitted).
- 36 artifacts were byte-identical across two builds. The final TIFF hashes and complete tile coverage are in visual-inspection.json.
- Figure1 TIFF SHA-256: `c40d0d72ad97c50a7dedba7ed9a1437c267d4e95736a39cbc361d7619a9f2b91`.
- Figure2 TIFF SHA-256: `7bbd34fa64d870333959e940428c00751b8a6a59f1d980e02ed004ba7eb123ab`.
