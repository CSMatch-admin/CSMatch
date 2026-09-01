# Get the table of treated units

Get the table of treated units

## Usage

``` r
treatment_table(csm, id = NULL, threshold = NULL, bad = FALSE)
```

## Arguments

- csm:

  A csm_matches object

- id:

  Optional list of ids for treated units

- threshold:

  Optional distance threshold for treated units; return only units below
  this threshold unless "bad" is set to TRUE.

- bad:

  If TRUE, return only treated units above the threshold. If bad is TRUE
  and threshold is NULL, return treated units above the set caliper.

## Value

Dataframe of treated units

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
treatment_table(mtch)
#> # A tibble: 5 × 9
#>   id    subclass    nc   ess min_dist max_dist adacal feasible matched
#>   <chr> <chr>    <dbl> <dbl>    <dbl>    <dbl>  <dbl>    <dbl>   <dbl>
#> 1 1     1           38  2.83    0.365    0.975      1        1       1
#> 2 2     2           20  1.79    0.303    0.975      1        1       1
#> 3 3     3           13  1.86    0.243    0.962      1        1       1
#> 4 4     4           23  2.16    0.245    0.983      1        1       1
#> 5 5     5           24  2.57    0.344    0.972      1        1       1
```
