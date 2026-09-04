#' Detect a Single Change Point
#'
#' Estimates a single change point and assesses its significance using a
#' permutation test.
#'
#' @param data A numeric matrix or data frame with observations in rows and
#'   variables in columns.
#' @param FUN_single_changepoint A function used to calculate pairwise
#'   distances. To use the modified L2 distance, set
#'   `FUN_single_changepoint = dist`.
#' @param nperm Number of permutations.
#' @param sig.lvl Significance level.
#'
#' @return A list containing the detected change point and permutation p-value.
#' @export
DCCP_single_changepoint <- function(data,
                                    FUN_single_changepoint = M.L1norm,
                                    nperm = 200,
                                    sig.lvl = 0.05) {
  if (!is.matrix(data) && !is.data.frame(data)) {
    stop("Input must be a matrix or data frame for multivariate data.")
  }
  if (ncol(data) <= 1) {
    stop("Data must have more than one column for multivariate change point detection.")
  }
  n <- nrow(data)
  p <- ncol(data)
  D <- as.matrix(FUN_single_changepoint(data))
  if (identical(FUN_single_changepoint, dist)) {
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

  permuted_test.statistics <- numeric(nperm)
  for (i in 1:nperm) {
    index <- 1:n
    perm_before <- index[1:(changepoint - 1)]
    perm_after <- index[(changepoint + 1):n]
    index <- c(perm_before, perm_after)
    permuted_index <- sample(index)
    permuted_data <- data[permuted_index, ]
    permuted_test.statistics[i] <- DCCP(
      data = permuted_data,
      Fun_DCCP = FUN_single_changepoint
    )$test.statistic
  }
  pvalue_numeric <- sum(permuted_test.statistics > test.statistic) / nperm
  pvalue_report <- if (pvalue_numeric < 0.01) "<0.01" else pvalue_numeric
  significance <- ifelse(
    pvalue_numeric < sig.lvl,
    "significant",
    "non-significant"
  )
  if (significance == "non-significant") {
    return(list(changepoint = NA, pvalue = pvalue_report))
  }
  return(list(changepoint = changepoint, pvalue = pvalue_report))
}
