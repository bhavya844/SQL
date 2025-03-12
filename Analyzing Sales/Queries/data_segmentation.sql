# here we are going to perform data segmentation

# here we are going to group the data based on specific range. so this will help us to 
# understand the correlation between two measures

# the problem statement is to segment the products into cost range and count how many products
# fall into each segment

with new_table as (
select product_key,
product_name, cost,
case when cost < 100 then 'Below 100'
when cost between 100 and 500 then '100 and 500'
when cost between 500 and 1000 then '500 and 1000' 
else 'above 1000' 
end cost_range 
from `gold.dim_products`)
select  cost_range, count(product_name) 
from new_table
group by  cost_range
order by count(product_name) desc;  

/* now we are going to start another task which is grouping the customers based on their 
spending behaviour. 
- so we have the VIP customers: at least 12 months of history and spending more than 5000
- Regular cusotmer at least 12 months of history but spending 5000 or less
- New cusotmers with lifespan less than 12 months
and find the total number of customers by each group 
*/
select * from `gold.fact_sales`;
select * from `gold.dim_customers`;

with new_table as (
select f.customer_key, 
sum(sales_amount) as total_sales, 
max(order_date) as max_order_date, min(order_date) as min_order_date ,
timestampdiff(month, min(order_date), max(order_date)) as total_months
from `gold.fact_sales` f
join `gold.dim_customers` d
on f.customer_key = d.customer_key
group by f.customer_key
order by f.customer_key asc),
new_table_2 as (select * , 
case when total_sales > 5000 and total_months>= 12 then 'VIP'
when total_sales<=5000 and total_months>=12 then 'Regular'
else 'New' 
end class_of_customers
from new_table) 
select class_of_customers, count(customer_key) from new_table_2
group by class_of_customers ;



