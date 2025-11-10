/*
Identify When a Customer Returned After a Break

Scenario:
You have a purchase history table:

purchases

customer_id	purchase_date
101	2024-01-05
101	2024-01-10
101	2024-03-01
102	2024-01-15
102	2024-02-01
102	2024-06-15
103	2024-03-05
103	2024-03-06

A return-after-break is defined as:

The gap between two purchases is more than 30 days.

❓Question:

For each customer, identify the purchase where they returned after a break (gap > 30 days).

Return:

customer_id

purchase_date

previous_purchase_date

days_gap

return_after_break (YES/NO)

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
    ) AS days_gap,
    CASE
        WHEN DATEDIFF(
            purchase_date,
            LAG(purchase_date) OVER (
                PARTITION BY customer_id
                ORDER BY purchase_date
            )
        ) > 30 THEN 'YES'
        ELSE 'NO'
    END AS return_after_break
FROM purchases
ORDER BY customer_id, purchase_date;