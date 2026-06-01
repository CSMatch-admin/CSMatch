# tests/testthat/test-bugfixes.R
#
# Regression tests for three runtime bugs fixed on 2026-06-01.
# Each test would have FAILED on the pre-fix code.

library(dplyr)

# ── Shared minimal dataset ─────────────────────────────────────────────────────
make_df <- function(K = 1, seed = 42) {
  set.seed(seed)
  n <- 200
  df <- as.data.frame(matrix(rnorm(n * K), nrow = n,
                              dimnames = list(NULL, paste0("X", seq_len(K)))))
  df$Z  <- rep(0:1, each = n / 2)
  df$Y  <- rnorm(n) + df$Z
  df$id <- seq_len(n)
  df
}

# ── Bug 1: aggregation.R bare map_dfr ─────────────────────────────────────────
# Before fix: result_table() called purrr::map_dfr without the purrr:: prefix,
# causing "could not find function 'map_dfr'" when purrr was not attached.
test_that("result_table works without purrr loaded (map_dfr namespace fix)", {
  df <- make_df(K = 2)
  m  <- get_cal_matches(df, metric = "maximum", caliper = 1, scaling = 1,
                        rad_method = "knn", k = 3, est_method = "average")
  # result_table internally calls purrr::map_dfr; must work without library(purrr)
  tbl <- result_table(m, nonzero_weight_only = TRUE)
  expect_s3_class(tbl, "data.frame")
  expect_true(all(c("id", "subclass", "weights", "Z") %in% names(tbl)))
})

# ── Bug 2: default_scaling() returned a tibble, not a named numeric vector ────
# Before fix: calling get_cal_matches() without explicit scaling= argument
# caused downstream failures because scaling was a 1-row tibble.
test_that("default_scaling returns a named numeric vector, not a tibble", {
  df  <- make_df(K = 2)
  sc  <- CSM:::default_scaling(df, c("X1", "X2"))
  expect_true(is.numeric(sc))
  expect_false(is.data.frame(sc))
  expect_named(sc, c("X1", "X2"))
  expect_true(all(sc > 0))
})

test_that("default_scaling works for K=1 single covariate", {
  df <- make_df(K = 1)
  sc <- CSM:::default_scaling(df, "X1")
  expect_true(is.numeric(sc) && length(sc) == 1L)
  expect_false(is.data.frame(sc))
})

test_that("get_cal_matches works without explicit scaling (uses default_scaling)", {
  df <- make_df(K = 2)
  # Before fix this would fail or produce wrong results because default_scaling
  # returned a tibble and names(scaling) check in get_cal_matches was unreliable.
  expect_no_error(
    get_cal_matches(df, metric = "maximum", caliper = 2,
                    rad_method = "knn", k = 3, est_method = "average")
  )
})

# ── Bug 3: distance.R covs[co_obs,] dropped matrix dims for K=1 ───────────────
# Before fix: with a single covariate (K=1), covs[co_obs,] returned a numeric
# vector instead of a matrix, causing flexclust::dist2() to fail.
test_that("matching works with a single covariate and no explicit scaling", {
  df <- make_df(K = 1)
  # Before fix: 'Error in ... non-conformable arrays' or similar.
  expect_no_error(
    get_cal_matches(df, covs = "X1", metric = "maximum", caliper = 2,
                    rad_method = "knn", k = 3, est_method = "average")
  )
})

test_that("ai06 variance works for K=1 (single covariate, no drop bug)", {
  df <- make_df(K = 1)
  m  <- get_cal_matches(df, metric = "maximum", caliper = 1, scaling = 1,
                        rad_method = "knn", k = 3, est_method = "average")
  r  <- estimate_ATT(m, superpopulation = TRUE, variance_method = "ai06",
                     df = df, M = 3, covs = "X1")
  # Before fix: ~33% NA rows in ai06 for K=1; ATT should be finite now.
  expect_true(is.finite(r$ATT))
  expect_true(is.finite(r$SE))
})
