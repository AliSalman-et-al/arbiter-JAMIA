# Visual review: Figures 1–2

Reviewed the actual vector-PDF-derived 600-dpi TIFFs at 4× final size and the 174 mm print-size proofs. This is an agent's clinician-perspective walkthrough, not a clinician user study.

## As a clinician who has never heard of ARBITER

**First:** I read AVATAR's population, early surgery versus watchful waiting, and all-cause death. The next line tells me that RoB 2 asks questions about risk of bias. The answer key defines Yes/Probably/No information and the hatching. The evidence key explains quotation support, context and reasoning. I do not need to know an AI tool or software term before starting.

**Second:** I read each domain row from left to right. The full domain name and ordinary question tell me the clinical issue; the small number lets me locate the official question. I can compare the paper or registry words with the model's answer. The software header explicitly says “rule-based software, no AI”. Its cells tell me that quotations were found, record an unresolved point about allocation staff, show why three deviations questions are unnecessary, and separate evidence of assessor awareness from reasoning about death recording. I can distinguish the model's answer from the filled risk-of-bias result. Every question position is present; hatching has an explicit key.

In the expanded final row, “prespecified” by itself does not establish a dated plan for this analysis. The registry quotation names death within a combined outcome. “No information” explains the missing documentation; it does not guess that the analysis was fixed in advance. The NI/PN/PN chips lead to a plain rule and Some concerns. I then read the Overall rule and its adjacent Some concerns pill. The curved-arrow notes reinforce that the software computes ratings and checks quotations.

**Third:** I read the orange Without ARBITER strip. The same model gave every domain Low and made an uncited registered-time-frame claim. The comparison identifies both adjudicators' Some concerns judgement, with a check for ARBITER and a cross for Without ARBITER; the published review was Low. The legend makes clear that these marks compare the consensus preferred D5 judgement, and that the verifier checks audit structure/evidence rather than clinical correctness. Finally I see that the audit can be independently checked.

## What I would not understand, and fixes made

- “Low” initially left the object implicit. Added “Results describe risk of bias” beside the RoB 2 introduction.
- Grey D5 evidence could lose its role in greyscale. Added “context” to both source labels, so that meaning is also written in words.
- The Overall output initially sat below its sentence. Aligned its pill with the Overall rule.
- Early geometry review found crowded quote/branching chips. Shortened the allocation quotation using only ellipses, placed question number and answer together inside each chip, and adjusted row spacing. No font size or clearance threshold was reduced.
- The printed registry term MACE remains inside a verbatim quotation; its own expansion (“Major Adverse Cardiac Event”) is shown. The AI reason uses the ordinary term “combined outcome”. All remaining codes have keys. Official wording and the full trace belong in eTable 31, as explained by the legend.

Figure 1 now reads as a division of responsibilities: the reviewer chooses and approves, the model reads and answers, the software stores/checks/applies rules, and the audit file retains the record. Technical calls are visually secondary in grey. The source glyph and approval connector are clear; no red rejection arrow appears.

## Actual inspection

Opened all 20 unique book reference images in an indexed contact sheet: 000166, 000191, 000192, 000193, 000097, 000143, 000168, 000170, 000203, 000202, 000037, 000230, 000226, 000228, 000139, 000098, 000014, 000171, 000172 and 000188. Used the lavender model block, mint software block, document/actor line glyphs, filled results, highlighting and italic curved-arrow notes.

Opened all six Figure 1 tiles (r1–r2 × c1–c3) and all twelve Figure 2 tiles (r1–r4 × c1–c3), derived from the 600-dpi TIFFs at 384 dpi, equivalent to 4× final size at a 96-dpi view. Inspected lettering, quotation punctuation, chip answers/order, hatching, borders, icons, rule text, bottom strip, footer and margins. Tile cuts through text are crop boundaries, not clipping in the figure. After the last wording changes, reopened the four changed tiles (Figure2 r1c1, r1c2, r3c1, r3c2); the other fourteen tile files remained byte-identical. Reopened the final Figure 2 print-size proof. Figure 1's final render was unchanged after its six-tile review.

Viewed both complete print-size proofs and greyscale/deuteranopia/protanopia/tritanopia sheets. Information remains readable through words, hatching, outlines and check/cross shapes. Context is also labelled in words. No clipping, overlapping text, broken glyphs, accidental collision or ambiguous answer-key mapping remained. The final TIFF hashes and complete crop coverage are in visual-inspection.json.

## Final gates

- Figure1: 174 × 107 mm; minimum type 7.0866 pt; geometry passed with zero violations; minimum text/stroke clearance 0.5263 mm and arrow/text clearance 1.8447 mm. Vector PDF, embedded Fira fonts, PNG/SVG and 600-dpi LZW TIFF passed.
- Figure2: 174 × 230 mm; minimum type 7.0866 pt; geometry passed with zero violations; minimum text/stroke clearance 0.4775 mm and arrow/text clearance 3.4725 mm. Vector PDF, embedded Fira fonts, PNG/SVG and 600-dpi LZW TIFF passed.
- Seven geometry regression fixtures passed. No geometry thresholds were relaxed.
- Bundle/manifest hashes, every displayed ordered quote, answer/branch, domain/Overall result, both Without ARBITER CSV exports, quoted run-log claim, consensus adjudicators and Published D5 assertions passed. D5's rule was checked against the scientific-pack algorithm and evaluator.
- Figure 2 reader-facing jargon guard passed for the scene and extracted PDF; both figures passed the legacy rob2-name guard.
- 27 artifacts were byte-identical across two independent builds. Frozen rejection audit/log-derived counts were retained and AVATAR log hashes rechecked.
- Final Figure1 TIFF SHA-256: `9e1279ebab43d0f80cceeb6b51faf34b305dae501bb54cc6250cd122e39e8ebc`.
- Final Figure2 TIFF SHA-256: `e9b8f4e812f533f7aa592583f1fb1adc5d8a5de514844847c958d97841be5f61`.
