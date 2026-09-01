# Estimate the measurement error variance component (V_E)

Calculates the measurement error variance component using the pooled
variance approach described in the paper. This estimates the variance
component due to the noise in outcomes.

## Usage

``` r
get_measurement_error_variance(
  matches_table,
  outcome = "Y",
  treatment = "Z",
  var_weight_type = "ess_units"
)
```

## Arguments

- matches_table:

  The data frame of the matched table

- outcome:

  Name of the outcome variable (default "Y")

- treatment:

  Name of the treatment variable (default "Z")

- var_weight_type:

  The way that cluster variances are averaged: "num_units": weight by
  number of units in the subclass "ess_units": weight by effective
  sample size of units in the subclass "uniform": weight each cluster
  equally

## Value

A tibble with measurement error variance (V_E), sigma_hat, N_T, and
ESS_C

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
get_measurement_error_variance(result_table(mtch), outcome = "Y")
#> # A tibble: 1 × 4
#>      V_E sigma_hat   N_T ESS_C
#>    <dbl>     <dbl> <int> <dbl>
#> 1 0.0650     0.466     5  10.1
```
