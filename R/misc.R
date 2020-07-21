# matrix of NA's -----
get.matrix.NAs <- function(x, y) {
  effect.est <- matrix(rep(NA, length(x) * length(y)), nrow = length(x))
  row.names(effect.est) <- as.character(x)
  colnames(effect.est) <- as.character(y)
  if (length(x) == 1) {
    effect.est <- c(effect.est)
    names(effect.est) <- as.character(y)
  } else if (length(y) == 1) {
    effect.est <- c(effect.est)
    names(effect.est) <- as.character(x)
  }
  return(effect.est)
}


