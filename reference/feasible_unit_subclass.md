# List all IDs of subclasses of units that are feasible

For all units matched without expanding the caliper, get the subclass
IDs (i.e., the ids that link controls to treated units in matched
clusters).

## Usage

``` r
feasible_unit_subclass(csm)
```

## Arguments

- csm:

  A csm_matches object.

## Value

Character vector of subclass IDs.

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
feasible_unit_subclass(mtch)
#> [1] "1" "2" "3" "4" "5"
```
