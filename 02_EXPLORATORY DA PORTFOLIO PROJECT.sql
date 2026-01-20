-- Project: Global Layoffs Exploratory Data Analysis
-- Author: Lelethu Bala
-- Description: Exploratory data analysis (EDA) of cleaned global layoffs data
-- Dataset: layoffs_staging2 (cleaned table)

/* ============================================================================
EXPLORATORY DATA ANALYSIS OVERVIEW
----------------------------------------------------------------------------
This script explores global layoff trends using SQL. The goal is not to
answer a single predefined question, but to understand patterns, trends,
and distributions within the data.

```
Focus areas:
- Layoff magnitude (total and percentage)
- Industry and country impact
- Time-based trends
- Company and stage-level analysis
============================================================================ */


-- ============================================================================
-- 1. Dataset Overview
-- ============================================================================

-- Total number of records in the dataset
SELECT COUNT(*) AS total_records
FROM layoffs_staging2;

-- Date range of the dataset
SELECT
MIN(`date`) AS start_date,
MAX(`date`) AS end_date
FROM layoffs_staging2;

-- ============================================================================
-- 2. Layoff Magnitude Analysis
-- ============================================================================

-- Maximum number of employees laid off in a single event
SELECT MAX(total_laid_off) AS max_laid_off
FROM layoffs_staging2;

-- Maximum total layoffs and maximum percentage laid off
SELECT
MAX(total_laid_off) AS max_total_laid_off,
MAX(percentage_laid_off) AS max_percentage_laid_off
FROM layoffs_staging2;

-- Companies that laid off 100% of their workforce
SELECT company, location, total_laid_off, percentage_laid_off
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

-- ============================================================================
-- 3. Company-Level Analysis
-- ============================================================================

-- Total layoffs by company
SELECT
company,
SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY company
ORDER BY total_laid_off DESC;

-- ============================================================================
-- 4. Industry and Country Analysis
-- ============================================================================

-- Total layoffs by industry
SELECT
industry,
SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY industry
ORDER BY total_laid_off DESC;

-- Total layoffs by country
SELECT
country,
SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY country
ORDER BY total_laid_off DESC;

-- ============================================================================
-- 5. Company Stage Analysis
-- ============================================================================

-- Total layoffs by company stage
SELECT
stage,
SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY stage
ORDER BY total_laid_off DESC;

-- ============================================================================
-- 6. Time-Series Analysis
-- ============================================================================

-- Layoffs by individual date
SELECT
`date`,
SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY `date`
ORDER BY `date` DESC;

-- Layoffs by year
SELECT
YEAR(`date`) AS year,
SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY total_laid_off DESC;

-- ============================================================================
-- 7. Monthly Trends and Rolling Total
-- ============================================================================

-- Monthly layoffs (YYYY-MM format)
SELECT
DATE_FORMAT(`date`, '%Y-%m') AS month,
SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY month
ORDER BY month ASC;

/*
Rolling total explanation:

* Aggregates layoffs by month
* Calculates a cumulative sum over time
* Shows progression of total layoffs across months
  */

WITH rolling_total_cte AS (
SELECT
DATE_FORMAT(`date`, '%Y-%m') AS month,
SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY month
)
SELECT
month,
total_laid_off,
SUM(total_laid_off) OVER (ORDER BY month) AS rolling_total
FROM rolling_total_cte
ORDER BY month ASC;

-- ============================================================================
-- End of Exploratory Data Analysis
-- ============================================================================
