# Exact run-build HTML report and product relabel

Run build: rob2-kit commit `2848c7926a2acc25402345a42be39d695a99861a`, version 0.13.0; installed non-editably into `%TEMP%/arbiter-avatar-2848c79` with `uv venv` and `uv pip install --python <venv>/Scripts/python.exe C:/Users/Ali-Salman/Documents/Code/rob2-kit playwright`. No source changes.

`<venv>/Scripts/rob2.exe report kit-sonnet-5.5/bundles/banovic26-avatar-2024.rob2.zip --output analysis/figure1/html-report/raw` succeeded. Both original HTML files are retained.

Only literal product names/CLI names/extensions are replaced in the copy, in the order below. RoB 2 (the instrument), source quotations, decisions, numbers, CSS and layout are unchanged. The original build version remains 0.13.0. Each file is asserted byte-equal to replaying exactly this substitution list. The full unified diff is [html-report-relabel.diff](html-report-relabel.diff).

## index.html

Raw SHA-256: `2b4fea7731bacb7ad29ee1a1471a94005bc63bf5f06d30ecb1f34f3ff2d79cd4`
Relabelled SHA-256: `ad4c0cd1fb7a2c285c82c5e7e0dfcfbbae5503d4cb8b3c88c608240df8349562`

| Before | After | Replacements | Before-string raw / copy | After-string raw / copy |
|---|---|---:|---:|---:|
| `rob2-kit` | `ARBITER` | 3 | 3 / 0 | 0 / 3 |
| `rob2 kit` | `ARBITER` | 0 | 0 / 0 | 0 / 3 |
| `Rob2-kit` | `ARBITER` | 0 | 0 / 0 | 0 / 3 |
| `Rob2 kit` | `ARBITER` | 0 | 0 / 0 | 0 / 3 |
| `rob2 verify` | `arbiter verify` | 1 | 1 / 0 | 0 / 1 |
| `rob2 report` | `arbiter report` | 0 | 0 / 0 | 0 / 0 |
| `rob2 review` | `arbiter review` | 0 | 0 / 0 | 0 / 0 |
| `.rob2.zip` | `.arbiter.zip` | 0 | 0 / 0 | 0 / 0 |
## trials/banovic26-avatar-2024.html

Raw SHA-256: `c514b95fce46c2c5e13047843a9c973af21ca3f63442df854290480f2004933f`
Relabelled SHA-256: `d4b042ea3072ef4822b54699a6119ccaa2c1bb1cb4670bf3d44fd021ba2a84f4`

| Before | After | Replacements | Before-string raw / copy | After-string raw / copy |
|---|---|---:|---:|---:|
| `rob2-kit` | `ARBITER` | 3 | 3 / 0 | 0 / 3 |
| `rob2 kit` | `ARBITER` | 0 | 0 / 0 | 0 / 3 |
| `Rob2-kit` | `ARBITER` | 0 | 0 / 0 | 0 / 3 |
| `Rob2 kit` | `ARBITER` | 0 | 0 / 0 | 0 / 3 |
| `rob2 verify` | `arbiter verify` | 1 | 1 / 0 | 0 / 1 |
| `rob2 report` | `arbiter report` | 0 | 0 / 0 | 0 / 0 |
| `rob2 review` | `arbiter review` | 0 | 0 / 0 | 0 / 0 |
| `.rob2.zip` | `.arbiter.zip` | 0 | 0 / 0 | 0 / 0 |
