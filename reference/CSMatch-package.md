# CSMatch: Caliper Synthetic Matching

CSMatch implements Caliper Synthetic Matching (CSM), a method for
matching in observational studies. Given an observational dataset, CSM
matches each treated unit to a set of nearby control units using a
(possibly adaptive) radius/caliper on a user-specified distance metric
over the covariates, and then builds a synthetic counterfactual for each
treated unit from its matched controls. The package also provides tools
for choosing a distance metric and caliper, diagnosing match quality,
and estimating (and getting standard errors for) the resulting average
treatment effect on the treated.

## Details

The typical workflow is:

1.  Call [`get_cal_matches()`](get_cal_matches.md) to match treated
    units to nearby control units (see `rad_method` for how the
    radius/caliper is chosen) and generate matched-set weights (see
    `est_method`, e.g. synthetic-control weights vs. simple averaging).
    This returns a [csm_matches](csm_matches.md) object.

2.  Use the diagnostic tools (e.g.
    [`caliper_distance_plot`](caliper_distance_plot.md),
    [`love_plot`](love_plot.md),
    [`sensitivity_table`](sensitivity_table.md),
    [`caliper_sensitivity_plot`](caliper_sensitivity_table.md)) to check
    match quality and tune the distance metric, scaling, and caliper.

3.  Refit with [`update_matches()`](update_matches.md) as those choices
    change, without having to respecify the entire call.

4.  Extract the final matched data with
    [`result_table()`](result_table.md) or
    [`as.data.frame()`](https://rdrr.io/r/base/as.data.frame.html), and
    estimate the treatment impact with
    [`estimate_ATT()`](estimate_ATT.md).

See
[`vignette("lalonde-example", package = "CSMatch")`](../articles/lalonde-example.md)
for a worked example, including how to select a distance metric and
caliper, on the canonical LaLonde job-training dataset.

## Main functions

- Matching:

  [`get_cal_matches`](get_cal_matches.md),
  [`gen_matches`](gen_matches.md), [`update_matches`](update_matches.md)

- The csm_matches object:

  [`result_table`](result_table.md),
  [`treatment_table`](treatment_table.md), [`params`](params.md),
  [`unmatched_units`](unmatched_units.md),
  [`bad_matches`](bad_matches.md)

- Diagnostics:

  [`caliper_distance_plot`](caliper_distance_plot.md),
  [`love_plot`](love_plot.md),
  [`distance_density_plot`](distance_density_plot.md),
  [`ess_plot`](ess_plot.md), [`feasible_plot`](feasible_plot.md),
  [`sensitivity_table`](sensitivity_table.md),
  [`caliper_sensitivity_table`](caliper_sensitivity_table.md),
  [`caliper_sensitivity_plot`](caliper_sensitivity_table.md)

- Estimation:

  [`estimate_ATT`](estimate_ATT.md), [`boot_SE`](boot_SE.md)

- Simulated data generators:

  [`gen_one_toy`](gen_one_toy.md), [`gen_df_adv`](gen_df_adv.md),
  [`gen_df_hain`](gen_df_hain.md), [`gen_df_kang`](gen_df_kang.md),
  [`gen_df_acic`](gen_df_acic.md)

## References

Che, J., Meng, X., & Miratrix, L. (2024). Caliper Synthetic Matching:
Generalized Radius Matching with Local Synthetic Controls.
<https://arxiv.org/abs/2411.05246>

## Author

**Maintainer**: Luke Miratrix <lmiratrix@g.harvard.edu>
([ORCID](https://orcid.org/0000-0002-0078-1906)) \[copyright holder\]

Authors:

- Xiang Meng <xmeng@g.harvard.edu>
  ([ORCID](https://orcid.org/0009-0000-7502-1314)) \[copyright holder\]

- Jonathan Che <jche@exponent.com> \[copyright holder\]
