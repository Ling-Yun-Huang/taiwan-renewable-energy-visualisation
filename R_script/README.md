# ⚡ Taiwan Renewable Energy Forecast Project R Scripts

This project analyses and forecasts Taiwan’s renewable energy development from 2005 to 2025. It evaluates historical trends, assesses progress toward national targets, and compares forecasting models.

---

## 🗂 Project File Structure

**01_data_prep.R**  
- Data cleaning, merging, and reshaping to long format for analysis.

**02_EDA.R**  
- Exploratory Data Analysis (EDA)
- Visualises trends, seasonality, and annual comparisons.

**03_01_model_ETS.R**  
- Time-series forecasting using ETS models.

**03_02_model_ARIMA.R**  
- Time-series forecasting using ARIMA models.

**03_03_model_Prophet.R**  
- Time-series forecasting using Prophet models.

**04_validation.R**  
- Calculates model accuracy metrics (RMSE, MAPE).
- Generates comparison tables across models.

**05_forecast2025.R**  
- Forecasts energy generation for 2025 by energy type and total.  
- Computes renewable energy percentages with 95% confidence intervals.

**06_summary.R**  
- Consolidates results and generates summary tables and plots.  
- Combines historical data with 2025 forecasts for visualisation.

**07_InteractionDashboard.R**  
- Builds an interactive dashboard (Shiny or Observable JS).  
- Allows filtering by year, energy type, and forecasting model.

---

## 📜 License

This project is licensed under the **[MIT License](LICENSE)**.
