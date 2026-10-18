# Fresh bundle verification

Run build: `2848c7926a2acc25402345a42be39d695a99861a`; distribution version `0.13.0`.

Verifier: `rob2_kit.application.finalization.verify_bundle(path, diagnostic=...)`, the function used by both `rob2 verify` and finalization. This rereads archive bytes and recomputes bundle invariants; it does not trust the stored receipt.

| Arm | Population | Fresh passes | Archived verified | Disagreements |
|---|---|---:|---:|---:|
| ARBITER-Haiku | analysis | 102/102 | 102/102 | 0 |
| ARBITER-Haiku | excluded | 1/1 | 1/1 | 0 |
| ARBITER-Sonnet | analysis | 102/102 | 102/102 | 0 |
| ARBITER-Sonnet | excluded | 3/3 | 3/3 | 0 |

Excluded bundles present: Sonnet—atwine-2020, haney-2004, herrmann-2016; Haiku—herrmann-2016. Haiku has no atwine-2020 or haney-2004 bundle. Excluded trials are never pooled into the 102-trial results.

## Isolated build and reproduction

Export commit 2848c79 with `git archive --format=zip`; expand into a new temporary directory. Run `uv venv --python 3.13 <temp>/venv`, `uv build --wheel --out-dir <temp>/dist <temp>/source`, then `uv pip install --python <temp>/venv/Scripts/python.exe <temp>/dist/rob2_kit-0.13.0-py3-none-any.whl`. Run `<temp>/venv/Scripts/python.exe analysis/reverify-bundles.py` from the analysis checkout. Both source repositories remain read-only. The module-path assertion confirms a site-packages installation inside the isolated venv. Dependency versions are recorded in `bundle-reverification-environment.json`; this recreates the exact project commit, not an undocumented historical transitive-dependency environment.

No tables or manuscript outputs were changed: the separate equivalence audit found behavioural differences. See `rename-equivalence.md`. No Quarto render was required.
