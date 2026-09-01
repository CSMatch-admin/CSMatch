# Return the parameters of the method

Return the parameters of the method

## Usage

``` r
params(csm)
```

## Arguments

- csm:

  A csm_matches object

## Value

A list of the settings used in the matching call

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
params(mtch)
#> $caliper
#> [1] 1
#> 
#> $rad_method
#> [1] "adaptive"
#> 
#> $metric
#> [1] "maximum"
#> 
#> $scaling
#> [1] 5 5
#> 
#> $treatment
#> [1] "Z"
#> 
#> $id_name
#> [1] "id"
#> 
#> $k
#> [1] 1
#> 
#> $est_method
#> [1] "csm"
#> 
#> $covariates
#> [1] "X1" "X2"
#> 
```
