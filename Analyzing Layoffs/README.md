# Layoffs Analysis Data Cleaning Project

## Overview
This project involves cleaning a real-world dataset related to layoffs using SQL. The goal is to ensure data consistency, remove duplicates, standardize values, and handle missing data.

## Steps Followed

### Data Preparation
- Used `new_layoffs` table as the source dataset.
- Created a staging table (`layoffs_staging`) to avoid modifying raw data.
- Inserted data from `new_layoffs` into `layoffs_staging`.

### Removing Duplicates
- Used window functions to identify duplicates.
- Created `layoffs_staging2` to store cleaned data.
- Removed duplicate rows where `row_num > 1`.

### Standardizing Data
- Trimmed spaces from `company` column.
- Standardized industry names (e.g., merged variations of `Crypto` into one category).
- Corrected inconsistencies in `country` column (e.g., `United States.` to `United States`).

### Formatting Date Column
- Converted `date` column to proper `DATE` format using `STR_TO_DATE`.
- Altered the column type to `DATE` for consistency.

### Handling Missing Values
- Identified and updated missing values in `industry` column using self-joins.
- Removed rows where both `total_laid_off` and `percentage_laid_off` were `NULL`.

### Finalizing Cleaned Dataset
- Created `layoffs_staging3` to store cleaned data.
- Ensured no duplicate records exist.
- Dropped unnecessary columns (`rnumber` and `row_num`).

## Result
The final cleaned dataset (`layoffs_staging3`) is well-structured, free of duplicates, standardized, and ready for analysis.

## Some of the results from Data Analysis

- The top three companies that laid off the maximum number of people in a single day were Google with 12000, Meta with 11000 
  and Amazon with 10000. While Amazon had maximum layoffs in the period from 2020 to 2023 compared to Meta and Google.
- The industries that were affected the most were the Consumer followed by the Retail industries.
- The countries which faced the massive layoffs were the United States with a whooping 256 thousand jobs followed by India 
  with almost 36 thousand jobs. The third country which faced the massive layoff was the Netherlands with 17000. 
- The year with the highest number of layoffs was 2022 with over 160 thousand. But the year 2023 could be worse as till 
  April the total number of layoffs were around 125 thousand.
- We can also see that most of the layoffs were from the POST-IPO stage of the companies while the other stages of the 
  companies down the line which suffered from job losses were Acquisitions, Series A etc.
- Able to show month by month progression of the layoff by using the window function.


