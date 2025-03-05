# here we are going to write some advanced queries related to the window functions

 create table employee
( emp_ID int
, emp_NAME varchar(50)
, DEPT_NAME varchar(50)
, SALARY int);

insert into employee values(101, 'Mohan', 'Admin', 4000);
insert into employee values(102, 'Rajkumar', 'HR', 3000);
insert into employee values(103, 'Akbar', 'IT', 4000);
insert into employee values(104, 'Dorvin', 'Finance', 6500);
insert into employee values(105, 'Rohit', 'HR', 3000);
insert into employee values(106, 'Rajesh',  'Finance', 5000);
insert into employee values(107, 'Preet', 'HR', 7000);
insert into employee values(108, 'Maryam', 'Admin', 4000);
insert into employee values(109, 'Sanjay', 'IT', 6500);
insert into employee values(110, 'Vasudha', 'IT', 7000);
insert into employee values(111, 'Melinda', 'IT', 8000);
insert into employee values(112, 'Komal', 'IT', 10000);
insert into employee values(113, 'Gautham', 'Admin', 2000);
insert into employee values(114, 'Manisha', 'HR', 3000);
insert into employee values(115, 'Chandni', 'IT', 4500);
insert into employee values(116, 'Satya', 'Finance', 6500);
insert into employee values(117, 'Adarsh', 'HR', 3500);
insert into employee values(118, 'Tejaswi', 'Finance', 5500);
insert into employee values(119, 'Cory', 'HR', 8000);
insert into employee values(120, 'Monica', 'Admin', 5000);
insert into employee values(121, 'Rosalin', 'IT', 6000);
insert into employee values(122, 'Ibrahim', 'IT', 8000);
insert into employee values(123, 'Vikram', 'IT', 8000);
insert into employee values(124, 'Dheeraj', 'IT', 11000);
COMMIT;

select * from employee;

-- finding out the max salary earned by the employee in each department
select DEPT_NAME, max(SALARY) as max_salary from employee
group by DEPT_NAME order by max_salary desc;

 -- let us say we want to display other information as well other than the dept_name and the 
 -- max(salary), then we would not be able to perform it using the aggregate functions
 
 -- over is used to specify to SQL that we have to create a window of records
 select * from employee;
 select *, 
 max(SALARY) over (partition by DEPT_NAME ) as max_salary
 from employee;

-- row_number()
select *,
row_number() over (partition by DEPT_NAME) as rn from employee;

-- Fetch the first 2 employees from each department to join the company

select * from (
select *, row_number() over (partition by DEPT_NAME order by emp_ID ) as `rn`
from employee) new_table where new_table.rn<=2;

-- Fetch the top three employees who earn the max salaries in each department
select * from (
select *, rank() over (partition by DEPT_NAME order by SALARY) as rnk from employee)
new_table where rnk<=3 order by DEPT_NAME; 

-- using the dense rank here
select * from (
select *, 
rank() over (partition by DEPT_NAME order by SALARY) as rnk,
dense_rank() over (partition by DEPT_NAME order by SALARY) as dense_rnk from employee)
new_table where rnk<=4 order by DEPT_NAME; 

-- here, we are going to check the last window functions which is the LEAD and RAG

-- fetch a query to display if the salary of an employee is higher, lower or equal
-- to the previous employee

select *,
lag(salary, 1, 0) over (partition by DEPT_NAME order by SALARY) as lag_salary,
lead(salary,1,0) over (partition by DEPT_NAME order by SALARY) as lead_salary
from employee; 

select *,
lag(salary) over (partition by DEPT_NAME order by emp_id) as lag_salary,
case when salary > lag(salary) over (partition by DEPT_NAME order by emp_ID) then 'Higher'
when salary < lag(salary) over (partition by DEPT_NAME order by emp_ID) then 'Lower'
when salary = lag(salary) over (partition by DEPT_NAME order by emp_ID) then 'Equal'
end sal_range
from employee;