# -----------------------------
# Summary (history + forecast)
# -----------------------------
# Data
energy_long <- readRDS("Documents/GitHub/taiwan-renewable-energy-visualisation/R_script/output/energy_long.rds")
forecast_total <- readRDS("Documents/GitHub/taiwan-renewable-energy-visualisation/R_script/output/forecast_total.rds")

energy_list <- c("Hydropower", "Geothermal", "Solar", "Wind", "Biomass", "Waste")

## Plot
# Calculate the historical renewable % in each month
historical_pct <- energy_long %>%
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
  labs(title = "Renewable %: Historical + 2025 Forecast (ARIMA)",
       x = "Date", y = "Renewable Energy / Total Energy", color = "Series") +
  theme_minimal(base_size = 12) +
  theme(plot.title = element_text(face = "bold", hjust = 0.5))


# Plotting after 2016
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
  labs(title = "Renewable %: 2016-2024 + 2025 Forecast (ARIMA)",
       x = "Date", y = "Renewable Energy / Total Energy", color = "Series") +
  theme_minimal(base_size = 12) +
  theme(plot.title = element_text(face = "bold", hjust = 0.5))


# ------------------------
# Prepare annual data
# ------------------------
energy_list <- c("Hydropower", "Geothermal", "Solar", "Wind", "Biomass", "Waste")

# Historical annual totals
historical_annual <- energy_long %>%
  group_by(year = format(date, "%Y")) %>%
  summarise(
    Renewable = sum(value[item %in% energy_list]),
    Total = sum(Overall[item %in% "Solar"]),
    Renewable_pct = Renewable / Total,
    .groups = "drop"
  ) %>%
  filter(as.numeric(year) >= 2020) %>% 
  mutate(series = "Historical",
         Renewable_lower = NA,
         Renewable_upper = NA,
         Renewable_lower_pct = NA,
         Renewable_upper_pct = NA)

# Forecast annual total (sum monthly predictions)
forecast_annual <- forecast_total %>%
  mutate(year = format(date, "%Y")) %>%
  group_by(year) %>%
  summarise(
    Renewable = sum(Renewable_mean),
    Total = sum(Overall_mean),
    Renewable_lower = sum(Renewable_lower),
    Renewable_upper = sum(Renewable_upper),
    Renewable_pct = sum(Renewable_mean) / sum(Overall_mean),
    Renewable_lower_pct = sum(Renewable_lower) / sum(Overall_upper),
    Renewable_upper_pct = sum(Renewable_upper) / sum(Overall_lower),
    .groups = "drop"
  ) %>%
  filter(as.numeric(year) >= 2020) %>% 
  mutate(series = "Forecast")

# Combine
annual_plot <- bind_rows(historical_annual, forecast_annual)

annual_plot <- annual_plot %>%
  arrange(year) %>%
  mutate(
    YoY_growth = (Renewable / lag(Renewable) - 1) * 100,
    YoY_growth_lower = ifelse(!is.na(Renewable_lower) & !is.na(lag(Renewable)),
                              (Renewable_lower / lag(Renewable) - 1) * 100, NA),
    YoY_growth_upper = ifelse(!is.na(Renewable_upper) & !is.na(lag(Renewable)),
                              (Renewable_upper / lag(Renewable) - 1) * 100, NA)
  )
annual_plot

# ------------------------
# Plot
# ------------------------
ggplot(annual_plot, aes(x = factor(year), y = Renewable, fill = series)) +
  geom_col(position = "dodge", width = 0.5) +  # 調整柱寬
  geom_errorbar(aes(ymin = Renewable_lower, ymax = Renewable_upper),
                width = 0.1,
                data = annual_plot %>% filter(series == "Forecast")) +
  scale_fill_manual(values = c("Historical" = "#6CA0DC", "Forecast" = "#93C572")) +
  labs(title = "Annual Renewable Energy Trend (2020–2025)",
       x = "Year", y = "Renewable Generation (GWh)", fill = "Series") +
  theme_minimal(base_size = 12)

