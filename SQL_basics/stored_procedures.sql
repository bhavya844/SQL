# stored_procedures

# they are a way to save our sql code such that they can used again and again

select * from employee_salary where salary>= 50000;

create procedure large_salaries()
select * from employee_salary where salary>= 50000;

call large_salaries()

delimiter $$
create procedure large_salaries2()
begin
	select * from employee_salary where salary > 50000;
	select * from employee_salary where salary < 90000;
end $$
delimiter ;
 
call large_salaries2();


USE `parks_and_recreation`;
DROP procedure IF EXISTS `new_procedure`;

DELIMITER $$
USE `parks_and_recreation`$$
CREATE PROCEDURE `new_procedure` ()
BEGIN
	select * from employee_salary where salary > 50000;
	select * from employee_salary where salary < 90000;
END$$

DELIMITER ;


delimiter $$
create procedure salaries4(employee_id_param int)
begin
	select salary from employee_salary
    where employee_id = employee_id_param;
end $$
delimiter ;

call salaries4(1)


