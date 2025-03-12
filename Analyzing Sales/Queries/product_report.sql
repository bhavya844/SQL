# here we are going to build the product report

/* Purpose: The report consolidates key product metrics and behaviours

Highlights:
	1) Gathers essential fields such as product_name, category, subcategory and cost.
    2) Segments products by revenue to identify High-performers, Mid_range, or Low-Performers.
    3) Aggregates product-level metrics
		- total orders
        - total sales
        - total quantity sold
        - total customers (unique)
        - lifespan (in months)
	4) Calculates valuable KPIs
		- recency (months since last sale)
        - average order revenue (AOR)
        - average monthly revenue
*/

select * from `gold.fact_sales`;
select * from `gold.dim_customers`;
select * from `gold.report_products`;
with new_table as (
select order_number, f.product_key, order_date, customer_key,
sales_amount, quantity, product_name, category, subcategory,
cost from `gold.fact_sales` f
left join `gold.report_products` r
on f.product_key  = r.product_key
where order_date is not null),
new_table_2 as (
select product_key, product_name, category, subcategory, cost,
timestampdiff(month, min(order_date), max(order_date)) as lifespan,
max(order_date) as last_purchase,
count(distinct order_number) as total_orders,
count(distinct customer_key) as total_customers,
sum(sales_amount) as total_sales,
sum(quantity) as total_quantity,
round(avg(cast(sales_amount as float)/ nullif(quantity,0)), 2) as avg_selling_price
from new_table
group by product_key, product_name, category, subcategory, cost)
select product_key, product_name, category, subcategory, cost, last_purchase,
timestampdiff(month, last_purchase, curdate()) as recency_in_months,
case
		when total_sales > 50000 then 'High-Performer'
		when total_sales >= 10000 then 'Mid-Range'
		else 'Low-Performer'
	end as product_segment,
	lifespan,
	total_orders,
	total_sales,
	total_quantity,
	total_customers,
	avg_selling_price,
case
		when total_orders = 0 then 0
		else total_sales / total_orders
	end as avg_order_revenue,
case
		when lifespan = 0 then total_sales
		else total_sales / lifespan
	end as avg_monthly_revenue
from new_table_2  ;



