
# aggregation functions ---------------------------------------------------


prep_data <- function(scweights,
                      covariates = get_x_vars(scweights),
                      treatment = "Z",
                      outcome =  NULL) {

  # Pull params from the scweights object if it is a csm_matches
  # object
  if ( is.csm_matches(scweights) ) {
    treatment = params(scweights)$treatment
    covariates = attr( scweights, "covariates" )
    scweights <- scweights$matches
  }

  # Convert list of dataframes to single dataframe
  if (!is.data.frame(scweights)) {
    scweights <- scweights %>%
      map_dfr(~mutate(., subclass=id[1]))
  }

  list( scweights = scweights,
        covariates = covariates,
        treatment = treatment,
        outcome = outcome )
}



#' Aggregation methods for matched data
#'
#' @description These functions aggregate matched or
#' synthetic-control–style output into unit-level summaries.
#'
#' @details
#' **`agg_sc_units()`**
#' Aggregate weights within treated-unit subclass to make pairs of tx
#' and corresponding synthetic control units. Generally aggregate by
#' cluster defined by treated unit, calculating the weighted average
#' of the control units in the cluster for all covariates any any
#' provided outcomes
#'
#' **`agg_co_units()`**
#' Aggregates across control units, collecting repeated controls used
#' across treated units and summing their weights.

#'
#' **`agg_avg_units()`**
#' Computes simple averages of controls within each subclass
#' (CEM-style averaging).
#'
#' @param scweights Either a `csm_matches` object or a list/data frame
#'   of matching/synthetic-control weights where each subclass
#'   contains one treated row and its controls.
#' @param covariates Character vector of covariate names. Defaults to
#'   `get_x_vars(scweights)`.
#' @param treatment Name of the treatment indicator column.
#' @param outcome Name of the outcome column.
#'
#' @return A `data.frame` with aggregated treated and control
#'   summaries.
#'
#' @examples
#' set.seed(4044440)
#' dat <- gen_one_toy(nt = 5)
#' mtch <- get_cal_matches(dat,
#'                         metric = "maximum",
#'                         scaling = c(1/0.2, 1/0.2),
#'                         caliper = 1,
#'                         rad_method = "adaptive",
#'                         est_method = "csm")
#' agg_sc_units(mtch, outcome = "Y")
#' agg_co_units(mtch, outcome = "Y")
#' agg_avg_units(mtch, outcome = "Y")
#'
#' @name AggregationMethods
#' @aliases agg_sc_units agg_co_units agg_avg_units
#'
NULL



#' @rdname AggregationMethods
#' @export
agg_sc_units <- function(scweights,
                         covariates = get_x_vars(scweights),
                         treatment = "Z",
                         outcome = NULL ) {
  prep <- prep_data( scweights,
                     covariates,
                     treatment,
                     outcome )
  treatment <- prep$treatment
  outcome <- prep$outcome
  covariates <- prep$covariates
  scweights <- prep$scweights

  cc = c( covariates, outcome )
  rs <- scweights %>%
    group_by(subclass, .data[[treatment]] ) %>%
    summarize(across( all_of( cc ),
                     ~sum(.x * weights)),
              .groups="drop_last")

  # Each subclass should have exactly one treated row and one
  # aggregated-control row; anything else (most commonly an unmatched
  # treated unit with zero controls) breaks the id-assignment below,
  # so fail with a clear message rather than a confusing recycling error.
  assert_two_rows_per_subclass( rs, treatment )

  rs <- rs %>%
    mutate(id = c(NA, subclass[1]), .before="subclass") %>%
    mutate(weights = 1) %>%
    ungroup()

  # Make IDs for the synthetic controls
  rs$id = as.character(rs$id)
  rs$id[ is.na(rs$id) ] <- paste0( rs$subclass[ is.na(rs$id) ], "_syn" )

  rs
}


#' Validate exactly 2 rows (one per treatment level) per subclass
#'
#' `agg_sc_units()`/`agg_avg_units()` assign per-subclass ids via
#' `c(NA, subclass[1])`, which silently misbehaves (a confusing
#' dplyr recycling error) unless every subclass group has exactly 2
#' rows. Most commonly caused by an unmatched treated unit with zero
#' matched controls.
#'
#' @noRd
assert_two_rows_per_subclass <- function( rs, treatment ) {
  bad_subclass <- rs %>%
    filter( dplyr::n() != 2 ) %>%
    dplyr::pull( subclass ) %>%
    unique()

  if ( length(bad_subclass) > 0 ) {
    stop( sprintf(
      "Expected exactly one treated and one control row per subclass (after aggregating by '%s'); subclass(es) %s have a different count. This usually means a treated unit has zero matched controls (e.g. an infeasible/unmatched unit) -- filter it out (e.g. via feasible_only) before aggregating.",
      treatment, paste( bad_subclass, collapse=", " )
    ) )
  }

  invisible(TRUE)
}


#' @rdname AggregationMethods
#' @export
agg_co_units <- function(scweights,
                         covariates = get_x_vars(scweights),
                         treatment = "Z",
                         outcome = NULL ) {

  prep <- prep_data( scweights,
                     covariates,
                     treatment,
                     outcome )
  treatment <- prep$treatment
  outcome <- prep$outcome
  covariates <- prep$covariates
  scweights <- prep$scweights

  # Unlike agg_sc_units()/agg_avg_units(), this function keeps every
  # column (not just `covariates`/`outcome`) via first(), since no
  # aggregation math happens across values -- but a bad `treatment`
  # or `outcome` argument should still be caught rather than silently
  # ignored.
  stopifnot( treatment %in% names(scweights) )
  if ( !is.null(outcome) ) {
    stopifnot( outcome %in% names(scweights) )
  }

  scweights %>%
    group_by(id) %>%
    summarize(across(-contains("weights"), ~first(.)),
              weights = sum(weights),
              subclass = NA,
              dist = NA,
              .groups = "drop")
}



#' @rdname AggregationMethods
#' @export
agg_avg_units <- function(scweights,
                          covariates = get_x_vars(scweights),
                          treatment = "Z",
                          outcome = NULL ) {
  prep <- prep_data( scweights,
                     covariates,
                     treatment,
                     outcome )
  treatment <- prep$treatment
  outcome <- prep$outcome
  covariates <- prep$covariates
  scweights <- prep$scweights

  cc = c( covariates, outcome )

  rs <- scweights %>%
    group_by( subclass, .data[[treatment]] ) %>%
    summarize( across( all_of( cc ),
                     ~sum(.x * 1/n())),
               .groups = "drop_last" )

  assert_two_rows_per_subclass( rs, treatment )

  rs <- rs %>%
    mutate(id = c(NA, subclass[1]), .before="subclass") %>%
    mutate(weights = 1) %>%
    ungroup()

  # Make IDs for the synthetic controls
  rs$id = as.character(rs$id)
  rs$id[ is.na(rs$id) ] <- paste0( rs$subclass[ is.na(rs$id) ], "_avg" )

  rs
}




