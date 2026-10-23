# Final local release checks — 23 October 2026

PASS for the manuscript and publication package; author declarations remain pending.

- Numerical audit: zero untraced tokens; 2787 main words, 232 abstract; figures/tables cited in order.
- Independent scientific review: PASS. Editorial required clarification implemented; senior-author disposition recorded separately.
- Word visual proof: all 22 pages inspected, pages 1–11 by parent and 12–22 by independent Sol reviewer. Tables remain whole; no blank pages.
- Source invariance: 106 fixed study/display sources unchanged against the recorded baseline. HTML refresh independently preserved all 155 protected artifacts.
- Provenance: all 79 nonempty main display CSV values occur in standalone tables and both manuscript formats; three embedded Word tables equal standalone tables cell-for-cell. Results and supplement HTML equal finalized Word source cells; all 241 original trace cells remain in Supplement.docx.
- Publication tests: nine Pages tests and five manuscript tests PASS. Presentation contract PASS. Full staging: 50 files, 54 resolving local links.
- Browser: Chrome fallback used after two T3 preview snapshot timeouts (`Preview automation snapshot timed out after 15000ms.`). Final manuscript, results and supplement each have one title, no broken images and no body overflow at desktop 1440px or mobile 390px. Parent inspected title, representative native tables and mobile captures. Long trace tokens now wrap; wide tables scroll within their containers. This is not a new visual audit of every unchanged supplementary table or figure.
- Entry points: both full R pipeline and presentation-only R builder invoke the finalized-source HTML refresh before manuscript HTML. No statistical code or analyses were rerun. Full R execution was not tested because the environment lacks its R dependencies; the invoked Python/Quarto refresh and manuscript path completed successfully.
- No shared skills were edited. Reflection improvements were applied to this project's source-authority handoffs and separate provenance/format verification.

These local checks precede deployment. The deployment manifest verifier compares every published byte with the staged package; its evidence is recorded separately after publishing.
