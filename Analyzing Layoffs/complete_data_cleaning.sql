# here we are going to perform a project which involves data cleaning by using 
# a real world dataset

use world_layoffs;

select * from new_layoffs;

# there are a few steps that we are going to follow for this data cleaning process
-- 1. Firstly, we are going to remove any duplicates that are present in the data
-- 2. Then we are going to perform the standardization on the data
-- 3. Remove the Null values or blank values that are present in the data
-- 4. Remove any columns which have high number of missing values as they might not be benficial for performing the inference in the future

# we can create a staging table when performing these procedures. the reason we are doing this is because we are going
# change the staging the database a lot. if we are making some mistake, we always want the raw data to be available so that we can revert back

create table layoffs_staging like new_layoffs;

#here we are inserting all the rows from the new_layoffs into the staging dataset that we have created
insert layoffs_staging select * from new_layoffs;

# let us get started with removing duplicates.
# for this we can use the window functions to get the row number for each unique element and then can 
# remove the duplicates where the row number are more than 2

with duplicate_cte as (
select * , row_number() over(partition by company, location, industry, total_laid_off, 
percentage_laid_off, `date`, stage, country, funds_raised_millions) as rnumber from layoffs_staging
)
delete from duplicate_cte where rnumber > 1;

# create new staging table where we can store the data and then remove the rnumber >2

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

# now let us insert the information from the cte into the new staging table so that we can delete the rnumber which are greated than 1

insert into layoffs_staging2 
select *, row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off,
`date`, stage, country, funds_raised_millions) as rnumber from layoffs_staging;

select * from layoffs_staging2 where row_num > 1;

delete from layoffs_staging2 where row_num > 1;

# now we can start with standardizing the data 

select company, trim(company) from layoffs_staging2; 

# updating the company column by trimming it 
update layoffs_staging2 set company = trim(company);

select distinct(industry) from layoffs_staging2 where industry like '%Crypto%';

# updating the different occurences of the Crypto (i.e. Crypto, Crypto Currency and 
# CryptoCurrency) with one Crypto
update layoffs_staging2 set industry = 'Crypto' 
where industry like '%Crypto%';

select distinct(industry) from layoffs_staging2 order by industry ; 

# now let us look at the location for the further process
select distinct location from layoffs_staging2 order by location ;

select distinct location, count(location) from layoffs_staging2
group by location order by count(location) desc;

#now let us look at the country column as the location column looks fine
select distinct(country) from layoffs_staging2 order by country; 

update layoffs_staging2 
set country = 'United States' where country ='United States.';

select distinct(country) from layoffs_staging2 order by country desc;

# we can also solve the above problem using (trailing '.' from country) 

# now, we have to set the date column to the correct format as it is not in a correct format
select date, str_to_date(`date`, '%m/%d/%Y') from layoffs_staging2 ; 
update layoffs_staging2 
set `date` = str_to_date(`date`, '%m/%d/%Y');

select *, row_number() over (partition by company, location, industry,
total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as rnumber
 from layoffs_staging2;
 
 select * from layoffs_staging2;
 
 select count(*) from layoffs_staging2 where `rnumber` > 1;
 
 CREATE TABLE `layoffs_staging3` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int,
  `rnumber` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
 
 select * from layoffs_staging3;
 
 insert into layoffs_staging3
select *, row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off,
`date`, stage, country, funds_raised_millions) as rnumber from layoffs_staging2;
 
 # creating another layoffs_staging3 with non-duplicate entries as just observed that
 # entries in the layoffs_staging2 were duplicate
INSERT INTO layoffs_staging3 
(company, location, industry, total_laid_off, percentage_laid_off, `date`, 
 stage, country, funds_raised_millions, row_num, rnumber)
SELECT company, location, industry, total_laid_off, percentage_laid_off, `date`, 
       stage, country, funds_raised_millions, 
       ROW_NUMBER() OVER (PARTITION BY company, location, industry, 
                          total_laid_off, percentage_laid_off, `date`, 
                          stage, country, funds_raised_millions) AS row_num,
       ROW_NUMBER() OVER (PARTITION BY company, location, industry, 
                          total_laid_off, percentage_laid_off, `date`, 
                          stage, country, funds_raised_millions) AS rnumber
FROM layoffs_staging2;

select * from layoffs_staging3;
delete from layoffs_staging3 where rnumber>1;

SELECT 
    (SELECT COUNT(DISTINCT row_num) FROM layoffs_staging3) AS distinct_row_num,
    (SELECT COUNT(DISTINCT rnumber) FROM layoffs_staging3) AS distinct_rnumber;

# now we have the updated dataset which is the layoffs_staging3

select distinct(`date`) from layoffs_staging3 order by `date` ;

# we are chaning the datatype for the column date. in the MySQL it is modify while in the SQL server we can use alter instead of modify.
alter table layoffs_staging3
modify column `date` date;

# now let us perform some more data cleaning by checking for nulls in the database
select * from layoffs_staging3 where total_laid_off is null
and percentage_laid_off is null;


# we can try to fill the missing values in the column industry by checking the related columns
select * from layoffs_staging3 where industry is null or industry = '';

# checking for airbnb
select * from layoffs_staging3 where company = 'Juul';

# updating the industry with travel where the company name is Airbnb, this is a manual way and can be automated using self joins
update layoffs_staging3 
set industry = 'Travel' where company ='Airbnb' and industry = '';

update layoffs_staging3 
set industry = Null where industry = ''; 

# doing using self joins
select s1.industry, s2.industry from layoffs_staging3 s1
join layoffs_staging3 s2
on s1.company = s2.company
where (s1.industry is null or s1.industry = '') and s2.industry is not null;


# now let us fill the columns
update layoffs_staging3 s1
join layoffs_staging3 s2
on s1.company = s2.company
set s1.industry = s2.industry
where (s1.industry is null or s1.industry = '') and s2.industry is not null;

delete from  layoffs_staging3 
where total_laid_off is null and percentage_laid_off is null ;

alter table layoffs_staging3
drop column rnumber,
drop column row_num;



