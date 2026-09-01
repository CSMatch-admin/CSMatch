# Obtain table of treated units that were not matched

Obtain table of treated units that were not matched

## Usage

``` r
unmatched_units(csm)
```

## Arguments

- csm:

  A csm_matches object.

## Value

dataframe, one row per treated unit.

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
unmatched_units(mtch)
#> # A tibble: 0 × 7
#> # ℹ 7 variables: id <chr>, subclass <chr>, nc <dbl>, ess <dbl>, min_dist <dbl>,
#> #   max_dist <dbl>, adacal <dbl>
```
