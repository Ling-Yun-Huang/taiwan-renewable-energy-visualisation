library(shiny)
library(dplyr)
library(ggplot2)
library(lubridate)
library(plotly)

# -------------------------
# Data preparation
# -------------------------
energy_long <- readRDS("energy_long.rds")

# annual data
energy_annual <- energy_long %>%
  group_by(year, item) %>%
  summarise(AnnualValue = sum(value), .groups = "drop")

# color panel
color_panel <- c(
  "Hydropower" = "#93C572",
  "Geothermal" = "#F4A582",
  "Solar"      = "#FFCC33",
  "Wind"       = "#6CA0DC",
  "Biomass"    = "#C08081",
  "Waste"      = "#A7A7A7"
)

# -------------------------
# UI
# -------------------------
ui <- fluidPage(
  titlePanel("Taiwan Renewable Energy Trends"),
  
  sidebarLayout(
    sidebarPanel(
      sliderInput("yearRange", "Select Year Range:",
                  min = min(energy_annual$year),
                  max = max(energy_annual$year),
                  value = c(2016, 2023), step = 1, sep = ""),
      checkboxGroupInput("sources", "Select Energy Sources:",
                         choices = unique(energy_annual$item),
                         selected = c("Solar", "Wind"))
    ),
    
    mainPanel(
      plotOutput("annualPlot"),    # 🔥 改成 plotlyOutput
      plotOutput("seasonalPlot")   # 🔥 改成 plotlyOutput
    )
  )
)

# -------------------------
# Server
# -------------------------
server <- function(input, output) {
  output$annualPlot <- renderPlot({
    data_filtered <- energy_annual %>%
      filter(year >= input$yearRange[1],
             year <= input$yearRange[2],
             item %in% input$sources)
    
    ggplot(data_filtered, aes(x = year, y = AnnualValue, color = item)) +
      geom_smooth(se = FALSE, method = "loess") +
      labs(title = "Annual Renewable Energy by Source (smooth)",
           x = "Year", y = "GWh", color = "Energy Source") +
      scale_color_manual(values = color_panel) +
      scale_y_continuous(expand = expansion(mult = c(0, 0.05)), limits = c(0, NA)) +  # y 從 0 開始
      theme_minimal(base_size = 15)
  })
  
  output$seasonalPlot <- renderPlot({
    seasonal_data <- energy_long %>%
      filter(item %in% input$sources,
             year(date) >= input$yearRange[1],
             year(date) <= input$yearRange[2]) %>%
      mutate(month = lubridate::month(date)) %>%
      group_by(item, month) %>%
      summarise(mean_value = mean(value, na.rm = TRUE),
                sd_value   = sd(value, na.rm = TRUE),
                .groups = "drop")
    
    ggplot(seasonal_data, aes(x = month, y = mean_value, color = item, fill = item)) +
      geom_ribbon(aes(ymin = mean_value - sd_value, ymax = mean_value + sd_value),
                  alpha = 0.2, color = NA) +
      geom_line(size = 1.2) +
      geom_point(size = 2) +
      scale_x_continuous(breaks = 1:12, labels = month.abb) +
      scale_color_manual(values = color_panel) +
      scale_fill_manual(values = color_panel) +
      labs(title = paste("Seasonal Pattern by Energy Source (", input$yearRange[1], "-", input$yearRange[2], ")", sep = ""),
           x = "Month", y = "Average Generation (GWh)",
           color = "Energy Source",
           fill = "Energy Source") +
      theme_minimal(base_size = 15)
  })
}

# -------------------------
# Run App
# -------------------------
shinyApp(ui = ui, server = server)

