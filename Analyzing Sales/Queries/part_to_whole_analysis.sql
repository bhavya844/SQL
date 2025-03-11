# here we are going to do part-to-whole analysis

# here we are going to understand how an individual part is performing compared to the 
# overall. This allows us to understand which category has the greatest impact  on the 
# business

# formula is ([Measure]/Total[Measure]) * 100 By [Dimension]

# the task is to find out which categories contribute the most to the overall sales

with new_table as (
select sales_amount, category from `gold.dim_products` d
right join `gold.fact_sales` f
on d.product_key = f.product_key
) ,new_table_2 as (
select *, sum(sales_amount) over (partition by category) as total_sum_category
from new_table)
select *, sum(sales_amount) over () as final_sum,
concat((total_sum_category)/(sum(sales_amount) over ()) * 100, '%') as percentage 
from new_table_2
order by percentage desc;

