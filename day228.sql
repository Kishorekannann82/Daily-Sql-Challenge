/*
Customer Purchase Retention Analysis

Scenario:
You work for an e-commerce platform. You have a table called orders:

order_id	customer_id	order_date	amount
1	101	2024-01-10	100
2	102	2024-01-15	200
3	101	2024-02-01	150
4	103	2024-02-10	300
5	101	2024-03-05	120
6	102	2024-03-20	180
7	103	2024-03-25	250
8	104	2024-03-28	400
❓Question:

Write a SQL query to calculate month-by-month customer retention rate —
i.e., the percentage of customers who made a purchase in a given month and had also made a purchase in the previous month.

Return:

month (YYYY-MM)

total_customers

retained_customers

retention_rate (%)

✅ Expected Answer (SQL Solution)
*/
WITH monthly_customers AS (
    SELECT
        DATE_FORMAT(order_date, '%Y-%m') AS month,
        customer_id
    FROM orders
    GROUP BY DATE_FORMAT(order_date, '%Y-%m'), customer_id
),
retention AS (
    SELECT
        curr.month AS month,
        COUNT(DISTINCT curr.customer_id) AS total_customers,
        COUNT(DISTINCT CASE WHEN prev.customer_id IS NOT NULL THEN curr.customer_id END) AS retained_customers
    FROM monthly_customers curr
    LEFT JOIN monthly_customers prev
        ON curr.customer_id = prev.customer_id
        AND DATE_FORMAT(DATE_ADD(CONCAT(prev.month, '-01'), INTERVAL 1 MONTH), '%Y-%m') = curr.month
    GROUP BY curr.month
)
SELECT
    month,
    total_customers,
    retained_customers,
    ROUND(
        CASE 
            WHEN total_customers = 0 THEN 0
            ELSE (retained_customers * 100.0 / total_customers)
        END, 2
    ) AS retention_rate
FROM retention
ORDER BY month;