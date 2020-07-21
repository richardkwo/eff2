#' eff2: efficient least squares for estimating total causal effects
#'
#' Estimate a total causal effect from observational data under
#' linearity and causal sufficiency. The observational data is supposed to be
#' generated from a linear structural equation model (SEM) with independent
#' and additive noise. The underlying causal DAG associated the SEM is required
#' to be known up to a maximally oriented partially directed graph (MPDAG),
#' which is a general class of graphs consisting of both directed and
#' undirected edges, including CPDAGs (i.e., essential graphs) and DAGs. Such
#' graphs are usually obtained with structure learning algorithms with added
#' background knowledge. The program is able to estimate every identified
#' effect, including single and multiple treatment variables. Moreover, the
#' resulting estimate has the minimal asymptotic covariance (and hence
#' shortest confidence intervals) among all estimators that are based on the
#' sample covariance.
#'
#' Use \code{\link{estimateEffect}} to estimate a total effect.
#'
#' Use \code{\link{isIdentified}} to determine if a total effect can be
#'   identified.
#'
#' @docType package
#' @name eff2
NULL
