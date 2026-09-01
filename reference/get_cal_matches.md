# Caliper Synthetic Matching

This is the core method of the CSM package. Conduct (adaptive) radius
matching with optional synthetic step on the resulting sets of controls.
The function creates a matched dataset by finding control units that are
similar to treatment units based on specified covariates and distance
metrics, then optionally weights these controls using synthetic control
methods.

## Usage

``` r
get_cal_matches(
  data,
  form = NULL,
  covs = NULL,
  treatment = NULL,
  metric = c("maximum", "euclidean", "manhattan"),
  caliper = 1,
  rad_method = c("adaptive", "fixed", "1nn", "knn", "knn-capped"),
  est_method = c("csm", "average"),
  scaling = NULL,
  id_name = "id",
  warn = TRUE,
  k = 1,
  dm = NULL
)
```

## Arguments

- data:

  The data frame of data to be matched. Must contain treatment indicator
  and covariates for matching.

- form:

  Formula of form treatment ~ cov1 + cov2 + ... specifying the treatment
  variable and covariates to use for matching. If not null, will
  override covs and treatment.

- covs:

  Specification of covariates to use for matching. Can be variable
  names, list of column numbers, or NULL. If NULL, will use covariate
  names found in the scaling parameter, or default to all columns
  starting with "X".

- treatment:

  Name of the column in `data` containing the treatment indicator (with
  values 0/1 or TRUE/FALSE).

- metric:

  Distance metric: "maximum", "euclidean", or "manhattan".

- caliper:

  Caliper size. Sets the max allowed distance between matches. Often 1.
  Scaling usually handles covariate importance.

- rad_method:

  How to set the radius for each treated unit:

  - "adaptive": max(caliper, distance to nearest control)

  - "fixed": use caliper; drop treated with no controls inside it

  - "1nn": distance to nearest neighbor

  - "adaptive-5nn": adaptive with cap at 5th NN

  - "knn": distance to the k-th nearest neighbor

- est_method:

  How to weight control units:

  - "csm": synthetic control weights

  - "average": simple average

- scaling:

  Length-P vector of scaling constants (or a single-row data frame).
  Each covariate is scaled by its value. Often 1/sd. Defaults to 1. If
  covs not supplied, the argument name is used to identify covariates.

- id_name:

  Column name for unit IDs. If missing, an `id` column using row numbers
  is created.

- warn:

  A logical indicating whether to warn about dropped units (those that
  cannot be matched within the caliper).

- k:

  Integer specifying the number of neighbors to use when
  `rad_method = "knn"`.

- dm:

  Optional treated-control distance matrix. Calipers are applied but
  distances are not recomputed.

## Value

An S3 object of class "csm_matches" containing:

- `matches`: A list of data frames, each containing matched control
  units for a treated unit

- `adacalipers`: Vector of adaptive calipers for each treated unit

- `dm_trimmed`: Distance matrix with control units farther than caliper
  set to NA

- `dm_uncapped`: Original distance matrix without censoring

- `treatment_table`: Table of treated units with matching information

The object also has attributes storing the settings used for matching.

## See also

[`gen_matches`](gen_matches.md) for the underlying matching function,
[`result_table`](result_table.md) for extracting results

## Examples

``` r
# Generate example data
set.seed(4044440)
dat <- gen_one_toy(nt = 5)

# Perform matching
mtch <- get_cal_matches(dat,
                        metric = "maximum",
                        scaling = c(1/0.2, 1/0.2),
                        caliper = 1,
                        rad_method = "adaptive",
                        est_method = "csm")
#> Warning: treatment variable not specified; defaulting to 'Z'

# View matching results
mtch
#> csm_matches: matching with "maximum" distance and "adaptive" radii
#> aggregating sets with "csm" method 
#> match covariates: X1, X2
#> 5 treated units matched to 91 of 500 control units 
#>  (0 exact matches, 5 below caliper, 0 above caliper) 
#> Adaptive calipers: 1, 1, 1, 1, 1 
#>  Target caliper = 1 
#> Max distance ranges 0.962 - 0.983 
#>  scaling: 5, 5

# Convert to data frame
as.data.frame(mtch)
#> # A tibble: 123 × 15
#>    id       X1    X2     Z   noise Y0_denoised    Y0 Y1_denoised    Y1     Y
#>    <chr> <dbl> <dbl> <dbl>   <dbl>       <dbl> <dbl>       <dbl> <dbl> <dbl>
#>  1 1     0.404 0.244     1  0.131         5.05  5.18        7.00  7.13  7.13
#>  2 18    0.538 0.320     0 -0.0744        4.99  4.91        7.56  7.48  4.91
#>  3 39    0.596 0.245     0 -0.541         4.53  3.99        7.05  6.51  3.99
#>  4 57    0.532 0.254     0 -0.769         4.79  4.02        7.14  6.37  4.02
#>  5 86    0.585 0.129     0 -0.271         4.04  3.77        6.18  5.91  3.77
#>  6 100   0.538 0.352     0  0.125         5.07  5.20        7.74  7.87  5.20
#>  7 120   0.502 0.286     0 -0.316         4.97  4.66        7.34  7.02  4.66
#>  8 124   0.578 0.181     0  0.431         4.32  4.75        6.60  7.03  4.75
#>  9 133   0.578 0.154     0  0.520         4.19  4.71        6.39  6.91  4.71
#> 10 140   0.578 0.419     0 -0.400         5.14  4.74        8.13  7.73  4.74
#> # ℹ 113 more rows
#> # ℹ 5 more variables: Y_denoised <dbl>, dist <dbl>, subclass <chr>, unit <chr>,
#> #   weights <dbl>
```
