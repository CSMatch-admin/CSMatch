# Love plot of covariate balance

Make a ggplot love plot of covariate balance for each covariate passed.
Treated units are added one at a time, in order of increasing adaptive
caliper, and the running treated-vs-control mean difference is tracked
for each covariate.

## Usage

``` r
love_plot(csm, covs = NULL, covs_names = NULL)
```

## Arguments

- csm:

  A csm_matches object.

- covs:

  Character vector of covariate names to plot. Defaults to all
  covariates used in the match.

- covs_names:

  Optional character vector of display names for `covs`, in the same
  order.

## Value

A ggplot object.

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
love_plot(mtch, covs = c("X1", "X2"))
#> `geom_path()`: Each group consists of only one observation.
#> ℹ Do you need to adjust the group aesthetic?
#> `geom_path()`: Each group consists of only one observation.
#> ℹ Do you need to adjust the group aesthetic?

```
