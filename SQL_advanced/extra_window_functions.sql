# window_functions_continued
# first let us start with creating a table and then performing operations on top of it

# this video contains the window functions like first_value, last_value, frame clause,
# nth_value, nth_tile, cume_dist, percent_rank

create database window_functions;
use window_functions;
create table product (
		product_category varchar(255),
		brand varchar(255),
		product_name varchar(255),
		price int
);

insert into product values
('Phone', 'Apple', 'iPhone 12 Pro Max', 1300),
('Phone', 'Apple', 'iPhone 12 Pro', 1100),
('Phone', 'Apple', 'iPhone 12', 1000),
('Phone', 'Samsung', 'Galaxy Z Fold 3', 1800),
('Phone', 'Samsung', 'Galaxy Z Flip 3', 1000),
('Phone', 'Samsung', 'Galaxy Note 20', 1200),
('Phone', 'Samsung', 'Galaxy S21', 1000),
('Phone', 'OnePlus', 'OnePlus Nord', 300),
('Phone', 'OnePlus', 'OnePlus 9', 800),
('Phone', 'Google', 'Pixel 5', 600),
('Laptop', 'Apple', 'MacBook Pro 13', 2000),
('Laptop', 'Apple', 'MacBook Air', 1200),
('Laptop', 'Microsoft', 'Surface Laptop 4', 2100),
('Laptop', 'Dell', 'XPS 13', 2000),
('Laptop', 'Dell', 'XPS 15', 2300),
('Laptop', 'Dell', 'XPS 17', 2500),
('Earphone', 'Apple', 'AirPods Pro', 280),
('Earphone', 'Samsung', 'Galaxy Buds Pro', 220),
('Earphone', 'Samsung', 'Galaxy Buds Live', 170),
('Earphone', 'Sony', 'WF-1000XM4', 250),
('Headphone', 'Sony', 'WH-1000XM4', 400),
('Headphone', 'Apple', 'AirPods Max', 550),
('Headphone', 'Microsoft', 'Surface Headphones 2', 250),
('Smartwatch', 'Apple', 'Apple Watch Series 6', 1000),
('Smartwatch', 'Apple', 'Apple Watch SE', 400),
('Smartwatch', 'Samsung', 'Galaxy Watch 4', 600),
('Smartwatch', 'OnePlus', 'OnePlus Watch', 220);
COMMIT;

select * from product;

/* Now, we are going to write the SQL query to display the most expensive product
under each category. Also we can get the unqiue values based on the product_category
and the brand later.*/

select *,
first_value(product_name) over (partition by product_category order by price desc) as most_expensive
from product;

# the below query will give us the most expnsive based on the product_category and the brand
select *,
first_value(product_name) over (partition by product_category, brand order by price desc) as most_expensive
from product;

/*Extract the least expensive columns under each category. For this we can use the last_value
window function*/

select *,
last_value(product_name) over (partition by product_category order by price desc
range between unbounded preceding and unbounded following) as least_expensive
from product; 

# we can also use the rows instead of the range. the difference will come when there 
# are duplicate values.

select *,
last_value(product_name) over (partition by product_category order by price desc
rows between unbounded preceding and unbounded following) as least_expensive
from product; 

# inside each of the partitions, we can again create subset of records which is known as
# frames. So, frame is basically a subset of partition. 

# alternate way of writing window functions is by using the windows in order to prevent
# the repetition of the code

select *, 
first_value(product_name) over w as most_expensive,
last_value(product_name) over w as least_expensive
from product
window w as (partition by product_category order by price desc
range between unbounded preceding and unbounded following);

-- nth value
-- this will basically help us to display the second most expensive product under each 
-- category.

select *,
first_value(product_name) over w as most_expensive,
last_value(product_name) over w as least_expensive,
nth_value(product_name, 2 ) over w as second_most_expensive,
row_number() over (partition by product_category) as rn
from product
window w as (partition by product_category order by price desc
range between unbounded preceding and unbounded following);

-- nth tile window function
-- It is basically used to group together a set of data within the partition and then 
-- place it into certain buckets and then sql will try its best that each bucket within 
-- the partition will have equal number of records

-- write a query to segregate all the expensive phones, mid range phones and the cheaper phones

select product_name, 
case when x.buckets = 1 then 'Cheap phones'
when x.buckets = 2 then 'Mid Range Phones'
else 'Expensive Phones'
end range_of_phones from 
(   select *,
	ntile(3) over (order by price ) as buckets 
	from product
	where product_category = 'Phone') as x;
    
/* cume_dist (cumulative distribution) 
Formula = Current Row no (or Row No with value same as current row) / Total no of rows 

Query to fetch all products which are constituting the first 30% 
of the data in products table based on price.
*/

