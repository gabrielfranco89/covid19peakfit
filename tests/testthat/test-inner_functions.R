test_that("prep_data returns specific data frame with 4 columns", {
  my_data <- data.frame(dt = as.Date(1:10, origin="2020-03-01"), acumulados = 1:10)
  my_data2 <- subset(my_data, select=dt)
  my_data <- prep_data(data = my_data, cum_cases = "acumulados", date_var = "dt")
  expect_true(ncol(my_data)==4)
  expect_error(prep_data(data=my_data2, date_var = dt))
  expect_true(all(is.numeric(my_data$cum_cases),
                  is.numeric(my_data$num_cases),
                  is.numeric(my_data$d2)))
})
