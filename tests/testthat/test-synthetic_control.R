

test_that("gen_sc_weights errors clearly on a treated unit with zero matched controls", {

  d <- data.frame( id = "T1", X1 = 1, X2 = 2 )

  expect_error(
    gen_sc_weights( d, match_cols = c("X1","X2"), scaling = c(1,1), metric = "maximum" ),
    "zero matched controls"
  )
})


test_that("normalize_sc_weights errors clearly instead of silently producing NaN weights when the solve is degenerate", {

  # A normal solve: drops tiny weights, renormalizes to sum to 1.
  expect_equal( normalize_sc_weights( c(0.5, 0.5, 1e-9) ), c(0.5, 0.5, 0) )

  # A degenerate solve (e.g. solver infeasibility) returning
  # all-near-zero weights should error, not silently divide by zero.
  expect_error(
    normalize_sc_weights( c(0, 1e-9, 0) ),
    "all-\\(near-\\)zero weights"
  )
})
