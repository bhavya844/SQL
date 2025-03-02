# here we are performing some basic queries related to the project

use book_store_analysis;

-- 1) Retrieve all the books in the Fiction genre
select * from books where Genre = 'Fiction';

select distinct  genre from books;

-- 2) Find all the books that have been published after the year 1950

select * from books where Published_Year > 1950 order by Published_Year asc;

-- 3) List all the customers from Canada

select * from customers where Country= 'Canada';

-- 4) Show orders that were placed in November 2023

select * from orders where month(Order_Date) = 11 and year(Order_Date) = 2023;

-- 5) Retrive the total stock of the books available

select sum(Stock) from books;

-- 6) Find the details of the most expensive book

select * from books order by price desc limit 1;

-- 7) Show all the customers who ordered more than one quantity of the book

select distinct c.`Name` from customers c
join orders o 
on c.Customer_ID = o.Customer_ID
where Quantity> 1;

-- 8) Retrieve all the orders where the total amound exceeds $ 20

select * from orders where Total_Amount > 20 order by Total_Amount;

-- 9) List all the genres available in the Books table

select distinct Genre from books;

-- 10) Find the book with the lowest stock

select * from books order by Stock asc limit 1;

-- 11) Calculate the total revenue generated from all orders

select sum(Total_Amount) as revenue from orders;



