/*
Top 2 Products by Monthly Revenue

Scenario:
You have a table of e-commerce transactions:

sales

sale_id	product_id	sale_date	quantity	price
1	101	2024-01-05	3	100
2	102	2024-01-08	2	200
3	103	2024-01-12	1	300
4	101	2024-02-03	5	100
5	102	2024-02-07	2	200
6	103	2024-02-11	3	300
7	101	2024-03-04	4	100
8	102	2024-03-05	5	200
9	103	2024-03-08	2	300
❓Question:

Find the top 2 products (by revenue) in each month.
Return:

month (YYYY-MM)

product_id

total_revenue

rank_in_month

✅ Expected Answer (SQL Solution)
*/

WITH monthly_revenue AS (
    SELECT
        DATE_FORMAT(sale_date, '%Y-%m') AS month,
        product_id,
        SUM(quantity * price) AS total_revenue
    FROM sales
    GROUP BY DATE_FORMAT(sale_date, '%Y-%m'), product_id
),
ranked AS (
    SELECT
        month,
        product_id,
        total_revenue,
        RANK() OVER (PARTITION BY month ORDER BY total_revenue DESC) AS rank_in_month
    FROM monthly_revenue
)
SELECT
    month,
    product_id,
    total_revenue,
    rank_in_month
FROM ranked
WHERE rank_in_month <= 2
ORDER BY month, rank_in_month;