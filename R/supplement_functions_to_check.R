
# This has some functions that are possibly no longer valid



# bootstrap the covariates
boot_bayesian_covs <- function(d, covs, B=100) {

  stop( "Bayesian covariate boostrap no longer valid choice." )

  map_dfr(1:B,
          .progress = "Bootstrapping...",
          function(b) {
            d %>%
              mutate(weights = weights *
                       as.numeric(gtools::rdirichlet(1, alpha=rep(1,nrow(d)))) *
                       nrow(d)) %>%
              group_by(Z) %>%
              summarize(across(all_of(covs),
                               ~sum(.*weights) / sum(weights))) %>%
              summarize(across(all_of(covs),
                               ~last(.) - first(.)))
          })
}


#' Run a Bayesian bootstrap
#'
#' @param d dataset with weights for each tx/co unit
#' @param B number of bootstrap samples
#'
#' @return vector of bootstrapped ATT estimates
#'
#' @noRd
boot_bayesian <- function(d, B=100) {
  map_dbl(1:B,
          .progress = "Bootstrapping...",
          function(b) {
            d %>%
              mutate(weights = weights *
                       as.numeric(gtools::rdirichlet(1, alpha=rep(1,nrow(d))))) %>%
              # rdirichlet(alpha=rep(1,nrow(d)))) %>%
              get_att_point_est()
          })
}
