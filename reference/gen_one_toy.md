# Generate a toy dataset with a single treatment effect (Updated to use gen_df_adv_k)

Generate a toy dataset with a single treatment effect (Updated to use
gen_df_adv_k)

## Usage

``` r
gen_one_toy(
  num_cov = 2,
  nc = 500,
  nt = 100,
  cluster_dist = 0.5,
  prop_nc_unif = 1/3,
  f0_sd = 0.5
)
```

## Arguments

- num_cov:

  Dimensionality of the feature space (number of covariates). Default is
  2.

- nc:

  Number of control units. Default is 500.

- nt:

  Number of treated units. Default is 100.

- cluster_dist:

  Distance between the two control clusters. Default is 0.5.

- prop_nc_unif:

  Proportion of control units drawn from a uniform distribution. Default
  is 1/3.

- f0_sd:

  Standard deviation for the noise in the potential outcome function f0.
  Default is 0.5.

## Value

A tibble with the toy dataset

## Examples

``` r
dat <- gen_one_toy(nt = 5)
dim(dat)
#> [1] 505  11
```
