# Post hoc results for manuscript citation

All intervals are 95% percentile bootstrap intervals. All estimable statistics have 10,000 valid replicates.

## Agreement against Published labels across 510 cells

| Metric | ARBITER | Direct prompting | ARBITER minus Direct prompting | All-Low |
| --- | --- | --- | --- | --- |
| accuracy | 75.686 (72.353 to 79.020) | 77.451 (74.118 to 80.784) | -1.765 (-5.098 to 1.569) | 83.725 (80.980 to 86.471) |
| kappa | 0.341 (0.265 to 0.415) | 0.283 (0.209 to 0.353) | 0.058 (-0.026 to 0.143) | 0.000 (0.000 to 0.000) |
| AC1 | 0.706 (0.660 to 0.749) | 0.733 (0.688 to 0.777) | -0.028 (-0.069 to 0.013) | 0.824 (0.792 to 0.856) |
| AC2 | 0.811 (0.778 to 0.842) | 0.822 (0.786 to 0.855) | -0.011 (-0.038 to 0.017) | 0.891 (0.869 to 0.912) |

Exact agreement is shown as percent; its paired difference is percentage points. Other metrics use coefficient units.

## Agreement relative to human human agreement

| Metric | ARBITER D(A) | Direct prompting D(A) | Paired difference |
| --- | --- | --- | --- |
| accuracy | 2.745 (-0.098 to 5.493) | -4.314 (-7.549 to -1.078) | 7.059 (4.804 to 9.412) |
| kappa | 0.010 (-0.042 to 0.060) | -0.151 (-0.219 to -0.087) | 0.161 (0.105 to 0.221) |

## Recorded Overall judgments

ARBITER and Direct prompting each have 102/102 recorded Overall judgments. Published labels have 81/102; 21 trials are excluded from its comparisons. Neither human review has a recorded Overall judgment (0/102 each); all 102 trials are excluded from comparisons with either review, including human-human agreement. Existing domain-derived human Overall analyses are a separate diagnostic. The adopted ARBITER Overall includes the recorded escalation for fulop-2021.

| Source | Exact agreement | Weighted kappa | AC2 |
| --- | --- | --- | --- |
| ARBITER | 58.025 (49.383 to 66.667) | 0.440 (0.319 to 0.558) | 0.495 (0.391 to 0.599) |
| Direct prompting | 59.259 (50.617 to 67.901) | 0.424 (0.273 to 0.562) | 0.532 (0.430 to 0.636) |
| ARBITER minus Direct prompting | -1.235 (-11.111 to 8.642) | 0.016 (-0.115 to 0.157) | -0.037 (-0.156 to 0.088) |
| All-Low | 51.852 (44.444 to 59.259) | 0.000 (0.000 to 0.000) | 0.485 (0.367 to 0.597) |

ARBITER exact agreement is 47/81; Direct prompting 48/81; All-Low 42/81.

## Missing ratings

All five sources have 0 missing domain ratings among 510 cells. Overall missing counts are ARBITER 0, Direct prompting 0, Human Review 1 102, Human Review 2 102, Published labels 21.

## Files and supplement locators

eTable 4 Agreement under four metrics: analysis/output/tables/posthoc-four-metrics.csv
eTable 9 Overall judgment agreement: analysis/output/tables/posthoc-overall-agreement.csv
eTable 5 Model agreement relative to human agreement: analysis/output/tables/posthoc-relative-human-agreement.csv
eTable 8 Distribution of ratings by source: analysis/output/tables/posthoc-rating-distribution.csv
eTable 10 Overall availability: analysis/output/tables/posthoc-overall-availability.csv

All numerical rows, including every domain, interval and valid replicate count: analysis/provenance/posthoc-requests/all-numbers.md

Verification: 120 existing estimate/contrast rows reproduce to numerical tolerance 1e-12; 41 original numerical CSVs differ only by the requested display rename. The existing test suite passed 215 tests. No model was rerun.

Package: irrCAC 1.4; gwet.ac1.table with identity or linear weights, fixed three-category scale. https://www.stat.math.ethz.ch/CRAN/web/packages/irrCAC/refman/irrCAC.html