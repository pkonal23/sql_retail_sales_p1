-- SQL Retail Sale Analysis
-- create TABLE transactions_id,sale_date,sale_time,customer_id,gender,age,category,quantiy,price_per_unit,cogs,total_sale

DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
	(
		transactions_id INT PRIMARY KEY,
		sale_date DATE,
		sale_time TIME,
		customer_id INT,
		gender VARCHAR(15),
		age INT,
		category VARCHAR(15),
		quantiy INT,
		price_per_unit FLOAT,
		cogs FLOAT,
		total_sale FLOAT
	);

--

SELECT * FROM retail_sales
LIMIT 10

--

SELECT 
	COUNT(*)
FROM retail_sales

--

SELECT * FROM retail_sales
WHERE
        transactions_id IS NULL
		OR
		sale_date IS NULL
		OR
		sale_time IS NULL
		OR
		customer_id IS NULL
		OR
		gender IS NULL
		OR
		age IS NULL
		OR
		category IS NULL
		OR
		quantiy IS NULL
		OR
		price_per_unit IS NULL
		OR
		cogs IS NULL
		OR
		total_sale IS NULL;
	
--

DELETE FROM retail_sales
WHERE
	  transactions_id IS NULL
		OR
		sale_date IS NULL
		OR
		sale_time IS NULL
		OR
		customer_id IS NULL
		OR
		gender IS NULL
		OR
		age IS NULL
		OR
		category IS NULL
		OR
		quantiy IS NULL
		OR
		price_per_unit IS NULL
		OR
		cogs IS NULL
		OR
		total_sale IS NULL;




-- DATA EXPLORATION

-- HOW MANY SALES WE HAVE?
SELECT COUNT(*) as total_sales FROM retail_sales

-- HOW MANY CUSTOMERS WE HAVE?
SELECT COUNT(customer_id) as total_sales FROM retail_sales

-- HOW MANY UNIQUE CUSTOMERS WE HAVE?
SELECT COUNT(DISTINCT customer_id) as total_sales FROM retail_sales

-- HOW MANY UNIQUE CATEGORY WE HAVE?
SELECT COUNT(DISTINCT category) as total_sales FROM retail_sales
SELECT DISTINCT category FROM retail_sales



-- Write a SQL query to retrieve all columns for sales made on '2022-11-05'.
SELECT * 
FROM retail_sales
WHERE sale_date = '2022-11-05';



-- Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in November 2022.
SELECT * 
FROM 
	retail_sales
WHERE 
	category = 'Clothing' 
	AND 
	quantiy >= 4 
	AND 
	TO_CHAR(sale_date, 'YYYY-MM') = '2022-11';



-- Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT 
	category,
	SUM(total_sale) as net_sale,
	COUNT(*) as total_orders
FROM retail_sales
GROUP BY category



-- Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT 
	category,
	-- AVG(age) as avg_age
	ROUND(AVG(age),2) as avg_age
FROM retail_sales
WHERE category = 'Beauty'
GROUP BY category;


-- Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT * 
FROM 
	retail_sales
	WHERE
		total_sale > 1000
		
		
-- Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT 
	category, 
	gender,
	Count(*) as TOTAL
		FROM retail_sales
			GROUP BY 
			gender, 
			category


-- Write a SQL query to calculate the average sale for each month. Find the best-selling month for each year.
SELECT * FROM
(


SELECT
	EXTRACT (YEAR FROM sale_date) as year,
	EXTRACT (MONTH FROM sale_date) as month,
	AVG(total_sale) as average_sale,
	RANK() OVER(PARTITION BY EXTRACT (YEAR FROM sale_date) ORDER BY AVG(total_sale)DESC)
		FROM retail_sales
			GROUP BY 1,2
			-- ORDER BY 1,2

)
WHERE RANK =1


-- Write a SQL query to find the top 5 customers based on the highest total sales.
SELECT 
	customer_id,
	total_sale_per_customer
		FROM(

SELECT 
	customer_id, 
	SUM(total_sale) as total_sale_per_customer
		FROM retail_sales
			GROUP BY 1
		)
		ORDER BY total_sale_per_customer DESC
		LIMIT 5
			


-- Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT 
		COUNT (DISTINCT customer_id) as distinct, 
       	category
	FROM retail_sales
	GROUP BY 2
	



-- Write a SQL query to create shifts and count the number of orders for each shift (Example: Morning <= 12, Afternoon between 12 and 17, Evening > 17).
SELECT 
	shift, 
	COUNT(transactions_id) as total_orders
	FROM (
SELECT *,
	CASE 
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'MORNING'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'AFTERNOON' 
		ELSE 'EVENING'
		END 
			as shift
				FROM retail_sales
	)
	GROUP BY shift

