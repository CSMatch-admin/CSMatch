## Submission notes

This is a new submission (first CRAN release).

### R CMD check results

0 errors | 2 warnings | 3 notes, all addressed below (plus the
always-present "New submission" note for a first release).

* `checking dependencies in R code` / `checking for unstated
  dependencies in examples` flag `aciccomp2016`, which is used
  (optionally) by `gen_df_acic()`. `aciccomp2016` is not on CRAN and
  cannot be listed in `Imports`/`Suggests`; `gen_df_acic()` guards its
  use with `requireNamespace()` and gives an informative error (with
  GitHub install instructions) if it is not installed.

* `checking R code for possible problems` flags `boot_bayesian_covs`
  and `get_variance_AI06` as undefined. These are internal helper
  functions referenced by optional, non-default arguments
  (`love_plot(B = ...)`, `get_total_variance(variance_method =
  "ai06")`) that are not yet implemented in this release; both are
  documented as incomplete in `?love_plot` and `?get_total_variance`,
  and the default arguments never reach these code paths. This is a
  known limitation being tracked for a future release rather than an
  oversight.

* `checking HTML version of manual` notes that the local `tidy`
  binary is outdated; this is a limitation of the checking
  environment, not the package.

### Method references

The methods implemented in this package are described in:

Che, J., Meng, X., & Miratrix, L. (2024). Caliper Synthetic Matching.
<https://arxiv.org/abs/2411.05246>. This is cited in the DESCRIPTION
`Description:` field.
