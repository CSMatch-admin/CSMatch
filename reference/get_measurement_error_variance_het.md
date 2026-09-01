# Estimate the measurement error variance component (V_E) under heterogeneous errors

Calculates the measurement error variance component allowing for
heterogeneous variances across matched subclasses. This uses
subclass-specific outcome variances and propagates them through the
weighting structure to estimate V_E.

## Usage

``` r
get_measurement_error_variance_het(
  matches_table,
  outcome = "Y",
  treatment = "Z",
  cluster_comb_mtd = "sample"
)
```

## Arguments

- matches_table:

  The data frame of the matched table (e.g., output from
  `full_unit_table`)

- outcome:

  Name of the outcome variable (default "Y")

- treatment:

  Name of the treatment variable (default "Z")

- cluster_comb_mtd:

  How per-subclass variances are combined across subclasses (default
  "sample").

## Value

A tibble with measurement error variance (V_E), pooled sigma_hat, N_T,
and ESS_C

## Examples

``` r
set.seed(4044440)
dat <- gen_one_toy(nt = 20)
mtch <- get_cal_matches(dat,
                        metric = "maximum",
                        scaling = c(1/0.2, 1/0.2),
                        caliper = 1,
                        rad_method = "adaptive",
                        est_method = "csm")
#> Warning: treatment variable not specified; defaulting to 'Z'
get_measurement_error_variance_het(result_table(mtch), outcome = "Y")
#> $V_E
#> [1] 0.02947523
#> 
#> $sigma_hat
#> [1] 0.5913112
#> 
#> $N_T
#> [1] 20
#> 
#> $ESS_C
#> [1] 28.88191
#> 
#> $var_calc_df
#> # A tibble: 245 × 6
#>    id        Z total_wt total_wt_squared avg_var_cluster rand_var_cluster
#>    <chr> <dbl>    <dbl>            <dbl>           <dbl>            <dbl>
#>  1 1         1        1                1           0.338            0.338
#>  2 10        1        1                1           0.266            0.266
#>  3 100       0        0                0           0.569            0.569
#>  4 104       0        0                0           0.569            0.569
#>  5 105       0        0                0           0.569            0.569
#>  6 108       0        0                0           0.569            0.569
#>  7 11        1        1                1           0.362            0.362
#>  8 112       0        0                0           0.569            0.569
#>  9 115       0        0                0           0.569            0.569
#> 10 116       0        0                0           0.569            0.569
#> # ℹ 235 more rows
#> 
```
