# Calculate distances from all matched treatment units to controls

Look at distances between each treated unit and their synthetic control,
average control, and closest control.

## Usage

``` r
distance_table(csm, long_table = FALSE)
```

## Arguments

- csm:

  A csm_matches object

- long_table:

  If TRUE, return a long-form table with method and distance columns. If
  FALSE each tx unit is a row.

## Value

A data frame with distances from each treated unit to their synthetic
control, average control, and closest control.

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
distance_table(mtch)
#> # A tibble: 5 × 6
#>   id         CSM average closest feasible matched
#>   <chr>    <dbl>   <dbl>   <dbl>    <dbl>   <dbl>
#> 1 1     7.17e-13  0.0460   0.365        1       1
#> 2 2     3.97e-14  0.460    0.303        1       1
#> 3 3     3.36e-13  0.296    0.243        1       1
#> 4 4     2.11e-12  0.312    0.245        1       1
#> 5 5     2.66e-12  0.175    0.344        1       1
```
