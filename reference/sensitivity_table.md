# Make sensitivity table of different ATT estimates

Given a csm_matches object, this function computes several different ATT
estimates:

- FATT: ATT using only feasible treated units (i.e., those with matches
  within the caliper)

- ATT: ATT using all treated units, if there were adaptive calipers.

- ATT_1nn: ATT using nearest-neighbor controls (if tied, use all tied
  controls).

- ATT_raw: ATT, averaging all controls within each matched set.

- ATT_raw_feas: ATT, averaging all controls within each matched set, but
  only for feasible treated units.

## Usage

``` r
sensitivity_table(
  csm,
  outcome = "Y",
  feasible_only = FALSE,
  include_variances = FALSE,
  include_distances = TRUE
)
```

## Arguments

- csm:

  A csm_matches object

- outcome:

  Name of outcome variable in data

- feasible_only:

  If TRUE, also restrict the "ATT"/"ATT_1nn"/ "ATT_raw" rows to feasible
  treated units only (in addition to the "FATT" rows, which are always
  feasible-only).

- include_variances:

  If TRUE, include the individual variance components (e.g. `V`, `V_E`,
  `V_P`) for each estimate, not just the standard error.

- include_distances:

  If TRUE, include columns summarizing the distance between each treated
  unit and its matched/synthetic control (mean/median distance, and
  pseudo-SE/bias ratios relative to the raw-average estimate).

## Value

A tibble with the estimates and standard errors

## Details

These estimates can be used to assess sensitivity of results to
different choices in matching and estimation. Return results are from
the [`estimate_ATT()`](estimate_ATT.md) method

Note: this is not sensitivity in the sense of a Rosenbaum sensitivity
analysis of unmeasured confounding, but rather sensitivity akin to
sensitivity under differing modeling specifications and tuning parameter
selections.

## See also

[`estimate_ATT()`](estimate_ATT.md)

## Examples

``` r
set.seed(4044440)
dat <- gen_one_toy(nt = 5)
mtch <- get_cal_matches(dat,
                        metric = "maximum",
                        scaling = c(1/0.2, 1/0.2),
                        caliper = 1,
                        rad_method = "adaptive",
                        est_method = "csm")
#> Warning: treatment variable not specified; defaulting to 'Z'
sensitivity_table(mtch, outcome = "Y")
#> # A tibble: 6 × 17
#>   Estimate   ATT      SE   N_T   N_C ESS_C sigma_hat p_drop S0_sq   S1_sq
#>   <chr>    <dbl>   <dbl> <int> <int> <dbl>     <dbl>  <dbl> <dbl>   <dbl>
#> 1 ATT       3.62   0.249     5    14 10.1         NA      0 0.200   0.210
#> 2 ATT_1nn   4.02 NaN         5     4  3.57        NA      1 0     NaN    
#> 3 ATT_raw   3.60   0.212     5    91 61.9         NA      0 0.175   0.210
#> 4 FATT      3.62   0.249     5    14 10.1         NA      0 0.200   0.210
#> 5 FATT_1nn  4.02 NaN         5     4  3.57        NA      1 0     NaN    
#> 6 FATT_raw  3.60   0.212     5    91 61.9         NA      0 0.175   0.210
#> # ℹ 7 more variables: cov_w_s <dbl>, t <dbl>, mean_dist <dbl>,
#> #   median_dist <dbl>, SE_star <dbl>, SE_ratio <dbl>, bias_ratio <dbl>
```
