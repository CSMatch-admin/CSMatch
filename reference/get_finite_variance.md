# Finite-sample variance estimator

Implements the plug-in estimator hat_V = S1^2 / n_T + S0^2 / ESS(C)
where S0^2 is the w_j^2-weighted average of s_j^2 across control units,
and S1^2 is either the simple average of s_t^2 (common-variance
assumption) or the average of s_1t^2 from treated-to-treated K-NN
matching.

## Usage

``` r
get_finite_variance(
  matches,
  df = NULL,
  outcome = "Y",
  treatment = "Z",
  use_common_variance = TRUE,
  homoskedastic = FALSE,
  K = 1,
  covs = NULL,
  scaling = NULL,
  metric = "maximum",
  id_name = "id"
)
```

## Arguments

- matches:

  Fitted CSM object (csm_matches) or a matched data frame (e.g. output
  of `full_unit_table()`).

- df:

  Full original data frame. Required when `use_common_variance = FALSE`
  and `matches` is a data frame.

- outcome:

  Name of outcome variable (default "Y").

- treatment:

  Name of treatment variable (default "Z").

- use_common_variance:

  If TRUE (default), estimate S1^2 from the control-side subclass
  variances (assuming sigma_1(x)=sigma_0(x)). If FALSE, estimate S1^2
  via treated-to-treated K-NN matching.

- homoskedastic:

  If TRUE, assume a single common variance across treated and control
  units, setting S1^2 = S0^2 (only used when
  `use_common_variance = TRUE`).

- K:

  Number of treated neighbours for the treated-to-treated step (used
  only when `use_common_variance = FALSE`).

- covs:

  Character vector of covariate names. Ignored when `matches` is a CSM
  object (extracted from `params(matches)`). Required when `matches` is
  a data frame and `use_common_variance = FALSE`.

- scaling:

  Per-covariate scaling vector. Same rules as `covs`.

- metric:

  Distance metric (default "maximum"). Same rules as `covs`.

- id_name:

  Name of the unit ID column (default "id"). Same rules as `covs`.

## Value

A tibble with columns matching
[`get_total_variance()`](get_total_variance.md): `V` (= V_E \* N_T, for
SE = sqrt(V)/sqrt(N_T) consistency), `V_E` (the finite-sample variance
estimate S1^2/N_T + S0^2/ESS_C), `V_P` (NA — not decomposed by this
estimator), `SE` (= sqrt(V_E)), `N_T`, `ESS_C`, `sigma_hat` (NA), plus
diagnostics `S0_sq`, `S1_sq`, `cov_w_s`.

## Details

Also returns the estimated empirical covariance Cov_p(w_j, s_j^2) which
goes with the alternate formulation of:

hat_V_alt = S^2\*(1/n_T + 1/ESS_C) + (1/n_T)\*Cov_p(w_j, s_j^2)

where S is a pooled estimate of S1 and S0

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
get_finite_variance(mtch, outcome = "Y")
#> # A tibble: 1 × 10
#>      SE   N_T   N_C ESS_C sigma_hat    V_E p_drop S0_sq S1_sq  cov_w_s
#>   <dbl> <int> <int> <dbl>     <dbl>  <dbl>  <dbl> <dbl> <dbl>    <dbl>
#> 1 0.249     5    14  10.1        NA 0.0618      0 0.200 0.210 -0.00256
```
