/* building a customer report 

Purpose of the report-
  This report should consolidate key customer metrics and behaviours
  
  Highlights: 
  1) Gathers essential fields such as names, ages and transaction details.
  2) Segments customers into categories (VIP, Regular, New) and age groups
  3) Aggregates customer level metrics
		- total orders
        - total sales
        - total quantity purchased
        - total products
        - lifespan (in months)
4) Calculates valuable KPIs:
		- recency(months since last order)
        - average value order
        - average monthly spend
        */

## selecting columns from the tables

with new_table as (
select f.order_number, f.product_key,
f.order_date, f.sales_amount, f.quantity,
c.customer_key, c.customer_number,  
concat(c.first_name,' ',c.last_name) as name,
timestampdiff(year, c.birthdate, curdate()) as age
from `gold.fact_sales` f
left join `gold.dim_customers` c 
on f.customer_key =c.customer_key
where order_date is not null)
select customer_key, customer_number,  
name, age, 
sum(sales_amount) as total_sales,
sum(quantity) as total_quantity,
count(distinct product_key) as total_products,
max(order_date) as max_date,
timestampdiff(year, min(order_date), max(order_date)) as lifespan
from new_table
group by `name`, customer_key, age, customer_number;

