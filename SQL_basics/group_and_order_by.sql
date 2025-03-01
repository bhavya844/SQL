# groupby
# it basically helps to perform the aggregate functions which are going to perform further
select gender from employee_demographics group by gender;

select gender, avg(age), max(age), min(age), count(age)
from employee_demographics group by gender;

# order by
select  * from employee_demographics order by gender, age desc;

# here we are giving the column numbers .. it is the same as above for quick queries
select * from employee_demographics order by 5,4 desc;

