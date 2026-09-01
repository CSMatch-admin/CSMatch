# Effective sample size (ESS) plot

Plot the effective sample size (ESS) of the treated units, and various
forms of possible control groups depending on their weighting.

## Usage

``` r
ess_plot(csm, feasible_only = FALSE)
```

## Arguments

- csm:

  A csm_matches object.

- feasible_only:

  If TRUE, compute ESS over only the feasible treated units (those
  matched within the target caliper); otherwise use all treated units
  (including those matched via an expanded adaptive caliper).

## Value

A ggplot object (bar chart of ESS by weighting method), with the
underlying table of values attached as the `"table"` attribute.

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
ess_plot(mtch)

```
