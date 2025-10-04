## 📊 Key R Results

These results summarise Taiwan’s renewable energy trends and forecasts based on R analysis and modelling.

---

### 🔹 Annual Renewable Energy Generation (2005–2023)

<img src="figures/annual_all_source.png" width="600">

| Energy Source | 2005 (GWh) | 2016 (GWh) | 2023 (GWh) | Growth (2016→2023) |
|---------------|------------|------------|------------|------------------|
| Solar         | 0.96       | 1,109      | 12,909     | +1064%           |
| Wind          | 91.3       | 1,457      | 6,201      | +326%            |

> This table highlights the two fastest-growing renewable sources.  
> Full details (all sources + seasonal patterns) are available in [EDA.md](EDA.md).
---

### 🔹 Time-Series Models Comparison


---

### 🔹 Forecasts for 2025

| Energy Source | Forecast 2025 (GWh) | Contribution to Total (%) |
|---------------|-------------------|---------------------------|
| Solar         | 14,200            | 45%                       |
| Wind          | 9,100             | 29%                       |
| Others        | 5,500             | 17%                       |

> Forecasts generated using **ARIMA** (the best model choose above) in R.  
> Based on trends, Taiwan is unlikely to reach the **20% renewable energy target by 2025**, but 2027 may be realistic.

---

### 🔹 Explore Interactive Results

For interactive charts and seasonal exploration:

> 🌍 [Open Shiny Dashboard](https://ling-yun-huang.shinyapps.io/interactiondashboard/)
