# 🛠 R Scripts for Taiwan Renewable Energy Forecast Project

This folder contains the R scripts used in the project, covering data preparation, exploratory analysis, time-series forecasting, and model evaluation.

---

## 🗂 Files Structure
| Script               | Description |
|-----------------------|-------------|
| **01_data_prep.R**    | Data cleaning, merging, and reshaping to long format for analysis. |
| **02_EDA.R**          | Exploratory Data Analysis (EDA). <br>Visualises trends, seasonality, and annual comparisons. |
| **📌 Models**         |---    |
| **03_01_model_ETS.R** | Time-series forecasting using ETS models. |
| **03_02_model_ARIMA.R** | Time-series forecasting using ARIMA models. |
| **03_03_model_Prophet.R** | Time-series forecasting using Prophet models. |
| **04_validation.R**   | Calculates model accuracy metrics (RMSE, MAPE). <br>Generates comparison tables across models. |
| **05_forecast2025.R** | Forecasts energy generation for 2025 by energy type and total. <br>Computes renewable energy percentages with 95% confidence intervals. |
| **06_summary.R**      | Consolidates results and generates summary tables and plots. <br>Combines historical data with 2025 forecasts for visualisation. |
| **07_InteractionDashboard.R** | Builds an interactive dashboard (Shiny or Observable JS). <br>Allows filtering by year, energy type, and forecasting model. |


---

### 📜 License

This project is licensed under the **[MIT License](LICENSE)**.
