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
where order_date is not null), 
new_table_2 as (
select customer_key, customer_number,  
name, age, 
sum(sales_amount) as total_sales,
sum(quantity) as total_quantity,
count(distinct product_key) as total_products,
max(order_date) as max_date,
timestampdiff(year, min(order_date), max(order_date)) as lifespan
from new_table
group by `name`, customer_key, age, customer_number)
select customer_key customer_number, name,
age,
case when age< 20 then 'Under 20'
when age between 20 and 29 then '20-29'
when age between 30 and 39 then '30-39'
when age between 40 and 49 then '40-49'
else 'above 50'
end age_groups,
case when total_sales > 5000 and lifespan>= 12 then 'VIP'
when total_sales<=5000 and lifespan>=12 then 'Regular'
else 'New' 
end customer_segment,
timestampdiff(month, max_date, curdate()) months_since_last_order,
case when total_quantity = 0 then 0
	else round(total_sales/ (total_quantity),2)
end avg_order_value,
case when lifespan =0 then total_sales
else total_sales/lifespan
end avg_monthly_spends,
total_sales, total_products, total_quantity, max_date from new_table_2;



