# joins

#joins help to combine two columns if the data within the two columns is same
select * from employee_demographics;

select * from employee_salary;

# inner joins are basically going to return the rows which are basically the same
# in both the tables
# this is the inner join
select d.employee_id, age, salary, occupation from employee_demographics d
join employee_salary s on d.employee_id = s.employee_id;

#this is the outer left join
select s.employee_id, age, occupation, salary from
employee_demographics d 
left outer join employee_salary s
on d.employee_id = s.employee_id;

select s.employee_id, s.first_name, s.last_name, age, salary
 from employee_demographics d 
right outer join employee_salary s
on d.employee_id= s.employee_id;

# self join
select s1.employee_id as emp_santa, s1.first_name as santa_first_name,
s1.last_name as santa_last_name, s2.employee_id as emp_id,
s2.first_name as emp_first_name, s2.last_name as emp_last_name
from employee_salary s1 
join employee_salary s2 on 
s1.employee_id +1 = s2.employee_id;

# joining multiple tables together
select s.employee_id, s.first_name, s.last_name, s.dept_id, pd.department_name
from employee_demographics d 
join employee_salary s
on d.employee_id = s.employee_id
join parks_departments pd on
s.dept_id = pd.department_id