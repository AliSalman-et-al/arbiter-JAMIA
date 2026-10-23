# Round 6 V1 layout repair

## Final gate

**PASS for V1 and the main-manuscript layout repair.** Page 6 now keeps `elsewhere.[8,9,10]` together. The final main manuscript remains 24 pages. All 24 final page PNGs were compared by SHA-256 with the independent round-six proof: pages **6 and 9 changed**, and **22 pages are byte-identical**. Both changed pages and their transition neighbors were individually inspected at original detail. No new clipping, overlap, missing glyph, broken table, or heading/page-transition defect was found.

This gate closes the one actionable visual finding in `round6/proof.md`; that independent report remains unchanged as historical evidence. It is not a scientific, author-completion, artwork, supplement, or submission-readiness approval. Existing author placeholders remain outside this repair. Word still contains only the five existing figure legends and alt-text paragraphs, with no artwork added.

## Implementation and ownership

- Replaced the sentence-specific reporting-citation condition in `docs/manuscript/assemble-publication.py` with `bind_final_reference`, a general paragraph-final numeric-citation rule. It inserts one invisible U+2060 WORD JOINER immediately before the bracket after sentence punctuation. It does not hardcode `elsewhere`, citation IDs, or manuscript prose; ordinary mid-paragraph citations are unchanged. The existing reporting-citation protection now also survives reporting-sentence rewording.
- Updated the existing narrow binding test in `scripts/test-manuscript.py`, retaining 25 total tests. It checks split runs, renumbering, formatting retention, idempotence, exact visible-text preservation, citation ranges, and exclusion of mid-paragraph citations and author placeholders.
- Rebuilt `analysis/output/manuscript/Manuscript.docx` and generated `analysis/manuscript.html` through the main-only builder. Its generated `.quarto/manuscript-page.md` and `qa/manuscript-assembled.md` are derived main inputs. The builder passes `--main-only` to the assembler and does not assemble or save Supplement, standalone tables, or TRIPOD-LLM.
- No canonical prose, references, external-fact ledger, statistical analyses/CSVs, figures, or supporting artifacts were edited by this repair. No git commands, pushes, or agents were used. A pre-edit hash inventory of manuscript sources, publication displays, and statistical table outputs showed only the owned assembler and main DOCX changing within that inventory at verification time; standalone displays and supporting artifacts were unchanged then. This does not restrict the separately authorized concurrent supporting-artifact worker.

## Managed runtime and reproducible commands

Read the documents skill and its render-verification guide. Ran `mark_artifact_operation_started.mjs --operation-kind edit --expected-output-count 1 --output-format docx` successfully exactly once, using the managed Node executable, immediately before the first authoring edit.

Managed Python: `/home/ali/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/bin/python3`.

Packaged renderer: `/home/ali/.codex/plugins/cache/openai-primary-runtime/documents/26.1011.51657/skills/documents/render_docx.py`.

The renderer resolves `/home/ali/.cache/codex-runtimes/codex-primary-runtime/dependencies/bin/override/soffice`, whose executable is `/home/ali/.cache/codex-runtimes/codex-primary-runtime/dependencies/native/libreoffice-headless/libreoffice/program/soffice` (managed LibreOffice 25.2). No desktop LibreOffice or system Python was used.

```bash
ARBITER_PYTHON=/home/ali/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/bin/python3 /home/ali/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/bin/python3 scripts/build-manuscript.py
/home/ali/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/bin/python3 /home/ali/.codex/plugins/cache/openai-primary-runtime/documents/26.1011.51657/skills/documents/render_docx.py analysis/output/manuscript/Manuscript.docx --output_dir /tmp/arbiter-r6-final-proof --emit_pdf
ARBITER_CHECK_BUILT=1 /home/ali/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/bin/python3 scripts/test-manuscript.py
/home/ali/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/bin/python3 docs/manuscript/verify-numbers.py
```

Final build: PASS. Final tests: **25 run, OK, zero skipped**, including built HTML/table checks. Final number audit: **PASS**, 324 numeric tokens = 184 output-traced + 25 external-literature + 115 non-result/editorial + **0 untraced**; all 6 external ledger spans accepted. Main text 3340/4000 words; abstract 217/250; display citation order PASS. The audit establishes recorded traceability, not independent source truth.

## Exact parity and pagination

Pre-edit DOCX SHA-256 was `bc1b24e23d87d51cb8f42d55f779ccb62c03a30758405518b6346485bea8bd9e`, exactly matching the independent proof's source digest. The final artifact was compared directly with a pre-edit copy:

- All **318 ordered OOXML text nodes** match exactly after removing U+2060. The original contains zero joiners; the final contains two, at the paragraph-final citations on pages 6 and 9. Visible prose, references, numbers, legends, and alt text are unchanged.
- All **three embedded table XML trees are byte-identical** to the pre-edit DOCX. The builder also confirms cell-for-cell equality against the existing standalone Word tables; the built-artifact test checks the corresponding HTML cells and notes.
- The complete `word/document.xml` is identical after removing U+2060 and normalizing only redundant `xml:space="preserve"` attributes on text without edge whitespace. Formatting, hyperlinks, table structure, section settings, and paragraph/run properties are unchanged.
- Ordered numeric tokens match exactly before/after.
- Both PDFs contain 24 pages of 612 × 792 pt. Extracted text on **each of all 24 pages** matches exactly after ignoring layout whitespace and invisible control characters. No text moved across a page boundary.
- The Word archive contains no `word/media/` artwork. The existing five legends and five alt-text paragraphs remain intact.

PDF geometry confirms V1: before, `elsewhere.` began at x=496.077 pt, top=191.121 pt, and `[8,9,10]` alone began at x=50.500 pt, top=216.421 pt. After, `elsewhere.[8,9,10]` is one contiguous word group beginning at x=50.500 pt, top=216.421 pt. On page 9, `fields.[12,13]` begins at the same x=50.500 pt, top=241.721 pt before and after; the generic binding changes its raster hash but does not alter its wrap or the following RESULTS heading position.

## Original-detail visual coverage

Final PNGs: `/tmp/arbiter-r6-final-proof/page-1.png` through `page-24.png`; retained PDF: `/tmp/arbiter-r6-final-proof/Manuscript.pdf`. Each full-page PNG is 1547 × 2002 pixels.

Each of the following was opened separately using `view_image` with `detail: original`, emitted at original detail, and inspected full-page:

| Page | Reason | Final visual result |
|---|---|---|
| 5 | Preceding transition neighbor of changed page 6 | Benchmark heading and body intact; final paragraph continues coherently onto page 6; no clipping. |
| 6 | Changed; V1 target | `elsewhere.[8,9,10]` stays together; links, Independent expert references heading, body, footer, and continuation onto page 7 intact. |
| 7 | Following transition neighbor of changed page 6 | Opening continues `Each then supplied a revised rating`; Outcomes heading, symbols, paragraph flow, and footer intact. |
| 8 | Preceding transition neighbor of changed page 9 | Outcomes continuation, citation, API/exploratory prose, and footer intact; next page starts Statistical analysis. |
| 9 | Changed; generalized reporting-citation protection | `fields.[12,13]` remains together; Statistical analysis and RESULTS headings intact; complete Table 1, native cells, notes, and footer readable with no clipped rows. |
| 10 | Following transition neighbor of changed page 9 | Results flow, complete Table 2 with notes, subsequent paragraphs, and footer intact. |

The **22 unchanged pages (1–5, 7–8, 10–24)** retain their full individual original-detail coverage from `round6/proof.md`, verified by exact PNG hashes against that report's manifest. Of those, pages 5, 7, 8, and 10 were additionally re-inspected here as neighbors. The **18 unchanged pages not re-opened here are 1–4 and 11–24**; no repeated inspection was needed because their complete page pixels match the independently inspected baseline. Thus all 24 final pages are covered by fresh inspection or exact-image continuity with the prior independent proof.

## All-page SHA-256 comparison

Before directory: `/tmp/arbiter-r6-proof`. After directory: `/tmp/arbiter-r6-final-proof`. Every before digest was also checked against the historical `round6/proof.md` manifest.

| Page | Before SHA-256 | Final SHA-256 | Result |
|---|---|---|---|
| 1 | `58cc1f940cc0b3a788f7c0014fe41d483ae3d7d66018f6516b7e20d5795f79a8` | `58cc1f940cc0b3a788f7c0014fe41d483ae3d7d66018f6516b7e20d5795f79a8` | Identical |
| 2 | `bc64cce94a720f99479ba91d28877663df43ec0c960dd634f1378949965daabc` | `bc64cce94a720f99479ba91d28877663df43ec0c960dd634f1378949965daabc` | Identical |
| 3 | `4f113bdf4356591e014d0b371635f66b69f29c5be953c7b0adbee80f58970e03` | `4f113bdf4356591e014d0b371635f66b69f29c5be953c7b0adbee80f58970e03` | Identical |
| 4 | `f0f78e7ebe6c0454b470f293a2e68e72052aec091b844250fbf294755f6eefd1` | `f0f78e7ebe6c0454b470f293a2e68e72052aec091b844250fbf294755f6eefd1` | Identical |
| 5 | `22b6108cb621a110d5b717b7de3731f0d08b57f1e2d3991c11fb935fae893335` | `22b6108cb621a110d5b717b7de3731f0d08b57f1e2d3991c11fb935fae893335` | Identical |
| 6 | `19bc1a930f51a76445e56af87640b0daffe1efbf3c3ca93fe5fb9a1278a6059a` | `bbcc53d47f33544ab885efbd4fba89731728962e3d52e66cc076624afa06f4d2` | Changed; visually inspected |
| 7 | `c4186c7f72c66a6d428751fe629afdad6e83399ae8c77fe0d550f86fcfc513a1` | `c4186c7f72c66a6d428751fe629afdad6e83399ae8c77fe0d550f86fcfc513a1` | Identical |
| 8 | `28c4ad70026451db7255b3064411c1ec72394872b517f223d95163012513a89a` | `28c4ad70026451db7255b3064411c1ec72394872b517f223d95163012513a89a` | Identical |
| 9 | `67b3b88420c4e12024425006fdc3760ce257e4e78cf28580010a10909b4ead98` | `ca914e327a14cece4b43baf7f2efbb6b1456d2fcf14cddaf4795f9e95f1ae21c` | Changed; visually inspected |
| 10 | `d6026110ba5488c2f94c0aaaa65844d3bb70c885a33f3985762fc799bb74020d` | `d6026110ba5488c2f94c0aaaa65844d3bb70c885a33f3985762fc799bb74020d` | Identical |
| 11 | `63ed48f7acc3d7e6e8d7243e751bdd08c7be79cc3336185f1339355be2ccd124` | `63ed48f7acc3d7e6e8d7243e751bdd08c7be79cc3336185f1339355be2ccd124` | Identical |
| 12 | `5a6fcfd2b5fbe0c119c8733a9703ec02559cfbaa267536fa9909eeb30431b5f4` | `5a6fcfd2b5fbe0c119c8733a9703ec02559cfbaa267536fa9909eeb30431b5f4` | Identical |
| 13 | `875145d170fc37d08c6cbfc7ae7ea3c3b7c43772d119bfe9fb4a96e3b8764412` | `875145d170fc37d08c6cbfc7ae7ea3c3b7c43772d119bfe9fb4a96e3b8764412` | Identical |
| 14 | `831ed58a167a46bc7e7f6be96da8037ec96a26cac849102e73c34b9f48b0f3da` | `831ed58a167a46bc7e7f6be96da8037ec96a26cac849102e73c34b9f48b0f3da` | Identical |
| 15 | `3083b8fd87438b3f642a807c88c2a2b0fde884405fd95fd04bb3afbaab0f9e81` | `3083b8fd87438b3f642a807c88c2a2b0fde884405fd95fd04bb3afbaab0f9e81` | Identical |
| 16 | `2e9c6f64b2a293a68ff4b0b04ff6e9d4d1666799ab9daceb985fb64492cf460d` | `2e9c6f64b2a293a68ff4b0b04ff6e9d4d1666799ab9daceb985fb64492cf460d` | Identical |
| 17 | `5fdb4caffcfbb682b984be0062f3d28188dba15fc2cc5aa6aab1251f7c26a2c7` | `5fdb4caffcfbb682b984be0062f3d28188dba15fc2cc5aa6aab1251f7c26a2c7` | Identical |
| 18 | `cf01123b6c6b08c191f4a7685e2d15b40f5e7af0bca078288c7fb4eb6c87bce6` | `cf01123b6c6b08c191f4a7685e2d15b40f5e7af0bca078288c7fb4eb6c87bce6` | Identical |
| 19 | `1fac942abbf5aff04a8ab55a1e03b18009b3fb8a8a3003f4c0f7d907d8f8d065` | `1fac942abbf5aff04a8ab55a1e03b18009b3fb8a8a3003f4c0f7d907d8f8d065` | Identical |
| 20 | `157be0ab377e10449fb45f88e01b374c1b22f3de057c73245de71a613c9b9467` | `157be0ab377e10449fb45f88e01b374c1b22f3de057c73245de71a613c9b9467` | Identical |
| 21 | `718c71eabf7cb7512f49cbb5ef87855c9022131e50400c54e37bb49ad4a328d2` | `718c71eabf7cb7512f49cbb5ef87855c9022131e50400c54e37bb49ad4a328d2` | Identical |
| 22 | `31ae377a92466724c32c6a777cbfc0be62ae0076c751ac040e03b047c24e4a07` | `31ae377a92466724c32c6a777cbfc0be62ae0076c751ac040e03b047c24e4a07` | Identical |
| 23 | `54b38ceea617eaa6ad18fc7f0e5e9de2ca1e43e8f73c113a70000ab6b9f51f08` | `54b38ceea617eaa6ad18fc7f0e5e9de2ca1e43e8f73c113a70000ab6b9f51f08` | Identical |
| 24 | `787600159b31cc3b27132a571a59355e723c570bf87e8b65e6659b7d7e8b1cfc` | `787600159b31cc3b27132a571a59355e723c570bf87e8b65e6659b7d7e8b1cfc` | Identical |

Final main DOCX SHA-256: `afdeb1fb574be2863ca863524b4bb67a87e28b01f30b818aa2c2dbc5ca711c6a`.

Generated main HTML SHA-256: `edfa90e9bc9332dbe08d33dfa5f6a00ca08322ea2025865425e94680e0198489`.

**Final repair gate: PASS. V1 closed; 24/24 page hash coverage; 2/2 changed pages and all four transition neighbors inspected at original detail; 25/25 built manuscript tests PASS; exact text/table parity and number audit PASS.**
