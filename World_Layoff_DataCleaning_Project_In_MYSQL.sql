CREATE DATABASE World_Layoffs;
-- creating new database and importing data.
 SELECT * FROM
 layoffs;
 
-- Steps
-- 1.Remove duplicates
-- 2.Standardization
-- 3.Fix (or) remove null values
-- 4.remove unwanted rows and columns

-- 1.REMOVE DUPLICATES

-- Finding duplicate values using window function.
WITH Cte_duplicate as
(
SELECT *,
ROW_NUMBER() OVER(
	PARTITION BY company,industry,location,`date`,total_laid_off,percentage_laid_off,
    stage,country,funds_raised_millions
    ) AS row_num
FROM layoffs
)
SELECT * FROM
Cte_duplicate
WHERE row_num > 1;

-- Checking the value is really dupicated or not by taking one particular duplicated values.
SELECT * 
FROM layoffs
WHERE company = "Cazoo";

-- Creating a duplicate_table with row_number.And then delete the rows which has row number 2.
CREATE TABLE `layoffs_duplicated` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  row_num INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Insering values into new table with row_numbers.
INSERT INTO layoffs_duplicated
SELECT *,ROW_NUMBER() OVER(
	PARTITION BY company,industry,location,`date`,total_laid_off,percentage_laid_off,
    stage,country,funds_raised_millions
    ) AS row_num
FROM layoffs;
	
SELECT *
FROM layoffs_duplicated
ORDER BY row_num DESC;

-- deleting a duplicated row.
DELETE FROM
layoffs_duplicated
WHERE row_num > 1; 

-- 2.STANDARDIZE DATA

-- standardize a values in the company column by removing unwanted symbols
SELECT DISTINCT(company)
FROM layoffs_duplicated;

SELECT DISTINCT TRIM(BOTH " " FROM(TRIM(BOTH "&" FROM(TRIM(BOTH "#" FROM(TRIM(BOTH "." FROM company)))))))-- if you want to remove those characters from end of the string then use trailing.
FROM layoffs_duplicated;

-- Based on the above query we are going to update the column values
UPDATE layoffs_duplicated
SET company = TRIM(BOTH " " FROM(TRIM(BOTH "&" FROM(TRIM(BOTH "#" FROM(TRIM(BOTH "." FROM company)))))));

-- country column
SELECT DISTINCT(country) 
FROM layoffs_duplicated;

-- romoving spaces and . from country column
UPDATE layoffs_duplicated
SET country = TRIM(BOTH "." FROM TRIM(BOTH " " FROM country));

-- industry column
SELECT DISTINCT(industry)
FROM layoffs_duplicated
ORDER BY 1;

-- there is same industry has three names Crypto,Crypto Currency,CryptoCurrency.
-- Changing the this industry into on linke crypto
UPDATE 
layoffs_duplicated
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- Also converting a empty spaces into actual null values.
UPDATE
layoffs_duplicated
SET industry = NULL 
WHERE industry = '';

-- if there is same company and one field is null and another one is null so based on the same company we fill the industry.

SELECT company,industry
FROM layoffs_duplicated
WHERE industry IS NULL
ORDER BY 1;

-- Checking the company has a industry in another rows.
SELECT company,industry
FROM layoffs_duplicated
WHERE company like "Airbnb%";

-- using join updating a null in industry if same company has industry name.
SELECT t1.company,t1.industry,t2.company,t2.industry
FROM layoffs_duplicated AS t1
JOIN layoffs_duplicated AS t2
ON t1.company = t2.company
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

-- Now update the company with industry that found using join.
UPDATE layoffs_duplicated AS t1
JOIN layoffs_duplicated AS t2
ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

-- date column
-- it is in text format we have to convert it into date format that is usefull for timeseries anlaysis.
-- first changing the format of the string that suitable to convert into data type.

SELECT str_to_date(`date`,'%m/%d/%Y')
FROM layoffs_duplicated;

UPDATE layoffs_duplicated
SET `date` = str_to_date(`date`,'%m/%d/%Y');

-- now conerting the entire column into datetime format.
ALTER TABLE layoffs_duplicated
MODIFY COLUMN `date` DATE;

-- 3.REMOVE NULL VALUED COLUMN
-- When both total_laid_off and percentage_laid_off are null then we have to remove that row beacuse without that the data is useless.

SELECT *
FROM layoffs_duplicated
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE FROM layoffs_duplicated
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- 4.REMOVING UNWANTED COLUMNS
-- now we don't need row number column so we are going to drop that column.

ALTER TABLE layoffs_duplicated
DROP COLUMN row_num;
