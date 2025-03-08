-- here we are doing changes over time analysis

select * from `gold.fact_sales`;

select year(order_date),  sum(sales_amount) as total_sales,
count(distinct customer_key) as total_customers, sum(quantity) as total_quantity
from `gold.fact_sales`
where order_date is not null
group by year(order_date)
order by year(order_date);

-- this provides us with a high level overview of how are business is performing

-- let us get the insights at the month level

select month(order_date) as `month`, sum(sales_amount) as total_sales,
count(distinct customer_key) as total_customers, sum(quantity) as total_quantity
from `gold.fact_sales` where order_date is not null
group by month(order_date) order by total_sales desc ;


-- getting the insights for both the month and year together
select month(order_date) as `month`, year(order_date) as `year`,
sum(sales_amount) as total_sales,
count(distinct customer_key) as total_customers, sum(quantity) as total_quantity
from `gold.fact_sales` where order_date is not null
group by month(order_date), year(order_date) 
order by month(order_date), year(order_date) ;


