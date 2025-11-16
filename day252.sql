/*
Find Customers Whose Latest Order Was Above the Monthly Average
Scenario:

You have two tables:

customers
customer_id	customer_name
1	Alice
2	Bob
3	Carol
4	David
orders
order_id	customer_id	order_date	amount
101	1	2024-01-05	200
102	1	2024-02-10	400
103	2	2024-01-11	150
104	2	2024-01-25	180
105	2	2024-03-01	600
106	3	2024-02-15	300
107	4	2024-03-20	500
108	4	2024-03-25	220
❓Question:

For each customer:

Find their most recent order

Compare that order’s amount to the average order amount of that month

Return only customers whose latest order is above that month’s average

Return:

customer_name

last_order_date

last_order_amount

monthly_avg

above_avg_flag

✅ Expected Answer (SQL Solution)
*/

WITH customer_last_order AS (
    SELECT
        o.customer_id,
        o.order_date,
        o.amount,
        ROW_NUMBER() OVER (
            PARTITION BY o.customer_id
            ORDER BY o.order_date DESC
        ) AS rn
    FROM orders o
),
monthly_avg AS (
    SELECT
        DATE_FORMAT(order_date, '%Y-%m') AS month,
        AVG(amount) AS avg_amount
    FROM orders
    GROUP BY DATE_FORMAT(order_date, '%Y-%m')
)
SELECT
    c.customer_name,
    clo.order_date AS last_order_date,
    clo.amount AS last_order_amount,
    ma.avg_amount AS monthly_avg,
    CASE
        WHEN clo.amount > ma.avg_amount THEN 'YES'
        ELSE 'NO'
    END AS above_avg_flag
FROM customer_last_order clo
JOIN customers c ON c.customer_id = clo.customer_id
JOIN monthly_avg ma 
    ON ma.month = DATE_FORMAT(clo.order_date, '%Y-%m')
WHERE clo.rn = 1 AND clo.amount > ma.avg_amount
ORDER BY clo.order_date DESC;