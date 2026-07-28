
# #' Old residual bootstrap code
# #'
# #' @param resids (desc)
# #' @param B  (desc)
# #' @param boot_mtd  (desc)
# #' @param seed_addition  (desc)
# #'
# #' @return (desc)
# #' @export
# #'
# boot_by_resids <-
#   function(resids,
#            B,
  #          boot_mtd,
  #          seed_addition = 123){
  #   T_star <- numeric(B)
  #   for (b in 1:B){
  #     set.seed(123 + seed_addition + b*13)
  #     n1 <- length(resids)
  #     # The implemented W is W(in the paper) / sqrt(n)
  #     if (boot_mtd=="Bayesian"){
  #       W = gtools::rdirichlet(1, alpha=rep(1,n1))
  #     }else if (boot_mtd=="wild"){
  #       W = sample(
  #         c( -(sqrt(5)-1)/2, (sqrt(5)+1)/2 ),
  #         prob = c( (sqrt(5)+1)/(2*sqrt(5)), (sqrt(5)-1)/(2*sqrt(5)) ),
  #         replace = T, size = n1) / n1
  #     }else if (boot_mtd == "sign"){
  #       W = sample(
  #         c(-1, 1),
  #         prob = c( 1/2, 1/2 ),
  #         replace = T, size = n1)
  #     }else if (boot_mtd == "naive"){
  #       W_mat = rmultinom(1,n1, rep(1/n1,n1)) / 10
  #       W = c(W_mat)
  #     }
  #     T_star[b] = sum(resids * W)
  #   }
  #   return(T_star)
  # }

#' Create a bootstrap function factory for residual resampling
#'
#' @description
#' Creates a specialized bootstrap function for resampling residuals using various methods.
#' The factory pattern allows creation of method-specific bootstrapping functions that can
#' be reused efficiently.
#'
#' @param boot_mtd The bootstrap method to use. Must be one of:
#'   \itemize{
#'     \item "Bayesian" - Uses Dirichlet distribution for weights
#'     \item "wild" - Uses wild bootstrap with Mammen weights
#'     \item "sign" - Uses random sign flipping
#'     \item "naive" - Uses naive residual resampling
#'   }
#' @param use_moving_block Logical flag to determine if Moving Block Bootstrap should be applied.
#'
#' @return A function that performs the specified bootstrap resampling with parameters:
#'   \itemize{
#'     \item resids - Numeric vector of residuals to bootstrap
#'     \item B - Number of bootstrap iterations
#'     \item block_size - Size of blocks for moving block bootstrap (required if use_moving_block is TRUE)
#'     \item seed_addition - Value added to base seed for reproducibility (default: 123)
#'   }
#'
#' @examples
#' # Create bootstrap functions for different methods
#' bayesian_boot <- make_bootstrap("Bayesian")
#'
#' # Generate some example residuals
#' resids <- rnorm(100)
#'
#' # Perform bootstrap with Moving Block Bootstrap enabled
#' mbb_results <- make_bootstrap("Bayesian", use_moving_block = TRUE)(resids, B = 1000, block_size = 5)
#' @noRd

make_bootstrap <- function(boot_mtd, use_moving_block = FALSE) {
  force(boot_mtd) # Ensure evaluation

  # Define the sampling function based on method
  sampler <- switch(boot_mtd,
                    "Bayesian" = function(n) {
                      gtools::rdirichlet(1, alpha = rep(1, n))
                    },
                    "wild" = function(n) {
                      sample(
                        c(-(sqrt(5)-1)/2, (sqrt(5)+1)/2),
                        prob = c((sqrt(5)+1)/(2*sqrt(5)), (sqrt(5)-1)/(2*sqrt(5))),
                        replace = TRUE,
                        size = n
                      ) / n
                    },
                    "sign" = function(n) {
                      sample(
                        c(-1, 1),
                        prob = c(1/2, 1/2),
                        replace = TRUE,
                        size = n
                      )
                    },
                    "naive" = function(n) {
                      W_mat <- rmultinom(1, n, rep(1/n, n)) / n
                      c(W_mat)
                    },
                    stop("Unknown bootstrap method:", boot_mtd)
  )

  # Returns a bootstrap resampling function with parameters:
  #   resids        - numeric vector of residuals to bootstrap
  #   B             - number of bootstrap iterations
  #   block_size    - block size for moving block bootstrap (required if
  #                   use_moving_block is TRUE)
  #   seed_addition - value added to base seed for reproducibility
  # Returns a numeric vector of length B containing bootstrap statistics.
  function(resids, B, block_size = NULL, seed_addition = 123) {
    n1 <- length(resids)
    T_star <- numeric(B)

    for(b in 1:B) {
      set.seed(123 + seed_addition + b*13)

      if (use_moving_block) {
        if (is.null(block_size)) stop("block_size must be specified when use_moving_block is TRUE")
        num_blocks <- ceiling(n1 / block_size) # number of block to sample for eahc
        indices <- sample(1:(n1 - block_size + 1), size = num_blocks, replace = TRUE)
        bootstrapped_sample <- unlist(lapply(indices, function(i) resids[i:(i + block_size - 1)]))[1:n1]
        sample_length <- length(bootstrapped_sample)
        W <- sampler(sample_length)
        T_star[b] <- sum(bootstrapped_sample * W)
      } else {
        W <- sampler(n1)
        T_star[b] <- sum(resids * W)
      }
    }

    T_star
  }
}

#' Create a bootstrap confidence interval calculator factory
#'
#' @description
#' Creates a specialized function for computing confidence intervals and standard errors
#' from bootstrap samples using various resampling methods.
#'
#' @param boot_mtd The bootstrap method to use. Must be one of:
#'   \itemize{
#'     \item "Bayesian" - Uses Dirichlet distribution for weights
#'     \item "wild" - Uses wild bootstrap with Mammen weights
#'     \item "naive" - Uses naive residual resampling
#'   }
#' @param use_moving_block Logical flag to determine if Moving Block Bootstrap should be applied.
#'
#' @return A function that computes confidence intervals and standard errors with parameters:
#'   \itemize{
#'     \item resids - Numeric vector of residuals to bootstrap
#'     \item mean_est - Point estimate (typically mean) around which to construct intervals
#'     \item B - Number of bootstrap iterations
#'     \item block_size - Size of blocks for moving block bootstrap (only required if use_moving_block is TRUE)
#'     \item seed_addition - Value added to base seed for reproducibility (default: 123)
#'   }
#'
#' @return A list containing:
#'   \itemize{
#'     \item ci_lower - Lower bound of confidence interval
#'     \item ci_upper - Upper bound of confidence interval
#'     \item sd - Bootstrap standard error
#'   }
#'
#' @examples
#' # Create bootstrap CI calculator
#' bayesian_ci <- make_bootstrap_ci("Bayesian", use_moving_block = TRUE)
#'
#' # Generate example data
#' resids <- rnorm(100)
#' mean_est <- mean(resids)
#'
#' # Calculate CIs and SE
#' results <- bayesian_ci(resids, mean_est, B = 1000, block_size = 5)
#' print(c(results$ci_lower, results$ci_upper, results$sd))
#' @noRd

make_bootstrap_ci <- function(boot_mtd, use_moving_block = FALSE) {
  # First create the base bootstrap sampler
  bootstrap_sampler <- make_bootstrap(boot_mtd, use_moving_block)

  # Returns a bootstrap confidence-interval calculator with parameters:
  #   resids        - numeric vector of residuals to bootstrap
  #   mean_est      - point estimate around which to construct intervals
  #   B             - number of bootstrap iterations
  #   block_size    - block size for moving block bootstrap (required if
  #                   use_moving_block is TRUE)
  #   seed_addition - value added to base seed for reproducibility
  # Returns a list containing ci_lower, ci_upper, and sd.
  function(resids, mean_est, B, block_size = NULL, seed_addition = 123) {
    # Validate input
    if (!is.numeric(resids) || !is.numeric(mean_est) || !is.numeric(B)) {
      stop("All inputs must be numeric")
    }

    # Generate bootstrap samples
    T_star <- bootstrap_sampler(resids, B, block_size, seed_addition)

    # Calculate confidence intervals and standard error
    list(
      ci_lower = mean_est - quantile(T_star, 0.975),
      ci_upper = mean_est - quantile(T_star, 0.025),
      sd = sd(T_star)
    )
  }
}



#' Estimate the variance from the bootstrap
#'
#' This is the main bootstrap function.
#'
#' @param matches_table The data frame of the matched table, or a
#'   csm_matches object (converted internally via
#'   \code{\link{result_table}()}).
#' @param outcome Name of the outcome variable (default "Y")
#' @param treatment Name of the treatment variable (default "Z")
#' @param B Number of bootstrap resamples (default 100).
#' @param boot_mtd Bootstrap resampling method: one of "Bayesian",
#'   "wild", "sign" (default), or "naive".
#'
#' @return A tibble with columns \code{SE_unif_weight} and
#'   \code{SE_SCM_weight}, the bootstrap standard errors of the ATT
#'   under uniform (CEM-style) and CSM synthetic-control weighting,
#'   respectively.
#'
#' @examples
#' set.seed(4044440)
#' dat <- gen_one_toy(nt = 20)
#' mtch <- get_cal_matches(dat,
#'                         metric = "maximum",
#'                         scaling = c(1/0.2, 1/0.2),
#'                         caliper = 1,
#'                         rad_method = "adaptive",
#'                         est_method = "csm")
#' boot_SE(mtch, B = 50)
#'
#' @export
boot_SE <- function(
    matches_table,
    outcome = "Y",
    treatment = "Z",
    B = 100,
    boot_mtd = "sign"){

  if ( is.csm_matches(matches_table) ) {
    matches_table <- result_table(matches_table)
  }

  # Step 1: give uniform weight
  # get_att_point_est(matches_table, outcome = "Y")
  nrow(matches_table %>% filter(Z==0) %>% distinct(id))
  matches_table_weights <-
    matches_table %>%
    group_by(subclass) %>%
    mutate(n_c = n() - 1,  # Number of control units (Z == 0) in the subclass
           weights_unif = ifelse(Z == 1, 1, 1 / n_c)) %>%
    ungroup() %>%
    rename(weights_SCM = "weights")

  # Step 2: get residuals
  ATT_residuals <-
    matches_table_weights %>%
    group_by(subclass) %>%
    summarise(
      Y_Z1 = Y[Z == 1],  # Extract Y for the Z == 1 data
      uniform_weighted_sum_Y_Z0 = sum(Y[Z == 0] * weights_unif[Z == 0]),
      SCM_weighted_sum_Y_Z0 = sum(Y[Z == 0] * weights_SCM[Z == 0])
    ) %>%
    mutate(
      residual_unif = Y_Z1 - uniform_weighted_sum_Y_Z0,
      residual_SCM = Y_Z1 - SCM_weighted_sum_Y_Z0,
      )

  # Step 3: bootstrap residuals.
  resample <- make_bootstrap(boot_mtd)

  booted_unif_weight <- resample(
    resids = ATT_residuals$residual_unif,
    B = B
  )

  booted_SCM_weight <- resample(
    resids = ATT_residuals$residual_SCM,
    B = B
  )

  return(tibble(
    SE_unif_weight = sd(booted_unif_weight),
    SE_SCM_weight = sd(booted_SCM_weight)
  ))
}
