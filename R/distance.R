#' Modified L1 Distance Matrix
#'
#' Computes the pairwise Manhattan distance divided by the data dimension.
#'
#' @param data A numeric matrix or data frame with observations in rows and
#' variables in columns.
#'
#' @return A symmetric matrix of pairwise modified L1 distances.
#' @export
M.L1norm <- function(data) {
p <- ncol(data)
L1norm_matrix <- (1 / p) *
as.matrix(stats::dist(data, method = "manhattan"))
return(L1norm_matrix)
}
 
