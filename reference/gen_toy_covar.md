# Generate covariates X1, X2 for the toy example

Generate covariates X1, X2 for the toy example

## Usage

``` r
gen_toy_covar(n, X1_ctrs, X2_ctrs, SD)
```

## Arguments

- n:

  Number of samples

- X1_ctrs:

  A vector of two elements, representing the two different X1 locations

- X2_ctrs:

  Same as X1_ctrs, but for X2 locations.

- SD:

  Std. deviation of the blobs around the centers. Lower means tighter
  blobs and better separation between the two clusters. Higher means
  more overlap.

## Value

A tibble object with two columns X1, X2

## Examples

``` r
n = 100
X1_ctrs <- c(0.25, 0.75)
X2_ctrs <- c(0.25, 0.75)
SD <- 0.1
res <- gen_toy_covar(n, X1_ctrs, X2_ctrs, SD)
```
