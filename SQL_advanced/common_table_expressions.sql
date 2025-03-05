create table emp
( emp_ID int
, emp_NAME varchar(50)
, SALARY int);

insert into emp values(101, 'Mohan', 40000);
insert into emp values(102, 'James', 50000);
insert into emp values(103, 'Robin', 60000);
insert into emp values(104, 'Carol', 70000);
insert into emp values(105, 'Alice', 80000);
insert into emp values(106, 'Jimmy', 90000);

select * from emp;

-- 1) Fetch all the employees who earn more than the average salary of all the employees

with average_salary (avgsalary) as (
select avg(SALARY) from emp 
) select emp_NAME, salary, avgsalary from emp, average_salary av where SALARY > av.avgsalary;  

-- doing the same using the subquery

select emp_NAME, SALARY from emp
where SALARY > (select avg(SALARY)  from emp);

create table sales
(
	store_id  		int,
	store_name  	varchar(50),
	product			varchar(50),
	quantity		int,
	cost			int
);
insert into sales values
(1, 'Apple Originals 1','iPhone 12 Pro', 1, 1000),
(1, 'Apple Originals 1','MacBook pro 13', 3, 2000),
(1, 'Apple Originals 1','AirPods Pro', 2, 280),
(2, 'Apple Originals 2','iPhone 12 Pro', 2, 1000),
(3, 'Apple Originals 3','iPhone 12 Pro', 1, 1000),
(3, 'Apple Originals 3','MacBook pro 13', 1, 2000),
(3, 'Apple Originals 3','MacBook Air', 4, 1100),
(3, 'Apple Originals 3','iPhone 12', 2, 1000),
(3, 'Apple Originals 3','AirPods Pro', 3, 280),
(4, 'Apple Originals 4','iPhone 12 Pro', 2, 1000),
(4, 'Apple Originals 4','MacBook pro 13', 1, 2500);


select * from sales;

-- Find the stores who's sales where better than the average sales across all stores
-- We can solve this problem by going through three steps. First we can find out the total 
-- sales for each store by using group by. Then we can find out the average sales. After that
--  we can find out the stores which have the higher cost as compared to the average sales.

with new_table (store_id, store_name, qty_sum, cost_sum) as
( 
 select store_id, store_name, sum(quantity), sum(cost) from sales
 group by store_id , store_name order by sum(cost) desc
 ),
 new_table_1 (average_cost) as
 (
 select avg(cost_sum) from new_table
 ) select store_id, store_name, cost_sum , average_cost from new_table, new_table_1
 where cost_sum > average_cost;
 
 -- the benefits of using the WITH clause is that we do not have to write the subquery 
 -- multiple times. Also, the efficiency of the sql query increases using the WITH clause 
 -- as the same query is not run again and again. It also becomes easier to maintain and debug.
 
