library(dplyr)
library(forecast)

energy05_23_long <- readRDS("Documents/GitHub/taiwan-renewable-energy-visualisation/R_script/output/energy05_23_long.rds")
ARIMA_forecast2024 <- list()
energy_cols <- c("Hydropower", "Geothermal", "Solar", "Wind", "Biomass", "Waste")

for(e in energy_list){
  ts_hist <- ts(energy05_23_long %>% filter(item==e) %>% pull(value),
                start=c(2005,1), frequency=12)
  fit_arima <- auto.arima(ts_hist)
  fc_arima <- forecast(fit_arima, h=12)
  ARIMA_forecast2024[[e]] <- fc_arima
}

#ARIMA_forecast2024
saveRDS(ARIMA_forecast2024, "Documents/GitHub/taiwan-renewable-energy-visualisation/R_script/output/ARIMA_forecast2024.rds")
