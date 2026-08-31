# Column/variable names referenced via tidyverse non-standard evaluation
# (e.g. inside dplyr/ggplot2 verbs) rather than as function arguments.
# These are not undefined globals; this silences the corresponding
# R CMD check NOTE. See "Writing R Extensions", section 1.6.2.
#
utils::globalVariables(c(
  ".", ".env", ":=", "ATT", "CALIPER", "CSM", "Distance", "ESS_C", "Estimate",
  "N_T", "Rank", "SCM_weighted_sum_Y_Z0", "SE", "SE_star",
  "V1", "V2", "V3", "V4", "V5", "V6", "V_correction_term", "Value",
  "X1", "X2", "Y", "Y0", "Y0_denoised", "Y1", "Y1_denoised", "Y_Z1",
  "Y_bias_corrected", "Y_hat_0", "Y_t", "Z",
  "adacal", "average", "avg_var_cluster", "bias",
  "caliper", "closest", "correction_term", "cum_avg",
  "d", "distance", "e", "est", "feasible", "feasible_subclasses",
  "id", "lalonde_params", "matched", "max_dist", "mean_dist",
  "median_dist", "method", "min_dist", "mn", "n_c", "n_feasible",
  "name", "nc", "noise", "pct_below_caliper", "precision", "q025", "q975",
  "s_t_sq", "shape", "subclass",
  "sum_squared_weights", "sum_weights", "total_wt", "total_wt_squared",
  "tx", "uniform_weighted_sum_Y_Z0", "value", "var_cluster",
  "weight", "weights_SCM", "weights_unif"
))
