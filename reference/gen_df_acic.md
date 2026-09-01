# Generate data from the ACIC 2016 competition

This function generates a dataset using the data generating process from
the ACIC 2016 competition. It samples covariates from the input_2016
dataset and then applies the dgp_2016 function to generate potential
outcomes and treatment assignments.

## Usage

``` r
gen_df_acic(
  model.trt = "step",
  root.trt = 0.35,
  overlap.trt = "full",
  model.rsp = "linear",
  alignment = 0.75,
  te.hetero = "high",
  random.seed = 1,
  n = 1000,
  p = 10
)
```

## Arguments

- model.trt:

  Functional form for the treatment-assignment model (e.g. "step",
  "linear"); passed to `aciccomp2016::dgp_2016()`.

- root.trt:

  Tuning constant controlling the degree of treatment propensity
  extremity/overlap; passed to `aciccomp2016::dgp_2016()`.

- overlap.trt:

  Overlap category for the treatment model (e.g. "full", "one-term",
  "some-overlap"); passed to `aciccomp2016::dgp_2016()`.

- model.rsp:

  Functional form for the response-surface model (e.g. "linear",
  "exponential"); passed to `aciccomp2016::dgp_2016()`.

- alignment:

  Degree of overlap between the covariates driving treatment assignment
  and those driving the response surface; passed to
  `aciccomp2016::dgp_2016()`.

- te.hetero:

  Level of treatment effect heterogeneity (e.g. "high", "med", "none");
  passed to `aciccomp2016::dgp_2016()`.

- random.seed:

  Seed passed to `aciccomp2016::dgp_2016()` for reproducibility of the
  DGP.

- n:

  Number of units to sample from the ACIC 2016 `input_2016` covariate
  pool.

- p:

  Number of (numeric-like) covariates to keep.

## Value

A tibble containing the generated dataset with covariates, treatment
assignment, potential outcomes, and observed outcome.

## Details

This function requires the aciccomp2016 package, which is not on CRAN
and is not a formal dependency of CSMatch. Install it from GitHub with
`remotes::install_github("vdorie/aciccomp/2016")` before calling this
function.

## Examples

``` r
if (requireNamespace("aciccomp2016", quietly = TRUE)) {
  dat <- gen_df_acic(n = 200, p = 5)
  dim(dat)
}
```
