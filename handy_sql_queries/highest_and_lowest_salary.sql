START TRANSACTION;

DROP TABLE IF EXISTS employee;
CREATE TABLE employee
(
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    dept VARCHAR(100),
    salary INT
);

INSERT INTO employee VALUES (DEFAULT, 'Alexander', 'Admin', 6500);
INSERT INTO employee VALUES (DEFAULT, 'Leo', 'Finance', 7000);
INSERT INTO employee VALUES (DEFAULT, 'Robin', 'IT', 2000);
INSERT INTO employee VALUES (DEFAULT, 'Ali', 'IT', 4000);
INSERT INTO employee VALUES (DEFAULT, 'Maria', 'IT', 6000);
INSERT INTO employee VALUES (DEFAULT, 'Alice', 'Admin', 5000);
INSERT INTO employee VALUES (DEFAULT, 'Sebastian', 'HR', 3000);
INSERT INTO employee VALUES (DEFAULT, 'Emma', 'Finance', 4000);
INSERT INTO employee VALUES (DEFAULT, 'John', 'HR', 4500);
INSERT INTO employee VALUES (DEFAULT, 'Kabir', 'IT', 8000);

COMMIT; -- Ensures changes are saved


select * from employee;

/*
From the given employee table, display the highest and lowest salary corresponding to 
each department. Return the result corresponding to each employee record
*/

select *,
max(salary) over (partition by dept order by salary desc) as highest_salary,
min(salary) over (partition by dept order by salary desc
rows between unbounded preceding and unbounded following) as lowest_salary
from employee; 