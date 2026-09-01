# generate sample dataset from Hainmueller (2012), exactly

note: generates a big population and samples nt/nco units paper
settings:

- n (total number of units): 300, 600, 1500

- r (ratio of co/tx units): 1,2,5

- sigma_e: n30 = low overlap, n100 = high overlap, chi5 = weird overlap

- outcome: "linear", "nl1", "nl2"

- sigma_y: 1

## Usage

``` r
gen_df_hain(
  nt = 50,
  nc = 250,
  sigma_e = c("chi5", "n30", "n100"),
  outcome = c("linear", "nl1", "nl2"),
  sigma_y = 1,
  ATE = 0
)
```

## Arguments

- nt:

  Number of treated units

- nc:

  Number of control units

- sigma_e:

  Error distribution for latent variable dictating treatment assignment.

- outcome:

  Outcome function type

- sigma_y:

  Standard deviation of the outcome noise (default 1).

- ATE:

  True average treatment effect added to the outcome (default 0).

## Value

A tibble with covariates, treatment indicator `Z`, and outcome `Y`.

## Examples

``` r
dat <- gen_df_hain(nt = 20, nc = 60)
dim(dat)
#> [1] 80 11
```
