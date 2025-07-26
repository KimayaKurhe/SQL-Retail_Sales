-- Retail Sales Analysis

DROP TABLE IF EXISTS retail_sales;

CREATE TABLE retail_sales
(
	transactions_id INT PRIMARY KEY,	
	sale_date DATE,
	sale_time TIME,
	customer_id INT,
	gender VARCHAR(15),
	age INT,
	category VARCHAR(20),
	quantiy INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT

);
SELECT * FROM retail_sales;

-- count of records
SELECT COUNT(*) FROM retail_sales;

-- no of customers we have
SELECT COUNT(DISTINCT(customer_id)) FROM retail_sales;

-- no of categories we have/categories we have
SELECT DISTINCT(category) FROM retail_sales;    -- name of categories
SELECT COUNT(DISTINCT(category)) FROM retail_sales;   -- no of categories

-- Problems and Answers

-- Q.1) SQL query to retrieve all columns for sales on '2022-11-05'.

SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Q.2) SQL query to retrieve all transactions where category is 'Clothing' and quantity sold is more than or equal to 4 in the month of Nov-2022. 

SELECT * FROM retail_sales
WHERE category = 'Clothing'
	  AND TO_CHAR(sale_date, 'yyyy-mm') = '2022-11'
	  AND quantiy >= 4
ORDER BY sale_date ASC;

-- Q.3) SQL query to calculate the total sales for each category.

SELECT category, SUM(total_sale) AS net_sales, COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category;

-- Q.4) SQL query to find average age of customers who purchased items from the 'Beauty' category.

SELECT category, ROUND(AVG(age),2) AS avg_age_customer
FROM retail_sales
WHERE category = 'Beauty'
GROUP BY category;

-- Q.5) SQL query to find all transactions where the total_sale is greater than 1000.

SELECT * FROM retail_sales
WHERE total_sale > 1000;

-- Q.6) SQL query to find the total number of transactions made by each gender in each category.

SELECT category, gender, COUNT(*) AS total_transactions
FROM retail_sales
GROUP BY category, gender
ORDER BY category;

-- Q.7) SQL query to calculate the average sale for each month. Find out best selling month in each year.

SELECT year, month, avg_sales FROM 
(
SELECT EXTRACT(YEAR FROM sale_date) AS year,
	   EXTRACT(MONTH FROM sale_date) AS month,
	   AVG(total_sale) AS avg_sales,
	   RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rank
FROM retail_sales
GROUP BY year, month           --can also (ORDER BY year DESC, avg_sales DESC)

) AS T1
WHERE rank  = 1;

-- Q.8) SQL query to find the top 5 customers based on the highest total sales.

SELECT customer_id, SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY SUM(total_sale) DESC LIMIT 5;

SELECT customer_id, SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC LIMIT 5;  -- using number of column instead of name of column

-- Q.9) SQL query to find the number of unique custmers who purchesed item from each category.

SELECT category, COUNT(DISTINCT(customer_id)) AS no_of_customers
FROM retail_sales
GROUP BY category;

-- Q.10) SQL query to create each shift and number of orders (Moring <= 12, Afternoon between 12 & 17, Evening > 17).

WITH hourly_shift                                                 -- concept of CTE(Common Table Expression)
AS (	
		SELECT *, CASE
					  WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
					  WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
					  ELSE 'Evening'
				  END AS shift
		FROM retail_sales
	)
SELECT shift, COUNT(*) AS total_orders
FROM hourly_shift
GROUP BY shift;





























