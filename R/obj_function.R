obj_function <- function(pars,
                         data,
                         weights){
  days <- seq_along(data$date)
  data$pred_d1 <- d1f(days, pars)
  data$pred_d2 <- d2f(days, pars)
  data$pred_cum <- d0f(days, pars)

  ssq = weights[1]*mean((data$cum_cases - data$pred_cum)^2) +
    weights[2]* mean((data$pred_d1 - data$num_cases)^2) +
    weights[3]*mean((data$pred_d2 - data$d2)^2)
  ssq
}
