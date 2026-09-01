# Generate toy data

generate data mostly in grid (0,1) x (0,1)

## Usage

``` r
gen_df_adv(
  nc,
  nt,
  f0_sd = 0.1,
  f0_fun = function(X1, X2) {
     1
 },
  tx_effect_fun = function(X1, X2) {
     1
 },
  f0_sd_fun = NULL,
  cluster_dist = 0.5,
  prop_nc_unif = 1/3
)
```

## Arguments

- nc:

  (something)

- nt:

  (something)

- f0_sd:

  degree of residual noise (default homoskedastic)

- f0_fun:

  (something)

- tx_effect_fun:

  (something)

- f0_sd_fun:

  Function to generate noise standard deviation. Default is NULL. If not
  null, override f0_sd.

- cluster_dist:

  Cluster separation, from 0 to 1; lower means better overlap

- prop_nc_unif:

  proportion of uniform controls. lower means worse overlap

## Value

A tibble containing a toy dataset. `Z` is numeric (0/1). Also includes
the `Y0_denoised`/`Y1_denoised`/`Y_denoised` (noiseless potential
outcome) columns that [`gen_df_adv_k()`](gen_df_adv_k.md) produces.

## Details

This is the fixed-2D-covariate special case of
[`gen_df_adv_k()`](gen_df_adv_k.md) (`k = 2`), implemented as a thin
wrapper around it so the two share one underlying DGP implementation.
`f0_fun`/`tx_effect_fun`/ `f0_sd_fun` here use the `function(X1, X2)`
calling convention (rather than [`gen_df_adv_k()`](gen_df_adv_k.md)'s
single k-column-matrix `function(X)`), for backward compatibility with
existing callers.

## Examples

``` r
dat <- gen_df_adv(nc = 100, nt = 10)
dim(dat)
#> [1] 110  11
```
