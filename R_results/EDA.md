## 📊 Data Exploration (EDA)

 [⬅ Back to R results](README.md) | [⬅ Back to Project Overview](../README.md)

This document presents the **Exploratory Data Analysis (EDA)** of Taiwan's renewable energy generation from 2005 to 2024.  
We examine **annual trends**, **seasonal patterns**, and highlight the most significant contributors.

---

### 🔹 Annual Trends by Energy Source

We aggregated the monthly generation data into annual totals for each energy source.

<img src="figures/annual_all_source.png" width="600">

The table below shows the total annual generation by energy source for 2005, 2016, and 2023,  
as well as the growth rate from 2016 to 2023.  

| Energy Source | 2005 (GWh) | 2016 (GWh) | 2023 (GWh) | Growth (2016→2023) |
|---------------|-----------:|-----------:|-----------:|------------------: |
| Solar         | 1          | 1,109      | 12,909     | +1064%             |
| Wind          | 91         | 1,457      | 6,201      | +326%              |
| Hydropower    | 4,071      | 6,562      | 3,963      | -40%               |
| Geothermal    | 0          | 0          | 23         | ---                |
| Biomass       | 323        | 205        | 231        | +13%               |
| Waste         | 3,054      | 3,397      | 3,382      | +0%                |

> **Insights:**  
> - Solar and Wind are the fastest-growing sources in Taiwan.  
> - Hydropower decreased in 2023 compared to 2016, likely due to water availability or operational adjustments.  
> - Geothermal has only started contributing recently.  
> - Biomass and Waste remain relatively stable.  

---

### 🔹 Seasonal Patterns

Seasonal variation differs by energy source:

- **Solar:** Peaks in summer months, lower in winter.  
- **Wind:** Peaks in winter months, moderate in other seasons.  
- **Hydropower:** Fluctuates with rainfall and water availability.  
- **Others (Geothermal, Biomass, Waste):** Minimal seasonal variation.

<img src="figures/seasonal_pattern_solar_wind.png" width="600">

> The plot highlights the average monthly generation (GWh) for Solar and Wind, with shaded areas representing standard deviation across years.  

---

### 🔹 Explore Interactive Results

For interactive exploration of seasonal and annual trends:

> 🌍 **Open the Shiny Dashboard:** [Click here](https://ling-yun-huang.shinyapps.io/interactiondashboard/)  

> 💡 **Dashboard Instructions:**  
> 1. Select a year range with the slider.  
> 2. Choose one or more energy sources.  
> 3. Explore annual trends and seasonal patterns.  
> 4. Compare energy sources using checkboxes.  

For a detailed guide with screenshots, see [Shiny Dashboard Instructions](Dashboard.md)

---

➡️ Next step: evaluate **forecasting models** using this historical data in [📈 Model Comparison](Model.md)  

[⬅ Back to R results](README.md) | [⬅ Back to Project Overview](../README.md)

