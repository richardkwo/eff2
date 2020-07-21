#' An example of 10 variables simulated from a linear SEM
#'
#'
#' @format A list containing:
#' \describe{
#'   \item{x}{treatment variables}
#'   \item{y}{outcome variable}
#'   \item{true.effects}{the true total effect of x on y}
#'   \item{B}{the coefficient matrix of the SEM}
#'   \item{amat.dag}{the adjacency matrix of the causal DAG}
#'   \item{amat.cpdag}{the adjacency matrix of the CPDAG of the causal DAG,
#'     representing the Markov equivalence class of the DAG.}
#'   \item{data}{500 iid samples generated under student-t errors}
#' }
"ex1"
