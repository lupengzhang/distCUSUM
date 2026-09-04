#' Distance-Based CUSUM Change Point Statistic
#'
#' Computes the DCCP statistic over all candidate change point locations
#' without a permutation test.
#'
#' @param data A numeric matrix or data frame with observations in rows and
#' variables in columns.
#' @param Fun_DCCP A function used to calculate pairwise distances. The default
#' is \code{M.L1norm}. To use the modified L2 norm, set
#' \code{Fun_DCCP = dist}.
#'
#' @return A list containing the estimated change point, test statistic,
#' distance matrix and CUSUM matrix.
#' @export
DCCP <- function(data, Fun_DCCP = M.L1norm) {
n <- nrow(data)
p <- ncol(data)
D <- as.matrix(Fun_DCCP(data))
if (identical(Fun_DCCP, dist)) {
D <- D / sqrt(p)
}
C <- matrix(0, nrow = n, ncol = n - 1)
for (i in 1:n) {
R <- D[i, ]
c <- numeric(n - 1)
for (k in 1:(n - 1)) {
c[k] <- sqrt(length(R[1:k]) * length(R[-(1:k)])) / n *
(mean(R[-(1:k)]) - mean(R[1:k]))
}
C[i, ] <- c
}
changepoint <- which.max(colSums(C^2))
test.statistic <- (1 / n) * colSums(C^2)[changepoint]
list_all <- list(
"changepoint" = changepoint,
"test.statistic" = test.statistic,
"Distance matrix" = D,
"CUSUM matrix" = C
)
return(list_all)
}

