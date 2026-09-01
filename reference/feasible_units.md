# Return table of feasible treated units

Return those treated units with controls within the set caliper.

## Usage

``` r
feasible_units(csm)
```

## Arguments

- csm:

  A csm_matches object.

## Value

Dataframe of all the treated units (not controls) that were matched
within a caliper.

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
feasible_units(mtch)
#> # A tibble: 5 × 8
#>   id    subclass    nc   ess min_dist max_dist adacal matched
#>   <chr> <chr>    <dbl> <dbl>    <dbl>    <dbl>  <dbl>   <dbl>
#> 1 1     1           38  2.83    0.365    0.975      1       1
#> 2 2     2           20  1.79    0.303    0.975      1       1
#> 3 3     3           13  1.86    0.243    0.962      1       1
#> 4 4     4           23  2.16    0.245    0.983      1       1
#> 5 5     5           24  2.57    0.344    0.972      1       1
```
