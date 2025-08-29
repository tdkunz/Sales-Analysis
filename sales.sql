use `your_schema`;

SET GLOBAL local_infile = 1;

-- drop table orders;
CREATE TABLE orders (
    Row_ID INT,
    Order_ID VARCHAR(50),
    Order_Date DATE,
    Ship_Date DATE,
    Ship_Mode VARCHAR(50),
    Customer_ID VARCHAR(50),
    Customer_Name VARCHAR(255),
    Segment VARCHAR(50),
    Country VARCHAR(100),
    City VARCHAR(100),
    State VARCHAR(100),
    Postal_Code VARCHAR(20),
    Region VARCHAR(50),
    Product_ID VARCHAR(50),
    Category VARCHAR(50),
    Sub_Category VARCHAR(50),
    Product_Name VARCHAR(255),
    Sales DECIMAL(10,2),
    Quantity INT,
    Discount DECIMAL(5,2),
    Profit DECIMAL(10,2)
);

-- import dataset
LOAD DATA LOCAL INFILE 'dataset path'
INTO TABLE orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(Row_ID, order_id, @order_date, @ship_date, ship_mode, customer_id, customer_name, segment, country, city, state, postal_code, region, product_id, category, sub_category, product_name, sales, quantity, discount, profit)
SET order_date = STR_TO_DATE(@order_date, '%m/%d/%Y'),
    ship_date  = STR_TO_DATE(@ship_date, '%m/%d/%Y');


-- Revenue by Region
select region as Region, sum(sales) as Total_Sales
from orders
group by region
order by Total_Sales desc;

-- Profit by Region
select region as Region, sum(profit) as Total_Profit
from orders
group by region
order by Total_Profit desc;

-- Top 10 customer
select customer_name, sum(sales) as Total_Spending
from orders
group by customer_name
order by Total_Spending desc
limit 10;

-- Average Revenue by Month
select year(order_date) as Year, month(order_date) as Month, round(sum(sales),2) as Monthly_Sales
from orders
group by year(order_date), month(order_date)
order by Year, Month;

-- Profit ratio by product category
select category as Category, 
	   sum(sales) as Total_Sales, 
       sum(profit) as Total_Profit, 
       round(sum(profit)/sum(sales)*100,2) as Profit_Margin
from orders
group by Category
order by Profit_Margin desc;

-- Impact of discount on profit
SELECT Discount,
       ROUND(AVG(Profit),2) AS Avg_Profit,
       COUNT(*) AS Order_Count
FROM orders
GROUP BY Discount
ORDER BY Discount;