# AVATAR HTML-report proof: failed, no HTML wording used

Run on 2026-10-18 from the assigned worktree. ARBITER source was read-only at `2f549ae30f056ff441ea61a04b719968716f2219`; installed distribution reports version 1.0.0. A non-editable wheel was built with uv in an isolated temporary venv. No source-tree environment or files were changed.

Exact PowerShell commands (working directory: `C:/Users/Ali-Salman/.t3/worktrees/arbiter-JAMIA/t3-66fed170`):

```powershell
$proofDir = Join-Path $env:TEMP 'arbiter-avatar-report-proof'
uv venv $proofDir
uv pip install --python "$proofDir/Scripts/python.exe" C:/Users/Ali-Salman/Documents/Code/ARBITER
& "$proofDir/Scripts/arbiter.exe" report kit-sonnet-5.5/bundles/banovic26-avatar-2024.rob2.zip --output "$proofDir/report"
```

The initially requested positional output-directory form is not accepted by this CLI; its actual syntax uses `--output`. The corrected command exits 1:

> no report: bundle verification failed: kit-sonnet-5.5\bundles\banovic26-avatar-2024.rob2.zip: The independent verifier rejected a canonical bundle invariant at finalization.py:4472. No report was written.

At `src/arbiter/application/finalization.py:4471–4472`, the verifier requires manifest schema `arbiter.bundle.v0.3`. This archive has `rob2-kit.bundle.v0.3`. The archive's own `verification.json` says `verified` under the older `rob2-kit.independent-verifier-input.v0.3` schema. Its canonical `report_format` is `none`, but that renderable marker does not bypass bundle verification. `write_report` checks verification before rendering.

No report page exists, so no screenshot/thumbnail is fabricated. Figure 1 and Figure 2 retain audit-file wording only. Their “verified” reference describes the archived receipt, not a successful run of the ARBITER 1.0.0 verifier. Neither the archive nor the read-only ARBITER source was altered to force rendering.
