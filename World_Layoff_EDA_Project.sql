-- EDA

SELECT *
FROM layoffs_duplicated;

-- Looking at who laid off most
SELECT MAX(total_laid_off)
FROM layoffs_duplicated;

SELECT MAX(total_laid_off),MIN(total_laid_off)
FROM layoffs_duplicated
WHERE total_laid_off IS NOT NULL;

-- taking the companies which laid off all the employees.
SELECT * 
FROM layoffs_duplicated
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- companies with single hikghest laid off
SELECT company,total_laid_off,percentage_laid_off,YEAR(`date`) AS year
FROM layoffs_duplicated
ORDER BY total_laid_off DESC
LIMIT 5;

-- Companies that laid off most in total
SELECT company,SUM(total_laid_off)
FROM layoffs_duplicated
GROUP BY company
ORDER BY 2 DESC
LIMIT 10;

-- highest number of laid off based on the location 
SELECT location,SUM(total_laid_off)
FROM layoffs_duplicated
GROUP BY location
ORDER BY SUM(total_laid_off) DESC;

-- Total laid off based on country
SELECT country,SUM(total_laid_off)
FROM layoffs_duplicated
GROUP BY country
ORDER BY SUM(total_laid_off) DESC;

-- total laid off based on year
SELECT YEAR(`date`) AS `year`,SUM(total_laid_off)
FROM layoffs_duplicated
WHERE `date` IS NOT NULL
GROUP BY `year`
ORDER BY SUM(total_laid_off) DESC;

-- total laid off based on industry
SELECT industry,SUM(total_laid_off)
FROM layoffs_duplicated
GROUP BY industry
ORDER BY SUM(total_laid_off) DESC;

-- total laid off based on stage
SELECT stage,SUM(total_laid_off)
FROM layoffs_duplicated
GROUP BY stage
ORDER BY SUM(total_laid_off) DESC;


-- total laid off based on each month
SELECT MONTH(`date`) as `month`,SUM(total_laid_off)
FROM layoffs_duplicated
GROUP BY `month`
ORDER BY SUM(total_laid_off) DESC;

-- for each year based on the company which laif_off most we are going to rank them.
WITH laid_off_company_year AS
(
SELECT company,YEAR(`date`) AS `year`,SUM(total_laid_off) as total_laid_off
FROM layoffs_duplicated
GROUP BY company,`year`
ORDER BY total_laid_off DESC
)
,company_rank AS
(
SELECT company,`year`,total_laid_off,
DENSE_RANK() OVER(PARTITION BY `year` ORDER BY total_laid_off DESC) AS ranking
FROM laid_off_company_year
)
SELECT * 
FROM company_rank
WHERE ranking <= 5 AND `year` IS NOT NULL;


-- ROLLING TOTAL_LAID_OFF BASED ON MONTH
WITH rolling_sum AS
(
SELECT SUBSTRING(`date`,1,7) AS dates,SUM(total_laid_off) as total_laid_off
FROM layoffs_duplicated
GROUP BY dates
ORDER BY dates ASC
)
SELECT dates,total_laid_off,SUM(total_laid_off) OVER(ORDER BY dates) as rolling_total
FROM rolling_sum
WHERE dates IS NOT NULL
ORDER BY dates;


-- Calculatiing a rolling total for india

WITH rolling_india_total AS 
(
SELECT country,SUBSTRING(`date`,1,7) AS dates,SUM(total_laid_off) as total_laid_off
FROM layoffs_duplicated
WHERE country = "India"
GROUP BY dates
ORDER BY dates
)
SELECT country,dates,total_laid_off,
SUM(total_laid_off) OVER(ORDER BY dates) AS rolling_total
FROM rolling_india_total;