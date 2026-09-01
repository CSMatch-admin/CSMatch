# Obtain impact table

This table summarizes the estimated impact for each treated unit, along
with the effective sample size of the controls used.

## Usage

``` r
impact_table(csm, outcome)
```

## Arguments

- csm:

  A csm_matches object from a matching call.

- outcome:

  Name of the outcome variable.

## Value

dataframe with one row per treated unit, with columns: subclass,
max_dist, outcome (estimated impact), precision (nominal precision of
the impact estimate, calculated as 1/(1 + 1/ess_C), nC (number of
controls used).

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
impact_table(mtch, outcome = "Y")
#> # A tibble: 5 × 6
#>   subclass min_dist max_dist outcome precision    nC
#>   <chr>       <dbl>    <dbl>   <dbl>     <dbl> <dbl>
#> 1 1           0.365    0.975   2.47      0.739     3
#> 2 2           0.303    0.975   0.692     0.642     3
#> 3 3           0.243    0.962   5.41      0.650     3
#> 4 4           0.245    0.983   4.57      0.684     3
#> 5 5           0.344    0.972   4.97      0.720     3
```
