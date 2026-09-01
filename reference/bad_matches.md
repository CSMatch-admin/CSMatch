# Return result table for the bad matches

Return result table for the bad matches

## Usage

``` r
bad_matches(csm, threshold, nonzero_weight_only = TRUE)
```

## Arguments

- csm:

  A csm_matches object

- threshold:

  Distance threshold for bad matches

- nonzero_weight_only:

  TRUE means drop any control units with 0 weight (e.g., due to csm
  weighting)

## Value

Dataframe of bad matches

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
bad_matches(mtch, threshold = 0.9)
#> # A tibble: 20 × 16
#>    id        X1     X2     Z    noise Y0_denoised    Y0 Y1_denoised    Y1     Y
#>    <chr>  <dbl>  <dbl> <dbl>    <dbl>       <dbl> <dbl>       <dbl> <dbl> <dbl>
#>  1 1     0.404  0.244      1  0.131          5.05  5.18        7.00  7.13  7.13
#>  2 86    0.585  0.129      0 -0.271          4.04  3.77        6.18  5.91  3.77
#>  3 351   0.258  0.0667     0  0.00759        4.76  4.76        5.73  5.74  4.76
#>  4 417   0.356  0.425      0 -0.0132         5.24  5.23        7.58  7.57  5.23
#>  5 2     0.0330 0.223      1  0.215          4.70  4.91        5.46  5.68  5.68
#>  6 419   0.0223 0.298      0 -0.135          4.52  4.39        5.49  5.35  4.39
#>  7 444   0.0137 0.157      0  0.427          4.70  5.13        5.21  5.64  5.13
#>  8 482   0.102  0.418      0  0.191          4.54  4.73        6.10  6.29  4.73
#>  9 3     0.863  0.838      1 -0.00439        4.95  4.95       10.1  10.0  10.0 
#> 10 359   0.671  0.885      0  0.438          4.80  5.24        9.47  9.90  5.24
#> 11 368   0.871  0.789      0 -0.462          4.95  4.49        9.93  9.47  4.49
#> 12 445   0.878  0.951      0  0.104          4.79  4.89       10.3  10.4   4.89
#> 13 4     0.835  0.658      1 -0.0932         4.93  4.84        9.41  9.32  9.32
#> 14 31    0.649  0.495      0 -0.784          5.14  4.35        8.57  7.79  4.35
#> 15 423   0.954  0.790      0  0.386          4.75  5.13        9.98 10.4   5.13
#> 16 436   0.911  0.462      0 -0.359          4.05  3.69        8.17  7.81  3.69
#> 17 5     0.802  0.779      1 -0.128          5.06  4.93        9.80  9.67  9.67
#> 18 158   0.814  0.609      0 -0.238          4.91  4.67        9.18  8.94  4.67
#> 19 445   0.878  0.951      0  0.104          4.79  4.89       10.3  10.4   4.89
#> 20 455   0.626  0.952      0  0.00664        4.43  4.44        9.17  9.18  4.44
#> # ℹ 6 more variables: Y_denoised <dbl>, dist <dbl>, subclass <chr>, unit <chr>,
#> #   weights <dbl>, adacal <dbl>
```
