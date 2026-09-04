#' Detect Multiple Change Points
#'
#' Applies the single-change-point procedure using recursive binary
#' segmentation.
#'
#' @param data A numeric matrix or data frame with observations in rows and
#'   variables in columns.
#' @param FUN_multiple_changepoints A function used to calculate pairwise
#'   distances. To use the modified L2 distance, set
#'   `FUN_multiple_changepoints = dist`.
#' @param minsegment Minimum segment length.
#' @param nperm Number of permutations.
#' @param sig.lvl Significance level.
#'
#' @return A sorted vector of significant change-point locations, or `NA`.
#' @export
DCCP_multiple_changepoints <- function(data,
                                       FUN_multiple_changepoints = M.L1norm,
                                       minsegment = 10,
                                       nperm = 200,
                                       sig.lvl = 0.05) {
  if (!is.matrix(data) && !is.data.frame(data)) {
    stop("Input must be a matrix or data frame for multivariate data.")
  }
  if (ncol(data) <= 1) {
    stop("Data must have more than one column for multivariate change point detection.")
  }
  changepoint_all <- NA
  length_data <- nrow(as.matrix(rbind(data, data))) / 2
  while (length_data > minsegment) {
    changepoint_test <- DCCP_single_changepoint(
      data = data,
      FUN_single_changepoint = FUN_multiple_changepoints,
      nperm = nperm,
      sig.lvl = sig.lvl
    )
    changepoint <- changepoint_test$changepoint
    changepoint_pvalue <- changepoint_test$pvalue
    if (is.character(changepoint_pvalue)) {
      if (grepl("^<", changepoint_pvalue)) {
        changepoint_pvalue <- as.numeric(sub("^<", "", changepoint_pvalue)) * 0.999
      } else {
        changepoint_pvalue <- as.numeric(changepoint_pvalue)
      }
    }
    end <- nrow(data)
    if (!is.na(changepoint) && changepoint_pvalue <= sig.lvl &
        changepoint > 2 & changepoint < end - 2) {
      data_before <- data[1:changepoint, ]
      data_after <- data[(changepoint + 1):end, ]
      changepoint_before <- DCCP_multiple_changepoints(
        data = data_before,
        FUN_multiple_changepoints = FUN_multiple_changepoints,
        minsegment = minsegment,
        nperm = nperm,
        sig.lvl = sig.lvl
      )
      changepoint_after <- DCCP_multiple_changepoints(
        data = data_after,
        FUN_multiple_changepoints = FUN_multiple_changepoints,
        minsegment = minsegment,
        nperm = nperm,
        sig.lvl = sig.lvl
      ) + changepoint
      changepoint_all <- c(
        changepoint,
        changepoint_before,
        changepoint_after
      )
      return(sort(changepoint_all[!is.na(changepoint_all)]))
    } else {
      return(NA)
    }
  }
  return(sort(changepoint_all[!is.na(changepoint_all)]))
}

