# CSMatch code review TODO

Generated from a full code review of `R/` (2026-07-28). Organized by
priority. Checked items are done; the rest are tracked for follow-up.

## Confirmed bugs — fixed 2026-07-28

1\. `est_method = "csm_extrap"` was documented but not implemented
(crashed immediately via `est_weights()`). **Fixed: removed as an
option** (get_cal_matches.R, matching.R, CLAUDE.md).

2\.
`get_total_variance(variance_method = "pooled_het", cluster_comb_mtd = "sample")`
always crashed — column-name typo (`sample_var_cluster` vs. the real
`rand_var_cluster`) in estimate.R. **Fixed the typo, removed the
now-unused
[`globalVariables()`](https://rdrr.io/r/utils/globalVariables.html)
entry that was masking it, added a regression test** (test-estimate.R).

3\. [`agg_co_units()`](reference/AggregationMethods.md) silently ignored
its own `outcome`/`treatment` arguments (aggregation.R). Investigated
further: the “keep every column via `first()`” behavior is intentional
and tested elsewhere (contrasted against `agg_sc_units`’s narrower
output), so **fixed by validating `treatment`/`outcome` actually exist
as columns (erroring clearly if not) rather than restricting the output
shape**; added a regression test.

4\. [`gen_df_acic()`](reference/gen_df_acic.md) called
`set.seed(random.seed)` internally, clobbering the caller’s global RNG
stream (sim_data.R). **Fixed: saves the current RNG state, sets the
passed seed, and restores the caller’s RNG state on exit (via
[`on.exit()`](https://rdrr.io/r/base/on.exit.html))**; added a
regression test (skipped locally since `aciccomp2016` isn’t installed,
but verified the exact save/restore mechanism in isolation).

5\. `get_radius_size()` silently returned `NA` when `k` exceeded the
number of available controls, silently dropping treated units
(matching.R). **Fixed: throws a clear error up front** (based on
`ncol(dm)`, before any computation) for every `rad_method` that actually
indexes on `k`; added a regression test. This also surfaced a latent bug
in `scripts/lib/wrappers.R`’s test usage (`k=8` default with only 3
controls) — fixed the test call site to pass an appropriate `k`.

6\. `estimate_ATT(matches, use_common_variance = FALSE)` on a plain data
frame threw “formal argument matched by multiple actual arguments”
(estimate.R). Root cause: `covs`/`scaling`/`metric`/ `id_name` were only
ever assigned as local variables inside the
[`is.csm_matches()`](reference/csm_matches.md) branch, then
unconditionally forwarded alongside `...`. **Fixed: made these (plus
`K`) explicit, documented parameters of
[`estimate_ATT()`](reference/estimate_ATT.md) with
supplied-value-wins-over-object-params precedence**; this also surfaced
and fixed a second bug, a `pp$covs` typo (should be `pp$covariates` —
[`params()`](reference/params.md) has no `covs` field) present in *two*
places ([`estimate_ATT()`](reference/estimate_ATT.md) and
[`get_finite_variance()`](reference/get_finite_variance.md) itself);
added a 3-scenario regression test (csm_matches auto-populate, plain
data frame with explicit args, explicit override taking precedence).

7\.
[`get_measurement_error_variance_OR()`](reference/get_measurement_error_variance_OR.md)
rejected `boot_mtd = "sign"` even though it’s the package-wide default
elsewhere (estimate.R). **Fixed: added “sign” to the allowed methods and
error message, updated docs**; added a regression test.

8\. `love_plot2()` was dead and fully broken — reads attributes nothing
ever sets (diagnostic_plots.R). **Removed**, along with the adjacent
dead commented-out bootstrap block inside
[`love_plot()`](reference/love_plot.md) (the `B` parameter and that code
path had already been removed from
[`love_plot()`](reference/love_plot.md) itself, resolving the
“`love_plot(B=...)` incomplete” item below as a side effect).

## Other confirmed bugs — fixed 2026-08-31

[`agg_sc_units()`](reference/AggregationMethods.md)/[`agg_avg_units()`](reference/AggregationMethods.md)
(aggregation.R) hard-assumed exactly 2 rows per subclass group after
grouping (most commonly broken by an unmatched treated unit with zero
controls), producing a confusing dplyr recycling error. **Fixed: added a
shared `assert_two_rows_per_subclass()` check that errors clearly up
front**; added a regression test.

`gen_sc_weights()` (synthetic_control.R) could silently divide by zero
(`sol / sum(sol)`) producing `NaN` weights with no warning if a QP/LP
solve returned all-near-zero weights, and didn’t special-case zero
controls the way it special-cased one control. **Fixed: added a
zero-controls case that errors clearly; extracted the
drop-tiny-weights/renormalize step into `normalize_sc_weights()`, which
now errors instead of dividing by zero**; added regression tests. Also
removed two stray `# browser()` lines encountered in the same file (see
“Dead code” below).

Inconsistent “exact match” tolerance constants:
[`print.csm_matches()`](reference/print.csm_matches.md) used
`10*.Machine$double.eps`, `result_table(return="exact")` used
`100*.Machine$double.eps` — same concept, two different magic constants,
could disagree on unit counts. **Fixed: unified on a single
`EXACT_MATCH_TOL` constant** (csm_matches_object.R), used in both
places.

`love_plot(B = ...)` — resolved: the `B` parameter and its
`boot_bayesian_covs()` call were removed from
[`love_plot()`](reference/love_plot.md) entirely (see bug \#8 above).

`get_total_variance(variance_method = "ai06")` calling
`get_variance_AI06()` (which doesn’t exist) — **already resolved prior
to this TODO file** (commit `ce2c390`, per your own earlier decision to
“leave it with a note in the docs saying it is incomplete”): it now
throws a clear [`stop()`](https://rdrr.io/r/base/stop.html) up front and
[`?get_total_variance`](reference/get_total_variance.md) documents it as
incomplete. No further action taken.

[`gen_df_hain()`](reference/gen_df_hain.md)’s `outcome` param is
restricted by [`match.arg()`](https://rdrr.io/r/base/match.arg.html) to
`c("linear","nl1","nl2")`, but the function body had a dead
`else if (outcome == "nl3")` branch that could never be reached.
**Removed.**

## Needs a decision — resolved 2026-08-31

**`R/supplement_functions_to_check.R`** — deleted per your decision.
Verified `boot_bayesian()`/`boot_bayesian_covs()` had no live callers
anywhere in `R/`, `tests/`, or `scripts/` (the similarly-named things in
`tests/testthat/old/test_bootstrap.R` and
`scripts/boot/boot_CSM_simulation_code.R` define their own unrelated
same-named functions).

## Dead code — removed 2026-08-31

`create_toy_df_plot()` (diagnostic_plots.R) — unexported, unused
anywhere. Removed.

`scm_vs_avg_distance_plot()`’s `if (F) {...}` debug block
(diagnostic_plots.R) — referenced undefined `feasible`. Removed.

Nested `plot_dm()` helper inside
[`caliper_distance_plot()`](reference/caliper_distance_plot.md)
(diagnostic_plots.R) — never called; referenced undefined
`lalonde_params`. Removed (also dropped `lalonde_params` from
[`globalVariables()`](https://rdrr.io/r/utils/globalVariables.html)
since nothing references it anymore).

~55 lines of commented-out `get_se_AE_table`/`get_se_AE` (estimate.R) —
superseded by `get_measurement_error_variance`/ `estimate_ATT`. Removed.

`get_plug_in_SE()` (estimate.R) — original author’s own comment said
“This should be removed, I think.” Removed, along with its now-orphaned
test in test-estimate.R. (Note: still used via
`CSMatch:::get_plug_in_SE()` in `scripts/draft-inference-scripts/` —
those are unmaintained draft scripts per CLAUDE.md and were left as-is,
not fixed up.)

Dev-scratch `if (F) {...}` blocks in sim_data.R (referenced undefined
top-level objects `nc`/`nt`/`f0_sd`/`input_2016`/ `dgp_2016`). Removed
both.

Stray `# browser()` lines in synthetic_control.R. Removed both.

Unused/duplicate helpers in utils.R: removed `logit`, `expit`, `rmse`,
`weighted_var`, `weighted_se` (all confirmed to have zero callers
anywhere in `R/`, `tests/`, or `scripts/`). **Correction to this item’s
original description: `invlogit()` was kept** — unlike the others it
*is* actually called, via `CSMatch:::invlogit()` in
`scripts/lib/wrappers.R` (a live, tracked script, not one of the
`old/`/draft ones); the original code review missed this `:::`-qualified
call site.

## Reuse / simplification / efficiency

Per your review of these items (2026-08-31), all now closed:

`compute_pairwise_shared_controls()`/`compute_shared_controls_per_treated()`
(calculate_overlap_stat.R) use O(N²) loops with per-pair
[`intersect()`](https://rdrr.io/r/base/sets.html); could reduce to one
matrix multiply on a treated×control incidence matrix. **Logged in
`FUTURE_WORK.md` per your call, not fixed now.**

`get_radius_size()`’s four branches are ~90% duplicated boilerplate
differing only in the final one-line computation. **Left as-is** — on a
second look the four branches (`"adaptive"`, `"targeted"`, `"fixed"`,
`"1nn"`/`"knn"`/`"knn-capped"`) differ in more than a one-line formula
(different sorting/indexing logic per branch), so the original review
overstated this one; agreed it’s fine as-is.

`set_NA_to_unmatched_co()` (matching.R) — was a per-row for-loop zeroing
out `dm_uncapped` entries beyond each treated unit’s radius. **Fixed:
vectorized to a single matrix comparison**
(`matrix(radius_sizes, nrow=, ncol=)`+ logical indexing), with a
`stopifnot` added guarding that
`nrow(dm_uncapped) == length(radius_sizes)`. Verified byte-identical
output vs. the old loop (including a pre-existing-`NA` edge case) before
committing; existing regression test still passes.

[`sensitivity_table()`](reference/sensitivity_table.md)’s
`include_distances` branch builds a full
[`distance_density_plot()`](reference/distance_density_plot.md) ggplot
object purely to scrape its attached data table. **Per your call (“put
in future… unclear how to do it cleanly”), logged in `FUTURE_WORK.md`
instead of fixing now.**

Duplicated ~8-line all-`NA` placeholder list appeared verbatim (actually
4x, not 3x) in `calculate_overlap_stats_from_table()`. **Fixed per your
instruction: extracted `na_pairwise_overlap()` and `na_overlap_result()`
internal helpers** (calculate_overlap_stat.R), all 4 call sites now use
them.

`calculate_subclass_variances()` and the `s_t_sq_df` block inside
`calculate_s_j_sq()` independently reimplemented near-identical
“variance per subclass” logic. **Fixed per your “yes”:**
`calculate_s_j_sq()` now filters to `treatment==0` + `n()>=2` (matching
`get_pooled_variance()`’s existing pattern) and calls
`calculate_subclass_variances()` directly, selecting/renaming its
`var_cluster` column to `s_t_sq` — same output shape as before
(`expect_named`/column checks in existing tests still pass), one fewer
independent implementation of “variance per subclass.”

[`feasible_plot()`](reference/feasible_plot.md) refits
[`estimate_ATT()`](reference/estimate_ATT.md) from scratch once per
cumulative subset of treated units — O(n) full recomputations. **Logged
in `FUTURE_WORK.md` per your call (“skip… might not be major”), noting
it’s likely cheap since it’s re-estimating on an already-matched table
(no rematching), but unbenchmarked.**

## Naming issues

Resolved per your instructions (2026-08-31) — full diff in commit
history; ran full test suite + `R CMD check` clean after each batch:

`calculate_overlap_stats_from_table()` → renamed to
[`calculate_overlap_statistics_from_table()`](reference/calculate_overlap_statistics_from_table.md)
(“stats” → “statistics”). Left the deeper inconsistency across the three
`calculate_overlap_statistics*` functions (and their differing return
shapes) for later — logged in `FUTURE_WORK.md` and noted in
[`?calculate_overlap_statistics_from_table`](reference/calculate_overlap_statistics_from_table.md),
per your instruction not to worry about that part right now.

[`params()`](reference/params.md) and [`ess()`](reference/ess.md) — **no
change**, per your call.

Variance-estimator family dispatch-string/function-name mismatch —
**left as-is for now**, per your call.

Five different parameter names for “the csm_matches object” (`x`,
`object`, `csm`, `res`, `mtch`) — renamed all non-S3-dispatch
occurrences of `res`/`mtch` to `csm`
([`update_matches()`](reference/update_matches.md),
[`calculate_overlap_statistics()`](reference/calculate_overlap_statistics.md),
[`calculate_overlap_statistics_from_match_object()`](reference/calculate_overlap_statistics_from_match_object.md),
`get_diff_scm_co_and_tx()`, `create_love_plot_df()`). Left `x`
(print/dim methods) and `object` (summary method) alone — those already
follow the S3-dispatch convention you specified.

`k` overloaded (“number of neighbors” vs. “covariate dimensionality”) —
renamed to `num_cov` in [`gen_one_toy()`](reference/gen_one_toy.md) only
(the user-facing demo/example entry point). \*\*Deliberately left
[`gen_df_adv_k()`](reference/gen_df_adv_k.md)/`gen_toy_covar_k()`‘s own
`k` unchanged\*\* — that parameter is the literal referent of those
functions’ `_k` suffix, so renaming it is really part of the
`gen_df_adv`/`gen_df_adv_k`/`gen_one_toy` hierarchy question below, not
this narrower overloading fix. See investigation below.

`matched_gps` parameter in `est_weights()` → renamed to `matches`, per
your instruction, with the doc updated to “List of matched groups, or a
csm object”. (Found and fixed a bug this surfaced: the function used the
same name for both the raw input and the extracted list-of-matched-sets,
then tried to re-wrap the *original* object at the end using a name that
had already been overwritten — introduced a separate `match_list` local
variable to fix it.)

`ctr_dist` parameter (DGP functions) → renamed to `cluster_dist` in
[`gen_df_adv()`](reference/gen_df_adv.md),
[`gen_df_adv_k()`](reference/gen_df_adv_k.md), and
[`gen_one_toy()`](reference/gen_one_toy.md), per your instruction. Also
fixed every direct call site in the *active* (non-`old/`) scripts that
passed it as a named argument to one of these three functions:
`sims-variance/debug_parallel_sim_inference.R`,
`sims-variance/0_sim_inference_utils.R`,
`figs/tune_bimodal_sigma_params.R`, `figs/fig_control_weights.R`,
`sims-variance-multi/0_utils.R`,
`sims-variance-het-sigma{,-bimodal,-bimodal-v2}/0_sim_inference_utils.R`,
`boot/boot_CSM_simulation_code.R`, `boot/development-otsu/test_A-E.R`,
`figs/fig04_sim_toy_3_overlaps.R`. Left `scripts/old/` untouched, and
left alone the many script-local wrapper functions
(e.g. `make_csm_toy_df()`) that happen to have their own same-named
`ctr_dist` parameter — those are the scripts’ own API, not the
package’s. **Found in passing: `figs/fig04_sim_toy_3_overlaps.R` was
already broken before any of this
([`library(CSM)`](https://rdrr.io/r/base/library.html) — a package name
that predates even the `scmatch2` name — and a
`source("./R/diagnostic_plots.R")` relative-path hack instead of using
the installed package), and it also calls `create_toy_df_plot()`, which
the earlier dead-code cleanup pass removed since it had zero references
anywhere in `R/`. That script needs your attention separately —
flagging, not fixing.**

`caliper_sensitivity_plot_stats` → renamed to
`caliper_sensitivity_plot_statistics`, per your instruction. Fixed all
call sites (R/, tests/, scripts/ferman-analysis,
scripts/lalonde-analysis).

`get_distance_table` → renamed to `distance_table`, per your
instruction. Fixed all call sites (R/, tests/, scripts/, incl.
ferman/lalonde analysis scripts).

[`sensitivity_table()`](reference/sensitivity_table.md)/`caliper_sensitivity_*`
naming clash with causal-inference “sensitivity analysis” — **left as-is
per your call** (“sensitivity is a broad term with modeling”). Added a
clarifying doc note to
[`sensitivity_table()`](reference/sensitivity_table.md) and to the
shared `caliper_sensitivity_table` topic (covering
[`caliper_sensitivity_table()`](reference/caliper_sensitivity_table.md)/[`caliper_sensitivity_plot()`](reference/caliper_sensitivity_table.md)/
[`caliper_sensitivity_plot_statistics()`](reference/caliper_sensitivity_table.md)):
“Note: this is not sensitivity in the sense of a Rosenbaum sensitivity
analysis of unmeasured confounding, but rather sensitivity akin to
sensitivity under differing modeling specifications and tuning parameter
selections.”

[`bad_matches()`](reference/bad_matches.md)
vs. `treatment_table(bad = TRUE)` — investigated per your question:
confirmed they’re complementary, not conflicting. Both key off the same
`adacal > threshold` criterion; `treatment_table(bad = TRUE)` returns
the treatment-level table for those units,
[`bad_matches()`](reference/bad_matches.md) returns the full
matched-unit rows (treated + controls) for the same units. No change
made; flagging one small asymmetry for awareness:
[`bad_matches()`](reference/bad_matches.md)’s `threshold` arg has no
default, while `treatment_table(bad=TRUE)` defaults it to the caliper.

`gen_df_adv`/`gen_df_adv_k`/`gen_one_toy` hierarchy — **merged, per your
call (“functionality should be merged, Z should be numerical
regardless”).** [`gen_df_adv_k()`](reference/gen_df_adv_k.md) is now the
one real implementation: gained `f0_sd_fun` support (heteroskedastic
noise, matrix-style `function(X)` convention) for feature parity with
the old [`gen_df_adv()`](reference/gen_df_adv.md), and its `Z` is now
numeric 0/1 (was logical `TRUE`/`FALSE`) — this fix also flows through
to [`gen_one_toy()`](reference/gen_one_toy.md), which already delegated
to [`gen_df_adv_k()`](reference/gen_df_adv_k.md).
[`gen_df_adv()`](reference/gen_df_adv.md) is now a thin wrapper around
`gen_df_adv_k(k = 2, ...)`: it converts its `function(X1, X2)`-style
`f0_fun`/`tx_effect_fun`/`f0_sd_fun` callbacks into
[`gen_df_adv_k()`](reference/gen_df_adv_k.md)’s `function(X)` matrix
convention, then relocates columns so its historical column order
(`id, X1, X2, Z, noise, Y0, Y1, Y`) is preserved, with
[`gen_df_adv_k()`](reference/gen_df_adv_k.md)’s additional `*_denoised`
columns trailing — kept as a separate name/signature rather than
removed, since it’s actively called with that `(X1, X2)` signature
across many scripts (`toy_large_or_lm.R`, `sims-bias_mse*`,
`sims-variance/debug_parallel_sim_inference.R`, etc.) and this way none
of them needed to change. Found and fixed one test that hard-coded the
old logical-`Z` expectation (`test-csm_matches_object.R`). Verified:
full test suite (365 pass) and, separately, the
slow/`RUN_SLOW_TESTS=TRUE` suite — the 3 failures there
(`test-het-sigma-sim.R`, coverage-rate assertions returning `NaN`) are
**pre-existing**, confirmed by reproducing them identically on the
pre-merge commit; unrelated to this change, not fixed (flagging for your
awareness, not something I touched).

`impact_curve` vs. `impact_table` inconsistent with the `*_plot` suffix
convention used elsewhere — **fixed: renamed `impact_curve()` to
[`impact_plot()`](reference/impact_plot.md)** to match every other
plot-producing exported function (`caliper_distance_plot`,
`caliper_sensitivity_plot`, `caliper_sensitivity_plot_statistics`,
`distance_density_plot`, `ess_plot`, `feasible_plot`, `love_plot`,
`scm_vs_avg_distance_plot`); fixed its one external call site
(`scripts/lalonde-analysis/03-lalonde-figures.R`). Remaining `get_`
prefix inconsistency: already resolved as a side effect of the
`get_distance_table` → `distance_table` rename above — no other exported
table-fetching function still carries a `get_` prefix (the only
remaining exported `get_*` functions are
[`get_cal_matches()`](reference/get_cal_matches.md) and the
variance-estimator family, both out of scope here).
