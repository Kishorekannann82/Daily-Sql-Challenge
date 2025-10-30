/*
🧩 Challenge #15: Find Days Between Consecutive Purchases per Customer

Scenario:
You have a table purchases that logs every customer’s purchase activity:

purchase_id	customer_id	purchase_date
1	101	2024-01-05
2	101	2024-01-20
3	101	2024-02-02
4	102	2024-01-10
5	102	2024-03-05
6	103	2024-02-15
7	103	2024-02-28
8	103	2024-03-10
❓Question:

For each customer, find the number of days between each consecutive purchase.

Return:

customer_id

purchase_date

previous_purchase_date

days_since_last_purchase

✅ Expected Answer (SQL Solution)
*/
SELECT
    customer_id,
    purchase_date,
    LAG(purchase_date) OVER (
        PARTITION BY customer_id 
        ORDER BY purchase_date
    ) AS previous_purchase_date,
    DATEDIFF(
        purchase_date,
        LAG(purchase_date) OVER (
            PARTITION BY customer_id 
            ORDER BY purchase_date
        )
    ) AS days_since_last_purchase
FROM purchases
ORDER BY customer_id, purchase_date;