# Impact curve plot

Plot the relationship between maximum distance in matched set and the
outcome difference within matched sets.

## Usage

``` r
impact_plot(csm, outcome, min_dist = TRUE, jitter = FALSE)
```

## Arguments

- csm:

  A csm_matches object

- outcome:

  The name of the outcome variable to plot.

- min_dist:

  If TRUE (default), use the minimum distance from the treated unit to
  its matched controls as the x-axis; if FALSE, use the maximum
  distance.

- jitter:

  If TRUE, jitter the plotted points horizontally to reduce overplotting
  from tied distances.

## Value

A ggplot object showing the impact curve. Also has an attribute "table"
with the underlying data used to create the plot.

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
impact_plot(mtch, outcome = "Y")
#> `geom_smooth()` using formula = 'y ~ x'
#> Warning: span too small.   fewer data values than degrees of freedom.
#> Warning: pseudoinverse used at 0.24288
#> Warning: neighborhood radius 0.059942
#> Warning: reciprocal condition number  0
#> Warning: There are other near singularities as well. 0.0039343
#> Warning: Chernobyl! trL>n 5
#> Warning: Chernobyl! trL>n 5
#> Warning: NaNs produced
#> Warning: span too small.   fewer data values than degrees of freedom.
#> Warning: pseudoinverse used at 0.24288
#> Warning: neighborhood radius 0.059942
#> Warning: reciprocal condition number  0
#> Warning: There are other near singularities as well. 0.0039343
#> Warning: NaNs produced
#> Warning: no non-missing arguments to max; returning -Inf
```
