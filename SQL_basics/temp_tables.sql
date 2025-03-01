# temp_tables

# they are only visible to the session they are created in 
# they can be used for storing the intermediate results of complex queries
# also can be used to manipulate data before entering it into a permanent table
# they can be used for advanced use cases as compared to the cte

create temporary table temp_table
( first_name varchar(50),
last_name varchar (50),
favourite_movie varchar(50)
);

select * from temp_table;

insert into temp_table
values ('bhavya', 'dave', 'cinderella man');

create temporary table salary_over_50k 
(select * from employee_salary where salary> 50000 and salary <= 75000);

select * from salary_over_50k;