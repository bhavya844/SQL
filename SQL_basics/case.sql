# case statements

select first_name, last_name, age,
case 
	when age<= 30 then 'Young'
	when age > 31 and age <= 50 then 'Old'
    when age > 50 then 'Retire'
end as label
from employee_demographics; 


select first_name, last_name, salary, department_name,
case 
	when salary < 50000 then '5%'
    when salary > 50000 then '7%'
    -- when department_name = 'Finance'
end as increment
from employee_salary s
join parks_departments d
on s.dept_id= d.department_id


