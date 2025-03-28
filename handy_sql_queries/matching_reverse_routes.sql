create table src_dest_distance
(
    source          varchar(20),
    destination     varchar(20),
    distance        int
);
insert into src_dest_distance values ('Bangalore', 'Hyderbad', 400);
insert into src_dest_distance values ('Hyderbad', 'Bangalore', 400);
insert into src_dest_distance values ('Mumbai', 'Delhi', 400);
insert into src_dest_distance values ('Delhi', 'Mumbai', 400);
insert into src_dest_distance values ('Chennai', 'Pune', 400);
insert into src_dest_distance values ('Pune', 'Chennai', 400);

select * from src_dest_distance;


with new_cte as  (
select * , row_number() over () as rn from src_dest_distance)
select t1.source, t1.destination, t1.distance
from new_cte t1 join
new_cte t2
on t1.rn < t2.rn
and t1.source = t2.destination
and t1.destination = t2.source;

