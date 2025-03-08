-- here we are going to solve some complex problems using SQL Queries

use casestudy_paintings;
-- 1) Fetch all the paintings which are not displayed on any of the museums

select name from work where museum_id is null;

-- 2) Are there any museums without any paintings ?

select * from work;

-- 3) How many paintings have an asking price of more than their regular price ?

select count(*) from product_size 
where sale_price > regular_price;

-- 4) Identify the paintings whose asking price is less than 50% of its regular price

select * from product_size where 
sale_price < 0.5 * regular_price;

-- 5) Which canva size costs the most ?

select cs.size_id, regular_price, sale_price from canvas_size cs 
join product_size ps on 
cs.size_id = ps.size_id 
order by sale_price desc limit 1;

-- 6) Delete duplicate records from work, product_size, subject and image_link tables

WITH duplicate_cte AS (
    SELECT work_id, 
           ROW_NUMBER() OVER (PARTITION BY work_id, name, artist_id, style, museum_id) AS rn
    FROM work
)
DELETE FROM work 
WHERE work_id IN (SELECT work_id FROM duplicate_cte WHERE rn > 1);


with duplicate_cte as 
(
select *, row_number() over (partition by work_id, size_id, sale_price, regular_price)
as rnumber from product_size
) delete from product_size where (work_id, size_id, sale_price, regular_price)
in (select work_id, size_id, sale_price, regular_price from duplicate_cte where rnumber>1);

-- now deleting the duplicate rows using the subquery
delete from subject where (work_id, `subject`) in 
(select work_id, `subject` from (select *, 
row_number() over (partition by work_id, `subject`) as rnumber from subject)
as subquery where rnumber > 1);

with duplicate_table as (
select *, row_number() over (partition by work_id, url, thumbnail_small_url,
thumbnail_large_url) as rnumber from image_link)
delete from image_link where (work_id, url, thumbnail_small_url,
thumbnail_large_url) in (select work_id, url, thumbnail_small_url,
thumbnail_large_url from duplicate_table where rnumber > 1);



-- 7) Identify the museums with invalid city information in the given dataset

SELECT * FROM museum 
WHERE city ~ '^[0-9]';

-- 8) Museum_hours has one invalid entry. Identify it and remove it

select * from museum_hours;

-- 9) Fetch the top 10 most famous painting subject

select subject, count(*) as famous from subject
group by subject order by famous desc limit 10;

-- 10) Identify the museums which are open on both Sunday and Monday. Display museum name and city.

-- 11) How many museums are open every single day ?

with new_table as 
( select *, row_number() over (partition by museum_id) as number_of_days
from museum_hours)
select museum_id from new_table where number_of_days = 7;

-- 12) Which are the top 5 most popular museum? (Popularity is defined based on the most
-- number of paintings in a museum)

with new_cte as 
( select m.museum_id, m.`name` as museum_name, work_id, w.`name` as work_name from museum m
left join `work` w on 
m.museum_id = w.museum_id
) ,  new_cte_2 as 
( select *, row_number() over (partition by museum_id) as num_paintings
from new_cte 
) select museum_name, max(num_paintings) from new_cte_2
group by museum_name order by max(num_paintings) desc limit 5 ; 


 