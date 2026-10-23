# Clean generated-include integration check

The isolated production build exposed a Quarto project prerequisite: rendering Results also parses the manuscript include, which did not yet exist in a clean generated directory. `report-refresh.py` now creates the two report includes first and, only when the manuscript include is absent, invokes the existing HTML-only manuscript builder before rendering Results/Supplement. It uses the same Python executable and does not rewrite Word or statistical outputs.

Validation removed all three generated include files from `/tmp/arbiter-analysis-r5-y3nrs5du/analysis/.quarto`, copied the repaired helper into that isolated workspace, and executed it with managed Python. The command exited 0, generated manuscript/Results/Supplement HTML and passed the helper's full content, table, image, anchor and protected-source checks. This exercised the missing-include path directly. Log: `clean-includes.log` alongside this note.

Separately, the shared R verifier exposed historical documentary CSV trace mismatches after the report text repairs; these are being reconciled before release and are not treated as a successful shared-source check.
