#' Check if a total causal effect is identified
#'
#' The total causal effect from x to y is identified if and only if there is
#' no possibly causal path from x to y that starts with an undirected edge.
#'
#' @param amat adjacency matrix. See \code{\link{estimateEffect}}
#'   for its coding.
#' @param x (integer) positions of treatment variables in the adjacency matrix
#' @param y (integer) positions of outcome variables in the adjacency matrix
#' @param type string specifying the type of graph of \code{amat}. It can be
#'   DAG (\code{type='dag'}) or MPDAG/CPDAG (\code{type='pdag'}).
#' @return \code{TRUE} if identified, \code{FALSE} if not.
#' @seealso \code{\link{estimateEffect}}
#' @export
#' @references
#' Emilija Perkovic. Identifying causal effects in maximally oriented
#' partially directed acyclic graphs.
#' In \emph{Uncertainty in Artificial Intelligence (UAI)}, 2020.
#' @examples
#' data("ex1")
#' # identified
#' isIdentified(ex1$amat.cpdag, c(3, 5), 7)
#' # not identified
#' isIdentified(ex1$amat.cpdag, 3, 7)
#' isIdentified(ex1$amat.cpdag, c(3, 5), 10)
isIdentified <- function(amat, x, y, type = "pdag") {
  m <- amat
  found <- FALSE
  stopifnot(`invalid graph type` = (type %in% c("pdag", "dag")))
  if (type == "dag") {
    return(!found)
  }
  i <- 0
  p <- length(x)
  while ((i < p) & !found) {
    i <- i + 1
    posDesc <- getPossDe(amat, x = x[i], y = x[-i])
    if (length(intersect(y, posDesc)) != 0) {
      nb <- as.vector(which(m[x[i], ] != 0 & m[, x[i]] != 0))
      cand <- intersect(nb, posDesc)
      j <- 0
      while ((j < length(cand)) & !found) {
        j <- j + 1
        newy <- union(x, intersect(which(m[, x[i]] == 0), which(m[x[i], ] != 0)))
        pdpTemp <- getPossDe(amat, x = cand[j], y = newy)
        pathOK <- (length(intersect(y, pdpTemp)) != 0)
        if (pathOK) {
          isPDAG <- (type == "pdag")
          PDAGproblem <- (isPDAG & (m[x[i], cand[j]] == 1))
          PAGproblem1 <- (!isPDAG & (m[x[i], cand[j]] != 2) & (m[cand[j], x[i]] != 3))
          isDirEdge <- ((m[x[i], cand[j]] == 2) & (m[cand[j], x[i]] == 3))
          PAGproblem2 <- (!isPDAG & isDirEdge & !pcalg::visibleEdge(m, x[i], cand[j]))
          found <- (PDAGproblem | PAGproblem1 | PAGproblem2)

        }
      }
    }
  }
  return(!found)
}
