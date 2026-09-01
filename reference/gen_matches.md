# Match treated units to control units

Generate matches for each treatment over controls using specified
covariate names, distance metric specified by the scaling parameter and
the method of metric. Finally, there is a selection of the units

## Usage

``` r
gen_matches(
  data,
  covs = get_x_vars(data),
  treatment = "Z",
  scaling = 1,
  metric = c("maximum", "euclidean", "manhattan"),
  caliper = 1,
  rad_method = c("adaptive", "fixed", "1nn", "knn", "knn-capped"),
  id_name = NULL,
  k = 1,
  dm = NULL,
  ...
)
```

## Arguments

- data:

  Data frame with covariates and treatment indicator.

- covs:

  Covariate names.

- treatment:

  Treatment indicator column (0/1).

- scaling:

  Length-P vector of scaling constants (or a single-row data frame).
  Each covariate is scaled by its value. Often 1/sd. Defaults to 1. If
  covs not supplied, the argument name is used to identify covariates.

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

- id_name:

  Column name for unit IDs. If missing, an `id` column using row numbers
  is created.

- k:

  For adaptive, number of units needed for minimum radius. For "knn",
  number of neighbors. Defaults to 1.

- dm:

  Optional treated-control distance matrix. Calipers are applied but
  distances are not recomputed.

- ...:

  Extra arguments

## Value

A list of results. matches: list of small datasets of matched control
units for each treated unit. adacalipers: vector of adaptive calipers
for each treated unit. dm_trimmed: distance matrix with control units
farther than caliper censored with NA dm_uncapped: distance matrix
without any control units censored.

## Details

Note: we allow controls to be repeatedly used (we match with
replacement).

Generally use the [`get_cal_matches()`](get_cal_matches.md) function
instead, which wraps this.

## Examples

``` r
data <- CSMatch:::gen_one_toy()
mtch <- gen_matches(data, covs = c("X1", "X2"), treatment = "Z")
names( mtch )
#> [1] "matches"     "adacalipers" "dm_trimmed"  "dm_uncapped"
```
