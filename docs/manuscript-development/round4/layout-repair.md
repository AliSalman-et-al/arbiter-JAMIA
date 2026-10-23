# Round 4 layout diagnosis and rebuild

23 October 2026. **Neither A1 nor A2 is supported by the original rendered evidence. No layout repair was warranted.** Read proof-a.md, proof-b.md, the complete assembler and the documents skill. No scientific prose, references, statistics, standalone tables or protected figures were edited. No nested agents, commits, push or full R build.

## A1 assessment

Opened original PNGs 2, 5, 6, 8, 11 and 12 individually at original detail (1547 × 2002), using `/tmp/arbiter-r4-proof/page-N.png`. The alleged compressed passages remain uniformly spaced in those original images. Extracted PDF text baselines with managed Python pypdf `PdfReader` / `extract_text(visitor_text=...)`; coordinates below are PDF text-matrix y values in points, measured upward from the page bottom. Also checked Poppler `pdftotext -bbox-layout` line/word bounds independently. Bounding-box tops are not baselines.

| Alleged passage | Original PDF baselines | Interval |
| --- | --- | --- |
| p2 Materials and Methods | 628.45, 603.15, 577.85, 552.55, 527.25, 501.95 | 25.30 pt throughout |
| p5 Both arms received | 313.20, 287.90, 262.60, 237.30, 212.00, 186.70 | 25.30 pt throughout |
| p6 Two blinded experts | 289.85, 264.55, 239.25, 213.95, 188.65, 163.35 | 25.30 pt throughout |
| p8 Published-label comparisons | 642.80, 617.50, 592.20 | 25.30 pt throughout |
| p8 Exploratory analyses before continuation | 160.40, 135.10, 109.80, 84.50 | 25.30 pt throughout |
| p11 Agreement gains | 668.10, 642.80, 617.50, 592.20 | 25.30 pt throughout |

OOXML corroborates this: all cited paragraphs use Body Text or First Paragraph, each with `w:spacing w:line="480" w:lineRule="auto"` (double spacing). There are no manual `w:br` breaks or local line-spacing overrides in these passages; ordinary prose is a single text run, apart from the abstract's bold label run. Abstract paragraphs intentionally have 4 pt space after; Body Text inherits 9 pt space before, producing 34.3 pt paragraph transitions rather than 25.3 pt within-paragraph intervals. These different paragraph/line gaps are expected. The earlier model/command paragraph on p6 includes a distinct inline code font with slightly larger line metrics; it does not establish compressed spacing in the expert paragraph. No OOXML cause for A1 exists in the alleged passages. Any apparent compression in a displayed preview cannot establish a document defect against these measurements; its display-side cause was not determined.

## A2 assessment

The original p12 label reads exactly `Image regions linked to their page`, wrapping before `page`. Its first rendered line occupies x=63.00–188.49 pt; `14/14 (100%)` occupies x=266.25–326.24 pt; `Not available` occupies x=373.30–431.07 pt. Thus the first/second text gap is **77.76 pt**, and the second/third text gap is **47.06 pt**. Both are ample. No overlap, boundary crowding or clipping is visible. The second/third boundary was measured independently rather than accepted as a defect.

The assembler already sets the label cell's end margin to 900 twips (45 pt), with a 3817-twip cell width. Numeric/availability cells have 70-twip start/end margins and widths 1587/2098 twips. The existing margin accounts for the deliberate wrap and large label/value separation. It was retained. No new manual line break, width, padding, font or text change was introduced.

## Rebuild and provenance

Successfully ran the documents artifact marker exactly once, immediately before the first authoring/build command, with managed Node, `--operation-kind edit --expected-output-count 1 --output-format docx`.

Used `/home/ali/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/bin/python3` with `ARBITER_PYTHON` set to that same path to run `scripts/build-manuscript.py`. The script regenerated HTML and assembled only the main manuscript (`--main-only`); no R analysis, supplement or standalone table build ran. Assembler source remained byte-identical to the task-start snapshot.

Rendered the rebuilt Word with that managed Python and `/home/ali/.codex/plugins/cache/openai-primary-runtime/documents/26.1011.51657/skills/documents/render_docx.py analysis/output/manuscript/Manuscript.docx --output_dir /tmp/arbiter-r4-final-proof --emit_pdf`. The renderer uses bundled `/home/ali/.cache/codex-runtimes/codex-primary-runtime/dependencies/native/libreoffice-headless/libreoffice/program/soffice`; no system/desktop LibreOffice was invoked. Output: **24 pages**, unchanged page count.

Compared every original/final PNG SHA-256: **24/24 identical; zero changed pages**. This binds the final render to proof A's individual original-detail coverage of pages 1–12 and proof B's corresponding coverage of pages 13–24. A1/A2 are superseded by the diagnosis above; other visual coverage is retained. This task independently inspected original pages 2, 5, 6, 8, 11, 12 and final pages 12 and 13 individually at original detail. Final p12→13 transition is clean: Discussion has two lines before its normal continuation; table, notes and runtime paragraph remain intact. The p11→12 transition was inspected through original pages 11/12, with the process paragraph complete before Table 3. No changed-page inspection was omitted, since there are no changed PNGs. This is managed LibreOffice proof, not native Microsoft Word proof; separate protected figure artwork was not re-reviewed.

The rebuilt DOCX differs from its task-start version only in `docProps/core.xml`; every other ZIP member is byte-identical, including document.xml and styles.xml. Exact top-level paragraph text and every embedded table-cell text also compare equal. The DOCX package hash changes due to regenerated core metadata/ZIP packaging, without a rendered or content change. Task-start hash comparison across docs, scripts and analysis/output found only Manuscript.docx changed before writing this report; canonical prose/reference files, assembler, standalone tables, figures, statistics and protected outputs retain their task-start bytes. Existing unrelated dirty work was preserved.

## Validation

All commands exited zero:

- `docs/manuscript/verify-numbers.py`: 328 numeric tokens; 208 output-traced, 120 non-result/editorial, **0 untraced**; 3368 main words, 225 abstract words; citation/display ordering passed.
- `ARBITER_CHECK_BUILT=1 scripts/test-manuscript.py`: **8 tests passed**.
- `docs/manuscript-development/verify-release.py --documentary-updates docs/manuscript-development/round3/documentary-updates.json`: PASS; 101 historical sources unchanged, 5 approved documentary updates preserved, 22 references in first-use order, 79 display CSV cells in both formats, all 3 embedded Word tables equal to standalone, 5 figures with alt text.

Logs retained in `/tmp/arbiter-r4-layout-{build,render,numbers,tests,release}.log`. Original/final render paths and task-start snapshots are QA evidence, not new publication deliverables. Prior round4/final-hashes.json remains a historical pre-rebuild manifest and was not rewritten by this task; use the current hashes below for the rebuilt Word.

## SHA-256 record

- Task-start Word: `d2eca0afec3ad530198f01020e5607ab1703ff37807db065d1a6193e828e5287`
- Rebuilt Word: `7dc0bd818f8c8a85d097e61ba23f6315f64c09c523c893c337da8519a9df6915`
- Unchanged assembler: `33f89d5a749dc6a7f913bf9d62786040832b20c1f5718b8b495695fd76579797`
- Original PDF: `c5feb181417501b6c22c6b554e25436056e39c92349e51fd309f752071878252`
- Final PDF: `7121a9a94849344619e2505dfa8ecee0dc0f0195d112575469605e4f46da6410`

Every row records the SHA-256 shared by original and final PNGs. Paths: `/tmp/arbiter-r4-proof/page-N.png` and `/tmp/arbiter-r4-final-proof/page-N.png`.

| Page | Original = final SHA-256 |
| --- | --- |
| 1 | `e7add0d3d33191d09545351c2df005c8855b51cddd77def5c33da3b246d38740` |
| 2 | `12eb461156e6b79e51d817cc8b61328b641e5b767f03e6e41ed4475d139646eb` |
| 3 | `d42212b4baae8de28a2ef5f56201f27e433e7f9ad4174154bd44b22eb6c29302` |
| 4 | `54ef58ec4968ebd329f742ee154b3b16a659752fa80d58a290710603e193abdb` |
| 5 | `5c23bde78c0899cae93c90ad01a91dad8ed22f34a189c131ea590e4288d09ab0` |
| 6 | `107c44ca2d8ea0a70d95cc969462c2f0e1210c27f837b8d9ed08f049e26b4885` |
| 7 | `6d1573e1573b7bb2e519dfb50a68c2c8683e14bc83ca4cf713df12ac0a92735f` |
| 8 | `94601ccc64ff37c3465c9a7252e57f7642cbee8ca470034d16f93fa6331f8b96` |
| 9 | `718dff91c889b7b939887db5e0311cc729f1d18d2c6dc074cc741c50151ff99a` |
| 10 | `c7a1f098bc1570ad94bbc11100dd5760d02940336e7f145adba1c5b247da6144` |
| 11 | `33540ff73a3f17a64754abe62df3d38f75b9c9be2a9e67134540cd0deef1e6e2` |
| 12 | `810a8bed16d34b7816e56e4f74c559989dd22d2b77a124951be03b0ac51cb868` |
| 13 | `fa8821f89915b831f57ed55364457bf61cb3260fd18b23f3d835d524a3961d67` |
| 14 | `0279fc03e623c6e00f1e61ca9aba01d840612f58d0f419f9d89df50c152df101` |
| 15 | `5280b2e4cd069a59130259e3e69034f0b537cc852c4db92064443e594e5fb50b` |
| 16 | `4ca3bca537f32fd7d6fbf2b824f0f2b61eb8fd7a4b976391fb9035bfbdb43572` |
| 17 | `7c027bfcef47d327454c34942a68d9c245bea7c443da3a74d830ecba4a479623` |
| 18 | `9149b4ae20de272aa534e85dc69a1b5896a2e30e81c631843bc90cf99f8ac4c6` |
| 19 | `6da1361bb74820744391516bc2eda2ca8f36ec63c50db592e8c851833cf9cb23` |
| 20 | `157be0ab377e10449fb45f88e01b374c1b22f3de057c73245de71a613c9b9467` |
| 21 | `718c71eabf7cb7512f49cbb5ef87855c9022131e50400c54e37bb49ad4a328d2` |
| 22 | `994735ac87a8708022db05ef3b7438c5914f2ad8dc32cd8e0dd95156816bc289` |
| 23 | `54b38ceea617eaa6ad18fc7f0e5e9de2ca1e43e8f73c113a70000ab6b9f51f08` |
| 24 | `787600159b31cc3b27132a571a59355e723c570bf87e8b65e6659b7d7e8b1cfc` |
