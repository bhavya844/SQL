# here are the advanced queries that are performed on the dataset

-- 1) Retrieve the total number of books sold for each genre

select Genre, sum(Quantity) as total_sum from books b
join orders o
on b.Book_ID = o.Book_ID
group by Genre order by total_sum desc;

-- 2) Find the average price of the books in the Fantasy genre

select genre, avg(Price) as average_price from books
group by Genre
having Genre = 'Fantasy';

-- 3) List the customers who have atleast puchased 2 books
with new_table as (
select c.`Name`, Quantity from customers c 
join orders o 
on c.Customer_ID = o.Customer_ID
)
select `Name`, sum(Quantity) as sum_quantity from new_table
group by `Name` having sum_quantity >= 2 order by sum_quantity desc ;

-- 4) List the customers who have atleast placed 2 orders

select c.`Name`, count(`Name`) as total_orders from customers c
join orders o
on c.Customer_ID = o.Customer_ID
group by `Name` having  total_orders >= 2 order by total_orders;

-- 5) Show the top three most expensive books of Fantasy genre

select Title, Price, Genre from books where Genre = 'Fantasy' order by Price desc
limit 3 ;

-- 6) Retrieve the total quantities of the books sold by each author

select Author , sum(Quantity) as total_sum from books b
join orders o on b.Book_ID = o.Book_ID
group by Author order by total_sum asc;

-- 7) List the cities where the customers who have spent over $30 are located


select City, sum(Total_Amount) as total_sum from customers c 
join orders o 
on c.Customer_ID =  o.Customer_ID
group by City having total_sum > 30 order by total_sum asc;

-- 8) Find the customer who spent the most on orders

select `Name`, sum(Total_Amount) as total_sum from customers
join orders on 
customers.Customer_ID = orders.Customer_ID
group by `Name` order by total_sum desc limit 1;

-- 9) Calculate the stock remaining after fulfilling all the orders

select * from books;
