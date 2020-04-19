#' Title
#'
#' @param data
#' @param useData
#'
#' @return
#' @import ggplot2
#' @export
#'
#' @examples
visu <- function(data, useData = TRUE){
  if(useData)
    days <- data$date
  else
    days <- seq_along(data$date)
  data = data.frame( data = rep(days,times=3),
                     var = factor(rep(c("Cumulative (d0)",
                                 "Confirmed (d1)",
                                 "Diff. Conf. (d2)"), each=length(days)),
                                 levels=c("Cumulative (d0)",
                                 "Confirmed (d1)",
                                 "Diff. Conf. (d2)")),
                     observed = c(data$cum_cases,data$num_cases,data$d2))
  data %>%
    ggplot(aes(data,observed))+
    geom_point()+
    facet_grid(var~., scales="free_y")
}

#' Title
#'
#' @param optObj
#' @param n_fut
#'
#' @return
#' @import ggplot2
#' @export
#'
#' @examples
future <- function(optObj, n_fut=30){
  dd_pred = optObj[["pred"]]
  dd_pred[["days"]] = rep(seq_along(unique(dd_pred[["date"]])),3)

  future = n_fut
  daysfut = seq(from=max(dd_pred[["days"]])+1,
                 to=max(dd_pred[["days"]])+future)
  dd_append = data.frame(date = rep(rep(dd_pred[["date"]][1],future),3), ## inicializando
                         var = rep(unique(dd_pred[["var"]]),each=future),
                         observed = NA,
                         estimated = c(d0f(daysfut, optObj[["pars"]]),
                                      d1f(daysfut, optObj[["pars"]]),
                                      d2f(daysfut, optObj[["pars"]])
                         ),
                         days = rep(daysfut,3))
  dd_append[["date"]] =  max(optObj$pred$date)+seq_along(daysfut)
  dd_pred[["Data"]] = "Observado"
  dd_append[["Data"]] = "Predito"
  pred_br = rbind(dd_pred,dd_append)
  pred_br %>%
    as.data.frame() %>%
    ggplot(aes(date,observed,col=Data)) +
    geom_point(alpha=.3) +
    geom_line(aes(y=estimated)) +
    facet_grid(var~., scales="free_y")
}
