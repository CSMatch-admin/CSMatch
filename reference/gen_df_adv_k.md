# Generate k-dimensional toy data (generalized version)

Generate k-dimensional toy data (generalized version)

## Usage

``` r
gen_df_adv_k(
  nc,
  nt,
  k,
  f0_sd = 0.1,
  f0_fun = function(X) {
     rep(1, nrow(X))
 },
  tx_effect_fun = function(X) {
     rep(1, nrow(X))
 },
  f0_sd_fun = NULL,
  cluster_dist = 0.5,
  prop_nc_unif = 1/3
)
```

## Arguments

- nc:

  Number of control units.

- nt:

  Number of treated units.

- k:

  Dimensionality of the feature space.

- f0_sd:

  Standard deviation of the noise term.

- f0_fun:

  Function for baseline potential outcome Y0 (expects k-dim matrix X).

- tx_effect_fun:

  Function for treatment effect (expects k-dim matrix X).

- f0_sd_fun:

  Function of the k-dim matrix X to generate noise standard deviation
  (heteroskedastic noise). Default is NULL. If not NULL, overrides
  `f0_sd`.

- cluster_dist:

  Distance parameter influencing cluster separation.

- prop_nc_unif:

  Proportion of control units drawn uniformly from the \\\[0,1\]^k\\
  box.

## Value

A tibble containing a k-dimensional toy dataset. `Z` is numeric (0/1).

## Examples

``` r
dat <- gen_df_adv_k(nc = 100, nt = 10, k = 3)
dim(dat)
#> [1] 110  12
```
