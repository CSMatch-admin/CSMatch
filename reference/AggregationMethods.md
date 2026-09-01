# Aggregation methods for matched data

These functions aggregate matched or synthetic-control–style output into
unit-level summaries.

## Usage

``` r
agg_sc_units(
  scweights,
  covariates = get_x_vars(scweights),
  treatment = "Z",
  outcome = NULL
)

agg_co_units(
  scweights,
  covariates = get_x_vars(scweights),
  treatment = "Z",
  outcome = NULL
)

agg_avg_units(
  scweights,
  covariates = get_x_vars(scweights),
  treatment = "Z",
  outcome = NULL
)
```

## Arguments

- scweights:

  Either a `csm_matches` object or a list/data frame of
  matching/synthetic-control weights where each subclass contains one
  treated row and its controls.

- covariates:

  Character vector of covariate names. Defaults to
  `get_x_vars(scweights)`.

- treatment:

  Name of the treatment indicator column.

- outcome:

  Name of the outcome column.

## Value

A `data.frame` with aggregated treated and control summaries.

## Details

**`agg_sc_units()`** Aggregate weights within treated-unit subclass to
make pairs of tx and corresponding synthetic control units. Generally
aggregate by cluster defined by treated unit, calculating the weighted
average of the control units in the cluster for all covariates any any
provided outcomes

**`agg_co_units()`** Aggregates across control units, collecting
repeated controls used across treated units and summing their weights.

**`agg_avg_units()`** Computes simple averages of controls within each
subclass (CEM-style averaging).

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
agg_sc_units(mtch, outcome = "Y")
#> # A tibble: 10 × 7
#>    id    subclass     Z     X1    X2     Y weights
#>    <chr> <chr>    <dbl>  <dbl> <dbl> <dbl>   <dbl>
#>  1 1_syn 1            0 0.404  0.244  4.66       1
#>  2 1     1            1 0.404  0.244  7.13       1
#>  3 2_syn 2            0 0.0330 0.223  4.99       1
#>  4 2     2            1 0.0330 0.223  5.68       1
#>  5 3_syn 3            0 0.863  0.838  4.64       1
#>  6 3     3            1 0.863  0.838 10.0        1
#>  7 4_syn 4            0 0.835  0.658  4.75       1
#>  8 4     4            1 0.835  0.658  9.32       1
#>  9 5_syn 5            0 0.802  0.779  4.70       1
#> 10 5     5            1 0.802  0.779  9.67       1
agg_co_units(mtch, outcome = "Y")
#> # A tibble: 96 × 15
#>    id        X1    X2     Z    noise Y0_denoised    Y0 Y1_denoised    Y1     Y
#>    <chr>  <dbl> <dbl> <dbl>    <dbl>       <dbl> <dbl>       <dbl> <dbl> <dbl>
#>  1 1     0.404  0.244     1  0.131          5.05  5.18        7.00  7.13  7.13
#>  2 100   0.538  0.352     0  0.125          5.07  5.20        7.74  7.87  5.20
#>  3 120   0.502  0.286     0 -0.316          4.97  4.66        7.34  7.02  4.66
#>  4 124   0.578  0.181     0  0.431          4.32  4.75        6.60  7.03  4.75
#>  5 133   0.578  0.154     0  0.520          4.19  4.71        6.39  6.91  4.71
#>  6 140   0.578  0.419     0 -0.400          5.14  4.74        8.13  7.73  4.74
#>  7 158   0.814  0.609     0 -0.238          4.91  4.67        9.18  8.94  4.67
#>  8 18    0.538  0.320     0 -0.0744         4.99  4.91        7.56  7.48  4.91
#>  9 2     0.0330 0.223     1  0.215          4.70  4.91        5.46  5.68  5.68
#> 10 3     0.863  0.838     1 -0.00439        4.95  4.95       10.1  10.0  10.0 
#> # ℹ 86 more rows
#> # ℹ 5 more variables: Y_denoised <dbl>, dist <lgl>, subclass <lgl>, unit <chr>,
#> #   weights <dbl>
agg_avg_units(mtch, outcome = "Y")
#> # A tibble: 10 × 7
#>    id    subclass     Z     X1    X2     Y weights
#>    <chr> <chr>    <dbl>  <dbl> <dbl> <dbl>   <dbl>
#>  1 1_avg 1            0 0.413  0.248  4.74       1
#>  2 1     1            1 0.404  0.244  7.13       1
#>  3 2_avg 2            0 0.125  0.257  4.67       1
#>  4 2     2            1 0.0330 0.223  5.68       1
#>  5 3_avg 3            0 0.804  0.846  4.95       1
#>  6 3     3            1 0.863  0.838 10.0        1
#>  7 4_avg 4            0 0.811  0.596  4.66       1
#>  8 4     4            1 0.835  0.658  9.32       1
#>  9 5_avg 5            0 0.767  0.772  4.85       1
#> 10 5     5            1 0.802  0.779  9.67       1
```
