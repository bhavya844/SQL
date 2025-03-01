# unions

# they basically add all the rows from all the tables
# so union basically takes the unique rows. so, it is performing DISTINCT by default
# also we can use ALL in order to get all the rows from both the tables

select first_name, last_name from employee_demographics
union all
select first_name, last_name from employee_salary;


select first_name, last_name , 'Old man' as label 
from employee_demographics
where age > 40 and gender = 'male'
union
select first_name, last_name, 'Old Lady' as label
from employee_demographics 
where age > 40 and gender = 'female'
union
select first_name, last_name , 'Highly paid employee' as label
from employee_salary
where salary > 70000
order by first_name, last_name;