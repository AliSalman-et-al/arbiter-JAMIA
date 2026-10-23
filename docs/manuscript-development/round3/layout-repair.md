# Round 3 Word layout repair

Result: **PASS for both requested layout repairs and the verification scope below.** Final Word has 23 pages. Number audit and relevant built tests pass. No unresolved layout finding.

## Changes and ownership

This worker edited only `docs/manuscript/assemble-publication.py`, regenerated `analysis/output/manuscript/Manuscript.docx`, and wrote this report. No source manuscript wording edit was needed or made by this worker.

- The assembler inserts U+2060 WORD JOINER between `fields.` and `[14,15]`. The citation now stays attached to the final prose word without visible wording changes.
- In the copied Table 3 cell containing `Image regions linked to their page`, the end margin is 900 twips (0.625 inches). This causes natural wrapping before `page` and clear separation from `14/14 (100%)`. No hard line break or table-text change was introduced. Standalone Table3.docx is untouched.

The source manuscript changed externally during this task. A software-revision declaration was added and then replaced by an eMethods cross-reference. Final rebuild uses the current canonical source, with 3425 main words and 239 abstract words. These concurrent edits explain the title count and pages 6–9 changing beyond the layout repairs. The extra table-label line shifts Discussion across pages 12–15. This worker did not change numerical data, table text, canonical figures or supplement. Final exact embedded table-cell text, including notes, matches all three standalone tables. All other regular publication-directory files match their task-start hashes (checked below).

## Runtime and validation

Read the requested documents SKILL.md and existing builder. No workspace dependency loader tool was exposed; the installed runtime manifest and existing round3/reporting-repair.md supplied the managed paths. Used `/home/ali/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/bin/python3` (Python 3.12.14) for build, rendering and checks. Packaged renderer resolves bundled `/home/ali/.cache/codex-runtimes/codex-primary-runtime/dependencies/bin/override/soffice` (manifest LibreOffice 25.2-headless-codex.1); desktop LibreOffice was not used. Managed Node ran the document marker successfully exactly once immediately before the first edit: `--operation-kind edit --expected-output-count 1 --output-format docx`.

- `ARBITER_PYTHON=<managed-python> <managed-python> scripts/build-manuscript.py`: PASS; main-only assembly protects supplement. Final log `/tmp/arbiter-r3-layout-build.log`.
- Packaged `render_docx.py analysis/output/manuscript/Manuscript.docx --output_dir /tmp/arbiter-r3-final-proof --emit_pdf`: PASS, 23 PNGs, each 1547 × 2002 pixels.
- `ARBITER_CHECK_BUILT=1 <managed-python> scripts/test-manuscript.py`: PASS, 5 tests including built HTML cells/images/anchors. Final log `/tmp/arbiter-r3-layout-tests.log`.
- `<managed-python> scripts/test-pages.py`: PASS, 9 tests, including temporary staging; no publication.
- `<managed-python> docs/manuscript/verify-numbers.py`: final PASS, 327 numeric tokens, 212 output-traced, 115 non-result/editorial, **0 untraced**; citation-order assertion PASS; main 3425/4000 and abstract 239/250. Log `/tmp/arbiter-r3-layout-numbers.log`. An intermediate run failed on the externally added commit identifier and `kit`; the subsequent external source replacement removed those triggers. This worker changed neither source nor audit to suppress findings.
- Read-only structural checks: exact table-cell equality, current canonical Markdown/reference equality with `qa/manuscript-assembled.md`, and protected publication-file hashes pass.

## Visual coverage and transitions

Each changed final PNG was individually opened with `view_image(detail="original")` and emitted at original detail: **1, 6, 7, 8, 9, 12, 13, 14, 15**. Final pages **2, 5, 10, 11, 16** were also individually opened at original detail to inspect both sides of changed-region boundaries. No contact sheets. Original resolution was preserved; native monitor zoom was not independently measured.

After the last external source edit, only page 6 differed from the immediately preceding render. Page 6 was reopened at original detail; all other pages were byte-identical to the individually inspected images. Thus the inspection applies to the exact final rasters.

| Page | Observations and transitions |
| --- | --- |
| 1 | Computed word count readable; metadata and footer intact. Clean title/abstract break at 1→2. |
| 6 | eMethods cross-reference, release text, links and pending note readable. Heading retains body. 5→6 continues “software service, assessment instructions…”; 6→7 continues “signalling answers…”, without loss. |
| 7 | Outcomes heading retains body; κ and pending note readable. 7→8 continues “such as a separate answer…” cleanly. |
| 8 | Prose and symbols contained. 8→9 continues “without optional escalation…” cleanly. |
| 9 | Final Statistical analysis line is `fields.[14,15]`, so citation is attached to prose. RESULTS retains its paragraph. 9→10 leads cleanly to complete Tables 1 and 2. |
| 12 | Target label wraps as “Image regions linked to their” / “page”, clearly separated from its value. Table, notes and computational paragraph remain contained. DISCUSSION retains two body lines. 11→12 is a clean prose/table boundary. 12→13 continues “Across all 510 trial–domain assessments…” cleanly. |
| 13 | Opening continuation, citation [16], prose and footer intact; 13→14 paragraph boundary clean. |
| 14 | Citations [6,7,8], [17], [18], signed intervals and body readable. 14→15 continues “trial reports…” cleanly. |
| 15 | Conclusion and BACK MATTER retain following content. Disclosure and footer intact. 15→16 transitions to Funding without splitting the disclosure. |

No clipping, overlap, missing glyphs, accidental blank pages, detached headings or broken table rows observed in this inspection. Fourteen final pages are byte-identical to the old proof. Prior independent visual coverage for unchanged pages is proof-a.md (1–12) and proof-b.md (13–23); five unchanged pages were additionally reopened here for transitions. This worker does **not** claim new independent coverage of every page. The original reports did not jointly cover 12→13; this repair explicitly inspected that transition.

## Exact identities and raster hashes

All hashes below are SHA256 of complete PNG file bytes, not perceptual hashes. Matching file bytes imply matching decoded rasters. Old directory `/tmp/arbiter-r3-proof`; final directory `/tmp/arbiter-r3-final-proof`. The old Word hash was verified at task start and agrees with proof A/B. Native Microsoft Word rendering, hidden content and scientific correctness are outside this raster review. Existing pending author declarations remain unresolved content, not layout defects.

No git commit, push, publication or supplement rebuild was performed.

Protected publication files unchanged: 60.

- Old Word SHA256: `108252e55016231213b2d3787361c1c4c49b9275bcfa29bcf46cb6783ca5c1eb`.
- Final Word SHA256: `b782346fbe94a462c4b4d715bb5eefbee4f84a1b1df6b58b2db668d909676066`.
- Current source SHA256: `e073df91cce8ee344d4a4bc8b8c97a503f47bdcd0600fb8db53edc1bb3f8aa23`.
- Audit script SHA256: `20a9f8730f4105139d9e8e42f77781a32bdc1b0f05e5d501330833882064b649`.

| Page | Old PNG SHA256 | Final PNG SHA256 | Coverage |
| --- | --- | --- | --- |
| 1 | `8e414f865a9300f327b2b6c39569b9a028fe269940ea58196c81bb9fedc2011a` | `065d34cdcd15e22373040af6a526f651287685512bbc68e888a4408887b85d52` | Changed; individually inspected now |
| 2 | `6a0ac79d5a8aea20cb5e6563ffd02b21d476f3135183b59d6bad3636a774aa75` | `6a0ac79d5a8aea20cb5e6563ffd02b21d476f3135183b59d6bad3636a774aa75` | Identical; reopened for transitions |
| 3 | `22f1d1c7a6eb9ed161c8606106266ad9f5ac5711e095a7f1368b99dc4d4077ca` | `22f1d1c7a6eb9ed161c8606106266ad9f5ac5711e095a7f1368b99dc4d4077ca` | Identical; prior independent proof A |
| 4 | `8eedc48264d85200c45ae0de51c74f421a839e188d0c20b102ea0a51a0d512fc` | `8eedc48264d85200c45ae0de51c74f421a839e188d0c20b102ea0a51a0d512fc` | Identical; prior independent proof A |
| 5 | `4560f9919b54860aea3a4dfc7a661d3670e679a10799632cd36ae238f7456262` | `4560f9919b54860aea3a4dfc7a661d3670e679a10799632cd36ae238f7456262` | Identical; reopened for transitions |
| 6 | `4e454998ca67ce569ef6c91f0ddc578ef21f0634493953ddfae0543b99ebb927` | `58aeae1f6bcd140a4d6c46f24f05d2da2f17acc7b20f3d205358460f83ed7e23` | Changed; individually inspected now |
| 7 | `6569ce93823b48475ed68dde10e0960e8c43c1e6fc0ae027019e904d952e8fb3` | `b181c4d4790db639dc8db25e5b65d81bcb04d5ffe7d43bdef0ff98d69f65ed2d` | Changed; individually inspected now |
| 8 | `700f40592b08073a88ab5515be49c42f41055fc65a1d1b41343266b1ac76f174` | `22473c3b833e72479aaf20622eab572114f9034c7e7470221c97a9daade2ba28` | Changed; individually inspected now |
| 9 | `167f53c0bec7738620936872d2c882fa5cb1dad017abde4db8b36ab918ad9415` | `48424f7d4892c1ebee412df91c03a39cf107adf0cd7f6e06539a3e1d7471fa00` | Changed; individually inspected now |
| 10 | `e06b055fc04a6742b3840cf979d1ad4918a93361d08e9e578ad532697e563a8f` | `e06b055fc04a6742b3840cf979d1ad4918a93361d08e9e578ad532697e563a8f` | Identical; reopened for transitions |
| 11 | `fc7f0820bfdb303164192ed2311752a0869ac0247c337b59f84ae5d60df43a03` | `fc7f0820bfdb303164192ed2311752a0869ac0247c337b59f84ae5d60df43a03` | Identical; reopened for transitions |
| 12 | `627cd5fa056d600e093215d2f39ae5c0943cbaefd7e72e8ffa82067d6408d4ff` | `3ec05113c7b67bd40f16d107034942a24dfcb8886b893996415e7d4ae481367b` | Changed; individually inspected now |
| 13 | `a873448ca6b74844dad4e0ad45f430a90fddb4fd8f572aac4e26ab01ac03e464` | `0a109fd02aff36373e3473c629ab1d4df20b4f9ce38eb2b1bd5ba770efaa103a` | Changed; individually inspected now |
| 14 | `e870b72e2f463d92d74bded45ed0f1f84d8a31702fc601b97a9247c23b3bda3a` | `71674f2fd134b906b0a21fd10b4bc666c1b1773754d7f34e048f941cd533c9a5` | Changed; individually inspected now |
| 15 | `6cb30e0dfedba19684acec3eb9034d6286c9b81ae03c353a523f296420186950` | `5d2775a1ed67e964610d256be2dcdf235a174178ec2ebcd4c2a386a01752c24a` | Changed; individually inspected now |
| 16 | `bd0f39b7b68f5b993134667ee98d72c9ae6c3b7353d99d1b4d8f835804bc81e5` | `bd0f39b7b68f5b993134667ee98d72c9ae6c3b7353d99d1b4d8f835804bc81e5` | Identical; reopened for transitions |
| 17 | `79d77e5d4d04a838db8f21d03be8c8b7383d8e20c01ad769d753fee99db5eeab` | `79d77e5d4d04a838db8f21d03be8c8b7383d8e20c01ad769d753fee99db5eeab` | Identical; prior independent proof B |
| 18 | `101446e051e38b89ec7c1b15789b6b2580809331dc54866240e985083487d6e5` | `101446e051e38b89ec7c1b15789b6b2580809331dc54866240e985083487d6e5` | Identical; prior independent proof B |
| 19 | `d78d59536739b74a4a670f8ed67f36d12a677bd1913de651001bc131a1d5c28d` | `d78d59536739b74a4a670f8ed67f36d12a677bd1913de651001bc131a1d5c28d` | Identical; prior independent proof B |
| 20 | `95c0da9f2def2dcce198981d21095200be44fdb861f72918633e2dd49c09cccb` | `95c0da9f2def2dcce198981d21095200be44fdb861f72918633e2dd49c09cccb` | Identical; prior independent proof B |
| 21 | `f03ccdf6d7102683d1c1893761be39f45d0ad8c68e597d42d234b27b72288185` | `f03ccdf6d7102683d1c1893761be39f45d0ad8c68e597d42d234b27b72288185` | Identical; prior independent proof B |
| 22 | `53cba1a6c2627a93165eca759075cade401064d0c3cc3094ab8a2ba63c4ac4db` | `53cba1a6c2627a93165eca759075cade401064d0c3cc3094ab8a2ba63c4ac4db` | Identical; prior independent proof B |
| 23 | `7febb2d94d0799289a161925782cf253c10da335820d630bef7499e81b11d990` | `7febb2d94d0799289a161925782cf253c10da335820d630bef7499e81b11d990` | Identical; prior independent proof B |
