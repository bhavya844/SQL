
create table teams
    (
        team_code       varchar(10),
        team_name       varchar(40)
    );

insert into teams values ('RCB', 'Royal Challengers Bangalore');
insert into teams values ('MI', 'Mumbai Indians');
insert into teams values ('CSK', 'Chennai Super Kings');
insert into teams values ('DC', 'Delhi Capitals');
insert into teams values ('RR', 'Rajasthan Royals');
insert into teams values ('SRH', 'Sunrisers Hyderbad');
insert into teams values ('PBKS', 'Punjab Kings');
insert into teams values ('KKR', 'Kolkata Knight Riders');
insert into teams values ('GT', 'Gujarat Titans');
insert into teams values ('LSG', 'Lucknow Super Giants');
commit;

select * from teams;

/*every team will play other team once*/
with new_table as 
(
select row_number() over (order by team_name) as id, t.* from teams t
)select t1.team_name as team, t2.team_name as opponent from new_table t1
join new_table t2 on
t1.id < t2.id;

/*every team will play another team twice*/

with new_table as 
(select *,
row_number() over (order by team_name) as id from teams)
select t1.team_name as team, t2.team_name as opponent from new_table t1
join new_table t2 on 
t1.id <> t2.id;



