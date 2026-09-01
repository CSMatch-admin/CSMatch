# Summary method for csm_matches object

Summary method for csm_matches object

## Usage

``` r
# S3 method for class 'csm_matches'
summary(object, outcome = NULL, ...)
```

## Arguments

- object:

  A csm_matches object to summarize

- outcome:

  Optional name of an outcome column; if given, also reports the ATT
  estimate for that outcome.

- ...:

  Extra arguments (currently ignored).

## Value

Invisibly, a list with the csm_matches object (`csm`), the ATT estimate
table if `outcome` was given (`att`), and a table of subclass sizes
(`subclass_sizes`).

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
summary(mtch, outcome = "Y")
#> csm_matches: matching with "maximum" distance and "adaptive" radii
#> aggregating sets with "csm" method 
#> match covariates: X1, X2
#> 5 treated units matched to 91 of 500 control units 
#>  (0 exact matches, 5 below caliper, 0 above caliper) 
#> Adaptive calipers: 1, 1, 1, 1, 1 
#>  Target caliper = 1 
#> Max distance ranges 0.962 - 0.983 
#>  scaling: 5, 5
#> 91 unique control units matched, 14 with non-zero weight
#> ATT estimates and sample sizes:
#>      ATT        SE N_T N_C    ESS_C sigma_hat p_drop     S0_sq     S1_sq
#>  3.62224 0.2485548   5  14 10.09417        NA      0 0.2004606 0.2096023
#>       cov_w_s       t
#>  -0.002560678 14.5732
#> Subclass sizes (before weighting):
#> tb
#> 13 20 23 24 38 
#>  1  1  1  1  1 
#> Subclass sizes (after weighting):
#> 3 
#> 5 
#> Control unit reuse (before weighting):
#>  1  2  3 
#> 69 17  5 
#> Control unit reuse (after weighting):
#>  1  2 
#> 13  1 
#> Summary of aggregated control weights
#>    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#> 0.04772 0.22772 0.50523 0.52632 0.85648 1.00000 
```
