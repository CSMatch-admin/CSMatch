# Estimate ATT and SE

Calculate ATT and associated standard error using the specified variance
estimator.

## Usage

``` r
estimate_ATT(
  matches,
  outcome = "Y",
  treatment = "Z",
  superpopulation = FALSE,
  homoskedastic = FALSE,
  use_common_variance = TRUE,
  var_weight_type = "ess_units",
  variance_method = "pooled",
  boot_mtd = "wild",
  B = 250,
  seed_addition = 11,
  cluster_comb_mtd = "average",
  feasible_only = FALSE,
  df = NULL,
  covs = NULL,
  scaling = NULL,
  metric = NULL,
  id_name = NULL,
  K = 1,
  ...
)
```

## Arguments

- matches:

  The CSM match object (csm_matches), or a data frame of matched units
  (must contain treatment, outcome, and weights columns).

- outcome:

  Name of the outcome variable (default "Y").

- treatment:

  Name of the treatment variable (default "Z").

- superpopulation:

  If TRUE (default), use the superpopulation variance estimator via
  [`get_total_variance()`](get_total_variance.md). If FALSE, use the
  finite-sample estimator via
  [`get_finite_variance()`](get_finite_variance.md).

- homoskedastic:

  Passed to [`get_finite_variance()`](get_finite_variance.md) when
  `superpopulation = FALSE`; if TRUE, assume treated and control units
  share a common variance.

- use_common_variance:

  Passed to [`get_finite_variance()`](get_finite_variance.md) when
  `superpopulation = FALSE`; if TRUE (default), estimate S1^2 from
  control-side subclass variances rather than treated-to-treated K-NN
  matching.

- var_weight_type:

  How cluster variances are averaged (default "ess_units"): "num_units"
  weights by number of units in the subclass; "ess_units" weights by
  effective sample size; "uniform" weights each cluster equally.

- variance_method:

  Variance method passed to
  [`get_total_variance()`](get_total_variance.md): "pooled" (default),
  "pooled_het", "bootstrap", or "ai06" (**incomplete**, not yet
  implemented in this release; will error if selected). Ignored when
  `superpopulation = FALSE`.

- boot_mtd:

  Bootstrap method when variance_method = "bootstrap" (default: "wild").

- B:

  Number of bootstrap samples (default: 250).

- seed_addition:

  Additional seed for bootstrap (default: 11).

- cluster_comb_mtd:

  How per-unit variances are combined when variance_method =
  "pooled_het" (default: "average").

- feasible_only:

  Logical; use only feasible matches (default FALSE).

- df:

  The *full* original data frame. Required for 'ai06' method and for
  [`get_finite_variance()`](get_finite_variance.md) when
  `use_common_variance = FALSE`.

- covs, scaling, metric, id_name:

  Passed to [`get_finite_variance()`](get_finite_variance.md) (and on to
  [`calculate_S1_sq_treated_to_treated()`](calculate_S1_sq_treated_to_treated.md))
  when `superpopulation = FALSE` and `use_common_variance = FALSE`. If
  `matches` is a csm_matches object, any of these left `NULL` are filled
  in from `params(matches)`; otherwise they must be supplied directly
  (required when `matches` is a plain data frame).

- K:

  Number of treated neighbours for the treated-to-treated K-NN step,
  passed to [`get_finite_variance()`](get_finite_variance.md) when
  `use_common_variance = FALSE` (default 1).

- ...:

  Additional arguments passed to
  [`get_total_variance()`](get_total_variance.md) when
  `superpopulation = TRUE`, e.g. `M` for the 'ai06' method.

## Value

A tibble with ATT estimate (ATT), standard error (SE), t-statistic (t),
total variance (V), measurement error variance (V_E), population
heterogeneity variance (V_P), and other relevant statistics.

## Details

This will implement both finite-sample and superpopulation variance
estimation. For superpopulation inference, it can also do the OR
bootstrap, if specified.

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
estimate_ATT(mtch, outcome = "Y")
#> # A tibble: 1 × 12
#>     ATT    SE   N_T   N_C ESS_C sigma_hat    V_E p_drop S0_sq S1_sq  cov_w_s
#>   <dbl> <dbl> <int> <int> <dbl>     <dbl>  <dbl>  <dbl> <dbl> <dbl>    <dbl>
#> 1  3.62 0.249     5    14  10.1        NA 0.0618      0 0.200 0.210 -0.00256
#> # ℹ 1 more variable: t <dbl>
```
