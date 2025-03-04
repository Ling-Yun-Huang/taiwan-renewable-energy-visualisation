# 🌱 Taiwan's Renewable Energy Progress (2005–2023)  

🌍 **Interactive Visualizations & Full Report**: [🔗 Observable Report](https://observablehq.com/d/13d921555879b756)  

## 1. Research Questions  

In 2016, Taiwan set a goal for **renewables to generate 20% of total power by 2025**. This report explores:  

1. How has Taiwan's renewable energy evolved, especially before and after 2016?  
2. With two years left, is achieving the 2025 target realistic?  

## 2. Data & Visualization  

Data from Taiwan’s **[Open Data Platform](http://data.gov.tw/en)** (2005–2023) was cleaned and analyzed using **Python**.  

*For figures, visit [Observable Report](https://observablehq.com/d/13d921555879b756).*  

## 3. Key Insights  

### **Renewable Energy Growth (Figure 1-1)**  
- Renewable power generation has **steadily increased**, with **faster growth after 2016**.  
- **Solar energy** leads this growth, followed by wind.  

### **Solar & Wind Energy Trends (Figure 1-2)**  
- **Solar** surged after 2016, showing a **seasonal pattern** (higher in summer).  
- **Wind** grew **slowly**, peaking in winter.  
- **Government incentives** accelerated **solar expansion** due to lower installation barriers.  

### **2025 Projections (Figure 2)**  
- **Linear Regression** predicts **~15% renewables** by 2025 (95% CI: **9.2%–10.7%**).  
- **Polynomial Regression** suggests **13.8%–16.2%**, with a **higher chance of hitting 15%**.  
- **Conclusion:** The **20% goal is unlikely by 2025** but achievable by **2027** with continued support.  

## 4. Design Choices  

Following Corum’s ["See, Think, Design, Produce"](http://style.org/stdp3/) approach:  

- **Stacked area charts & line charts** balance **overview** and **detailed trends**.  
- **Small multiples visualization** highlights **solar & wind seasonality**.  
- **Regression models** encourage **critical interpretation** of future trends.  

## 5. Validation & Limitations  

- **Bias risks**: Focus on solar/wind may overlook hydropower’s role.  
- **Stacked charts** emphasize growth but may **mask setbacks**.  
- **Y-axis scaling** differences could **distort perception**, but post-2016 acceleration remains clear.  

This analysis integrates **data-driven insights** with **effective visualization strategies**, ensuring a clear understanding of Taiwan’s renewable energy progress.
