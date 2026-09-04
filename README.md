This R package is for the following published paper:

Zhang L. and Drikvandi R. (2025). "Distance-based CUSUM statistics for high dimensional change points". Statistics and Computing, 35, Article 215. https://doi.org/10.1007/s11222-025-10752-1

You can install this R package using the following two commands in R:

    library(devtools)

    install_github("lupengzhang/distCUSUM")

and then load it using:

    library(distCUSUM)

Details about this package can be found in the DESCRIPTION file. The main R function of the package is called "DCCP_multiple_changepoints", which can be applied for detecting multiple change points in high dimensional data using the distance-based CUSUM method presented in the paper. If there is only a single change point, the function "DCCP_single_changepoint" can be used. Both functions use the modified L1 norm by default. Users can specify another relevant distance function through the corresponding distance-function argument. For example, to use the modified L2 norm, set "FUN_single_changepoint=dist" in the function "DCCP_single_changepoint", or set "FUN_multiple_changepoints=dist" in the function "DCCP_multiple_changepoints".

Two examples:

1. Single change point: the data are simulated with n=100 and p=500, where there is a change in the mean of observations at location 60. The variables follow an AR(1) correlation structure with rho=0.5. Below is the code to generate the data and apply the R package, along with the output:

    library(MASS)
    n <- 100
    p <- 500
    mu <- 0.3
    s <- 0.75
    Deltamu <- sample(c(rep(0,(1-s)*p),rep(mu,s*p)))
    rho <- 0.5
    cov_matrix <- matrix(0,nrow=p,ncol=p)
    for(i in 1:p){
      for(j in 1:p){
        cov_matrix[i,j] <- rho^abs(i-j)
      }
    }
    Obs_before <- mvrnorm(0.6*n,mu=rep(0,p),Sigma=cov_matrix)
    Obs_after <- mvrnorm(0.4*n,mu=Deltamu,Sigma=cov_matrix)
    Obs <- rbind(Obs_before,Obs_after)
    DCCP_single_changepoint(Obs)

The output is:

    $changepoint
    [1] 60

    $pvalue
    [1] "<0.01"

2. Multiple change points: the data are simulated with n=100 and p=500, where there are three changes in the mean of observations at locations 20, 60, and 80. Using the same mean-change vector and covariance matrix defined above, the data are generated and analyzed as follows:

    Obs_1 <- mvrnorm(0.2*n,mu=rep(0,p),Sigma=cov_matrix)
    Obs_2 <- mvrnorm(0.4*n,mu=Deltamu,Sigma=cov_matrix)
    Obs_3 <- mvrnorm(0.2*n,mu=2*Deltamu,Sigma=cov_matrix)
    Obs_4 <- mvrnorm(0.2*n,mu=3*Deltamu,Sigma=cov_matrix)
    Obs <- rbind(Obs_1,Obs_2,Obs_3,Obs_4)
    DCCP_multiple_changepoints(Obs)

The output is:

    [1] 20 60 80

The two real data sets used in the applications, the S&P500 data and the MIT cellphone data, are also included in the package. The original S&P500 data are also available in the R package "HDDchangepoint". See the data documentation for further details.
