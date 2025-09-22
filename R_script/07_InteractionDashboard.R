library(shiny)
library(dplyr)
library(ggplot2)
library(forecast)

# -------------------------
# 讀取資料
# -------------------------
energy05_23_long <- readRDS("Documents/GitHub/taiwan-renewable-energy-visualisation/R_script/output/energy05_23_long.rds")
energy24_long   <- readRDS("Documents/GitHub/taiwan-renewable-energy-visualisation/R_script/output/energy24_long.rds")
forecast_ETS    <- readRDS("Documents/GitHub/taiwan-renewable-energy-visualisation/R_script/output/ETS_forecast2024.rds")
forecast_ARIMA  <- readRDS("Documents/GitHub/taiwan-renewable-energy-visualisation/R_script/output/ARIMA_forecast2024.rds")
forecast_Prophet<- readRDS("Documents/GitHub/taiwan-renewable-energy-visualisation/R_script/output/Prophet_forecast2024.rds")

energy_list <- c("Hydropower", "Geothermal", "Solar", "Wind", "Biomass", "Waste")
forecast_list <- list(ETS = forecast_ETS, ARIMA = forecast_ARIMA, Prophet = forecast_Prophet)
energy_long <- rbind(energy05_23_long, energy24_long)

# -------------------------
# UI
# -------------------------
ui <- fluidPage(
  titlePanel("Renewable Energy Forecast Dashboard"),
  sidebarLayout(
    sidebarPanel(
      dateRangeInput("date_range", "Select Date Range", 
                     start = min(energy_long$date), 
                     end = max(energy_long$date)),
      checkboxGroupInput("selected_energy", "Select Energy Type", 
                         choices = energy_list, selected = energy_list),
      radioButtons("selected_model", "Select Forecast Model", 
                   choices = names(forecast_list), selected = "ARIMA")
    ),
    mainPanel(
      plotOutput("forecast_plot", height = "400px"),
      plotOutput("stacked_plot", height = "400px"),
      tableOutput("accuracy_table")
    )
  )
)

# -------------------------
# Server
# -------------------------
server <- function(input, output, session) {
  
  # Filter historical data
  filtered_historical <- reactive({
    energy_long %>%
      filter(date >= input$date_range[1],
             date <= input$date_range[2],
             item %in% input$selected_energy)
  })
  
  # Select forecast model
  selected_forecast <- reactive({
    forecast_list[[input$selected_model]]
  })
  
  # Combine historical + forecast for plotting
  forecast_plot_data <- reactive({
    hist <- filtered_historical()
    
    fc <- lapply(input$selected_energy, function(e) {
      data.frame(
        date = energy24_long$date,
        item = e,
        pred = as.numeric(selected_forecast()[[e]]$mean)
      )
    }) %>% bind_rows()
    
    list(hist = hist, fc = fc)
  })
  
  # Accuracy table
  output$accuracy_table <- renderTable({
    hist <- filtered_historical()
    fc <- selected_forecast()
    
    acc_table <- lapply(input$selected_energy, function(e){
      actual <- energy24_long %>% filter(item == e) %>% pull(value)
      pred <- as.numeric(fc[[e]]$mean)
      data.frame(Energy = e,
                 Model = input$selected_model,
                 RMSE = round(Metrics::rmse(actual, pred),2),
                 MAPE = round(Metrics::mape(actual, pred),2))
    }) %>% bind_rows()
    
    acc_table
  })
  
  # Forecast line plot
  output$forecast_plot <- renderPlot({
    data <- forecast_plot_data()
    
    ggplot() +
      geom_line(data = data$hist, aes(x = date, y = value, color = item), size = 1) +
      geom_line(data = data$fc, aes(x = date, y = pred, color = item), linetype = "dashed", size = 1) +
      labs(title = paste("Forecast vs Historical (", input$selected_model, ")"),
           x = "Date", y = "GWh", color = "Energy Source") +
      theme_minimal(base_size = 12)
  })
  
  # Stacked area plot
  output$stacked_plot <- renderPlot({
    hist <- filtered_historical() %>%
      group_by(date) %>%
      summarise(value = sum(value), .groups = "drop") %>%
      mutate(series = "Historical")
    
    fc_total <- data.frame(
      date = energy24_long$date,
      value = rowSums(sapply(input$selected_energy, function(e) as.numeric(selected_forecast()[[e]]$mean))),
      series = "Forecast"
    )
    
    plot_data <- bind_rows(hist, fc_total)
    
    ggplot(plot_data, aes(x = date, y = value, fill = series)) +
      geom_area(alpha = 0.5, position = "identity") +
      labs(title = paste("Total Renewable Energy (", input$selected_model, ")"),
           x = "Date", y = "GWh", fill = "Series") +
      theme_minimal(base_size = 12)
  })
}

# -------------------------
# Run App
# -------------------------
shinyApp(ui, server)

