# --------------------------------
# Time-series Forecasting - ETS
# --------------------------------

library(dplyr)
library(forecast)

# Read data
energy05_23_long <- readRDS("Documents/GitHub/taiwan-renewable-energy-visualisation/R_script/output/energy05_23_long.rds")
ets_forecast2024 <- list()
energy_list <- c("Hydropower", "Geothermal", "Solar", "Wind", "Biomass", "Waste")

for(e in energy_list){ 
  ts_values <- energy05_23_long %>% 
    filter(item == e) %>% # for each source
    arrange(date) %>% pull(value)
  ts_data <- ts(ts_values, start = c(2005, 1), frequency = 12)
  fit_ets <- ets(ts_data) # fit ETS
  fc_ets <- forecast(fit_ets, h = 12) # forecasting future 12 months
  ets_forecast2024[[e]] <- fc_ets
}

# Store the ETS forecast on 2024
saveRDS(ets_forecast2024, "Documents/GitHub/taiwan-renewable-energy-visualisation/R_script/output/ETS_forecast2024.rds")
