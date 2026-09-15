This R package is for the following published paper:

Zhang L. and Drikvandi R. (2025). "Distance-based CUSUM statistics for high dimensional change points". Statistics and Computing, 35(6), 215. https://doi.org/10.1007/s11222-025-10752-1

You can install this R package using the following two commands in R:

    library(devtools)

    install_github("lupengzhang/distCUSUM")

and then load it using:

    library(distCUSUM)

Details about this package can be found in the DESCRIPTION file. The main R function of the package is called "DCCP_multiple_changepoints", which can be applied for detecting multiple change points in high dimensional data using the distance-based CUSUM method presented in the paper. If there is only a single change point, the function "DCCP_single_changepoint" can be used. Both functions use the modified L1 norm by default. Users can specify another relevant distance function through the corresponding distance-function argument. For example, to use the modified L2 norm, set "FUN_single_changepoint=dist" in the function "DCCP_single_changepoint", or set "FUN_multiple_changepoints=dist" in the function "DCCP_multiple_changepoints".

Simulation examples:

### Single change point example

The data are simulated with n = 100 and p = 500, with a change in the mean after observation 60. The variables follow an AR(1) correlation structure with rho = 0.5.

    library(distCUSUM)
    library(MASS)

    n <- 100
    p <- 500
    mu <- 0.3
    s <- 0.75

    set.seed(123)
    Deltamu <- sample(c(rep(0, (1-s)*p), rep(mu, s*p)))
    rho <- 0.5
    cov_matrix <- matrix(0, nrow=p, ncol=p)
    for (i in 1:p) {
      for (j in 1:p) {
        cov_matrix[i,j] <- rho^abs(i-j)
      }
    }

    set.seed(123)
    Obs_before <- mvrnorm(0.6*n, mu=rep(0,p), Sigma=cov_matrix)
    Obs_after <- mvrnorm(0.4*n, mu=Deltamu, Sigma=cov_matrix)
    Obs <- rbind(Obs_before, Obs_after)
    DCCP_single_changepoint(Obs)

The output is:

    $changepoint
    [1] 61

    $pvalue
    [1] "<0.01"

### Multiple change points example

The data are simulated with n = 100 and p = 500, with changes in the mean after observations 20, 60, and 80. The variables follow an AR(1) correlation structure with rho = 0.5.

    library(distCUSUM)
    library(MASS)

    n <- 100
    p <- 500
    mu <- 0.3
    s <- 0.75

    set.seed(123)
    Deltamu <- sample(c(rep(0, (1-s)*p), rep(mu, s*p)))
    rho <- 0.5
    cov_matrix <- matrix(0, nrow=p, ncol=p)
    for (i in 1:p) {
      for (j in 1:p) {
        cov_matrix[i,j] <- rho^abs(i-j)
      }
    }

    set.seed(123)
    Obs_1 <- mvrnorm(0.2*n, mu=rep(0,p), Sigma=cov_matrix)
    Obs_2 <- mvrnorm(0.4*n, mu=Deltamu, Sigma=cov_matrix)
    Obs_3 <- mvrnorm(0.2*n, mu=2*Deltamu, Sigma=cov_matrix)
    Obs_4 <- mvrnorm(0.2*n, mu=3*Deltamu, Sigma=cov_matrix)
    Obs <- rbind(Obs_1, Obs_2, Obs_3, Obs_4)
    DCCP_multiple_changepoints(Obs)

The output is:

    [1] 21 61 81

Note that our algorithm reports the first observation after a change as the change point. Some papers use the last observation before the change, which would be 20, 60, and 80 in the multiple change point example above. Please check the indexing when running simulations or comparing results.

### Real data examples

The S&P500 and MIT cellphone data used in the paper are included in the package. The original S&P500 data are also available in "HDDchangepoint". See the data documentation for details.

The default is the modified L1 norm. Set `FUN_multiple_changepoints = dist` to use the modified L2 norm.

#### S&P500

    data("SP500data", package = "distCUSUM")

    # Modified L1 norm
    DCCP_multiple_changepoints(SP500data)

    # Modified L2 norm
    DCCP_multiple_changepoints(SP500data, FUN_multiple_changepoints = dist)

The outputs are, respectively:

    [1] 10 18 27 37 45 49 58 68 72 80 88 99
    [1] 10 15 21 27 37 48 68 80 91 95

#### MIT cellphone

    data("MITcellphone", package = "distCUSUM")

    # Modified L1 norm
    DCCP_multiple_changepoints(MITcellphone)

    # Modified L2 norm
    DCCP_multiple_changepoints(MITcellphone, FUN_multiple_changepoints = dist)

The outputs are, respectively:

    [1] 34 94 101 113 186 214
    [1] 34 95 101 112 179 200 210 214
