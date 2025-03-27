# this has some of the sql queries

use sql_queries;

create table cars
(
	model_id		int primary key,
	model_name		varchar(100),
	color			varchar(100),
	brand			varchar(100)
);
insert into cars values(1,'Leaf', 'Black', 'Nissan');
insert into cars values(2,'Leaf', 'Black', 'Nissan');
insert into cars values(3,'Model S', 'Black', 'Tesla');
insert into cars values(4,'Model X', 'White', 'Tesla');
insert into cars values(5,'Ioniq 5', 'Black', 'Hyundai');
insert into cars values(6,'Ioniq 5', 'Black', 'Hyundai');
insert into cars values(7,'Ioniq 6', 'White', 'Hyundai');

select * from cars;

# delete duplicate data from the table of cars

select * from cars;

with new_table as (
select *, 
row_number() over (partition by model_name, color, brand) as rn
from cars)
delete from cars where model_id in (select model_id from new_table
where rn>1);

# another solution

delete from cars where model_id in 
(select model_id from 
(select *, 
row_number() over (partition by model_name, brand order by model_id) as rn
from cars) x where x.rn >1);

select * from cars;

