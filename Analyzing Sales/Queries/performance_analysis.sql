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

# now let us use cte to query

with new_table as (
select year(order_date) as order_year, sum(sales_amount) as total_sales,
product_name from `gold.fact_sales` f
left join `gold.dim_products` p
on f.product_key = p.product_key
where order_date is not null
group by product_name, order_year
order by order_year asc
) select *,
round(avg(total_sales) over (partition by product_name),2) as avg_sales ,
total_sales - avg(total_sales) over (partition by product_name) as difference,
case 
when total_sales > round(avg(total_sales) over (partition by product_name),2) then 'above_average'
when total_sales = round(avg(total_sales) over (partition by product_name),2) then 'same as average'
when total_sales < round(avg(total_sales) over (partition by product_name),2) then 'below average'
end compare_to_average
from new_table
order by product_name,order_year;

# now let us compare the total_sales with the previous year sales. for this also we will
# be using the window functions and using the lag() function in it.

with new_table as (
select year(order_date) as order_year, sum(sales_amount) as total_sales,
product_name from `gold.fact_sales` f
left join `gold.dim_products` p
on f.product_key = p.product_key
where order_date is not null
group by product_name, order_year
order by order_year asc
) select *,
lag(total_sales,1,0) over (partition by product_name order by order_year) as previous_year_sales,
case when total_sales > lag(total_sales,1,0) over (partition by product_name order by order_year) then 'greater'
when total_sales = lag(total_sales,1,0) over (partition by product_name order by order_year) then 'equal'
when total_sales < lag(total_sales,1,0) over (partition by product_name order by order_year) then 'lesser'
end compare_previous_year
from new_table
order by product_name, order_year;




