# Package index

## All functions

- [`agg_sc_units()`](AggregationMethods.md)
  [`agg_co_units()`](AggregationMethods.md)
  [`agg_avg_units()`](AggregationMethods.md) : Aggregation methods for
  matched data
- [`bad_matches()`](bad_matches.md) : Return result table for the bad
  matches
- [`boot_SE()`](boot_SE.md) : Estimate the variance from the bootstrap
- [`calculate_S1_sq_treated_to_treated()`](calculate_S1_sq_treated_to_treated.md)
  : Compute S1^2 via treated-to-treated matching
- [`calculate_overlap_statistics()`](calculate_overlap_statistics.md) :
  Calculate Overlap Statistics (Backward Compatibility)
- [`calculate_overlap_statistics_from_match_object()`](calculate_overlap_statistics_from_match_object.md)
  : Calculate Overlap Statistics from Match Object
- [`calculate_overlap_statistics_from_table()`](calculate_overlap_statistics_from_table.md)
  : Calculate Overlap Statistics from Matched Table
- [`caliper_distance_plot()`](caliper_distance_plot.md) : Distance of
  kth neighbor plot
- [`caliper_sensitivity_table()`](caliper_sensitivity_table.md)
  [`caliper_sensitivity_plot()`](caliper_sensitivity_table.md)
  [`caliper_sensitivity_plot_statistics()`](caliper_sensitivity_table.md)
  : Make sensitivity table or plot of impact of changing caliper
- [`caliper_table()`](caliper_table.md) : Return table of calipers for
  all treated units
- [`is.csm_matches()`](csm_matches.md)
  [`` `[`( ``*`<csm_matches>`*`)`](csm_matches.md)
  [`` `[[`( ``*`<csm_matches>`*`)`](csm_matches.md)
  [`dim(`*`<csm_matches>`*`)`](csm_matches.md)
  [`as.data.frame(`*`<csm_matches>`*`)`](csm_matches.md) : csm_matches
  object accessors
- [`distance_density_plot()`](distance_density_plot.md) : Calculate
  distances from treated units to their controls
- [`distance_table()`](distance_table.md) : Calculate distances from all
  matched treatment units to controls
- [`ess()`](ess.md) : Effective Sample Size
- [`ess_plot()`](ess_plot.md) : Effective sample size (ESS) plot
- [`estimate_ATT()`](estimate_ATT.md) : Estimate ATT and SE
- [`feasible_plot()`](feasible_plot.md) : Make feasible plot showing
  cumulative ATT as feasible units are added
- [`feasible_unit_subclass()`](feasible_unit_subclass.md) : List all IDs
  of subclasses of units that are feasible
- [`feasible_units()`](feasible_units.md) : Return table of feasible
  treated units
- [`gen_df_acic()`](gen_df_acic.md) : Generate data from the ACIC 2016
  competition
- [`gen_df_adv()`](gen_df_adv.md) : Generate toy data
- [`gen_df_adv_k()`](gen_df_adv_k.md) : Generate k-dimensional toy data
  (generalized version)
- [`gen_df_hain()`](gen_df_hain.md) : generate sample dataset from
  Hainmueller (2012), exactly
- [`gen_df_kang()`](gen_df_kang.md) : Simulation data from the Kang
  paper
- [`gen_matches()`](gen_matches.md) : Match treated units to control
  units
- [`gen_one_toy()`](gen_one_toy.md) : Generate a toy dataset with a
  single treatment effect (Updated to use gen_df_adv_k)
- [`gen_toy_covar()`](gen_toy_covar.md) : Generate covariates X1, X2 for
  the toy example
- [`get_cal_matches()`](get_cal_matches.md) : Caliper Synthetic Matching
- [`get_finite_variance()`](get_finite_variance.md) : Finite-sample
  variance estimator
- [`get_measurement_error_variance()`](get_measurement_error_variance.md)
  : Estimate the measurement error variance component (V_E)
- [`get_measurement_error_variance_OR()`](get_measurement_error_variance_OR.md)
  : Get the standard error using the OR bootstrap approach
- [`get_measurement_error_variance_het()`](get_measurement_error_variance_het.md)
  : Estimate the measurement error variance component (V_E) under
  heterogeneous errors
- [`get_total_variance()`](get_total_variance.md) : Calculate the total
  variance estimator (V)
- [`impact_plot()`](impact_plot.md) : Impact curve plot
- [`impact_table()`](impact_table.md) : Obtain impact table
- [`love_plot()`](love_plot.md) : Love plot of covariate balance
- [`params()`](params.md) : Return the parameters of the method
- [`print(`*`<csm_matches>`*`)`](print.csm_matches.md) : Print method
  for csm_matches object
- [`result_table()`](result_table.md) : Obtain table of aggregated
  results
- [`sensitivity_table()`](sensitivity_table.md) : Make sensitivity table
  of different ATT estimates
- [`summary(`*`<csm_matches>`*`)`](summary.csm_matches.md) : Summary
  method for csm_matches object
- [`treatment_table()`](treatment_table.md) : Get the table of treated
  units
- [`unmatched_units()`](unmatched_units.md) : Obtain table of treated
  units that were not matched
- [`update_matches()`](update_matches.md) : Update a matching call to
  change some parameters
