# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working
with code in this repository.

## What this is

CSMatch (package name `CSMatch`, formerly `scmatch2`) is an R package
implementing **Caliper Synthetic Matching (CSM)**: radius matching on a
covariate distance metric, followed by an optional synthetic-control
weighting step to build a synthetic counterfactual for each treated
unit. It accompanies the paper Che et al. (2024), “Caliper Synthetic
Matching” (<https://arxiv.org/abs/2411.05246>).

The repo contains both the installable package (`R/`, `man/`, `tests/`)
and non-package replication material for the paper (`scripts/`, `data/`,
`writeup/`, `figures/`). `scripts/` is excluded from the built package
(see README).

## Common commands

Run these from an R session with the working directory set to the
package root (or via the RStudio project `CSM.Rproj`).

``` r

devtools::load_all()      # load package source for interactive dev
devtools::document()      # regenerate NAMESPACE and man/*.Rd from roxygen comments
devtools::test()          # run full testthat suite
devtools::check()         # full R CMD check
testthat::test_file("tests/testthat/test-get_cal_matches.R")   # run a single test file
testthat::test_file("tests/testthat/test-estimate.R", desc = "some test name")  # filter to one test
```

Some tests are slow or depend on optional packages and are skipped by
default: - Slow tests are gated behind `Sys.getenv("RUN_SLOW_TESTS")`;
set `RUN_SLOW_TESTS=TRUE` in the environment to enable them (see
`tests/testthat/helper-skip.R`). - Several tests
`skip_if_not_installed()` on `Suggests`-only packages (`grf`, `twang`,
`kbal`, `aciccomp2016`, `tmle`, `dbarts`, `AIPW`) — install them to
exercise those code paths. - `aciccomp2016` is not on CRAN; install with
`remotes::install_github("vdorie/aciccomp/2016")`. Only needed for
generating ACIC-based synthetic data (`gen_df_acic`), not for core
matching/estimation.

Roxygen is configured with `Roxygen: list(markdown = TRUE)` — always run
`devtools::document()` after editing any `@param`/`@return`/doc comment
so `NAMESPACE` and `man/` stay in sync; don’t hand-edit `NAMESPACE` or
`man/*.Rd`.

## Architecture

The pipeline has three conceptual stages, each living in its own
file(s), glued together by the top-level entry point
[`get_cal_matches()`](reference/get_cal_matches.md)
(`R/get_cal_matches.R`):

1.  **Matching** (`R/distance.R`, `R/matching.R`): compute a distance
    matrix between treated and control units on scaled covariates
    (`coerce_covs`, `scale_covs`), then determine a radius/caliper per
    treated unit (`get_radius_size`, supporting `"adaptive"`,
    `"targeted"`, `"fixed"`, `"1nn"`, `"knn"`, `"knn-capped"` methods)
    and pull the controls within that radius (`gen_matches`). Output is
    a list of per-treated-unit data frames of matched controls plus the
    trimmed/uncapped distance matrices.
2.  **Weighting/aggregation** (`R/synthetic_control.R`,
    `R/aggregation.R`, `R/est_weights` in matching pipeline): within
    each treated unit’s matched set, assign control weights either via
    synthetic control optimization (`gen_sc_weights`, solved via
    `osqp`/`lpSolve` QP/LP — `est_method = "csm"`) or simple averaging
    (`est_method = "average"`, CEM-style).
    `agg_sc_units`/`agg_co_units`/`agg_avg_units` (`R/aggregation.R`)
    aggregate the resulting per-subclass or per-control-unit weights for
    downstream use.
3.  **Estimation/inference** (`R/estimate.R`): compute the ATT point
    estimate and its standard error from the matched/weighted data
    (`estimate_ATT`, `get_att_point_est`), including several variance
    estimators (`get_pooled_variance`, `get_total_variance`,
    `get_measurement_error_variance*`) and effective sample size helpers
    (`ess`, `R/ess_tools.R`). `R/bootstrap.R` provides an alternative
    bootstrap-based SE (`boot_SE`, `make_bootstrap`,
    `make_bootstrap_ci`), including a moving-block option for correlated
    designs.

Results are wrapped in an S3 class **`csm_matches`**
(`R/csm_matches_object.R`) with `print`, `summary`, `dim`, `[`, `[[`,
and `as.data.frame` methods. `as.data.frame.csm_matches` delegates to
[`result_table()`](reference/result_table.md), the main way to pull a
flat data frame of matched units (with
`feasible_only`/`nonzero_weight_only` filters) out of a `csm_matches`
object. Settings used to produce the match (metric, caliper, scaling,
treatment/covariate names, etc.) are stored as an attribute
(`attr(x, "settings")`) and read back via the
[`params()`](reference/params.md) accessor — most downstream functions
(aggregation, estimation, plotting) pull covariates/treatment name from
these settings rather than taking them as explicit arguments when given
a `csm_matches` object directly.

Diagnostics and reporting build on top of the same object: -
`R/diagnostic_plots.R`, `R/sensitivity_plot.R`, `R/ess_tools.R`: love
plots, caliper sensitivity plots/tables, ESS plots, feasibility plots. -
`R/calculate_overlap_stat.R`: statistics on how much treated units’
matched sets overlap/reuse the same control units (relevant to variance
estimation, since reused controls induce correlation).

`R/sim_data.R` holds the data-generating processes used both in package
examples and in the paper’s simulations (`gen_one_toy`, `gen_df_adv`,
`gen_df_adv_k`, `gen_df_hain`, `gen_df_kang`, `gen_df_acic`) — these are
exported package functions, distinct from the analysis-only DGPs in
`scripts/datagen`.

### Non-package replication code (`scripts/`)

`scripts/` is a loose collection of paper-replication code, not part of
the installed package. Per `to_do_list.md`, the intended (partially
realized) organization is: - `demo/`: illustrates package usage only,
not tied to paper results. - `sims-*`: run the paper’s simulation
studies (bias/MSE, variance under various heterogeneity settings). -
`figs/`: build the paper’s illustrative figures from existing results
(no new analysis). - `lalonde-analysis/`, `ferman-analysis/`: empirical
applications used in the paper. - `lib/`: shared helpers for simulations
(`sim_runner.R`, `wrappers.R`, plotting helpers) — `wrappers.R` in
particular wraps other estimators (AIPW, TMLE, GRF, twang, kbal) for
comparison against CSM in simulations, which is why
`tests/testthat/test-wrappers.R` skips on missing `Suggests` packages. -
`boot/`, `draft-inference-scripts/`: bootstrap/inference exploration. -
`old/` and top-level `old_code/`: superseded code kept for reference;
don’t build on these without checking whether the corresponding logic
has already moved into `R/`.

This directory structure is mid-refactor (see `to_do_list.md`) — expect
some drift between the intended layout above and what currently exists
on disk.

## Conventions

- Tidyverse style throughout (`dplyr`, `purrr`, `tibble`); most package
  functions expect data as tibbles/data frames and use `dplyr`-style NSE
  (`.data[[...]]`) rather than base-R subsetting.
- Treated units are typically encoded as `Z` (or the column named in
  `treatment`/`form`), covariates default to columns whose names start
  with `X` when not otherwise specified (`get_x_vars`).
- Matching functions treat `id`/`subclass` as the key linking columns
  between the matches list, the distance matrices, and the treatment
  table — preserve these when modifying matching internals.
