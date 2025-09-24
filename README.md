# **E-commerce Analysis**

**Author:** Divyansh Chawla  
**Date:** `24 September 2025`  

---

## Project Overview
This project analyzes e-commerce customer behavior to:

- **Increase revenue** by identifying high-value customers  
- **Reduce order cancellations**  
- Understand buying patterns across weekdays and weekends  
- Provide actionable recommendations to improve customer engagement  

The analysis includes:

1. Data cleaning and preprocessing  
2. Exploratory Data Analysis (EDA) with descriptive statistics  
3. Hypothesis testing  
4. Predictive modeling (logistic regression for high-value invoices)  
5. RFM (Recency, Frequency, Monetary) customer segmentation  
6. Visualization of key insights  

---

## Folder Structure
```Ecommerce_project/
├── code/                     # All R scripts for analysis
│   ├── 01_packages.R         # Package installation and loading
│   ├── 02_load_clean_data.R  # Data loading and cleaning
│   ├── 03_eda.R              # Exploratory Data Analysis
│   ├── 04_hypothesis_tests.R # Hypothesis testing (t-tests, chi-square)
│   ├── 05_modeling.R         # Predictive modeling (logistic regression)
│   └── 06_rfm_analysis.R     # RFM scoring and segmentation
│
├── data/                     # Dataset folder
│   ├── ecommerce-data.csv    # Full dataset (too large for GitHub preview)
│   └── ecommerce-sample.csv  # Sample dataset for GitHub preview
│
├── figures/                  # Generated plots and charts
│   ├── aov_hist.png
│   ├── aov_weekend_box.png
│   └── top10_countries_cancel.png
│
├── outputs/                  # Generated outputs like CSV summaries
│   └── rfm_summary.csv
│
├── analysis.Rmd              # Main RMarkdown file
├── analysis.pdf              # PDF report generated from RMarkdown
└── README.md                 # Project overview and instructions
```
## Notes
- The full dataset (ecommerce-data.csv) is too large to render on GitHub.
- A sample CSV (ecommerce-sample.csv) is included for testing and demonstration.
- All figures are generated from scripts and included in the PDF report.
## References
- Customer segmentation with RFM analysis
- Logistic regression and ROC/AUC for classification
- Tidyverse for reproducible data cleaning and visualization