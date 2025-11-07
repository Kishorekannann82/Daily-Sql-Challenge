/*
Pareto Analysis – Find Cumulative Sales Contribution by Product

Scenario:
You have a table product_sales:

product_id	product_name	total_sales
101	Laptop	50000
102	Phone	40000
103	Tablet	20000
104	Headphones	15000
105	Keyboard	8000
106	Mouse	5000
❓Question:

Write a SQL query to:

Sort products by sales descending

Calculate cumulative sales across the sorted list

Calculate cumulative % contribution to total revenue

Identify products contributing to the first 80% of total revenue (Pareto principle)

Return:

product_name

total_sales

cumulative_sales

cumulative_percentage

pareto_flag ('Top 80%' or 'Remaining')

✅ Expected Answer (SQL Solution)
*/
WITH ordered_sales AS (
    SELECT
        product_name,
        total_sales,
        SUM(total_sales) OVER (ORDER BY total_sales DESC) AS cumulative_sales,
        SUM(total_sales) OVER () AS total_all_sales
    FROM product_sales
)
SELECT
    product_name,
    total_sales,
    cumulative_sales,
    ROUND((cumulative_sales * 100.0 / total_all_sales), 2) AS cumulative_percentage,
    CASE
        WHEN (cumulative_sales * 1.0 / total_all_sales) <= 0.80 THEN 'Top 80%'
        ELSE 'Remaining'
    END AS pareto_flag
FROM ordered_sales
ORDER BY cumulative_sales;