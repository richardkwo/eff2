# eff² <img src="docs/eff2-logo.png" align="right" width="165px"/>
**Efficient Least Squares for Estimating Total Causal Effects**

`eff2` is an `R` package for estimating a total causal effect from observational data under linearity and causal sufficiency (no unobserved confounding, no selection bias). It can consistently estimate any identified effect, including single and multiple treatment variables. Moreover, the resulting estimate has the minimal asymptotic covariance (and hence shortest confidence intervals) among all estimators that are based on the sample second moment.

## Installation

From CRAN:

```R
install.packages("eff2")
```

Alternatively, the package can be installed from GitHub.

``` r
# install.packages("devtools")
# install.packages("rmarkdown")
# install.packages("qgraph")
devtools::install_github("richardkwo/eff2", build_vignettes = TRUE)
```

In case of problem, first make sure dependency [pcalg](https://cran.r-project.org/package=pcalg) is properly installed. Several packages required by `pcalg` are removed from CRAN and have to be installed from BioConductor:

```R
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
BiocManager::install("graph")
BiocManager::install("RBGL")
```

For a quick start, check out the vignette:

```R
vignette("eff2-doc")
```

## Reference

Guo, F. Richard, and Emilija Perković. "Efficient Least Squares for Estimating Total Effects under Linearity and Causal Sufficiency." *[arXiv preprint arXiv:2008.03481](https://arxiv.org/abs/2008.03481)* (2020).