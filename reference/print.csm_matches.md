# Print method for csm_matches object

Print method for csm_matches object

## Usage

``` r
# S3 method for class 'csm_matches'
print(x, ...)
```

## Arguments

- x:

  object to print

- ...:

  Extra arguments (currently ignored).

## Value

None, called for side effects (prints a summary to the console).

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
print(mtch)
#> csm_matches: matching with "maximum" distance and "adaptive" radii
#> aggregating sets with "csm" method 
#> match covariates: X1, X2
#> 5 treated units matched to 91 of 500 control units 
#>  (0 exact matches, 5 below caliper, 0 above caliper) 
#> Adaptive calipers: 1, 1, 1, 1, 1 
#>  Target caliper = 1 
#> Max distance ranges 0.962 - 0.983 
#>  scaling: 5, 5
```
