CREATE DATABASE onlinebookstore;
-- Switch to the database
\c OnlineBookstore;

-- Create Tables
DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);
DROP TABLE IF EXISTS customers;
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);
DROP TABLE IF EXISTS orders;
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

--import data into books table
COPY Books(Book_ID, Title, Author, Genre, Published_Year, Price, Stock )
FROM '‪‪C:/Users/ASUS/Documents/Books (1).csv'
CSV HEADER;

--import data into customers table
COPY Customers(Customer_ID, Name, Email,Phone, City, Country)
FROM 'C:\Users\ASUS\Downloads\Customers.csv'
CSV HEADER;

--import data into orders table
COPY Orders(Order_ID, Customer_ID, Book_ID, Order_Date, Quantity, Total_Amount)
FROM 'C:\Users\ASUS\Downloads\Orders.csv'
CSV HEADER;

--BASIC QUESTIONS--

--1.Retrieve all books in the fiction genre
SELECT * FROM Books
WHERE genre='Fiction';

--2.find books published after the year 1950
SELECT * FROM Books
WHERE published_year>1950;

--3.list all customers from the canada
SELECT  * FROM Customers
WHERE country='Canada';

--4.Retrieve orders placed in November 2023
SELECT * FROM Orders
WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30';

--5.Retrieve total stock of books available
SELECT SUM(stock) AS total_stock
FROM Books;

--6.Find the details of the most expensive book
SELECT * FROM Books
ORDER BY price DESC
LIMIT 1;

--7.Show all customers who ordered more than 1 quantity of a book
SELECT * FROM Orders
WHERE  quantity>1;

--8.Retrieve all orders where the total amount exceeds $20
SELECT * FROM Orders
WHERE total_amount>20;

--9.list all genres available in the book table
SELECT DISTINCT genre 
FROM Books;

--10.find the book with the lowest stock
SELECT * FROM Books
ORDER BY stock
LIMIT 1;

--11.calculate the total revenue generated from all orders
SELECT SUM(total_amount) AS total_revenue
FROM Orders;


--ADVANCE QUESTIONS--
--12.Retrieve the total number of books sold for each genre
SELECT b.Genre,SUM(o.quantity)AS total_book_sold
FROM Orders o
JOIN 
Books b
ON b.book_id=o.book_id
GROUP BY b.Genre

--13.find the average price of books in the "fantasy genre"
SELECT AVG(price)AS average_price
FROM Books
WHERE genre='Fantasy';

--14.list customers who have placed atleast 2 orders
SELECT o.customer_id, c.name, COUNT(o.order_id)AS order_count
FROM Orders o
JOIN Customers c ON o.customer_id=c.customer_id
GROUP BY o.customer_id,c.name
HAVING COUNT(Order_id)>=2;

--15.find the most frequently ordered book
SELECT o.book_id,b.title, COUNT(o.order_id)AS order_count
FROM Orders o
JOIN
Books b ON o.book_id=b.book_id
GROUP BY o.book_id,b.title
ORDER BY order_count DESC LIMIT 1;

--16.show the top 3 most expensive books of 'fantasy genre'
SELECT * FROM Books
WHERE genre='Fantasy'
ORDER BY price DESC
LIMIT 3;

--17.retrieve the total quantity of books sold by each author
SELECT b.author,SUM(o.quantity)AS total_book_sold
FROM Books b
JOIN Orders o 
ON o.book_id=b.book_id
GROUP BY b.author;

--18.list all cities where customer who spent over $30 are located
SELECT DISTINCT c.city,o.total_amount AS customer_spent
FROM Customers c
JOIN Orders o ON o.customer_id=c.customer_id
WHERE total_amount>30;

--19.find the customer who spent the most on orders
SELECT c.name,c.customer_id,SUM(o.total_amount) AS total_spent
FROM Customers c
JOIN Orders o ON o.customer_id=c.customer_id
GROUP BY c.name,c.customer_id
ORDER BY total_spent DESC
LIMIT 1; 

--20.calculate the stock remaining after fulfuling all orders
SELECT b.book_id,b.title,b.stock, COALESCE(SUM(o.quantity),0)AS ORDER_QUANTITY,
    b.stock-COALESCE(SUM(o.quantity),0) AS REAMAINING_QUANTITY
FROM Books b
LEFT JOIN Orders o ON o.book_id=b.book_id
GROUP BY b.book_id;




















