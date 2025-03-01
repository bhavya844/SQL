# string functions

select length('skyfall');

select first_name, length(first_name) as length from employee_demographics
where length(first_name) >=5 and first_name = "Leslie"
order by length desc;

select upper('name');
select lower('Name');

select trim('      bhvaya') as trim_column;

# getting the left and the right name from the tables here
select first_name, left(first_name, 4) as left_name, 
right(first_name, 4) as right_name,
substring(first_name, 3,2) as substring_name,
substring(birth_date, 6,2) as birth_month
from employee_demographics
order by left(first_name,4) desc;


# replace 
select first_name , replace(first_name, 'A', 'z') 
from employee_demographics;

# locate
select locate('a', first_name) from employee_demographics;

select first_name, locate('A', first_name) as A_locate_index from 
employee_demographics;

# concat 
select first_name, last_name, concat(first_name, ' ', last_name) as full_name
from employee_demographics;
