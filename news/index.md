# Changelog

## CSMatch 0.1.0

Initial CRAN submission.

- Implements Caliper Synthetic Matching (CSM): radius/caliper matching
  on a user-specified covariate distance metric, with an optional
  synthetic-control weighting step
  ([`get_cal_matches()`](../reference/get_cal_matches.md)).
- Diagnostic tools for choosing a distance metric and caliper and for
  assessing match quality and covariate balance
  ([`caliper_distance_plot()`](../reference/caliper_distance_plot.md),
  [`love_plot()`](../reference/love_plot.md),
  [`sensitivity_table()`](../reference/sensitivity_table.md),
  [`caliper_sensitivity_plot()`](../reference/caliper_sensitivity_table.md),
  and related functions).
- Estimation of the average treatment effect on the treated with several
  variance estimators ([`estimate_ATT()`](../reference/estimate_ATT.md),
  [`boot_SE()`](../reference/boot_SE.md)).
- A vignette
  ([`vignette("lalonde-example")`](../articles/lalonde-example.md))
  walking through fitting and diagnosing a match on the LaLonde
  job-training data.
