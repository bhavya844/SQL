# window functions

# they are something like group by. they allow us to look at a partition or a 
# group but they each keep their unique rows in the output

select d.first_name, d.last_name, gender, avg(salary) over (partition by gender)
from employee_demographics d 
join employee_salary s on d.employee_id = s.employee_id;

# we can also perform rolling total with the help of the window function

# here, we are performing the cumulative sum of the column
select d.first_name, d.last_name, gender, salary,
sum(salary) over (partition by gender order by d.employee_id) as RolingTotal
from employee_demographics d 
join employee_salary s on d.employee_id = s.employee_id;

# we can also use rank for the same for ranking the rows based on the feature
# getting the row number for the table
select d.first_name, d.last_name, gender, salary,
row_number() over(partition by gender order by salary desc) as rownumber,
rank() over(partition by gender order by salary desc) as ranknumber,
dense_rank() over(partition by gender order by salary desc) as denserank
from employee_demographics d 
join employee_salary s on d.employee_id = s.employee_id; 


