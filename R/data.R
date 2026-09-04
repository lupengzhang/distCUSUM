#' Standardized S&P500 Stock Prices
#'
#' Standardized daily closing prices for 496 S&P500 companies over 108 trading
#' days from 1 January 2020 to 29 May 2020. The same source data are also used
#' and available in the \code{HDDchangepoint} package.
#'
#' @format A numeric matrix with 108 rows and 496 columns.
#' @source Yahoo Finance, obtained using the \code{BatchGetSymbols} package.
#' @references Zhang, L. and Drikvandi, R. (2025). Distance-based CUSUM
#'   statistics for high dimensional change points. Statistics and Computing,
#'   35, Article 215. \doi{10.1007/s11222-025-10752-1}.
#' @name SP500data
NULL

#' MIT Cellphone Activity Data
#'
#' Daily pairwise cellphone activities for 96 participants from 15 September
#' 2004 to 4 May 2005. Each of the 4,560 columns represents one unique pair of
#' participants and each row represents one of 232 days.
#'
#' @format A numeric matrix with 232 rows and 4,560 columns.
#' @source MIT Reality Mining project.
#' @references Eagle, N. and Pentland, A. (2006). Reality mining: sensing
#'   complex social systems. Personal and Ubiquitous Computing, 10, 255-268.
#' @name MITcellphone
NULL

