# triggers and events

# this is used as event triggers when something happens to the tables
# so like when new record is entered into one table, then we can automatically
# add that record in another table if the trigger is built up

# there are also triggers for batch and table which are way better as compared
# to the row level triggers


delimiter $$
create trigger employee_insert_1
	After insert on employee_salary
    for each row 
begin 
	insert into employee_demographics 
    (employee_id, first_name, last_name) 
    values (new.employee_id, new.first_name, new.last_name);
end $$
delimiter ;

insert into employee_salary (employee_id, first_name, last_name, occupation,
salary, dept_id) 
values (1, 'bhavya', 'dave', 'Office Manger', 55000, 1 );


# events

select * from employee_demographics;
delimiter $$
create event delete_retirees
on schedule every 30 second
do begin 
	delete 
	from employee_demographics where
    age > 60 ; 
end $$
delimiter ;


show variables like 'event%'