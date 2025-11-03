
/*
Find Top 2 Products by Sales in Each Category

Scenario:
You have a table sales:

sale_id	category	product	total_sales
1	Electronics	Laptop	5000
2	Electronics	TV	7000
3	Electronics	Headphones	2000
4	Furniture	Chair	1500
5	Furniture	Table	2500
6	Furniture	Sofa	6000
7	Clothing	T-Shirt	1200
8	Clothing	Jeans	2500
9	Clothing	Jacket	4000
❓Question:

Write a SQL query to return the top 2 products by total_sales in each category.

Return:

category

product

total_sales

rank_in_category

✅ Expected Answer (SQL Solution)
*/

WITH ranked_sales AS (
    SELECT
        category,
        product,
        total_sales,
        DENSE_RANK() OVER (
            PARTITION BY category
            ORDER BY total_sales DESC
        ) AS rank_in_category
    FROM sales
)
SELECT
    category,
    product,
    total_sales,
    rank_in_category
FROM ranked_sales
WHERE rank_in_category <= 2
ORDER BY category, rank_in_category;