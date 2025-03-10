-- it is the process of comparing the current value with the target value
-- it helps us to measure the success and compare the performances

-- we are performing it using the formula current[measure] - target[measure]

-- for these type of queries also we use the window functions

-- the task we are going to perform is ---
-- Analyze the yearly performance of the products by comparing each product's sales
-- to both its average sales performance and the previous year's sales

select * from `gold.report_products`;