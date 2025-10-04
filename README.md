# ⚡ Taiwan Renewable Energy Forecasting and Visualising

🏷️ **Tags:** `R` 📊, `JavaScript` 🌐, `Shiny` ✨

This project analyses and forecasts Taiwan’s renewable energy development, with particular emphasis on the **2016 energy policy reforms**. 

It combines **interactive visualisations** and **time-series forecasting** to help policymakers and stakeholders quickly understand trends, assess progress toward targets, and compare forecasting models.

> *“Explore Taiwan’s renewable energy journey from 2005 to 2025, and see how close we are to the 20% renewable energy goal.”*

---

## 🛠 Tools & Technologies

- **Observable** – Interactive visualisations (JavaScript) 🌐  
- **R** – Time-series forecasting, analysis, and plotting (ggplot2) 📊  
- **Shiny** – Interactive dashboard for exploration ✨

---

## 📈 Insights & Findings

- Renewable energy generation has **steadily increased**, with a **notable acceleration after 2016**.  
- **Solar energy** drives most of the growth, with **clear seasonal patterns** (higher in summer, lower in winter).  
- **Wind energy** shows gradual improvement, with **winter peaks**.  
- **Forecasting models** suggest that **reaching 20% by 2025 is unlikely**, but **2027 may be more realistic**.  


---

## 📚 Project Structure

For detailed analysis and results:

| Section                   | Description                                        | Tool       | Link                                                   |
| ------------------------- | -------------------------------------------------- | ---------- | ------------------------------------------------------ |
| 🔹 R results overview     | Summary tables and plots generated in R            | 🇷 `R`      | 📎 [Link](R_results/README.md)                         |
| 📊 Data Exploration (EDA) | Annual/seasonal patterns, key energy source trends | 🇷 `R`      | 📎 [Link](R_results/EDA.md)                            |
| 📈 Model Comparison       | ARIMA, ETS, Prophet and evaluation                 | 🇷 `R`      | 📎 [Link](R_results/Model.md)                          |
| 🔮 Forecasting Results    | 2025 & 2030 projections vs policy targets          | 🇷 `R`      | 📎 [Link](R_results/Forecast.md)                       |
| 🌍 Shiny Dashboard        | Interactive exploration                            | ✨ `Shiny`  | 📎 [Link](R_results/Dashboard.md)                      |
| 🔗 Observable Report      | Interactive visualisation in JavaScript            | 🌐 `JS`     | 📎 [Link](https://observablehq.com/d/13d921555879b756) |


---

## 🎨 Interactive Dashboard

- Built with **Shiny** (R)
- Select year range and energy sources to explore trends and seasonal patterns

> 🌍 **Try the Dashboard:** [Shiny App Link](https://ling-yun-huang.shinyapps.io/interactiondashboard/)

Detailed instructions: Learn how to interact with filters, view seasonal patterns, and interpret plots

> 📖 Dashboard Guide: [Shiny Dashboard](R_result/Dashboard.md)

---

## 🔍 Data

- **Source**: Taiwan’s [Open Data Platform](http://data.gov.tw/en)  
- **Coverage**: 2005–2024 (monthly)  
- **Features**: Power generation by energy source  
- **Processing**: Cleaned and prepared with Python; forecasting done in R  

---

## 🎓 About This Project

Part of the **Master’s in Data Science** program (*Data Visualisation* course) at **City, University of London** (2024), where it received a **Distinction**.  
Extended using R to provide **advanced forecasting and additional analysis**.  

---

## 📜 License

This project is licensed under the **[MIT License](LICENSE)**.
