
# functions to generate diagnostic plots


# Exploring distances -----


#' Distance of kth neighbor plot
#'
#' Plot distribution of distances between treated units and their
#' kth-nearest neighbors in the control group, for a set of k values.
#'
#' @param csm A csm_matches object
#' @param tops A vector of integers indicating which nearest neighbors
#'   to plot
#' @param caliper Optional caliper value to plot as a vertical line.
#'   Otherwise it will take caliper from csm object.  If NA will plot
#'   no line.
#' @param target_percentile Optional target percentile for caliper,
#'   which will calculate caliper to achieve.
#' @param target_k Which of the values in `tops` to use when computing
#'   the caliper for `target_percentile` (default 1, the nearest
#'   neighbor).
#'
#' @return The plot with some extra attributes.  First is "distances",
#'   the table of distances to the kth nearest neighbor. Second, if
#'   caliper provided, "table" with the table of proportion of
#'   distances below the caliper for each k.  Last is "caliper", the
#'   caliper value used.
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
#' caliper_distance_plot(mtch, tops = c(1, 2, 3), target_percentile = 0.8)
#'
#' @export
caliper_distance_plot <- function( csm, tops = 1:3, caliper = NULL,
                                   target_percentile = NULL,
                                   target_k = 1 ) {

  tops = sort(tops)

  # Extract distance matrix from slot
  dist_matrix <- data.frame(t(as.matrix(csm$dm_uncapped)))
  dm_col_sorted <- apply(dist_matrix, 2, sort)

  # Top 1, 2, 3 distances
  dists <- dm_col_sorted[tops,] %>%
    t() %>%
    as.data.frame() %>%
    set_names( tops ) %>%
    pivot_longer( cols=everything(),
                  names_to = "Rank",
                  values_to = "Distance") %>%
    mutate( Rank = as.numeric( Rank ) )


  plt <- ggplot( dists, aes( Distance )  ) +
    facet_wrap( ~Rank, ncol=1 ) +
    geom_histogram( color="black" ) +
    labs( y = "" ) +
    theme_minimal() +
    theme(
      axis.text.y = element_blank(),
      axis.ticks.y = element_blank(),
      panel.grid.minor = element_blank()
    )

  if ( !is.null( target_percentile ) ) {
    if( !( target_k %in% tops ) ) {
      stop( "target_k must be one of the values in tops" )
    }

    caliper <- quantile( dists$Distance[ dists$Rank == target_k ],
                         probs = target_percentile )
  }
  attr( plt, "distances" ) <- dists

  if ( is.null( caliper ) ) {
    caliper = params(csm)$caliper
  }

  if ( !is.null( caliper ) && !is.na( caliper) ) {

    tbl <- dists %>%
      group_by( Rank ) %>%
      summarise( pct_below_caliper = mean( Distance <= caliper ) )

    #  ach_percentile <- tbl$pct_below_caliper[ tbl$Rank == target_k ]

    x_loc = max( dists$Distance ) * 0.95

    plt <- plt +
      geom_vline( xintercept = caliper, col="red" ) +
      geom_text(
        data = tbl,
        aes(
          x = x_loc, y = Inf,
          label = scales::percent(pct_below_caliper, accuracy = 1)
        ),
        hjust = 1.1, vjust = 1.1,
        inherit.aes = FALSE
      ) +
      labs( caption = glue::glue( "Caliper = {round( caliper, 3 )}" ) )

    attr( plt, "caliper" ) <- caliper
    attr( plt, "table" ) <- tbl
  }

  plt
}


#' Calculate distances from all matched treatment units to controls
#'
#' Look at distances between each treated unit and their synthetic
#' control, average control, and closest control.
#'
#' @param csm A csm_matches object
#' @param long_table If TRUE, return a long-form table with method and
#'   distance columns.  If FALSE each tx unit is a row.
#'
#' @return A data frame with distances from each treated unit to their
#'   synthetic control, average control, and closest control.
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
#' distance_table(mtch)
#'
#' @export
distance_table <- function( csm,
                                long_table = FALSE ) {
  d = result_table(csm)
  scaling = params(csm)$scaling
  metric = params(csm)$metric
  covariates = params(csm)$covariates
  treatment = params(csm)$treatment
  outcome = params(csm)$outcome

  if ( is.null( csm$treatment_table ) ) {
    csm$treatment_table <- make_treatment_table(csm)
  }

  # check distances bw each tx/sc pair
  sc_dists <- csm %>%
    agg_sc_units()
  stopifnot( all( sc_dists$id[sc_dists[[treatment]]==1] == csm$treatment_table$id) )
  sc_dists <- sc_dists %>%
    gen_dm(scaling = scaling,
           covs = covariates,
           treatment = treatment,
           metric = metric) %>%
    diag()

  avg_dists <- csm %>%
    agg_avg_units()
  stopifnot( all( avg_dists$id[avg_dists[[treatment]]==1] == csm$treatment_table$id) )

  avg_dists <- avg_dists %>%
    gen_dm(scaling = scaling,
           covs = covariates,
           treatment = treatment,
           metric = metric) %>%
    diag()

  nn_dists <- csm %>%
    result_table() %>%
    group_by( .data[[treatment]], ,subclass) %>%
    filter(dist == min(dist)) %>%
    mutate(weights = 1/n()) %>%
    ungroup() %>%
    agg_avg_units( covariates = covariates,
                   treatment = treatment,
                   outcome = outcome )
  stopifnot( all( nn_dists$id[nn_dists[[treatment]]==1] == csm$treatment_table$id) )
  nn_dists <- nn_dists %>%
    gen_dm(scaling = scaling,
           covs = covariates,
           treatment = treatment,
           metric = metric) %>%
    diag()

  res_list <- list(sc = sc_dists, avg = avg_dists, nn = nn_dists)
  dist_table <- tibble(id = csm$treatment_table$id,
                       CSM = sc_dists,
                       average = avg_dists,
                       closest = nn_dists)

  dist_table <- dist_table %>%
    left_join( csm$treatment_table %>%
                 dplyr::select( id, feasible, matched ),
               by="id" )

  if ( long_table ) {
    dist_table <- dist_table %>%
      pivot_longer( c( `CSM`, `average`, `closest` ),
                    names_to = "method", values_to="distance" ) %>%
      mutate(method = factor( method, levels = c( "CSM", "average", "closest" ) ) )
  }


  dist_table
}


# CSM evaluation plot -----------------------------------------------------

#' Calculate distances from treated units to their controls
#'
#'
#' Look at distribution of pairwise distances between treated unit and
#' their synthetic control, average control, and 1-NN control.
#'
#' @param csm A csm_matches object
#' @param feasible_only If TRUE, only plot distances for treated units
#'   that were feasible and matched.
#' @param boxplot_style If TRUE, use boxplot style for the density
#'   plot.
#'
#' @return A ggplot object showing the density of distances. Also has
#'   two attributes: "table" with summary statistics of the distances,
#'   and "dist_table" with the full table of distances.
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
#' distance_density_plot(mtch)
#'
#' @export
distance_density_plot <- function(csm, feasible_only = FALSE, boxplot_style = TRUE ) {

  dist_table <- distance_table( csm, long_table = TRUE )

  # rename method factor level closest to 1-NN
  dist_table <- dist_table %>%
    mutate( method = recode( method,
                             closest = "1-NN",
                             average = "Average",
                             CSM = "CSM" ) )

  dd <- if ( feasible_only ) {
    dist_table %>%
      filter( feasible == 1 & matched == 1 )
  } else {
    dist_table
  }

  if ( boxplot_style ) {
    plt <- ggplot( dd, aes( method, distance, col=method ) ) +
      geom_boxplot() +
      coord_flip() +
      theme_classic() +
      scale_color_manual(values = wesanderson::wes_palette("Zissou1", 5)[c(5,4,1)]) +
      labs(y = "",
           y = "Distance between treated unit \nand corresponding control",
           color = "Method")

  } else {
    plt <- ggplot(dd, aes(x=distance, color=method)) +
      geom_density(linewidth=1) +
      theme_classic() +
      scale_color_manual(values = wesanderson::wes_palette("Zissou1", 5)[c(5,4,1)]) +
      labs(y = "Density",
           x = "Distance between treated unit \nand corresponding control",
           color = "Method")
  }

  tbl <- dd %>%
    group_by( method ) %>%
    summarise( mean = mean( distance ),
               median = median( distance ) )

  attr( plt, "table" ) <- tbl
  attr( plt, "dist_table" ) <- dist_table

  return(plt)
}



#' Explore pairwise distances
#'
#' Look at the distance between each treated unit and their synthetic control
#' versus the distance between each treated unit and the simple average control.
#'
#' @noRd
scm_vs_avg_distance_plot <- function(csm) {

  d = result_table(csm)
  scaling = params(csm)$scaling
  metric = params(csm)$metric

  # check distances bw each tx/sc pair
  sc_dists <- d %>%
    agg_sc_units() %>%
    gen_dm(scaling = scaling,
           metric = metric) %>%
    diag()
  avg_dists <- d %>%
    agg_avg_units() %>%
    gen_dm(scaling = scaling,
           metric = metric) %>%
    diag()

  # TODO: simple plot comparing distance between:
  #  - tx unit and simple average control
  #  - tx unit and synthetic control

  tibble(sc_dists = sc_dists,
         avg_dists = avg_dists) %>%
    ggplot(aes(x=sc_dists, y=avg_dists)) +
    geom_point() +
    geom_abline(lty="dotted") +
    theme_classic() +
    labs(y = "Distance between treated and average unit",
         x = "Distance between treated and SC unit")
}



# love plot ---------------------------------------------------------------

get_diff_scm_co_and_tx <- function(csm, covs){
  stopifnot( is.csm_matches(csm) )

  ada = csm$treatment_table %>%
    dplyr::select(id, adacal) %>%
    mutate( id = as.character(id) )
  df_diff_scm_co_and_tx <- result_table(csm) %>%
    left_join(ada,
              by="id") %>%
    group_by(subclass) %>%
    summarize(adacal = last(adacal),
              across(all_of(covs),
                     ~.[2] - .[1]))
  return(df_diff_scm_co_and_tx)
}



create_love_plot_df <- function(csm, covs){
  feasible_subclasses <- feasible_units(csm)
  n_feasible <- nrow(feasible_subclasses)

  df_step_1<-
    get_diff_scm_co_and_tx(csm,covs)

  df_step_2<-df_step_1 %>%
    arrange(adacal) %>%
    mutate(order = 1:n(),
           across(all_of(covs),
                  ~cumsum(.) / order))

  df_step_3 <- df_step_2 %>%
    slice((n_feasible):n()) %>%
    pivot_longer(all_of(covs))
  love_plot_df <- df_step_3
  return(love_plot_df)
}


#' Love plot of covariate balance
#'
#' Make a ggplot love plot of covariate balance for each covariate
#' passed. Treated units are added one at a time, in order of
#' increasing adaptive caliper, and the running treated-vs-control
#' mean difference is tracked for each covariate.
#'
#' @param csm A csm_matches object.
#' @param covs Character vector of covariate names to plot. Defaults
#'   to all covariates used in the match.
#' @param covs_names Optional character vector of display names for
#'   `covs`, in the same order.
#' @return A ggplot object.
#' @examples
#' set.seed(4044440)
#' dat <- gen_one_toy(nt = 5)
#' mtch <- get_cal_matches(dat,
#'                         metric = "maximum",
#'                         scaling = c(1/0.2, 1/0.2),
#'                         caliper = 1,
#'                         rad_method = "adaptive",
#'                         est_method = "csm")
#' love_plot(mtch, covs = c("X1", "X2"))
#'
#' @export
love_plot <- function( csm, covs = NULL, covs_names = NULL ) {


  cc = params(csm)$covariates
  if ( !is.null( covs ) ) {
    stopifnot( all( covs %in% cc ) )
  } else {
    covs = cc
  }

  if ( !is.null( covs_names ) && !is.null( covs ) ) {
    stopifnot( length( covs_names ) == length( covs ) )
  }

  love_steps <- create_love_plot_df(csm, covs)

  if ( !is.null( covs_names ) ) {
    love_steps$name <- covs_names[ match( love_steps$name, covs ) ]
  } else {
    covs_names = covs
  }

  p <- love_steps %>%
    ggplot(aes(x=order, color=name)) +
    geom_point(data=. %>%
                 slice( c( seq(1,length(covs)),
                           seq( n()-length(covs)+1, n()))),
               aes(y=value), size=2) +
    geom_step(aes(y=value, group=name),
              linewidth=1.1) +
    expand_limits(y = 0) +
    geom_hline(yintercept=0,
               lty="dotted") +
    facet_wrap(~name,
               scales="free_y") +
    labs(y = "\n Covariate balance (tx-co)",
         x = "Total number of treated units used",
         color = "Covariate") +
    theme_classic() +
    make_tx_axis( love_steps$order )

  return(p)

}


# Impact curve ----


#' Impact curve plot
#'
#' Plot the relationship between maximum distance in matched set and
#' the outcome difference within matched sets.
#'
#' @param csm A csm_matches object
#' @param outcome The name of the outcome variable to plot.
#' @param min_dist If TRUE (default), use the minimum distance from
#'   the treated unit to its matched controls as the x-axis; if FALSE,
#'   use the maximum distance.
#' @param jitter If TRUE, jitter the plotted points horizontally to
#'   reduce overplotting from tied distances.
#'
#' @return A ggplot object showing the impact curve. Also has an
#'   attribute "table" with the underlying data used to create the
#'   plot.
#' @examples
#' set.seed(4044440)
#' dat <- gen_one_toy(nt = 5)
#' mtch <- get_cal_matches(dat,
#'                         metric = "maximum",
#'                         scaling = c(1/0.2, 1/0.2),
#'                         caliper = 1,
#'                         rad_method = "adaptive",
#'                         est_method = "csm")
#' impact_curve(mtch, outcome = "Y")
#' @export
impact_curve <- function( csm, outcome, min_dist = TRUE, jitter = FALSE ) {

  if ( is.csm_matches( csm ) ) {
    rsb = impact_table( csm=csm, outcome=outcome )
  } else {
    rsb = csm
  }

  ATT = mean( rsb$outcome )

  if ( min_dist ) {
    plt <- ggplot( rsb, aes( x = min_dist, y = outcome ) )
    x_lab = "Minimum Distance in Matched Set"
  } else {
    plt <- ggplot( rsb, aes( x = max_dist, y = outcome ) )
    x_lab = "Maximum Distance in Matched Set"
  }

  if ( jitter ) {
    plt <- plt +
      geom_jitter( aes( size = precision ), alpha = 0.25, width = 0.02, height = 0.02 )
  } else {
    plt <- plt +
      geom_point( aes( size = precision ), alpha = 0.25 )
  }

  plt <- plt +
    geom_smooth( method = "loess" ) +
    scale_size( range = c( 1.5, 3 ) ) +
    labs( x = x_lab,
          y = "Impact" ) +
    theme_minimal() +
    geom_hline( yintercept = ATT )

  attr( plt, "table" ) <- rsb

  return( plt )
}

