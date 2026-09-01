# csm_matches object accessors

Methods for working with a `csm_matches` object as if it were a data
frame of matched units.

## Usage

``` r
is.csm_matches(x)

# S3 method for class 'csm_matches'
x[...]

# S3 method for class 'csm_matches'
x[[...]]

# S3 method for class 'csm_matches'
dim(x, ...)

# S3 method for class 'csm_matches'
as.data.frame(x, row.names = NULL, optional = FALSE, return = "all", ...)
```

## Arguments

- x:

  A csm_matches object.

- ...:

  additional arguments to be passed to the as.data.frame.list methods.
  (Currently ignored.)

- row.names:

  NULL or a character vector giving the row names for the data frame.

- optional:

  logical. If TRUE, setting row names and converting column names is
  optional. (Currently ignored.)

- return:

  Which return format to use; passed to
  [`result_table()`](result_table.md).

## Value

is.csm_matches: TRUE if object is a csm_matches object.

`[`: pull out rows and columns of the dataframe.

`[[`: pull out single element of dataframe.

dim: Dimension of csm_matches (as matrix)

as.data.frame: The matched data as a clean dataframe (no more attributes
from csm_matches).

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
is.csm_matches(mtch)
#> [1] TRUE
dim(mtch)
#> [1] 123  15
head(mtch[, c("id", "X1", "X2")])
#> # A tibble: 6 × 3
#>   id       X1    X2
#>   <chr> <dbl> <dbl>
#> 1 1     0.404 0.244
#> 2 18    0.538 0.320
#> 3 39    0.596 0.245
#> 4 57    0.532 0.254
#> 5 86    0.585 0.129
#> 6 100   0.538 0.352
```
