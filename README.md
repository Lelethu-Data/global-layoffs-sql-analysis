# Global Layoffs Data Cleaning, EDA & Excel Dashboard
# Project Overview

This project analyzes global layoff data to uncover trends across industries, countries, company stages, and time between 2020-03-11 and 2023-03-06. The analysis was performed using MySQL for data cleaning, exploratory data analysis, and Excel for interactive visualization, demonstrating an end-to-end data analytics workflow.

# Tools
- MySQL – Data cleaning and exploratory analysis
- Excel – Interactive dashboard and visualization
- Power Query – Data transformation and data type enforcement
- PivotTables, Slicers, and Timeline – Interactive filtering

# Data Preparation
- Removed duplicates and standardized text fields
- Handled missing and null values
- Converted date and numeric fields to correct data types
- Exported cleaned data from MySQL and finalized transformations in Excel using Power Query

# Exploratory Analysis
The analysis focused on:
- Total layoffs by company, industry, and country
- Companies with 100% workforce layoffs
- Layoff trends over time (monthly and yearly)
- Cumulative (rolling) layoffs
- Layoffs by company stage

# Excel Dashboard
<img width="640" height="321" alt="Screenshot_Global layoffs Excel Interactive Dashboard" src="https://github.com/user-attachments/assets/53b2f359-3aae-4db5-ad79-305b89ccce3f" />

- An interactive Excel dashboard was created featuring:
- Layoffs by industry and country
- Time-based trend analysis
- Company stage comparison
- Slicers and a timeline for dynamic exploration

# Key Insights
- The Consumer industry experienced the highest number of layoffs globally.
- The United States recorded the largest share of total layoffs.
- Layoffs peaked in 2022 with a total of 160,661, compared to 80,998 in 2020 during the COVID outbreak and 15,823 in 2021, the lowest year.
- The top three companies with the highest layoffs were Amazon (18,150), Google (12,000), and Meta (11,000).
- Companies in the Post-IPO stage accounted for the highest layoffs, totaling 204,132.
- Several companies laid off 100% of their workforce, highlighting the severity of the impact in certain cases.

# Next Steps
- Rebuild the dashboard in Power BI to enable more interactive and scalable reporting
- Automate data refresh to support ongoing analysis as new data becomes available
- Introduce advanced KPIs to track workforce impact and trends over time
