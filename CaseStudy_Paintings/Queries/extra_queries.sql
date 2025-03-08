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