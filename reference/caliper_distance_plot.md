# Distance of kth neighbor plot

Plot distribution of distances between treated units and their
kth-nearest neighbors in the control group, for a set of k values.

## Usage

``` r
caliper_distance_plot(
  csm,
  tops = 1:3,
  caliper = NULL,
  target_percentile = NULL,
  target_k = 1
)
```

## Arguments

- csm:

  A csm_matches object

- tops:

  A vector of integers indicating which nearest neighbors to plot

- caliper:

  Optional caliper value to plot as a vertical line. Otherwise it will
  take caliper from csm object. If NA will plot no line.

- target_percentile:

  Optional target percentile for caliper, which will calculate caliper
  to achieve.

- target_k:

  Which of the values in `tops` to use when computing the caliper for
  `target_percentile` (default 1, the nearest neighbor).

## Value

The plot with some extra attributes. First is "distances", the table of
distances to the kth nearest neighbor. Second, if caliper provided,
"table" with the table of proportion of distances below the caliper for
each k. Last is "caliper", the caliper value used.

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
caliper_distance_plot(mtch, tops = c(1, 2, 3), target_percentile = 0.8)
#> `stat_bin()` using `bins = 30`. Pick better value `binwidth`.

```
