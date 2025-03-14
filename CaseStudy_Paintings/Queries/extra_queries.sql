-- continuation of queries further

-- 13) Who are the top 5 most popular artist? 
-- (Popularity is defined based on most no of paintings done by an artist)

-- this is a similar to question 12. let us solve it

with new_cte as 
( select a.artist_id , full_name,  `name` from artist a
right join work w
on w.artist_id = a.artist_id
), new_cte_2 as 
( select *, row_number() over (partition by artist_id) as pop_num
from new_cte
) select full_name, max(pop_num) as max_num from new_cte_2
group by full_name order by max_num desc limit 5;

-- 14) Display the least 3 popular canva sizes

select * from canvas_size where size_id in 
(select size_id from (select size_id, count(size_id) from product_size
group by size_id order by count(size_id) asc limit 4) as subquery); 

-- 15) Which museum is open for longest during a day ? Display museum name, state and hours
-- open and which day ?

select * from museum_hours;
select *, substring(`open`, 1,5) - substring(`close`,1,5) from museum_hours;
select *, (time(`open`)- time(`close`)) as hours_open from museum_hours;

-- 16) Which museum has the most number of popular painting style ?
with new_cte as (select m.`name`, w.museum_id, style from museum m
right join `work` w
on m.museum_id = w.museum_id where w.museum_id is not null and style is not null
) , new_cte_2 as (select style, count(style) from new_cte
group by style order by count(style) desc limit 1)
select new_cte.`name`, style, count(*) as counts from new_cte
where style in (select style from new_cte_2) 
group by new_cte.`name`, style  
order by counts desc limit 1;

-- 17) Identify the artists whose paintings are displayed in multiple countries

-- for this we would need artist, museum and work tables

with work_artist as (
select w.`name` as name_of_work, w.style, museum_id, w.artist_id,
full_name, nationality, birth, death
from work w
left join artist a
on w.artist_id = a.artist_id
where museum_id is not null),
work_artist_museum as (
select m.`name` as name_of_museum, style, wa.museum_id, wa.artist_id, country,
full_name, nationality
from work_artist wa
left join museum m
on wa.museum_id = m.museum_id)
select full_name,artist_id, 
count(distinct(country)) as total_country
from work_artist_museum
group by full_name,artist_id
having total_country >1
order by total_country desc;

-- 18) Display the country and the city with most no of museums. Output 2 seperate 
-- columns to mention the city and country. If there are multiple value, seperate them 
-- with comma.

select country, city, count(distinct(name)) as total_museums from museum 
group by country, city order by count(distinct(name)) desc;

-- 19) Identify the artist and the museum where the most expensive and least expensive 
-- painting is placed. Display the artist name, sale_price, painting name, museum 
-- name, museum city and canvas label

-- 20) Which country has the 5th highest no of paintings?
select * from work;
with new_table as (
select m.museum_id, country, work_id, w.name from museum m
right join work w
on m.museum_id = w.museum_id
where country is not null
) , new_table_2 as 
(select country, count(name) as total_paintings from new_table
group by country order by count(name) desc),
new_table_3 as (select country, total_paintings,
row_number() over ( order by total_paintings desc) as `rank` 
from new_table_2) 
select * from new_table_3 where `rank`=5;

-- 21) Which are the 3 most popular and 3 least popular painting styles?

with most_popular as (
select style, count(*) as total_count 
from work where style is not null and museum_id is not null 
group by style order by count(*) desc limit 3
), least_popular as (
select style, count(*) as total_count 
from work where style is not null and museum_id is not null
group by style order by count(*) asc limit 3
) select style, total_count from most_popular
union 
select style, total_count from least_popular;


-- 22) Which artist has the most no of Portraits paintings outside USA?. Display artist 
-- name, no of paintings and the artist nationality.

select * from museum;
with new_table as (
select a.artist_id, a.full_name, a.nationality, a.style, w.museum_id
from artist a
right join work w
on a.artist_id = w.artist_id
), new_table_2 as (
select nt.museum_id, country, artist_id, full_name, nationality, style from new_table nt
left join museum m on 
nt.museum_id = m.museum_id
where country not like '%USA%' and nt.museum_id is not null
) select full_name, count(distinct(country)) as total_countries from new_table_2
group by full_name order by count(distinct(country)) desc;
