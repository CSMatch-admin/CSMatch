# Effective Sample Size

Calculate the effective sample size given a vector of unit weights

## Usage

``` r
ess(weights)
```

## Arguments

- weights:

  A numeric vector of weights

## Value

The effective sample size

## Examples

``` r
ess(c(1, 1, 1, 1))
#> [1] 4
ess(c(1, 0.5, 0.5))
#> [1] 2.666667
```
