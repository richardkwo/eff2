# eff² <img src="docs/eff2-logo.png" align="right" width="165px"/>
**Efficient Least Squares for Estimating Total Causal Effects**

`eff2` is an `R` package for estimating a total causal effect from observational data under linearity and causal sufficiency (no unobserved confounding, no selection bias). It can consistently estimate any identified effect, including single and multiple treatment variables. Moreover, the resulting estimate has the minimal asymptotic covariance (and hence shortest confidence intervals) among all estimators that are based on the sample second moment.

## Installation
``` r
# install.packages("devtools")
devtools::install_github("richardkwo/eff2")
```

