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

## Other confirmed bugs (not yet actioned)

- [ ] `agg_sc_units()`/`agg_avg_units()` (aggregation.R) hard-assume
      exactly 2 rows per subclass group after grouping; degrade
      ungracefully if a subclass ever produces a different count.
- [ ] `gen_sc_weights()` (synthetic_control.R) can silently divide by
      zero (`sol / sum(sol)`) producing `NaN` weights with no warning
      if a QP/LP solve returns all-near-zero weights; the
      zero-controls edge case isn't special-cased like the
      one-control case is.
- [ ] Inconsistent "exact match" tolerance constants: `print.csm_matches()`
      uses `10*.Machine$double.eps`, `result_table(return="exact")`
      uses `100*.Machine$double.eps` — same concept, two different
      magic constants, can disagree on unit counts.
- [x] `love_plot(B = ...)` — resolved: the `B` parameter and its
      `boot_bayesian_covs()` call were removed from `love_plot()`
      entirely (see bug #8 above).
- [ ] `get_total_variance(variance_method = "ai06")` calls
      `get_variance_AI06()`, which doesn't exist anywhere. Documented
      as incomplete in `?get_total_variance`.
- [ ] `gen_df_hain()`'s `outcome` param is restricted by `match.arg()`
      to `c("linear","nl1","nl2")`, but the function body has a
      dead `else if (outcome == "nl3")` branch that can never be
      reached.

## Needs a decision

- [ ] **`R/supplement_functions_to_check.R`** — recently-added file
      defining `boot_bayesian_covs()` (stub that errors) and
      `boot_bayesian()` (real but currently unreferenced). Decide:
      integrate properly (would unblock `love_plot(B=...)`), move to
      `scripts/`, or delete.

## Dead code to remove

- [ ] `create_toy_df_plot()` (diagnostic_plots.R) — unexported, unused
      anywhere.
- [ ] `scm_vs_avg_distance_plot()`'s `if (F) {...}` debug block
      (diagnostic_plots.R) — references undefined `feasible`.
- [ ] Nested `plot_dm()` helper inside `caliper_distance_plot()`
      (diagnostic_plots.R) — never called; references undefined
      `lalonde_params`.
- [ ] ~55 lines of commented-out `get_se_AE_table`/`get_se_AE`
      (estimate.R) — superseded by `get_measurement_error_variance`/
      `estimate_ATT`.
- [ ] `get_plug_in_SE()` (estimate.R) — original author's own comment
      says "This should be removed, I think."
- [ ] Dev-scratch `if (F) {...}` blocks in sim_data.R (reference
      undefined top-level objects).
- [ ] Stray `# browser()` lines in synthetic_control.R.
- [ ] Six unused/duplicate helpers in utils.R (`logit`, `invlogit`,
      `expit`, `rmse`, `weighted_var`, `weighted_se`) — `expit()` is a
      byte-for-byte duplicate of `invlogit()`; neither is called
      anywhere (the one place the package needs inverse-logit uses
      `rje::expit()` instead).

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
