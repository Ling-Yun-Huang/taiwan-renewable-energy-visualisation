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
    Renewable_pct = (Renewable / Total)*100,
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
    Renewable_pct = sum(Renewable_mean) / sum(Overall_mean)*100,
    Renewable_lower_pct = sum(Renewable_lower) / sum(Overall_upper)*100,
    Renewable_upper_pct = sum(Renewable_upper) / sum(Overall_lower)*100,
    .groups = "drop"
  ) %>%
  filter(as.numeric(year) >= 2020) %>% 
  mutate(series = "Forecast")

# Combine
annual_plot <- bind_rows(historical_annual, forecast_annual)

annual_plot <- annual_plot %>%
  arrange(year) %>%
  mutate(YoY_growth = (Renewable / lag(Renewable) - 1) * 100) %>%
  mutate(year_num = as.numeric(year))

annual_plot

# ------------------------
# Plot
# ------------------------
ggplot(annual_plot, aes(x = factor(year), y = Renewable, fill = series)) +
  geom_col(position = "dodge", width = 0.5) + 
  geom_errorbar(aes(ymin = Renewable_lower, ymax = Renewable_upper),
                width = 0.1,
                data = annual_plot %>% filter(series == "Forecast")) +
  scale_fill_manual(values = c("Historical" = "#6CA0DC", "Forecast" = "#93C572")) +
  labs(title = "Annual Renewable Energy Trend (2020–2025)",
       x = "Year", y = "Renewable Generation (GWh)", fill = "Series") +
  theme_minimal(base_size = 12)

scale_factor <- max(annual_plot$Renewable, na.rm = TRUE) / max(annual_plot$YoY_growth, na.rm = TRUE)

ggplot(annual_plot, aes(x = factor(year))) +
  geom_col(aes(y = Renewable, fill = series), position = "dodge", width = 0.4) +
  geom_errorbar(aes(ymin = Renewable_lower, ymax = Renewable_upper),
                width = 0.05,
                data = annual_plot %>% filter(series == "Forecast")) +
  geom_line(aes(y = YoY_growth * scale_factor, group = 1), color = "#C08081", size = 1.1) +
  geom_point(aes(y = YoY_growth * scale_factor), color = "#C08081", size = 2.5) +
  scale_y_continuous(
    name = "Renewable Generation (GWh)",
    sec.axis = sec_axis(~./scale_factor, name = "YoY Growth (%)")
  ) +
  scale_fill_manual(values = c("Historical" = "#4F81BD", "Forecast" = "#9BBB59")) +
  labs(
    title = "Annual Renewable Energy Trend with YoY Growth (2020–2025)",
    x = "Year",
    fill = "Series"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    axis.title.y.right = element_text(color = "#A52A2A"),
    axis.text.y.right = element_text(color = "#A52A2A"),
    #legend.position = "bottom"
  )


# lines
historical_line <- annual_plot %>% filter(year_num <= 2024)
forecast_line <- annual_plot %>% filter(year_num >= 2024)

ggplot(annual_plot, aes(x = year_num, y = Renewable_pct)) +
  geom_line(data = historical_line, aes(group = 1), color = "#4F81BD", size = 1.2) +
  geom_line(data = forecast_line, aes(group = 1), color = "#9BBB59", size = 1.2, linetype = "dashed") +
  geom_point(aes(color = series), size = 3) +
  geom_hline(yintercept = 20, linetype = "dashed", color = "#A52A2A", size = 1) +
  annotate("text", x = 2024.5, y = 20, label = "20% target", vjust = -0.5, color = "#A52A2A") +
  scale_color_manual(values = c("Historical" = "#4F81BD", "Forecast" = "#9BBB59")) +
  scale_y_continuous(labels = scales::percent_format(scale = 1), limits = c(0, 22)) +
  labs(title = "Annual Renewable Energy Share (2020–2025)",
       x = "Year", y = "Renewable Energy (%)", color = "Series") +
  theme_minimal(base_size = 12)
