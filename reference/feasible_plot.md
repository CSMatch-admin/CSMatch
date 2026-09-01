# Make feasible plot showing cumulative ATT as feasible units are added

Given a csm_matches object, this function makes a plot showing how the
cumulative ATT estimate changes as more feasible treated units are added
(i.e., as the caliper size increases to include more treated units).

## Usage

``` r
feasible_plot(csm, outcome = "Y", return_table = FALSE, caliper_plot = FALSE)
```

## Arguments

- csm:

  A csm_matches object

- outcome:

  Name of the outcome column to use for the cumulative ATT estimate
  (default "Y").

- return_table:

  If TRUE, return the full table of results instead of a plot

- caliper_plot:

  If TRUE, return a plot of maximum caliper size vs number of treated
  units. If "both" return a list of both plots, along with the table
  itself.

## Value

A ggplot object showing the feasible plot, or a table of results if
return_table is TRUE.

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
feasible_plot(mtch, outcome = "Y")
#> `geom_line()`: Each group consists of only one observation.
#> ℹ Do you need to adjust the group aesthetic?

```
