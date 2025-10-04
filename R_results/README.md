## 📊 Key R Results

These results summarise Taiwan’s renewable energy trends and forecasts based on R analysis and modelling.

---

### 🔹 Annual Renewable Energy Generation (2005–2023)

| Energy Source | 2005 (GWh) | 2016 (GWh) | 2023 (GWh) | Growth (2016→2023) |
|---------------|------------|------------|------------|------------------|
| Solar         | 0.96       | 1,109      | 12,909     | +1064%           |
| Wind          | 91.3       | 1,457      | 6,201      | +326%            |
| Hydropower    | 4,071      | 6,562      | 3,963      | -40%             |
| Geothermal    | 0          | 0          | 23.2       | ---              |
| Biomass       | 323        | 205        | 231        | +13%             |
| Waste         | 3054       | 3397       | 3382       | +0%              |

> Generated with R using `dplyr` summarisation.

![Annual_trend_all_plot](figure/annual_all_source.png)

---

### 🔹 Seasonal Pattern Example (Solar 2016–2023)

![Solar Seasonal Pattern](output/solar_seasonal.png)

> The plot shows monthly averages with standard deviation ribbons. Clear seasonal patterns appear, with higher generation in summer months.

---

### 🔹 Forecasts for 2025

| Energy Source | Forecast 2025 (GWh) | Contribution to Total (%) |
|---------------|-------------------|---------------------------|
| Solar         | 14,200            | 45%                       |
| Wind          | 9,100             | 29%                       |
| Hydro         | 5,500             | 17%                       |
| Other Renewables | 2,000          | 9%                        |
| **Total**     | 30,800            | 100%                      |

> Forecasts generated using **ETS, ARIMA, and Prophet** models in R.  
> Based on trends, Taiwan is unlikely to reach the **20% renewable energy target by 2025**, but 2027 may be realistic.

---

### 🔹 Explore Interactive Results

For interactive charts and seasonal exploration:

> 🌍 [Open Shiny Dashboard](https://ling-yun-huang.shinyapps.io/interactiondashboard/)
