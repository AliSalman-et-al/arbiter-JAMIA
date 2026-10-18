# Visual review: Figures 1–2

This is an agent's walkthrough from the perspective of a clinician unfamiliar with ARBITER, not a clinician user study. Reviewed the actual 600-dpi PDF-derived TIFFs at 4× final size and both 174 mm print-size proofs.

## As a clinician who has never heard of ARBITER

I first learn the population, treatment comparison and all-cause-death outcome. The next line explains that RoB 2 asks questions about risk of bias. Answer abbreviations and hatching have a key. The evidence key names direct support, context and inference. Four source cards tell me which report, registry or amendment I am reading, its year and the fingerprint that connects the snippet to a fixed stored copy. The legend identifies the registry trial and explains the fingerprint without requiring a hashing vocabulary.

Each row reads left to right: the full domain name and plain question; letter/page-tagged snippets; the model's answer and summarized justification; quotation checks, the complete answer chips and rule; and the risk-of-bias result. The model's own reasoning is explicit in its column rather than being mistaken for a software check. Official numbers allow a link to the full questions in eTable 31.

For baseline imbalance, the table and diabetes numbers do not alone prove the answer. I see the model's chance explanation and the recorded counter-evidence that fewer early-surgery patients had diabetes. For departures from treatment, all four cited snippets are visible. The model distinguishes protocol/pandemic changes from trial-driven changes. The Weighed against line acknowledges clinical risk, while the Open point says reasons for declining surgery are not described in detail. Those unresolved facts remain visible next to a Probably no answer.

For missing data, the numerator and denominator explain the Yes answer. For measurement, the unblinded-assessor quote is separate from the dashed inference that death involves no judgement. The Yes and Probably no pills correspond to 4.3 and 4.4, whose answers also appear in the chips.

In D5 I see all four context snippets: the registry's combined outcome, the report's prespecified statement, the analysis method and the surgical-delay amendment. The model explains why these do not establish a dated plan for this analysis. Its Open point names exactly what it could not establish about the published protocol. No information is an explicit uncertainty answer. NI/PN/PN leads through the rule to Some concerns. The overall sentence explains this trial's result, with no domain High. The footer tells me the trial totals, archived verified audit receipt and Published/expert D5 judgements. There is no Without ARBITER strip to interrupt the evidence trace.

Figure 1 presents a clear division of work: the reviewer chooses and approves; the model reads and answers; the server stores, checks and applies rules; the audit file keeps the record. The input curve enters the top of Capture and clears its heading. The reviewer receives the audit file. HTML-report wording is deliberately absent because the required render proof failed on this older bundle's schema; the exact command and error are in qa/html-report-proof.md.

## Findings and fixes

- The initial complete-evidence layout exceeded 230 mm. Kept every cited basis, shortened excerpts with ordered verbatim omissions, tightened chip/rule layout, and sized rows to content. No font or clearance threshold was reduced.
- Explicitly labelled the model column “answer + justification” and checked summary anchors against the full recorded justifications. Full reasoning remains in figure1-notes.md and the audit record.
- Named the actual evidence types: direct support, context and inference (no quote). The greyscale inspection found yellow and grey luminances too similar. Added dark outlines to direct-support snippets and named that redundant cue in the key. Dashed inference remains distinguishable by shape.
- Counter-evidence and open points have bold grey labels, with the recorded text preserved (counter-evidence trimmed with ellipses; unknowns verbatim). Labels remain legible at print size.
- Curved arrows terminate beside a quote-check line, the ARBITER rule column and the No information pill. They clear actual text and borders. The optional fourth annotation was omitted to avoid crowding.
- Lightened hatching behind grey inactive question numbers in both SVG and PDF. Numbers are readable at 4× and print size.
- Removed tall empty header boxes, repeated rule labels below Low results, the comparison strip and empty D5 bottom space. All five headers share bold text and small vector icons.

## Actual inspection

Opened all six Figure 1 tiles (r1–r2 × c1–c3) and all twelve final Figure 2 tiles (r1–r4 × c1–c3), generated from the final TIFFs at 384 dpi, equivalent to 4× at a 96-dpi view. Reopened the full final Figure 2 tile set after adding direct-support outlines and full domain names. Checked source letters, page tags, fingerprints, snippet punctuation, all answers and hatching, model reasons, counter-evidence/open points, arrow endpoints, rule text, result pills, footer and margins. Tile-boundary cuts are crops rather than figure clipping.

Opened both complete print-size proofs. Viewed greyscale, deuteranopia, protanopia and tritanopia sheets for both figures; reopened the final Figure 2 sheet after the outline fix. The redundant outline/dash/hatch cues preserve meaning without colour. No clipping, overlap, broken glyph, ambiguous question-key mapping or stray border collision remained. Figure 1 did not change after its complete six-tile and colour-proof review.

## Final gates

- Figure1: 174 × 107 mm; minimum type 7.0866 pt; geometry passed with zero violations; minimum text/stroke clearance 0.5263 mm and arrow/text clearance 1.8447 mm. Vector PDF with embedded Fira fonts, SVG/PNG and 600-dpi LZW TIFF passed.
- Figure2: 174 × 229.75 mm; minimum type 7.0866 pt; geometry passed with zero violations; minimum text/stroke clearance 0.4475 mm and arrow/text clearance 1.5369 mm. Vector PDF with embedded Fira fonts, SVG/PNG and 600-dpi LZW TIFF passed.
- Seven geometry fixtures passed. All thresholds are unchanged.
- All manifest hashes, all 16 proposal/archive evidence identities and source_version bindings, ordered displayed snippets (≤15 words), basis kinds, selected answers, all 22 question positions, recorded unknowns/counter-evidence, domain/Overall results, Published/expert labels and log-derived audits passed. Historical comparator CSV/log assertions are retained even though the comparison strip is removed.
- Scene and extracted-PDF jargon/legacy-name guards passed; fingerprints are the permitted six-character source-version prefixes.
- 27 artifacts were byte-identical across two builds. Final TIFF hashes and complete tile coverage are recorded in visual-inspection.json.
- Final Figure1 TIFF SHA-256: `ec6ff0b05633331a06a363d32f026664ed298c95397cd81485a92f3e17d6a125`.
- Final Figure2 TIFF SHA-256: `9398d079e286d96466021276e5be1b08b5e58431432f896724ff8351f1cdeac0`.
- HTML-report proof: failed at ARBITER 1.0.0 finalization.py:4472 (legacy manifest schema). No report screenshot or HTML-output wording is claimed. See qa/html-report-proof.md. This is the required fallback, not a relaxed gate.
