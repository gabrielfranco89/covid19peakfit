## code to prepare `DATASET` dataset goes here
devtools::install_github("Freguglia/datacovidbr")

cssegis <- CSSEGISandData()
#> Latest Update:  2020-03-21
korea_covid19 <- cssegis %>%
  filter(Country.Region == "Korea, South",
         data <= "2020-03-21") %>%
  select(date=data, cum_cases = casosAcumulados) %>%
  as.data.frame()
korea_covid19 <- subset(korea_covid19, select = -Country.Region)

usethis::use_data(korea_covid19)
rm(cssegis)
