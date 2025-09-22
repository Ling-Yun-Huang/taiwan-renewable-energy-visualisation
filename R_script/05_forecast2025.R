library(dplyr)
library(forecast)
library(ggplot2)

# -------------------------
# Data
# -------------------------
energy05_23_long <- readRDS("Documents/GitHub/taiwan-renewable-energy-visualisation/R_script/output/energy05_23_long.rds")
energy24_long <- readRDS("Documents/GitHub/taiwan-renewable-energy-visualisation/R_script/output/energy24_long.rds")
energy_list <- c("Hydropower", "Geothermal", "Solar", "Wind", "Biomass", "Waste")

arima_forecast_2025 <- list()
forecast_total <- data.frame(date = seq(as.Date("2025-01-01"), as.Date("2025-12-01"), by = "month"))

energy05_24_long <- rbind(energy05_23_long, energy24_long)

# -------------------------
# for each source
# -------------------------
for(e in energy_list){
  ts_values <- energy05_24_long %>%
    filter(item == e) %>%
    arrange(date) %>%
    pull(value)
  
  ts_data <- ts(ts_values, frequency = 12, start = c(2005, 1))
  
  fit_arima <- auto.arima(ts_data)
  fc <- forecast(fit_arima, h = 12, level = 95) # 95% CI
  
  arima_forecast_2025[[e]] <- fc
  
  forecast_total[[paste0(e, "_pred")]] <- as.numeric(fc$mean)
  forecast_total[[paste0(e, "_lower")]] <- fc$lower[,1]
  forecast_total[[paste0(e, "_upper")]] <- fc$upper[,1]
}

# -------------------------
# Forecast the total energy
# -------------------------
ts_total <- energy05_24_long %>% 
  group_by(date) %>%
  summarise(Overall = first(Overall), .groups = "drop")

ts_overall <- ts(ts_total$Overall, start=c(2005,1), frequency=12)
fit_overall <- auto.arima(ts_overall)
fc_overall <- forecast(fit_overall, h=12, level=95)

forecast_total$Overall_mean  <- as.numeric(fc_overall$mean)
forecast_total$Overall_lower <- as.numeric(fc_overall$lower[,1])
forecast_total$Overall_upper <- as.numeric(fc_overall$upper[,1])

# -------------------------
# Calculate the total and percentage
# -------------------------
forecast_total <- forecast_total %>%
  mutate(
    Renewable_mean  = rowSums(select(., paste0(energy_list, "_pred"))),
    Renewable_lower = rowSums(select(., paste0(energy_list, "_lower"))),
    Renewable_upper = rowSums(select(., paste0(energy_list, "_upper"))),
    Renewable_pct_mean  = Renewable_mean  / Overall_mean,
    Renewable_pct_lower = Renewable_lower / Overall_upper,
    Renewable_pct_upper = Renewable_upper / Overall_lower
  )
saveRDS(forecast_total, "Documents/GitHub/taiwan-renewable-energy-visualisation/R_script/output/forecast_total.rds")

# -------------------------
# Plot the total renewable with 95% CI
# -------------------------
ggplot(forecast_total, aes(x = date)) +
  geom_ribbon(aes(ymin = Renewable_lower, ymax = Renewable_upper), fill = "lightblue", alpha = 0.3) +
  geom_line(aes(y = Renewable_mean), color = "blue", size = 1.2) +
  labs(title = "Total Renewable Energy Forecast 2025 (ARIMA)", y = "GWh", x = "Date") +
  theme_minimal(base_size = 12)

ggplot(forecast_total, aes(x = date)) +
  geom_ribbon(aes(ymin = Renewable_pct_lower, ymax = Renewable_pct_upper),
              fill = "lightgreen", alpha = 0.3) +
  geom_line(aes(y = Renewable_pct_mean), color = "darkgreen", size = 1.2) +
  labs(title = "Forecasted Renewable Energy Percentage 2025 (ARIMA)",
       y = "Renewable Energy / Total Energy",
       x = "Month") +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
  theme_minimal(base_size = 12) +
  theme(plot.title = element_text(face = "bold", hjust = 0.5))