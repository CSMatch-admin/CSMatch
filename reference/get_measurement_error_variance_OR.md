# Get the standard error using the OR bootstrap approach

This function estimates the standard error of the ATT using a bootstrap
approach based on residuals from the OR method.

## Usage

``` r
get_measurement_error_variance_OR(
  matches,
  outcome = "Y",
  treatment = "Z",
  boot_mtd = "wild",
  B = 250,
  use_moving_block = FALSE,
  seed_addition = 11,
  block_size = NA
)
```

## Arguments

- matches:

  A CSM match object (R S3 object) or data frame

- outcome:

  Name of the outcome variable (default: "Y")

- treatment:

  Name of the treatment variable (default: "Z")

- boot_mtd:

  The bootstrap method to use. Options are "Bayesian", "wild", "sign",
  or "naive".

- B:

  Number of bootstrap samples (default: 250)

- use_moving_block:

  Whether to use a moving block bootstrap (default: FALSE)

- seed_addition:

  Additional seed value to ensure reproducibility (default: 11)

- block_size:

  Block size for bootstrap (default: NA, automatically chosen)

## Value

A tibble with measurement error variance (V_E), standard error (SE),
bootstrap confidence intervals, and sample sizes.

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
get_measurement_error_variance_OR(mtch, outcome = "Y", B = 20)
#> # A tibble: 1 × 6
#>     V_E    SE   N_T ESS_C CI_lower CI_upper
#>   <dbl> <dbl> <int> <dbl>    <dbl>    <dbl>
#> 1 0.452 0.672     5  10.1     2.82     4.89
```
