# ctes (Common table expressions)
# this can be used when we are performing the subqueries.. we can form a table and
# then in the cte use that table to get the averages and so on
# also we can improve the readability using the cte..


# also we can use the cte right after we mention it and we cannot use it after 
# that. it will give us errors
use parks_and_recreation;
with cte_example as (
select gender, max(salary) as max_sal, min(salary) as min_sal, avg(salary) as avg_sal
from employee_demographics d
join employee_salary s
on d.employee_id=s.employee_id
group by gender)
select avg(avg_sal) as total_average from cte_example;

# the cte has better readability than the subquery
select avg(`avg_sal`) from 
(select gender, max(salary) as max_sal, min(salary) as min_sal, avg(salary) as avg_sal
from employee_demographics d
join employee_salary s
on d.employee_id=s.employee_id
group by gender) as db;


# using joins with the help of cte

with cte_example as (
select employee_id, gender, birth_date
from employee_demographics
where birth_date > '1985-01-01'
), cte_example_2 as (
select employee_id, salary, occupation
from employee_salary
where salary > 50000
)
select d.employee_id, salary, occupation, gender, birth_date 
from cte_example d
join  cte_example_2  s
on d.employee_id = s.employee_id;	