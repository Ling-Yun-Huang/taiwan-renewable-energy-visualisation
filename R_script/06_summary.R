# -------------------------
# Data
# -------------------------
energy05_23_long <- readRDS("Documents/GitHub/taiwan-renewable-energy-visualisation/R_script/output/energy05_23_long.rds")
energy24_long <- readRDS("Documents/GitHub/taiwan-renewable-energy-visualisation/R_script/output/energy24_long.rds")
energy05_24_long <- rbind(energy05_23_long, energy24_long)
forecast_total <- readRDS("Documents/GitHub/taiwan-renewable-energy-visualisation/R_script/output/forecast_total.rds")

## Plot the historical + 2025 Forecast
# Calculate the historical renewable % in each month
historical_pct <- energy05_24_long %>%
  group_by(date) %>%
  summarise(
    Renewable = sum(value[item %in% energy_list]),
    Overall = first(Overall),
    .groups = "drop"
  ) %>%
  mutate(Renewable_pct = Renewable / Overall,
         series = "Historical")

# 2025 forecast
forecast_pct <- forecast_total %>%
  select(date, Renewable_pct_mean, Renewable_pct_lower, Renewable_pct_upper) %>%
  rename(Renewable_pct = Renewable_pct_mean) %>%
  mutate(series = "Forecast")

# Combine the dataset
plot_data <- bind_rows(
  historical_pct %>% select(date, Renewable_pct, series),
  forecast_pct %>% select(date, Renewable_pct, series)
)

# plot
ggplot() +
  geom_line(data = historical_pct, aes(x = date, y = Renewable_pct, color = "Historical"), size = 1.2) +
  geom_ribbon(data = forecast_total, aes(x = date, ymin = Renewable_pct_lower, ymax = Renewable_pct_upper),
              fill = "lightgreen", alpha = 0.3) +
  geom_line(data = forecast_pct, aes(x = date, y = Renewable_pct, color = "Forecast"), size = 1.2) +
  geom_hline(yintercept = 0.2, linetype = "dashed", color = "red") +  # 20% goal line
  scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
  scale_color_manual(values = c("Historical" = "slateblue", "Forecast" = "mediumseagreen")) +
  labs(title = "Renewable Energy %: Historical + 2025 Forecast (ARIMA)",
       x = "Date", y = "Renewable Energy / Total Energy", color = "Series") +
  theme_minimal(base_size = 12) +
  theme(plot.title = element_text(face = "bold", hjust = 0.5))


# Combine the dataset
plot_data <- bind_rows(
  historical_pct %>% select(date, Renewable_pct, series),
  forecast_pct %>% select(date, Renewable_pct, series)
) %>%
  filter(date >= as.Date("2016-01-01"))   # keep only after 2016

# plot
ggplot() +
  geom_line(data = plot_data %>% filter(series == "Historical"),
            aes(x = date, y = Renewable_pct, color = "Historical"), size = 1.2) +
  geom_ribbon(data = forecast_total %>% filter(date >= as.Date("2016-01-01")),
              aes(x = date, ymin = Renewable_pct_lower, ymax = Renewable_pct_upper),
              fill = "lightgreen", alpha = 0.3) +
  geom_line(data = plot_data %>% filter(series == "Forecast"),
            aes(x = date, y = Renewable_pct, color = "Forecast"), size = 1.2) +
  geom_hline(yintercept = 0.2, linetype = "dashed", color = "red") +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
  scale_color_manual(values = c("Historical" = "slateblue", "Forecast" = "mediumseagreen")) +
  labs(title = "Renewable Energy %: Historical + 2025 Forecast (ARIMA)",
       x = "Date", y = "Renewable Energy / Total Energy", color = "Series") +
  theme_minimal(base_size = 12) +
  theme(plot.title = element_text(face = "bold", hjust = 0.5))
