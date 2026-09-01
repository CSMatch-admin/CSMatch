# Calculate Overlap Statistics from Match Object

Extracts a matched table from a match object and then calculates all
three overlap metrics.

## Usage

``` r
calculate_overlap_statistics_from_match_object(csm)
```

## Arguments

- csm:

  A match object from matching procedures.

## Value

A list containing all three sets of overlap statistics.

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
calculate_overlap_statistics_from_match_object(mtch)
#> $pairwise_overlap
#> $pairwise_overlap$avg_shared_controls
#> [1] 0
#> 
#> $pairwise_overlap$p75_shared_controls
#> 75% 
#>   1 
#> 
#> $pairwise_overlap$max_shared_controls
#> [1] 1
#> 
#> $pairwise_overlap$avg_shared_treated
#> [1] 0
#> 
#> $pairwise_overlap$p75_shared_treated
#> 75% 
#>   1 
#> 
#> $pairwise_overlap$max_shared_treated
#> [1] 1
#> 
#> 
#> $control_reuse
#> $control_reuse$mean_reuse
#> [1] 1.071429
#> 
#> $control_reuse$median_reuse
#> [1] 1
#> 
#> $control_reuse$max_reuse
#> [1] 2
#> 
#> 
#> $shared_per_treated
#> $shared_per_treated$mean_shared
#> [1] 0.4
#> 
#> $shared_per_treated$median_shared
#> [1] 0
#> 
#> $shared_per_treated$prop_shared
#> [1] 0.1333333
#> 
#> $shared_per_treated$max_shared
#> [1] 1
#> 
#> 
```
