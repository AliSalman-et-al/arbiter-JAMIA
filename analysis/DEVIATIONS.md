# Analysis deviations and unresolved inputs

No Python is used. This file records conservative resolutions as they arise.

1. **Section 5.4 hard gate prevents completion.** ARBITER-Sonnet reproduces
   510/510 domain labels. ARBITER-Haiku reproduces 504/505 observed labels:
   hill-2017 D1 reports Some concerns, but 1.1=NI, 1.2=PY, 1.3=N gives Low
   under official Table 4 (printed p. 20) and the retrieved ARBITER source.
   Five additional Haiku cells (award-1-2014 D1-D5) have no labels or answers.
   Missing cells are reported separately; excluding them still fails the gate.
   Following the explicit instruction to stop, the implementation halts before
   downstream analyses. The mandatory gate test remains failing, and no
   successful render or completed analysis is claimed. See VALIDATION-HALT.md
   and output/tables/algorithm-mismatches.csv. The algorithm and input labels
   have not been altered to force agreement.
2. **Unverifiable run provenance.** The retrieved ARBITER commit is
   2f549ae30f056ff441ea61a04b719968716f2219. It is recorded as the source
   cross-check commit only; the benchmark-run commit, exact model IDs and run
   dates have not been established from the available CSVs. They are not
   inferred from directory names or filesystem modification dates.
