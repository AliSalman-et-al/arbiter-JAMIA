# Visual review: Figures 1–2

This is an agent’s walkthrough from the perspective of a clinician unfamiliar with ARBITER, not a clinician user study. This final review supersedes the earlier table-crop/annotation layouts. I opened every final PDF-derived TIFF tile at 4×, both 174 mm print-size proofs, the complete greyscale/deuteranopia/protanopia/tritanopia sheets, and the actual report screenshots.

## Clinician walkthrough

Figure 1 starts with reports and registry records and gives me a clear division of work. I choose a trial/outcome and approve the result. The AI model reads and answers; the rule-based server stores the sources, checks quotes and applies RoB 2 rules. Small grey labels show two real tools per phase, including the four labels restored after the cramped revision. The primary action text remains readable without understanding the tool names. The reviewer receives two concrete outputs: the yellow audit file and the framed HTML report. The source report view is recognizably a real web page, with five domain-navigation results and the first domain card; it is no longer a giant sparse table row. The two output arrows clear their targets and the caption names both deliverables.

Figure 2 has distinct header bands. I first learn the comparison, death outcome and population; the next lines explain RoB 2 and the answer abbreviations. The evidence key shows actual yellow, grey and dashed boxes, with not-needed hatching. Sources stored has its own heading and four uncluttered cards. Folded-page icons identify the two reports; a register icon identifies ClinicalTrials.gov; the amendment has a marked document. Fingerprints and their explanation are removed. They were implementation detail rather than necessary clinical context.

Every domain reads across the same five aligned columns: a plain question, source snippets, the AI answer and contextual verbatim excerpt, recorded answer chips, and the RoB 2 result. The wider model column and larger primary text make complete subjects and conclusions easier to follow. The software header explains its role once; there are no repeated per-row quote-check or Official RoB 2 rule sentences duplicating the result. All five domain frames and the Overall frame have the same weight. The robot icon and model subtitle identify its role in interpreting evidence. Source/page labels are centred in their fixed-width tabs. The full official wording remains in eTable 31.

For baseline differences, the model’s excerpt names the one-year age difference before its chance interpretation. The diabetes numbers and full-width counter-evidence remain visible. For deviations, the first source excerpt now shows symptom onset and AS progression from the same recorded Table 3 evidence; the other three snippets show delayed surgery/COVID, symptom-triggered referral and physical/phone visits. The AI explicitly says that crossover from conservative care to surgery (35/79) was driven by protocol-defined indications. The clinical-risk qualification and the unknown reasons for declining surgery remain on their own lines.

For missing data, the model’s quoted clause says 1/157 (0.6%) has incomplete outcome data, instead of a fragmented numeric label. For measurement, Yes and Probably no remain distinct and the dashed inference names its subject: “All-cause death … involves no judgement”. D5 shows all four context snippets and ordered verbatim clauses naming the published protocol and explaining that it is not captured and the report statements are not dated before unblinded data. Its unknown remains explicit. The heavier 5.1 chip and deciding-question note identify the recorded driver without making the whole D5 frame heavier. Its result is Some concerns; the Overall rule remains because it explains aggregation. The footer reports all-trial quote checking once and ends naturally with independent verification, without a status-style “: verified”.

## Final visual findings

I checked all source letters/page tags, new icons, quote punctuation, line endings, answer labels, all 22 active/inactive chip positions, uniform domain borders, deciding chip, counter-evidence/open points, result-column alignment, Overall and footer. No clipping, stroke/text collision, broken glyph, stray hatch or orphan word remained. Cuts at tile boundaries are inspection crops, not figure clipping. The earlier stale PDF hatch coordinate was corrected and rechecked. Figure 1’s report frame has a continuous outer stroke and the native screenshot text is not stretched.

Both print-size views remain readable. In greyscale and all three CVD simulations, outlines, dashes and hatching preserve the evidence distinctions; the actual report retains tick/exclamation redundancy. The output cards remain distinguishable by labels and shape when colour changes.

## Evidence and limits

Figure 1 was inspected in nine tiles (r1–r3 × c1–c3), Figure 2 in twelve (r1–r4 × c1–c3). These 21 tiles cover the full final 600-dpi TIFFs at 384 pixels/in, equivalent to 4× at a 96-dpi view. Both 658-pixel-wide final-size proofs represent 174 mm at 96 dpi.

The report is the actual exact-run-build render. Raw and product-name-only HTML copies, substitution counts, byte-replay assertions and a full diff are retained. The final thumbnail is a native responsive AVATAR trial-page crop of domain navigation and the first domain card, not the batch page’s summary table. The trial page has no summary table; the full trial-page and batch-table screenshots remain in QA. No HTML/CSS layout was edited. Figure 1 has one required raster screenshot, while its diagram and text remain vector with embedded Fira fonts. Figure 2 is entirely vector. The only content omissions/shortenings are documented, ordered verbatim excerpts; no evidence identity, answer or judgement changes.

- Figure1: 174 × 125.0 mm; minimum diagram text 7.0866 pt; zero geometry violations; minimum text/stroke clearance 0.6852 mm. SVG/PDF/PNG, embedded fonts and 600-dpi LZW TIFF passed.
- Figure2: 174 × 225.5 mm; minimum diagram text 7.0866 pt; zero geometry violations; minimum text/stroke clearance 0.37 mm. SVG/PDF/PNG, embedded fonts and 600-dpi LZW TIFF passed.
- Figure 2 primary questions/AI text: 7.5118 pt; three type sizes maximum. Report thumbnail minimum: 7.0753 pt.
- All seven geometry fixtures passed with unchanged clearance thresholds.
- 75 text-provenance rows; every semantic source/AI/software/result row string is asserted and matched to the final SVG. All 16 archived evidence identities/source bindings, all 22 answer positions, counter-evidence and unknowns, domain/Overall results and log-derived counts passed.
- Legacy-name and jargon guards passed in the scene, final SVG and extracted PDF text. No displayed fingerprints remain.
- 38 artifacts were byte-identical across two builds.
- Figure1 inspected TIFF SHA-256: `8f0e4671e7434bac4a400f1a59b71dbeda3d41643605a09a6869f3777165c222`.
- Figure2 inspected TIFF SHA-256: `e21197be3e55e01e8d0edfe54633d2a77f3de66980c29a3ac105c7bce3100e5f`.
