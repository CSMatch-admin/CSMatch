# CSMatch code review TODO

Generated from a full code review of `R/` (2026-07-28). Organized by
priority. Checked items are done; the rest are tracked for follow-up.

## Confirmed bugs — fixed 2026-07-28

- [x] 1. `est_method = "csm_extrap"` was documented but not implemented
      (crashed immediately via `est_weights()`). **Fixed: removed as an
      option** (get_cal_matches.R, matching.R, CLAUDE.md).
- [x] 2. `get_total_variance(variance_method = "pooled_het", cluster_comb_mtd = "sample")`
      always crashed — column-name typo (`sample_var_cluster` vs. the
      real `rand_var_cluster`) in estimate.R. **Fixed the typo,
      removed the now-unused `globalVariables()` entry that was
      masking it, added a regression test** (test-estimate.R).
- [x] 3. `agg_co_units()` silently ignored its own `outcome`/`treatment`
      arguments (aggregation.R). Investigated further: the "keep every
      column via `first()`" behavior is intentional and tested
      elsewhere (contrasted against `agg_sc_units`'s narrower output),
      so **fixed by validating `treatment`/`outcome` actually exist as
      columns (erroring clearly if not) rather than restricting the
      output shape**; added a regression test.
- [x] 4. `gen_df_acic()` called `set.seed(random.seed)` internally,
      clobbering the caller's global RNG stream (sim_data.R). **Fixed:
      saves the current RNG state, sets the passed seed, and restores
      the caller's RNG state on exit (via `on.exit()`)**; added a
      regression test (skipped locally since `aciccomp2016` isn't
      installed, but verified the exact save/restore mechanism in
      isolation).
- [x] 5. `get_radius_size()` silently returned `NA` when `k` exceeded
      the number of available controls, silently dropping treated
      units (matching.R). **Fixed: throws a clear error up front**
      (based on `ncol(dm)`, before any computation) for every
      `rad_method` that actually indexes on `k`; added a regression
      test. This also surfaced a latent bug in
      `scripts/lib/wrappers.R`'s test usage (`k=8` default with only 3
      controls) — fixed the test call site to pass an appropriate `k`.
- [x] 6. `estimate_ATT(matches, use_common_variance = FALSE)` on a plain
      data frame threw "formal argument matched by multiple actual
      arguments" (estimate.R). Root cause: `covs`/`scaling`/`metric`/
      `id_name` were only ever assigned as local variables inside the
      `is.csm_matches()` branch, then unconditionally forwarded
      alongside `...`. **Fixed: made these (plus `K`) explicit,
      documented parameters of `estimate_ATT()` with
      supplied-value-wins-over-object-params precedence**; this also
      surfaced and fixed a second bug, a `pp$covs` typo (should be
      `pp$covariates` — `params()` has no `covs` field) present in
      *two* places (`estimate_ATT()` and `get_finite_variance()`
      itself); added a 3-scenario regression test (csm_matches
      auto-populate, plain data frame with explicit args, explicit
      override taking precedence).
- [x] 7. `get_measurement_error_variance_OR()` rejected `boot_mtd =
      "sign"` even though it's the package-wide default elsewhere
      (estimate.R). **Fixed: added "sign" to the allowed methods and
      error message, updated docs**; added a regression test.
- [x] 8. `love_plot2()` was dead and fully broken — reads attributes
      nothing ever sets (diagnostic_plots.R). **Removed**, along with
      the adjacent dead commented-out bootstrap block inside
      `love_plot()` (the `B` parameter and that code path had already
      been removed from `love_plot()` itself, resolving the
      "`love_plot(B=...)` incomplete" item below as a side effect).

## Other confirmed bugs — fixed 2026-08-31

- [x] `agg_sc_units()`/`agg_avg_units()` (aggregation.R) hard-assumed
      exactly 2 rows per subclass group after grouping (most commonly
      broken by an unmatched treated unit with zero controls),
      producing a confusing dplyr recycling error. **Fixed: added a
      shared `assert_two_rows_per_subclass()` check that errors
      clearly up front**; added a regression test.
- [x] `gen_sc_weights()` (synthetic_control.R) could silently divide
      by zero (`sol / sum(sol)`) producing `NaN` weights with no
      warning if a QP/LP solve returned all-near-zero weights, and
      didn't special-case zero controls the way it special-cased one
      control. **Fixed: added a zero-controls case that errors
      clearly; extracted the drop-tiny-weights/renormalize step into
      `normalize_sc_weights()`, which now errors instead of dividing
      by zero**; added regression tests. Also removed two stray
      `# browser()` lines encountered in the same file (see "Dead
      code" below).
- [x] Inconsistent "exact match" tolerance constants: `print.csm_matches()`
      used `10*.Machine$double.eps`, `result_table(return="exact")`
      used `100*.Machine$double.eps` — same concept, two different
      magic constants, could disagree on unit counts. **Fixed: unified
      on a single `EXACT_MATCH_TOL` constant** (csm_matches_object.R),
      used in both places.
- [x] `love_plot(B = ...)` — resolved: the `B` parameter and its
      `boot_bayesian_covs()` call were removed from `love_plot()`
      entirely (see bug #8 above).
- [x] `get_total_variance(variance_method = "ai06")` calling
      `get_variance_AI06()` (which doesn't exist) — **already resolved
      prior to this TODO file** (commit `ce2c390`, per your own
      earlier decision to "leave it with a note in the docs saying
      it is incomplete"): it now throws a clear `stop()` up front and
      `?get_total_variance` documents it as incomplete. No further
      action taken.
- [x] `gen_df_hain()`'s `outcome` param is restricted by `match.arg()`
      to `c("linear","nl1","nl2")`, but the function body had a
      dead `else if (outcome == "nl3")` branch that could never be
      reached. **Removed.**

## Needs a decision — resolved 2026-08-31

- [x] **`R/supplement_functions_to_check.R`** — deleted per your
      decision. Verified `boot_bayesian()`/`boot_bayesian_covs()` had
      no live callers anywhere in `R/`, `tests/`, or `scripts/` (the
      similarly-named things in `tests/testthat/old/test_bootstrap.R`
      and `scripts/boot/boot_CSM_simulation_code.R` define their own
      unrelated same-named functions).

## Dead code — removed 2026-08-31

- [x] `create_toy_df_plot()` (diagnostic_plots.R) — unexported, unused
      anywhere. Removed.
- [x] `scm_vs_avg_distance_plot()`'s `if (F) {...}` debug block
      (diagnostic_plots.R) — referenced undefined `feasible`. Removed.
- [x] Nested `plot_dm()` helper inside `caliper_distance_plot()`
      (diagnostic_plots.R) — never called; referenced undefined
      `lalonde_params`. Removed (also dropped `lalonde_params` from
      `globalVariables()` since nothing references it anymore).
- [x] ~55 lines of commented-out `get_se_AE_table`/`get_se_AE`
      (estimate.R) — superseded by `get_measurement_error_variance`/
      `estimate_ATT`. Removed.
- [x] `get_plug_in_SE()` (estimate.R) — original author's own comment
      said "This should be removed, I think." Removed, along with its
      now-orphaned test in test-estimate.R. (Note: still used via
      `CSMatch:::get_plug_in_SE()` in `scripts/draft-inference-scripts/`
      — those are unmaintained draft scripts per CLAUDE.md and were
      left as-is, not fixed up.)
- [x] Dev-scratch `if (F) {...}` blocks in sim_data.R (referenced
      undefined top-level objects `nc`/`nt`/`f0_sd`/`input_2016`/
      `dgp_2016`). Removed both.
- [x] Stray `# browser()` lines in synthetic_control.R. Removed both.
- [x] Unused/duplicate helpers in utils.R: removed `logit`, `expit`,
      `rmse`, `weighted_var`, `weighted_se` (all confirmed to have zero
      callers anywhere in `R/`, `tests/`, or `scripts/`). **Correction
      to this item's original description: `invlogit()` was kept** —
      unlike the others it *is* actually called, via
      `CSMatch:::invlogit()` in `scripts/lib/wrappers.R` (a live,
      tracked script, not one of the `old/`/draft ones); the original
      code review missed this `:::`-qualified call site.

## Reuse / simplification / efficiency

- [ ] `compute_pairwise_shared_controls()`/`compute_shared_controls_per_treated()`
      (calculate_overlap_stat.R) use O(N²) loops with per-pair
      `intersect()`; reduce to one matrix multiply on a
      treated×control incidence matrix.
- [ ] `get_radius_size()`'s four branches are ~90% duplicated
      boilerplate differing only in the final one-line computation.
- [ ] `set_NA_to_unmatched_co()` (matching.R) — per-row for-loop that
      vectorizes cleanly.
- [ ] `sensitivity_table()`'s `include_distances` branch builds a full
      `distance_density_plot()` ggplot object purely to scrape its
      attached data table.
- [ ] Duplicated ~8-line all-`NA` placeholder list appears 3x verbatim
      in `calculate_overlap_stats_from_table()`.
- [ ] `calculate_subclass_variances()` and the `s_t_sq_df` block inside
      `calculate_s_j_sq()` independently reimplement near-identical
      "variance per subclass" logic.
- [ ] `feasible_plot()` refits `estimate_ATT()` from scratch once per
      cumulative subset of treated units — O(n) full recomputations.

## Naming issues (need your input before renaming — these are
## public-API-breaking for exported functions)

- [ ] `sensitivity_table()`/`caliper_sensitivity_*` — name clashes with
      the established causal-inference meaning of "sensitivity
      analysis" (robustness to unmeasured confounding); this family
      does something unrelated (comparing weighting methods).
- [ ] `calculate_overlap_statistics()` vs.
      `calculate_overlap_statistics_from_match_object()` vs.
      `calculate_overlap_stats_from_table()` — near-identical names,
      inconsistent `statistics`/`stats` abbreviation, and the
      shortest-named one returns a *different, smaller* shape than its
      siblings.
- [ ] `params()` and `ess()` — dangerously generic/terse exported names
      (collision risk in a user's session).
- [ ] The variance-estimator family (`get_pooled_variance`,
      `get_measurement_error_variance[_het/_OR]`, `get_finite_variance`,
      `get_total_variance`) — dispatch strings don't match function
      names (`variance_method="bootstrap"` → `..._OR`; `"pooled"` → a
      function whose name doesn't say "pooled").
- [ ] Five different parameter names across the package for "the
      csm_matches object": `x`, `object`, `csm`, `res`, `mtch`.
- [ ] `gen_df_adv`/`gen_df_adv_k`/`gen_one_toy` — hierarchy invisible
      from names (`gen_one_toy` wraps `gen_df_adv_k`, not
      `gen_df_adv`); "adv" is an undocumented abbreviation.
- [ ] `k` is overloaded package-wide: "number of neighbors" in matching
      code vs. "covariate dimensionality" in DGP code.
- [ ] `bad_matches()` vs. `treatment_table(bad = TRUE)` — two different
      "bad" concepts, easy to conflate.
- [ ] `matched_gps` parameter in `est_weights()` — unclear abbreviation.
- [ ] `ctr_dist` parameter (DGP functions) — misleading; actually means
      cluster separation, not control-vs-treated distance.
- [ ] Minor: `caliper_sensitivity_plot_stats` reads awkwardly;
      `impact_curve` vs. `impact_table` inconsistent with the `*_plot`
      suffix convention used elsewhere; `get_` prefix used
      inconsistently (`get_distance_table` vs. `sensitivity_table`/
      `caliper_table`, same "fetch a table" role).
