# Estimate the variance from the bootstrap

This is the main bootstrap function.

## Usage

``` r
boot_SE(
  matches_table,
  outcome = "Y",
  treatment = "Z",
  B = 100,
  boot_mtd = "sign"
)
```

## Arguments

- matches_table:

  The data frame of the matched table, or a csm_matches object
  (converted internally via [`result_table()`](result_table.md)).

- outcome:

  Name of the outcome variable (default "Y")

- treatment:

  Name of the treatment variable (default "Z")

- B:

  Number of bootstrap resamples (default 100).

- boot_mtd:

  Bootstrap resampling method: one of "Bayesian", "wild", "sign"
  (default), or "naive".

## Value

A tibble with columns `SE_unif_weight` and `SE_SCM_weight`, the
bootstrap standard errors of the ATT under uniform (CEM-style) and CSM
synthetic-control weighting, respectively.

## Examples

``` r
set.seed(4044440)
dat <- gen_one_toy(nt = 20)
mtch <- get_cal_matches(dat,
                        metric = "maximum",
                        scaling = c(1/0.2, 1/0.2),
                        caliper = 1,
                        rad_method = "adaptive",
                        est_method = "csm")
#> Warning: treatment variable not specified; defaulting to 'Z'
boot_SE(mtch, B = 50)
#> # A tibble: 1 × 2
#>   SE_unif_weight SE_SCM_weight
#>            <dbl>         <dbl>
#> 1           18.4          18.4
```
