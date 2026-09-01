# Future work

Lower-priority follow-ups noted during the 2026-08-31 naming/simplification review (see `TODO.md` for the fuller code-review history). These are deliberately deferred, not forgotten.

## Overlap-statistics function family

`calculate_overlap_statistics()`, `calculate_overlap_statistics_from_match_object()`, and `calculate_overlap_statistics_from_table()` (`R/calculate_overlap_stat.R`) have near-identical names but inconsistent shapes: the first is a backward-compatibility wrapper that returns only the `pairwise_overlap` piece, while the other two return the full three-part result (`pairwise_overlap`, `control_reuse`, `shared_per_treated`). At some point, align these — either by making all three return the same shape, or by renaming to make the difference obvious from the name (e.g. distinguish "pairwise-only" from "full" explicitly). Not worth doing casually since it risks breaking existing callers who rely on the current (smaller) shape from `calculate_overlap_statistics()`.

## `sensitivity_table()`'s `include_distances` branch

`sensitivity_table()`'s `include_distances` branch (`R/sensitivity_plot.R`) builds a full `distance_density_plot()` ggplot object purely to scrape its attached data table. It would be cleaner to pull that table-computation logic out into a helper that both `distance_density_plot()` and `sensitivity_table()` call directly, avoiding the throwaway plot construction. Deferred because it's unclear how to split the shared logic out cleanly without a larger refactor of `distance_density_plot()`.
