# Return table of calipers for all treated units

Return table of calipers for all treated units

## Usage

``` r
caliper_table(csm)
```

## Arguments

- csm:

  A csm_matches object.

## Value

Dataframe with one row per treated unit, giving its subclass,
feasibility, matched-control distance range, and adaptive caliper.

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
caliper_table(mtch)
#> # A tibble: 5 × 6
#>   id    subclass feasible min_dist max_dist adacal
#>   <chr> <chr>       <dbl>    <dbl>    <dbl>  <dbl>
#> 1 1     1               1    0.365    0.975      1
#> 2 2     2               1    0.303    0.975      1
#> 3 3     3               1    0.243    0.962      1
#> 4 4     4               1    0.245    0.983      1
#> 5 5     5               1    0.344    0.972      1
```
