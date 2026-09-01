# Future work

Lower-priority follow-ups noted during the 2026-08-31 naming/simplification review (see `TODO.md` for the fuller code-review history). These are deliberately deferred, not forgotten.

## Overlap-statistics function family

`calculate_overlap_statistics()`, `calculate_overlap_statistics_from_match_object()`, and `calculate_overlap_statistics_from_table()` (`R/calculate_overlap_stat.R`) have near-identical names but inconsistent shapes: the first is a backward-compatibility wrapper that returns only the `pairwise_overlap` piece, while the other two return the full three-part result (`pairwise_overlap`, `control_reuse`, `shared_per_treated`). At some point, align these — either by making all three return the same shape, or by renaming to make the difference obvious from the name (e.g. distinguish "pairwise-only" from "full" explicitly). Not worth doing casually since it risks breaking existing callers who rely on the current (smaller) shape from `calculate_overlap_statistics()`.

## `sensitivity_table()`'s `include_distances` branch

`sensitivity_table()`'s `include_distances` branch (`R/sensitivity_plot.R`) builds a full `distance_density_plot()` ggplot object purely to scrape its attached data table. It would be cleaner to pull that table-computation logic out into a helper that both `distance_density_plot()` and `sensitivity_table()` call directly, avoiding the throwaway plot construction. Deferred because it's unclear how to split the shared logic out cleanly without a larger refactor of `distance_density_plot()`.

## Overlap-statistics O(N²) loops

`compute_pairwise_shared_controls()`/`compute_shared_controls_per_treated()` (`R/calculate_overlap_stat.R`) use O(N²) loops with per-pair `intersect()` calls to compute shared-control counts between every pair of treated units. This could be reduced to a single matrix multiply on a treated×control incidence matrix (build a 0/1 matrix of which controls each treated unit uses, then the shared-control counts fall out of the matrix product with its transpose). Worth doing if overlap statistics are ever run on large matched datasets where the O(N²) loop becomes a bottleneck; not urgent otherwise.

## `feasible_plot()`'s repeated `estimate_ATT()` refits

`feasible_plot()` (`R/sensitivity_plot.R`) refits `estimate_ATT()` from scratch once per cumulative subset of treated units, an O(n) sequence of full recomputations as units are added one at a time. This is likely *not* a major cost in practice since it's re-estimating on an already-matched table (no rematching involved) rather than rerunning the expensive matching step — but this hasn't been benchmarked. Worth a quick profiling pass if `feasible_plot()` is ever slow in practice (e.g. very large `n` or used inside a bootstrap loop); not worth optimizing pre-emptively.
