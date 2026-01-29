-- Project: Global Layoffs Data Cleaning
-- Description: SQL script for cleaning and preparing layoff data for analysis

-- Started the project with the messy raw dataset with an initial total row count of 2361 records.
SELECT *
FROM layoffs;

SELECT COUNT(*) AS total_rows
FROM layoffs;

-- ===========================================================================
-- 0. Create Staging Table
--    Preserve raw data while performing cleaning operations
-- ============================================================================
CREATE TABLE layoffs_staging
LIKE layoffs;

INSERT INTO layoffs_staging
SELECT *
FROM layoffs;

-- ============================================================================
-- 1. Remove Duplicate Records
-- ============================================================================
/*
Duplicates are identified using ROW_NUMBER().
Partitioning is done across all relevant columns to avoid false duplicates.*/

# THE DUPLICATED ROWS HAVE row_num >1
SELECT *,
 ROW_NUMBER() OVER(
 PARTITION BY company,location, industry, total_laid_off, percentage_laid_off,`date`,stage, 
 country , funds_raised_millions) AS row_num
 FROM layoffs_staging;
 
 CREATE TABLE layoffs_staging2 (
company TEXT,
location TEXT,
industry TEXT,
total_laid_off INT DEFAULT NULL,
percentage_laid_off TEXT,
`date` TEXT,
stage TEXT,
country TEXT,
funds_raised_millions INT DEFAULT NULL,
row_num INT
);

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER (
PARTITION BY company, location, industry, total_laid_off,
percentage_laid_off, `date`, stage, country,
funds_raised_millions
) AS row_num
FROM layoffs_staging;

-- Remove duplicate rows
DELETE
FROM layoffs_staging2
WHERE row_num > 1;

#New reference table without duplicates
SELECT * FROM layoffs_staging2;

-- ============================================================================
-- 2. Standardize Data
-- ============================================================================
-- 2.1 Company names: remove leading/trailing spaces
SELECT company, TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

-- 2.2 Industry names: standardize variations
SELECT DISTINCT industry 
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- 2.3 Country names: remove trailing punctuation
SELECT DISTINCT country 
FROM layoffs_staging2;

SELECT DISTINCT country , TRIM(TRAILING '.' FROM country )
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

-- 2.4 Date column: convert text to DATE format
UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

-- ============================================================================
-- 3. Handle NULL and Blank Values
-- ============================================================================
SELECT * FROM layoffs_staging2;

-- Convert blank industry values to NULL
SELECT DISTINCT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = '';

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

/*
Populate missing industry values using other records
with the same company and location
*/
SELECT t1.industry,t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
    ON t1.company = t2.company
    AND t1.location = t2.location
    WHERE t1.industry is NULL 
    AND t2.industry IS NOT NULL;

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company = t2.company
AND t1.location = t2.location
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

-- ============================================================================
-- 4. Remove Unnecessary Rows and Columns
-- ============================================================================

/*
Rows where both total_laid_off and percentage_laid_off are NULL
provide no analytical value and are removed.
*/
SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
     AND percentage_laid_off IS NULL;
     
DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- Remove helper column used for duplicate identification
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;


-- ============================================================================
-- Final Cleaned Dataset
--With a total row count of 1995 records
-- ============================================================================

SELECT *
FROM layoffs_staging2;

Select Count(*)
From layoffs_staging2;
