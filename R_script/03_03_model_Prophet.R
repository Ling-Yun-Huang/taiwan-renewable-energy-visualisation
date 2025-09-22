library(dplyr)
library(prophet)

energy05_23_long <- readRDS("Documents/GitHub/taiwan-renewable-energy-visualisation/R_script/output/energy05_23_long.rds")
prophet_forecast2024 <- list()
energy_list <- c("Hydropower", "Geothermal", "Solar", "Wind", "Biomass", "Waste")

for(e in energy_list){
  df_prophet <- energy_long %>%
    filter(item == e) %>%
    select(date, value) %>%
    rename(ds = date, y = value)
  
  m <- prophet(df_prophet, yearly.seasonality=TRUE)
  future <- make_future_dataframe(m, periods=12, freq="month")
  fc_prophet <- predict(m, future)
  prophet_forecast2024[[e]] <- fc_prophet
}

#prophet_forecast2024
saveRDS(prophet_forecast2024, "Documents/GitHub/taiwan-renewable-energy-visualisation/R_script/output/prophet_forecast2024.rds")
