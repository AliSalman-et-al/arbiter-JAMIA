# Round 2 implementation report

Milestones 3–5 are implemented. The exact commit list is given in the handoff message.

All intervals below are 95% percentile stratified trial-cluster bootstrap intervals.
10,000 replicates; seed 20261018. Values are proportions, not percentages, unless explicitly shown.
Paired differences are ARBITER minus baseline. No p-values are reported.

## Primary endpoint

|analysis          |metric   |  n| count|  estimate|     lower|     upper|
|:-----------------|:--------|--:|-----:|---------:|---------:|---------:|
|Consensus         |ARBITER  | 62|    54| 0.8709677| 0.7903226| 0.9433962|
|Consensus         |Baseline | 62|     7| 0.1129032| 0.0454545| 0.1923077|
|Consensus         |Neither  | 62|     1| 0.0161290| 0.0000000| 0.0476190|
|A                 |ARBITER  | 80|    60| 0.7500000| 0.6666667| 0.8333333|
|A                 |Baseline | 80|    16| 0.2000000| 0.1168777| 0.2894737|
|A                 |Neither  | 80|     4| 0.0500000| 0.0126582| 0.0919540|
|Z                 |ARBITER  | 80|    64| 0.8000000| 0.7233961| 0.8720930|
|Z                 |Baseline | 80|    15| 0.1875000| 0.1159420| 0.2631579|
|Z                 |Neither  | 80|     1| 0.0125000| 0.0000000| 0.0375000|
|Split sensitivity |ARBITER  | 80|    54| 0.6750000| 0.5866667| 0.7631579|
|Split sensitivity |Baseline | 80|     7| 0.0875000| 0.0352941| 0.1500000|
|Split sensitivity |Neither  | 80|    19| 0.2375000| 0.1604938| 0.3134328|

The consensus 54 ARBITER versus 7 baseline wins reproduce the expected sanity value.

## Table 2: pooled domains and Overall

|arm             |domain  |kappa                  |AC2                    |accuracy               |sensitivity            |specificity            |
|:---------------|:-------|:----------------------|:----------------------|:----------------------|:----------------------|:----------------------|
|ARBITER-Sonnet  |D1-D5   |0.341 (0.265 to 0.415) |0.811 (0.778 to 0.842) |0.757 (0.724 to 0.790) |0.663 (0.573 to 0.747) |0.813 (0.777 to 0.847) |
|Baseline-Sonnet |D1-D5   |0.283 (0.209 to 0.353) |0.822 (0.786 to 0.855) |0.775 (0.741 to 0.808) |0.506 (0.403 to 0.602) |0.857 (0.821 to 0.893) |
|All-Low         |D1-D5   |—                    |—                    |0.837 (0.810 to 0.865) |—                    |1.000 (1.000 to 1.000) |
|ARBITER-Sonnet  |Overall |0.440 (0.319 to 0.558) |0.495 (0.391 to 0.599) |0.580 (0.494 to 0.667) |0.923 (0.837 to 1.000) |0.548 (0.442 to 0.674) |
|Baseline-Sonnet |Overall |0.424 (0.273 to 0.562) |0.532 (0.430 to 0.636) |0.593 (0.506 to 0.679) |0.641 (0.500 to 0.778) |0.762 (0.659 to 0.868) |
|All-Low         |Overall |—                    |—                    |0.519 (0.444 to 0.593) |—                    |1.000 (1.000 to 1.000) |

### Paired differences

|comparison                           |domain  |kappa                   |AC2                      |accuracy                 |sensitivity            |specificity               |
|:------------------------------------|:-------|:-----------------------|:------------------------|:------------------------|:----------------------|:-------------------------|
|ARBITER-Sonnet minus Baseline-Sonnet |D1-D5   |0.058 (-0.026 to 0.143) |-0.011 (-0.038 to 0.017) |-0.018 (-0.051 to 0.016) |0.157 (0.068 to 0.244) |-0.044 (-0.076 to -0.012) |
|ARBITER-Sonnet minus Baseline-Sonnet |Overall |0.016 (-0.115 to 0.157) |-0.037 (-0.156 to 0.088) |-0.012 (-0.111 to 0.086) |0.282 (0.161 to 0.405) |-0.214 (-0.327 to -0.098) |

All-Low has no variance: kappa is undefined; AC2 and sensitivity are intentionally not reported, per plan.

## Composite reference

|arm             |domain |kappa                  |AC2                    |accuracy               |
|:---------------|:------|:----------------------|:----------------------|:----------------------|
|ARBITER-Sonnet  |D1-D5  |0.941 (0.909 to 0.969) |0.980 (0.970 to 0.989) |0.973 (0.959 to 0.986) |
|Baseline-Sonnet |D1-D5  |0.691 (0.617 to 0.757) |0.905 (0.883 to 0.925) |0.876 (0.852 to 0.900) |

|comparison                           |domain |kappa                  |AC2                    |accuracy               |
|:------------------------------------|:------|:----------------------|:----------------------|:----------------------|
|ARBITER-Sonnet minus Baseline-Sonnet |D1-D5  |0.250 (0.180 to 0.329) |0.075 (0.053 to 0.097) |0.097 (0.070 to 0.124) |

Composite: 485 cells per Sonnet arm; offered-label restriction and unadjudicated concordant cells inflate absolute values.

## Table 3: violation rates

|arm             |domain  |   n| count| missing|  estimate|     lower|     upper|
|:---------------|:-------|---:|-----:|-------:|---------:|---------:|---------:|
|ARBITER-Haiku   |Overall | 101|     0|       1| 0.0000000| 0.0000000| 0.0000000|
|ARBITER-Sonnet  |Overall | 102|     0|       0| 0.0000000| 0.0000000| 0.0000000|
|Baseline-Haiku  |Overall | 102|     0|       0| 0.0000000| 0.0000000| 0.0000000|
|Baseline-Sonnet |Overall | 102|     0|       0| 0.0000000| 0.0000000| 0.0000000|
|Meta            |Overall |  81|     1|      21| 0.0123457| 0.0000000| 0.0370370|
|Baseline-Haiku  |D1-D5   | 462|   132|      48| 0.2857143| 0.2522119| 0.3194748|
|Baseline-Sonnet |D1-D5   | 471|    27|      39| 0.0573248| 0.0382979| 0.0775681|
|Baseline-Haiku  |D1      | 102|    10|       0| 0.0980392| 0.0490196| 0.1568627|
|Baseline-Sonnet |D1      | 101|     5|       1| 0.0495050| 0.0100000| 0.0891089|
|Baseline-Haiku  |D2      |  63|    16|      39| 0.2539683| 0.1612903| 0.3500219|
|Baseline-Sonnet |D2      |  98|     3|       4| 0.0306122| 0.0099010| 0.0612245|
|Baseline-Haiku  |D3      | 101|    17|       1| 0.1683168| 0.1078431| 0.2323232|
|Baseline-Sonnet |D3      | 101|     4|       1| 0.0396040| 0.0098039| 0.0784314|
|Baseline-Haiku  |D4      |  95|    35|       7| 0.3684211| 0.2783505| 0.4623656|
|Baseline-Sonnet |D4      |  70|     3|      32| 0.0428571| 0.0000000| 0.0909091|
|Baseline-Haiku  |D5      | 101|    54|       1| 0.5346535| 0.4455446| 0.6200000|
|Baseline-Sonnet |D5      | 101|    12|       1| 0.1188119| 0.0594059| 0.1800000|

### ARBITER proposals and recorded overrides

|arm            |domain |status               |   n| count| missing|  estimate| lower|     upper|
|:--------------|:------|:--------------------|---:|-----:|-------:|---------:|-----:|---------:|
|ARBITER-Haiku  |D1-D5  |Proposed agreement   | 505|   505|       5| 1.0000000|     1| 1.0000000|
|ARBITER-Haiku  |D1-D5  |Recorded override    | 505|     1|       5| 0.0019802|     0| 0.0059406|
|ARBITER-Haiku  |D1-D5  |Unrecorded violation | 505|     0|       5| 0.0000000|     0| 0.0000000|
|ARBITER-Sonnet |D1-D5  |Proposed agreement   | 510|   510|       0| 1.0000000|     1| 1.0000000|
|ARBITER-Sonnet |D1-D5  |Recorded override    | 510|     0|       0| 0.0000000|     0| 0.0000000|
|ARBITER-Sonnet |D1-D5  |Unrecorded violation | 510|     0|       0| 0.0000000|     0| 0.0000000|
|ARBITER-Haiku  |D1     |Proposed agreement   | 101|   101|       1| 1.0000000|     1| 1.0000000|
|ARBITER-Haiku  |D1     |Recorded override    | 101|     1|       1| 0.0099010|     0| 0.0297030|
|ARBITER-Haiku  |D1     |Unrecorded violation | 101|     0|       1| 0.0000000|     0| 0.0000000|
|ARBITER-Sonnet |D1     |Proposed agreement   | 102|   102|       0| 1.0000000|     1| 1.0000000|
|ARBITER-Sonnet |D1     |Recorded override    | 102|     0|       0| 0.0000000|     0| 0.0000000|
|ARBITER-Sonnet |D1     |Unrecorded violation | 102|     0|       0| 0.0000000|     0| 0.0000000|
|ARBITER-Haiku  |D2     |Proposed agreement   | 101|   101|       1| 1.0000000|     1| 1.0000000|
|ARBITER-Haiku  |D2     |Recorded override    | 101|     0|       1| 0.0000000|     0| 0.0000000|
|ARBITER-Haiku  |D2     |Unrecorded violation | 101|     0|       1| 0.0000000|     0| 0.0000000|
|ARBITER-Sonnet |D2     |Proposed agreement   | 102|   102|       0| 1.0000000|     1| 1.0000000|
|ARBITER-Sonnet |D2     |Recorded override    | 102|     0|       0| 0.0000000|     0| 0.0000000|
|ARBITER-Sonnet |D2     |Unrecorded violation | 102|     0|       0| 0.0000000|     0| 0.0000000|
|ARBITER-Haiku  |D3     |Proposed agreement   | 101|   101|       1| 1.0000000|     1| 1.0000000|
|ARBITER-Haiku  |D3     |Recorded override    | 101|     0|       1| 0.0000000|     0| 0.0000000|
|ARBITER-Haiku  |D3     |Unrecorded violation | 101|     0|       1| 0.0000000|     0| 0.0000000|
|ARBITER-Sonnet |D3     |Proposed agreement   | 102|   102|       0| 1.0000000|     1| 1.0000000|
|ARBITER-Sonnet |D3     |Recorded override    | 102|     0|       0| 0.0000000|     0| 0.0000000|
|ARBITER-Sonnet |D3     |Unrecorded violation | 102|     0|       0| 0.0000000|     0| 0.0000000|
|ARBITER-Haiku  |D4     |Proposed agreement   | 101|   101|       1| 1.0000000|     1| 1.0000000|
|ARBITER-Haiku  |D4     |Recorded override    | 101|     0|       1| 0.0000000|     0| 0.0000000|
|ARBITER-Haiku  |D4     |Unrecorded violation | 101|     0|       1| 0.0000000|     0| 0.0000000|
|ARBITER-Sonnet |D4     |Proposed agreement   | 102|   102|       0| 1.0000000|     1| 1.0000000|
|ARBITER-Sonnet |D4     |Recorded override    | 102|     0|       0| 0.0000000|     0| 0.0000000|
|ARBITER-Sonnet |D4     |Unrecorded violation | 102|     0|       0| 0.0000000|     0| 0.0000000|
|ARBITER-Haiku  |D5     |Proposed agreement   | 101|   101|       1| 1.0000000|     1| 1.0000000|
|ARBITER-Haiku  |D5     |Recorded override    | 101|     0|       1| 0.0000000|     0| 0.0000000|
|ARBITER-Haiku  |D5     |Unrecorded violation | 101|     0|       1| 0.0000000|     0| 0.0000000|
|ARBITER-Sonnet |D5     |Proposed agreement   | 102|   102|       0| 1.0000000|     1| 1.0000000|
|ARBITER-Sonnet |D5     |Recorded override    | 102|     0|       0| 0.0000000|     0| 0.0000000|
|ARBITER-Sonnet |D5     |Unrecorded violation | 102|     0|       0| 0.0000000|     0| 0.0000000|

|arm           |slug      |domain |proposed |adopted       |rationale                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |evidence                                                                                                                                                                                                                  |
|:-------------|:---------|:------|:--------|:-------------|:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|ARBITER-Haiku |hill-2017 |D1     |Low      |Some concerns |The algorithm proposed Low, but sequence generation is no_information: the main article says only that participants were randomized, and neither the protocol's stratification description (section 8.2.1.c) nor the registry names a generation method. Official RoB 2 guidance treats a trial described as randomized with no further detail on the process as Some concerns, not Low, so the algorithm's Low does not reflect the reported process. Concealment and baseline balance do not raise concern and are unchanged. |sha256:4c6a1469d473e37187dfbdd2f51c53488d9835243a58aceb36ceaa1c4af17689; sha256:75e0ab0bb4f4a2b9b6635c5091d05ad60426bfcb6a4071c537b5172d1b1fcdb3; sha256:a68e44424483b669f80594c17fc7dd0c557968e1ca677ff5274574a35c251f0c |

ARBITER-Haiku: proposals agree with the official algorithm in 505/505 domains; one recorded hill-2017 D1 override gives 504/505 adopted-label agreement (99.80%). Five domain labels remain missing.
ARBITER-Sonnet Overall: 101 exact-consistent and one permitted escalation; zero violations.
Meta Overall: 74 exact-consistent, six permitted escalations, one violation among 81 observed labels.

## Adjudicator reliability

|comparison                       |   n|kappa                    |AC2                      |accuracy               |
|:--------------------------------|---:|:------------------------|:------------------------|:----------------------|
|A vs Z independent               | 154|0.587 (0.485 to 0.682)   |0.688 (0.607 to 0.769)   |0.740 (0.682 to 0.799) |
|A vs Z preferred                 | 154|0.687 (0.570 to 0.793)   |0.830 (0.767 to 0.889)   |0.838 (0.786 to 0.889) |
|A independent vs meta label      | 154|-0.079 (-0.168 to 0.012) |-0.056 (-0.182 to 0.071) |0.221 (0.158 to 0.285) |
|A independent vs ARBITER-Sonnet  | 154|0.517 (0.405 to 0.622)   |0.660 (0.571 to 0.741)   |0.695 (0.627 to 0.760) |
|A independent vs Baseline-Sonnet | 154|0.216 (0.129 to 0.304)   |0.280 (0.183 to 0.381)   |0.448 (0.381 to 0.516) |
|Z independent vs meta label      | 154|-0.077 (-0.176 to 0.027) |0.138 (0.036 to 0.244)   |0.273 (0.204 to 0.343) |
|Z independent vs ARBITER-Sonnet  | 154|0.670 (0.565 to 0.763)   |0.787 (0.726 to 0.846)   |0.779 (0.717 to 0.840) |
|Z independent vs Baseline-Sonnet | 154|0.307 (0.187 to 0.418)   |0.448 (0.370 to 0.529)   |0.494 (0.422 to 0.565) |

## Meta-label direction on consensus disputed cells

|direction   |   n| count|  estimate|     lower|     upper|
|:-----------|---:|-----:|---------:|---------:|---------:|
|Less severe | 129|    78| 0.6046512| 0.5284553| 0.6778552|
|Equal       | 129|    29| 0.2248062| 0.1587302| 0.2962963|
|More severe | 129|    22| 0.1705426| 0.1134644| 0.2313433|

## Grounding metric

|arm             |    n| quoted|  estimate|     lower|     upper|
|:---------------|----:|------:|---------:|---------:|---------:|
|ARBITER-Sonnet  | 1538|     34| 0.0221066| 0.0109536| 0.0347547|
|Baseline-Sonnet | 1459|      0| 0.0000000| 0.0000000| 0.0000000|
|ARBITER-Haiku   | 1552|     47| 0.0302835| 0.0165604| 0.0463320|
|Baseline-Haiku  | 1782|      3| 0.0016835| 0.0000000| 0.0044346|

Quotation syntax is descriptive and does not verify quotation accuracy.

## Added section 5.8: process and audit metrics

|arm             |metric                |   n| missing|       median|           q1|           q3|        total|
|:---------------|:---------------------|---:|-------:|------------:|------------:|------------:|------------:|
|ARBITER-Haiku   |wall_seconds          | 102|       0| 4.825500e+02| 4.073750e+02| 5.585500e+02| 6.884530e+04|
|ARBITER-Haiku   |input_tokens          | 102|       0| 1.160000e+02| 1.025000e+02| 1.240000e+02| 1.179200e+04|
|ARBITER-Haiku   |cache_creation_tokens | 102|       0| 5.677700e+05| 5.105020e+05| 6.170168e+05| 5.761925e+07|
|ARBITER-Haiku   |cache_read_tokens     | 102|       0| 5.789667e+06| 5.246519e+06| 6.297647e+06| 5.862166e+08|
|ARBITER-Haiku   |output_tokens         | 102|       0| 5.580000e+04| 4.843625e+04| 6.379250e+04| 5.718801e+06|
|ARBITER-Haiku   |thinking_tokens       | 102|       0| 2.774300e+04| 2.372775e+04| 3.243525e+04| 2.913354e+06|
|ARBITER-Haiku   |cost_usd              | 102|       0| 1.399761e+01| 1.239120e+01| 1.510473e+01| 1.447293e+03|
|ARBITER-Haiku   |turns                 | 102|       0| 2.000000e+00| 2.000000e+00| 2.000000e+00| 2.080000e+02|
|ARBITER-Haiku   |agent_steps           | 102|       0| 6.800000e+01| 6.300000e+01| 7.400000e+01| 6.988000e+03|
|ARBITER-Haiku   |continues             | 102|       0| 0.000000e+00| 0.000000e+00| 0.000000e+00| 4.000000e+00|
|ARBITER-Haiku   |approved              | 102|       0| 1.000000e+00| 1.000000e+00| 1.000000e+00| 1.020000e+02|
|ARBITER-Sonnet  |wall_seconds          | 102|       0| 4.567500e+02| 3.679000e+02| 6.307000e+02| 7.014020e+04|
|ARBITER-Sonnet  |input_tokens          | 102|       0| 9.600000e+01| 8.600000e+01| 1.040000e+02| 9.794000e+03|
|ARBITER-Sonnet  |cache_creation_tokens | 102|       0| 4.939730e+05| 4.596983e+05| 5.443870e+05| 5.069588e+07|
|ARBITER-Sonnet  |cache_read_tokens     | 102|       0| 4.964973e+06| 4.483251e+06| 5.585994e+06| 5.128678e+08|
|ARBITER-Sonnet  |output_tokens         | 102|       0| 2.136200e+04| 1.891350e+04| 2.428550e+04| 2.237043e+06|
|ARBITER-Sonnet  |thinking_tokens       | 102|       0| 3.451000e+03| 2.595750e+03| 4.183250e+03| 3.631540e+05|
|ARBITER-Sonnet  |cost_usd              | 102|       0| 1.111459e+01| 1.037543e+01| 1.206854e+01| 1.140339e+03|
|ARBITER-Sonnet  |turns                 | 102|       0| 2.000000e+00| 2.000000e+00| 2.000000e+00| 2.040000e+02|
|ARBITER-Sonnet  |agent_steps           | 102|       0| 6.000000e+01| 5.400000e+01| 7.175000e+01| 6.438000e+03|
|ARBITER-Sonnet  |continues             | 102|       0| 0.000000e+00| 0.000000e+00| 0.000000e+00| 0.000000e+00|
|ARBITER-Sonnet  |approved              | 102|       0| 1.000000e+00| 1.000000e+00| 1.000000e+00| 1.020000e+02|
|Baseline-Haiku  |wall_seconds          | 102|       0| 6.800000e+01| 5.165000e+01| 8.697500e+01| 7.020100e+03|
|Baseline-Haiku  |input_tokens          | 102|       0| 8.000000e+00| 6.000000e+00| 1.000000e+01| 8.720000e+02|
|Baseline-Haiku  |cache_creation_tokens | 102|       0| 3.940100e+04| 2.673725e+04| 5.988950e+04| 4.432900e+06|
|Baseline-Haiku  |cache_read_tokens     | 102|       0| 4.421850e+04| 2.476700e+04| 1.254340e+05| 8.581878e+06|
|Baseline-Haiku  |output_tokens         | 102|       0| 1.202750e+04| 9.561750e+03| 1.516425e+04| 1.258831e+06|
|Baseline-Haiku  |thinking_tokens       | 102|       0| 9.975500e+03| 7.739500e+03| 1.297725e+04| 1.059135e+06|
|Baseline-Haiku  |cost_usd              | 102|       0| 7.349685e-01| 5.432838e-01| 1.022172e+00| 8.009507e+01|
|Baseline-Haiku  |turns                 | 102|       0| 1.000000e+00| 1.000000e+00| 1.000000e+00| 1.020000e+02|
|Baseline-Haiku  |agent_steps           | 102|       0| 6.000000e+00| 5.000000e+00| 9.000000e+00| 7.390000e+02|
|Baseline-Haiku  |continues             | 102|       0| 0.000000e+00| 0.000000e+00| 0.000000e+00| 0.000000e+00|
|Baseline-Haiku  |approved              |   0|     102|           NA|           NA|           NA|           NA|
|Baseline-Sonnet |wall_seconds          | 102|       0| 2.720000e+01| 2.255000e+01| 3.120000e+01| 2.809200e+03|
|Baseline-Sonnet |input_tokens          | 102|       0| 6.000000e+00| 6.000000e+00| 6.000000e+00| 6.440000e+02|
|Baseline-Sonnet |cache_creation_tokens | 102|       0| 1.678950e+04| 1.075950e+04| 2.580450e+04| 1.910531e+06|
|Baseline-Sonnet |cache_read_tokens     | 102|       0| 2.469000e+04| 2.456325e+04| 2.495750e+04| 3.585005e+06|
|Baseline-Sonnet |output_tokens         | 102|       0| 2.396500e+03| 1.927250e+03| 2.923750e+03| 2.485790e+05|
|Baseline-Sonnet |thinking_tokens       | 102|       0| 1.041000e+03| 6.730000e+02| 1.348250e+03| 1.083840e+05|
|Baseline-Sonnet |cost_usd              | 102|       0| 2.414382e-01| 1.732116e-01| 3.398693e-01| 2.711551e+01|
|Baseline-Sonnet |turns                 | 102|       0| 1.000000e+00| 1.000000e+00| 1.000000e+00| 1.020000e+02|
|Baseline-Sonnet |agent_steps           | 102|       0| 4.000000e+00| 4.000000e+00| 5.000000e+00| 4.640000e+02|
|Baseline-Sonnet |continues             | 102|       0| 0.000000e+00| 0.000000e+00| 0.000000e+00| 0.000000e+00|
|Baseline-Sonnet |approved              |   0|     102|           NA|           NA|           NA|           NA|

|estimand                     |     estimate|        lower|        upper| valid_replicates|metric                |
|:----------------------------|------------:|------------:|------------:|----------------:|:---------------------|
|Mean paired trial difference | 6.601078e+02| 5.046185e+02| 8.466158e+02|            10000|wall_seconds          |
|Total paired difference      | 6.733100e+04| 5.147109e+04| 8.635481e+04|            10000|wall_seconds          |
|Mean paired trial difference | 8.970588e+01| 8.766667e+01| 9.172549e+01|            10000|input_tokens          |
|Total paired difference      | 9.150000e+03| 8.942000e+03| 9.356000e+03|            10000|input_tokens          |
|Mean paired trial difference | 4.782877e+05| 4.693900e+05| 4.871239e+05|            10000|cache_creation_tokens |
|Total paired difference      | 4.878535e+07| 4.787778e+07| 4.968664e+07|            10000|cache_creation_tokens |
|Mean paired trial difference | 4.992969e+06| 4.867215e+06| 5.117104e+06|            10000|cache_read_tokens     |
|Total paired difference      | 5.092828e+08| 4.964559e+08| 5.219446e+08|            10000|cache_read_tokens     |
|Mean paired trial difference | 1.949475e+04| 1.882947e+04| 2.014439e+04|            10000|output_tokens         |
|Total paired difference      | 1.988464e+06| 1.920606e+06| 2.054728e+06|            10000|output_tokens         |
|Mean paired trial difference | 2.497745e+03| 2.318937e+03| 2.679227e+03|            10000|thinking_tokens       |
|Total paired difference      | 2.547700e+05| 2.365316e+05| 2.732812e+05|            10000|thinking_tokens       |
|Mean paired trial difference | 1.091395e+01| 1.071091e+01| 1.110942e+01|            10000|cost_usd              |
|Total paired difference      | 1.113223e+03| 1.092513e+03| 1.133161e+03|            10000|cost_usd              |
|Mean paired trial difference | 1.000000e+00| 1.000000e+00| 1.000000e+00|            10000|turns                 |
|Total paired difference      | 1.020000e+02| 1.020000e+02| 1.020000e+02|            10000|turns                 |
|Mean paired trial difference | 5.856863e+01| 5.685294e+01| 6.027451e+01|            10000|agent_steps           |
|Total paired difference      | 5.974000e+03| 5.799000e+03| 6.148000e+03|            10000|agent_steps           |
|Mean paired trial difference | 0.000000e+00| 0.000000e+00| 0.000000e+00|            10000|continues             |
|Total paired difference      | 0.000000e+00| 0.000000e+00| 0.000000e+00|            10000|continues             |

|metric              | estimate| lower| upper| valid_replicates|    n| count|arm             |note          |
|:-------------------|--------:|-----:|-----:|----------------:|----:|-----:|:---------------|:-------------|
|Evidence coverage   |        1|     1|     1|            10000| 1552|  1552|ARBITER-Haiku   |NA            |
|Bundle verification |        1|     1|     1|            10000|  102|   102|ARBITER-Haiku   |NA            |
|Evidence coverage   |        1|     1|     1|            10000| 1538|  1538|ARBITER-Sonnet  |NA            |
|Bundle verification |        1|     1|     1|            10000|  102|   102|ARBITER-Sonnet  |NA            |
|Evidence coverage   |       NA|    NA|    NA|                0|   NA|    NA|Baseline-Haiku  |Not available |
|Bundle verification |       NA|    NA|    NA|                0|   NA|    NA|Baseline-Haiku  |Not available |
|Evidence coverage   |       NA|    NA|    NA|                0|   NA|    NA|Baseline-Sonnet |Not available |
|Bundle verification |       NA|    NA|    NA|                0|   NA|    NA|Baseline-Sonnet |Not available |

|arm            | bases| answers|     share|
|:--------------|-----:|-------:|---------:|
|ARBITER-Haiku  |     1|     315| 0.2029639|
|ARBITER-Haiku  |     2|     659| 0.4246134|
|ARBITER-Haiku  |     3|     351| 0.2261598|
|ARBITER-Haiku  |     4|     150| 0.0966495|
|ARBITER-Haiku  |     5|      54| 0.0347938|
|ARBITER-Haiku  |     6|      14| 0.0090206|
|ARBITER-Haiku  |     7|       6| 0.0038660|
|ARBITER-Haiku  |     8|       3| 0.0019330|
|ARBITER-Sonnet |     1|     316| 0.2054616|
|ARBITER-Sonnet |     2|     699| 0.4544863|
|ARBITER-Sonnet |     3|     359| 0.2334200|
|ARBITER-Sonnet |     4|     109| 0.0708713|
|ARBITER-Sonnet |     5|      42| 0.0273082|
|ARBITER-Sonnet |     6|       7| 0.0045514|
|ARBITER-Sonnet |     7|       6| 0.0039012|

Costs are harness-reported with unknown basis; thinking tokens are part of output tokens. Baseline traces are not available.
All 102 Haiku bundles exist, including an empty award-1-2014 bundle: structural verification does not imply a completed assessment.

## Author completion and uncertainty

- Concurrent author amendments resolved provenance: claude-sonnet-5-5 and claude-haiku-5-5, medium effort; Claude Code 2.1.278, isolated homes; ARBITER 1.0.0, public commit 2f549ae.
- Run READMEs date ARBITER-Sonnet to 12 October 2026 (12:12–19:17 EDT) and the other arms to 14 October 2026. The requested AUTHORS placeholder remains alongside these facts for confirmation.
- The hill-2017 bundle confirms a recorded model override, with rationale and evidence exported; it is not an algorithm violation.
- Five candidate trace cells are supplied; only two contain qualifying double quotations. Authors select the final trace.
- Human taxonomy codes and second-author reliability remain pending; both supplied sheets have empty code columns.
- Checklist page/section/applicability fields, public repository and Zenodo DOI require authors.
- Missing ordinal penalties, incomplete consistency paths, and split sensitivity conventions are recorded below.
- No Python was used. The binding plan, glossary and tracked data files were not edited.

## Complete DEVIATIONS.md contents

# Analysis deviations and unresolved inputs

No Python is used. This file records conservative resolutions as they arise.

1. **Amended section 5.4 gate passes; consistency exception.** ARBITER-Sonnet reproduces
   510/510 domain labels. ARBITER-Haiku reproduces 504/505 observed labels:
   hill-2017 D1 reports Some concerns, but 1.1=NI, 1.2=PY, 1.3=N gives Low
   under official Table 4 (printed p. 20) and the retrieved ARBITER source.
   Five additional Haiku cells (award-1-2014 D1-D5) have no labels or answers.
   The amended gate permits this single independently established exception.
   It is listed in the supplement and footnoted on the Haiku consistency rate;
   the bundle now confirms a recorded model override (see resolution below). The five missing cells belong to an
   unfinished run (continues=1), count as wrong, and have an exclusion sensitivity.
   No algorithm or input label was changed. This entry folds in the retired
   VALIDATION-HALT.md. Guidance: https://www.cochrane.de/sites/cochrane.de/files/uploads/RoB_2.0_guidance_2019.pdf
   (Tables 3–4, printed pp. 19–20); source cross-check:
   https://github.com/AliSalman-et-al/ARBITER/blob/2f549ae30f056ff441ea61a04b719968716f2219/src/arbiter/logic/evaluator.py
   (randomization branch); question locators: src/arbiter/packs/scientific.py.
   These sources both give Low for NI/PY/N. The later author amendment and supplied
   bundles resolve this as a recorded model override, with proposed=Low,
   adopted=Some concerns, rationale and evidence. It is not an algorithm violation.
   Table 3 distinguishes proposed-algorithm agreement from recorded overrides.
2. **Run provenance resolved after the initial CSV-only stage.** Author commits
   supplied run READMEs, metadata and bundles during this implementation. Models
   are claude-sonnet-5-5 and claude-haiku-5-5, effort medium; Claude Code 2.1.278
   used isolated homes. ARBITER-Sonnet ran 12 October 2026 (12:12–19:17 EDT),
   the other arms 14 October 2026, per READMEs. The author amendment identifies
   ARBITER 1.0.0, public commit 2f549ae30f056ff441ea61a04b719968716f2219,
   as the run version. Earlier internal names/commit IDs are not published in
   report outputs. The requested AUTHORS placeholder remains for confirmation
   alongside these documented facts; no date is inferred from file timestamps.
3. **Missing ordinal judgements.** The plan requires missing arm labels to count
   as wrong but does not define ordinal coefficients for missing predictions.
   For Haiku only, missing predictions are assigned the opposite extreme of the
   reference (High for Low; Low otherwise) for coefficient calculations. This
   imposes maximal linear disagreement and also fails exact and Not Low scoring.
   It is a penalty convention, not a recovered judgement. Confusion matrices retain
   Missing explicitly. The sensitivity excludes the same cells from both Haiku
   arms so their differences remain paired. Overall missing cells are handled too.
4. **Bootstrap and degenerate estimates.** Seed 20261018, 10,000 replicates,
   percentile type-7 intervals. The full 102-trial cohort is resampled within each
   meta; endpoint subsets are then selected. Every paired contrast uses identical
   replicate weights. Undefined replicates are omitted metric by metric, with the
   valid count exported; an entirely undefined interval is blank. The All-Low
   kappa is suppressed as explicitly directed by the plan; All-Low reports only
   accuracy and specificity. Other coefficients follow their usual formulas,
   including zero kappa for constant predictions when its denominator is nonzero.
5. **Split sensitivity.** Split discordant cells are forced ARBITER losses, without
   fabricating a baseline win. They join the residual Neither/forced-loss category.
6. **Grounding and exploratory answers.** Quotation words are whitespace-separated
   tokens inside paired straight or curly double quotes. This detects quotation
   syntax, not verification. Independent signalling answers define exploratory
   question eligibility, including explicit NA; missing arm answers count as wrong.
   Haiku is included in this non-adjudication-derived-arm comparison to independent
   signalling answers, but never in preferred-judgement endpoints or composites.
7. **Worked-trace candidates and raw bundles.** Five consensus cells where ARBITER
   beat the meta label are exported with verbatim ARBITER justifications. Only two
   eligible cells have an active justification meeting the five-word double-quote
   criterion; those are prioritised and flagged, and the draft trace uses one.
   The other three preserve the source justifications without inventing quotations.
   Raw logs and local untracked run files are ignored by git; run artefacts
   committed concurrently by the author remain tracked. The exported scoring
   inputs remain unchanged. This implementation adds no raw bundles, settings
   or trial PDFs to its analysis commits.
8. **Consistency denominators and codebook.** Missing reported labels or required
   active signalling answers make a cell not evaluable; no answer is inferred.
   Consistency rates use evaluable cells, and tables expose not-evaluable counts
   (including incomplete baseline answer paths). The deductive codebook uses one
   primary human-assigned code per losing source; second-author sample size is
   ceiling(20% of rows), fixed before coding. Author codes remain separate from
   optional reconciled final codes. The checklist is an abbreviated item-ID
   skeleton, with author applicability/page/section entries blank.
9. **Concurrent binding amendments incorporated.** Author commits added section
   5.8, resolved the recorded override, supplied provenance, and specified distinct
   baseline prompts during milestones 3–5. The last milestone incorporates these
   amendments. R streams JSONL in bounded chunks and cross-checks terminal usage
   against metadata. Four per-arm derived CSVs are committed; reports do not read
   raw logs/bundles. Extraction fails on absent logs and writes only after all
   inputs validate. No Python is needed. UTF-8 JSON is explicitly tagged when
   parsing strings on Windows; bytes and numeric fields are not altered.
10. **Process estimands and bundle denominators.** Section 5.8 does not specify
   the statistic for paired process differences. We report the mean paired
   per-trial difference and total difference, with the shared bootstrap; per-arm
   medians, quartiles and totals are also shown. Thinking tokens are a subset of
   output tokens and are not added again. Cost is harness-reported with unknown
   basis. Baseline approval/evidence/verification are not available, not zero.
   All 102 ARBITER-Haiku bundles exist, but award-1-2014 has no assessed domains;
   its empty bundle can verify structurally without supplying any judgement.
   Domain scoring remains missing/wrong; proposal and override denominators are
   505 observed Haiku domains. Bundle verification uses all available bundles,
   while evidence coverage uses their active answers. A pass is structural
   verification, not proof of assessment correctness or completion.
