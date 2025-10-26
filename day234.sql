/*
Pivot Monthly Sales by Region

Scenario:
You have a table called sales:

sale_id	region	sale_date	amount
1	East	2024-01-05	500
2	West	2024-01-06	400
3	North	2024-01-10	300
4	East	2024-02-08	600
5	West	2024-02-12	700
6	North	2024-02-15	350
7	East	2024-03-04	550
8	West	2024-03-07	500
9	North	2024-03-10	450
❓Question:

Write a SQL query to pivot the data so that each region becomes a column showing its total monthly sales.
*/


Return:

month (YYYY-MM)

east_sales

west_sales

north_sales

✅ Expected Answer (SQL Solution)
SELECT
    DATE_FORMAT(sale_date, '%Y-%m') AS month,
    SUM(CASE WHEN region = 'East' THEN amount ELSE 0 END) AS east_sales,
    SUM(CASE WHEN region = 'West' THEN amount ELSE 0 END) AS west_sales,
    SUM(CASE WHEN region = 'North' THEN amount ELSE 0 END) AS north_sales
FROM sales
GROUP BY DATE_FORMAT(sale_date, '%Y-%m')
ORDER BY month;
