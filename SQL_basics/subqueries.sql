# subqueries

# we can use the subqueries when we do not want to perform the joins in the tables

select * from employee_demographics;
select * from employee_salary;

select * from employee_demographics
where employee_id in (select employee_id from employee_salary where dept_id=1);

# let us see if the salary is above average or below average
select first_name,
(select avg(salary) as total_average_salary from employee_salary) as total_average_salary
from employee_demographics;

select gender, avg(`max_age`) as avg_max_age, 
avg(`min_age`) as avg_min_age 
from 
	(select gender, max(age) as max_age, min(age) as min_age, avg(age) 
	from employee_demographics
	group by gender) as d
group by gender;

