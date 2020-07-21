# total effects (multivariate x means joint intervention) -------
getEffectsFromSEM <- function(B, x, y) {
  amat <- B
  amat[amat != 0] <- 1
  stopifnot(pcalg::isValidGraph(amat, type = "dag"))
  # joint intervention
  B <- t(B)
  B[, x] <- 0
  size <- nrow(B)
  effect.est <- solve(diag(size) - B)[x, y]
  if (length(x) == 1 || length(y) == 1) {
    effect.est <- c(effect.est)
  }
  return(effect.est)
}

# bucket decomposition -------
getBucketDecomp <- function(x, y, amat) {
  stopifnot(pcalg::isValidGraph(amat, type = "pdag"))
  # get undirected graph
  amat.un <- (amat + t(amat))/2
  amat.un[amat.un == 0.5] <- 0
  U <- igraph::graph.adjacency(amat.un, mode = "undirected")
  U <- igraph::as_graphnel(U)
  connected.comps <- RBGL::connectedComp(U)
  # get ancestors of y in the subgraph where x is removed
  amat.x.removed <- amat
  amat.x.removed[x, ] <- 0
  amat.x.removed[, x] <- 0
  an.y <- getPossAn(amat.x.removed, y)
  # get induced bucket partitioning of an.y
  induced.buckets <- lapply(connected.comps, function(C) intersect(C, an.y))
  induced.buckets <- induced.buckets[lapply(induced.buckets, length) > 0]
  return(induced.buckets)
}

# check the restrictive property of a bucket decomposition
isValidBucketDecomp <- function(buckets, amat) {
  stopifnot(pcalg::isValidGraph(amat, type = "pdag"))
  for (i in 1:length(buckets)) {
    b <- buckets[[i]]
    p <- getParents(amat, b)
    for (x in b) {
      pa.x <- setdiff(getParents(amat, x), b)  # Pa(x) \ b
      if (!setequal(p, pa.x)) {
        return(FALSE)
      }
    }
  }
  return(TRUE)
}

# iterated least squares ------
.estimateEffect <- function(.cov, x, y, amat) {
  stopifnot(length(y) == 1)
  if (!isIdentified(amat, x, y, type = "pdag")) {
    stop("Effect not identifiable!")
  }
  # bucket decomposition
  buckets <- getBucketDecomp(x, y, amat)
  nodes.D <- unname(unlist(buckets))
  stopifnot(isValidBucketDecomp(buckets, amat))
  # iterated regressions
  size <- nrow(amat)
  Lambda <- matrix(rep(0, size^2), nrow = size)
  for (i in 1:length(buckets)) {
    # iterated over buckets
    b <- buckets[[i]]
    p <- getParents(amat, b)
    if (length(p) > 0) {
      # least-squares
      Lambda[p, b] <- solve(.cov[p, p]) %*% .cov[p, b]
    }
  }
  # finally get the causal effects
  effect.est <- (Lambda[x, nodes.D] %*% solve(diag(length(nodes.D)) -
                                Lambda[nodes.D, nodes.D]))[, match(y, nodes.D)]
  if (is.matrix(effect.est)) {
    row.names(effect.est) <- as.character(x)
    colnames(effect.est) <- as.character(y)
  }
  if (length(x) == 1) {
    effect.est <- c(effect.est)
    names(effect.est) <- as.character(y)
  } else if (length(y) == 1) {
    effect.est <- c(effect.est)
    names(effect.est) <- as.character(x)
  }
  return(effect.est)
}

#' Estimate the total causal effect
#'
#' Estimate the total causal effect of x on y with iterated least squares.
#' The resulting estimate has the minimal asymptotic covariance among all least
#' squares estimators.
#'
#' Adjacency matrix \code{amat} represents the graphical information of the
#' underlying causal DAG (directed acyclic graph). The causal DAG should be
#' contained by the graph represented by \code{amat}, which can be a DAG, CPDAG
#' (essential graph), or more generally, an MPDAG (maximally oriented partially
#' directed acyclic graph).
#'
#' Matrix \code{amat} is coded with the convention of \code{\link[pcalg]{amatType}}:
#' \itemize{
#'   \item \code{amat[i,j]=0} and \code{amat[j,i]=1} means \code{i->j}
#'   \item \code{amat[i,j]=1} and \code{amat[j,i]=0} means \code{i<-j}
#'   \item \code{amat[i,j]=1} and \code{amat[j,i]=1} means \code{i--j}
#'   \item \code{amat[i,j]=0} and \code{amat[j,i]=0} means \code{i  j}
#' }
#'
#' \code{amat} can be learned from observational data with a structure learning
#' algorithm; see \code{\link[pcalg]{pc}}, \code{\link[pcalg]{ges}}
#' and \code{\link[pcalg]{LINGAM}}. Additional background knowledge can also be
#' incorporated with \code{\link[pcalg]{addBgKnowledge}}.
#'
#' @param data a data frame consisting of iid observational data
#' @param x (integer) positions of treatment variables in the adjacency matrix;
#'   can be a singleton (single treatment) or a vector (multiple treatments)
#' @param y (integer) position of the outcome variable in the adjacency matrix
#' @param amat adjacency matrix representing a DAG, CPDAG or MPDAG
#' @param bootstrap If \code{TRUE}, will estimate the asymptotic covariance with
#'  bootstrap (default: \code{FALSE})
#' @export
#' @return A vector of the same length as \code{x}. If \code{bootstrap=TRUE},
#'  return a list of \code{(effect, asymp.cov)}.
#' @seealso \code{\link{isIdentified}} is called for determining if an effect can be
#' identified. See also \code{\link[pcalg]{adjustment}}, \code{\link[pcalg]{ida}},
#'  and \code{\link[pcalg]{jointIda}} for other estimators.
#' @examples
#' data("ex1")
#' result <- estimateEffect(ex1$data, c(5,3), 7, ex1$amat.cpdag, bootstrap=TRUE)
#' print(result$effect)
#' print(result$effect - 1.64 * sqrt(diag(result$asymp.cov)))
#' print(result$effect + 1.64 * sqrt(diag(result$asymp.cov)))
#' # compare with truth
#' print(ex1$true.effects)
#'
#' \dontrun{
#' # throws an error because the effect is not identified
#' estimateEffect(ex1$data, 3, 7, ex1$amat.cpdag)
#' }
estimateEffect <- function(data, x, y, amat, bootstrap=FALSE) {
  if (!isIdentified(amat, x, y, type="pdag")) {
    stop("Effect is not identified!")
  }
  if (!bootstrap) {
    return(.estimateEffect(stats::cov(data), x, y, amat))
  } else {
    effect <- .estimateEffect(stats::cov(data), x, y, amat)
    n <- nrow(data)
    bootstrap.df <- replicate(400, {
      .estimateEffect(stats::cov(data[sample(n, replace = TRUE), ]), x, y, amat)
    })
    return(list(effect=effect, asymp.cov=stats::cov(t(bootstrap.df))))
  }
}
