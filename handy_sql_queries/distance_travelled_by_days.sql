create table car_travels
(
    cars                    varchar(40),
    days                    varchar(10),
    cumulative_distance     int
);
insert into car_travels values ('Car1', 'Day1', 50);
insert into car_travels values ('Car1', 'Day2', 100);
insert into car_travels values ('Car1', 'Day3', 200);
insert into car_travels values ('Car2', 'Day1', 0);
insert into car_travels values ('Car3', 'Day1', 0);
insert into car_travels values ('Car3', 'Day2', 50);
insert into car_travels values ('Car3', 'Day3', 50);
insert into car_travels values ('Car3', 'Day4', 100);

select * from car_travels;

/*
From the given cars_travel table, find the actual distance travelled by each 
car corresponding to each day
*/

with new_table as (
select *, 
lag(cumulative_distance, 1,0) over (partition by cars ) as distance
from car_travels)
select cars, days, cumulative_distance, (cumulative_distance- distance) as
distance_travelled from new_table;