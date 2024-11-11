-- Exploratory Data Analysis on World Layoffs

SELECT * 
FROM layoffs_staging2;

-- Exploring the Data in Different Ways

# Max number of laid off and MAX percentage of laid off in the Data
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

# View all percentage laid off that is equal to 1 (which means 100% of employees were laid off) and their fund raised millions in descending order
SELECT * 
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

# Sum of total laid off for each company by descending order of the most laid off to the least by companies
SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

# Earliest and Latest date of starting laid off in this Data
SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

# Viewing the total of each industry that laid off employees by descending order from most to least
SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

# Viewing the total of each country that laid off employees by descending order from most to least
SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

# Viewing the total of each year that laid off employees by descending order from most to least
SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

# Viewing the total of each stage that laid off employees by descending order from most to least
SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

# Viewing the average of each company that had a percentage laid off employees by descending order from most to least (this wasn't as helpful)
SELECT company, AVG(percentage_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

# Looking at the sum of layoffs per month using Substrings
SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC;

# Look at the total layoffs using Rolling Total (good to see the total of all laid off since 2020) using the substring
WITH Rolling_Total AS
(
	SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS total_off
	FROM layoffs_staging2
	WHERE SUBSTRING(`date`,1,7) IS NOT NULL
	GROUP BY `MONTH`
	ORDER BY 1 ASC
)
SELECT `MONTH`, total_off, SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;

# View companies by the year of which they laid off the most employee
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

# 2 cte; Rank how many employees were laid off per year and what companies laid off the most employees (Top 5 companies each year)
WITH Company_Year (company, years, total_laid_off) AS
(
	SELECT company, YEAR(`date`), SUM(total_laid_off)
	FROM layoffs_staging2
	GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS
(
	SELECT *, DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
	FROM Company_Year
	WHERE years IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <= 5
;



