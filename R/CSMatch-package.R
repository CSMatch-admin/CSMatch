#' CSMatch: Caliper Synthetic Matching
#'
#' @description
#' CSMatch implements Caliper Synthetic Matching (CSM), a method for
#' matching in observational studies. Given an observational dataset,
#' CSM matches each treated unit to a set of nearby control units
#' using a (possibly adaptive) radius/caliper on a user-specified
#' distance metric over the covariates, and then builds a synthetic
#' counterfactual for each treated unit from its matched controls.
#' The package also provides tools for choosing a distance metric and
#' caliper, diagnosing match quality, and estimating (and getting
#' standard errors for) the resulting average treatment effect on the
#' treated.
#'
#' @details
#' The typical workflow is:
#'
#' \enumerate{
#'   \item Call \code{\link{get_cal_matches}()} to match treated units
#'     to nearby control units (see \code{rad_method} for how the
#'     radius/caliper is chosen) and generate matched-set weights (see
#'     \code{est_method}, e.g. synthetic-control weights vs. simple
#'     averaging). This returns a \link[=is.csm_matches]{csm_matches} object.
#'   \item Use the diagnostic tools (e.g. \code{\link{caliper_distance_plot}},
#'     \code{\link{love_plot}}, \code{\link{sensitivity_table}},
#'     \code{\link{caliper_sensitivity_plot}}) to check match quality
#'     and tune the distance metric, scaling, and caliper.
#'   \item Refit with \code{\link{update_matches}()} as those choices
#'     change, without having to respecify the entire call.
#'   \item Extract the final matched data with \code{\link{result_table}()}
#'     or \code{as.data.frame()}, and estimate the treatment impact with
#'     \code{\link{estimate_ATT}()}.
#' }
#'
#' See \code{vignette("lalonde-example", package = "CSMatch")} for a
#' worked example, including how to select a distance metric and
#' caliper, on the canonical LaLonde job-training dataset.
#'
#' @section Main functions:
#' \describe{
#'   \item{Matching}{\code{\link{get_cal_matches}}, \code{\link{gen_matches}},
#'     \code{\link{update_matches}}}
#'   \item{The csm_matches object}{\code{\link{result_table}},
#'     \code{\link{treatment_table}}, \code{\link{params}},
#'     \code{\link{unmatched_units}}, \code{\link{bad_matches}}}
#'   \item{Diagnostics}{\code{\link{caliper_distance_plot}}, \code{\link{love_plot}},
#'     \code{\link{distance_density_plot}}, \code{\link{ess_plot}},
#'     \code{\link{feasible_plot}}, \code{\link{sensitivity_table}},
#'     \code{\link{caliper_sensitivity_table}}, \code{\link{caliper_sensitivity_plot}}}
#'   \item{Estimation}{\code{\link{estimate_ATT}}, \code{\link{boot_SE}}}
#'   \item{Simulated data generators}{\code{\link{gen_one_toy}}, \code{\link{gen_df_adv}},
#'     \code{\link{gen_df_hain}}, \code{\link{gen_df_kang}}, \code{\link{gen_df_acic}}}
#' }
#'
#' @references
#' Che, J., Meng, X., & Miratrix, L. (2024). Caliper Synthetic
#' Matching: Generalized Radius Matching with Local Synthetic Controls.
#' \url{https://arxiv.org/abs/2411.05246}
#'
#' @keywords internal
#' @import dplyr
#' @import tidyr
#' @import ggplot2
#' @import tibble
#' @import purrr
#' @importFrom latex2exp TeX
#' @importFrom stringr str_replace
#' @importFrom stats cov dist median model.frame quantile rbinom rchisq
#'   rmultinom rnorm runif sd setNames var weighted.mean weights
#' @importFrom utils modifyList
"_PACKAGE"

## usethis namespace: start
## usethis namespace: end
NULL
