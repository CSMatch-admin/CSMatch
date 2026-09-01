# Update a matching call to change some parameters

Refits [`get_cal_matches()`](get_cal_matches.md) on `data` reusing all
settings (metric, scaling, treatment, covariates, etc.) stored on `csm`,
except for any settings overridden via `...`.

## Usage

``` r
update_matches(csm, data, warn = TRUE, ...)
```

## Arguments

- csm:

  A csm_matches object

- data:

  The data frame to rematch (typically the same data originally passed
  to [`get_cal_matches()`](get_cal_matches.md))

- warn:

  A logical indicating whether to warn about dropped units (passed
  through to [`get_cal_matches()`](get_cal_matches.md))

- ...:

  Parameters to change in the matching call, e.g. `caliper` or
  `rad_method`

## Value

A new csm_matches object with updated parameters

## Examples

``` r
# Generate example data
set.seed(4044440)
dat <- gen_one_toy(nt = 5)

# Perform matching
mtch <- get_cal_matches(dat,
                        metric = "maximum",
                        scaling = c(1/0.2, 1/0.2),
                        caliper = 1,
                        rad_method = "adaptive",
                        est_method = "csm")
#> Warning: treatment variable not specified; defaulting to 'Z'

# View matching results
mtch
#> csm_matches: matching with "maximum" distance and "adaptive" radii
#> aggregating sets with "csm" method 
#> match covariates: X1, X2
#> 5 treated units matched to 91 of 500 control units 
#>  (0 exact matches, 5 below caliper, 0 above caliper) 
#> Adaptive calipers: 1, 1, 1, 1, 1 
#>  Target caliper = 1 
#> Max distance ranges 0.962 - 0.983 
#>  scaling: 5, 5

update_matches( mtch, dat, caliper = 0.5, rad_method = "fixed" )
#> csm_matches: matching with "maximum" distance and "fixed" radii
#> aggregating sets with "csm" method 
#> match covariates: X1, X2
#> 5 treated units matched to 26 of 500 control units 
#>  (0 exact matches, 5 below caliper, 0 above caliper) 
#> Adaptive calipers: 0.5, 0.5, 0.5, 0.5, 0.5 
#>  Target caliper = 0.5 
#> Max distance ranges 0.382 - 0.498 
#>  scaling: 5, 5
```
