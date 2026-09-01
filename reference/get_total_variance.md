# Calculate the total variance estimator (V)

Implements the total variance estimator from the paper, which accounts
for both measurement error variance (V_E) and population heterogeneity
variance (V_P).

## Usage

``` r
get_total_variance(
  matches,
  outcome = "Y",
  treatment = "Z",
  var_weight_type = "ess_units",
  variance_method = c("pooled", "pooled_het", "bootstrap", "ai06"),
  boot_mtd = "wild",
  B = 250,
  seed_addition = 11,
  cluster_comb_mtd = "average",
  df = NULL,
  ...
)
```

## Arguments

- matches:

  The CSM match object, an R S3 object

- outcome:

  Name of the outcome variable (default "Y")

- treatment:

  Name of the treatment variable (default "Z")

- var_weight_type:

  The way that cluster variances are averaged: "num_units": weight by
  number of units in the subclass "ess_units": weight by effective
  sample size of units in the subclass "uniform": weight each cluster
  equally

- variance_method:

  Method for calculating measurement error variance: "pooled": use
  get_measurement_error_variance (default). "bootstrap": use
  get_measurement_error_variance_OR. "pooled_het": allow for
  heterogeneity. "ai06": the estimator of Abadie and Imbens.
  **Incomplete:** this option is not yet implemented in this release (it
  calls an internal helper, `get_variance_AI06()`, that does not
  currently exist) and will error if selected.

- boot_mtd:

  Bootstrap method when variance_method = "bootstrap" (default: "wild")

- B:

  Number of bootstrap samples when variance_method = "bootstrap"
  (default: 250)

- seed_addition:

  Additional seed for bootstrap (default: 11)

- cluster_comb_mtd:

  How per-subclass variances are combined when
  `variance_method = "pooled_het"` (default "average").

- df:

  The *full* original data frame. Required when
  `variance_method = "ai06"`.

- ...:

  Additional arguments passed to the chosen variance estimator; e.g. `M`
  when `variance_method = "ai06"`.

## Value

A tibble with total variance (V), measurement error variance (V_E),
population heterogeneity variance (V_P), and other relevant statistics

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
get_total_variance(mtch, outcome = "Y")
#> # A tibble: 1 × 10
#>       V    V_E   V_P    SE   N_T ESS_C squared_deviations squared_deviations_s…¹
#>   <dbl>  <dbl> <dbl> <dbl> <int> <dbl>              <dbl>                  <dbl>
#> 1  3.34 0.0296 0.138 0.409    20  28.9               3.26                   3.43
#> # ℹ abbreviated name: ¹​squared_deviations_se_ver
#> # ℹ 2 more variables: V_correction <dbl>, sigma_hat <dbl>
```
