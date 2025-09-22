library(dplyr)
library(forecast)

energy05_23_long <- readRDS("Documents/GitHub/taiwan-renewable-energy-visualisation/R_script/output/energy05_23_long.rds")
ets_forecast2024 <- list()
energy_list <- c("Hydropower", "Geothermal", "Solar", "Wind", "Biomass", "Waste")

for(e in energy_list){
  
  ts_values <- energy05_23_long %>%
    filter(item == e) %>%
    arrange(date) %>%
    pull(value)
  
  ts_data <- ts(ts_values, start = c(2005, 1), frequency = 12)
  
  # fit ETS
  fit_ets <- ets(ts_data)
  
  # forecasting future 12 months
  fc_ets <- forecast(fit_ets, h = 12)
  ets_forecast2024[[e]] <- fc_ets
}


#ets_forecast2024
saveRDS(ets_forecast2024, "Documents/GitHub/taiwan-renewable-energy-visualisation/R_script/output/ETS_forecast2024.rds")
