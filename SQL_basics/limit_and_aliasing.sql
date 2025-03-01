# limit and aliasing

select * from employee_demographics order by age desc
limit 2, 1 ;

# aliasing- it is just a way to change the name of hte columns

select gender, avg(age) as average_age from employee_demographics
where gender = "Male"
group by gender having average_age> 25 ;