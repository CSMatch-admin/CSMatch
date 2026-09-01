# Simulation data from the Kang paper

A DGP for simulation studies.

## Usage

``` r
gen_df_kang(n = 1000)
```

## Arguments

- n:

  Number of samples to generate

## Value

A data frame with covariates and outcome

## Details

Generates a 4 dimensional multivariate normal that then gets transformed
to generate four "X" variables. The Outcome is a function of the
original V variables.

## Examples

``` r
dat <- gen_df_kang(n = 200)
dim(dat)
#> [1] 200  12
```
