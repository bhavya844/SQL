# here we are going to solve problems using recursive sql queries

# here we need to have two separate queries which need to be merged with the help 
# of Union.


-- syntax for using the recursive queries
/*
WITH [RECURSIVE] CTE_name AS
(
     SELECT query (Non Recursive query or the Base query)
    UNION [ALL]
 SELECT query (Recursive query using CTE_name [with a termination condition])
)
SELECT * FROM CTE_name;
*/

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

/*Queries that we are going to solve are:
1) Display number from 1 to 10 without using built in functions*/

with recursive numbers as (
select 1 as n
union 
select n+1 from numbers where n < 10
) select * from numbers;


# 2) Find the hierarchy of the employees under a given manager "Asha"

with recursive emp_hierarchy as 
(	select id, name, manager_id, designation, 1 as level from emp_details
	where name = 'Asha' 
    union
    select E.id, E.name, E.manager_id, E.designation, H.level + 1 as level
    from emp_hierarchy h join emp_details e on
    h.id = e.manager_id
) select * from emp_hierarchy;
