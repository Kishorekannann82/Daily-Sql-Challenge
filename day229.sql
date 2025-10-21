/*
🧩 Challenge #7: Find the Most Recent Order per Customer Before a Given Date

Scenario:
You’re asked to find, for each customer, the most recent order before a given cutoff date (say '2024-03-01').

You have this table:

orders

order_id	customer_id	order_date	amount
1	101	2024-01-10	100
2	102	2024-01-15	200
3	101	2024-02-01	150
4	103	2024-02-10	300
5	101	2024-03-05	120
6	102	2024-03-20	180
7	103	2024-03-25	250
❓Question:

Write a SQL query to find each customer’s most recent order (order_id and date) that occurred before '2024-03-01'.

Return:

customer_id

order_id

order_date

amount

✅ Expected Answer (SQL Solution)
*/

WITH ranked_orders AS (
    SELECT
        customer_id,
        order_id,
        order_date,
        amount,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY order_date DESC
        ) AS rn
    FROM orders
    WHERE order_date < '2024-03-01'
)
SELECT
    customer_id,
    order_id,
    order_date,
    amount
FROM ranked_orders
WHERE rn = 1
ORDER BY customer_id;