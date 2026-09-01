
# helpful utility functions

# NB: used via CSMatch:::invlogit() in scripts/lib/wrappers.R -- keep
# even though nothing inside the package itself calls it.
invlogit <- function(x) {
  exp(x) / (1+exp(x))
}

get_x_vars <- function(df) {
  names(df) %>%
    grep("^X", ., value = TRUE)
}
