% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{ex1}
\alias{ex1}
\title{An example of 10 variables simulated from a linear SEM}
\format{
A list containing:
\describe{
\item{x}{treatment variables}
\item{y}{outcome variable}
\item{true.effects}{the true total effect of x on y}
\item{B}{the coefficient matrix of the SEM}
\item{amat.dag}{the adjacency matrix of the causal DAG}
\item{amat.cpdag}{the adjacency matrix of the CPDAG of the causal DAG,
representing the Markov equivalence class of the DAG.}
\item{data}{500 iid samples generated under student-t errors}
}
}
\usage{
ex1
}
\description{
An example of 10 variables simulated from a linear SEM
}
\keyword{datasets}
