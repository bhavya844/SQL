# here, we are performing the data analysis (Exploratory Data Analysis)

use world_layoffs;

# checking the range of the date for the dataset
select max(`date`), min(`date`) from layoffs_staging3;

# companies which have laid of the amximum number of people in a single day
select company, total_laid_off from layoffs_staging3 order by total_laid_off desc;

# comapnies which have laid of 100% of the employees
select company, percentage_laid_off from layoffs_staging3 order by 
percentage_laid_off desc;

# companies which have had the highest total number of layoffs
select * from layoffs_staging3 
where percentage_laid_off = 1 order by total_laid_off desc;

# total laid off based group by the companies
select company, sum(total_laid_off) as total_sum from layoffs_staging3
group by company order by total_sum desc;

# seeing which industries got really hard considering the layoffs
select industry, sum(total_laid_off) as total from layoffs_staging3
group by industry order by total desc;

select country, sum(total_laid_off) as total from layoffs_staging3
group by country order by total desc;

select year(`date`), sum(total_laid_off) total from layoffs_staging3
group by year(`date`) order by total desc;

select distinct month(`date`) from layoffs_staging3
where year(`date`) = 2023;

select stage, sum(total_laid_off) total from layoffs_staging3
group by stage order by total desc;

select * ,  
sum(total_laid_off) over(partition by `date` ) as rolling_count
from layoffs_staging3
where country = "United States" 
order by `date` desc; 

# getting the number of layoffs each month
select substring(`date`, 1,7) as `year and month`, sum(total_laid_off) as total from layoffs_staging3
where substring(`date`,1,7) is not null
group by substring(`date`,1,7) order by substring(`date`,1,7) asc;

# for the rolling total, we can create a cte
with rolling_total as (
select  substring(`date`, 1,7) as `year and month`, sum(total_laid_off) as total from layoffs_staging3
where substring(`date`,1,7) is not null
group by `year and month` order by substring(`date`,1,7) asc
)
select `year and month`,total, sum(total) over (order by `year and month`) as rolling_total
from rolling_total;
 
 
 #  ranking the companies based on the layoffs in each year
 select company, year(`date`), sum(total_laid_off) as total
 from layoffs_staging3
 group by company, year(`date`)
 order by total desc;
 
 
 # getting the companies based on the rank of layoffs per year
 with company_year (company, years, total) as (
  select company, year(`date`), sum(total_laid_off)
  from layoffs_staging3
  group by company, year(`date`)
 ), company_year_rank as (
 select *, dense_rank() over (partition by years order by total desc) as `rank`
 from company_year
 where years is not null)
 select * from company_year_rank
 where `rank` <= 5;
 
 