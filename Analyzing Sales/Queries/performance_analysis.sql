-- it is the process of comparing the current value with the target value
-- it helps us to measure the success and compare the performances

-- we are performing it using the formula current[measure] - target[measure]

-- for these type of queries also we use the window functions

-- the task we are going to perform is ---
-- Analyze the yearly performance of the products by comparing each product's sales
-- to both its average sales performance and the previous year's sales


select year(order_date) as order_year,
sum(sales_amount) as total_sales, 
product_name
from `gold.fact_sales` f
left join `gold.dim_products` p
on f.product_key = p.product_key
where order_date  is not null
group by order_year, product_name
order by order_year asc;



