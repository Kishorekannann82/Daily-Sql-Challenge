/*
🧩 Challenge #8: Sales Summary by Region and Category (with Totals)

Scenario:
You have the following tables:

sales

sale_id	region	category	amount
1	East	Electronics	1000
2	East	Furniture	500
3	West	Electronics	1200
4	West	Furniture	700
5	North	Electronics	800
6	North	Furniture	400
7	East	Electronics	900
8	West	Furniture	600
❓Question:

Write a SQL query to get a sales summary by region and category,
including subtotals per region and a grand total at the end.

Return:

region

category

total_sales

✅ Expected Answer (SQL Solution)
*/
SELECT
    region,
    category,
    SUM(amount) AS total_sales
FROM sales
GROUP BY ROLLUP(region, category)
ORDER BY
    region,
    category;
