# CSMatch 0.1.0

Initial development release.

* Implements Caliper Synthetic Matching (CSM): radius/caliper matching
  on a user-specified covariate distance metric, with an optional
  synthetic-control weighting step (`get_cal_matches()`).
* Diagnostic tools for choosing a distance metric and caliper and for
  assessing match quality and covariate balance (`caliper_distance_plot()`,
  `love_plot()`, `sensitivity_table()`, `caliper_sensitivity_plot()`,
  and related functions).
* Estimation of the average treatment effect on the treated with
  several variance estimators (`estimate_ATT()`, `boot_SE()`).
* A vignette (`vignette("lalonde-example")`) walking through fitting
  and diagnosing a match on the LaLonde job-training data.
