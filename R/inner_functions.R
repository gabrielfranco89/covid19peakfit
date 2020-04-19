#' Prepare data for model optimization
#'
#' @param data Data frame whihc must contains date information and at least one of cumulative cases or number of cases per date
#' @param cum_cases Character variable: name of cumulative cases column on data
#' @param num_cases Character variable: name of number of cases column on data
#' @param date_var Character variable: name date variable column on data
#'
#' @return A data frame with 4 variables:
#'
#' \enumerate{
#' \item date
#' \item cum_cases
#' \item num_cases
#' \item d2: difference of num_cases between consecutive days}
#' @export
#'
#' @examples
#' prep_korea <- prep_data(data=korea_covid19, cum_cases="cum_cases", date_var="date")
#' str(prep_korea)
prep_data <- function(data,
                      cum_cases = NULL,
                      num_cases = NULL,
                      date_var){
  if(all(is.null(cum_cases),is.null(num_cases)))
    stop("Must have at least num_cases or cum_cases not null")
  dd <- data.frame(date = data[[date_var]])
  n_row = nrow(dd)
  if(is.null(cum_cases)){
    dd$num_cases <- data[[num_cases]]
    dd <- dd[order(dd$date),]
    dd$cum_cases <- cumsum(dd$num_cases)
  }
  if(is.null(num_cases)){
    dd$cum_cases <- data[[cum_cases]]
    dd <- dd[order(dd$date),]
    dd$num_cases <- c(0, diff(dd$cum_cases))
  }
  if(all(!is.null(num_cases), !is.null(cum_cases))){
    dd$cum_cases <- data[[cum_cases]]
    dd$num_cases <- data[[num_cases]]
    dd <- dd[order(dd$date),]
  }
  ## Get d2
  dd$d2 <- c(0,diff(dd$num_cases))
  dd
}

d0f <- function(x, p){
  exp_denom = exp((p[2]-x)/p[3])
  p[1]/(1+exp_denom)
}
d1f = function(x, pars){
  expterm = exp((pars[2]-x)/pars[3])
  num = pars[1]*expterm
  den = pars[3]*((1+expterm)^2)
  num/den
}

d2f = function(x, pars){
  expterm = exp((pars[2]-x)/pars[3])
  num = pars[1]*expterm*(expterm-1)
  den = (pars[3]^2)*((expterm+1)^3)
  num/den
}

d0f <- function(x, pars){
  exp_denom = exp((pars[2]-x)/pars[3])
  pars[1]/(1+exp_denom)
}

d1f = function(x, pars){
  expterm = exp((pars[2]-x)/pars[3])
  num = pars[1]*expterm
  den = pars[3]*((1+expterm)^2)
  num/den
}

d2f = function(x, pars){
  expterm = exp((pars[2]-x)/pars[3])
  num = pars[1]*expterm*(expterm-1)
  den = (pars[3]^2)*((expterm+1)^3)
  num/den
}

