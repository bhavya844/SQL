-- with recursive cte as (
-- select query (non recursive part of the query )

-- union

-- select query using CTE Name [with a termination condition])
-- )
-- select * from cte_name;


-- display number from 1 to 10 without using any built in function

with recursive cte as (
select 1 as n
union
select n+1 from cte where n < 10
) select * from cte;


-- Find the hierarchy of the employees under a given manager "Asha"

CREATE TABLE emp_details
    (
        id           int PRIMARY KEY,
        name         varchar(100),
        manager_id   int,
        salary       int,
        designation  varchar(100)

    );

INSERT INTO emp_details VALUES (1,  'Shripadh', NULL, 10000, 'CEO');
INSERT INTO emp_details VALUES (2,  'Satya', 5, 1400, 'Software Engineer');
INSERT INTO emp_details VALUES (3,  'Jia', 5, 500, 'Data Analyst');
INSERT INTO emp_details VALUES (4,  'David', 5, 1800, 'Data Scientist');
INSERT INTO emp_details VALUES (5,  'Michael', 7, 3000, 'Manager');
INSERT INTO emp_details VALUES (6,  'Arvind', 7, 2400, 'Architect');
INSERT INTO emp_details VALUES (7,  'Asha', 1, 4200, 'CTO');
INSERT INTO emp_details VALUES (8,  'Maryam', 1, 3500, 'Manager');
INSERT INTO emp_details VALUES (9,  'Reshma', 8, 2000, 'Business Analyst');
INSERT INTO emp_details VALUES (10, 'Akshay', 8, 2500, 'Java Developer');
commit;

select * from emp_details;

with recursive cte as (
select id, name, manager_id, designation, 1 as lvl from emp_details where name = "Asha"
union
select e.id, e.name, e.manager_id, e.designation , lvl+1 as level from cte H
join emp_details e on H.id = e.manager_id 
) select * from cte;


with recursive cte as (
select id, name, manager_id, designation, 1 as lvl from emp_details where name = "Asha"
union
select e.id, e.name, e.manager_id, e.designation , lvl+1 as level from cte H
join emp_details e on H.id = e.manager_id 
) select c.name as emp_name, c.id, e.manager_id, e.name as manager_name from cte c
join emp_details e on c.manager_id = e.id ;
  
-- Find the hierarchy of the employees (up the chain of managerial positions)


select * from emp_details;

select id, manager_id, name, designation, 1 as lvl from emp_details 
  where name = "David";

with recursive emp_hierarchy as (
  select id, manager_id, name, 1 as lvl from emp_details 
  where name = "David"
  union 
  select e.id, e.manager_id, e.name, h.lvl+1 as lvl from emp_hierarchy h 
  join emp_details e on h.manager_id = e.id where h.manager_id is not null
  ) select  h.id, h.name as employee_name, e.name as manager_name, h.manager_id as manager_id
  from emp_hierarchy h join emp_details e 
  on h.manager_id = e.id;


