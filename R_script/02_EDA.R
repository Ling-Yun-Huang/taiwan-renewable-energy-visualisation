# -----------------------------
# Exploratory Data Analysis
# -----------------------------

library(dplyr) 
library(tidyr)
library(ggplot2)

# Read data
energy_long <- readRDS("Documents/GitHub/taiwan-renewable-energy-visualisation/R_script/output/energy_long.rds")

# annual data
energy_annual <- energy_long %>%
  group_by(year, item) %>%
  summarise(AnnualValue = sum(value), .groups = "drop")

energy_monthly_first <- energy_long %>%
  group_by(year, month) %>%
  slice(1) %>%        # keep first one
  ungroup()

# Yearly renewable percentage
energy_annual_re <- energy_monthly_first %>%
  group_by(year) %>%
  summarise(
    Overall = sum(Overall),          
    RenewableTotal = sum(RenewableTotal),
    .groups = "drop"
  )%>%
  mutate(
    Renewable_pct = RenewableTotal / Overall
  )

# Calculate each source total power in 2005, 2016, 2023

summary_table <- energy_annual %>% 
  filter(year %in% c(2005, 2016, 2023)) %>% 
  pivot_wider(names_from = year, values_from = AnnualValue, names_prefix = "Y") %>% 
  mutate( Growth = scales::percent((Y2023 - Y2016) / Y2016, accuracy = 1) ) %>% 
  select(item, Y2005, Y2016, Y2023, Growth)

print(summary_table)

# see individual types trend

color_panel <- c(
  "Hydropower" = "#93C572",  
  "Geothermal" = "#F4A582",  
  "Solar"      = "#FFCC33",  
  "Wind"       = "#6CA0DC",  
  "Biomass"    = "#C08081",  
  "Waste"      = "#A7A7A7"  
)

ggplot(energy_annual, aes(x = year, y = AnnualValue, color = item)) +
  geom_smooth(se = FALSE, method = "loess") + 
  labs(title = "Annual Renewable Energy by Source (smooth)",
       x = "Year", y = "GWh", color = "Energy Source") +
  scale_color_manual(values = color_panel) +
  theme_minimal(base_size = 13)

# see yearly percentage in Renewable Energy
ggplot(energy_annual_re, aes(x = year, y = Renewable_pct)) +
  geom_line(color = "steelblue", size = 1.2) +
  geom_point(color = "steelblue", size = 2) +
  geom_point(data = energy_annual_re %>% filter(year == 2016), 
             aes(x = year, y = Renewable_pct), color = "orange", size = 3) +
  geom_text(data = energy_annual_re %>% filter(year == 2016),
            aes(x = year, y = Renewable_pct, 
                label = paste0(round(Renewable_pct*100,1),"%")),
                vjust = -1, color = "orange", size = 3.5) +
  annotate("text", x = 2016.2, y = 0.043, label = "2016", 
           color = "orange", vjust = -0.5, size = 3.5) +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
  labs(
    title = "Yearly Renewable Energy Percentage",
    x = "Year",
    y = "Renewable Energy / Total Energy"
  ) +
  theme_minimal(base_size = 12) +
  theme(plot.title = element_text(face = "bold", hjust = 0.5))

## Take a closer look in solar and wind after 2016
# Solar
solar_data <- energy_long %>% 
  filter(item == 'Solar') %>%
  filter(year(date) >= 2016) %>%
  arrange(date)

ggplot(solar_data, aes(x = date, y = value)) +
  geom_line(color = "#FFCC33", size = 1) +
  geom_point(color = "#FFCC33", size = 1.5) +
  labs(
    title = paste("Solar Monthly Generation Trend"),
    x = "Date",
    y = "Generation (GWh)"
  ) +
  theme_minimal(base_size = 12)

# Wind
wind_data <- energy_long %>% 
  filter(item == 'Wind') %>%
  filter(year(date) >= 2016) %>%
  arrange(date)

ggplot(wind_data, aes(x = date, y = value)) +
  geom_line(color = "#6CA0DC", size = 1) +
  geom_point(color = "#6CA0DC", size = 1.5) +
  labs(
    title = paste("Wind Monthly Generation Trend"),
    x = "Date",
    y = "Generation (GWh)"
  ) +
  theme_minimal(base_size = 12)

# -------------------------
# Seasonal Analysis
# -------------------------
# monthly avg in Solar
solar_seasonal_data <- solar_data %>%
  mutate(month = month(date)) %>%
  group_by(month) %>%
  summarise(
    mean_value = mean(value, na.rm = TRUE),
    sd_value = sd(value, na.rm = TRUE),
    .groups = "drop"
  )

ggplot(solar_seasonal_data, aes(x = month, y = mean_value)) +
  geom_line(color = "#FFCC33", size = 1.2) +
  geom_point(color = "#FFCC33", size = 2) +
  geom_ribbon(aes(ymin = mean_value - sd_value, ymax = mean_value + sd_value),
              fill = "yellow", alpha = 0.3) +
  scale_x_continuous(breaks = 1:12, labels = month.abb) +
  labs(
    title = paste("Solar Seasonal Pattern(2016-2024)"),
    x = "Month",
    y = "Average Generation (GWh)"
  ) +
  theme_minimal(base_size = 12)

# closer look at 2020-2024
solar_seasonal_data20 <- solar_data %>%
  filter(year(date) >= 2020) %>%
  mutate(month = month(date)) %>%
  group_by(month) %>%
  summarise(
    mean_value = mean(value, na.rm = TRUE),
    sd_value = sd(value, na.rm = TRUE),
    .groups = "drop"
  )

ggplot(solar_seasonal_data20, aes(x = month, y = mean_value)) +
  geom_line(color = "#FFCC33", size = 1.2) +
  geom_point(color = "#FFCC33", size = 2) +
  geom_ribbon(aes(ymin = mean_value - sd_value, ymax = mean_value + sd_value),
              fill = "yellow", alpha = 0.3) +
  scale_x_continuous(breaks = 1:12, labels = month.abb) +
  labs(
    title = paste("Solar Seasonal Patternc(2020-2024)"),
    x = "Month",
    y = "Average Generation (GWh)"
  ) +
  theme_minimal(base_size = 12)

# monthly avg in Wind
wind_seasonal_data <- wind_data %>%
  mutate(month = month(date)) %>%
  group_by(month) %>%
  summarise(
    mean_value = mean(value, na.rm = TRUE),
    sd_value = sd(value, na.rm = TRUE),
    .groups = "drop"
  )

ggplot(wind_seasonal_data, aes(x = month, y = mean_value)) +
  geom_line(color = "#6CA0DC", size = 1.2) +
  geom_point(color = "#6CA0DC", size = 2) +
  geom_ribbon(aes(ymin = mean_value - sd_value, ymax = mean_value + sd_value),
              fill = "skyblue", alpha = 0.3) +
  scale_x_continuous(breaks = 1:12, labels = month.abb) +
  labs(
    title = paste("Wind Seasonal Pattern (2016-2024)"),
    x = "Month",
    y = "Average Generation (GWh)"
  ) +
  theme_minimal(base_size = 12)

# All source with seasonal pattern after 2016
seasonal_data <- energy_long %>%
  mutate(month = month(date)) %>%
  filter(year(date) >= 2016) %>%
  group_by(item, month) %>%
  summarise(
    mean_value = mean(value, na.rm = TRUE),
    sd_value   = sd(value, na.rm = TRUE),
    .groups = "drop"
  )

ggplot(seasonal_data, aes(x = month, y = mean_value, color = item, fill = item)) +
  geom_ribbon(aes(ymin = mean_value - sd_value, ymax = mean_value + sd_value),
              alpha = 0.2, color = NA) +
  geom_line(size = 1.2) +
  geom_point(size = 2) +
  scale_x_continuous(breaks = 1:12, labels = month.abb) +
  scale_color_manual(values = color_panel) +
  scale_fill_manual(values = color_panel) +
  labs(title = "Seasonal Pattern by Energy Source (2016-2024)",
       x = "Month",
       y = "Average Generation (GWh)",
       color = "Energy Source",
       fill = "Energy Source") +
  theme_minimal(base_size = 12)

