# here we are going to learn about the where clause

select * from parks_and_recreation.employee_salary where first_name = 'Leslie';

select * from employee_salary where salary >= 50000;

select * from employee_demographics where 
(first_name = 'Leslie' and age =44 ) or age > 55;

# like statement
# % and _ sign 
select * from employee_demographics where first_name like 'a__';

select * from employee_demographics where birth_date like '1985%';
