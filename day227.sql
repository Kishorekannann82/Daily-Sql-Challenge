/*
🧩 Challenge #5: Top 3 Products by Revenue per Category

Scenario:
You have the following tables:

products

product_id	product_name	category
101	Laptop	Electronics
102	Phone	Electronics
103	Headphones	Electronics
104	Chair	Furniture
105	Desk	Furniture
106	Lamp	Furniture

sales

sale_id	product_id	quantity	price
1	101	10	900
2	102	15	700
3	103	20	100
4	104	8	200
5	105	5	400
6	106	12	150
7	101	5	950
8	102	10	720
9	103	8	120
❓Question:

Write a SQL query to find the Top 3 products (by total revenue) within each category.

Return:

category

product_name

total_revenue

rank_in_category

✅ Expected Answer (SQL Solution)
*/
WITH product_revenue AS (
    SELECT
        p.category,
        p.product_name,
        SUM(s.quantity * s.price) AS total_revenue
    FROM products p
    JOIN sales s ON p.product_id = s.product_id
    GROUP BY p.category, p.product_name
),
ranked AS (
    SELECT
        category,
        product_name,
        total_revenue,
        RANK() OVER (PARTITION BY category ORDER BY total_revenue DESC) AS rank_in_category
    FROM product_revenue
)
SELECT
    category,
    product_name,
    total_revenue,
    rank_in_category
FROM ranked
WHERE rank_in_category <= 3
ORDER BY category, rank_in_category;