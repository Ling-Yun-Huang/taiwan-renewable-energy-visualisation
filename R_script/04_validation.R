# ----------------------------------
# Models Validation & Comparison
# ----------------------------------

library(dplyr)
library(ggplot2)
library(Metrics)
library(forecast)

# Read data and results
energy05_23_long <- readRDS("Documents/GitHub/taiwan-renewable-energy-visualisation/R_script/output/energy05_23_long.rds")
energy24_long <- readRDS("Documents/GitHub/taiwan-renewable-energy-visualisation/R_script/output/energy24_long.rds")

forecast_ETS <- readRDS("Documents/GitHub/taiwan-renewable-energy-visualisation/R_script/output/ETS_forecast2024.rds")
forecast_ARIMA <- readRDS("Documents/GitHub/taiwan-renewable-energy-visualisation/R_script/output/ARIMA_forecast2024.rds")
forecast_Prophet <- readRDS("Documents/GitHub/taiwan-renewable-energy-visualisation/R_script/output/Prophet_forecast2024.rds")

energy_list <- c("Hydropower", "Geothermal", "Solar", "Wind", "Biomass", "Waste")

accuracy_table <- data.frame()

color_mapping <- c(
  "Actual 2024" = "slateblue",      
  "ETS"         = "cornflowerblue", 
  "ARIMA"       = "mediumseagreen", 
  "Prophet"     = "lightsalmon"     
)

# for each source
for(e in energy_list){
  actual <- energy24_long %>% filter(item == e) %>% pull(value) # 2024 data
  pred_ets <- as.numeric(forecast_ETS[[e]]$mean) # ETS
  pred_arima <- as.numeric(forecast_ARIMA[[e]]$mean) # ARIMA
  pred_prophet <- tail(forecast_Prophet[[e]]$yhat, 12) # Prophet
  
  # accuracy calculation
  accuracy_table <- rbind(
    accuracy_table,
    data.frame(Energy = e, Model = "ETS",    RMSE = rmse(actual, pred_ets),    MAPE = mape(actual, pred_ets)),
    data.frame(Energy = e, Model = "ARIMA",  RMSE = rmse(actual, pred_arima),  MAPE = mape(actual, pred_arima)),
    data.frame(Energy = e, Model = "Prophet",RMSE = rmse(actual, pred_prophet), MAPE = mape(actual, pred_prophet))
  )
  
  # plot
  df_plot <- data.frame(
    date = rep(energy24_long$date[energy24_long$item == e], 4),
    value = c(actual, pred_ets, pred_arima, pred_prophet),
    series = rep(c("Actual 2024", "ETS", "ARIMA", "Prophet"), each = length(actual))
  )
  
  p <- ggplot(df_plot, aes(x = date, y = value, color = series)) +
    geom_line(size = 1.2) +
    scale_color_manual(values = color_mapping) +
    labs(title = paste(e, "Forecast vs Actual"), y = "GWh", x = "Date") +
    theme_minimal(base_size = 12) +
    theme(plot.title = element_text(face = "bold", hjust = 0.5))
  
  print(p)
}

## Added all renewable energy sources and compare to the actual number in 2024

# create a dataframe to store the total number
total_df <- data.frame(date = energy24_long %>% filter(item == energy_list[1]) %>% pull(date))

# using rowSums
total_df$ETS_total <- rowSums(sapply(energy_list, function(e) as.numeric(forecast_ETS[[e]]$mean)))
total_df$ARIMA_total <- rowSums(sapply(energy_list, function(e) as.numeric(forecast_ARIMA[[e]]$mean)))
total_df$Prophet_total <- rowSums(sapply(energy_list, function(e) tail(forecast_Prophet[[e]]$yhat, 12)))

# Read Renewable Total
total_df$RenewableTotal <- energy24_long %>% 
  filter(item == "Hydropower") %>%  # only take one date(avoid repeating)
  pull(RenewableTotal)

# Plot
df_plot_total <- total_df %>%
  pivot_longer(cols = -date, names_to = "series", values_to = "value")

df_plot_total <- df_plot_total %>%
  dplyr::mutate(series = case_when(
    series == "ETS_total"    ~ "ETS",
    series == "ARIMA_total"  ~ "ARIMA",
    series == "Prophet_total"~ "Prophet",
    series == "RenewableTotal" ~ "Actual 2024",
    TRUE ~ series
  ))

ggplot(df_plot_total, aes(x = date, y = value, color = series)) +
  geom_line(size = 1.2) +
  scale_color_manual(values = c(color_mapping)) +
  labs(title = "Total Renewable Energy Forecast vs Actual", y = "GWh", x = "Date") +
  theme_minimal(base_size = 12) +
  theme(plot.title = element_text(face = "bold", hjust = 0.5))


# calculate RMSE / MAPE
rmse_ets    <- rmse(total_df$RenewableTotal, total_df$ETS_total)
rmse_arima  <- rmse(total_df$RenewableTotal, total_df$ARIMA_total)
rmse_prophet<- rmse(total_df$RenewableTotal, total_df$Prophet_total)

mape_ets    <- mape(total_df$RenewableTotal, total_df$ETS_total)
mape_arima  <- mape(total_df$RenewableTotal, total_df$ARIMA_total)
mape_prophet<- mape(total_df$RenewableTotal, total_df$Prophet_total)

# accuracy table
accuracy_total <- data.frame(
  Model = c("ETS", "ARIMA", "Prophet"),
  RMSE = c(rmse_ets, rmse_arima, rmse_prophet),
  MAPE = c(mape_ets, mape_arima, mape_prophet)
)

print(accuracy_total)
