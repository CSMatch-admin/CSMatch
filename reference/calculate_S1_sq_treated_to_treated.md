# Compute S1^2 via treated-to-treated matching

For each treated unit t, finds the K nearest treated units, then
computes s_1t^2 = (Y_t - mean_K-NN Y)^2. Returns S1^2 = mean_t(s_1t^2).

## Usage

``` r
calculate_S1_sq_treated_to_treated(
  df,
  treatment = "Z",
  outcome = "Y",
  K = 1,
  covs = NULL,
  scaling = NULL,
  metric = "maximum",
  id_name = "id"
)
```

## Arguments

- df:

  Full data frame (treated and control units).

- treatment:

  Name of treatment variable.

- outcome:

  Name of outcome variable.

- K:

  Number of nearest treated neighbors.

- covs:

  Character vector of covariate column names, or NULL to auto-detect
  columns starting with "X" (default NULL).

- scaling:

  Scaling vector passed to get_cal_matches. If NULL, uses
  default_scaling(df, covs).

- metric:

  Distance metric passed to get_cal_matches (default "maximum").

- id_name:

  Name of the unit ID column (default "id").

## Value

A list with:

- S1_sq:

  Scalar: mean of s_1t^2 over treated units.

- s_1t_sq:

  Data frame with columns `id` and `s_1t_sq`.

## Examples

``` r
dat <- gen_one_toy(nt = 20)
calculate_S1_sq_treated_to_treated(dat)
#> $S1_sq
#> [1] 0.1431955
#> 
#> $s_1t_sq
#> # A tibble: 20 × 2
#>    id     s_1t_sq
#>    <chr>    <dbl>
#>  1 1     0.0578  
#>  2 2     0.0218  
#>  3 3     0.0493  
#>  4 4     0.155   
#>  5 5     0.0835  
#>  6 6     0.000407
#>  7 7     0.330   
#>  8 8     0.0493  
#>  9 9     0.222   
#> 10 10    0.324   
#> 11 11    0.273   
#> 12 12    0.398   
#> 13 13    0.302   
#> 14 14    0.108   
#> 15 15    0.00633 
#> 16 16    0.273   
#> 17 17    0.0739  
#> 18 18    0.0739  
#> 19 19    0.0311  
#> 20 20    0.0311  
#> 
```
