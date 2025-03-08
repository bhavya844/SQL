-- here we are going to aggregate the data progressively over time

-- it basically helps us to understand about how are business is performing over the time.
-- whether the business is growing or declining over time

-- for performing cumulative analysis, we can use the aggregate window functions in sql

-- we are going to calculate the total sales for each month and also the running total of sales
-- over time

select * from `gold.fact_sales`;

select month(order_date) as `month`, year(order_date) as `year`, 
sum(sales_amount) as total_sales
from `gold.fact_sales` 
where order_date is not null
group by month(order_date), year(order_date)
order by year(order_date), month(order_date);

-- let us now perform window function on the above table using the subquery

select *, sum(total_sales) over (order by year, month) as running_total
from (select month(order_date) as `month`, year(order_date) as `year`, 
sum(sales_amount) as total_sales
from `gold.fact_sales` 
where order_date is not null
group by month(order_date), year(order_date)
order by year(order_date), month(order_date)
) as subquery;

-- now let us get the total sales per year again with the help of the window function

select *, sum(total_sales) over (partition by `year`) as total_sales_per_year
from (select month(order_date) as `month`, year(order_date) as `year`, 
sum(sales_amount) as total_sales
from `gold.fact_sales` 
where order_date is not null
group by month(order_date), year(order_date)
order by year(order_date), month(order_date)
) as subquery;

-- getting only the year and not the months

select *, sum(total_sales) over (order by `year`) as total_sales_per_year
from (select year(order_date) as `year`, 
sum(sales_amount) as total_sales
from `gold.fact_sales` 
where order_date is not null
group by year(order_date)
order by year(order_date)
) as subquery;


-- now let us get the moving average for the price. we just need to add another window
-- function to it calculate the same


select *, 
sum(total_sales) over (order by `year`) as total_sales_per_year,
avg(avg_price) over (order by `year`) as moving_average
from (select year(order_date) as `year`, 
sum(sales_amount) as total_sales,
avg(price) as `avg_price`
from `gold.fact_sales` 
where order_date is not null
group by year(order_date)
order by year(order_date)
) as subquery;

-- to know how the business is progressing, we can use the cumulative analysis
