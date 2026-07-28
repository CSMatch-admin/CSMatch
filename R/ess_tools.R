
# Effective Sample Size exploration tools




# ESS plot ----------------------------------------------------------------

#' Effective sample size (ESS) plot
#'
#' Plot the effective sample size (ESS) of the treated units, and
#' various forms of possible control groups depending on their
#' weighting.
#'
#' @param csm A csm_matches object.
#' @param feasible_only If TRUE, compute ESS over only the feasible
#'   treated units (those matched within the target caliper);
#'   otherwise use all treated units (including those matched via an
#'   expanded adaptive caliper).
#' @return A ggplot object (bar chart of ESS by weighting method), with
#'   the underlying table of values attached as the `"table"`
#'   attribute.
#' @examples
#' set.seed(4044440)
#' dat <- gen_one_toy(nt = 5)
#' mtch <- get_cal_matches(dat,
#'                         metric = "maximum",
#'                         scaling = c(1/0.2, 1/0.2),
#'                         caliper = 1,
#'                         rad_method = "adaptive",
#'                         est_method = "csm")
#' ess_plot(mtch)
#'
#' @export
ess_plot <- function(csm, feasible_only = FALSE) {

  tbl <- sensitivity_table( csm, feasible_only = feasible_only )

  df_sc = df_tx = df_avg = df_1nn = NA
  y_lab = "ESS of set of units"

  if ( feasible_only ) {
    y_lab = "ESS of feasible set of units"

    df_sc = tbl$ESS_C[ tbl$Estimate == "FATT" ]
    df_tx = tbl$N_T[ tbl$Estimate == "FATT" ]
    df_avg = tbl$ESS_C[ tbl$Estimate == "FATT_raw" ]
    df_1nn = tbl$ESS_C[ tbl$Estimate == "FATT_1nn" ]
  } else {
    df_sc = tbl$ESS_C[ tbl$Estimate == "ATT" ]
    df_tx = tbl$N_T[ tbl$Estimate == "ATT" ]
    df_avg = tbl$ESS_C[ tbl$Estimate == "ATT_raw" ]
    df_1nn = tbl$ESS_C[ tbl$Estimate == "ATT_1nn" ]
  }

  vars_df <- tibble(
    method = c( "1nn", "avg", "sc", "tx" ),
    ess = c( df_1nn,
             df_avg,
             df_sc,
             df_tx )
  )


  plt <- vars_df %>%
    mutate(method = factor(method, levels=c("1nn", "avg", "sc", "tx"))) %>%
    ggplot(aes(x=method, y=ess)) +
    geom_col(aes(fill = method)) +
    scale_fill_manual(values = c("black",
                                 wesanderson::wes_palette("Zissou1", 5)[c(5,4,1)])) +
    scale_x_discrete(labels = c("Control units \n(1-NN weights)",
                                "Control units \n(Average weights)",
                                "Control units \n(CSM weights)",
                                "Treated units")) +
    theme_classic() +
    guides(fill="none") +
    labs(y = y_lab,
         x = "") +
    coord_flip()

  attr( plt, "table" ) <- vars_df

  plt
}







