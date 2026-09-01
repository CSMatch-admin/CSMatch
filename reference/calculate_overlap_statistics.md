# Calculate Overlap Statistics (Backward Compatibility)

Wrapper function that maintains backward compatibility with the original
function name but now returns only the pairwise overlap statistics.

## Usage

``` r
calculate_overlap_statistics(csm)
```

## Arguments

- csm:

  A match object from matching procedures

## Value

Original pairwise overlap statistics for backward compatibility

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
calculate_overlap_statistics(mtch)
#> $avg_shared_controls
#> [1] 0
#> 
#> $p75_shared_controls
#> 75% 
#>   1 
#> 
#> $max_shared_controls
#> [1] 1
#> 
#> $avg_shared_treated
#> [1] 0
#> 
#> $p75_shared_treated
#> 75% 
#>   1 
#> 
#> $max_shared_treated
#> [1] 1
#> 
```
